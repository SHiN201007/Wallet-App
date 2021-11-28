//
//  SettingViewModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/28.
//

import Foundation
import RxSwift
import RxCocoa

class SettingViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        var foodText: Observable<String>
        var lifeText: Observable<String>
        var entertainmentText: Observable<String>
        var studyText: Observable<String>
        var trainText: Observable<String>
        var otherText: Observable<String>
        var doneButtonTapped: Observable<Void>
    }

    struct Output {
        var foodPrice: Observable<Int>
        var lifePrice: Observable<Int>
        var entertainmentPrice: Observable<Int>
        var studyPrice: Observable<Int>
        var trainPrice: Observable<Int>
        var otherPrice: Observable<Int>
    }
    
    // parameter
    private var _input: Input!
    private var _output: Output!
    
    private let foodPriceRelay = BehaviorRelay<Int>(value: 0)
    private let lifePriceRelay = BehaviorRelay<Int>(value: 0)
    private let entertainmentPriceRelay = BehaviorRelay<Int>(value: 0)
    private let studyPriceRelay = BehaviorRelay<Int>(value: 0)
    private let trainPriceRelay = BehaviorRelay<Int>(value: 0)
    private let otherPriceRelay = BehaviorRelay<Int>(value: 0)
    
    init(trigger: Input) {
        _input = trigger
        _output = Output(
            foodPrice: foodPriceRelay.asObservable(),
            lifePrice: lifePriceRelay.asObservable(),
            entertainmentPrice: entertainmentPriceRelay.asObservable(),
            studyPrice: studyPriceRelay.asObservable(),
            trainPrice: trainPriceRelay.asObservable(),
            otherPrice: otherPriceRelay.asObservable()
        )
        
        bind()
    }
    
    private func bind() {
        _input.foodText
            .map { self.convertPrice(priceText: $0) }
            .unwrap()
            .bind(to: foodPriceRelay)
            .disposed(by: disposeBag)
        
        _input.lifeText
            .map { self.convertPrice(priceText: $0) }
            .unwrap()
            .bind(to: lifePriceRelay)
            .disposed(by: disposeBag)
        
        _input.entertainmentText
            .map { self.convertPrice(priceText: $0) }
            .unwrap()
            .bind(to: entertainmentPriceRelay)
            .disposed(by: disposeBag)
        
        _input.studyText
            .map { self.convertPrice(priceText: $0) }
            .unwrap()
            .bind(to: studyPriceRelay)
            .disposed(by: disposeBag)
        
        _input.trainText
            .map { self.convertPrice(priceText: $0) }
            .unwrap()
            .bind(to: trainPriceRelay)
            .disposed(by: disposeBag)
        
        _input.otherText
            .map { self.convertPrice(priceText: $0) }
            .unwrap()
            .bind(to: otherPriceRelay)
            .disposed(by: disposeBag)
        
        _input.doneButtonTapped
            .bind(to: Binder(self) { me, _ in
                print("food", me.foodPriceRelay.value)
            })
            .disposed(by: disposeBag)
    }
    
    private func convertPrice(priceText: String) -> Int? {
        let index = priceText.count <= 0 ? priceText.count : priceText.count - 1
        let price = priceText.suffix(index)
        return Int(price)
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
