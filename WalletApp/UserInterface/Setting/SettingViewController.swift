//
//  SettingViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/26.
//

import UIKit
import RxSwift
import RxCocoa

class SettingViewController: UIViewController {
    
    @IBOutlet var walletViews: [UIView]!
    @IBOutlet var typeViews: [UIView]!
    @IBOutlet var typeImageViews: [UIImageView]!
    @IBOutlet var typeLabels: [UILabel]!
    @IBOutlet weak var foodTextField: UITextField!
    @IBOutlet weak var lifeTextField: UITextField!
    @IBOutlet weak var entertainmentTextField: UITextField!
    @IBOutlet weak var studyTextField: UITextField!
    @IBOutlet weak var trainTextField: UITextField!
    @IBOutlet weak var otherTextField: UITextField!
    
    private var doneButton: UIBarButtonItem!
    
    private var viewModel: SettingViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configViewModel()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configWalletViews()
    }
    
    private func configView() {
        title = L10n.titleSetting
        doneButton = createDoneButton()
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func createDoneButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            title: "登録",
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    private func configWalletViews() {
        let walletList: [WalletType] = [.food, .life, .entertainment, .study, .train, .other]
        for (index, view) in walletViews.enumerated() {
            view.configShadow()
            view.configGradientColor(width: self.view.bounds.width - 40, height: 70, colors: walletList[index])
        }
        
        typeViews.forEach { $0.layer.cornerRadius = 10.0 }
        
        for (index, imageView) in typeImageViews.enumerated() {
            imageView.image = walletList[index].image
        }
        
        for (index, label) in typeLabels.enumerated() {
            label.text = walletList[index].typeName
        }
    }
    
    private func configViewModel() {
        let input = SettingViewModel.Input(
            foodText: foodTextField.rx.text.orEmpty.asObservable(),
            lifeText: lifeTextField.rx.text.orEmpty.asObservable(),
            entertainmentText: entertainmentTextField.rx.text.orEmpty.asObservable(),
            studyText: studyTextField.rx.text.orEmpty.asObservable(),
            trainText: trainTextField.rx.text.orEmpty.asObservable(),
            otherText: otherTextField.rx.text.orEmpty.asObservable(),
            doneButtonTapped: doneButton.rx.tap.asObservable()
        )
        viewModel = SettingViewModel(trigger: input)
    }
    
    private func bind() {
        viewModel.output().foodPrice
            .map { "¥\($0)" }
            .bind(to: foodTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output().lifePrice
            .map { "¥\($0)" }
            .bind(to: lifeTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output().entertainmentPrice
            .map { "¥\($0)" }
            .bind(to: entertainmentTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output().studyPrice
            .map { "¥\($0)" }
            .bind(to: studyTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output().trainPrice
            .map { "¥\($0)" }
            .bind(to: trainTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output().otherPrice
            .map { "¥\($0)" }
            .bind(to: otherTextField.rx.text)
            .disposed(by: disposeBag)
    }

}
