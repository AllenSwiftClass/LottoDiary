//
//  LottoListHeader.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/11/28.
//

import UIKit
import SnapKit

final class LottoListHeader: UIView {
    
    weak var lottoListHeaderDelegate: LottoListHeaderDelegate?
    
    lazy var lottoListViewModel = LottoListViewModel()
    let getPickerDays = LottoListViewModel().getPickerDays()
    
    // 맨 처음 로드될때, LottoListView는 현재 날짜 기준 정렬
    lazy var selectedYear: Double = self.lottoListViewModel.getTodayDate()[0] {
        didSet {
            // UIPickerView.selectRow() : picker 열었을 때, 초기 wheel 셋팅
            self.setupSelectRow()
            self.setupDateTextFieldText()
            self.lottoListHeaderDelegate?.didSelectedDate(year: self.selectedYear, month: self.selectedMonth)
        }
    }
    lazy var selectedMonth: Double = self.lottoListViewModel.getTodayDate()[1] {
        didSet {
            self.setupSelectRow()
            self.setupDateTextFieldText()
            self.lottoListHeaderDelegate?.didSelectedDate(year: self.selectedYear, month: self.selectedMonth)
        }
    }
    // picker을 아무것도 누르지 않고 선택 버튼을 누를 경우를 위해 changingDay 초기값은 selectedYear/Month.
    lazy var changingDay: [Double] = [self.selectedYear, self.selectedMonth]
    
    lazy var datePickerView = UIPickerView()
    
    let dateTextField: UITextField = {
        let tf = UITextField()
        // 커서 깜빡이는 것 없애기
        tf.tintColor = .clear
        tf.textColor = UIColor.designSystem(.mainBlue)
        tf.font = UIFont.gmarksans(weight: .bold, size: ._19)
        
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDateTextField()
        setupDateTextFieldText()
        
        setupPickerView()
        setupPickerToolBar()
        setupSelectRow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDateTextField() {
        self.addSubview(dateTextField)
        
        dateTextField.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
    }
    
    private func setupDateTextFieldText() {
        
        let monthText = NSMutableAttributedString(string: "\(Int(self.selectedYear))년  \(Int(self.selectedMonth))월 >")
        
        // 2022년 : 흰색에 글씨 속성 변경
        monthText.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: String(self.selectedYear).count + 1))
        monthText.addAttribute(.font, value: UIFont.gmarksans(weight: .bold, size: ._19), range: NSRange(location: 0, length: String(self.selectedYear).count + 1))
        
        dateTextField.attributedText = monthText
    }
    
    private func setupPickerView() {
        dateTextField.inputView = datePickerView
        datePickerView.dataSource = self
        datePickerView.delegate = self
    }
    
    // pickerView의 toolBar
    private func setupPickerToolBar() {
        
        let toolBar = UIToolbar(frame: .init(x: 0, y: 0, width: 100, height: 35))
        
        let cancelBtn = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction))
        let doneBtn = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(doneAction))
        
        // cancle과 done 버튼 사이 space 주기
        let spacingBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([cancelBtn, spacingBtn, doneBtn], animated: true)
        dateTextField.inputAccessoryView = toolBar
    }
    
    // picker의 wheel 처음 로드 값
    private func setupSelectRow() {
        // pickerView는 마지막으로 select했던 row 로 wheel이 돌아가있음.
        // 그 전 picker에서 날짜를 선택하고 취소버튼 눌렀을 경우, 다음 picker을 열었을 때 wheel이 돌아가 있지 않도록 설정
        guard let yearRow = getPickerDays[0].firstIndex(of: selectedYear) else { return }
        guard let monthRow = getPickerDays[1].firstIndex(of: selectedMonth) else { return }
        self.datePickerView.selectRow(yearRow, inComponent: 0, animated: false)
        self.datePickerView.selectRow(monthRow, inComponent: 1, animated: false)
    }
    
    @objc func cancelAction() {
        self.setupSelectRow()
        // 취소를 누르면, dateTextField의 월 부분이 모두 흰색으로 변해버리는 현상 발생
        self.setupDateTextFieldText()
        
        // picker 내려가는 코드
        dateTextField.resignFirstResponder()
    }
    
    @objc func doneAction() {
        // picker의 wheel로 날짜를 바꾸고 난 뒤, 선택 버튼을 눌러야 selectedYear/Month 변경.
        // 취소 버튼 누를시, selectedYear/Month는 바뀌지 않음.
        self.selectedYear = self.changingDay[0]
        self.selectedMonth = self.changingDay[1]
        dateTextField.resignFirstResponder()
    }
}

// MARK: - Extensions

// PickerViewDataSource
extension LottoListHeader: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let yearMonthComponents = 2
        return yearMonthComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return getPickerDays[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(Int(getPickerDays[component][row]))년"
        case 1:
            return "\(Int(getPickerDays[component][row]))월"
        default:
            return ""
        }
    }
    
    // picker 선택할때마다 작동
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let changingYear =  getPickerDays[0][pickerView.selectedRow(inComponent: 0)]
        let changingMonth = getPickerDays[1][pickerView.selectedRow(inComponent: 1)]
        // picker의 wheel 변경할때마다 changingDay 변수 변경
        self.changingDay = [changingYear, changingMonth]
    }
}

// delegate까지 설정해줘야 picker의 title이 보임.
extension LottoListHeader: UIPickerViewDelegate {
}
