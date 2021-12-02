//
//  TabbarUtil.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import Foundation
import UIKit

enum TabbarUtil {
    case wallet
    case payment
    case mypage
    
    var vc: UIViewController {
        switch self {
        case .wallet:
            return WalletViewController()
        case .payment:
            return PaymentViewController()
        case .mypage:
            return MypageViewController()
        }
    }
    
    var title: String {
        switch self {
        case .wallet:
            return L10n.titleWallet
        case .payment:
            return L10n.titlePayment
        case .mypage:
            return L10n.titleMypage
        }
    }
    
    var image: UIImage {
        switch self {
        case .wallet:
            return Asset.Images.wallet.image
        case .payment:
            return Asset.Images.payment.image
        case .mypage:
            return Asset.Images.mypage.image
        }
    }
    
    var tag: Int {
        switch self {
        case .wallet:
            return 0
        case .payment:
            return 1
        case .mypage:
            return 2
        }
    }
}
