//
//  FirebaseConstants.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation
import Ballcap
import Firebase

let db = Firestore.firestore()

enum FirebaseConstants {
    case users
    case rooms
    
    var ref: CollectionReference {
        switch self {
        case .users:
            return db.collection(FirebaseCollections.Users.rawValue)
        case .rooms:
            return db.collection(FirebaseCollections.Rooms.rawValue)
        }
    }
    
    func document(id: String) -> DocumentReference {
        self.ref.document(id)
    }
    
    func subCollections(parentDocument: String, subCollection: SubCollections) -> CollectionReference {
        self.document(id: parentDocument).collection(subCollection.rawValue)
    }
    
    // MARK: - - Sub Collections
    enum SubCollections: String {
        case members
        case payments
    }
}
