//
//  CSTabBarController.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/20.
//

import UIKit
import SnapKit

final class CSTabBarController: UITabBarController{
    
  
    struct TabBarModel{
        let currentIndex: Int = 0
        let bottomTabBarHeight: CGFloat = 80
        let tabModels: [BottomStackItem]
    }
    
    
    init(currentIndex: Int = 0,
         bottomTabBarHeight: CGFloat = 80,
         tabModels: [BottomStackItem]) {
        
        self.currentIndex = currentIndex
        self.bottomTabBarHeight = bottomTabBarHeight
        self.tabModels = tabModels
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func create(with model: TabBarModel) -> CSTabBarController{
        return CSTabBarController(currentIndex: model.currentIndex,
                                  bottomTabBarHeight: model.bottomTabBarHeight,
                                  tabModels: model.tabModels)
    }
    
    private var currentIndex = 0
    
    //Tab Bar Height Size
    private var bottomTabBarHeight: CGFloat = 80
    
    private var tabModels: [BottomStackItem]
    
    lazy var tabs: [StackItemView] = {
        var items = [StackItemView]()
        for _ in 0..<5{
            items.append(StackItemView.newInstance)
        }
        return items
    }()
    
    
    private lazy var bottomContainer: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.systemPink
        return view
    }()

    private lazy var bottomStack: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.axis = .horizontal
        return stackView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        layoutConfigure()
        self.setupTabs()
    }
    
    fileprivate func setupTabs() {
        for (index, model) in self.tabModels.enumerated() {
            let tabView = self.tabs[index]
            model.isSelected = index == 0
            tabView.item = model
            tabView.delegate = self
            
            self.bottomStack.addArrangedSubview(tabView)
        }
    }
    
    fileprivate func layoutConfigure() {
        self.view.backgroundColor = .systemPink
        
        self.view.addSubview(bottomContainer)
        bottomContainer.addSubview(bottomStack)
        
        bottomContainer.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(bottomTabBarHeight)
        }
        
        bottomStack.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
        bottomStack.backgroundColor = .systemPink
        
    }
}
extension CSTabBarController: StackItemViewDelegate {
    
    func handleTap(_ view: StackItemView) {
        self.tabs[self.currentIndex].isSelected = false
        view.isSelected = true
        self.currentIndex = self.tabs.firstIndex(where: { $0 === view }) ?? 0
        self.selectedIndex = self.currentIndex
    }
    
}
