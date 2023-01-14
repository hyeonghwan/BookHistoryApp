//
//  ImageContextMenuButton.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/07.
//

import UIKit
import RxSwift
import RxCocoa

protocol ImageAddProtocol: AnyObject{
    var actionObserver: AnyObserver<ContextMenuEventType>? { get }
}

enum ContextMenuEventType{
    case size
    case photoLibrary
    case photoTake
    case fileAdd
}

final class ImageAddButton: UIButton,ImageAddProtocol{

    weak var accessoryViewModel: AccessoryCompositionProtocol?
    
    var actionObserver: AnyObserver<ContextMenuEventType>?
    
    var disposeBag = DisposeBag()
    
    var actionTriggerPipe = PublishSubject<ContextMenuEventType>()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        /// If the contextMenuInteraction is the primary action of the control, invoked on touch-down. NO by default.
        ///  @available(iOS 14.0, *)
        self.showsMenuAsPrimaryAction = true

        let photoLibraryAddAction =
        UIAction(title: "사진 보관함", image: UIImage(systemName: "folder")) {[weak self] action in
            guard let self = self else {return}
            self.actionTriggerPipe.onNext(.photoLibrary)
        }

        let takePhotoAction =
        UIAction(title: "사진 촬영", image: UIImage(systemName: "square.and.pencil")) {[weak self] action in
            guard let self = self else {return}
            self.actionTriggerPipe.onNext(.photoTake)
        }

        let fileAddAction =
        UIAction(title: "파일 추가", image: UIImage(systemName: "square.and.pencil")) {[weak self] action in
            guard let self = self else {return}
            self.actionTriggerPipe.onNext(.fileAdd)
        }

        let items = [photoLibraryAddAction, takePhotoAction, fileAddAction]

        self.menu = UIMenu(title: "", children: items)
        
    }
    deinit{
        
        self.disposeBag = DisposeBag()
    }
    
    convenience init(_ frame: CGRect,
                     _ accessoryViewModel : AccessoryCompositionProtocol?){
        self.init(frame: frame)
        
        self.accessoryViewModel = accessoryViewModel
        self.actionObserver = actionTriggerPipe.asObserver()

        actionTriggerPipe
            .asSignal(onErrorJustReturn: .size)
            .emit(to: self.accessoryViewModel!.imageAddActionEvent)
            .disposed(by: disposeBag)
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
}
