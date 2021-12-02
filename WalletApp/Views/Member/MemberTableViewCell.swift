//
//  MemberTableViewCell.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/27.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configAddUser() {
        iconImageView.image = Asset.Images.friend.image
        userNameLabel.text = L10n.memberPlaceHolder
        userNameLabel.textColor = Asset.Colors.placeHolderColor.color
    }
    
    func configUser() {
        userNameLabel.textColor = .label
    }
    
}
