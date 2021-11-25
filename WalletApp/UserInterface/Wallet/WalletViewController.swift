//
//  WalletViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var walletCornerTopView: UIView!
    @IBOutlet weak var walletCornerBottomView: UIView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceSlideView: UIView!
    @IBOutlet weak var balanceRightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configView()
    }
    
    private func configView() {
        walletView.do { view in
            view.configGradientColor(width: self.view.bounds.width - 40, height: view.bounds.height)
            view.configShadow()
            view.layer.cornerRadius = 10.0
        }
        walletCornerTopView.configCornerRadius(position: .top, value: 50)
        walletCornerBottomView.configCornerRadius(position: .bottom, value: 50)
        balanceView.configShadow()
        balanceView.layer.cornerRadius = 10.0
        balanceSlideView.layer.cornerRadius = 10.0
    }
    
}
