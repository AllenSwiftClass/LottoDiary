//
//  CustomTextField.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/10.
//

import UIKit

final class CustomTextField: UITextField {
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        backgroundColor = .clear
        textColor = .white
        tintColor = .white
        font = .gmarksans(weight: .regular, size: ._25)
        keyboardType = .numberPad
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        clearsOnBeginEditing = false
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.font : UIFont.gmarksans(weight: .medium, size: ._22), NSAttributedString.Key.foregroundColor : UIColor.designSystem(.gray63626B)!])
    }
}
