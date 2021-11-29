//
//  UserModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation
import Firebase
import Ballcap
import Hydra

class UserModel {
    
    func signIn() -> Promise<Bool> {
        return Promise<Bool>(in: .main) { [weak self] resolve, reject, _ in
            self?.signInAnonymously().then { _ in
                self?.createUser().then { _ in
                    resolve(true)
                }.catch { error in
                    print("signIn error", error)
                    reject(error)
                }
            }.catch { error in
                print("signIn error", error)
                reject(error)
            }
        }
    }
    
    private func signInAnonymously() -> Promise<Bool> {
        return Promise<Bool>(in: .main) { resolve, reject, _ in
            Auth.auth().signInAnonymously { result, error in
                if let authError = error {
                    print(authError)
                    reject(FirebaseError.unAuthError)
                    return
                }
                guard let user = result?.user else {
                    reject(FirebaseError.unAuthError)
                    return
                }
                user.isAnonymous ? resolve(true) : reject(FirebaseError.unAuthError)
            }
        }
    }
    
    private func createUser() -> Promise<Bool> {
        return Promise<Bool>(in: .main) { resolve, reject, _ in
            guard let uid: String = Auth.auth().currentUser?.uid else {
                reject(FirebaseError.unAuthError)
                return
            }
            let userRef = FirebaseConstants.users.document(id: uid)
            let user: Document<Users.users> = Document(userRef)
            
            user.data = Users.users(
                userName: "テストユーザー"
            )
            
            user.save { error in
                if let saveError = error {
                    print(saveError)
                    reject(FirebaseError.unSaveError)
                    return
                }
                resolve(true)
            }
        }
    }
    
    
    // main roomID取得
    func getMainRoomID() -> Promise<String> {
        return Promise<String>(in: .main) { resolve, reject, _ in
            guard let uid: String = Auth.auth().currentUser?.uid else {
                reject(FirebaseError.unAuthError)
                return
            }
            
            let userRef = FirebaseConstants.users.document(id: uid)
            Document<Users.users>.get(documentReference: userRef) { user, error in
                if let getError = error {
                    print(getError)
                    reject(FirebaseError.connotDataError)
                    return
                }
                
                guard let data = user?.data,
                      let mainRoomID = data.mainRoomID else {
                    reject(FirebaseError.connotDataError)
                    return
                }
                
                resolve(mainRoomID)
            }
        }
    }
    
    
    // update main room
    func updateMainRoom(roomID: String) -> Promise<Void> {
        return Promise<Void>(in: .main) { resolve, reject, _ in
            guard let uid: String = Auth.auth().currentUser?.uid else {
                reject(FirebaseError.unAuthError)
                return
            }
            
            let userRef = FirebaseConstants.users.document(id: uid)
            Document<Users.users>.get(documentReference: userRef) { user, error in
                if let getError = error {
                    print(getError)
                    reject(FirebaseError.connotDataError)
                    return
                }
                
                guard let data = user?.data else {
                    reject(FirebaseError.connotDataError)
                    return
                }
                
                user?.data = data
                user?.data?.mainRoomID = roomID
                
                user?.save { error in
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
    
}
