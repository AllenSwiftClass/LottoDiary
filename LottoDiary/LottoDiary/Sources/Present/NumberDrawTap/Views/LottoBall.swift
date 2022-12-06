//
//  LottoBall.swift
//  LottoDiary
//
//  Created by uiskim on 2022/12/06.
//

import UIKit
import SnapKit

enum LottoType {
    case oneTwoThree
    case four
    case five
    case six
    case bonuns
    
    var ballColor: UIColor {
        switch self {
        case .oneTwoThree:
            return .designSystem(.mainYellow)!
        case .four:
            return .designSystem(.mainBlue)!
        case .five, .bonuns:
            return .designSystem(.mainOrange)!
        case .six:
            return .designSystem(.mainGreen)!
        }
    }
}

class LottoBall: UIView {
    
    static let ballSize = 38
    
    var ballNumber: Int {
        didSet {
            self.ballNumberLabel.text = String(ballNumber)
        }
    }
    
    let ballNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .bold, size: ._13)
        label.textColor = .designSystem(.white)
        label.textAlignment = .center
        return label
    }()
    
    init(lottoType: LottoType, LottoNumber: Int = .random(in: Int.lottoRange)) {
        ballNumber = LottoNumber
        super.init(frame: .zero)
        self.backgroundColor = lottoType.ballColor
        self.ballNumberLabel.text = String(LottoNumber)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(LottoBall.ballSize / 2)
        addSubview(ballNumberLabel)
        ballNumberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
    }
}
