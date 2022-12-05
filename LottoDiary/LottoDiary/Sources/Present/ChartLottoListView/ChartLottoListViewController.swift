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
    lazy var lottoListViewModel = LottoListViewModel()
    
    // 앱 실행시, 초기 설정은 오늘 년도와 날짜
    lazy var selectedYear: Double = self.lottoListViewModel.getTodayDate()[0] {
        didSet {
            // selectedYear 변경시, 년도에 맞는 chartData 변경
            self.setupChartData()
        }
    }
    lazy var selectedMonth: Double = lottoListViewModel.getTodayDate()[1] {
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
    
    // TODO: typealias 공부하기
    typealias Section = LottoListDataSourceController.Section
    typealias Amount = LottoListDataSourceController.Amount
    
    var dataSource: UITableViewDiffableDataSource<Section, Amount>!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChartView()
        setupChartData()
        
        setupLottoListView()
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
        chartView.data = chartViewModel.setBarChartData(year: selectedYear)
    }
    
    private func setupLottoListView() {
        view.addSubview(lottoListView)
        lottoListView.backgroundColor = .clear
        
        // 구분선 제거
        lottoListView.separatorStyle = .none
        
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
        self.dataSource = UITableViewDiffableDataSource(tableView: self.lottoListView) { (tableView, indexPath, item) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(LottoListCell.self)", for: indexPath) as! LottoListCell
            
            // TODO: ,000 설정하기
            cell.amountLabel.text = String("\(Int(item.amount!).formattedWithSeparator) 원")
            cell.resultLabel.text = item.result?.title
            cell.resultLabel.textColor = item.result?.textColor
            cell.setupCell(section: indexPath.section, percent: item.percent)
            return cell
        }
        
    }
    
    private func setupLottoListSnapshot() {
        
        let data = lottoListViewModel.getMonthList(year: selectedYear, month: selectedMonth)
        let percentData = lottoListViewModel.getMonthPercent(year: selectedYear, month: selectedMonth).first
        
        let item1 = [Amount(amount: data.goalAmount, result: percentData?.key, percent: percentData?.value)]
        let item2 = [Amount(amount: data.buyAmount, result: percentData?.key, percent: percentData?.value)]
        let item3 = [Amount(amount: data.winAmount, result: percentData?.key, percent: percentData?.value)]
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Amount>()
        
        snapshot.appendSections([.goal, .buy, .win])
        snapshot.appendItems(item1, toSection: .goal)
        snapshot.appendItems(item2, toSection: .buy)
        snapshot.appendItems(item3, toSection: .win)
        
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}


// MARK: - Extension

// ChartViewDelegate
extension ChartLottoListViewController: ChartViewDelegate {
    
    // bar 클릭시 실행되는 함수
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

        self.selectedMonth = entry.x
        
        // LottoListHeader 에도 넘겨줘서 dateTextField.text 변경
        let lottoListHeader = self.lottoListView.tableHeaderView as! LottoListHeader
        lottoListHeader.selectedMonth = entry.x
    }
}

// DatePickerDelegate
extension ChartLottoListViewController: LottoListHeaderDelegate {
    func didSelectedDate(year: Double, month: Double) {
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
