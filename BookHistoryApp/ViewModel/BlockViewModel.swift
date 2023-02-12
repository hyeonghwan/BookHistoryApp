//
//  BlockViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/11.
//

import Foundation
import RxSwift
import RxCocoa



enum ActionType{
    case basic(String)
    case media(String)
    case dataBase(String)
}

struct BlockInput{
    var blockActionInput: Observable<CollectionViewElement>
}

struct BlockOutPut{
    var blockActionOutput : Driver<CustomBlockType.Base>?
    
    init(outPut: Driver<CustomBlockType.Base>) {
        self.blockActionOutput = outPut
    }
    
    init(){
        
    }
}

struct BlockAddViewInput{
    var section: BehaviorRelay<Int>
}



protocol BlockVMProtocol: AnyObject{
    var blockActionModel: Observable<[CollectionViewElement]> { get }
    
//    var blockInputAction: PublishRelay<CollectionViewElement> { get }
    
    var blockAddViewInput: BlockAddViewInput? { get }
    
    func createBlockActionInPut(_ input: BlockInput)
    func createBlockActionOutPut() -> BlockOutPut
}


final class BlockViewModel: NSObject,BlockVMProtocol {
    
    
    var blockAddViewInput: BlockAddViewInput?
    
    var blockInput: BlockInput?
    
    var blockOutPut: BlockOutPut?
    
    var blockActionModel: Observable<[CollectionViewElement]>
    
    
    
    private var blockOutPutAction = BehaviorRelay<CustomBlockType.Base>(value: CustomBlockType.Base.none)
    
    var disposeBag = DisposeBag()
    
    deinit{
        self.disposeBag = DisposeBag()
    }
    
    init(setting: BehaviorRelay<[ActionType]>) {
        
        let model = BehaviorRelay<[CollectionViewElement]>(value: [])
         
        blockActionModel = model.asObservable()
        
        super.init()
        
        setting
            .asObservable()
            .flatMap(settingBlockCollectionViewData(_:))
            .bind(onNext: model.accept(_:))
            .disposed(by: disposeBag)
    }
   
    
    func createBlockActionInPut(_ input: BlockInput){
        let observable: Observable<CollectionViewElement> = input.blockActionInput
       
        observable
            .flatMap(elementToBlockType(_:))
            .asDriver(onErrorJustReturn: .none)
            .drive(onNext: blockOutPutAction.accept(_:), onCompleted: {
                print("observable compolec")
            }, onDisposed: {
                print("observable disposedf")
            })
            .disposed(by: disposeBag)
        
    }
    
    func createBlockActionOutPut() -> BlockOutPut{
        
        let outPut = BlockOutPut(outPut: self.blockOutPutAction.asDriver(onErrorJustReturn: .none))
    
        return outPut
    }
    
    
    private func elementToBlockType(_ element: CollectionViewElement) -> Observable<CustomBlockType.Base>{
        return Observable<CustomBlockType.Base>.create{ emit in
            guard let type = CustomBlockType.Base(rawValue: element.name) else { return Disposables.create() }
            
            emit.onNext(type)
            
            return Disposables.create()
        }
    }
    
    private func settingBlockCollectionViewData(_ model: [ActionType]) -> Observable<[CollectionViewElement]> {
        return Observable<[CollectionViewElement]>.create{ emit in
            let result = model.map{ action in
                switch action{
                case .basic(let name):
                    return CollectionViewElement(name: name, image: "book")
                case .media(let name):
                    return CollectionViewElement(name: name, image: "book")
                case .dataBase(let name):
                    return CollectionViewElement(name: name, image: "book")
                }
            }
            
            emit.onNext(result)
            
            return Disposables.create()
        }
    }
}
