//
//  RoomModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation
import Firebase
import Ballcap
import Hydra

class RoomModel {
    
    func setupRoom(item: SettingModel.UpperItem) -> Promise<Void> {
        // create room
        // participate user : member model
        let memberModel = MemberModel()
        let userModel = UserModel()
        let participateRoomModel = ParticipateRoomModel()
        return Promise<Void>(in: .main) { [weak self] resolve, reject, _ in
            self?.createRoom(item: item).then { roomID in
                all(
                    memberModel.addMemberForMe(roomID: roomID),
                    participateRoomModel.addParticipateRoom(roomID: roomID),
                    userModel.updateMainRoom(roomID: roomID)
                ).then { _ in
                    resolve(())
                }.catch { error in
                    reject(error)
                }
            }.catch { error in
                reject(error)
            }
        }
    }
    
    private func createRoom(item: SettingModel.UpperItem) -> Promise<String> {
        return Promise<String>(in: .main) { resolve, reject, _ in
            let roomRef = FirebaseConstants.rooms.ref
            let room: Document<Rooms.rooms> = Document(collectionReference: roomRef)
            
            room.data = Rooms.rooms(
                foodUpper: item.foodPrice,
                lifeUpper: item.lifePrice,
                entertainmentUpper: item.entertainmentPrice,
                studyUpper: item.studyPrice,
                trainUpper: item.trainPrice,
                otherUpper: item.otherPrice
            )
            
            room.save { error in
                if let saveError = error {
                    print(saveError)
                    reject(FirebaseError.unSaveError)
                    return
                }
                
                let roomID = room.documentReference.documentID
                resolve(roomID)
            }
        }
    }
    
    // update room setting
    func updateRoomSetting(id: String, item: SettingModel.UpperItem) -> Promise<Void> {
        return Promise<Void>(in: .main) { resolve, reject, _ in
            let roomRef = FirebaseConstants.rooms.document(id: id)
            Document<Rooms.rooms>.get(documentReference: roomRef) { room, error in
                if let getError = error {
                    print(getError)
                    reject(FirebaseError.connotDataError)
                    return
                }
                
                room?.data = Rooms.rooms(
                    foodUpper: item.foodPrice,
                    lifeUpper: item.lifePrice,
                    entertainmentUpper: item.entertainmentPrice,
                    studyUpper: item.studyPrice,
                    trainUpper: item.trainPrice,
                    otherUpper: item.otherPrice
                )
                
                room?.update { error in
                    if let updateError = error {
                        print(updateError)
                        reject(FirebaseError.unUpdateError)
                        return
                    }
                    resolve(())
                }
            }
        }
    }
    
    
    // MARK: Get
    func getSettingItems(id: String) -> Promise<SettingModel.UpperItem> {
        return Promise<SettingModel.UpperItem>(in: .main) { resolve, reject, _ in
            let roomRef = FirebaseConstants.rooms.document(id: id)
            Document<Rooms.rooms>.get(documentReference: roomRef) { room, error in
                if let getError = error {
                    print(getError)
                    reject(FirebaseError.connotDataError)
                    return
                }
                guard let data = room?.data else {
                    reject(FirebaseError.connotDataError)
                    return
                }
                
                let item = SettingModel.UpperItem(
                    foodPrice: data.foodUpper,
                    lifePrice: data.lifeUpper,
                    entertainmentPrice: data.entertainmentUpper,
                    studyPrice: data.studyUpper,
                    trainPrice: data.trainUpper,
                    otherPrice: data.otherUpper
                )
                resolve(item)
            }
        }
    }
}
