//  HeaderView.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import Foundation
import UIKit
import SnapKit

final class DateHeaderView: UICollectionReusableView {
    static var elementKind: String { UICollectionView.elementKindSectionHeader}

    let label = UILabel()
    
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
        addSubview(label)
        label.textColor = .white
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalToSuperview()
        }
        
        label.font = .gmarksans(weight: .bold, size: ._16)
    }
}
