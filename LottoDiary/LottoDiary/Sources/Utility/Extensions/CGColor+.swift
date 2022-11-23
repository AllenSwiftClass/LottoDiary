//
//  CGColor+.swift
//  LottoDiary
//
//  Created by uiskim on 2022/11/23.
//

import UIKit

extension CGColor {
    class func designSystem(_ color: Palette) -> CGColor? {
        UIColor(named: color.rawValue)?.cgColor
    }
}
