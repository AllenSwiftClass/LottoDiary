//
//  ChartViewModel.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/11/15.
//

import UIKit
import Charts

class ChartViewModel {
    
    let lottoListViewModel = LottoListViewModel()
    
    // 1. BarChartDataEntry 변환하기.
    // BarChartDataEntry의 x, y는 모두 Double 타입
    // chart는 년단위로 로드되기 때문에, year 파라미터로 받아 데이터 조회
    private func setBarChartDataEntry(year: Double, completion: (BarChartDataSet) -> BarChartDataSet) -> BarChartDataSet {
        // 년도 별 데이터 추출
        let rowData = LottoItem.rowData.filter { $0.buyYear == year }
        
        var yearLottoItem: [LottoItem] = []
        
        // 만약 특정 년도 데이터가 2월, 4월 등 1~12월 모두 있는 경우가 아닐때, 데이터가 없는 월 차트 채워주기
        rowData.forEach { eachData in
            for month in 1...12 {
                // buyYear은 있는데 buyMonth는 없는 데이터는 없으므로 강제 !
                if month == Int(eachData.buyMonth) {
                    yearLottoItem.append(eachData)
                } else {
                    // 데이터가 저장되지 않은 month는 buyAmount, winAmount, goalAmount 중 단 하나도 데이터가 없기 때문에 모두 0으로 설정
                    yearLottoItem.append(LottoItem(buyYear: year, buyMonth: Double(month), buyAmount: 0, winAmount: 0, goalAmount: 0))
                }
            }
        }
        
        // rowData를 BarChartDataEntry(x:,y:)로 변환
        let dataEntry = yearLottoItem.map { BarChartDataEntry(x: $0.buyMonth, y: $0.winAmount - $0.buyAmount) }
        
        // BarChartDataEntry를 BarChartDataSet으로 변환하기 위해 completion으로 넘김.
        let dataSet = completion(setBarChartDataSet(dataEntry: dataEntry, completion: {$0}))
        
        return dataSet
    }
    
    // 2. BarChartDataSet 변환하기
    private func setBarChartDataSet(dataEntry: [BarChartDataEntry], completion: (BarChartDataSet) -> BarChartDataSet) -> BarChartDataSet {
        
        let dataSet = BarChartDataSet(entries: dataEntry)
        dataSet.colors = [ NSUIColor.designSystem(.mainBlue)! ]
        // bar 위 숫자 설정
        dataSet.drawValuesEnabled = false
        
        return dataSet
    }
    
    // 3. BarChartData 변환하기
    func setBarChartData(year: Double) -> BarChartData {
        
        let chartData = setBarChartDataEntry(year: year) { $0 }
        let data = BarChartData(dataSet: chartData)
        
        return data
    }
}
