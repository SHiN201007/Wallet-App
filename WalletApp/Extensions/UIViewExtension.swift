//
//  UIViewExtension.swift
//  WalletApp
//
//  Created by 松丸真 on 2021/11/25.
//

import Foundation
import UIKit

extension UIView {
    
    func configShadow() {
        layer.do {
            $0.cornerRadius = 10.0
            $0.shadowOpacity = 0.3
            $0.shadowOffset = CGSize(width: 5, height: 5)
            $0.shadowColor = Asset.Colors.blackColor.color.cgColor
        }
    }
    
    enum CornerRadiusPosition {
        case top
        case bottom
    }
    
    func configCornerRadius(position: CornerRadiusPosition, value: CGFloat) {
        layer.cornerRadius = value
        
        var corners: CACornerMask {
            switch position {
            case .top:
                return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .bottom:
                return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }
        
        layer.maskedCorners = corners
    }
    
    func configGradientColor(width: CGFloat, height: CGFloat, colors: WalletType) {
        let topColor = colors.typeColor.top
        let bottomColor = colors.typeColor.bottom
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(
            x: bounds.minX,
            y: bounds.minY,
            width: width,
            height: height
        )
        gradientLayer.colors = [bottomColor.cgColor, topColor.cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        gradientLayer.cornerRadius = 10.0
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

extension Int {
    func numberForComma() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        let result = formatter.string(from: NSNumber(value: self))
        return result!
    }
}

extension String {
    func convertPrice() -> Int? {
        var modifiedPriceText = self
        let deleteKeys: Set<Character> = ["¥", ","]
        modifiedPriceText.removeAll(where: { deleteKeys.contains($0) })
        return Int(modifiedPriceText)
    }
}
