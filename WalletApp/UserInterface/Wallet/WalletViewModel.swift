//
//  WalletViewModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import Foundation
import Hydra
import RxSwift
import RxCocoa
import RxDataSources

class WalletViewModel {
    
    private let model = WalletModel()
    private let disposeBag = DisposeBag()
    
//    struct Input {
//
//    }
    
    struct Output {
        var balance: Observable<Int>
        var walletItems: Observable<[SectionWallet]>
    }
    
//    private var _input: WalletViewModel.Input!
    private var _output: WalletViewModel.Output!
    
    // parameter
    private let balanceRelay = BehaviorRelay<Int>(value: 0)
    private let walletItemsRelay = BehaviorRelay<[SectionWallet]>(value: [])
    
    init() {
        _output = Output(
            balance: balanceRelay.asObservable(),
            walletItems: walletItemsRelay.asObservable()
        )
        
        // configure
        fetchWalletBalance()
        fetchWalletItems()
    }
    
    private func fetchWalletBalance() {
        model.fetchBalance().then { [weak self] balance in
            self?.balanceRelay.accept(balance)
        }.catch { error in
            print(error.showErrorDescription())
        }
    }
    
    private func fetchWalletItems() {
        model.fetchWalletData().then { [weak self] items in
            self?.walletItemsRelay.accept(items)
        }.catch { error in
            print("fetch wallet error", error)
        }
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
    func reloadBalanceData() {
        fetchWalletBalance()
    }
    
}
