//
//  PlanGoalViewController.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/27.
//

import UIKit
import SnapKit
import FSCalendar
import RxCocoa
import RxRelay
import RxSwift

final class PlanGoalViewController: UIViewController{
    
    private lazy var planCalendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.isUserInteractionEnabled = true
        calendar.locale = Locale.init(identifier: "ko")
        return calendar
    }()
    
    private lazy var monthView: PlanMonthView = {
        let monthView = PlanMonthView()
        return monthView
    }()
    
    
    
//    let currentPageMonth = calendar.currentPage.get(.month)
    
    fileprivate var theme: Int = 0 {
        didSet {
            print("theme didset \(self.theme)")
            switch (theme) {
            case 0:
                
                self.planCalendar.appearance.titleWeekendColor = UIColor.systemRed
                self.planCalendar.appearance.weekdayTextColor = .systemCyan
                self.planCalendar.appearance.headerTitleColor = .black
                self.planCalendar.appearance.eventDefaultColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.planCalendar.appearance.selectionColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.planCalendar.appearance.headerDateFormat = "yyyy년  MM월"
                self.planCalendar.appearance.todayColor = UIColor(red: 198/255.0, green: 51/255.0, blue: 42/255.0, alpha: 1.0)
                self.planCalendar.appearance.borderRadius = 1.0
                self.planCalendar.appearance.headerMinimumDissolvedAlpha = 0.2

            default:
                break
            }
        }
    }
    
    private var planViewModel: PlanViewTypeAble = PlanViewModel()
    
    private var disposeBag = DisposeBag()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.planCalendar,
                                                action: #selector(self.planCalendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        addAutoLayout()
        setUpBinding()
        settingCalendarBehavior()

        planViewModel.onAction.onNext(())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.planCalendar.setScope(.week, animated: true)
            self.planCalendar.select(Date())
            self.theme = 0
        })
        
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
    
    private func settingCalendarBehavior(){
        self.planCalendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.monthView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.planCalendar.scope = .month
    }
    
    
    private func addAutoLayout(){
        
        [planCalendar,monthView].forEach{
            self.view.addSubview($0)
        }
    
        planCalendar.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(300)
        }
        
        monthView.snp.makeConstraints{
            $0.top.equalTo(planCalendar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension PlanGoalViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("self.monthView.tableView.contentOffset.y : \(self.monthView.contentOffset.y)")
        print("-self.monthView.tableView.contentInset.top : \(-self.monthView.contentInset.top)")
        let shouldBegin = self.monthView.contentOffset.y <= -self.monthView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.planCalendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            @unknown default:
                fatalError("@unknown default")
            }
        }
        return shouldBegin
    }
}
extension PlanGoalViewController: FSCalendarDataSource{
    
}
extension PlanGoalViewController: FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        calendar.snp.updateConstraints{(make) in
            make.height.equalTo(bounds.height)
        }

        self.view.layoutIfNeeded()
    }

}
extension PlanGoalViewController: FSCalendarDelegateAppearance{
    
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//
//
//
//        if date.isSunday {
//            return .systemRed
//        }
//
//        if date.isSaturday {
//            return .systemBlue
//        }
//
//        return .label
//    }
}
