//
//  ParticipateRoomModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation
import Firebase
import Ballcap
import Hydra

class ParticipateRoomModel {
    
    // MARK: CRUD
    func addParticipateRoom(roomID: String) -> Promise<Void> {
        return Promise<Void>(in: .main) { resolve, reject, _ in
            guard let uid: String = Auth.auth().currentUser?.uid else {
                reject(FirebaseError.unAuthError)
                return
            }
            let participateRoomRef = FirebaseConstants.users
                .subCollections(parentDocument: uid, subCollection: .participateRooms)
            
            let participateRoom: Document<ParticipateRooms.participateRooms> = Document(collectionReference: participateRoomRef)
            
            participateRoom.data = ParticipateRooms.participateRooms(roomID: roomID)
            
            participateRoom.save { error in
                if let saveError = error {
                    print(saveError)
                    reject(FirebaseError.unSaveError)
                    return
                }
                resolve(())
            }
        }
    }
    
}
