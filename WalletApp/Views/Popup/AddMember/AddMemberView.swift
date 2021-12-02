//
//  AddMemberView.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/12/02.
//

import UIKit

class AddMemberView: UIView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
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
    
}
