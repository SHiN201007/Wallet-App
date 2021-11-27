//
//  CustomViewUtil.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import Foundation

enum CustomViewPath {
    case wallet
    case member
    
    var view: String {
        switch self {
        case .wallet:
            return "WalletTableViewCell"
        case .member:
            return "MemberTableViewCell"
        }
    }
    
    var cell: String {
        switch self {
        case .wallet:
            return "WalletCell"
        case .member:
            return "MemberCell"
        }
    }
}
