//
//  AddLottoViewController.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import UIKit
import SnapKit
import AudioToolbox


final class AddLottoViewController: UIViewController {
    
    var lotto: Lotto?
    
    var onChange: (Lotto)->Void
    
    var lottotype: LottoType = .lotto
    
    lazy var selectedDate: Date? = nil
    
    private lazy var typeLabel = CustomLabel(text: "로또 종류", font: .gmarksans(weight: .bold, size: ._22), textColor: .white)
       
    
    private lazy var lottoSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["로또", "스피또"])
        // 선택된 인덱스
        segmentedControl.selectedSegmentIndex = 0
        // 선택되었을 때 글자의 색상
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.designSystem(.whiteEAE9EE)!, NSAttributedString.Key.font: UIFont.gmarksans(weight: .bold, size: ._17)], for: .selected)
        
        // 선택되지 않았을 때 글자의 색상
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.designSystem(.grayA09FA7)!, NSAttributedString.Key.font: UIFont.gmarksans(weight: .bold, size: ._17)], for: .normal)
        
        // 선택되었을때 배경색
        segmentedControl.selectedSegmentTintColor = .designSystem(.gray4D4D59)
        // 넓은 범위의 기본 배경색
        segmentedControl.backgroundColor = .designSystem(.gray2B2C35)
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        
        return segmentedControl
    }()
    
    private lazy var warningPurchaseLabel = CustomLabel(text: "100,000,000 이하의 숫자만 입력 가능합니다.", font: .gmarksans(weight: .regular, size: ._11), textColor: .clear)
    
    
    
    private lazy var warningWinningLabel = CustomLabel(text: "100,000,000 이하의 숫자만 입력 가능합니다.", font: .gmarksans(weight: .regular, size: ._11), textColor: .clear)
    
    private lazy var purchaseLabel = CustomLabel(text: "구입금액", font: .gmarksans(weight: .regular, size: ._13), textColor: .designSystem(.grayA09FA7)!)

    
    private lazy var purchaseTextField = CustomTextField(placeholder: "구매금액을 입력해주세요", type: .number, align: .left)
    
    private lazy var winningLabel = CustomLabel(text: "당첨금액", font: .gmarksans(weight: .regular, size: ._13), textColor: .designSystem(.grayA09FA7)!)
    
    private lazy var winningTextField = CustomTextField(placeholder: "당첨금액을 입력해주세요", type: .number, align: .left)
    
    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .gmarksans(weight: .regular, size: ._15)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.alpha = 0.3
        button.backgroundColor = UIColor.black
        button.isEnabled = false
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .gmarksans(weight: .regular, size: ._15)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.backgroundColor = .designSystem(.gray2D2B35)
        button.addTarget(self, action: #selector(cancelModal), for: .touchUpInside)
        return button
    }()
    
    init(lotto: Lotto, onChange: @escaping (Lotto)->Void) {
        self.lotto = lotto
        self.onChange = onChange
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .designSystem(.backgroundBlack)
        purchaseTextField.delegate = self
        winningTextField.delegate = self
        setUI()
    }
    
    
    
    func setUI() {
        
        view.addSubviews(typeLabel, lottoSegmentedControl, purchaseLabel, purchaseTextField, winningLabel, winningTextField, warningPurchaseLabel, warningWinningLabel, okButton, cancelButton)
        
        typeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(30)
        }
    
        lottoSegmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(typeLabel.snp.bottom).offset(25)
            make.height.equalTo(40)
        }

        purchaseLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.top.equalTo(lottoSegmentedControl.snp.bottom).offset(40)
        }
        
        purchaseTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.top.equalTo(purchaseLabel.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        
        warningPurchaseLabel.snp.makeConstraints { make in
            make.top.equalTo(purchaseTextField.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(40)
        }
        
        winningLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalTo(warningPurchaseLabel.snp.bottom).offset(10)
        }
        
        winningTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.top.equalTo(winningLabel.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        
        warningWinningLabel.snp.makeConstraints { make in
            make.top.equalTo(winningTextField.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(40)
        }
        
        okButton.layer.cornerRadius = 5.0
        cancelButton.layer.cornerRadius = 5.0
        
        okButton.snp.makeConstraints { make in
            make.top.equalTo(winningTextField.snp.bottom).offset(40)
            make.centerX.equalToSuperview().offset(-60)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(winningTextField.snp.bottom).offset(40)
            make.leading.equalTo(okButton.snp.trailing).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    // 확인버튼 클릭시 호출되는 메서드
    @objc func okButtonTapped() {
        if let main = purchaseTextField.text?.replacingOccurrences(of: ",", with: ""), !main.isEmpty,
           let price = winningTextField.text?.replacingOccurrences(of: ",", with: ""), !price.isEmpty {
            
            lotto = Lotto(type: lottotype, purchaseAmount: Double(main)!, winAmount: Double(price)!, date: selectedDate!)
            // 클로저 호출
            if lotto != nil {
                onChange(lotto!)
            }
        }
    }
    
    // 취소버튼
    @objc func cancelModal() {
        dismiss(animated: true)
    }
    
    // segmented버튼을 클릭했을때 호출되는 메서드
    @objc func segmentedValueChanged(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0:
            lottotype = .lotto
        case 1:
            lottotype = .spitto
        default:
            break
        }
    }
    
    // 다른 곳 클릭 시 텍스트뷰 닫기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        purchaseTextField.resignFirstResponder()
        winningTextField.resignFirstResponder()
    }
    
    // 확인버튼 Validate
    func validateOkButton() {
        
        // 구매금액과 당첨금액이 비어있지 않을때
        if let purchase = purchaseTextField.text?.replacingOccurrences(of: ",", with: ""), !purchase.isEmpty,
           let price = winningTextField.text?.replacingOccurrences(of: ",", with: ""), !price.isEmpty {
            // 구입금액이 1000원이 넘고 당첨금액이 0보다 크거나 같다면 버튼 활성화
            if Int(purchase)! >= 1000, Int(price)! >= 0 {
                okButton.isEnabled = true
                okButton.backgroundColor = .systemBlue
                okButton.alpha = 1
            } else {
                okButton.backgroundColor = .black
                okButton.setTitleColor(UIColor.white, for: .normal)
                okButton.isEnabled = false
            }
        } else { // 둘 중 하나라도 비어있다면 button 비활성화
            okButton.backgroundColor = .black
            okButton.setTitleColor(UIColor.white, for: .normal)
            okButton.isEnabled = false
            okButton.alpha = 0.3
        }
    }
    
    // TextField 흔들기 애니메이션
        func shakeTextField(_ textField: UITextField) -> Void {
            if textField == purchaseTextField {
                warningPurchaseLabel.textColor = .systemRed
            } else {
                warningWinningLabel.textColor = .systemRed
            }
            
            UIView.animate(withDuration: 0.05, animations: {
                textField.frame.origin.x -= 2.5
            }, completion: { _ in
                UIView.animate(withDuration: 0.05, animations: {
                    textField.frame.origin.x += 5
                }, completion: { _ in
                    UIView.animate(withDuration: 0.05, animations: {
                        textField.frame.origin.x -= 2.5
                    }, completion: {_ in
                        UIView.animate(withDuration: 0.05, animations: {
                            textField.frame.origin.x -= 2.5
                        }, completion: {_ in
                            UIView.animate(withDuration: 0.05, animations: {
                                textField.frame.origin.x += 5
                            }, completion: {_ in
                                UIView.animate(withDuration: 0.05, animations: {
                                    textField.frame.origin.x -= 2.5
                                })
                            })
                        })
                    })
                })
            })
        }
    
}


// MARK: - UITextFieldDelegate
extension AddLottoViewController: UITextFieldDelegate {
    // 텍스트 필드에 1000단위로 , 붙여주는 델리게이트, replacementString인 string은 입력한 길이 1인 문자이다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0
            if let removeAllSeparator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: "") {
                var beforeFormattedString = removeAllSeparator + string
                // 입력된 수가 100억 보다 크다면
                if beforeFormattedString.count > 10 {
                    shakeTextField(textField)
                    return false
                } else {
                    if textField == purchaseTextField {
                        warningPurchaseLabel.textColor = .clear
                    } else {
                        warningWinningLabel.textColor = .clear
                    }
                }
                if formatter.number(from: string) != nil { // 백스페이스가 들어오면 숫자로 변환이 안되기 때문에 nil
                    // 숫자로 만든 후에 formatter.string으로 문자열을 만드는 과정에서 ,을 붙이게 된다.
                    if let formattedNumber = formatter.number(from: beforeFormattedString), let formattedString = formatter.string(from: formattedNumber) {
                        textField.text = formattedString
                        validateOkButton()
                        
                        return false
                    }
                } else {
                    if string == "" { // 들어온 값이 백스패이스라면
                        let lastIndex = beforeFormattedString.index(beforeFormattedString.endIndex, offsetBy: -1)
                        beforeFormattedString = String(beforeFormattedString[..<lastIndex]) //String의 서브스크립트에서는 ..<를 사용할 때 앞에 빈 공간은 첫번째 인덱스를 뜻한다
                        if let formattedNumber = formatter.number(from: beforeFormattedString), let formattedString = formatter.string(from: formattedNumber) {
                            textField.text = formattedString
                            validateOkButton()
                            return false
                        } else {
                            okButton.backgroundColor = .black
                            okButton.setTitleColor(UIColor.white, for: .normal)
                            okButton.isEnabled = false
                            okButton.alpha = 0.3
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
