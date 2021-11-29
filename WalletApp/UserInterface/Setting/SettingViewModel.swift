//
//  SettingViewModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/28.
//

import Foundation
import RxSwift
import RxCocoa
import Hydra
import KRProgressHUD

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
        var foodPrice: Observable<Int?>
        var lifePrice: Observable<Int?>
        var entertainmentPrice: Observable<Int?>
        var studyPrice: Observable<Int?>
        var trainPrice: Observable<Int?>
        var otherPrice: Observable<Int?>
        var isNextPage: Observable<SettingViewController.SettingType>
    }
    
    // parameter
    private var _input: Input!
    private var _output: Output!
    
    private let foodPriceRelay = BehaviorRelay<Int?>(value: nil)
    private let lifePriceRelay = BehaviorRelay<Int?>(value: nil)
    private let entertainmentPriceRelay = BehaviorRelay<Int?>(value: nil)
    private let studyPriceRelay = BehaviorRelay<Int?>(value: nil)
    private let trainPriceRelay = BehaviorRelay<Int?>(value: nil)
    private let otherPriceRelay = BehaviorRelay<Int?>(value: nil)
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
        
        configSettingItem()
        bind()
    }
    
    private func configSettingItem() {
        model.fetchSettingData().then { [weak self] item in
            self?.foodPriceRelay.accept(item.foodPrice)
            self?.lifePriceRelay.accept(item.lifePrice)
            self?.entertainmentPriceRelay.accept(item.entertainmentPrice)
            self?.studyPriceRelay.accept(item.studyPrice)
            self?.trainPriceRelay.accept(item.trainPrice)
            self?.otherPriceRelay.accept(item.otherPrice)
        }.catch { error in
            KRProgressHUD.showError(withMessage: error.showErrorDescription())
        }
    }
    
    private func bind() {
        _input.foodText
            .map { $0.convertPrice() }
            .unwrap()
            .bind(to: foodPriceRelay)
            .disposed(by: disposeBag)
        
        _input.lifeText
            .map { $0.convertPrice() }
            .unwrap()
            .bind(to: lifePriceRelay)
            .disposed(by: disposeBag)
        
        _input.entertainmentText
            .map { $0.convertPrice() }
            .unwrap()
            .bind(to: entertainmentPriceRelay)
            .disposed(by: disposeBag)
        
        _input.studyText
            .map { $0.convertPrice() }
            .unwrap()
            .bind(to: studyPriceRelay)
            .disposed(by: disposeBag)
        
        _input.trainText
            .map { $0.convertPrice() }
            .unwrap()
            .bind(to: trainPriceRelay)
            .disposed(by: disposeBag)
        
        _input.otherText
            .map { $0.convertPrice() }
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
    
    private func configUpperItem() -> SettingModel.UpperItem {
        return SettingModel.UpperItem(
            foodPrice: foodPriceRelay.value ?? 0,
            lifePrice: lifePriceRelay.value ?? 0,
            entertainmentPrice: entertainmentPriceRelay.value ?? 0,
            studyPrice: studyPriceRelay.value ?? 0,
            trainPrice: trainPriceRelay.value ?? 0,
            otherPrice: otherPriceRelay.value ?? 0
        )
    }
    
    private func registSetting() {
        KRProgressHUD.show(withMessage: "設定を登録中...")
        model.registSetting(
            upperItem: configUpperItem()
        ).then { [weak self] _ in
            KRProgressHUD.dismiss()
            self?.isNextPageSubject.onNext(.regist)
        }.catch { error in
            print(error.localizedDescription)
            KRProgressHUD.showError(withMessage: error.showErrorDescription())
        }
    }
    
    private func updateSetting() {
        KRProgressHUD.show(withMessage: "設定を更新中...")
        model.updateSetting(
            upperItem: configUpperItem()
        ).then { [weak self] _ in
            KRProgressHUD.showMessage("限度額を更新しました🎉")
            self?.isNextPageSubject.onNext(.update)
        }.catch { error in
            print(error.localizedDescription)
            KRProgressHUD.showError(withMessage: error.showErrorDescription())
        }
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
