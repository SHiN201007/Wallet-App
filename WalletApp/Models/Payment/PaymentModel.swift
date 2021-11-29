//
//  PaymentModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation
import Firebase
import Ballcap
import Hydra

class PaymentModel {
    
    struct PaymentData {
        var price: Int
        var type: WalletType
    }
    
    func sendPayment(data: PaymentData) -> Promise<Void> {
        let userModel = UserModel()
        return Promise<Void>(in: .main) { resolve, reject, _ in
            guard let uid: String = Auth.auth().currentUser?.uid else {
                reject(FirebaseError.unAuthError)
                return
            }
            userModel.getMainRoomID().then { mainRoomID in
                let paymentRef = FirebaseConstants.rooms
                    .subCollections(parentDocument: mainRoomID, subCollection: .payments)
                let payment: Document<Payments.payments> = Document(collectionReference: paymentRef)
                
                payment.data = Payments.payments(
                    paymentType: data.type.typeName,
                    price: data.price,
                    senderID: uid
                )
                
                payment.save { error in
                    if let saveError = error {
                        print(saveError)
                        reject(FirebaseError.unSaveError)
                        return
                    }
                    // completion
                    resolve(())
                }
            }
        }
    }
    
}
