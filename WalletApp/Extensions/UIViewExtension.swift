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
    
    func configGradientColor(width: CGFloat, height: CGFloat) {
        let topColor = Asset.Colors.greenTopColor.color
        let bottomColor = Asset.Colors.greenBottomColor.color
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
