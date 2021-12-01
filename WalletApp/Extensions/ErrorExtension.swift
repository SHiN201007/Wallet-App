//
//  ErrorExtension.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation

extension Error {
    
    func showErrorDescription() -> String {
        switch self.localizedDescription {
        case FirebaseError.unAuthError.localizedDescription:
            return FirebaseError.unAuthError.descript
        case FirebaseError.unknowError.localizedDescription:
            return FirebaseError.unknowError.descript
        case FirebaseError.unSaveError.localizedDescription:
            return FirebaseError.unSaveError.descript
        case FirebaseError.unUpdateError.localizedDescription:
            return FirebaseError.unUpdateError.descript
        case FirebaseError.unDeleteError.localizedDescription:
            return FirebaseError.unDeleteError.descript
        case FirebaseError.connotDataError.localizedDescription:
            return FirebaseError.connotDataError.descript
        default:
            return "予期せぬエラーが発生しました。\nリトライしてください。"
        }
    }
    
}
