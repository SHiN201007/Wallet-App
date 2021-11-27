//
//  MemberModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/27.
//

import Foundation
import Hydra

class MemberModel {
    enum MemberError: Error {
        case unknowError
    }
    
    func fetchMemberData() -> Promise<[SectionMember]> {
        return Promise<[SectionMember]>(in: .main) { [weak self] resolve, reject, _ in
            if let items = self?.sampleMemberData() {
                resolve(items)
                return
            }else {
                reject(MemberError.unknowError)
                return
            }
        }
    }
    
    // sample data
    private func sampleMemberData() -> [SectionMember] {
        return [
            SectionMember(items: [SectionMember.Item(userName: "シン", gender: .man)]),
            SectionMember(items: [SectionMember.Item(userName: "きょうか", gender: .woman)]),
            SectionMember(items: [SectionMember.Item(userName: nil, gender: nil)])
        ]
    }
}
