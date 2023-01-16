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
    let toggleAction: BlockToggleAction
}
final class BlockToggleButton: UIButton{
    
    var disposeBag = DisposeBag()
    
    
    convenience init(frame: CGRect,dependency: BlockToggleDependency) {
        self.init(frame: frame)
        
        dependency.toggleAction
            .createToggleObservable(
                self.rx.tap.map{ _ in self.imageView?.transform == CGAffineTransform(rotationAngle: -(.pi / 2))
                }.asDriver(onErrorJustReturn: false)
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
    
}
