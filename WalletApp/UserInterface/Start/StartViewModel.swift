//
//  StartViewModel.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation
import RxSwift
import RxCocoa

class StartViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        var startButtonTapped: Observable<Void>
    }
    
    struct Output {
        var isNextPage: Observable<Bool>
    }
    
    // parameter
    private var _input: Input!
    private var _output: Output!
    
    private let isNextPageSubject = PublishSubject<Bool>()
    
    init(trigger: Input) {
        _input = trigger
        _output = Output(
            isNextPage: isNextPageSubject.asObservable()
        )
        
        bind()
    }
    
    private func bind() {
        _input.startButtonTapped
            .bind(to: Binder(self) { me, _ in
                // TODO: create user
                me.isNextPageSubject.onNext(true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
