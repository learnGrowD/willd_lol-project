//
//  UIColor.swift
//  willd_lol
//
//  Created by 도학태 on 2022/08/09.
//

import Foundation
import UIKit

extension UIColor {
    static var willdBlack : UIColor? { return UIColor(named: "willdBlack") }
    static var willdPulple : UIColor? { return UIColor(named: "willdPurple") }
    static var willdWhite : UIColor? { return UIColor(named: "willdWhite") }
}


extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
