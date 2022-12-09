//
//  LottoListCell.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/11/26.
//

import UIKit
import SnapKit

class LottoListCell: UITableViewCell {
    
    typealias Section = LottoListDataSourceController.Section
    
    // mainImage에서 Image를 설정했지만, UIImageView와 Image 사이 inset 주는데 실패하고, view 하나 더 올려 간격 줌.
    var mainImageView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 3
        view.backgroundColor = .white
        return view
    }()
    
    var mainImage: UIImageView = {
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .bold, size: ._17)
        label.textColor = .white
        return label
    }()
    
    var resultLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .bold, size: ._15)
        return label
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarksans(weight: .bold, size: ._20)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // cell간 간격 주기 위해 contentView에 올리고 Inset 설정
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 13, left: 15, bottom: 13, right: 15))
    }
    
    private func setupCell() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        mainImageView.addSubview(mainImage)
        mainImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.equalTo(mainImageView.snp.right).offset(15)
        }
        
        contentView.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.left.equalTo(titleLabel).inset(5)
        }
        
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(5)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    // 하나의 cell을 재사용하기 때문에, section에 따라 titleLabel, mainImage 변경
    func setupCellDetail(section: Int, percent: Int?) {
        if section == 0 {
            titleLabel.text = Section.goal.title
            mainImage.image = Section.goal.image
        } else if section == 1 {
            titleLabel.text = Section.buy.title
            mainImage.image = Section.buy.image
        } else {
            titleLabel.text = Section.win.title
            mainImage.image = Section.win.image
            // 마지막 cell에서는 구매금액 - 당첨금액 으로 % 내야하기 때문에 따로 설정
            guard let percent = percent else { return }
            self.setupPercent(percent: percent)
        }
    }
    
    // label에서 image와 title 같이 사용하기
    // func으로 따로 뺀 이유는 Percent 받아서 숫자와 이미지 설정해주기 위해.
    func setupPercent(percent: Int) {
        let percentString = "\(abs(percent).formattedWithSeparator)% "
        let attributedString = NSMutableAttributedString(string: percentString)
        let imageAttachment = NSTextAttachment()
        
        // - % 라면,
        if percent == 0 {
            imageAttachment.image = UIImage(systemName: "minus")?.withTintColor(UIColor.designSystem(.mainGreen)!)
            attributedString.addAttribute(.foregroundColor, value: UIColor.designSystem(.mainGreen)!, range: NSRange(location: 0, length: percentString.count))
        }
        // + % 라면,
        else if percent < 0 {
            imageAttachment.image = UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(UIColor.designSystem(.mainBlue)!)
            attributedString.addAttribute(.foregroundColor, value: UIColor.designSystem(.mainBlue)!, range: NSRange(location: 0, length: percentString.count))
        }
        // - % 라면, (%가 없다면)
        else {
            imageAttachment.image = UIImage(systemName: "arrowtriangle.up.fill")?.withTintColor(UIColor.designSystem(.mainOrange)!)
            attributedString.addAttribute(.foregroundColor, value: UIColor.designSystem(.mainOrange)!, range: NSRange(location: 0, length: percentString.count))
        }
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        resultLabel.attributedText = attributedString
    }
}

