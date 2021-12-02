//
//  FirebaseError.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation

enum FirebaseError: Error {
    case unAuthError
    case unknowError
    case unSaveError
    case unUpdateError
    case unDeleteError
    case connotDataError
    
    var descript: String {
        switch self {
        case .unAuthError:
            return "ユーザー認証に失敗しました。\n再ログインを行ってください。"
        case .unknowError:
            return "予期せぬエラーが発生しました。\nリトライしてください。"
        case .unSaveError:
            return "データの保存に失敗しました。\nリトライしてください。"
        case .unUpdateError:
            return "データの更新に失敗しました。\nリトライしてください。"
        case .unDeleteError:
            return "データの削除に失敗しました。\nリトライしてください。"
        case .connotDataError:
            return "データの取得に失敗しました。\nリトライしてください。"
        }
    }
}
