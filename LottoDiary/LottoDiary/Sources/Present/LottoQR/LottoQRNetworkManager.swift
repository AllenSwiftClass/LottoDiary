//
//  LottoQRViewModel.swift
//  LottoDiary
//
//  Created by 송선진 on 2022/12/19.
//

import UIKit

// MARK: - Network error 정의

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

// MARK: - Networking 모델

final class LottoQRNetworkManager {
    
    static let shared = LottoQRNetworkManager()
    private init() {}
    
    typealias NetworkCompletion = (Result<LottoResultSorted, NetworkError>) -> Void
    
    // 네트워킹 요청하는 함수
    func fetchLottoResult(roundNumber: String, completion: @escaping NetworkCompletion) {
        // 로또 결과 가져오는 함수
        let urlString = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(roundNumber)"
        
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    // 실제 Request하는 함수 (비동기적 실행 -> 클로저 방식으로 끝난 시점을 전달 받도록 설계)
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        
        // URL 구조체 만들기
        guard let url = URL(string: urlString) else { return }
        
        // URL요청 생성 -> 작업 세션 시작
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            
            // 1. 에러 있다면,
            if error != nil {
                print("performRequest error: \(error!)")
                completion(.failure(.networkingError))
                return
            }
            
            // 2. data == nil이라면,
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 3. 성공시
            if let lottoData = self.parseJSON(safeData) {
                print("Parse 실행")
                let numberArray = [lottoData.drwtNo1.insertZero, lottoData.drwtNo2.insertZero, lottoData.drwtNo3.insertZero, lottoData.drwtNo4.insertZero, lottoData.drwtNo5.insertZero, lottoData.drwtNo6.insertZero].sorted().joined()
                let lottoResultSorted = LottoResultSorted(lottoResultNumber: numberArray, roundNumber: lottoData.drwNo, bonusNumber: lottoData.bnusNo.insertZero)
                completion(.success(lottoResultSorted))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 받아온 JSON 데이터를 변환하는 함수
    private func parseJSON(_ lottoResultData: Data) -> LottoResult? {
        do {
            // JSON -> LottoResult 변환
            let lottoData = try JSONDecoder().decode(LottoResult.self, from: lottoResultData)
            return lottoData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
