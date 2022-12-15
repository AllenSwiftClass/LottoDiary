//
//  LottoCalendarViewModel.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//


import RxSwift
import Foundation

final class LottoCalendarViewModel {
    
    // 날짜 변환 객체
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    lazy var lottoObservable = BehaviorSubject<[Lotto]>(value: [])
    
    lazy var filteredLottos = lottoObservable.map {
        $0.filter{ $0.date ==  self.selectedDate }
    }
    
    lazy var selectedDate: String = formatter.string(from: Date())
    
    init() {
        let lottos: [Lotto] = [
            Lotto(type: .lotto, purchaseAmount: 13330000, winningAmount: 500, date: "2022-11-13"),
            Lotto(type: .spitto, purchaseAmount: 20000, winningAmount: 15000, date: "2022-11-13"),
            Lotto(type: .lotto, purchaseAmount: 13330000, winningAmount: 500, date: "2022-11-17"),
            Lotto(type: .spitto, purchaseAmount: 20000, winningAmount: 15000, date: "2022-11-18"),
            Lotto(type: .spitto, purchaseAmount: 20001, winningAmount: 15000, date: "2022-11-18"),
            Lotto(type: .spitto, purchaseAmount: 20000, winningAmount: 15000, date: "2022-11-18"),
            Lotto(type: .spitto, purchaseAmount: 20000, winningAmount: 15000, date: "2022-11-18"),
            Lotto(type: .spitto, purchaseAmount: 20000, winningAmount: 15000, date: "2022-11-18"),
            Lotto(type: .spitto, purchaseAmount: 20000, winningAmount: 15000, date: "2022-11-18"),
            Lotto(type: .spitto, purchaseAmount: 20000, winningAmount: 15000, date: "2022-11-18"),
            Lotto(type: .lotto, purchaseAmount: 13330000, winningAmount: 500, date: "2022-11-19"),
            Lotto(type: .spitto, purchaseAmount: 20000, winningAmount: 15000, date: "2022-11-20"),
            Lotto(type: .lotto, purchaseAmount: 30000, winningAmount: 2000, date: "2022-11-24"),
            Lotto(type: .lotto, purchaseAmount: 30000, winningAmount: 2000, date: "2022-11-25"),
            Lotto(type: .spitto, purchaseAmount: 30000, winningAmount: 2000, date: "2022-11-30"),
            Lotto(type: .spitto, purchaseAmount: 30000, winningAmount: 2000, date: "2022-11-30"),
        ]
        
        lottoObservable.onNext(lottos)
    }
    
}


