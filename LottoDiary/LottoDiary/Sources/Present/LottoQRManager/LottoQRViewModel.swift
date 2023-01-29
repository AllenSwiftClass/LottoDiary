//
//  LottoQRModel.swift
//  LottoDiary
//
//  Created by 송선진 on 2023/01/16.
//

import UIKit
import QRCodeReader

final class LottoQRViewModel {
    
    func check(result: QRCodeReaderResult?) -> String? {
        // 로또 번호 주소가 올바르지 않을 경우
        guard (result?.value.contains("http://m.dhlottery.co.kr/?v=")) == true else {
            return nil
        }
        
        // 예시) "http://m.dhlottery.co.kr/?v=0868m041120213645m010306132438m142933354042m021823262731m1217284143441293818248"
        // 1. components(separatedBy: "=")[1] : 로또QR 주소 중 = 이후 회차번호,로또 번호들이 나열되어있음. = 를 기준으로 나눈 후 [1]을 부르면 회차번호, 로또 번호들만 추출
        // 2. .dropLast(10) : 맨 마지막 번호 중 마지막 10자리는 TR 번호이다. 우리는 TR번호가 쓸모 없기 때문에 마지막 10자리는 삭제
        // lottoTotalNumber : m을 기준으로 회차번호, 로또번호
        guard let lottoURL = result?.value.components(separatedBy: "=")[1]  else {
            return nil
        }
        return lottoURL
    }
    
    func separate(lottoURL: String) {
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
        getLottoResult(from: roundNumber, buyNumbers: lottoNumber)
    }
    
    // 로또 API를 이용해 회차번호로 로또결과 가져오기
    private func getLottoResult(from roundNumber: String, buyNumbers: [[Int]]) {
        
        //        LottoQRNetworkManager.shared.fetchLottoResult(roundNumber: roundNumber) { [weak self] result in
        //            switch result {
        //            case .success(let lottoResult):
        //                print(lottoResult)
        //                self?.compare(buyNumbers: buyNumbers, resultNumbers: lottoResult)
        //            case .failure(let error):
        //                // 로또 회차 로드가 안되는 경우 (ex. 이미 결과발표가 안된 회차)
        //                // 구매한 로또 번호만 저장하고, 달력 페이지로 넘어가기
        //                print(error.localizedDescription)
        //            }
        //        }
        networkTest(roundNumber: roundNumber) { result in
            self.compare(buyNumbers: buyNumbers, resultNumbers: result)
        }
    }
    
    private func networkTest(roundNumber: String, completion: @escaping (LottoResultSorted)->Void) {
        LottoQRNetworkManager.shared.fetchLottoResult(roundNumber: roundNumber) { result in
            switch result {
            case .success(let lottoResult):
                // 여기 위에서는 compare함수 부르기 위한 클로저고, randomNum에서는 로또결과 불러서 화면에 보여주기 위해서고.
                completion(lottoResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // 당첨 번호 비교하는 함수
    private func compare(buyNumbers: [[Int]], resultNumbers: LottoResultSorted) {
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
    
    func makeLottoData(standardRound: Int) -> LottoData {
        let lottoQRViewModel = LottoQRViewModel()
        var array = [Int]()
        
        let group = DispatchGroup()
        group.enter()
        lottoQRViewModel.networkTest(roundNumber: String(standardRound)) { result in
            array = result.lottoResultNumber
            array.append(result.bonusNumber)
            group.leave()
        }
        group.wait()
        return LottoData(turnNumber: standardRound, numbers:array)
    }
}


