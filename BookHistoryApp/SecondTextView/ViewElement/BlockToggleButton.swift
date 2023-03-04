//
//  BlockToggleButton.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/16.
//

import UIKit
import RxSwift
import RxCocoa

final class TodoBlcokButton: UIButton{
    
    struct TodoBlockDependency{
        weak var todoAction: BlockAttachmentAction?
        var firstInitIndex: Int?
    }
    
    var disposeBag = DisposeBag()
    
    private var depenedency: TodoBlockDependency?
    
    var object: BlockObject?{
        didSet{
            print("self.object?.blockType : \(String(describing: self.object?.object?.e.base.rawValue))")
        }
    }
    
    var checked: Bool = false{
        didSet{
            if self.checked == true{
                self.setImage(UIImage.checkedSquare, for: .normal)
            }else{
                self.setImage(UIImage.square, for: .normal)
            }
        }
    }
   
    var firstInitIndex: Int?
    
    var blockRange: NSRange? {
        getRangeButtonUsingRect(self.frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    convenience init(frame: CGRect,dependency: TodoBlockDependency) {
        self.init(frame: frame)
        self.depenedency = dependency
        self.firstInitIndex = dependency.firstInitIndex
        guard let todoAction = dependency.todoAction else {return}
        
        todoAction
            .createTodoObservable(
                self.rx.tap.asDriver(),
                self
            )
        
        self.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else {return}
                self.checked.toggle()
            })
            .disposed(by: disposeBag)
        
        self.setImage(UIImage.square, for: .normal)
        self.tintColor = UIColor.label
        
        self.contentMode = .scaleAspectFit
        self.imageView?.contentMode = .scaleAspectFit
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    private func getRangeButtonUsingRect(_ frame: CGRect) -> NSRange?{
        guard let layoutManager = depenedency?.todoAction?.layoutManager else {return nil}
        guard let containerInset = depenedency?.todoAction?.textContainerInset else {return nil}
        guard let firstContainer = layoutManager.textContainers.first else {return nil}
        
        var buttonFrame = frame
        buttonFrame.origin.x -= containerInset.left
        buttonFrame.origin.y  -= containerInset.top
        
        let toggleTitleRange = layoutManager.glyphRange(forBoundingRect: buttonFrame, in: firstContainer)
        print("toggleTitleRange : \(toggleTitleRange)")
        return toggleTitleRange
    }
    
    
}


final class BlockToggleButton: UIButton{
    
    struct BlockToggleDependency{
        weak var toggleAction: BlockAttachmentAction?
        var firstInitIndex: Int?
    }
    
    var disposeBag = DisposeBag()
    
    private var depenedency: BlockToggleDependency?
    
    var object: BlockObject?{
        didSet{
            print("self.object?.blockType : \(String(describing: self.object?.object?.e.base.rawValue))")
        }
    }
    
   
    var firstInitIndex: Int?
    
    var blockRange: NSRange? {
        getRangeButtonUsingRect(self.frame)
    }
    
    
    convenience init(frame: CGRect,dependency: BlockToggleDependency) {
        self.init(frame: frame)
        self.depenedency = dependency
        self.firstInitIndex = dependency.firstInitIndex
        guard let toggleAction = dependency.toggleAction else {return}
        
        toggleAction
            .createToggleObservable(
                self.rx.tap.map{ _ in self.imageView?.transform == CGAffineTransform(rotationAngle: 0)
                }.asDriver(onErrorJustReturn: false),
                self
            )
        
        self.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else {return}
                if self.imageView?.transform == CGAffineTransform(rotationAngle: .pi / 2){
                    self.imageView?.transform = self.imageView?.transform.rotated(by: -(.pi / 2)) ?? CGAffineTransform(rotationAngle: -(.pi / 2))
                    
                }else{
                    self.imageView?.transform = self.imageView?.transform.rotated(by: .pi / 2) ?? CGAffineTransform(rotationAngle: .pi / 2)
                }
            })
            .disposed(by: disposeBag)
     
        self.setImage(UIImage(systemName: "play.fill"), for: .normal)
        self.tintColor = UIColor.label
        self.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    private func getRangeButtonUsingRect(_ frame: CGRect) -> NSRange?{
        guard let layoutManager = depenedency?.toggleAction?.layoutManager else {return nil}
        guard let containerInset = depenedency?.toggleAction?.textContainerInset else {return nil}
        guard let firstContainer = layoutManager.textContainers.first else {return nil}
        
        var buttonFrame = frame
        buttonFrame.origin.x -= containerInset.left
        buttonFrame.origin.y  -= containerInset.top
        
        let toggleTitleRange = layoutManager.glyphRange(forBoundingRect: buttonFrame, in: firstContainer)
        print("toggleTitleRange : \(toggleTitleRange)")
        return toggleTitleRange
    }
    
    
}
