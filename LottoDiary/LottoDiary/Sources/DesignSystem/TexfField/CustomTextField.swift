//
//  CustomTextField.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/10.
//

import UIKit

enum TextFieldType {
    case letter
    case number
}


final class CustomTextField: UITextField {
    convenience init(placeholder: String, type: TextFieldType, align: NSTextAlignment) {
        self.init(frame: .zero)
        switch type {
        case .letter: self.keyboardType = .default
        case .number: self.keyboardType = .numberPad
        }
        textAlignment = align
        backgroundColor = .clear
        textColor = .white
        tintColor = .white
        font = .gmarksans(weight: .bold, size: ._25)
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        clearsOnBeginEditing = false
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font : UIFont.gmarksans(weight: .medium, size: ._22), NSAttributedString.Key.foregroundColor : UIColor.designSystem(.gray63626B)!])
    }
}
