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
    
    
    var disposeBag = DisposeBag()
    
    var bookPagingViewModel: PagingType = BookPagingViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
                index, item , cell in
                
                cell.onPageData.onNext(item)
                
            }.disposed(by: disposeBag)
            
        
        //TableView select EVENT
        bookPagingTableView
            .rx.modelSelected(BookMO.self)
            .subscribe(onNext: { [weak self] element in
                guard let self = self else {return}
                
                let vc = SecondViewController()
                
                let item = BookViewModelData(id: element.bookID,
                                             bookTitle: element.bookTitle,
                                             bookContent: element.bookContent,
                                             bookPage: nil)
                
                vc.contentViewModel.onTextViewData.onNext(item)
                
                self.navigationController?
                    .pushViewController(vc, animated: true)
                
            }).disposed(by: disposeBag)

        
        self.navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                
                let vc = SecondViewController()
                vc.bookPagingViewModel = self.bookPagingViewModel
                
                self.navigationController?
                    .pushViewController(vc, animated: false)
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

