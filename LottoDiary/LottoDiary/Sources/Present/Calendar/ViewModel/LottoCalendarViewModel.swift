//
//  LottoCalendarViewModel.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//


import RxSwift
import Foundation
import RealmSwift

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
    
    lazy var selectedDate: Date = Date()
    
    // 지나간 결과가 아닌 로또들은 당첨금액이 없는 상태인데도 일단 로또로 뽑아줘야 함.
    // hasPassedResult
    func convertLottoRealmToLottos(lottoRealms: Results<LottoRealm>) -> [Lotto] {
        // 결과를 가지고있다면
        var lottos: [Lotto] = []
        lottoRealms.forEach {
            lottos.append(Lotto(type: LottoType(rawValue: $0.type)!,
                                purchaseAmount: $0.purchaseAmount,
                                winAmount: $0.winAmount,
                                date: $0.date))
        }
        return lottos
    }
    
    init() {
        let lottoRealms = database.read(LottoRealm.self)

        let lottos = convertLottoRealmToLottos(lottoRealms: lottoRealms)
        
        lottoObservable.onNext(lottos)
    }
    
}


