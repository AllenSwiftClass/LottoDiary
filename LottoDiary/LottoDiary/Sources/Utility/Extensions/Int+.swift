//
//  Int+.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/12/06.
//

import Foundation

extension Int {
    //
    static let lottoRange: Range<Int> = 1..<46
    
    static func makeRandomIntArray(count: Int) -> [Int] {
        var returnArray: [Int] = []
        for _ in 0..<count {
            returnArray.append(Int.random(in: lottoRange))
        }
        
        var sortedRandomReturnArray = returnArray.sorted()
        
        return sortedRandomReturnArray
    }
    
    static func makeRandomLottoNumber() -> Int {
        return Int.random(in: lottoRange)
    }
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? ""
    }
}
