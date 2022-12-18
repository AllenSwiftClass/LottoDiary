//
//  calendarView.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import FSCalendar
import SnapKit

final class LottoCalendar: FSCalendar {
    
    lazy var expandButton: ExpandButton = {
        let button = ExpandButton(frame: .zero)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCalendar()
        configureExpandButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCalendar() {
        locale = Locale(identifier: "ko_KR")
        backgroundColor = .designSystem(.gray17181D)
        scrollEnabled = true
        
        // 커스텀 헤더를 쓰기때문에 기본 폰트는 0으로 -> 0으로 하지않으면 스와이프 시 기존의 값이 잠시 보여진다.
        appearance.headerTitleFont = .gmarksans(weight: .regular, size: ._0)
        // header Title이 덜 왼쪽으로 가있어서 offSet속성으로 설정
        appearance.headerTitleAlignment = .left
        // 헤더의 높이
        headerHeight = 80.0
        if UIScreen.main.bounds.width < 400 {
            appearance.headerTitleOffset = CGPoint(x: self.frame.origin.x - 75 , y: self.frame.origin.y)
        } else {
            appearance.headerTitleOffset = CGPoint(x: self.frame.origin.x - 85 , y: self.frame.origin.y)
        }
        
        
        // 일월화수목금토의 font크기 굵게
        appearance.weekdayFont = .designSystem(weight: .bold, size: ._15)
        
        // day의 font크기 굵게
        appearance.titleFont = .designSystem(weight: .bold, size: ._15)
        
        // 달력의 요일 글자 색깔
        appearance.weekdayTextColor = .designSystem(.gray63626B)
        
        // 오늘날짜 색상 설정
        appearance.todayColor = .designSystem(.gray63626B)?.withAlphaComponent(0.3)
        
        // 현재 월 빼고 안보이게
        placeholderType = .none
        
        // title 옆 숨기게
        appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 이벤트 표시 색상
        appearance.eventDefaultColor = UIColor.green
        appearance.eventSelectionColor = UIColor.green
    }
    
    func configureExpandButton() {
        self.addSubview(expandButton)
        expandButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    
}

