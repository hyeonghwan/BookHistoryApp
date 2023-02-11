//
//  PageDIContainer.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/02/11.
//

import UIKit


protocol ScreenCoordinatorProtocol{
    func makeViewController() -> UIViewController
}

class PageDIContainer{
    
    var dependency: ScreenCoordinatorProtocol?
    
    private func makePagesViewController() -> BookPagingViewController
    
    init{
        
    }
}

//class ButtonsDIContainer {
//
//    func makeButtonCoordinator(navigationController: UINavigationController) -> ButtonsCoordinator {
//        return ButtonsCoordinator(navigationController: navigationController, dependencies: self)
//    }
//
//    // Private
//
//    private func makeButtonsUseCaseImpl() -> ButtonsUseCase {
//        return ButtonsUseCaseImpl()
//    }
//
//    private func makeButtonsViewModel(actions: ButtonsViewModelActions) -> ButtonsViewModel {
//        return ButtonsViewModelImpl(actions: actions, buttonUseCase: makeButtonsUseCaseImpl())
//    }
//}
//
//extension ButtonsDIContainer: ButtonsCoordinatorDependencies {
//    func makeButtonViewController(actions: ButtonsViewModelActions) -> ButtonsViewController {
//        return ButtonsViewController.create(with: makeButtonsViewModel(actions: actions))
//    }
//
//    func makeRedViewController(tapCount: Int) -> UIViewController {
//        return RedViewController.create(tapCount: tapCount)
//    }
//
//    func makeBlueViewController(tapCount: Int) -> UIViewController {
//        return BlueViewController.create(tapCount: tapCount)
//    }
//}
