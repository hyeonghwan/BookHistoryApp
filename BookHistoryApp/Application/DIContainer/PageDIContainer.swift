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
        
        
        let validatorUseCase = makeParagraphValidatorUseCase(pageVC.pageViewModel)
        
        pageVC.pageViewModel.settingValidatorUseCaseDependency(validatorUseCase)
        
        return pageVC
    }
    
    //MARK: - TextValidator
    func makeParagraphValidatorUseCase(_ dependency: PageVCValidDelegate) -> ParagraphValidatorProtocol{
        return ParagraphValidator(dependencies: ParagraphValidator.Dependencies(pageViewModel: dependency) )
    }

    
    func makePageFlowCoordinator(_ navigationController: UINavigationController?) -> PageFlowCoordinator{
        return PageFlowCoordinator(navigationController,self)
    }
    
}
extension PageDIContainer: PageFlowCoordinatorDependencies{ }
