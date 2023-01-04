//
//  User.swift
//  LottoDiary
//
//  Created by 천승현 on 2023/01/04.
//

import RealmSwift
import Foundation

class User: Object {
    @objc dynamic var nickName: String = ""
    @objc dynamic var notificationCycle: String = ""
    var goalAmounts = List<GoalAmount>()
    
    convenience init(nickName: String, notificationCycle: String) {
        self.init()
        self.nickName = nickName
        self.notificationCycle = notificationCycle
    }
}

class GoalAmount: Object {
    @objc dynamic var date: Date = Date()
    @objc dynamic var goalAmount: Int = 0
    
    convenience init(date: Date, goalAmount: Int) {
        self.init()
        self.date = date
        self.goalAmount = goalAmount
    }
}
