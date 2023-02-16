//
//  PageFlowCoordinator.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/11.
//

import UIKit

//MoviesSearchFlowCoordinatorDependencies
protocol PageAppFlowCoordinatorDependencies{
    
    func makePageDIContainer() -> PageDIContainer
    func makePageFlowCoordinator(_ navigationController: UINavigationController) -> PageAppFlowCoordinator
    
    func makePageListViewController(_ actions: PageListViewModelActions) -> UIViewController
    
    func makePageDependencies(_ pagingType: PagingType) -> PageVCViewModel.PageDependencies
    
//    func makePageViewController(_ viewModel: PageVCViewModelProtocol) -> UIViewController
    
    func makeSettingViewController() -> UIViewController
    func makeCSTabBarController() -> UITabBarController
    func makeTestViewContoller() -> UIViewController
    
}

class PageAppFlowCoordinator{
    
    private let dependencies: PageAppFlowCoordinatorDependencies
    private weak var navigationController: UINavigationController?
    
    
    private var pageNavigationController: UINavigationController?
    private var pageListViewController: PageListVC?
    
    
    private var testVC: TestViewController?
    private var planVC: PlanGoalViewController?
    
    init(_ nav: UINavigationController,_ dependencies: PageAppFlowCoordinatorDependencies){
        self.navigationController = nav
        self.dependencies = dependencies
    }
    
    
    func start(){
        let tap = dependencies.makeCSTabBarController()
        
        pageListViewController = makePageListVC()
        pageNavigationController = UINavigationController(rootViewController: pageListViewController!)
        
        testVC = dependencies.makeTestViewContoller() as? TestViewController
        
        let plan = PlanGoalViewController()
        
        tap.setViewControllers([pageNavigationController!,
                                testVC!,
                                plan], animated: false)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(tap, animated: false)
    }
    
    private func makePageListVC() -> PageListVC{
        
        let actions = PageListViewModelActions(createPage: createPage,
                                               closePage: closePage,
                                               showSettingPage: showSettingPage)
        
        return dependencies.makePageListViewController(actions) as! PageListVC
    }
    
    
    
    //MARK: - PageListVC actions
    //not yet
    func createPage(_ pageModel: PageModel?){
        guard let pagingType = pageListViewController?.bookPagingViewModel else { return }
        let pageDependency = dependencies.makePageDependencies(pagingType)
        let pageDIContainer = dependencies.makePageDIContainer()
        let pageFlowCoordinaotr = pageDIContainer.makePageFlowCoordinator(pageNavigationController)
        pageFlowCoordinaotr.start(pageDependency,pageModel)
    }
    
    // should add store logic
    func closePage(){
        pageNavigationController?.popViewController(animated: true)
    }
    
    // page setting func
    func showSettingPage(_ model: PageModel){
        let vc = dependencies.makeSettingViewController() as! PageSettingViewController
        print("showSettingPage Coordinator: \(model)")
        pageNavigationController?.show(vc, sender: true)
    }
    
    
    //MARK: -Page action
    
    
    
}
