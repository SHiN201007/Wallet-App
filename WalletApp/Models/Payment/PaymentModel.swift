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
    
    
    func getPaymentTotal(roomID id: String) -> Promise<Int> {
        var total = 0
        return Promise<Int>(in: .main) { resolve, reject, _ in
            let paymentRef = FirebaseConstants.rooms
                .subCollections(parentDocument: id, subCollection: .payments)
            paymentRef.getDocuments { snapshot, error in
                if let getPaymentsError = error {
                    print(getPaymentsError)
                    reject(FirebaseError.connotDataError)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    reject(FirebaseError.connotDataError)
                    return
                }
                
                documents.forEach { snap in
                    if let document = Document<Payments.payments>(snapshot: snap),
                       let data = document.data {
                        total += data.price ?? 0
                    }else {
                        reject(FirebaseError.connotDataError)
                        return
                    }
                }
                
                resolve(total)
                return
            }
        }
    }
    
    func fetchTypeOfPaymentTotal(roomID id: String, type: WalletType) -> Promise<Int> {
        var total = 0
        return Promise<Int>(in: .main) { resolve, reject, _ in
            let paymentRef = FirebaseConstants.rooms
                .subCollections(parentDocument: id, subCollection: .payments)
            paymentRef
                .whereField("paymentType", isEqualTo: type.typeName ?? "")
                .getDocuments { snapshot, error in
                    if let getPaymentsError = error {
                        print(getPaymentsError)
                        reject(FirebaseError.connotDataError)
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        reject(FirebaseError.connotDataError)
                        return
                    }
                
                    documents.forEach { snap in
                        if let document = Document<Payments.payments>(snapshot: snap),
                           let data = document.data {
                            total += data.price ?? 0
                        }else {
                            reject(FirebaseError.connotDataError)
                            return
                        }
                    }
                    
                    resolve(total)
                    return
            }
        }
    }
    
}
