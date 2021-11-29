//
//  PaymentViewModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/26.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import KRProgressHUD

class PaymentViewModel {
    
    private let model = PaymentModel()
    private let disposeBag = DisposeBag()
    
    struct Input {
        var priceText: Observable<String>
        var foodButtonTapped: Observable<Void>
        var lifeButtonTapped: Observable<Void>
        var entertainmentButtonTapped: Observable<Void>
        var trainButtonTapped: Observable<Void>
        var studyButtonTapped: Observable<Void>
        var otherButtonTapped: Observable<Void>
        var doneButtonTapped: Observable<Void>
    }
    
    struct Output {
        var price: Observable<Int?>
        var typeImage: Observable<UIImage>
        var typeName: Observable<String>
        var walletType: Observable<WalletType>
        var isSuccsess: Observable<Bool>
    }
    
    // parameter
    private var _input: Input!
    private var _output: Output!
    
    private let typeImageRelay = BehaviorRelay<UIImage?>(value: WalletType.food.image)
    private let typeNameRelay = BehaviorRelay<String?>(value: WalletType.food.typeName)
    private let walletTypeRelay = BehaviorRelay<WalletType>(value: .food)
    private let priceRelay = BehaviorRelay<Int?>(value: nil)
    private let isSuccsessSubject = PublishSubject<Bool>()
    
    init(trigger: Input) {
        _input = trigger
        _output = Output(
            price: priceRelay.asObservable(),
            typeImage: typeImageRelay.unwrap().asObservable(),
            typeName: typeNameRelay.unwrap().asObservable(),
            walletType: walletTypeRelay.asObservable(),
            isSuccsess: isSuccsessSubject.asObservable()
        )
        
        bind()
    }
    
    private func bind() {
        _input.priceText
            .map { $0.convertPrice() }
            .unwrap()
            .bind(to: priceRelay)
            .disposed(by: disposeBag)
        
        _input.doneButtonTapped
            .bind(to: Binder(self) { me, _ in
                me.sendPaymentData()
            })
            .disposed(by: disposeBag)
        
        // toggle wallet type
        _input.foodButtonTapped
            .map { WalletType.food }
            .bind(to: walletTypeRelay)
            .disposed(by: disposeBag)
        
        _input.lifeButtonTapped
            .map { WalletType.life }
            .bind(to: walletTypeRelay)
            .disposed(by: disposeBag)
        
        _input.entertainmentButtonTapped
            .map { WalletType.entertainment }
            .bind(to: walletTypeRelay)
            .disposed(by: disposeBag)
        
        _input.trainButtonTapped
            .map { WalletType.train }
            .bind(to: walletTypeRelay)
            .disposed(by: disposeBag)
        
        _input.studyButtonTapped
            .map { WalletType.study }
            .bind(to: walletTypeRelay)
            .disposed(by: disposeBag)
        
        _input.otherButtonTapped
            .map { WalletType.other }
            .bind(to: walletTypeRelay)
            .disposed(by: disposeBag)
        
        // toggle
        walletTypeRelay.asObservable()
            .bind(to: Binder(self) { me, type in
                me.typeImageRelay.accept(type.image)
                me.typeNameRelay.accept(type.typeName)
            })
            .disposed(by: disposeBag)
    }

    private func sendPaymentData() {
        let price = priceRelay.value ?? 0
        
        if price > 0 {
            let data = PaymentModel.PaymentData(
                price: priceRelay.value ?? 0,
                type: walletTypeRelay.value
            )
            
            KRProgressHUD.show(withMessage: "送信中...")
            model.sendPayment(data: data).then { [weak self] _ in
                KRProgressHUD.showMessage("送信完了💰")
                self?.isSuccsessSubject.onNext(true)
            }.catch { error in
                KRProgressHUD.showError(withMessage: error.showErrorDescription())
            }
        }else {
            KRProgressHUD.showError(withMessage: "金額を入力してください。")
        }
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
