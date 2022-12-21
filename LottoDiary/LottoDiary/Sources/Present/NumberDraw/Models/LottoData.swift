//
//  LottoData.swift
//  LottoDiary
//
//  Created by uiskim on 2022/12/07.
//

import UIKit

struct LottoData {
    let turnNumber: Int
    let numbers: [Int]
}

extension LottoData {
    static let lastDrawDatas: [LottoData] = [
        LottoData(turnNumber: 1033, numbers: [1,2,3,4,5,6,7]),
        LottoData(turnNumber: 1034, numbers: [8,9,10,11,12,13,14]),
        LottoData(turnNumber: 1035, numbers: [15,16,17,18,19,20,21])
    ]
}
