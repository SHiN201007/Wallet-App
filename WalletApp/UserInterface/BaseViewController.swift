//
//  BaseViewController.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/29.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentStartPageIfNeeded()
    }
    
    private func presentStartPageIfNeeded() {
        if UserDefaults.standard.bool(forKey: "login") {
            // already logined
        }else {
            // present start view
            let startVC = StartViewController()
            startVC.modalPresentationStyle = .fullScreen
            present(startVC, animated: true, completion: nil)
        }
    }
    
}
