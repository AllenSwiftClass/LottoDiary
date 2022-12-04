//
//  LottoCalendarViewController.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import UIKit
import FSCalendar
import SnapKit
import RxSwift


final class LottoCalendarViewController: UIViewController {

    // MARK: - Calendar 관련 변수
    
    lazy var events: [Date] = [] {
        didSet {
            self.calendar.reloadData()
        }
    }
    
    private let calendar = LottoCalendar()
    
    let calendarHeight: CGFloat = 300
    
    let lottos: [Lotto] = [
        Lotto(type: .lotto, purchaseAmount: 13330000, winningAmount: 500, date: "2022-11-13"),
        Lotto(type: .spitto, purchaseAmount: 20000, winningAmount: 15000, date: "2022-11-13"),
        Lotto(type: .lotto, purchaseAmount: 13330000, winningAmount: 500, date: "2022-11-17"),
        Lotto(type: .spitto, purchaseAmount: 20000, winningAmount: 15000, date: "2022-11-18"),
        Lotto(type: .spitto, purchaseAmount: 20001, winningAmount: 15000, date: "2022-11-18"),
        Lotto(type: .spitto, purchaseAmount: 20000, winningAmount: 15000, date: "2022-11-18")
    ]
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .designSystem(.gray17181D)
        
        // 스크롤 뷰 레이아웃 설정
        configureScrollView()
        
        // 캘린더 레이아웃 설정
        configureCalendarLayout()
        // 캘린더 이벤트 등록
        setupEvents()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        changeHeaderTitle()
    }
    

}


// MARK: - ScrollView 관련 함수

extension LottoCalendarViewController {
    func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
    }
}


// MARK: - calendar Func, DataSource, Delegate
extension LottoCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    // MARK: - 메서드
    
    func configureCalendarLayout() {
        contentView.addSubview(calendar)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(calendarHeight)
        }
        
        // expandButton delegate 설정
        calendar.expandButton.delegate = self
    }
    
    func setupEvents() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        
        lottos.forEach { (lotto) in
            let date = formatter.date(from: lotto.date)!
            self.events.append(date)
            
        }
    }
    
    // 헤더의 제목을 attributed 시키는 함수
    func changeHeaderTitle() {
        let currentPageDate = calendar.currentPage
        let year = Calendar.current.component(.year, from: currentPageDate)
        let month = Calendar.current.component(.month, from: currentPageDate)
        let monthName = DateFormatter().monthSymbols[month - 1].capitalized
        
        for cell in calendar.calendarHeaderView.collectionView.visibleCells {
            let attributedString = NSMutableAttributedString(string: "\(year)\n\(monthName)\n")
            
            let attributes0: [NSAttributedString.Key : Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.gmarksans(weight: .light, size: ._22)
                
            ]
            let attributes1: [NSAttributedString.Key : Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.gmarksans(weight: .bold, size: ._15)
            ]
            
            // title 사이에 간격 띄우기
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            
            
            attributedString.addAttributes(attributes0, range: NSRange(location: 0, length: 4))
            attributedString.addAttributes(attributes1, range: NSRange(location: 5, length: 3))
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            
            (cell as! FSCalendarHeaderCell).titleLabel.attributedText = attributedString
        }
    }
    
    // 주, 월 scope 변경
    @objc func switchCalendarScope(_ isMonth: Bool) {
        if isMonth {
            self.calendar.setScope(.month, animated: true)
        } else {
            self.calendar.setScope(.week, animated: true)
        }
        changeHeaderTitle()
    }
    
    
    
    // MARK: - FsCalendarDataSource
    
    // 이벤트 등록
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return self.events.contains(date) ? 1 : 0
    }
    
    
    // MARK: - FscalendarDelegate
    
    // 달력 넘길때 customHeader 적용
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        changeHeaderTitle()
    }
    
    // scope변경 시 Rect수정 델리게이트
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        let boundHeight = bounds.height
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(boundHeight)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            // 애니메이션이 끝난 시점에 custom header 적용
            self.changeHeaderTitle()
        }


        self.view.layoutIfNeeded()
    }
    
}


// MARK: - calendar Appearance Delegate

extension LottoCalendarViewController: FSCalendarDelegateAppearance {
    // weekday마다 색상 설정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let _ = Calendar.current.component(.weekday, from: date) - 1
        return .designSystem(.gray63626B)
    }
    
    // 선택되었을때 셀 배경색
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .designSystem(.gray3C3C47)
    }
    
    // 선택되었을때 셀 border색
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return .designSystem(.gray3C3C47)
    }
    
}


// 확장버튼 델리게이트 메서드
extension LottoCalendarViewController: ExpandButtonDelegate {
    func isMonthChange(_ isMonth: Bool) {
        switchCalendarScope(isMonth)
    }
}
