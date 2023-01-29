//
//  Double+.swift
//  LottoDiary
//
//  Created by 천승현 on 2023/01/18.
//

import Foundation

extension Double {
    
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }
    
}
