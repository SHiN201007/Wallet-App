//
//  MypageViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import FFPopup

class MypageViewController: UIViewController {
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var settingCornerTopView: UIView!
    @IBOutlet weak var settingCornerBottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: MypageViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionMember>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionMember>.ConfigureCell = { [weak self] (dataSouce, tableView, indexPath, item) in
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomViewPath.member.cell, for: indexPath) as! MemberTableViewCell
        
        if let userName = item.userName,
           let gender = item.gender {
            cell.iconImageView.image = gender.image
            cell.userNameLabel.text = userName
            cell.configUser()
        }else {
            cell.configAddUser()
        }
        
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
        title = L10n.titleMypage
        navigationItem.backButtonTitle = ""
        settingView.do { view in
            view.configGradientColor(width: self.view.bounds.width - 40, height: view.bounds.height, colors: .setting)
            view.configShadow()
            view.layer.cornerRadius = 10.0
        }
        settingCornerTopView.configCornerRadius(position: .top, value: 50)
        settingCornerBottomView.configCornerRadius(position: .bottom, value: 50)
    }
    
    private func configTableView() {
        let nib = UINib(nibName: CustomViewPath.member.view, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: CustomViewPath.member.cell)
        tableView.tableFooterView = UIView(frame: .zero) // 空白cellの線　削除
        tableView.separatorStyle = .none
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func configViewModel() {
        let input = MypageViewModel.Input()
        viewModel = MypageViewModel(trigger: input)
    }
    
    private func bind() {
        // setting
        settingButton.rx.tap
            .bind(to: Binder(self) { me, _ in
                let settingVC = SettingViewController()
                settingVC.settingTypeRelay.accept(.update)
                me.navigationController?.pushViewController(settingVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // tableView
        viewModel.output().memberItem.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        // selected items
        tableView.rx.itemSelected
            .bind(to: Binder(self) { me, indexPath in
                me.tableView.deselectRow(at: indexPath, animated: true)
                let item = me.viewModel.output().memberItem.value[indexPath.section].items.first
                if item?.userName == nil || item?.gender == nil {
                    print("invitaion")
                    me.showAddMemberView()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showAddMemberView() {
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width - 40, height: 250)
        let addMemberView = AddMemberView(frame: frame)
        
        let popup = FFPopup(contentView: addMemberView)
        popup.do {
            $0.showType = .growIn
            $0.dismissType = .shrinkOut
        }
        let layout = FFPopupLayout(horizontal: .center, vertical: .center)
        popup.show(layout: layout)
    }

}
extension MypageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
}
