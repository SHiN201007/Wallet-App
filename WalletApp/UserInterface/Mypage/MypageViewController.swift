//
//  MypageViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class MypageViewController: UIViewController {
    
    private var viewModel: MypageViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        title = L10n.titleMypage
    }

}
