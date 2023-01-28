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
//    static let lastDrawDatas: [LottoData] = [
//        LottoData(turnNumber: 1033, numbers: [1,2,3,4,5,6,7]),
//        LottoData(turnNumber: 1034, numbers: [8,9,10,11,12,13,14]),
//        LottoData(turnNumber: 1035, numbers: [15,16,17,18,19,20,21])
//    ]
    
    static var lastDrawDatas: [LottoData] = {
        let lottoQRViewModel = LottoQRViewModel()
        
        return [ lottoQRViewModel.makeLottoData(standardRound: 1033),
                 lottoQRViewModel.makeLottoData(standardRound: 1034),
                 lottoQRViewModel.makeLottoData(standardRound: 1035)
                 ]
    }()
}




/*
 import UIKit

 let standardDate = "2022-12-24"
 var standardRound = 1047
 let today = "2023-01-06"

 let dataFormatter = DateFormatter()
 dataFormatter.dateFormat = "yyyy-MM-dd"

 let startDate = dataFormatter.date(from: standardDate)
 let endDate = dataFormatter.date(from: today)

 let term = Calendar.current.dateComponents([.day], from: startDate!, to: endDate!)

 if term.day! > 7 {
     standardRound += term.day! / 7
    standardDate = Calendar.current.date(byAdding: .day, value: (term.day! / 7)*7, to: standardDate)
 } else {
     if term.day! == 7 {
          standardRound += 1
        standardDate = today
      }
 }
 //print(term.day! / 7)

 print(standardRound)

 */
