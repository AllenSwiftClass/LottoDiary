//
//  String+.swift
//  LottoDiary
//
//  Created by 송선진 on 2022/12/21.
//

import Foundation

extension String {
    
    // string의 인덱스가 0-1, 2-3, 4-5에서 끊어서 return : QR로 들어온 번호는 모두 합쳐저서 하나의 String으로 오기 때문에 분리.
    var separateNumber: [Int] {
        var separatedArray:[Int] = []

        for addIndex in 0...5 {
            let startIndex = self.index(self.startIndex, offsetBy: addIndex * 2)
            let endIndex = self.index(self.startIndex, offsetBy: addIndex * 2 + 1)
            
            guard let addNumber = Int(self[startIndex...endIndex]) else { return [] }
            separatedArray.append(addNumber)
        }

        return separatedArray
    }
}
