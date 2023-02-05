//
//  LottoListViewModel.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/11/28.
//

import UIKit

final class LottoListViewModel {
    
    let database = DataBaseManager.shared
    let chartViewModel = ChartViewModel()
    let calendar = Calendar.current
    
    typealias GoalResult = LottoListDataSourceController.GoalResult
    typealias Amount = LottoListDataSourceController.Amount
    
    func getMonthList(year: Int, month: Int) -> LottoItem {
        let allData = chartViewModel.filterDataByYear(year: Int(year))
        var data = allData.filter { $0.buyMonth == Int(month) }
        
        data[0].goalAmount = Double(getGoalAmount(year: year, month: month))
        return data[0]
    }
    
    func getGoalAmount(year: Int, month: Int) -> Int {
        // MARK: - 잠시 헷갈리는 것이, 하나의 앱에는 하나의 nickName이 잇는것이 맞는지? 그래서 밑에 코드에는 first로 적음.

        let userGoal = database.read(UserRealm.self).first?.goalAmounts
        let filteredGoal = userGoal?.filter { eachData -> Bool in
            let yearComponents = self.calendar.component(Calendar.Component.year, from: eachData.date)
            let monthComponents = self.calendar.component(Calendar.Component.month, from: eachData.date)
            
            return yearComponents == year && monthComponents == month
        }
        
        guard let result = filteredGoal?.first?.goalAmount else { return 0 }
        return result
    }
    
    // 특정 년, 월의 당첨 퍼센테이지 구하기
    func getMonthPercent(year: Int, month: Int) -> [GoalResult : Int] {
        let monthData = self.getMonthList(year: year, month: month)
        var result = GoalResult.percent
        let goalAmount = monthData.goalAmount ?? 0
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
    func getTodayDate() -> [Int] {
        let yearFormatter = DateFormatter()
        let monthFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        monthFormatter.dateFormat = "MM"
        
        let date = Date()
        guard let thisYear = Int(yearFormatter.string(from: date)) else { return [] }
        guard let thisMonth = Int(monthFormatter.string(from: date)) else { return [] }
        
        return [ thisYear, thisMonth ]
    }
    
    // datePicker 구현시, 년도(1년부터 오늘 년도까지)와 월 설정
    // 오늘 날짜 기준으로 picker component 구성
    func getPickerDays() -> [[Int]] {
        var year: [Int] = []
        let month: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        let thisYear = self.getTodayDate()[0]
        for num in stride(from: thisYear, to: 1, by: -1) {
            year.append(num)
        }
        return [year, month]
    }

    func makeAmountData(year: Int, month: Int) -> [Amount] {
        
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
    func didSelectedDate(year: Int, month: Int)
}

