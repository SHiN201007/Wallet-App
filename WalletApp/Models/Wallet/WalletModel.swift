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
        let userModel = UserModel()
        let paymentModel = PaymentModel()
        return Promise<[SectionWallet]>(in: .main) { [weak self] resolve, reject, _ in
            userModel.getMainRoomID().then { mainRoomID in
                all(
                    paymentModel.fetchTypeOfPaymentTotal(roomID: mainRoomID, type: .food),
                    paymentModel.fetchTypeOfPaymentTotal(roomID: mainRoomID, type: .life),
                    paymentModel.fetchTypeOfPaymentTotal(roomID: mainRoomID, type: .entertainment),
                    paymentModel.fetchTypeOfPaymentTotal(roomID: mainRoomID, type: .study),
                    paymentModel.fetchTypeOfPaymentTotal(roomID: mainRoomID, type: .train),
                    paymentModel.fetchTypeOfPaymentTotal(roomID: mainRoomID, type: .food)
                ).then { prices in
                    resolve(self?.setupWalletData(prices: prices) ?? [])
                }.catch { error in
                    reject(error)
                }
            }.catch { error in
                reject(error)
            }
        }
    }
    
    // sample data
    private func setupWalletData(prices: [Int]) -> [SectionWallet] {
        return [
            SectionWallet(items: [SectionWallet.Item(amount: prices[0], walletType: .food)]),
            SectionWallet(items: [SectionWallet.Item(amount: prices[1], walletType: .life)]),
            SectionWallet(items: [SectionWallet.Item(amount: prices[2], walletType: .entertainment)]),
            SectionWallet(items: [SectionWallet.Item(amount: prices[3], walletType: .study)]),
            SectionWallet(items: [SectionWallet.Item(amount: prices[4], walletType: .train)]),
            SectionWallet(items: [SectionWallet.Item(amount: prices[5], walletType: .other)])
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
