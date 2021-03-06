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
    
    func joinParticipateRoom(shareCode: Int) -> Promise<Void> {
        let userModel = UserModel()
        let memberModel = MemberModel()
        let participateRoomModel = ParticipateRoomModel()
        return Promise<Void>(in: .main) { resolve, reject, _ in
            self.searchRoomID(shareCode: shareCode).then { roomID in
                all(
                    memberModel.addMemberForMe(roomID: roomID),
                    participateRoomModel.addParticipateRoom(roomID: roomID),
                    userModel.updateMainRoom(roomID: roomID)
                ).then { _ in
                    UserDefaults.standard.setValue(true, forKey: LocalKey.logined.rawValue)
                    resolve(())
                }.catch { error in
                    reject(error)
                }
            }.catch { error in
                reject(error)
            }
        }
    }
    
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
        return Promise<String>(in: .main) { [weak self] resolve, reject, _ in
            let roomRef = FirebaseConstants.rooms.ref
            let room: Document<Rooms.rooms> = Document(collectionReference: roomRef)
            self?.createShareCode().then { shareCode in
                room.data = Rooms.rooms(
                    foodUpper: item.foodPrice,
                    lifeUpper: item.lifePrice,
                    entertainmentUpper: item.entertainmentPrice,
                    studyUpper: item.studyPrice,
                    trainUpper: item.trainPrice,
                    otherUpper: item.otherPrice,
                    shareCode: shareCode
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
            }.catch { error in
                reject(error)
            }
        }
    }
    
    private func createShareCode() -> Promise<Int> {
        let shareModel = ShareCodeModel()
        var createFlag = true
        var codes: [Int] = []
        return Promise<Int>(in: .main) { resolve, reject, _ in
            let roomRef = FirebaseConstants.rooms.ref
            roomRef.getDocuments { snapshot, error in
                if let roomError = error {
                    reject(roomError)
                    return
                }
                guard let documents = snapshot?.documents else {
                    reject(FirebaseError.connotDataError)
                    return
                }
                
                documents.forEach { snapshot in
                    if let data = Document<Rooms.rooms>(snapshot: snapshot)?.data {
                        codes.append(data.shareCode)
                    }
                }
                
                while createFlag {
                    let shareCode = shareModel.createShareCode()
                    if !codes.contains(shareCode) {
                        createFlag = false
                        resolve(shareCode)
                        return
                    }
                }
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
    
    func getTotalPrice(roomID id: String) -> Promise<Int> {
        return Promise<Int>(in: .main) { resolve, reject, _ in
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
                
                var total = 0
                total += data.foodUpper
                total += data.lifeUpper
                total += data.entertainmentUpper
                total += data.studyUpper
                total += data.trainUpper
                total += data.otherUpper
                resolve(total)
                return
            }
        }
    }
    
    func getRoomShareCode() -> Promise<Int> {
        let userModel = UserModel()
        return Promise<Int>(in: .main) { resolve, reject, _ in
            userModel.getMainRoomID().then { mainRoomID in
                let roomRef = FirebaseConstants.rooms.document(id: mainRoomID)
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
                    
                    resolve(data.shareCode)
                    return
                }
            }.catch { error in
                reject(error)
            }
        }
    }
    
    private func searchRoomID(shareCode: Int) -> Promise<String> {
        return Promise<String>(in: .main) { resolve, reject, _ in
            let roomRef = FirebaseConstants.rooms.ref
            roomRef.whereField("shareCode", isEqualTo: shareCode)
                .getDocuments { snapshot, error in
                    if let roomError = error {
                        reject(roomError)
                        return
                    }
                    guard let documents = snapshot?.documents,
                          let data = documents.first else {
                        reject(FirebaseError.connotDataError)
                        return
                    }
                    
                    let roomID = data.documentID
                    print("roomID:", roomID)
                    resolve(roomID)
                    return
                }
        }
    }
}
