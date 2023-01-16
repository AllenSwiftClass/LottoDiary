//
//  LottoQRModel.swift
//  LottoDiary
//
//  Created by 송선진 on 2023/01/16.
//

import UIKit

final class LottoQRViewModel {
    
    func separateLottoURL(lottoURL: String) {
        // TR번호
        let startIndex = lottoURL.index(lottoURL.endIndex, offsetBy: -10)
        let TRNumber = lottoURL[startIndex...]
        
        var lottoTotalNumber = lottoURL.dropLast(10).components(separatedBy: "m")
        // 회차번호
        let roundNumber = lottoTotalNumber.removeFirst()
        // 구매금액
        let buyAmount = (lottoTotalNumber.count) * 1000
        // 로또 번호
        let lottoNumber = lottoTotalNumber.map { $0.separateNumber }
        
        print(TRNumber, roundNumber, buyAmount, lottoNumber)
        
        LottoQRNetworkManager.shared.fetchLottoResult(roundNumber: roundNumber) { [weak self] result in
            switch result {
            case .success(let lottoResult):
                print(lottoResult)
                self?.compareLottoNumbers(buyNumbers: lottoNumber, resultNumbers: lottoResult)
            case .failure(let error):
                // 로또 회차 로드가 안되는 경우 (ex. 이미 결과발표가 안된 회차)
                // 구매한 로또 번호만 저장하고, 달력 페이지로 넘어가기
                print(error.localizedDescription)
            }
        }
    }
    
    // 당첨 번호 비교하는 함수
    func compareLottoNumbers(buyNumbers: [[Int]], resultNumbers: LottoResultSorted) {
        print("당첨 번호 비교 함수")

        var matchResult: [Int] = []
        
        buyNumbers.forEach { rowNum in
            var count = 0
            resultNumbers.lottoResultNumber.forEach { resultNum in
                if rowNum.contains(resultNum) {
                    count += 1
                }
            }
            
            if count == 6 {
                matchResult.append(1)
            } else if count == 5 {
                rowNum.contains(resultNumbers.bonusNumber) ? matchResult.append(2) : matchResult.append(3)
            } else if count == 4 {
                matchResult.append(4)
            } else if count == 3 {
                matchResult.append(5)
            } else {
                matchResult.append(0)
            }
        }
        print(matchResult)
    }
}


