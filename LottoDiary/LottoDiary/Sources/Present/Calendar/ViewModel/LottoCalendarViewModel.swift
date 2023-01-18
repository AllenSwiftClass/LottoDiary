//
//  LottoCalendarViewModel.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//


import RxSwift
import Foundation

final class LottoCalendarViewModel {
    
    let database = DataBaseManager.shared
    
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
        ]
        
        lottoObservable.onNext(lottos)
    }
    
}


