//
//  Lotto.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import Foundation
import UIKit

// 로또 타입
enum LottoType: String {
    case lotto = "로또"
    case spitto = "스피또"
}

struct Lotto: Equatable, Identifiable  {
    
    var id: String = UUID().uuidString
    var type: LottoType = .lotto
    var name: String {
        switch type {
        case .lotto: return "로또"
        case .spitto: return "스피또"
        }
    }
    var image: UIImage {
        switch type {
        case .lotto: return UIImage()
        case .spitto: return UIImage()
        }
    }
    var purchaseAmount: Int
    var winningAmount: Int
    var date: String
    
    init(type: LottoType, purchaseAmount: Int, winningAmount: Int, date: String) {
        self.type = type
        self.purchaseAmount = purchaseAmount
        self.winningAmount = winningAmount
        self.date = date
    }
}

// id값을 받아 인덱스 값을 리턴하는 배열 확장
extension Array where Element == Lotto {
    func indexOfLotto(with id: Lotto.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError("error occurred while retrieving the index using the ID of the lotto.")
        }
        return index
    }
}
