//
//  PageDIContainer.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/13.
//

import UIKit
import ParagraphTextKit
import SubviewAttachingTextView


class PageDIContainer{

    
    init(){}
    
    
    func makePageViewController(_ pageViewModel: PageVCViewModelProtocol) -> PageVC{
        let pageVC = PageVC.create(with: pageViewModel)
        pageVC.pageViewModel.pageVC = pageVC
        
        let validatorUseCase = makeParagraphValidatorUseCase()
        
        pageVC.pageViewModel.setParagraphUseCase(validatorUseCase)
        
        return pageVC
    }
    
    //MARK: - TextValidator
    func makeParagraphValidatorUseCase() -> ParagraphValidatorProtocol{
        return ParagraphValidator()
    }

    
    func makePageFlowCoordinator(_ navigationController: UINavigationController?) -> PageFlowCoordinator{
        return PageFlowCoordinator(navigationController,self)
    }
    
}
extension PageDIContainer: PageFlowCoordinatorDependencies{ }
