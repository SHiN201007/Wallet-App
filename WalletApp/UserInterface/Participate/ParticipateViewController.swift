//
//  ParticipateViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/12/02.
//

import UIKit
import RxSwift
import RxCocoa

class ParticipateViewController: UIViewController {
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var shareTextField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    
    private var viewModel: ParticipateViewModel!
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
        title = L10n.titleParticipate
        shareView.configShadow()
        joinButton.layer.cornerRadius = 10.0
        joinButton.configGradientColor(width: self.view.bounds.width - 128, height: 60, colors: .setting)
        joinButton.configShadow()
    }
    
    private func configViewModel() {
        let input = ParticipateViewModel.Input(
            inviteCode: shareTextField.rx.text.orEmpty.asObservable(),
            joinButtonTapped: joinButton.rx.tap.asObservable()
        )
        viewModel = ParticipateViewModel(trigger: input)
    }
    
    private func bind() {
        viewModel.output().isSuccsess
            .bind(to: Binder(self) { me, _ in
                me.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
}
