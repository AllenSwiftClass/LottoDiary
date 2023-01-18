//
//  MyInfomationSettingViewController.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/10.
//

import UIKit
import SnapKit
import RealmSwift

final class MyInfomationSettingViewController: UIViewController {

    // MARK: - Property
    
    let realm = try! Realm()
    
    // 경고알림 주기를 담고있는 배열
    private let notificationCycleArray = ["설정 안함", "하루", "일주일", "한달"]
    private var validation = Validation()
    
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
    
    private lazy var warningAmountLabel = CustomLabel(text: "errorName", font: .gmarksans(weight: .regular, size: ._0), textColor: .clear)
    
    private lazy var notificationLabel = CustomLabel(text: "일정 주기마다 로또 경고 알림", font: .gmarksans(weight: .bold, size: ._20), textColor: .white)
    
    private lazy var notificationTextField = CustomTextField(placeholder: "주기를 선택해주세요", type: .number, align: .natural)
    
    private let pickerView = UIPickerView()
    
    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.tintColor = .designSystem(.grayD8D8D8)
        button.titleLabel!.font = .gmarksans(weight: .bold, size: ._20)
        button.backgroundColor = .designSystem(.gray63626B)
        button.layer.cornerRadius = 15
        button.alpha = 0.3
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        targetAmountTextField.delegate = self
        
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
        
        view.addSubviews(myInfoLabel, nameTextFieldView, warningNameLabel, targetAmountTextFieldView, warningAmountLabel, notificationLabel, notificationTextField, okButton)
        
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
            make.width.equalToSuperview().multipliedBy(0.4)
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
        
        okButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
    }

    
    // 폰트, 텍스트내용, 텍스트 색을 통해 warningLabel을 디자인하는 메서드
    // font는 11크기의 regular가 기본값이며 다른 크기나 굵기를 주고 싶다면 직접 인수로 넣어줘야 함.
    private func setWarningLabel(target label: UILabel, font: UIFont = .designSystem(weight: .regular, size: ._11), text: String, textColor: UIColor) {
        label.font = font
        label.text = text
        label.textColor = textColor
    }
    
    // 확인버튼이 유효성을 검사하고 스타일변화
    func validateOkButton() {
        if let notification = notificationTextField.text, !notification.isEmpty {
            let nameValid = validation.validateName(name: nameTextField.text).isValid
            let targetAmountValid = validation.validateTargetAmount(number: targetAmountTextField.text).isValid
            if nameValid && targetAmountValid {
                okButton.isEnabled = true
                okButton.alpha = 1
                return
            }
        }
        okButton.isEnabled = false
        okButton.alpha = 0.3
    }
    
    // String타입의 구분자(,)를 포함한 숫자에서 구분자를 제거해 Int?타입으로 변환해주는 함수
    func convertAmountTextToInt(amountLabel: String?) -> Int? {
        guard let amountWithSeparator = amountLabel else {
            return nil
        }
        let amountText = amountWithSeparator.components(separatedBy: [","]).joined()
        
        guard let targetAmount = Int(amountText) else {
            return nil
        }
        return targetAmount
    }
    
    // 확인 버튼 클릭 시(닉네임, 목표금액, 경고 알림 선택시 활성화)
    @objc func okButtonTapped() {
        // 옵셔널을 풀고 ,를 제거하고 Int로 변환
        //
        guard let goalAmount = convertAmountTextToInt(amountLabel: targetAmountTextField.text) else {
            return
        }
        
        guard let userName = nameTextField.text, let notification = notificationTextField.text else {
            return
        }
        
        let myGoalAmount = GoalAmount(date: Date(), goalAmount: goalAmount)
        let user = User(nickName: userName, notificationCycle: notification)
        
        print(user.goalAmounts)
        user.goalAmounts.append(myGoalAmount)
        
        print(user)
        try! realm.write {
            self.realm.add(user)
        }
        
        let tabBarvc = TabBarController()
        navigationController?.pushViewController(tabBarvc, animated: true)
        // 유저 데이터 생성 부분
    }
    
}


// MARK: - textField Delegate
extension MyInfomationSettingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            textFieldCheck(nameTextField, .letter)
        } else if textField == targetAmountTextField {
            textFieldCheck(targetAmountTextField, .number)
        }
    }
    
    // 텍스트필드가 유효성에 따라 warningLabel의 상태를 정하는 메서드
    func textFieldCheck(_ tf: UITextField, _ type: TextFieldType) {
        switch type {
        case .letter:
            let ResultWithLabel = validation.validateName(name: tf.text)
            ResultWithLabel.isValid ? setWarningLabel(target: warningNameLabel,
                                                      font: .designSystem(weight: .regular, size: ._0),
                                                      text: "" ,
                                                      textColor: .clear)
                                    : setWarningLabel(target: warningNameLabel,
                                                      text: ResultWithLabel.errorLabel,
                                                      textColor: .systemRed)
        case .number:
            let ResultWithLabel = validation.validateTargetAmount(number: tf.text)
            ResultWithLabel.isValid ? setWarningLabel(target: warningAmountLabel,
                                                      font: .designSystem(weight: .regular, size: ._0),
                                                      text: "",
                                                      textColor: .clear)
                                    : setWarningLabel(target: warningAmountLabel,
                                                      text: ResultWithLabel.errorLabel,
                                                      textColor: .systemRed)
        }
        validateOkButton()
    }
    
    // 텍스트 필드에 1000단위로 , 붙여주는 델리게이트, replacementString인 string은 입력한 길이 1인 문자이다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard textField == targetAmountTextField else { return true }
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0
            if let removeAllSeparator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: "") {
                var beforeFormattedString = removeAllSeparator + string
                if formatter.number(from: string) != nil { // 백스페이스가 들어오면 숫자로 변환이 안되기 때문에 nil
                    // 숫자로 만든 후에 formatter.string으로 문자열을 만드는 과정에서 ,을 붙이게 된다.
                    if let formattedNumber = formatter.number(from: beforeFormattedString), let formattedString = formatter.string(from: formattedNumber) {
                        textField.text = formattedString
                        return false
                    }
                } else {
                    if string == "" { // 들어온 값이 백스패이스라면
                        let lastIndex = beforeFormattedString.index(beforeFormattedString.endIndex, offsetBy: -1)
                        beforeFormattedString = String(beforeFormattedString[..<lastIndex]) //String의 서브스크립트에서는 ..<를 사용할 때 앞에 빈 공간은 첫번째 인덱스를 뜻한다
                        if let formattedNumber = formatter.number(from: beforeFormattedString), let formattedString = formatter.string(from: formattedNumber) {
                            textField.text = formattedString
                            return false
                        }
                    } else {
                        return false
                    }
                }
            }
        // textFeild의 내용이 전부 지워질때 델리게이트 단에서 내용을 지워준다.
        return true
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
        let toolBar = UIToolbar(frame: .init(x: 0, y: 0, width: 100, height: 35))
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
        validateOkButton()
    }
    
    // "취소" 클릭 시 textfield의 텍스트 값을 nil로 처리 후 입력창 내리기
    @objc func cancelButtonTapped() {
        self.notificationTextField.text = nil
        self.notificationTextField.resignFirstResponder()
        validateOkButton()
    }
    
    // 알림 주기 pickview는 1개만 설정
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

