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
                    print("succsess")
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
        print("signInAnonymously")
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
                print("isAnonymous", user.isAnonymous)
                user.isAnonymous ? resolve(true) : reject(FirebaseError.unAuthError)
            }
        }
    }
    
    private func createUser() -> Promise<Bool> {
        print("createUser")
        return Promise<Bool>(in: .main) { resolve, reject, _ in
            guard let uid: String = Auth.auth().currentUser?.uid else {
                reject(FirebaseError.unAuthError)
                return
            }
            print("uid", uid)
            let userRef = FirebaseConstants.users.document(id: uid)
            let user: Document<Users.users> = Document(userRef)
            
            user.data = Users.users(
                userName: "テストユーザー",
                gender: nil
            )
            
            user.save { error in
                if let saveError = error {
                    print(saveError)
                    reject(FirebaseError.unSaveError)
                    return
                }
                print("create user done")
                resolve(true)
            }
        }
    }
    
}
