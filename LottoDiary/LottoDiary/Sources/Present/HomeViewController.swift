//
//  ViewController.swift
//  LottoDiary
//
//  Created by uiskim on 2022/11/23.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    let testLabel: UILabel = {
        let v = UILabel()
        v.text = "테스트 라벨입니다"
        v.font = .gmarksans(weight: .bold, size: ._17)
        v.textColor = .designSystem(.mainOrange)
        v.layer.borderColor = UIColor.designSystem(.mainOrange)?.cgColor
        return v
    }()
    
    let codeReviewLabel: UILabel = {
        let v = UILabel()
        v.text = "코드리뷰설명 PR을 위한 라벨입니다"
        v.font = .systemFont(ofSize: 15, weight: .bold)
        v.textColor = .red
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testLabel)
        view.backgroundColor = .designSystem(.mainBlue)
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(200)
        }
        // Do any additional setup after loading the view.
        
        view.addSubview(codeReviewLabel)
        codeReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(testLabel.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().offset(30)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
    }


}

