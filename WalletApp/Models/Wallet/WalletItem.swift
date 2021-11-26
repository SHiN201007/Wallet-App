//
//  WalletItem.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import Foundation
import UIKit
import RxDataSources

enum WalletType {
    case all
    case food
    case life
    case entertainment
    case study
    case train
    case other
    
    struct GradientColors {
        var top: UIColor
        var bottom: UIColor
    }
    
    var image: UIImage? {
        switch self {
        case .all:
            return nil
        case .food:
            return Asset.Images.food.image
        case .life:
            return Asset.Images.life.image
        case .entertainment:
            return Asset.Images.entertainment.image
        case .study:
            return Asset.Images.study.image
        case .train:
            return Asset.Images.train.image
        case .other:
            return Asset.Images.other.image
        }
    }
    
    var typeName: String? {
        switch self {
        case .all:
            return nil
        case .food:
            return "食費"
        case .life:
            return "生活費"
        case .entertainment:
            return "交際費"
        case .study:
            return "教育費"
        case .train:
            return "交通費"
        case .other:
            return "雑費"
        }
    }
    
    var typeColor: GradientColors {
        switch self {
        case .all:
            return GradientColors(
                top: Asset.Colors.greenTopColor.color,
                bottom: Asset.Colors.greenBottomColor.color
            )
        case .food:
            return GradientColors(
                top: Asset.Colors.purpleTopColor.color,
                bottom: Asset.Colors.purpleBottomColor.color
            )
        case .life:
            return GradientColors(
                top: Asset.Colors.blueTopColor.color,
                bottom: Asset.Colors.blueBottomColor.color
            )
        case .entertainment:
            return GradientColors(
                top: Asset.Colors.redTopColor.color,
                bottom: Asset.Colors.redBottomColor.color
            )
        case .study:
            return GradientColors(
                top: Asset.Colors.greenTopColor.color,
                bottom: Asset.Colors.greenBottomColor.color
            )
        case .train:
            return GradientColors(
                top: Asset.Colors.purpleTopColor.color,
                bottom: Asset.Colors.purpleBottomColor.color
            )
        case .other:
            return GradientColors(
                top: Asset.Colors.blueTopColor.color,
                bottom: Asset.Colors.blueBottomColor.color
            )
        }
    }
}

struct WalletItem {
    var walletType: WalletType
}

struct SectionWallet {
  var items: [Item]
}
extension SectionWallet: SectionModelType {
  typealias Item = WalletItem

  init(original: SectionWallet, items: [SectionWallet.Item]) {
    self = original
    self.items = items
  }
}
