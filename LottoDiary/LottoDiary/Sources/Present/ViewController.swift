//
//  ViewController.swift
//  LottoDiary
//
//  Created by uiskim on 2022/11/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let testLabel: UILabel = {
        let v = UILabel()
        v.text = "테스트 라벨입니다"
        v.font = .gmarksans(weight: .bold, size: ._13)
        v.backgroundColor = .white
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(testLabel)
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(200)
        }
        // Do any additional setup after loading the view.
    }


}

