//
//  IntroViewController.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/12/14.
//

import UIKit
import SnapKit

class IntroViewController: UIViewController {

    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "목표금액을 설정해주세요!"
        label.font = .gmarksans(weight: .bold, size: ._25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "매달 지출목표를 설정해서 지출을 줄여보세요."
        label.font = .gmarksans(weight: .medium, size: ._17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .designSystem(.mainOrange)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.setTitle("목표 입력하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(settingButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        setupView()
    }
    
    private func setupView() {
        
        lazy var stackView: UIStackView = {
            let sv = UIStackView()
            sv.axis = .vertical
            sv.spacing = 18
            sv.addArrangedSubview(mainLabel)
            sv.addArrangedSubview(subLabel)
            return sv
        }()
        
        mainLabel.snp.makeConstraints { make in
            make.left.right.top.equalTo(stackView)
        }
        
        subLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(stackView)
        }
        
        lazy var totalStackView: UIStackView = {
            let sv = UIStackView()
            sv.axis = .vertical
            sv.spacing = 32
            sv.addArrangedSubview(stackView)
            sv.addArrangedSubview(settingButton)
            return sv
        }()
        
        stackView.snp.makeConstraints { make in
            make.left.right.top.equalTo(totalStackView)
        }
        
        settingButton.snp.makeConstraints { make in
            make.bottom.equalTo(totalStackView)
            make.left.right.equalTo(totalStackView).inset(70)
            make.height.equalTo(60)
        }
        
        view.addSubview(totalStackView)
        totalStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func settingButtonAction() {
        print("settiong page 연결")
    }
}
