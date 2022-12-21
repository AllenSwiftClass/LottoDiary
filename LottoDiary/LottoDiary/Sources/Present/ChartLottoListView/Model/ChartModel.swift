//
//  ChartModel.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/12/05.
//

import UIKit

// 서버에서 받아오는 데이터 타입.. 이지만 임의 설정
struct LottoItem {
    var buyYear: Double
    var buyMonth: Double    // BarChartDataEntry에 넣기 편리하도록 Double 타입 선언
    var buyAmount: Double
    var winAmount: Double
    var goalAmount: Double
    
    static var rowData: [LottoItem] = [
        LottoItem(buyYear: 2022, buyMonth: 1, buyAmount: 5000, winAmount: 0, goalAmount: 150000),
        LottoItem(buyYear: 2022, buyMonth: 2, buyAmount: 55000, winAmount: 50000, goalAmount: 10000),
        LottoItem(buyYear: 2022, buyMonth: 3, buyAmount: 35000, winAmount: 100000, goalAmount: 30000),
        LottoItem(buyYear: 2022, buyMonth: 4, buyAmount: 25000, winAmount: 5000, goalAmount: 20000),
        LottoItem(buyYear: 2022, buyMonth: 5, buyAmount: 10000, winAmount: 30000, goalAmount: 10000),
        LottoItem(buyYear: 2022, buyMonth: 6, buyAmount: 5000, winAmount: 0, goalAmount: 15000),
        LottoItem(buyYear: 2022, buyMonth: 7, buyAmount: 10000, winAmount: 2000, goalAmount: 30000),
        LottoItem(buyYear: 2022, buyMonth: 8, buyAmount: 100000, winAmount: 1000, goalAmount: 50000),
        LottoItem(buyYear: 2022, buyMonth: 9, buyAmount: 15000, winAmount: 5000, goalAmount: 30000),
        LottoItem(buyYear: 2022, buyMonth: 10, buyAmount: 170000, winAmount: 100000, goalAmount: 18000),
        LottoItem(buyYear: 2022, buyMonth: 11, buyAmount: 35000, winAmount: 6000, goalAmount: 50000),
        LottoItem(buyYear: 2022, buyMonth: 12, buyAmount: 2000, winAmount: 82000, goalAmount: 10000),
        
        LottoItem(buyYear: 2021, buyMonth: 1, buyAmount: 5000, winAmount: 500000, goalAmount: 150000),
        LottoItem(buyYear: 2021, buyMonth: 2, buyAmount: 55000, winAmount: 50000, goalAmount: 10000),
        LottoItem(buyYear: 2021, buyMonth: 3, buyAmount: 35000, winAmount: 100000, goalAmount: 30000),
        LottoItem(buyYear: 2021, buyMonth: 4, buyAmount: 25000, winAmount: 5000, goalAmount: 20000),
        LottoItem(buyYear: 2021, buyMonth: 5, buyAmount: 10000, winAmount: 30000, goalAmount: 10000),
        LottoItem(buyYear: 2021, buyMonth: 6, buyAmount: 5000, winAmount: 0, goalAmount: 15000),
        LottoItem(buyYear: 2021, buyMonth: 7, buyAmount: 10000, winAmount: 2000, goalAmount: 30000),
        LottoItem(buyYear: 2021, buyMonth: 8, buyAmount: 100000, winAmount: 1000, goalAmount: 50000),
        LottoItem(buyYear: 2021, buyMonth: 9, buyAmount: 15000, winAmount: 5000, goalAmount: 30000),
        LottoItem(buyYear: 2021, buyMonth: 10, buyAmount: 170000, winAmount: 100000, goalAmount: 18000),
        LottoItem(buyYear: 2021, buyMonth: 11, buyAmount: 35000, winAmount: 6000, goalAmount: 50000),
        LottoItem(buyYear: 2021, buyMonth: 12, buyAmount: 2000, winAmount: 82000, goalAmount: 10000),
    
        LottoItem(buyYear: 2020, buyMonth: 2, buyAmount: 15000, winAmount: 5000, goalAmount: 30000),
        LottoItem(buyYear: 2020, buyMonth: 5, buyAmount: 170000, winAmount: 100000, goalAmount: 18000),
        LottoItem(buyYear: 2020, buyMonth: 8, buyAmount: 35000, winAmount: 6000, goalAmount: 50000),
        LottoItem(buyYear: 2020, buyMonth: 12, buyAmount: 2000, winAmount: 82000, goalAmount: 10000)
    ]
}

