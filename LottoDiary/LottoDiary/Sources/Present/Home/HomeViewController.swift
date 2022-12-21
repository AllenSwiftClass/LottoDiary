//
//  ViewController.swift
//  LottoDiary
//
//  Created by uiskim on 2022/11/23.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = testUser.nickName + "님"
        label.font = .gmarksans(weight: .bold, size: ._20)
        label.textColor = .designSystem(.white)
        label.textAlignment = .left
        return label
    }()
    
    let settingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = .designSystem(.white)
        return button
    }()
    
    let monthGoalLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .medium, size: ._30)
        label.textColor = .designSystem(.mainOrange)
        return label
    }()
    
    let achievementGoalLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .medium, size: ._30)
        label.textColor = .designSystem(.mainOrange)
        return label
    }()
    
    let goalPriceView = InfoView(title: "목표", price: String(Int(testUser.goal)), backGroundColor: .designSystem(.gray2B2C35)!)
    
    let purchasePriceView = InfoView(title: "구매금액", price: String(Int(testUser.usage)), backGroundColor: .designSystem(.mainOrange)!)
    
    let winPriceView = InfoView(title: "당첨금액", price: String(Int(testUser.winPrice)), backGroundColor: .designSystem(.mainBlue)!)
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.text = "이 돈이면"
        label.font = .gmarksans(weight: .bold, size: ._20)
        label.textColor = .designSystem(.white)
        label.textAlignment = .left
        return label
    }()
    
    let gukbobImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "gokbob"))
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    let usagePriceLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .medium, size: ._25)
        label.textColor = .designSystem(.mainOrange)
        label.textAlignment = .center
        return label
    }()
    
    let compareLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .medium, size: ._30)
        label.textColor = .designSystem(.mainOrange)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setUI() {
        view.backgroundColor = .designSystem(.backgroundBlack)
        view.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        view.addSubview(settingButton)
        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(nickNameLabel.snp.centerY)
            make.leading.equalTo(nickNameLabel.snp.trailing).offset(10)
            make.size.equalTo(25)
        }
        
        monthGoalLabel.attributedText = String.makeAtrributedString(nonAppendString: "7월", appendString: " 동안", changeAppendStringSize: ._20, changeAppendStringWieght: .medium, changeAppendStringColor: .designSystem(.white)!)
        view.addSubview(monthGoalLabel)
        monthGoalLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(20)
        }
        view.addSubview(achievementGoalLabel)
        achievementGoalLabel.attributedText = String.makeAtrributedString(nonAppendString: "목표치의 \(testUser.goalPercentage)%", appendString: " 를 사용하셨습니다", changeAppendStringSize: ._20, changeAppendStringWieght: .medium, changeAppendStringColor: .designSystem(.white)!)
        achievementGoalLabel.snp.makeConstraints { make in
            make.top.equalTo(monthGoalLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        view.addSubviews(goalPriceView, purchasePriceView, winPriceView)
        goalPriceView.snp.makeConstraints { make in
            make.top.equalTo(achievementGoalLabel.snp.bottom).offset(23)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo((DeviceInfo.screenWidth - 58)/3)
            make.height.equalTo(76)
        }
        purchasePriceView.snp.makeConstraints { make in
            make.top.equalTo(goalPriceView.snp.top)
            make.leading.equalTo(goalPriceView.snp.trailing).offset(13)
            make.width.equalTo((DeviceInfo.screenWidth - 58)/3)
            make.height.equalTo(76)
        }
        
        winPriceView.snp.makeConstraints { make in
            make.top.equalTo(goalPriceView.snp.top)
            make.leading.equalTo(purchasePriceView.snp.trailing).offset(13)
            make.width.equalTo((DeviceInfo.screenWidth - 58)/3)
            make.height.equalTo(76)
        }
        
        view.addSubview(subTitle)
        subTitle.snp.makeConstraints { make in
            make.leading.equalTo(nickNameLabel.snp.leading)
            make.top.equalTo(winPriceView.snp.bottom).offset(40)
        }
        
        view.addSubview(gukbobImageView)
        gukbobImageView.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(23)
        }
        
        usagePriceLabel.attributedText = String.makeAtrributedString(nonAppendString: String(Int(testUser.usage)) + "원", appendString: "으로", changeAppendStringSize: ._25, changeAppendStringWieght: .light, changeAppendStringColor: .designSystem(.white)!)
        view.addSubview(usagePriceLabel)
        usagePriceLabel.snp.makeConstraints { make in
            make.top.equalTo(gukbobImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        compareLabel.attributedText = String.makeAtrributedString(nonAppendString: "국밥" + String((testUser.usage / 10000)) + "개", appendString: "그릇먹기 가능", changeAppendStringSize: ._25, changeAppendStringWieght: .light, changeAppendStringColor: .designSystem(.white)!)
        
        view.addSubview(compareLabel)
        compareLabel.snp.makeConstraints { make in
            make.top.equalTo(usagePriceLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
    }
    
    @objc func settingButtonTapped() {
        print("세팅버튼이 눌렸습니다")
    }
}

