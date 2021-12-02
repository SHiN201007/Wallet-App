//
//  MypageViewModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/26.
//

import Foundation
import RxSwift
import RxCocoa
import Hydra
import KRProgressHUD

class MypageViewModel {
    
    private let model = MemberModel()
    private let disposeBag = DisposeBag()
    
    struct Input {
    }
    
    struct Output {
        var memberItem: BehaviorRelay<[SectionMember]>
    }
    
    // parameter
    private var _input: Input!
    private var _output: Output!
    
    private let memberItemsRelay = BehaviorRelay<[SectionMember]>(value: [])
    
    init(trigger: Input) {
        _input = trigger
        _output = Output(
            memberItem: memberItemsRelay
        )
        
        fetchMemberItems().catch { error in
            KRProgressHUD.showError(withMessage: error.showErrorDescription())
        }
    }
    
    func fetchMemberItems() -> Promise<Void> {
        return Promise<Void>(in: .main) { [weak self] resolve, reject, _ in
            self?.model.fetchMemberData().then { members in
                self?.memberItemsRelay.accept(members)
                resolve(())
            }.catch { error in
                print("fetch member error", error)
                reject(error)
            }
        }
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
