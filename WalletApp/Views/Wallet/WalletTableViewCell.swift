//
//  WalletTableViewCell.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import UIKit

class WalletTableViewCell: UITableViewCell {
    
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var genreImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceSlideView: UIView!
    @IBOutlet weak var balanceRightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configView(width: CGFloat, type: WalletType) {
        walletView.do { view in
            view.configGradientColor(width: width, height: view.bounds.height, colors: type)
            view.configShadow()
            view.layer.cornerRadius = 10.0
        }
        balanceView.configShadow()
        balanceView.layer.cornerRadius = 5.0
        balanceView.backgroundColor = type.typeColor.bottom
        
        balanceSlideView.layer.cornerRadius = 5.0
        genreView.layer.cornerRadius = 10.0
    }
    
    func configType(amount: Int, type: WalletType) {
        genreImageView.image = type.image
        typeLabel.text = type.typeName
        
        priceLabel.text = "¥\(amount.numberForComma())"
    }
    
}
