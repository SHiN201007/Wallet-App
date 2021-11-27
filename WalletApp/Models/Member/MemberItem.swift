//
//  MemberItem.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/27.
//

import Foundation
import UIKit
import RxDataSources

enum Gender {
    case man
    case woman
    case other
    
    var image: UIImage {
        switch self {
        case .man:
            return Asset.Images.father.image
        case .woman:
            return Asset.Images.girl.image
        case .other:
            return Asset.Images.friend.image
        }
    }
}

struct MemberItem {
    var userName: String?
    var gender: Gender?
}

struct SectionMember {
  var items: [Item]
}
extension SectionMember: SectionModelType {
  typealias Item = MemberItem

  init(original: SectionMember, items: [SectionMember.Item]) {
    self = original
    self.items = items
  }
}
