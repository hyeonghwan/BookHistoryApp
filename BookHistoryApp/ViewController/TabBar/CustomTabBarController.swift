////
////  CustomTabBarController.swift
////  BookHistoryApp
////
////  Created by 박형환 on 2022/12/19.
////
//
//import UIKit
//import SnapKit
//
//
//
//final class BottomStackTabViewController: UIViewController {
//    
//    let testVC = UIViewController()
//    
//    var bookPagingVC: BookPagingViewController?
//    var viewController: ViewController?
//    var secondViewController: SecondViewController?
//    
//    var navVC: UINavigationController?
//    
//    var currentViewController: UIViewController?
//    
//    var currentIndex = 0
//    
//    //Tab Bar Height Size
//    private var bottomTabBarHeight: CGFloat = 100
//    
//    
//    private var bottomContainer: UIView = {
//       let view = UIView()
//        view.backgroundColor = UIColor.white
//        return view
//    }()
//
//    private lazy var bottomStack: UIStackView = {
//        let stackView = UIStackView()
//        stackView.alignment = .center
//        stackView.distribution = .equalSpacing
//        stackView.spacing = 5
//        stackView.axis = .horizontal
//        return stackView
//    }()
//    
//  
//
//    lazy var tabs: [StackItemView] = {
//        var items = [StackItemView]()
//        
//        let instance = StackItemView.newInstance
//        instance.containerVC = navVC
//        items.append(instance)
//        
//        let instance2 = StackItemView.newInstance
//        instance.containerVC = viewController
//        items.append(instance2)
//        
//        let instance3 = StackItemView.newInstance
//        instance.containerVC = secondViewController
//        items.append(instance3)
//        
//        let instance4 = StackItemView.newInstance
//        instance.containerVC = self
//        items.append(instance4)
//        
//        return items
//    }()
//    
//    
//    lazy var tabModels: [BottomStackItem] = {
//        
//        return [
//            BottomStackItem(title: "Home", image: "house"),
//            BottomStackItem(title: "Favorites", image: "heart"),
//            BottomStackItem(title: "Search", image: "magnifyingglass"),
//            BottomStackItem(title: "Profile", image: "Person"),
//        ]
//    }()
//    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    
//    convenience init(_ VCArray: [UIViewController]) {
//        self.init(nibName: nil, bundle: nil)
//        self.bookPagingVC = VCArray[0] as? BookPagingViewController
//        self.viewController = VCArray[1] as? ViewController
//        self.secondViewController = VCArray[2] as? SecondViewController
//        navVC = UINavigationController(rootViewController: self.bookPagingVC ?? UIViewController())
//
//        add_ViewController(navVC!)
//        add_ViewController(viewController!)
//        add_ViewController(secondViewController!)
//        
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    // Adding
//    func add_ViewController(_ vc: UIViewController) {
//
//        var bounds = self.view.bounds
//        bounds.size.height -= bottomTabBarHeight
//        vc.view.frame = bounds
//        self.view.addSubview(vc.view)
//        self.addChild(vc)
////        vc.didMove(toParent: self)
//        
////        self.secondViewController = controller
//    }
//    
//    // Removing
//    func remove_ViewController(secondViewController:UIViewController?) {
//        if secondViewController != nil {
//            if self.view.subviews.contains(secondViewController!.view) {
//                secondViewController!.view.removeFromSuperview()
//            }
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        layoutConfigure()
//        self.setupTabs()
//        
//        
//        
//    }
//
//    fileprivate func setupTabs() {
//        for (index, model) in self.tabModels.enumerated() {
//            let tabView = self.tabs[index]
//            model.isSelected = index == 0
//            tabView.item = model
//            tabView.delegate = self
//            
//            self.bottomStack.addArrangedSubview(tabView)
//        }
//    }
//    
//    fileprivate func layoutConfigure() {
//        self.view.backgroundColor = .systemPink
//        
//        self.view.addSubview(bottomContainer)
//        bottomContainer.addSubview(bottomStack)
//        
//        bottomContainer.snp.makeConstraints{
//            $0.leading.trailing.bottom.equalToSuperview()
//            $0.height.equalTo(bottomTabBarHeight)
//        }
//        
//        bottomStack.snp.makeConstraints{
//            $0.leading.trailing.equalToSuperview().inset(10)
//            $0.top.bottom.equalToSuperview()
//        }
//        
//        
//        bottomStack.backgroundColor = .white
//    }
//    
//}
//
//extension BottomStackTabViewController: StackItemViewDelegate {
//    
//    func handleTap(_ view: StackItemView, _ vc: UIViewController) {
//        
//        self.tabs[self.currentIndex].isSelected = false
//        view.isSelected = true
//        vc.didMove(toParent: self)
//        self.currentIndex = self.tabs.firstIndex(where: { $0 === view }) ?? 0
//        
//    }
//    
//}
