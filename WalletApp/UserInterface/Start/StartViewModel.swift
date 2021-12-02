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
        var promotionButtonTapped: Observable<Void>
    }
    
    struct Output {
        var isNextPage: Observable<Bool>
        var showSharePage: Observable<Bool>
    }
    
    // parameter
    private var _input: Input!
    private var _output: Output!
    
    private let isNextPageSubject = PublishSubject<Bool>()
    private let isShowSharePageSubject = PublishSubject<Bool>()
    
    init(trigger: Input) {
        _input = trigger
        _output = Output(
            isNextPage: isNextPageSubject.asObservable(),
            showSharePage: isShowSharePageSubject.asObservable()
        )
        
        bind()
    }
    
    private func bind() {
        _input.startButtonTapped
            .bind(to: Binder(self) { me, _ in
                KRProgressHUD.show(withMessage: "アカウント作成中...")
                me.createUser().then { flag in
                    KRProgressHUD.dismiss()
                    me.isNextPageSubject.onNext(true)
                }.catch { error in
                    KRProgressHUD.showError(withMessage: error.showErrorDescription())
                }
            })
            .disposed(by: disposeBag)
        
        _input.promotionButtonTapped
            .bind(to: Binder(self) { me, _ in
                KRProgressHUD.show(withMessage: "アカウント作成中...")
                me.createUser().then { flag in
                    KRProgressHUD.dismiss()
                    me.isShowSharePageSubject.onNext(true)
                }.catch { error in
                    KRProgressHUD.showError(withMessage: error.showErrorDescription())
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func createUser() -> Promise<Bool> {
        return Promise<Bool>(in: .main) { [weak self] resolve, reject, _ in
            self?.userModel.signIn().then { succsess in
                resolve(true)
            }.catch { error in
                reject(error)
            }
        }
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
