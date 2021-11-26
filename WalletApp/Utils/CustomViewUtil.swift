//
//  CustomViewUtil.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import Foundation

enum CustomViewPath {
    case wallet
    
    var view: String {
        switch self {
        case .wallet:
            return "WalletTableViewCell"
        }
    }
    
    var cell: String {
        switch self {
        case .wallet:
            return "WalletCell"
        }
    }
}
