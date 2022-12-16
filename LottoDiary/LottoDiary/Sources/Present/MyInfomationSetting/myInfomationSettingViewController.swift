//
//  MyInfomationSettingViewController.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/10.
//

import UIKit
import SnapKit


final class MyInfomationSettingViewController: UIViewController {

    
    // MARK: - Property
    
    private lazy var myInfoLabel = CustomLabel(text: "내 정보", font: .gmarksans(weight: .bold, size: ._28), textColor: .white)
    
    private lazy var nameTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray2B2C35)
        view.layer.cornerRadius = 5
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        return view
    }()
    
    private lazy var nameLabel = CustomLabel(text: "닉네임", font: .gmarksans(weight: .bold, size: ._13), textColor: .white)
    
    private lazy var nameTextField = CustomTextField(placeholder: "Youth", type: .letter, align: .right)
    
    private lazy var warningNameLabel = CustomLabel(text: "errorName", font: .gmarksans(weight: .regular, size: ._0), textColor: .clear)
    
    private lazy var targetAmountTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray2B2C35)
        view.layer.cornerRadius = 5
        view.addSubview(targetAmountLabel)
        view.addSubview(targetAmountTextField)
        return view
    }()
    
    private lazy var currentMonth = Calendar.current.dateComponents([.month], from: Date()).month!
    
    private lazy var targetAmountLabel = CustomLabel(text: "\(currentMonth)월 목표금액", font: .gmarksans(weight: .bold, size: ._13), textColor: .white)
    
    private lazy var targetAmountTextField = CustomTextField(placeholder: "목표금액을 입력해주세요", type: .number, align: .right)
    
    private lazy var warningAmountLabel = CustomLabel(text: "errorName", font: .gmarksans(weight: .regular, size: ._11), textColor: .clear)
    
    private lazy var notificationLabel = CustomLabel(text: "일정 주기마다 로또 경고 알림", font: .gmarksans(weight: .bold, size: ._20), textColor: .white)
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        targetAmountTextField.resignFirstResponder()
    }
    
    func setUI() {
        
        view.backgroundColor = .designSystem(.backgroundBlack)
        
        [myInfoLabel, nameTextFieldView, warningNameLabel, targetAmountTextFieldView, warningAmountLabel, notificationLabel]
            .forEach{ view.addSubview($0) }
        
        myInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        nameTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(myInfoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(44)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        nameTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        warningNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextFieldView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        targetAmountTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(warningNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(83)
        }
        
        targetAmountLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(15)
        }
        
        targetAmountTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        warningAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(targetAmountTextFieldView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
        }
        
        notificationLabel.snp.makeConstraints { make in
            make.top.equalTo(warningAmountLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(15)
        }
        
        
    }
    
    
}
