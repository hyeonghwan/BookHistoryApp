//
//  BookPageViewController.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/23.
//

import UIKit
import SnapKit
import CoreData
import RxCocoa
import RxSwift

class BookPagingViewController: UIViewController {
    
    static func create(dependency: PagingType) -> BookPagingViewController{
        return BookPagingViewController(dependency)
    }
    
    var disposeBag = DisposeBag()
    
    var bookPagingViewModel: PagingType
    
    
    init(_ type: PagingType) {
        self.bookPagingViewModel = type
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private lazy var bookPagingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.backgroundColor = .tertiarySystemBackground
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = CGFloat(60)
        
        tableView.register(BookPagingTableViewCell.self,
                           forCellReuseIdentifier: BookPagingTableViewCell.identify)
        
        return tableView
    }()
    
    private lazy var recentPagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize(width: 110, height: 110)
        
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .tertiarySystemBackground
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: PageCell.identify)
        let insetValue: CGFloat = 15
        collectionView.contentInset = UIEdgeInsets(top: insetValue,
                                                   left: insetValue,
                                                   bottom: insetValue,
                                                   right: insetValue)
        return collectionView
    }()
    
    
    

    func testFunction(){
        let coldObservable = Observable<Int>.create { observer in
            print("Subscribed")
            observer.onNext(1)
            observer.onNext(2)
            observer.onCompleted()
            return Disposables.create()
        }

        coldObservable.subscribe(onNext: { value in
            print("Subscriber 1: \(value)")
        })

        coldObservable.subscribe(onNext: { value in
            print("Subscriber 2: \(value)")
        })
        
        let hotObservable = BehaviorRelay<Int>(value: 100)
        print("-----")
        hotObservable.subscribe(onNext: { value in
            print("Subscriber 1: \(value)")
        })

        hotObservable.accept(1)
        hotObservable.accept(2)

        hotObservable.subscribe(onNext: { value in
            print("Subscriber 2: \(value)")
        })
        hotObservable.accept(4)
        
        print("-----")
        
        let ob = BehaviorSubject<Int>(value: 1)
        ob.subscribe(onNext: {
            print("oibbb : \($0)")
        })
        ob.subscribe(onNext: {
            print("oibbb : \($0)")
        })
        
        
      
    }
//    class DeallocPrinter {
//        deinit {
//            print("deallocated")
//        }
//    }
//
//    struct SomeStruct {
//        let printer = DeallocPrinter()
//    }
//
//    func test(_ some: SomeStruct){
//        print("some: \(some)")
//    }
//    var t : SomeStruct?
    override func viewDidLoad() {
        super.viewDidLoad()
//        t = SomeStruct()
//        test(t!)
//
        print("\(("\u{fffc}리스트\n").count)")
        print("\(("\u{fffc}리스트\n").length)")
        print("\u{fffc}리스트\n")
        layoutConfigure()
        
        settingNavi()
        
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookPagingViewModel.onPaging.onNext(())
    }
    
    
    private func setupBinding(){
        
        // load Recent Page Data to CollectionView
        bookPagingViewModel.showPage
            .observe(on: MainScheduler.instance)
            .bind(to: recentPagesCollectionView.rx.items(cellIdentifier: PageCell.identify,
                                                         cellType: PageCell.self)){
                index, item, cell in
               
                cell.onRecentPageData.onNext(item)
                
            }.disposed(by: disposeBag)
        
        
        // load Paging Data to TableView
        bookPagingViewModel.showPage
            .observe(on: MainScheduler.instance)
            .bind(to: bookPagingTableView.rx.items(cellIdentifier:BookPagingTableViewCell.identify,
                                                   cellType: BookPagingTableViewCell.self)){
                [weak self] index, item , cell in
                guard let self = self else {return}
                cell.rx.cellBinder.onNext((item,self.bookPagingViewModel))
                
            }.disposed(by: disposeBag)
            
        
        //TableView select EVENT
        bookPagingTableView
            .rx.modelSelected(PageModel.self)
            .withUnretained(self)
//            .flatMap{ own,pageValue in own.bookPagingViewModel.getChildBlocksOFPage(pageValue)}
//            .map{  $0.compactMap{ page_block in page_block.ownObject } }
            .subscribe(onNext: { owned,value in
                owned.bookPagingViewModel.createPage(value)
            }).disposed(by: disposeBag)

        
        self.navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.bookPagingViewModel.createPage(nil)
            })
            .disposed(by: disposeBag)
        
        
        self.navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.bookPagingViewModel.deletePage.onNext(())
            })
            .disposed(by: disposeBag)
    }


    
    private func settingNavi() {
        
        self.navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    private func layoutConfigure() {
        
        self.view.addSubview(recentPagesCollectionView)
        self.view.addSubview(bookPagingTableView)
        
        self.title = "Paging"
        
        recentPagesCollectionView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        bookPagingTableView.snp.makeConstraints{
            $0.top.equalTo(recentPagesCollectionView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

