//
//  StartViewModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation
import RxSwift
import RxCocoa
import Hydra
import KRProgressHUD

class StartViewModel {
    
    private let userModel = UserModel()
    private let disposeBag = DisposeBag()
    
    struct Input {
        var startButtonTapped: Observable<Void>
    }
    
    struct Output {
        var isNextPage: Observable<Bool>
    }
    
    // parameter
    private var _input: Input!
    private var _output: Output!
    
    private let isNextPageSubject = PublishSubject<Bool>()
    
    init(trigger: Input) {
        _input = trigger
        _output = Output(
            isNextPage: isNextPageSubject.asObservable()
        )
        
        bind()
    }
    
    private func bind() {
        _input.startButtonTapped
            .bind(to: Binder(self) { me, _ in
                me.createUser()
            })
            .disposed(by: disposeBag)
    }
    
    private func createUser() {
        KRProgressHUD.show(withMessage: "アカウント作成中...")
        userModel.signIn().then { [weak self] succsess in
            KRProgressHUD.dismiss()
            self?.isNextPageSubject.onNext(true)
        }.catch { error in
            KRProgressHUD.showError(withMessage: error.showErrorDescription())
        }
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
