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
    
    // 경고알림 주기를 담고있는 배열
    private let notificationCycleArray = ["설정 안함", "하루", "일주일", "한달"]
    
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
    
    private lazy var notificationTextField = CustomTextField(placeholder: "주기를 선택해주세요", type: .number, align: .natural)
    
    private let pickerView = UIPickerView()
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePickView()
        setUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        targetAmountTextField.resignFirstResponder()
        notificationTextField.resignFirstResponder()
    }
    
    
    private func setUI() {
        view.backgroundColor = .designSystem(.backgroundBlack)
        
        [myInfoLabel, nameTextFieldView, warningNameLabel, targetAmountTextFieldView, warningAmountLabel, notificationLabel, notificationTextField]
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
        
        notificationTextField.snp.makeConstraints { make in
            make.top.equalTo(notificationLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15)
        }
        
    }
}



// MARK: - UIPickview Method, DataSource, Delegate

extension MyInfomationSettingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    private func configurePickView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        // textField에 반응하는 view를 pickerView로 설정
        notificationTextField.inputView = pickerView
        notificationTextField.textColor = .designSystem(.mainBlue)
        configureToolbar()
    }
    
    // 취소, 완료버튼이 있는 toolBar 설정
    private func configureToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .white
        toolBar.sizeToFit()
        
        // flexibleSpace는 취소~완료 간의 거리를 만들어준다.
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneBT.tintColor = .black
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelButtonTapped))
        cancelBT.tintColor = .black
        toolBar.setItems([cancelBT, flexibleSpace, doneBT], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        notificationTextField.inputAccessoryView = toolBar
    }
    
    // "완료" 클릭 시 데이터를 textField에 입력 후 입력창 내리기
    @objc func doneButtonTapped() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.notificationTextField.text = self.notificationCycleArray[row]
        self.notificationTextField.resignFirstResponder()
    }
    
    // "취소" 클릭 시 textfield의 텍스트 값을 nil로 처리 후 입력창 내리기
    @objc func cancelButtonTapped() {
        self.notificationTextField.text = nil
        self.notificationTextField.resignFirstResponder()
    }
    
    // pickview는 1개만 설정
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return notificationCycleArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return notificationCycleArray[row]
    }
    
    // textfield의 텍스트에 pickerview에서 선택한 값을 넣어준다.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.notificationTextField.text = self.notificationCycleArray[row]
    }
    
}

