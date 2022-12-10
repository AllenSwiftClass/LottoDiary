//  HeaderView.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import UIKit
import SnapKit

final class DateHeaderView: UICollectionReusableView {
    static var elementKind: String { UICollectionView.elementKindSectionHeader}

    let headerLabel =  CustomLabel(text: "날짜", font: .gmarksans(weight: .bold, size: ._16), textColor: .white)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DateHeaderView {
    func configure() {
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalToSuperview()
        }
        
    }
}
