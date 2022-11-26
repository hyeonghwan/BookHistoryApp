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
    
    var container: NSPersistentContainer?
    
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
        
        // load Paging Data
        bookPagingViewModel.showPage
            .observe(on: MainScheduler.instance)
            .bind(to: bookPagingTableView.rx.items(cellIdentifier:BookPagingTableViewCell.identify,
                                                   cellType: BookPagingTableViewCell.self)){
                index, item , cell in
                
                cell.onPageData.onNext(item)
                
            }.disposed(by: disposeBag)
            
        
        bookPagingTableView
            .rx.modelSelected(BookMO.self)
            .subscribe(onNext: { [weak self] e in
                guard let self = self else {return}
                
                let vc = SecondViewController()
                
                vc.textView.attributedText = e.bookContent!
                
                self.navigationController?
                    .pushViewController(vc, animated: false)
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
    }


    
    private func settingNavi() {
        
        self.navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        
    }
    
   
    
    private func layoutConfigure() {
        
        
        self.view.addSubview(bookPagingTableView)
        
        self.title = "Paging"
        
        bookPagingTableView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

