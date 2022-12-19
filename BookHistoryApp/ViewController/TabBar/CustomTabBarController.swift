//
//  CustomTabBarController.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/12/19.
//

import UIKit
import SnapKit

class BottomStackTabViewController: UIViewController {
    
    private var bottomContainer: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
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
    
    var currentIndex = 0
    
    
    lazy var tabs: [StackItemView] = {
        var items = [StackItemView]()
        for _ in 0..<5 {
            items.append(StackItemView.newInstance)
        }
        return items
    }()
    
    
    lazy var tabModels: [BottomStackItem] = {
        return [
            BottomStackItem(title: "Home", image: "house"),
            BottomStackItem(title: "Favorites", image: "heart"),
            BottomStackItem(title: "Search", image: "magnifyingglass"),
            BottomStackItem(title: "Profile", image: "Person"),
        ]
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            $0.height.equalTo(100)
        }
        
        bottomStack.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        
        bottomStack.backgroundColor = .white
    }
    
}

extension BottomStackTabViewController: StackItemViewDelegate {
    
    func handleTap(_ view: StackItemView) {
        self.tabs[self.currentIndex].isSelected = false
        view.isSelected = true
        self.currentIndex = self.tabs.firstIndex(where: { $0 === view }) ?? 0
    }
    
}
