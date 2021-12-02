//
//  AddMemberView.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/12/02.
//

import UIKit
import RxSwift
import RxCocoa
import Hydra
import KRProgressHUD

class AddMemberView: UIView {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    struct ShareItem {
        var userName: String
        var shareCode: Int
    }
    
    struct Output {
        var share: Observable<Bool>
        var cancel: Observable<Bool>
        var shareItem: BehaviorRelay<ShareItem>
    }
    
    private var _output: Output!
    private let disposeBag = DisposeBag()
    
    private let shareTriggerSubject = PublishSubject<Bool>()
    private let cancelTriggerSubject = PublishSubject<Bool>()
    private let shareItemRelay = BehaviorRelay<ShareItem>(value: ShareItem(userName: "userName", shareCode: 0))
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        _output = Output(
            share: shareTriggerSubject.asObservable(),
            cancel: cancelTriggerSubject.asObservable(),
            shareItem: shareItemRelay
        )
        
        loadNib()
        fetchMyNameData()
        bind()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    private func loadNib(){
        guard let view =  UINib(nibName: "AddMemberView", bundle: nil).instantiate(withOwner: self, options: nil).first as? AddMemberView else {
            return
        }
        view.frame = self.bounds
        view.layer.cornerRadius = 10.0
        self.addSubview(view)
    }
    
    private func fetchMyNameData() {
        let userModel = UserModel()
        let roomModel = RoomModel()
        
        KRProgressHUD.show()
        userModel.getMyUserData().then { [weak self] user in
            roomModel.getRoomShareCode().then { shareCode in
                self?.shareItemRelay.accept(
                    ShareItem(
                        userName: user.userName,
                        shareCode: shareCode
                    )
                )
                KRProgressHUD.dismiss()
            }.catch { error in
                print("share code error", error)
                KRProgressHUD.showError(withMessage: error.showErrorDescription())
            }
        }.catch { error in
            print("user data error", error)
            KRProgressHUD.showError(withMessage: error.showErrorDescription())
        }
    }
    
    private func bind() {
        shareItemRelay
            .map { "\($0.shareCode)" }
            .unwrap()
            .bind(to: codeLabel.rx.text)
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .map { true }
            .bind(to: shareTriggerSubject)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .map { true }
            .bind(to: cancelTriggerSubject)
            .disposed(by: disposeBag)
    }
    
    func output() -> Output {
        _output
    }
    
}
