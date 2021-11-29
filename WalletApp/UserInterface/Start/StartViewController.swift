//
//  StartViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import UIKit
import RxSwift
import RxCocoa

class StartViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var promotionButton: UIButton!
    
    private var viewModel: StartViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configView()
    }
    
    private func configView() {
        title = "使い方"
        startButton.layer.cornerRadius = 10.0
        startButton.configGradientColor(width: self.view.bounds.width - 128, height: 60, colors: .all)
        startButton.configShadow()
    }
    
    private func configViewModel() {
        let input = StartViewModel.Input(
            startButtonTapped: startButton.rx.tap.asObservable()
        )
        viewModel = StartViewModel(trigger: input)
    }
    
    private func bind() {
        // promotion
        promotionButton.rx.tap
            .bind(to: Binder(self) { me, _ in
                
            })
            .disposed(by: disposeBag)
        
        // output
        viewModel.output().isNextPage
            .filter { $0 == true }
            .bind(to: Binder(self) { me, _ in
                let settingVC = SettingViewController()
                settingVC.settingTypeRelay.accept(.regist)
                me.navigationController?.pushViewController(settingVC, animated: true)
            })
            .disposed(by: disposeBag)
    }

}
