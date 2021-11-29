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

class PaymentViewModel {
    
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
        var price: Observable<Int>
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
    private let priceSubject = PublishSubject<Int>()
    private let isSuccsessSubject = PublishSubject<Bool>()
    
    init(trigger: Input) {
        _input = trigger
        _output = Output(
            price: priceSubject.asObservable(),
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
            .bind(to: priceSubject)
            .disposed(by: disposeBag)
        
        _input.doneButtonTapped
            .bind(to: Binder(self) { me, _ in
                
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
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
