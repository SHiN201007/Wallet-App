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
    }
    
    private func fetchWalletBalance() -> Promise<Void> {
        return Promise<Void>(in: .main) { [weak self] resolve, reject, _ in
            self?.model.fetchBalance().then { balance in
                self?.balanceRelay.accept(balance)
                resolve(())
            }.catch { error in
                print(error.showErrorDescription())
                reject(error)
            }
        }
    }
    
    private func fetchWalletItems() -> Promise<Void> {
        return Promise<Void>(in: .main) { [weak self] resolve, reject, _ in
            self?.model.fetchWalletData().then { items in
                self?.walletItemsRelay.accept(items)
                resolve(())
            }.catch { error in
                print("fetch wallet error", error)
                reject(error)
            }
        }
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
    func reloadBalanceData() -> Promise<Void> {
        return Promise<Void>(in: .main) { resolve, reject, _ in
            all(self.fetchWalletBalance(), self.fetchWalletItems()).then { _ in
                resolve(())
            }.catch { error in
                reject(error)
            }
        }
    }
    
}
