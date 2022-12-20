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
            
            // 예시) "http://m.dhlottery.co.kr/?v=0868m041120213645m010306132438m142933354042m021823262731m1217284143441293818248"
            // 1. components(separatedBy: "=")[1] : 로또QR 주소 중 = 이후 회차번호,로또 번호들이 나열되어있음. = 를 기준으로 나눈 후 [1]을 부르면 회차번호, 로또 번호들만 추출
            // 2. .dropLast(10) : 맨 마지막 번호 중 마지막 10자리는 TR 번호이다. 우리는 TR번호가 쓸모 없기 때문에 마지막 10자리는 삭제
            // lottoTotalNumber : m을 기준으로 회차번호, 로또번호
            guard let lottoURL = result?.value.components(separatedBy: "=")[1]  else { return }
                
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
            
            print(lottoURL)
            print(TRNumber, roundNumber, buyAmount, lottoNumber)
            
            self.networkManager.fetchLottoResult(roundNumber: roundNumber) { result in
                switch result {
                case .success(let lottoResult):
                    print(lottoResult)
                    compareLottoNumbers(buyNumbers: lottoNumber, resultNumbers: lottoResult)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        // 당첨 번호 비교하는 함수
        func compareLottoNumbers(buyNumbers: [[Int]], resultNumbers: LottoResult) {
            print("당첨 번호 비교 함수")
        }
        
        // 로또QR 카메라 화면 push
        // LottoQR 버튼 클릭하면 QR화면으로 전환
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        tabBar.middleBtnActionHandler = {
            self.navigationController?.pushViewController(self.readerVC, animated: true)
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
    // QR 인식이 성공하면 실행되는 코드
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        print("reader 완료")
        
        // popViewController로 rederView 날리기
        self.navigationController?.popViewController(animated: true)
        // QR 인식 성공 후 calendarView로 넘어가기
        self.selectedIndex = 0
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true)
    }
}
