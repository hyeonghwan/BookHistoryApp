//
//  BookModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/26.
//

import Foundation
import RxSwift

protocol PlanViewTypeAble{
    var onAction: AnyObserver<Void> { get }
    
    var toPlanDatas: Observable<PlanDataModels> { get }
}

final class PlanViewModel: NSObject,PlanViewTypeAble{
    var onAction: AnyObserver<Void>
    
    var toPlanDatas: Observable<PlanDataModels>
    
    var disposeBag = DisposeBag()
    
    override init() {
        let actionPipe = PublishSubject<Void>()
        
        let planDatasPipe = BehaviorSubject<PlanDataModels>(value: [])
        
        onAction = actionPipe.asObserver()
        
        toPlanDatas = planDatasPipe
        
        super.init()
        
        actionPipe
            .flatMap{ _ in MockPlanService.getPlanDatas()}
            .subscribe(onNext: planDatasPipe.onNext(_:))
            .disposed(by: disposeBag)
            
            
        
        
    }
}

class MockPlanService{
    
    
    static var data = [PlanDataModel(title: "1", content: "2123"),
                       PlanDataModel(title: "2", content: "4123"),
                       PlanDataModel(title: "3", content: "5123"),
                       PlanDataModel(title: "4", content: "6123"),
                       PlanDataModel(title: "5", content: "7123"),
                       PlanDataModel(title: "6", content: "8123"),
                       PlanDataModel(title: "7", content: "8123"),
                       PlanDataModel(title: "8", content: "8123"),
                       PlanDataModel(title: "9", content: "8123"),
                       PlanDataModel(title: "10", content: "8123"),
                       PlanDataModel(title: "11", content: "8123"),
                       PlanDataModel(title: "12", content: "8123")]
    
    static func getPlanDatas() -> Observable<PlanDataModels>{
        
        return Observable.create{ emiter in
            emiter.onNext(MockPlanService.data)

            return Disposables.create()
        }
    }
}
