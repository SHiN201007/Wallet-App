//
//  WalletModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import Foundation
import Hydra

class WalletModel {
    
    enum WalletError: Error {
        case unknowError
    }
    
    func fetchWalletData() -> Promise<[SectionWallet]> {
        return Promise<[SectionWallet]>(in: .main) { [weak self] resolve, reject, _ in
            if let items = self?.sampleWalletData() {
                resolve(items)
                return
            }else {
                reject(WalletError.unknowError)
                return
            }
        }
    }
    
    // sample data
    private func sampleWalletData() -> [SectionWallet] {
        return [
            SectionWallet(items: [SectionWallet.Item(walletType: .food)])
        ]
    }
}
