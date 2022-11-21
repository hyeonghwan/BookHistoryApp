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

class BackGroundPickerView: UIInputView{
    
    
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
    
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var verticalStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var colorButton: ColorButton = {
        let button = ColorButton(frame: .zero, buttonObserver: buttonObserver)
        return button
    }()
    
    private lazy var colorButton3: ColorButton = {
        let button = ColorButton(frame: .zero, buttonObserver: buttonObserver)
        return button
    }()
    
    private lazy var colorButton5: ColorButton = {
        let button = ColorButton(frame: .zero, buttonObserver: buttonObserver)
        return button
    }()
    
    private lazy var colorButton7: ColorButton = {
        let button = ColorButton(frame: .zero, buttonObserver: buttonObserver)
        return button
    }()
    
    private lazy var colorButton2: ColorButton = {
        let button = ColorButton(frame: .zero, buttonObserver: buttonObserver)
        return button
    }()
    
    private lazy var colorButton4: ColorButton = {
        let button = ColorButton(frame: .zero, buttonObserver: buttonObserver)
        return button
    }()
    
    private lazy var colorButton6: ColorButton = {
        let button = ColorButton(frame: .zero, buttonObserver: buttonObserver)
        return button
    }()

    private lazy var colorButton8: ColorButton = {
        let button = ColorButton(frame: .zero, buttonObserver: buttonObserver)
        return button
    }()
    
    //input
    var buttonObserver: AnyObserver<PresentationType>
    
    //output
    var buttonObservable: Observable<PresentationType>
    
    var disposeBag = DisposeBag()
    
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
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(500).priority(.low)
        }
        
        [sectionForeTitle,
         sectionBackTitle,
         verticalStackView,
         verticalStackView2].forEach{
            self.containerView.addSubview($0)
        }
        
        sectionForeTitle.snp.makeConstraints{
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        verticalStackView.snp.makeConstraints{
            $0.top.equalTo(sectionForeTitle.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
        
        
        verticalStackView2.snp.makeConstraints{
            $0.top.equalTo(sectionForeTitle.snp.bottom).offset(12)
            $0.leading.equalTo(verticalStackView.snp.trailing)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        
        
        [colorButton5,colorButton,colorButton3,colorButton7].forEach{
            verticalStackView.addArrangedSubview($0)
            $0.snp.makeConstraints{
                $0.leading.equalToSuperview().inset(16)
                $0.width.equalTo(UIScreen.main.bounds.width / 2 - 24)
                $0.height.equalTo(60)
            }
        }
        
        colorButton5.configureButton(.clear, .clear)
        colorButton.configureButton(.systemCyan, .systemCyan)
        colorButton3.configureButton(.blue, .blue)
        colorButton7.configureButton(.systemMint, .systemMint)
        
        
        [colorButton2,colorButton4,colorButton6,colorButton8].forEach{
            verticalStackView2.addArrangedSubview($0)
            $0.snp.makeConstraints{
                $0.width.equalTo(UIScreen.main.bounds.width / 2 - 24)
                $0.height.equalTo(60)
            }
        }

        colorButton2.configureButton(.red, .red)
        colorButton4.configureButton(.green,.green)
        colorButton6.configureButton(.systemPink, .systemPink)
        colorButton8.configureButton(.systemPurple, .systemPurple)
    }
}
