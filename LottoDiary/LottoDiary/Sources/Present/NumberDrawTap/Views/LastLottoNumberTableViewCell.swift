//
//  LastLottoNumberTableViewCell.swift
//  LottoDiary
//
//  Created by uiskim on 2022/12/07.
//

import UIKit
import SnapKit

class LastLottoNumberTableViewCell: UITableViewCell {
    
    static let cellId = "LastLottoNumberTableViewCell"
    
    var lottoData: LottoData? {
        didSet {
            guard let lottoData = lottoData else { return }
            turnNumberLabel.text = String(lottoData.turnNumber) + "회"
            lottoView.lottoNumbers = lottoData.numbers
        }
    }
    
    let turnNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .gmarksans(weight: .light, size: ._19)
        return label
    }()
    
    let lottoView = LottoNumbersView(numbers: Int.makeRandomIntArray(count: 7))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = .clear
        addSubview(turnNumberLabel)
        addSubview(lottoView)
        turnNumberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.leading.equalToSuperview().inset(14)
            make.height.equalTo(21)
        }
        lottoView.snp.makeConstraints { make in
            make.top.equalTo(turnNumberLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview()
        }
    }
    
}
