//
//  SettingViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/26.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        title = L10n.titleSetting
    }

}
