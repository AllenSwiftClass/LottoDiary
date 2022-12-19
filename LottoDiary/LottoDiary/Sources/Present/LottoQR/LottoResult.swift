//
//  LottoResult.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/12/19.
//

import UIKit

// 로또 API에서 받는 정보
struct LottoResult: Codable {
    let returnValue, drwNoDate: String
    let firstWinamnt, firstPrzwnerCo: Int
    // 회차번호
    let drwNo: Int
    let drwtNo5, bnusNo, drwtNo6, drwtNo4: Int
    let drwtNo2, drwtNo3, drwtNo1: Int
}
