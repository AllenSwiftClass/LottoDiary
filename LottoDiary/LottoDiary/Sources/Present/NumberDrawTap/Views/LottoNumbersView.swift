//
//  LottoNumbersView.swift
//  LottoDiary
//
//  Created by uiskim on 2022/12/06.
//

import UIKit
import SnapKit

class LottoNumbersView: UIView {
    
    let ballOffsetWidth: CGFloat = (DeviceInfo.screenWidth - (14 * 2 * 2) - (38 * 7) - 30) / 6
    
    var lottoNumbers: [Int] {
        didSet {
            firstNumberBall.ballNumber = lottoNumbers[0]
            secondNumberBall.ballNumber = lottoNumbers[1]
            thirdNumberBall.ballNumber = lottoNumbers[2]
            fourthNumberBall.ballNumber = lottoNumbers[3]
            fifthNumberBall.ballNumber = lottoNumbers[4]
            sixthNumberBall.ballNumber = lottoNumbers[5]
            bounusNumberBall.ballNumber = lottoNumbers[6]
        }
    }

    lazy var firstNumberBall = LottoBall()
    lazy var secondNumberBall = LottoBall()
    lazy var thirdNumberBall = LottoBall()
    lazy var fourthNumberBall = LottoBall()
    lazy var fifthNumberBall = LottoBall()
    lazy var sixthNumberBall = LottoBall()
    
    lazy var plusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PlusButton")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var bounusNumberBall = LottoBall()

    init(numbers: [Int] = Int.makeRandomIntArray(count: 7)) {
        self.lottoNumbers = numbers
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addSubviews(firstNumberBall, secondNumberBall, thirdNumberBall, fourthNumberBall, fifthNumberBall, sixthNumberBall, plusImage, bounusNumberBall)
        
        firstNumberBall.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(LottoBall.ballSize)
        }
        
        secondNumberBall.snp.makeConstraints { make in
            make.leading.equalTo(firstNumberBall.snp.trailing).offset(ballOffsetWidth)
            make.centerY.equalToSuperview()
            make.size.equalTo(LottoBall.ballSize)
        }
        
        thirdNumberBall.snp.makeConstraints { make in
            make.leading.equalTo(secondNumberBall.snp.trailing).offset(ballOffsetWidth)
            make.centerY.equalToSuperview()
            make.size.equalTo(LottoBall.ballSize)
        }
        
        fourthNumberBall.snp.makeConstraints { make in
            make.leading.equalTo(thirdNumberBall.snp.trailing).offset(ballOffsetWidth)
            make.centerY.equalToSuperview()
            make.size.equalTo(LottoBall.ballSize)
        }
        
        fifthNumberBall.snp.makeConstraints { make in
            make.leading.equalTo(fourthNumberBall.snp.trailing).offset(ballOffsetWidth)
            make.centerY.equalToSuperview()
            make.size.equalTo(LottoBall.ballSize)
        }
        
        sixthNumberBall.snp.makeConstraints { make in
            make.leading.equalTo(fifthNumberBall.snp.trailing).offset(ballOffsetWidth)
            make.centerY.equalToSuperview()
            make.size.equalTo(LottoBall.ballSize)
        }
        
        plusImage.snp.makeConstraints { make in
            make.leading.equalTo(sixthNumberBall.snp.trailing).offset(ballOffsetWidth)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        bounusNumberBall.snp.makeConstraints { make in
            make.leading.equalTo(plusImage.snp.trailing).offset(ballOffsetWidth)
            make.centerY.equalToSuperview()
            make.size.equalTo(LottoBall.ballSize)
        }
    }
}

