//
//  PlanGoalViewController.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/27.
//

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift

final class PlanGoalViewController: UIViewController{
    
    
    private lazy var monthView: PlanMonthView = {
        let monthView = PlanMonthView()
        return monthView
    }()
    
    private var planViewModel: PlanViewTypeAble = PlanViewModel()
    
    private var disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        addAutoLayout()
        setUpBinding()

        planViewModel.onAction.onNext(())
    }
    
    private func setUpBinding() {
        planViewModel.toPlanDatas
            .observe(on: MainScheduler.instance)
            .bind(to: monthView.tableView.rx.items(cellIdentifier: PlanCell.identify,
                                         cellType: PlanCell.self)){
                index, item, cell in
                
                cell.onData?.onNext(item)
            }.disposed(by: disposeBag)
    }
    
    
    private func addAutoLayout(){
        
        [monthView].forEach{
            self.view.addSubview($0)
        }
        
        monthView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
}
