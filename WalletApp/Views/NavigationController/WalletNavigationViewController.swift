//
//  WalletNavigationViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import UIKit

class WalletNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        navigationBar.do {
            $0.backgroundColor = Asset.Colors.backgroundColor.color
            $0.tintColor = .black
            $0.barTintColor = Asset.Colors.backgroundColor.color
            $0.titleTextAttributes = [
                .foregroundColor: UIColor.black
            ]
            $0.setBackgroundImage(UIImage(), for: .default)
            $0.shadowImage = UIImage()
        }
    }

}
