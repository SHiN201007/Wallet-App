//
//  WalletViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import KRProgressHUD

class WalletViewController: BaseViewController {
    
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var walletCornerTopView: UIView!
    @IBOutlet weak var walletCornerBottomView: UIView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceSlideView: UIView!
    @IBOutlet weak var balanceRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    private var viewModel: WalletViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionWallet>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionWallet>.ConfigureCell = { [weak self] (dataSouce, tableView, indexPath, item) in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomViewPath.wallet.cell, for: indexPath) as! WalletTableViewCell
        
        // layout
        if let width = self?.view.bounds.width {
            cell.configView(width: width - 40, type: item.walletType)
            cell.configType(amount: item.amount, type: item.walletType)
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configViewModel()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadBalanceData().catch { error in
            KRProgressHUD.showError(withMessage: error.showErrorDescription())
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configView()
    }
    
    private func configView() {
        title = L10n.titleWallet
        walletView.do { view in
            view.configGradientColor(width: self.view.bounds.width - 40, height: view.bounds.height, colors: .all)
            view.configShadow()
            view.layer.cornerRadius = 10.0
        }
        walletCornerTopView.configCornerRadius(position: .top, value: 50)
        walletCornerBottomView.configCornerRadius(position: .bottom, value: 50)
        balanceView.configShadow()
        balanceView.layer.cornerRadius = 10.0
        balanceView.backgroundColor = WalletType.all.typeColor.bottom
        balanceSlideView.layer.cornerRadius = 10.0
    }
    
    private func configTableView() {
        let nib = UINib(nibName: CustomViewPath.wallet.view, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: CustomViewPath.wallet.cell)
        tableView.tableFooterView = UIView(frame: .zero) // 空白cellの線　削除
        tableView.separatorStyle = .none
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.refreshControl = refreshControl
    }
    
    private func configViewModel() {
        viewModel = WalletViewModel()
    }
    
    private func bind() {
        // balance
        viewModel.output().balance
            .map { "¥\($0.numberForComma())" }
            .bind(to: balanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        // wallet items
        viewModel.output().walletItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: Binder(self) { me, indexPath in
                me.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: Binder(self) { me, _ in
                me.viewModel.reloadBalanceData().then { _ in
                    me.refreshControl.endRefreshing()
                }.catch { error in
                    KRProgressHUD.showError(withMessage: error.showErrorDescription())
                }
            })
            .disposed(by: disposeBag)
    }
    
}

extension WalletViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
