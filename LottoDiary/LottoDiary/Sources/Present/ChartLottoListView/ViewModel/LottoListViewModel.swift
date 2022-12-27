//
//  LottoListViewModel.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/11/28.
//

import UIKit

final class LottoListViewModel {
    
    typealias GoalResult = LottoListDataSourceController.GoalResult
    typealias Amount = LottoListDataSourceController.Amount
    
    // rowData에서 특정 년도, 월 데이터 뽑아내기
    func getMonthList(year: Double, month: Double) -> LottoItem {
        let data = LottoItem.rowData.filter { $0.buyYear == year && $0.buyMonth == month }
        
        // 만약 특정 년, 월의 데이터가 없다면?
        if data.isEmpty {
            return LottoItem(buyYear: year, buyMonth: month, buyAmount: 0, winAmount: 0, goalAmount: 0)
        } else {
            return data[0]
        }
    }
    
    // 특정 년, 월의 당첨 퍼센테이지 구하기
    func getMonthPercent(year: Double, month: Double) -> [GoalResult : Int] {
        let monthData = self.getMonthList(year: year, month: month)
        var result = GoalResult.percent
        let goalAmount = monthData.goalAmount
        let buyAmount = monthData.buyAmount
        let winAmount = monthData.winAmount
        
        var percent = ((winAmount - buyAmount) / buyAmount) * 100
        
        if buyAmount == 0 && winAmount == 0 {
            result = .percent
            percent = 0
        } else if Int(goalAmount) >= Int(buyAmount) {
            result = .success
        } else {
            result = .fail
        }
        return [result : Int(percent)]
    }
    
    // 오늘 날짜 구하기
    func getTodayDate() -> [Double] {
        let yearFormatter = DateFormatter()
        let monthFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        monthFormatter.dateFormat = "MM"
        
        let date = Date()
        guard let thisYear = Double(yearFormatter.string(from: date)) else { return [] }
        guard let thisMonth = Double(monthFormatter.string(from: date)) else { return [] }
        
        return [ thisYear, thisMonth ]
    }
    
    // datePicker 구현시, 년도(1년부터 오늘 년도까지)와 월 설정
    // 오늘 날짜 기준으로 picker component 구성
    func getPickerDays() -> [[Double]] {
        var year: [Double] = []
        let month: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        let thisYear = self.getTodayDate()[0]
        for num in stride(from: thisYear, to: 1, by: -1) {
            year.append(num)
        }
        return [year, month]
    }

    func makeAmountData(year: Double, month: Double) -> [Amount] {
        
        // 1. 특정 년, 월 데이터를 가져온다.
        let data = self.getMonthList(year: year, month: month)
        let percentData = self.getMonthPercent(year: year, month: month).first
        
        // 2. 데이터를 Amount에 넣어 새로운 Amount 객체를 생성한다.
        let item1 = Amount(amount: data.goalAmount, result: percentData?.key)
        
        let item2 = Amount(amount: data.buyAmount, result: percentData?.key)
        
        let item3 = Amount(amount: data.winAmount, percent: percentData?.value)
        
        // goal, buy, win 총 3개의 Amount 가 생성되어야 한다.
        return [item1, item2, item3]
    }
}


// delegate protocol 설정할때, AnyObject 명시하면 weak 사용으로 Memory Leak문제 해결 가능
// LottoListHeader -> ChartViewController간 selectedYear/Month 공유
protocol LottoListHeaderDelegate: AnyObject {
    func didSelectedDate(year: Double, month: Double)
}

