//
//  NumberDrawViewController.swift
//  LottoDiary
//
//  Created by uiskim on 2022/12/06.
//

import UIKit

final class NumberDrawViewController: UIViewController {
    
    let mainTitle: UILabel = {
        let label = UILabel()
        label.text = "로또일기"
        label.textColor = .designSystem(.white)
        label.font = .gmarksans(weight: .bold, size: ._19)
        label.textAlignment = .center
        return label
    }()
    
    let drawTitle: UILabel = {
        let label = UILabel()
        label.text = "이번주 추천 번호는?"
        label.textColor = .designSystem(.white)
        label.font = .gmarksans(weight: .bold, size: ._20)
        label.textAlignment = .left
        return label
    }()
    
    let lastNumberTitle: UILabel = {
        let label = UILabel()
        label.text = "지난 회차 번호는?"
        label.textColor = .designSystem(.white)
        label.font = .gmarksans(weight: .bold, size: ._20)
        label.textAlignment = .left
        return label
    }()
    
    let randomNumberDrawView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .designSystem(.gray2B2C35)
        return view
    }()

    let randomNumberDraw = LottoNumbersView()
    
    lazy var changeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("새로운 번호 섞기", for: .normal)
        button.titleLabel?.font = .gmarksans(weight: .bold, size: ._13)
        button.tintColor = .white
        button.backgroundColor = .designSystem(.mainOrange)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "위 번호는 컴퓨터가 무작위로 조합한 숫자로,\n당첨과 아무런 연관이 없음을 밝힙니다."
        label.numberOfLines = 2
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .light, size: ._10)
        label.textAlignment = .left
        return label
    }()
    
    let lastNumbersView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .designSystem(.gray2B2C35)
        return view
    }()
    
    lazy var lastLottoNumberTabelView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(LastLottoNumberTableViewCell.self, forCellReuseIdentifier: LastLottoNumberTableViewCell.cellId)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = DeviceInfo.screenHeight / 10
        return tableView
    }()
    
    var lastDrawNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회차 번호 더보기", for: .normal)
        button.titleLabel?.font = .gmarksans(weight: .bold, size: ._13)
        button.tintColor = .white
        button.backgroundColor = .designSystem(.mainBlue)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .designSystem(.backgroundBlack)
        view.addSubview(mainTitle)
        mainTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(50)
        }
        view.addSubview(drawTitle)
        drawTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(14)
            make.top.equalTo(mainTitle.snp.bottom).offset(40)
            
        }
        view.addSubview(randomNumberDrawView)
        randomNumberDrawView.snp.makeConstraints { make in
            make.top.equalTo(drawTitle.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(172)
        }
        randomNumberDrawView.addSubview(randomNumberDraw)
        randomNumberDraw.lottoNumbers = Int.makeRandomIntArray(count: 7)
        randomNumberDrawView.addSubview(changeButton)
        randomNumberDrawView.addSubview(warningLabel)
        randomNumberDraw.snp.makeConstraints { make in
            make.top.equalToSuperview().inset( 22 + LottoBall.ballSize / 2 )
            make.leading.equalToSuperview()
        }
        changeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.top.equalTo(randomNumberDraw.snp.bottom).offset(22 + LottoBall.ballSize / 2)
            make.height.equalTo(32)
            make.width.equalTo(142)
        }
        warningLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(14)
        }
        
        view.addSubview(lastNumberTitle)
        lastNumberTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(14)
            make.top.equalTo(randomNumberDrawView.snp.bottom).offset(30)
            make.height.equalTo(23)
        }
        
        view.addSubview(lastNumbersView)
        lastNumbersView.snp.makeConstraints { make in
            make.top.equalTo(lastNumberTitle.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(130)
        }
        
        lastNumbersView.addSubview(lastLottoNumberTabelView)
        lastLottoNumberTabelView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lastNumbersView.addSubview(lastDrawNumberButton)
        lastDrawNumberButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(14)
            make.height.equalTo(32)
            make.width.equalTo(142)
        }
        
    }
    
    @objc func changeButtonTapped() {
        randomNumberDraw.lottoNumbers = Int.makeRandomIntArray(count: 7)
    }
}

extension NumberDrawViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LottoData.lastDrawDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LastLottoNumberTableViewCell.cellId, for: indexPath) as? LastLottoNumberTableViewCell else { return UITableViewCell() }
        cell.lottoData = LottoData.lastDrawDatas[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
