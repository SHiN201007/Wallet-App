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
    case food
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
