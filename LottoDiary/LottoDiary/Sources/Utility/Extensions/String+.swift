//
//  String+.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import UIKit

extension String {
    var dateStringToHeaderView: String {
        var nums = self.split(separator: "-").map{String($0)}
        if nums[1].hasPrefix("0") { nums[1].removeFirst() }
        if nums[2].hasPrefix("0") { nums[2].removeFirst() }
        let newStr = "\(nums[1])월 \(nums[2])일"
        return newStr
    }
}

extension String {
    /// 특정글자의 font와 textColor를 바꿀수 있는 메서드
    /// - Parameters:
    ///   - nonAppendString: 바뀌지 않는 문자열
    ///   - appendString: 바꾸고싶은 문자열
    ///   - changeAppendStringSize: 바꾸고싶은 문자열의 fontSize
    ///   - changeAppendStringWieght: 바꾸고싶은 문자열의 fontWeight
    ///   - changeAppendStringColor: 바꾸고 싶은 문자열의 fontColor
    /// - Returns: UILabel속성이라면 .text가 아니라 .attributedText로 받아야함
    static func makeAtrributedString(
        nonAppendString: String,
        appendString: String,
        changeAppendStringSize: Font.Size,
        changeAppendStringWieght: Font.Weight,
        changeAppendStringColor: UIColor
    ) -> NSMutableAttributedString {
        let profileString = nonAppendString + appendString
        let attributedQuote = NSMutableAttributedString(string: profileString)
        attributedQuote.addAttribute(
            .foregroundColor,
            value: changeAppendStringColor,
            range: (profileString as NSString).range(of: appendString)
        )
        attributedQuote.addAttribute(
            .font,
            value: UIFont.gmarksans(weight: changeAppendStringWieght, size: changeAppendStringSize),
            range: (profileString as NSString).range(of: appendString)
        )
        return attributedQuote
    }
}
