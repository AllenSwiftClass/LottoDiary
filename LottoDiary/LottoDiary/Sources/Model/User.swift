//
//  User.swift
//  LottoDiary
//
//  Created by 천승현 on 2023/01/04.
//

import RealmSwift
import Foundation

class User: Object {
    @Persisted var nickName: String = ""
    @Persisted var notificationCycle: String = ""
    @Persisted var goalAmounts = List<GoalAmount>()
    
    convenience init(nickName: String, notificationCycle: String) {
        self.init()
        self.nickName = nickName
        self.notificationCycle = notificationCycle
    }
}

class GoalAmount: Object {
    @Persisted var date: Date = Date()
    @Persisted var goalAmount: Int = 0
    
    convenience init(date: Date, goalAmount: Int) {
        self.init()
        self.date = date
        self.goalAmount = goalAmount
    }
}
