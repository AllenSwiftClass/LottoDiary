//
//  LottoCalendarViewController.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import UIKit
import FSCalendar
import SnapKit
import RxSwift


final class LottoCalendarViewController: UIViewController {

    // MARK: - Calendar 관련 변수
    
    lazy var events: [Date] = [] {
        didSet {
            self.calendar.reloadData()
        }
    }
    
    private let calendar = LottoCalendar()
    
    let calendarHeight: CGFloat = 300
    
    let viewModel = LottoCalendarViewModel()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    // MARK: - DiffableDataSource 관련 property
    
    var headerView: DateHeaderView? = nil
    
    enum Section: Equatable {
        case date
    }
    
    var dataSource: DataSource!
    var lottosCollectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .designSystem(.gray17181D)
        
        // 스크롤 뷰 레이아웃 설정
        configureScrollView()
        
        // 캘린더 레이아웃 설정
        configureCalendarLayout()
        // 캘린더 이벤트 등록
        setupEvents()
        
        // CollectionView, DataSource 설정
        configureCollectionView()
        configureDataSource()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        changeHeaderTitle()
    }
    

}


// MARK: - DiffableDataSource, CompositionalLayout 관련 함수
extension LottoCalendarViewController {
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        
        contentView.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.register(LottoCell.self, forCellWithReuseIdentifier: LottoCell.reuseIdentifier)
        collectionView.backgroundColor = .designSystem(.gray17181D)

        collectionView.isScrollEnabled = false
        lottosCollectionView = collectionView
        
        viewModel.filteredLottos
            .map { $0.count }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { count in
                self.lottosCollectionView.snp.makeConstraints { make in
                    make.leading.equalToSuperview()
                    make.top.equalTo(self.calendarHeight + 20) // 캘린더와의 거리
                    make.width.equalToSuperview()
                    // 동적으로 데이터가 들어가야함
                    make.height.equalTo(count * 90 + 20 + 50) // 셀 크기, 헤더(MM월 dd일), 푸터
                    // bottom으로 contentView를 마무리지음
                    make.bottom.equalToSuperview()
                }
            })
            .dispose()
    }
    
    func configureDataSource() {
        dataSource = DataSource(collectionView: lottosCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, lottoId: Lotto.ID) ->
            UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LottoCell.reuseIdentifier,
                for: indexPath) as? LottoCell
            else { fatalError("Could not create new cell") }
            let lotto = self.lotto(for: lottoId)
            
            if lotto != nil {
                cell.purchaseAmount.text = "\(lotto!.purchaseAmount.formattedWithSeparator) 원"
                cell.winningAmount.text = "\(lotto!.goalAmount.formattedWithSeparator) 원"
                cell.type = lotto!.type
            }
            return cell
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: DateHeaderView.elementKind, handler: headerRegistrationHandler)
        let footerRegistration = UICollectionView.SupplementaryRegistration(elementKind: AddLottoFooterView.elementKind, handler: footerRegistrationHandler)
        
        dataSource.supplementaryViewProvider = {
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            
            
            if elementKind == DateHeaderView.elementKind {
                
                // Dequeue header view
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration, for: indexPath)
                
            } else {
                // Dequeue footer view
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: footerRegistration, for: indexPath)
            }
        }
        
        updateSnapShot()
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _ , _ in
            return self.generateLottosLayout()
        }
        return layout
    }
    
    func generateLottosLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(90))
        
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1)
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 15,
            leading: 15,
            bottom: 0,
            trailing: 15)
        
        // 헤더크기 설정
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),
            heightDimension: .absolute(14))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: DateHeaderView.elementKind,
            alignment: .topLeading)
            
        // footer 크기설정
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: AddLottoFooterView.elementKind,
            alignment: .bottom)
        sectionFooter.contentInsets = NSDirectionalEdgeInsets(
            top: 15,
            leading: 15,
            bottom: 0,
            trailing: 15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        return section
    }
}


// MARK: - ScrollView 관련 함수

extension LottoCalendarViewController {
    func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
    }
}


// MARK: - calendar Method, DataSource, Delegate
extension LottoCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: - Method
    
    func configureCalendarLayout() {
        contentView.addSubview(calendar)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(calendarHeight)
        }
        
        // expandButton delegate 설정
        calendar.expandButton.delegate = self
    }
    
    func setupEvents() {
        // 로또배열을 탐색하며 date 포멧이 가능한 date를 이벤트에 넣어준다.
        
        viewModel.lottoObservable
            .map{$0.map{ self.viewModel.formatter.date(from: $0.date)!} }
            .subscribe(onNext: { (dates) in
                dates.forEach{ self.events.append($0) }
            })
            .dispose()
    }
    
    // 헤더의 제목을 attributed 시키는 함수
    func changeHeaderTitle() {
        let currentPageDate = calendar.currentPage
        let year = Calendar.current.component(.year, from: currentPageDate)
        let month = Calendar.current.component(.month, from: currentPageDate)
        let monthName = DateFormatter().monthSymbols[month - 1].capitalized
        
        for cell in calendar.calendarHeaderView.collectionView.visibleCells {
            let attributedString = NSMutableAttributedString(string: "\(year)\n\(monthName)\n")
            
            let attributes0: [NSAttributedString.Key : Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.gmarksans(weight: .light, size: ._22)
                
            ]
            let attributes1: [NSAttributedString.Key : Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.gmarksans(weight: .bold, size: ._15)
            ]
            
            // title 사이에 간격 띄우기
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            
            
            attributedString.addAttributes(attributes0, range: NSRange(location: 0, length: 4))
            attributedString.addAttributes(attributes1, range: NSRange(location: 5, length: 3))
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            
            (cell as! FSCalendarHeaderCell).titleLabel.attributedText = attributedString
        }
    }
    
    // 주, 월 scope 변경
    @objc func switchCalendarScope(_ isMonth: Bool) {
        if isMonth {
            self.calendar.setScope(.month, animated: true)
        } else {
            self.calendar.setScope(.week, animated: true)
        }
        changeHeaderTitle()
    }
    
    
    
    // MARK: - FsCalendarDataSource
    
    // 이벤트 등록
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return self.events.contains(date) ? 1 : 0
    }
    
    
    // MARK: - FscalendarDelegate
    
    // 달력 넘길때 customHeader 적용
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        changeHeaderTitle()
    }
    
    // scope변경 시 Rect수정 델리게이트
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        let boundHeight = bounds.height
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(boundHeight)
        }
        
        lottosCollectionView.snp.updateConstraints { make in
            make.top.equalTo(boundHeight + 20) // 변경된 캘린더의 높이 + 아래 collectionView와의 gap
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            // 애니메이션이 끝난 시점에 custom header 적용
            self.changeHeaderTitle()
        }


        self.view.layoutIfNeeded()
    }
    
    // 날짜 선택 시 호출
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.selectedDate = viewModel.formatter.string(from: date)
        
        changeCollectionViewHeight()
        updateSnapShot()
    }
    
}


// MARK: - calendar Appearance Delegate

extension LottoCalendarViewController: FSCalendarDelegateAppearance {
    // weekday마다 색상 설정
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let _ = Calendar.current.component(.weekday, from: date) - 1
        return .designSystem(.gray63626B)
    }
    
    // 선택되었을때 셀 배경색
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .designSystem(.gray3C3C47)
    }
    
    // 선택되었을때 셀 border색
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return .designSystem(.gray3C3C47)
    }
    
}


// MARK: - CollectionView Method, Delegate
extension LottoCalendarViewController: UICollectionViewDelegate {
    
    // MARK: - Method
    
    func changeCollectionViewHeight() {
        // headerViewText 변경
        headerView?.headerLabel.text = viewModel.selectedDate.dateStringToHeaderView
        
        viewModel.filteredLottos
            .map { $0.count }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { count in
                self.lottosCollectionView.snp.updateConstraints { make in
                    // 동적으로 데이터가 들어가야함
                    make.height.equalTo(count * 90 + 20 + 50)  // 셀 크기, 헤더(MM월 dd일), 푸터
                    
                    // bottom으로 contentView를 마무리지음
                    make.bottom.equalToSuperview()
                }
            })
            .dispose()
        
        
        // 컬렉션 뷰의 height이 커지는 부분을 애니메이션
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.changeHeaderTitle()
        }
    }
    
}



// MARK: - Expand Button Delegate
extension LottoCalendarViewController: ExpandButtonDelegate {
    func isMonthChange(_ isMonth: Bool) {
        switchCalendarScope(isMonth)
    }
}
