//
//  BlockToggleButton.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2023/01/16.
//

import UIKit
import RxSwift
import RxCocoa


struct BlockToggleDependency{
    weak var toggleAction: BlockToggleAction?
    var blockObject: BlockObject?
    
}
final class BlockToggleButton: UIButton{
    
    var disposeBag = DisposeBag()
    var element: BlockObject?
    
    convenience init(frame: CGRect,dependency: BlockToggleDependency) {
        self.init(frame: frame)
        guard let toggleAction = dependency.toggleAction else {return}
        guard let element = dependency.blockObject else {return}
        self.element = element
        
        toggleAction
            .createToggleObservable(
                self.rx.tap.map{ _ in self.imageView?.transform == CGAffineTransform(rotationAngle: -(.pi / 2))
                }.asDriver(onErrorJustReturn: false)
            )
        
        self.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else {return}
                print("BlockToggleButton : \(self.frame)")
                print("BlockToggleButton : \(self.bounds)")
                print("element: \(self.element)")
                
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
    
}
