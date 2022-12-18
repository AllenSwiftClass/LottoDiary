//
//  InfoView.swift
//  LottoDiary
//
//  Created by uiskim on 2022/12/18.
//

import UIKit

class InfoView: UIView {
    
    let mainTitle: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .medium, size: ._15)
        label.textColor = .designSystem(.white)
        label.textAlignment = .center
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .medium, size: ._15)
        label.textColor = .designSystem(.white)
        label.textAlignment = .center
        return label
    }()

    init(frame: CGRect = .zero, title: String, price: String, backGroundColor: UIColor) {
        super.init(frame: frame)
        self.backgroundColor = backGroundColor
        mainTitle.text = title
        priceLabel.text = price + "원"
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        addSubviews(mainTitle, priceLabel)
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
    }
    
}
