//
//  MypageViewModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/26.
//

import Foundation
import RxSwift
import RxCocoa

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
        
        // configure
        fetchMemberItems()
    }
    
    private func fetchMemberItems() {
        model.fetchMemberData().then { [weak self] members in
            self?.memberItemsRelay.accept(members)
        }.catch { error in
            print("fetch member error", error)
        }
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
