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
        configViewModel()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configView()
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
        let input = PaymentViewModel.Input(
            priceText: priceTextField.rx.text.orEmpty.asObservable(),
            foodButtonTapped: foodButton.rx.tap.asObservable(),
            lifeButtonTapped: lifeButton.rx.tap.asObservable(),
            entertainmentButtonTapped: entertainmentButton.rx.tap.asObservable(),
            trainButtonTapped: trainButton.rx.tap.asObservable(),
            studyButtonTapped: studyButton.rx.tap.asObservable(),
            otherButtonTapped: otherButton.rx.tap.asObservable(),
            doneButtonTapped: doneButton.rx.tap.asObservable()
        )
        viewModel = PaymentViewModel(trigger: input)
    }
    
    private func bind() {
        viewModel.output().price
            .map { "¥\($0.numberForComma())" }
            .bind(to: priceTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output().typeImage
            .bind(to: typeImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.output().typeName
            .bind(to: typeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output().walletType
            .bind(to: Binder(self) { me, type in
                me.configGradient(type: type)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func configGradient(type: WalletType) {
        unConfigGradient()
        if let count = doneButton.layer.sublayers?.count {
            if count <= 1 {
                doneButton.configGradientColor(width: self.view.bounds.width - 128, height: 60, colors: type)
            }
        }
    }
    
    private func unConfigGradient() {
        if let count = doneButton.layer.sublayers?.count {
            if count > 1 {
                doneButton.layer.sublayers?.removeFirst()
            }
        }
    }

}
