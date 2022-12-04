//
//  Int+.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import Foundation

extension Int {
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }
}
