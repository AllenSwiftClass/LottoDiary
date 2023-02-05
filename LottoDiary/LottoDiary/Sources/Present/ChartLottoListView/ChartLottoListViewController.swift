//
//  ChartLottoListViewController.swift
//  LottoDiary
//
//  Created by 송선화 on 2022/11/15.
//

import UIKit
import Charts
import SnapKit

final class ChartLottoListViewController: UIViewController {
    
    // MARK: - Propertises
    
    let chartViewModel = ChartViewModel()
    let lottoListViewModel = LottoListViewModel()
    let database = DataBaseManager.shared
    
    // chartView에서만 월별 목표,구매,당첨 금액을 계산하면 되기 때문에 데이터를 따로 저장하지 않고, 클릭시 그때 그때 월별 데이터 계산
    var selectedAmount: [Amount] = []
    
    // 앱 실행시, 초기 설정은 오늘 년도와 날짜
    lazy var selectedYear: Int = self.lottoListViewModel.getTodayDate()[0] {
        didSet {
            // selectedYear 변경시, 년도에 맞는 chartData 변경
            self.setupChartData()
        }
    }
    
    lazy var selectedMonth: Int = lottoListViewModel.getTodayDate()[1] {
        didSet {
            // selectedMonth 변경시, 월에 맞는 lottoList 변경
            self.setupLottoListSnapshot()
        }
    }
    
    private let chartView: BarChartView = {
        let chartView = BarChartView()
    
        chartView.backgroundColor = UIColor.designSystem(.gray2B2C35)
        chartView.layer.cornerRadius = 20
        chartView.clipsToBounds = true
        
        // chart 더블클릭시 확대되는 것 false
        chartView.setScaleEnabled(false)
        chartView.doubleTapToZoomEnabled = false
        // chart bar 별 의미 적힌 동그라미 false
        chartView.legend.enabled = false
        return chartView
    }()
    
    private let lottoListView: UITableView = {
        let cv = UITableView(frame: .zero)
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        cv.rowHeight = 80
        cv.allowsSelection = false
        return cv
    }()
    
    typealias Section = LottoListDataSourceController.Section
    typealias Amount = LottoListDataSourceController.Amount
    
    var dataSource: UITableViewDiffableDataSource<Section, Amount.ID>!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChartView()
        setupChartData()
        
        setupLottoListView()
        setupLottoListDataSource()
        setupLottoListSnapshot()
    }
    
    // MARK: - 달력에서 새로운 로또 추가하고 차트로 건너오면 데이터 바로 적용 X 

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupChartData()
        setupLottoListDataSource()
        setupLottoListSnapshot()
    }
    
    // MARK: - Helpers
    
    private func setupChartView() {
        view.addSubview(chartView)
        chartView.delegate = self
        
        chartView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(280)
        }
        
        // 오른쪽, 왼쪽 금액 표시 비활성화
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        
        // xAxis label 비활성화
        chartView.xAxis.drawLabelsEnabled = false
        // xAxis 선 비활성화
        chartView.xAxis.drawAxisLineEnabled = false
        // bar 별 xAxis 세로선 삭제하기
        chartView.xAxis.drawGridLinesEnabled = false
    }
    
    private func setupChartData() {
        chartView.data = chartViewModel.setBarChartData(year: Double(selectedYear))
    }
    
    private func setupLottoListView() {
        view.addSubview(lottoListView)
        lottoListView.backgroundColor = .clear
        
        // 구분선 제거
        lottoListView.separatorStyle = .none
        // cell 등록
        self.lottoListView.register(LottoListCell.self, forCellReuseIdentifier: "\(LottoListCell.self)")
        
        lottoListView.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(400)
        }
    
        // delegate로 설정한 header은 tableView의 section마다 달리는 header. 이것은 전체 tableView의 header
        let header = LottoListHeader(frame: .init(x: 0, y: 0, width: lottoListView.frame.size.width, height: 30))
        header.dateTextField.delegate = self
        header.lottoListHeaderDelegate = self
        lottoListView.tableHeaderView = header
    }
    
    private func setupLottoListDataSource() {
        self.dataSource = UITableViewDiffableDataSource(tableView: self.lottoListView) { [weak self] (tableView, indexPath, identifier) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(LottoListCell.self)", for: indexPath) as! LottoListCell
            
            // snapshot실행 후 dataSource 실행
            // selectedAmount에는 이미 해당 달의 목표/구매/당첨 Amount가 들어가 있음. 이중 identifier 즉, id가 동일한 Amount 빼내기.
            let data = self?.selectedAmount.filter { $0.id == identifier }
            guard let item = data?.first else { return UITableViewCell() }
            
            cell.amountLabel.text = String("\(Int(item.amount ?? 00).formattedWithSeparator) 원")
            cell.resultLabel.text = item.result?.title
            cell.resultLabel.textColor = item.result?.textColor
            cell.setupCellDetail(section: indexPath.section, percent: item.percent)
            return cell
        }
    }
    
    private func setupLottoListSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Amount.ID>()
        
        snapshot.appendSections([.goal, .buy, .win])
        
        // 월별 목표,구매,당첨 금액 Amount 객체 생성 후 selectedAmount에 저장
        self.selectedAmount = lottoListViewModel.makeAmountData(year: self.selectedYear, month: self.selectedMonth)
        
        let item1 = selectedAmount[0]
        let item2 = selectedAmount[1]
        let item3 = selectedAmount[2]

        snapshot.appendItems([item1.id], toSection: .goal)
        snapshot.appendItems([item2.id], toSection: .buy)
        snapshot.appendItems([item3.id], toSection: .win)
        
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}


// MARK: - Extension

// ChartViewDelegate
extension ChartLottoListViewController: ChartViewDelegate {
    
    // bar 클릭시 실행되는 함수
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

        self.selectedMonth = Int(entry.x)
        
        // LottoListHeader 에도 넘겨줘서 dateTextField.text 변경
        let lottoListHeader = self.lottoListView.tableHeaderView as! LottoListHeader
        lottoListHeader.selectedMonth = Int(entry.x)
    }
}

// DatePickerDelegate
extension ChartLottoListViewController: LottoListHeaderDelegate {
    func didSelectedDate(year: Int, month: Int) {
        self.selectedYear = year
        self.selectedMonth = month
    }
}

// UITextFieldDelegate
extension ChartLottoListViewController: UITextFieldDelegate {
    
    // LottoListHeader의 dateTextField 수정 불가능하게 설정
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
