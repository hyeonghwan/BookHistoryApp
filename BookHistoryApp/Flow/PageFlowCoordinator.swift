//
//  PageFlowCoordinator.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/13.
//

import UIKit
import SubviewAttachingTextView
import ParagraphTextKit

protocol PageFlowCoordinatorDependencies{
    func makePageViewController(_ pageViewModel: PageVCViewModelProtocol) -> PageVC
}


class PageFlowCoordinator {
    var dependency: PageFlowCoordinatorDependencies?
    weak var navigationController: UINavigationController?
    var pageViewController: PageVC?
    
    init(_ navigation: UINavigationController?,
         _ dependency: PageFlowCoordinatorDependencies){
        self.navigationController = navigation
        self.dependency = dependency
    }
    
    func start(_ pageDependency: PageVCViewModel.PageDependencies,
               _ pageModel: PageModel?){
        let actions: PageViewModelActions = PageViewModelActions(pageModel: pageModel)
        
        let pageVcViewModel = PageVCViewModel(pageDependency, actions)
        
        pageViewController = dependency?.makePageViewController(pageVcViewModel)
        
        navigationController!.pushViewController(pageViewController!, animated: true)
    }
    
    
    func make(){
        
    }
}



