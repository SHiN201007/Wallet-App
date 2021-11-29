//
//  SettingModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation
import Firebase
import Ballcap
import Hydra

class SettingModel {
    
    struct UpperItem {
        var foodPrice: Int
        var lifePrice: Int
        var entertainmentPrice: Int
        var studyPrice: Int
        var trainPrice: Int
        var otherPrice: Int
    }
    
    
    func registSetting(upperItem: UpperItem) -> Promise<Void> {
        // setup room : room model
        let roomModel = RoomModel()
        return Promise<Void>(in: .main) { resolve, reject, _ in
            roomModel.setupRoom(item: upperItem).then { _ in
                // completion
                UserDefaults.standard.setValue(true, forKey: LocalKey.logined.rawValue)
                resolve(())
            }.catch { error in
                reject(error)
            }
        }
    }
    
    
    func updateSetting(upperItem: UpperItem) -> Promise<Void> {
        let userModel = UserModel()
        let roomModel = RoomModel()
        return Promise<Void>(in: .main) { resolve, reject, _ in
            userModel.getMainRoomID().then { mainRoomID in
                roomModel.updateRoomSetting(
                    id: mainRoomID,
                    item: upperItem
                ).then { _ in
                    // completion
                    resolve(())
                }.catch { error in
                    reject(error)
                }
            }.catch { error in
                reject(error)
            }
        }
    }
    
    
    
    
}
