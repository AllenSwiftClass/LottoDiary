//
//  LottoCell.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import UIKit
import SnapKit

final class LottoCell: UICollectionViewCell {
    
    static let reuseIdentifier = "lotto-item-cell-reuse-identifier"
    let lottoImageView = UIImageView()
    
    lazy var titleLabel = CustomLabel(text: "로또", font: .gmarksans(weight: .bold, size: ._19), textColor: .white)
    
    lazy var purchaseLabel = CustomLabel(text: "구매 금액:", font: .gmarksans(weight: .regular, size: ._15), textColor: .white)
    
    lazy var winningLabel =  CustomLabel(text: "당첨 금액:", font: .gmarksans(weight: .regular, size: ._15), textColor: .white)

    
    lazy var purchaseAmount =  CustomLabel(text: "10000원", font: .gmarksans(weight: .bold, size: ._15), textColor: .white)

    
    lazy var winningAmount =  CustomLabel(text: "5000원", font: .gmarksans(weight: .regular, size: ._15), textColor: .white)

    
    var type: LottoType = .lotto {
        didSet {
            configure()
        }
    }
    
    var backColor: UIColor? {
        switch self.type {
        case .lotto: return .designSystem(.mainOrange)
        case .spitto: return .designSystem(.mainBlue)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = true
    }
}

extension LottoCell {
    func configure() {
        self.backgroundColor = backColor
        
        [lottoImageView, titleLabel, purchaseLabel, purchaseAmount, winningLabel, winningAmount]
            .forEach{ self.contentView.addSubview($0) }
        
        // 디바이스가 400보다 클때
        if DeviceInfo.screenWidth >= 400 {
            lottoImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(15)
                make.width.height.equalTo(30)
            }
            lottoImageView.image = UIImage(named: "\(type)")
            
            titleLabel.text = "\(type.rawValue)"
            
            titleLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(lottoImageView.snp.trailing).offset(10)
            }
            
            purchaseLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.leading.equalTo(contentView.snp.leading).offset(170)
            }
            
            purchaseAmount.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-22)
            }
            
            winningLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-10)
                make.leading.equalTo(contentView.snp.leading).offset(170)
            }
            
            winningAmount.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-10)
                make.trailing.equalToSuperview().offset(-22)
            }
        } else {
            lottoImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(10)
                make.width.height.equalTo(20)
            }
            
            lottoImageView.image = UIImage(named: "\(type)")
            
            titleLabel.text = "\(type.rawValue)"
            titleLabel.font = .gmarksans(weight: .bold, size: ._17)
            
            titleLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(lottoImageView.snp.trailing).offset(5)
            }
            
            purchaseLabel.font = UIFont.gmarksans(weight: .regular, size: ._13)
            purchaseAmount.font = UIFont.gmarksans(weight: .bold, size: ._13)
            purchaseLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.leading.equalTo(contentView.snp.leading).offset(160)
            }
            
            purchaseAmount.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-22)
            }
            
            winningLabel.font = UIFont.gmarksans(weight: .regular, size: ._13)
            winningAmount.font = UIFont.gmarksans(weight: .bold, size: ._13)
            
            winningLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-10)
                make.leading.equalTo(contentView.snp.leading).offset(160)
            }
            
            winningAmount.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-10)
                make.trailing.equalToSuperview().offset(-22)
            }
        }
        
    }
}
