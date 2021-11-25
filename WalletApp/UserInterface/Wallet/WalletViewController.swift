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

class WalletViewController: UIViewController {
    
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var walletCornerTopView: UIView!
    @IBOutlet weak var walletCornerBottomView: UIView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceSlideView: UIView!
    @IBOutlet weak var balanceRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: WalletViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionWallet>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionWallet>.ConfigureCell = { [weak self] (dataSouce, tableView, indexPath, item) in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomViewPath.wallet.cell, for: indexPath) as! WalletTableViewCell
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configViewModel()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configView()
    }
    
    private func configView() {
        walletView.do { view in
            view.configGradientColor(width: self.view.bounds.width - 40, height: view.bounds.height)
            view.configShadow()
            view.layer.cornerRadius = 10.0
        }
        walletCornerTopView.configCornerRadius(position: .top, value: 50)
        walletCornerBottomView.configCornerRadius(position: .bottom, value: 50)
        balanceView.configShadow()
        balanceView.layer.cornerRadius = 10.0
        balanceSlideView.layer.cornerRadius = 10.0
    }
    
    private func configTableView() {
        let nib = UINib(nibName: CustomViewPath.wallet.view, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: CustomViewPath.wallet.cell)
        tableView.tableFooterView = UIView(frame: .zero) // 空白cellの線　削除
        tableView.separatorStyle = .none
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func configViewModel() {
        viewModel = WalletViewModel()
        // output
        
        // wallet items
        viewModel.output().walletItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        tableView.rx.itemSelected
            .bind(to: Binder(self) { me, indexPath in
                me.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

extension WalletViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
