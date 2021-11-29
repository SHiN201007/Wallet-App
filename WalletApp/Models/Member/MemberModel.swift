//
//  MemberModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/27.
//

import Foundation
import Firebase
import Ballcap
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
    
    
    // MARK: CRUD
    func addMemberForMe(roomID: String) -> Promise<Void> {
        return Promise<Void>(in: .main) { [weak self] resolve, reject, _ in
            guard let uid: String = Auth.auth().currentUser?.uid else {
                reject(FirebaseError.unAuthError)
                return
            }
            let memberRef = FirebaseConstants.rooms
                .subCollections(parentDocument: roomID, subCollection: .members)
            
            let member: Document<Members.members> = Document(collectionReference: memberRef)
            
            member.data = Members.members(
                memberID: uid
            )
            
            member.save { error in
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
