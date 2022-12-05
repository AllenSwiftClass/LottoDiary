//
//  Int+.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/12/06.
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
