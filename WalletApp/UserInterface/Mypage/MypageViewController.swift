//
//  MypageViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class MypageViewController: UIViewController {
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var settingCornerTopView: UIView!
    @IBOutlet weak var settingCornerBottomView: UIView!
    
    private var viewModel: MypageViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func bind() {
        settingButton.rx.tap
            .bind(to: Binder(self) { me, _ in
                me.navigationController?.pushViewController(SettingViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }

}
