//
//  ParticipateViewModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/12/02.
//

import Foundation
import RxSwift
import RxCocoa
import KRProgressHUD

class ParticipateViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        var inviteCode: Observable<String>
        var joinButtonTapped: Observable<Void>
    }
    
    struct Output {
        var isSuccsess: Observable<Bool>
    }
    
    private var _input: Input!
    private var _output: Output!
    
    private let shareCodeRelay = BehaviorRelay<Int>(value: 0)
    private let isSuccsessSubject = PublishSubject<Bool>()

    init(trigger: Input) {
        _input = trigger
        _output = Output(
            isSuccsess: isSuccsessSubject.asObservable()
        )
        
        bind()
    }
    
    private func bind() {
        _input.inviteCode
            .map { Int($0) }
            .unwrap()
            .bind(to: shareCodeRelay)
            .disposed(by: disposeBag)
        
        _input.joinButtonTapped
            .bind(to: Binder(self) { me, _ in
                me.joinRoom()
            })
            .disposed(by: disposeBag)
    }
    
    private func joinRoom() {
        let roomModel = RoomModel()
        KRProgressHUD.show(withMessage: "ウォレットを検索中...")
        print("shareCode;", shareCodeRelay.value)
        roomModel.joinParticipateRoom(shareCode: shareCodeRelay.value).then { [weak self] _ in
            KRProgressHUD.dismiss()
            self?.isSuccsessSubject.onNext(true)
        }.catch { error in
            print(error.localizedDescription)
            KRProgressHUD.showError(withMessage: "ウォレットが見つかりませんでした。\nもう一度ご確認ください。")
        }
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
