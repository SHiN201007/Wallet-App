//
//  FirebaseModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation
import Firebase
import Ballcap

class Users: Object {
    
    var data: users?
    
    struct users: Modelable & Codable {
        var userName: String = "ユーザー"
        var gender: String?
    }
    
}

class Rooms: Object, DataRepresentable & HierarchicalStructurable {
    
    var data: rooms?
    // SubCollection
    var members: [Members] = []
    var payments: [Payments] = []
    
    struct rooms: Modelable & Codable {
        var foodUpper: Int = 0
        var lifeUpper: Int = 0
        var entertainmentUpper: Int = 0
        var studyUpper: Int = 0
        var trainUpper: Int = 0
        var otherUpper: Int = 0
    }
    
    enum CollectionKeys: String {
        case members
        case payments
    }
}

class Members: Object {

    var data: members?
    
    struct members: Modelable & Codable {
        var memberID: String?
    }
}

class Payments: Object {
    
    var data: payments?
    
    struct payments: Modelable & Codable {
        var paymentType: String?
        var price: Int?
        var senderID: String?
    }
}
