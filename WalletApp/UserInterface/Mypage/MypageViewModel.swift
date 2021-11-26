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
    
    private let disposeBag = DisposeBag()
    
    struct Input {
    }
    
    struct Output {
    }
    
    // parameter
    private var _input: Input!
    private var _output: Output!
    
    init(trigger: Input) {
        _input = trigger
        _output = Output(
        )
        
    }
    
    // MARK: -- OUTPUT
    func output() -> Output {
        _output
    }
    
}
