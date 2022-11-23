//
//  UIFont+.swift
//  LottoDiary
//
//  Created by uiskim on 2022/11/23.
//

import UIKit

extension UIFont {
    static func designSystem(weight: Font.Weight, size: Font.Size) -> UIFont {
        .systemFont(ofSize: size.rawValue, weight: weight.real)
    }
    
    static func gmarksans(weight: Font.Weight, size: Font.Size) -> UIFont {
        let font = Font.CustomFont(name: .gmarketsans, weight: weight)
        return ._font(name: font.name, size: size.rawValue)
    }
    
    private static func _font(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            return .systemFont(ofSize: size)
        }
        return font
    }
}
