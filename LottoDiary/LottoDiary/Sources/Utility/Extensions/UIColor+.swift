//
//  UIColor+.swift
//  LottoDiary
//
//  Created by uiskim on 2022/11/23.
//

import UIKit

extension UIColor {
    class func designSystem(_ color: Palette) -> UIColor? {
        UIColor(named: color.rawValue)
    }
}
