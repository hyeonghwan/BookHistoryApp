//
//  PageFlowCoordinator.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/11.
//

import UIKit

//MoviesSearchFlowCoordinatorDependencies
protocol PageFlowCoordinatorDependencies{
    func makePageFlowCoordinator(_ navigationController: UINavigationController) -> PageFlowCoordinator
    
    func makePageListViewController(_ actions: PageListViewModelActions) -> UIViewController
    
    func makePageDependencies(_ pagingType: PagingType) -> PageVCViewModel.PageDependencies
    
    func makePageViewController(_ dependency: PageVCViewModel.PageDependencies,
                                _ actions: PageViewModelActions) -> UIViewController
    
    func makeSettingViewController() -> UIViewController
    func makeCSTabBarController() -> UITabBarController
    func makeTestViewContoller() -> UIViewController
    
}

class PageFlowCoordinator{
    
    private let dependencies: PageFlowCoordinatorDependencies
    private weak var navigationController: UINavigationController?
    
    
    private var pageNavigationController: UINavigationController?
    private var pageListViewController: PageListVC?
    private var pageViewController: PageVC?
    
    private var testVC: TestViewController?
    private var planVC: PlanGoalViewController?
    
    init(_ nav: UINavigationController,_ dependencies: PageFlowCoordinatorDependencies){
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
    func createPage(){
        guard let pagingType = pageListViewController?.bookPagingViewModel else { return }
        let pageDependency = dependencies.makePageDependencies(pagingType)
        
        let actions: PageViewModelActions = PageViewModelActions()
      
        pageViewController = dependencies.makePageViewController(pageDependency,
                                                                 actions) as? PageVC
        
        pageNavigationController?.pushViewController(pageViewController!, animated: true)
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
