//
//  BackGroundPickerView.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/19.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class BackORForeColorPickerView: UIInputView{
    
    
    private var screenWidhth: CGFloat = UIApplication.shared.keyWindow!.frame.width
    
    private lazy var buttonWidth = screenWidhth / 2 - 24
    
    private let buttonHeight: CGFloat = 60
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    private lazy var sectionForeTitle: UILabel = {
        let label = UILabel()
        label.text = "색"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var sectionBackTitle: UILabel = {
        let label = UILabel()
        label.text = "배경"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    
    private lazy var vStackForeGroundLeftView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var vStackForeGroundRightView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var vStackBackGroundRightView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var vStackBackGroundLeftView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()

    //input
    private var buttonObserver: AnyObserver<PresentationType>
    
    //output
    var buttonObservable: Observable<PresentationType>
    
    private var disposeBag = DisposeBag()
    
    
    override init(frame: CGRect,inputViewStyle: UIInputView.Style) {
        
        let colorObserverPipe = PublishSubject<PresentationType>()
        
        buttonObserver = colorObserverPipe.asObserver()
        
        let colorObervablePipe = PublishSubject<PresentationType>()
        
        buttonObservable = colorObervablePipe
        
        super.init(frame: frame,inputViewStyle: inputViewStyle)
    
        
        colorObserverPipe
            .bind(onNext: colorObervablePipe.onNext(_:))
            .disposed(by: disposeBag)
        
        autoLayoutAdd()
        
    }
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
    
    fileprivate func autoLayoutAdd() {
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        
        scrollView.addSubview(containerView)
        
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.height.equalTo(500).priority(.low)
        }
        
        [sectionForeTitle,
         sectionBackTitle,
         vStackForeGroundLeftView,
         vStackForeGroundRightView,
         sectionBackTitle,
         vStackBackGroundLeftView,
        vStackBackGroundRightView].forEach{
            self.containerView.addSubview($0)
        }
        
        sectionForeTitle.snp.makeConstraints{
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        vStackForeGroundLeftView.snp.makeConstraints{
            $0.top.equalTo(sectionForeTitle.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        
        
        vStackForeGroundRightView.snp.makeConstraints{
            $0.top.equalTo(sectionForeTitle.snp.bottom).offset(12)
            $0.leading.greaterThanOrEqualTo(vStackForeGroundLeftView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        sectionBackTitle.snp.makeConstraints{
            $0.top.equalTo(vStackForeGroundLeftView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        vStackBackGroundLeftView.snp.makeConstraints{
            $0.top.equalTo(sectionBackTitle.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        
        vStackBackGroundRightView.snp.makeConstraints{
            $0.top.equalTo(sectionBackTitle.snp.bottom).offset(12)
            $0.leading.greaterThanOrEqualTo(vStackBackGroundLeftView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-100)
        }
        
        
        makeColorButton(vStackForeGroundLeftView,
                        buttonObserver,
                        PresentationType.getForeGroundColor([.clear,.systemCyan,.blue,.systemMint]))
        
        makeColorButton(vStackForeGroundRightView,
                        buttonObserver,
                        PresentationType.getForeGroundColor([.red,.green,.systemPink,.systemPurple]))

        makeColorButton(vStackBackGroundLeftView,
                        buttonObserver,
                        PresentationType.getBackGroundColor([.clear,.systemCyan,.blue,.systemMint]))
        
        makeColorButton(vStackBackGroundRightView,
                        buttonObserver,
                        PresentationType.getBackGroundColor([.red,.green,.systemPink,.systemPurple]))
        
        
        
    }
    
    private func makeColorButton(_ view: UIStackView,
                                 _ observer: AnyObserver<PresentationType>,
                                 _ presentationTypes: [PresentationType]) {
        
        presentationTypes.forEach{ presentationType in
            let button = ColorButton(frame: .zero, buttonObserver: observer, presentationType: presentationType)
            view.addArrangedSubview(button)
            button.snp.makeConstraints{
                $0.width.equalTo(buttonWidth)
                $0.height.equalTo(buttonHeight)
            }
        }
    }
    
}
