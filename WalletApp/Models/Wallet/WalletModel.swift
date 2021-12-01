//
//  WalletModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import Foundation
import Firebase
import Ballcap
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
            SectionWallet(items: [SectionWallet.Item(walletType: .food)]),
            SectionWallet(items: [SectionWallet.Item(walletType: .life)]),
            SectionWallet(items: [SectionWallet.Item(walletType: .entertainment)]),
            SectionWallet(items: [SectionWallet.Item(walletType: .study)]),
            SectionWallet(items: [SectionWallet.Item(walletType: .train)]),
            SectionWallet(items: [SectionWallet.Item(walletType: .other)])
        ]
    }
    
    // MARK: Balance
    func fetchBalance() -> Promise<Int> {
        let userModel = UserModel()
        let roomModel = RoomModel()
        let paymentModel = PaymentModel()
        return Promise<Int>(in: .main) { resolve, reject, _ in
            userModel.getMainRoomID().then { mainRoomID in
                all(
                    roomModel.getTotalPrice(roomID: mainRoomID),
                    paymentModel.getPaymentTotal(roomID: mainRoomID)
                ).then { results in
                    let balance = results[0] - results[1]
                    resolve(balance)
                }.catch { error in
                    reject(error)
                }
            }.catch { error in
                reject(error)
            }
        }
    }
}
