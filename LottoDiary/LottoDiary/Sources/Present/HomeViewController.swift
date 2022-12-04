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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testLabel)
        view.backgroundColor = .designSystem(.mainBlue)
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(200)
        }
        print("new commit")
        // Do any additional setup after loading the view.
    }


}

