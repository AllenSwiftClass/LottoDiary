//
//  Int+.swift
//  LottoDiary
//
//  Created by 송선진 on 2022/12/20.
//

import Foundation

extension Int {
    
    var insertZero: String {
        return String(format: "%02d", self)
    }
}
