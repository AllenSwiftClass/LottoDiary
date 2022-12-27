//
//  TabBarController.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/12/02.
//

import UIKit
import QRCodeReader
import AVFoundation

final class TabBarController: UITabBarController {
    
    var networkManager = LottoQRNetworkManager.shared
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
//            let readerView = QRCodeReaderContainer(displayable: LottoQRView())
//            $0.readerView = readerView
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // 플래시 버튼
            $0.showTorchButton = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton = false
            $0.showOverlayView = true
            // 가이드라인 선
            $0.rectOfInterest = CGRect(x: 0.2, y: 0.3, width: 0.6, height: 0.3)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Date())
        
        tabBarConfigure()
        setupTabBar()
        setupLottoQR()
    }
    
    private func tabBarConfigure() {
        // customTabBar 등록
        setValue(CustomTabBar(frame: tabBar.frame), forKey: "tabBar")
        delegate = self
    }
    
    private func setupTabBar() {
        
        let calendar = naviController(image: UIImage(systemName: "calendar.badge.plus"), title: "달력", rootViewController: LottoCalendarViewController())
        let home = naviController(image: UIImage(systemName: "house"), title: "홈", rootViewController: HomeViewController())
        let chart = naviController(image: UIImage(systemName: "chart.bar"), title: "차트", rootViewController: ChartLottoListViewController())
        let num = naviController(image: UIImage(systemName: "number.circle"), title: "번호 추첨", rootViewController: RandomLottoNumberViewController())
        
        self.viewControllers = [ calendar, home, UIViewController() , chart, num ]
    }
    
    func naviController(image: UIImage!, title: String, rootViewController: UIViewController) -> UINavigationController {
        
        let navi = UINavigationController(rootViewController: rootViewController)
        navi.tabBarItem.title = title
        navi.tabBarItem.image = image
        return navi
    }
    
    func setupLottoQR() {
        readerVC.delegate = self
        
        self.readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            
            // 로또 번호 주소가 올바르지 않을 경우
            guard (result?.value.contains("http://m.dhlottery.co.kr/?v=")) == true else {
                // 로또 번호가 맞지 않으면 alert 보내기
                makeWrongAlert()
                return
            }
            
            // 예시) "http://m.dhlottery.co.kr/?v=0868m041120213645m010306132438m142933354042m021823262731m1217284143441293818248"
            // 1. components(separatedBy: "=")[1] : 로또QR 주소 중 = 이후 회차번호,로또 번호들이 나열되어있음. = 를 기준으로 나눈 후 [1]을 부르면 회차번호, 로또 번호들만 추출
            // 2. .dropLast(10) : 맨 마지막 번호 중 마지막 10자리는 TR 번호이다. 우리는 TR번호가 쓸모 없기 때문에 마지막 10자리는 삭제
            // lottoTotalNumber : m을 기준으로 회차번호, 로또번호
            
            guard let lottoURL = result?.value.components(separatedBy: "=")[1]  else {
                makeWrongAlert()
                return
            }
                
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
            
            self.networkManager.fetchLottoResult(roundNumber: roundNumber) { result in
                switch result {
                case .success(let lottoResult):
                    print(lottoResult)
                    compareLottoNumbers(buyNumbers: lottoNumber, resultNumbers: lottoResult)
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
        
        func makeWrongAlert() {
            let wrongAlert = UIAlertController(title: "잘못된 로또 QR입니다.", message: "올바른 로또 QR을 인식해주세요." , preferredStyle: .alert)
            
            // Alert 창 구현
            let wrongAlertConfirm = UIAlertAction(title: "확인", style: .default) { [self] _ in
                readerVC.startScanning()
            }
            wrongAlert.addAction(wrongAlertConfirm)
            present(wrongAlert, animated: true)
        }
        
        // 로또QR 카메라 화면 push
        // LottoQR 버튼 클릭하면 QR화면으로 전환
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        tabBar.middleBtnActionHandler = {
            self.navigationController?.pushViewController(self.readerVC, animated: true)
        }
        
        func loadLastResult() {
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    
    /*
     middleButton은 tabBar item[2]의 구역에 존재하지만, 포함되지 않는 부분도 존재.
     hitTest로 middleButton 전역이 눌릴 수 있도록 구현했으니, middleButton이 아닌 tabBar item[2]의 부분이 눌리지 않도록 tabBar item[2]를 비활성화 시킴.(select을 false로)
     */
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        return selectedIndex == 2 ? false : true
    }
}

// MARK: - QRCodeReaderViewControllerDelegate

extension TabBarController: QRCodeReaderViewControllerDelegate {
    // QR 인식이 성공하면(올바른 로또QR X, 인식이 성공되었을 때) 실행되는 코드
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print("reader 완료")
        
        let okAlert = UIAlertController(title: "로또 QR 인식에 성공하였습니다.", message: "로또 달력으로 이동합니다." , preferredStyle: .alert)

        // Alert 창 구현
        let okAlertConfirm = UIAlertAction(title: "확인", style: .default) { action in
            reader.stopScanning()
            // popViewController로 rederView 날리기
            self.navigationController?.popViewController(animated: true)
            // QR 인식 성공 후 calendarView로 넘어가기
            self.selectedIndex = 0
        }
        okAlert.addAction(okAlertConfirm)
        present(okAlert, animated: true)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true)
    }
}
