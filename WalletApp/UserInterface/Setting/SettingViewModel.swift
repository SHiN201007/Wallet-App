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
    
    private let model = SettingModel()
    private let disposeBag = DisposeBag()
    
    struct Input {
        var settingType: BehaviorRelay<SettingViewController.SettingType>
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
        var isNextPage: Observable<SettingViewController.SettingType>
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
    private let isNextPageSubject = PublishSubject<SettingViewController.SettingType>()
    
    init(trigger: Input) {
        _input = trigger
        _output = Output(
            foodPrice: foodPriceRelay.asObservable(),
            lifePrice: lifePriceRelay.asObservable(),
            entertainmentPrice: entertainmentPriceRelay.asObservable(),
            studyPrice: studyPriceRelay.asObservable(),
            trainPrice: trainPriceRelay.asObservable(),
            otherPrice: otherPriceRelay.asObservable(),
            isNextPage: isNextPageSubject.asObservable()
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
            .map { self._input.settingType.value }
            .bind(to: Binder(self) { me, type in
                type == .regist ? me.registSetting() : me.updateSetting()
            })
            .disposed(by: disposeBag)
    }
    
    private func convertPrice(priceText: String) -> Int? {
        let index = priceText.count <= 0 ? priceText.count : priceText.count - 1
        let price = priceText.suffix(index)
        return Int(price)
    }
    
    private func configUpperItem() -> SettingModel.UpperItem {
        return SettingModel.UpperItem(
            foodPrice: foodPriceRelay.value,
            lifePrice: lifePriceRelay.value,
            entertainmentPrice: entertainmentPriceRelay.value,
            studyPrice: studyPriceRelay.value,
            trainPrice: trainPriceRelay.value,
            otherPrice: otherPriceRelay.value
        )
    }
    
    private func registSetting() {
        
        model.registSetting(
            upperItem: configUpperItem()
        ).then { [weak self] _ in
            
            self?.isNextPageSubject.onNext(.regist)
        }.catch { error in
            print(error.localizedDescription)
            
        }
    }
    
    private func updateSetting() {
        
        model.updateSetting(
            upperItem: configUpperItem()
        ).then { [weak self] _ in
            
            self?.isNextPageSubject.onNext(.update)
        }.catch { error in
            print(error.localizedDescription)
            
        }
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
