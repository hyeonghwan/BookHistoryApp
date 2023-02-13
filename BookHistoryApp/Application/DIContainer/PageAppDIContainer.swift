//
//  PageDIContainer.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/11.
//

import UIKit
import RxRelay


protocol ScreenCoordinatorProtocol{
    func makeViewController() -> UIViewController
}

typealias DataTransferService = RxBookService
typealias BookServiceAble = RxBookService & URLBookMarkMakable
typealias PageListProtocol = PagingType
typealias BlockViewModelProtocol = BlockVMProtocol
typealias PageVC = SecondViewController
typealias PageListVC = BookPagingViewController

class PageAppDIContainer{
    
    
    struct Dependencies{
        let coreDataTransferService: DataTransferService
        let bookTransferService: BookServiceAble
    }
    
    var dependency: Dependencies
    
    
    init(container dependency: Dependencies){
        self.dependency = dependency
    }
   
    
    //MARK: - make ViewController
    func makePageListViewController(_ actions: PageListViewModelActions) -> UIViewController{
        return PageListVC.create(dependency: self.makePagingType(actions))
    }
    
    func makeTestViewContoller() -> UIViewController{
        let vc = TestViewController.create()
        return vc
    }
    
    
    func makeCSTabBarController() -> UITabBarController{

        let tapModel = CSTabBarController.TabBarModel(tabModels:[BottomStackItem(title: "Home", image: "house"),
                                                                 BottomStackItem(title: "Favorites", image: "heart"),
                                                                 BottomStackItem(title: "Search", image: "magnifyingglass"),
                                                                 BottomStackItem(title: "Profile", image: "Person")])
        return CSTabBarController.create(with: tapModel)
    }
    
    func makeSettingViewController() -> UIViewController {
        return PageSettingViewController()
    }
    
    
    //MARK: - create Page func
    
    func makePageDependencies(_ pagingType: PagingType) -> PageVCViewModel.PageDependencies{
        return PageVCViewModel.PageDependencies(inputViewModel: makeInputViewModel(),
                                                colorViewModel: makeColorViewModel(),
                                                contentViewModel: makeContentViewModel(),
                                                accessoryViewModel: makeAccessoryViewModel(),
                                                blockViewModel: makeBlockViewModel(),
                                                bookPagingViewModel: pagingType)
    }
    
    
    //MARK: - ParagraphTraking Use Case
    func makeParagrphTrackingUtilityUseCase() -> ParagraphTrackingUtility{
        return ParagraphTrackingUtility()
    }

    
    //MARK: - ViewModel Make Func
    private func makePagingType(_ actions: PageListViewModelActions) -> PageListProtocol{
        return BookPagingViewModel(coreDataService: self.dependency.coreDataTransferService,
                                   action: actions)
    }
    
    private func makeInputViewModel() -> InputViewModelProtocol{
        return InputViewModel()
    }
    
    private func makeColorViewModel() -> ColorViewModelProtocol{
        return ColorViewModel()
    }
    
    private func makeAccessoryViewModel() -> AccessoryCompositinalProtocol{
        return AccessoryViewModel()
    }
    
    private func makeContentViewModel() -> ContentViewModelProtocol{
        return BookContentViewModel(dependencies: BookContentViewModel.Dependencies(service: self.dependency.bookTransferService,
                                                                                    paragrphTrackingUtility: makeParagrphTrackingUtilityUseCase()))
    }
    
    private func makeBlockViewModel() -> BlockViewModelProtocol{
        let actionType: [ActionType] = [.basic("텍스트"), .basic("페이지"), .basic("할 일 목록"),
                                        .basic("제목1"),.basic("제목2"),.basic("제목3"),
                                        .basic("표"),.basic("글머리 기호 목록"),.basic("번호 매기기 목록"),.basic("토글 목록"),
                                        .basic("인용"), .basic("구분선"), .basic("페이지 링크"), .basic("콜아웃")]
        
        let blockSetting: BehaviorRelay<[ActionType]> = BehaviorRelay<[ActionType]>(value: actionType)
        
        return BlockViewModel(setting: blockSetting)
    }
    
    
    //MARK: - Coordinator make func
    func makePageFlowCoordinator(_ navigationController: UINavigationController) -> PageAppFlowCoordinator{
        return PageAppFlowCoordinator(navigationController, self)
    }
    
    
    //MARK: - DIContainer make
    func makePageDIContainer() -> PageDIContainer {
        return PageDIContainer()
    }
}

extension PageAppDIContainer: PageAppFlowCoordinatorDependencies{}
