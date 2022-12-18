//
//  LottoBall.swift
//  LottoDiary
//
//  Created by uiskim on 2022/12/06.
//

import UIKit
import SnapKit

class LottoBall: UIView {
    
    static let ballSize = 38
    
    var ballNumber: Int {
        didSet {
            self.ballNumberLabel.text = String(ballNumber)
            switch ballNumber {
            case 1..<10:
                self.backgroundColor = .designSystem(.mainYellow)
            case 10..<20:
                self.backgroundColor = .designSystem(.mainOrange)
            case 20..<30:
                self.backgroundColor = .designSystem(.mainBlue)
            case 30..<40:
                self.backgroundColor = .designSystem(.gray2B2C35)
            default:
                self.backgroundColor = .designSystem(.mainGreen)
            }
        }
    }
    
    let ballNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .bold, size: ._13)
        label.textColor = .designSystem(.white)
        label.textAlignment = .center
        return label
    }()
    
    init(lottoNumber: Int = .random(in: Int.lottoRange)) {
        ballNumber = lottoNumber
        super.init(frame: .zero)
        self.ballNumberLabel.text = String(lottoNumber)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        switch ballNumber {
        case 1..<10:
            self.backgroundColor = .designSystem(.mainYellow)
        case 10..<20:
            self.backgroundColor = .designSystem(.mainOrange)
        case 20..<30:
            self.backgroundColor = .designSystem(.mainBlue)
        case 30..<40:
            self.backgroundColor = .designSystem(.gray2B2C35)
        default:
            self.backgroundColor = .designSystem(.mainGreen)
        }
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(LottoBall.ballSize / 2)
        addSubview(ballNumberLabel)
        ballNumberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
    }
}
