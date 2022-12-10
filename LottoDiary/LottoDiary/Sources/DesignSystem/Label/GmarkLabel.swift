//
//  CustomLabel.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/10.
//

import UIKit

class GmarkLabel: UILabel {
    // MARK: - initializer
    
    convenience init(text: String, font: UIFont = .gmarksans(weight: .regular, size: ._15), textColor: UIColor = .white) {
        self.init(frame: .zero)
        configure(text: text, font: font, textColor: textColor)
    }
    
    private func configure(text: String, font: UIFont, textColor: UIColor) {
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}
