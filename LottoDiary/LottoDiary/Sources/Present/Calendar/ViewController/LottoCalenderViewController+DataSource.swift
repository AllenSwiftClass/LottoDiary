//
//  LottoCalenderViewController+DataSource.swift
//  LottoDiary
//
//  Created by 천승현 on 2022/12/04.
//

import Foundation
import UIKit
import RxSwift

extension LottoCalendarViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Lotto.ID>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Lotto.ID>
    
    // 셀의 데이터가 변경되었을 때마다 snapShot을 업데이트하고, apply시켜야 적용이 됨.
    func updateSnapShot(reloading idsThatChanged: [Lotto.ID] = []) {
        let filteredLottos = lottos.filter{ $0.date == self.selectedDate}
        var snapshot = SnapShot()
        snapshot.appendSections([Section.date])
        snapshot.appendItems(filteredLottos.map{$0.id})
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    // 로또의 ID를 받아서 Lotto 인덱스를 생성
    func lotto(for id: Lotto.ID) -> Lotto? {
        return lottos[lottos.indexOfLotto(with: id)]
    }
}



// MARK: - header 및 footer 등록
extension LottoCalendarViewController {
    // header등록 시 사용되는 completionHandler
    func headerRegistrationHandler(dateHeaderView: DateHeaderView, elementKind: String, indexPath: IndexPath) {
        self.headerView = dateHeaderView
        headerView?.label.text = selectedDate.dateStringToHeaderView
    }
    
    // footer등록 시 사용되는 completionHandler
    func footerRegistrationHandler(addLottoFooterView: AddLottoFooterView, elementKind: String, indexPath: IndexPath) {
        addLottoFooterView.label.text = "새로운 로또 추가"
    }
    
}
