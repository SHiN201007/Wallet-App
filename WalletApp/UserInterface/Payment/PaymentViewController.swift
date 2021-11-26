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
    
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var lifeButton: UIButton!
    @IBOutlet weak var entertainmentButton: UIButton!
    @IBOutlet weak var trainButton: UIButton!
    @IBOutlet weak var studyButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet var walletTypeViews: [UIView]!
    
    private var viewModel: PaymentViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configViewModel()
        bind()
    }
    
    private func configView() {
        title = L10n.titlePayment
        // paymentView
        paymentView.do { view in
            view.layer.cornerRadius = 10.0
            view.configShadow()
        }
        // wallet type view
        walletTypeViews.forEach { typeView in
            typeView.layer.cornerRadius = 10.0
            typeView.configShadow()
        }
        
        doneButton.layer.cornerRadius = 10.0
        doneButton.configGradientColor(width: self.view.bounds.width - 128, height: 60, colors: .food)
        doneButton.configShadow()
    }
    
    private func configViewModel() {
        let input = PaymentViewModel.Input()
        viewModel = PaymentViewModel(trigger: input)
    }
    
    private func bind() {
        
    }

}
