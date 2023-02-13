//
//  BookPagingViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/23.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import RxRelay



struct PageListViewModelActions {
    /// Note: if you would need to edit movie inside Details screen and update this Movies List screen with updated movie then you would need this closure:
    /// showMovieDetails: (Movie, @escaping (_ updated: Movie) -> Void) -> Void
    let createPage: () -> Void
    let closePage: () -> Void
    let showSettingPage: (PageModel) -> Void
}

protocol PageListViewModelProtocol: AnyObject {
    
    //input
    var onPaging: AnyObserver<Void> { get }
    
    var pageData: AnyObserver<[PageModel]> { get }
    
    var movePage: AnyObserver<BookMO> { get }
    
    var deletePage: AnyObserver<Void> { get }
    
    
    
    //output
    var showPage: Observable<[PageModel]> { get }
    
    func getChildBlocksOFPage(_ id: PageModel) -> Observable<[Page_ChildBlock]>
}

protocol PageListAction: AnyObject {
    func createPage() -> Void
    
    func closePage() -> Void
}

protocol PageSettingAction: AnyObject {
    func showSettingPageButtonTapped(_ tap: Driver<Void>,
                                     _ model: PageModel?,
                                     _ disposeBag: DisposeBag)
}

typealias PageListActions = PageListAction & PageSettingAction

typealias PagingType = PageListActions & PageListViewModelProtocol

enum Book{
    case book
}

class BookPagingViewModel: NSObject, PagingType{
    
    private let service: RxBookService
    
    private let actions: PageListViewModelActions
    
    var onPaging: AnyObserver<Void>
    
    var pageData: AnyObserver<[PageModel]>
    
    var movePage: AnyObserver<BookMO>
    
    var showPage: Observable<[PageModel]>
    
    var deletePage: AnyObserver<Void>
    
    var disposeBag = DisposeBag()
    
    init(coreDataService: RxBookService = BookService(),
         action: PageListViewModelActions) {
        
        service = coreDataService
        actions = action
        
        let pagingPipe = PublishSubject<Void>()
        
        let pageDataPipe = PublishSubject<[PageModel]>()
        
        let movePipe = PublishSubject<BookMO>()
        
        let showPipe = BehaviorRelay<[PageModel]>(value: [])
        
        let deletePipe = PublishSubject<Void>()
        
        onPaging = pagingPipe.asObserver()
        
        pageData = pageDataPipe.asObserver()
        movePage = movePipe.asObserver()
        
        showPage = showPipe.asObservable()
        
        
        deletePage = deletePipe.asObserver()
        
        // Data flow
        // onPaging -> pagingPipe -> Service -> pageDataPipe -> showPipe -> showPage
        
        super.init()
        
        pagingPipe
            .flatMap(service.rxGetPages)
            .map{ pages -> [PageModel] in
                pages.compactMap{ [weak self] in
                    guard let self = self else {return nil}
                    return self.convertingPageModel($0)
                }
            }
            .subscribe(onNext: { value in
                pageDataPipe.onNext(value)
            })
            .disposed(by: disposeBag)
        
        pageDataPipe
            .subscribe(onNext: showPipe.accept(_:))
            .disposed(by: disposeBag)
        
        deletePipe
            .flatMap(service.rxDeletePage)
            .subscribe(onNext: { flag in
                
            })
            .disposed(by: disposeBag)
    }
    
    
    
    func getChildBlocksOFPage(_ id: PageModel) -> Observable<[Page_ChildBlock]>{
        return service
            .rxGetPage(id.pageID)
            .withUnretained(self)
            .compactMap{ own,page in own.makeChildrenBlockObject(page) }
    }
    
    
    
    //MARK: - PageList Action
    func createPage(){
        actions.createPage()
    }
    
    func closePage() -> Void{
        actions.closePage()
    }
    
    func showSettingPageButtonTapped(_ tap: Driver<Void>,
                                     _ model: PageModel? ,
                                     _ disposeBag: DisposeBag) {
        guard let model = model else {return}
        tap.drive(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.actions.showSettingPage(model)
        })
        .disposed(by: disposeBag)
    }
    
    
    
}
private extension BookPagingViewModel{
    
    func convertingPageModel(_ page: MyPage) -> PageModel?{
        guard let id = page.id else {return nil}
        
        guard let block = page.childBlock?.firstObject as? Page_ChildBlock,
              let text = try? block.ownObject?.object?.e.getBlockValueType() as? TextAndChildrenBlockValueObject ,
              let title = text.richText.first?.text.content
        else{
            return PageModel(pageID: id, title: "제목 없음")
        }
        
        
        return PageModel(pageID: id, title: title)
    }
    
    func makeChildrenBlockObject(_ page: MyPage) -> [Page_ChildBlock]? {
        do {
            let childBlocks = try page.childBlock?.map({ element -> Page_ChildBlock in
                if let childBlock = element as? Page_ChildBlock{
                    return childBlock
                }else{
                    throw CoreDataError.objectCastingError
                }
            })
            return childBlocks
        }catch{
            print(error)
            return nil
        }
    }
    
}
