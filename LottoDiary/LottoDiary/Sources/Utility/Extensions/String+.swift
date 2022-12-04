//
//  String+.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import Foundation

extension String {
    var dateStringToHeaderView: String {
        var nums = self.split(separator: "-").map{String($0)}
        if nums[1].hasPrefix("0") { nums[1].removeFirst() }
        if nums[2].hasPrefix("0") { nums[2].removeFirst() }
        let newStr = "\(nums[1])월 \(nums[2])일"
        return newStr
    }
}
