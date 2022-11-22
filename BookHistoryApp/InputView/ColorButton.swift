//
//  ColorButton.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/19.
//

import UIKit
import RxCocoa
import RxSwift

class ColorButton: UIButton {

    
    private var contextColor: Color?
    
    private var presentationType: PresentationType?
    
    var colorObservable: Observable<Color>
    
    private var disposeBag = DisposeBag()
    
    
    lazy var colorContextView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    lazy var contextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    fileprivate func layoutConfigure() {
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        
        let colorPipe = PublishSubject<Color>()
        
        colorObservable = colorPipe
        
        super.init(frame: frame)
        
        layoutConfigure()
        
    }
    
    convenience init(frame: CGRect,
                     buttonObserver: AnyObserver<PresentationType>,
                     presentationType: PresentationType) {
        self.init(frame: frame)
        
        configureButton(presentationType)
        
        self.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else {return}
                guard let type = self.presentationType else {return}
                buttonObserver.onNext(type)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    
    
    func configureButton(_ presentationType: PresentationType) {
        
        self.presentationType = presentationType
        
        switch presentationType {
        case let .backGround(color):
            self.contextColor = color
            colorContextView.backgroundColor = color.create
            contextLabel.text = color.rawValue
            
        case let .foreGround(color):
            self.contextColor = color
            colorContextView.backgroundColor = color.create
            contextLabel.text = color.rawValue
        }
       
        self.addSubview(colorContextView)
        self.addSubview(contextLabel)
        
        colorContextView.frame = CGRect(x: 8, y: 20, width: 25, height: 25)
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .heavy)
        label.textColor = .white
        label.text = "가"
        label.sizeToFit()
        colorContextView.addSubview(label)
        
        label.center = CGPointMake(colorContextView.frame.size.width / 2 , colorContextView.frame.size.height / 2)
        
        contextLabel.sizeToFit()
        
        contextLabel.frame = CGRect(x: colorContextView.frame.origin.x + colorContextView.frame.width + 10,
                                    y: colorContextView.frame.origin.y,
                                    width: contextLabel.bounds.width, height: contextLabel.bounds.height)
        
    }
    
    
}
