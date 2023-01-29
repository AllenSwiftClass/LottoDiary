//
//  LottoRealm.swift
//  LottoDiary
//
//  Created by 천승현 on 2023/01/18.
//
import UIKit
import RealmSwift

class LottoRealm: Object {
    @Persisted var id: String = ""
    @Persisted var type: String = ""
    @Persisted var purchaseAmount: Double = 0.0
    @Persisted var winAmount: Double?
    @Persisted var round: Int?
    @Persisted var lottoNumberArray = List<LottoRow>()
    @Persisted var date: Date = Date()
    @Persisted var hasPassedResult: Bool = true
    
    convenience init(id: String, type: String, purchaseAmount: Double, winAmount: Double, date: Date) {
        self.init()
        self.id = id
        self.type = type
        self.purchaseAmount = purchaseAmount
        self.winAmount = winAmount
        self.date = date
    }
}

class LottoRow: Object {
    @Persisted var numbers = List<LottoNumber>()
}

class LottoNumber: Object {
    @Persisted var number: Int?
}
