//
//  TabBarController.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/12/02.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarConfigure()
        setupTabBar()
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
        
        // 로또QR 카메라 화면 전환
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        tabBar.middleBtnActionHandler = {
            self.navigationController?.pushViewController(LottoQRViewController(), animated: true)
        }
    }
    
    func naviController(image: UIImage!, title: String, rootViewController: UIViewController) -> UINavigationController {
        
        let navi = UINavigationController(rootViewController: rootViewController)
        navi.tabBarItem.title = title
        navi.tabBarItem.image = image
        
        // ios13이후로 navigation style관련은 UINavigationBarAppearance를 사용
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        
        
        navi.navigationBar.standardAppearance = navigationBarAppearance
        navi.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        return navi
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    /*
     middleButton은 tabBar item[2]의 구역에 존재하지만, 포함되지 않는 부분도 존재.
     hitTest로 middleButton 전역이 눌릴 수 있도록 구현했으니, middleButton이 아닌 tabBar item[2]의 부분이 눌리지 않도록 tabBar item[2]를 비활성화 시킴.(select을 false로)
     */
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        if selectedIndex == 2 {
            return false
        }
        return true
    }
}
