//
//  String+.swift
//  LottoDiary
//
//  Created by 송선진 on 2022/12/21.
//

import Foundation

extension String {
    
    // string의 인덱스가 0-1, 2-3, 4-5에서 끊어서 return : QR로 들어온 번호는 모두 합쳐저서 하나의 String으로 오기 때문에 분리.
//    static func separateNumber(lottoQRNumber number: String) -> [String] {
//        let separatedArray = [String]
//
//        for addIndex in 0...2 {
//            let startIndex = number.index(number.startIndex, offsetBy: addIndex * 2)
//            let endIndex = number.index(number.startIndex, offsetBy: addIndex * 2 + 1)
//
//            separatedArray.append(number[startIndex...endIndex])
//        }
//
//        return separatedArray
//    }
    
//    var separateNumber: [String] {
//        let separatedArray: [String] = []
//
//        for addIndex in 0...2 {
//            let startIndex = self.index(self.startIndex, offsetBy: addIndex * 2)
//            let endIndex = self.index(self.startIndex, offsetBy: addIndex * 2 + 1)
//            separatedArray.append(self[startIndex...endIndex])
//        }
//
//        return separatedArray
//    }
}
