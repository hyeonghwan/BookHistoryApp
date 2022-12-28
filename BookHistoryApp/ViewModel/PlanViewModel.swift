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
    
    
    static var data = [PlanDataModel(title: "1월 계획", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "),
                       PlanDataModel(title: "2월 계획", content: "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
                       PlanDataModel(title: "3월 계획", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy"),
                       PlanDataModel(title: "4월 계획", content: " survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum"),
                       PlanDataModel(title: "5월 계획", content: "Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard"),
                       PlanDataModel(title: "6월 계획", content: "Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard"),
                       PlanDataModel(title: "7월 계획", content: "survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum "),
                       PlanDataModel(title: "8월 계획", content: "Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard"),
                       PlanDataModel(title: "9월 계획", content: "survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum "),
                       PlanDataModel(title: "10월 계획", content: "Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard"),
                       PlanDataModel(title: "11월 계획", content: "survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum "),
                       PlanDataModel(title: "12월 계획", content: "survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum ")]
    
    static func getPlanDatas() -> Observable<PlanDataModels>{
        
        return Observable.create{ emiter in
            emiter.onNext(MockPlanService.data)

            return Disposables.create()
        }
    }
}
