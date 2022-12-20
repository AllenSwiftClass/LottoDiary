//
//  Int+.swift
//  LottoDiary
//
//  Created by 송선진 on 2022/12/20.
//

import Foundation

extension Int {
    
    // 1, 2 등 1자리 숫자를 01, 02로 변경하는 함수
    var insertZero: String {
        return String(format: "%02d", self)
    }
}
