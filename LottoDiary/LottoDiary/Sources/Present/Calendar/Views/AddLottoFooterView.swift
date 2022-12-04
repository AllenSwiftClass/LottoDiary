//
//  AddLottoFooterView.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import Foundation
import UIKit
import SnapKit

final class AddLottoFooterView: UICollectionReusableView {
    static var elementKind: String { UICollectionView.elementKindSectionFooter}

    let plusImageView = UIImageView()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .gmarksans(weight: .bold, size: ._17)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // borderRadius 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15.0
    }
    
}

extension AddLottoFooterView {
    func configure() {
        self.backgroundColor = .clear
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addSubview(plusImageView)
        plusImageView.image = UIImage(named: "add")
        plusImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.trailing.equalTo(label.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
}
