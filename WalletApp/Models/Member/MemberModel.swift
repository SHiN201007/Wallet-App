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
        let userModel = UserModel()
        return Promise<[SectionMember]>(in: .main) { [weak self] resolve, reject, _ in
            userModel.getMainRoomID().then { mainRoomID in
                self?.getRoomMembers(roomID: mainRoomID).then { members in
                    resolve(members)
                }.catch { error in
                    reject(error)
                }
            }
        }
    }
    
    private func getRoomMembers(roomID id: String) -> Promise<[SectionMember]> {
        let userModel = UserModel()
        var users: [String] = []
        var members: [SectionMember] = []
        return Promise<[SectionMember]>(in: .main) { resolve, reject, _ in
            let memberRef = FirebaseConstants.rooms
                .subCollections(parentDocument: id, subCollection: .members)
            memberRef.getDocuments { snapshot, error in
                if let memberError = error {
                    reject(memberError)
                    return
                }
                guard let documents = snapshot?.documents else {
                    reject(FirebaseError.connotDataError)
                    return
                }
                
                documents.forEach { snapshot in
                    if let document = Document<Members.members>(snapshot: snapshot),
                       let data = document.data,
                       let uid = data.memberID {
                        users.append(uid)
                    }else {
                        reject(FirebaseError.connotDataError)
                        return
                    }
                }
                
                // userdata
                all(users.map(userModel.fetchUserData(userID:))).then { users in
                    users.forEach { user in
                        let member = SectionMember.Item(
                            userName: user.userName,
                            gender: userModel.convertGender(string: user.gender)
                        )
                        members.append(SectionMember(items: [member]))
                    }
                    members.append(SectionMember(items: [SectionMember.Item(userName: nil, gender: nil)]))
                    resolve(members)
                }.catch { error in
                    reject(error)
                }
            }
        }
    }
    
    // MARK: CRUD
    func addMemberForMe(roomID: String) -> Promise<Void> {
        return Promise<Void>(in: .main) { resolve, reject, _ in
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
