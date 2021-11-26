//
//  PaymentViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class PaymentViewController: UIViewController {
    
    private var viewModel: PaymentViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configViewModel()
    }
    
    private func configView() {
        title = L10n.titlePayment
    }
    
    private func configViewModel() {
        let input = PaymentViewModel.Input()
        viewModel = PaymentViewModel(trigger: input)
        // MARK: OUTPUT
    }

}
