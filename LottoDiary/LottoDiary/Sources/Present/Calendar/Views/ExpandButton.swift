//
//  ExpandButton.swift
//  FscalendarLearning
//
//  Created by 천승현 on 2022/11/17.
//

import UIKit
import SnapKit

protocol ExpandButtonDelegate: AnyObject {
    func isMonthChange(_ isMonth: Bool)
}


final class ExpandButton: UIButton {
    
    weak var delegate: ExpandButtonDelegate?
    
    var isMonth: Bool = true {
        didSet {
            self.changeState()
        }
    }
    
    // 스위치 isWeek 값 변경 시 애니메이션 여부
    private var isAnimated: Bool = false

    // 전체 bar 뷰
    private var barView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.masksToBounds = true
        return view
    }()
    
    // 주간일때와 월간일때 변경되는 뷰
    private var stateView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.mainBlue)
        return view
    }()
    
    private var weekLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .bold, size: ._15)
        label.text = "월간"
        label.textColor = .white
        return label
    }()
    
    private var monthLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .bold, size: ._15)
        label.text = "주간"
        label.textColor = .white.withAlphaComponent(0.5)
        return label
    }()

    
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buttonInit(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // borderRadius 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        barView.layer.cornerRadius = barView.frame.size.height / 2.0
        stateView.layer.cornerRadius = stateView.frame.size.height / 2.0
    }
    
    
    // MARK: - func

    
    // 버튼 레이아웃 설정
    private func buttonInit(frame: CGRect) {
        [barView, stateView, weekLabel, monthLabel].forEach{ self.addSubview($0) }
        
        barView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        stateView.snp.makeConstraints { make in
            make.width.equalTo(barView.snp.width).multipliedBy(0.5)
            make.top.equalTo(barView).offset(2)
            make.bottom.equalTo(barView).offset(-2)
            make.leading.equalTo(barView).offset(2)
        }
        
        // button내부에 UIView를 subView로 담게되면 interaction이 되지않는 문제 -> view들의 상호작용 없앰.
        barView.isUserInteractionEnabled = false
        stateView.isUserInteractionEnabled = false
        
        weekLabel.snp.makeConstraints { make in
            make.centerY.equalTo(barView)
            make.leading.equalTo(barView).offset(12.5)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(barView)
            make.trailing.equalTo(barView).offset(-12.5)
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setOn(on: !self.isMonth, animated: true)
    }
            
    func setOn(on: Bool, animated: Bool) {
        self.isAnimated = animated
        self.isMonth = on
    }
    
    // 버튼이 클릭되었을때 stateView의 색상과 위치 변경하는 메서드
    private func changeState() {
        if self.isMonth {
            stateView.backgroundColor = .designSystem(.mainBlue)
            weekLabel.textColor = .white.withAlphaComponent(1)
            monthLabel.textColor = .white.withAlphaComponent(0.5)
            
            stateView.snp.updateConstraints { make in
                make.leading.equalTo(barView).offset(2)
            }
        } else {
            stateView.backgroundColor = .designSystem(.mainOrange)
            monthLabel.textColor = .white.withAlphaComponent(1)
            weekLabel.textColor = .white.withAlphaComponent(0.5)
            
            stateView.snp.updateConstraints { make in
                make.leading.equalTo(barView).offset(50)
            }
        }
        
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        
        delegate?.isMonthChange(isMonth)
        
    }
    
}
