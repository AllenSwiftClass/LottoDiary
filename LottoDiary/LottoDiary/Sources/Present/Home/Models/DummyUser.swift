//
//  DummyUser.swift
//  LottoDiary
//
//  Created by uiskim on 2022/12/18.
//

import Foundation

struct DummyUser {
    let nickName: String
    let goal: Double
    let usage: Double
    let winPrice: Double
    
    var goalPercentage: Int {
        return Int(usage/goal * 100)
    }
}

let testUser = DummyUser(nickName: "Brody", goal: 100000.0, usage: 78000.0, winPrice: 50000.0)
