//
//  ChartViewModel.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/11/15.
//

import UIKit
import Charts
import RealmSwift

final class ChartViewModel {
    
    let database = DataBaseManager.shared
    let calendar = Calendar.current
    
    // 1~12월까지의 임시 데이터 배열을 생성한다.
    // MARK: - 문제가, 이 함수가 자꾸 로드됌. 이런.. 이걸 년도가 바뀌었을 때에만! 실행되도록 refactoring 해보기.
    private func makeYearData() -> [LottoItem] {
        var array = [LottoItem]()
        for month in 1...12 {
            array.append(LottoItem(buyMonth: month, buyAmount: 0, winAmount: 0))
        }
        return array
    }
    
    // 특정 년도가 같은 데이터를 Realm에서 filter하는 함수
    func filterDataByYear(year: Int) -> [LottoItem] {
        let filteredYear = database.read(LottoRealm.self).filter { lottoRealm -> Bool in
            let components = self.calendar.component(.year, from: lottoRealm.date)
            return components == year
        }
        return convertToLottoItem(from: filteredYear)
    }
    
  
    // 임시 배열을 생성하고, 거기에 Realm에서 불러온 데이터를 합산해 월별 데이터로 총합 만들기
    private func convertToLottoItem(from lottoRealm: LazyFilterSequence<Results<LottoRealm>>) -> [LottoItem] {
        
        var allData = makeYearData()
        
        lottoRealm.forEach { eachData in
            let month = self.calendar.component(.month, from: eachData.date)
            var monthlyData: LottoItem = allData[month - 1]
            monthlyData.buyAmount += eachData.purchaseAmount
            monthlyData.winAmount += eachData.winAmount ?? 0
            
            allData[month - 1] = monthlyData
        }
        
        return allData
    }
    
    
    // 1. BarChartDataEntry 변환하기.
    // BarChartDataEntry의 x, y는 모두 Double 타입
    // chart는 년단위로 로드되기 때문에, year 파라미터로 받아 데이터 조회
    private func setBarChartDataEntry(year: Double, completion: (BarChartDataSet) -> BarChartDataSet) -> BarChartDataSet {
        let yearLottoItem: [LottoItem] = filterDataByYear(year: Int(year))
        
        // rowData를 BarChartDataEntry(x:,y:)로 변환
        let dataEntry = yearLottoItem.map { BarChartDataEntry(x: Double($0.buyMonth), y: $0.winAmount - $0.buyAmount) }
        
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
