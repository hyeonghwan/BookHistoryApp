//
//  BlockViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/11.
//

import Foundation
import RxSwift
import RxCocoa

//[.basic("텍스트"), .basic("페이지"), .basic("할 일 목록"),
//                                .basic("제목1"),.basic("제목2"),.basic("제목3"),
//                                .basic("표"),.basic("글머리 기호 목록"),.basic("번호 매기기 목록"),.basic("토글 목록"),
//                                .basic("인용"), .basic("구분선"), .basic("페이지 링크"), .basic("콜아웃")]
enum BlockType: String{
    case paragraph = "텍스트"
    case page = "페이지"
    case todoList = "할 일 목록"
    case title1 = "제목1"
    case title2 = "제목2"
    case title3 = "제목3"
    case graph = "표"
    case textSymbolList = "글머리 기호 목록"
    case numberList = "번호 매기기 목록"
    case toggleList = "토글 목록"
    case quotation = "인용"
    case separatorLine = "구분선"
    case pageLink = "페이지 링크"
    case collOut = "콜아웃"
    case none
}


enum ActionType{
    case basic(String)
    case media(String)
    case dataBase(String)
}

struct BlockInput{
    var blockActionInput: Observable<CollectionViewElement>
}

struct BlockOutPut{
    var blockActionOutput : Driver<BlockType>?
    
    init(outPut: Driver<BlockType>) {
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
    
    var actionType: [ActionType] = [.basic("텍스트"), .basic("페이지"), .basic("할 일 목록"),
                                    .basic("제목1"),.basic("제목2"),.basic("제목3"),
                                    .basic("표"),.basic("글머리 기호 목록"),.basic("번호 매기기 목록"),.basic("토글 목록"),
                                    .basic("인용"), .basic("구분선"), .basic("페이지 링크"), .basic("콜아웃")]
    
    private lazy var blockSetting: BehaviorRelay<[ActionType]> = BehaviorRelay<[ActionType]>(value: actionType)
    
    private var blockOutPutAction = BehaviorRelay<BlockType>(value: BlockType.none)
    
    var disposeBag = DisposeBag()
    
    deinit{
        self.disposeBag = DisposeBag()
    }
    
    override init() {
        
        let model = BehaviorRelay<[CollectionViewElement]>(value: [])
         
        blockActionModel = model.asObservable()
        
        
        super.init()
        
        blockSetting
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
    
    
    private func elementToBlockType(_ element: CollectionViewElement) -> Observable<BlockType>{
        return Observable<BlockType>.create{ emit in
            guard let type = BlockType(rawValue: element.name) else { return Disposables.create() }
            
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
