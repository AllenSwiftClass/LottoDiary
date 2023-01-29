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
    static var lastDrawDatas: [LottoData] = {
        let lottoQRViewModel = LottoQRViewModel()
        let standardRound = 1033
        
        return [ lottoQRViewModel.makeLottoData(standardRound: standardRound),
                 lottoQRViewModel.makeLottoData(standardRound: standardRound - 1),
                 lottoQRViewModel.makeLottoData(standardRound: standardRound - 2)
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
