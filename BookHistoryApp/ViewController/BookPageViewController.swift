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
        
        tableView.register(BookPagingTableViewCell.self, forCellReuseIdentifier: BookPagingTableViewCell.identify)
        
        return tableView
    }()
    
    var container: NSPersistentContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        layoutConfigure()
        
        self.bookPagingTableView.delegate = self
        self.bookPagingTableView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        container = appDelegate.persistentContainer
    
        guard let container = container else {return}
        
        guard let entity = NSEntityDescription.entity(forEntityName: "BookData", in: container.viewContext ) else {return}
        
        let data = NSManagedObject(entity: entity, insertInto: container.viewContext)
        data.setValue("history", forKey: "bookTitle")
        data.setValue("history-content", forKey: "bookContent")
        
        do {
            try container.viewContext.save()
        }catch{
            print("catch Error 1")
            print(error.localizedDescription)
        }
        
        
    }
    
    private func fetchData(){
        guard let container = container else {return}
        do {
            print(111)
            let content = try container.viewContext.fetch(BookMO.fetchRequest()) // as! [BookMO]
            
            content.forEach{ entity in
                
                print(entity.bookTitle)
                print(entity.bookContent)
            }
        }catch{
            print(error.localizedDescription)
        }
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

extension BookPagingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fetchData()
//        let TextVC = SecondViewController()
//        self.navigationController?.pushViewController(TextVC, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
//
    }
}
extension BookPagingViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookPagingTableViewCell.identify, for: indexPath) as? BookPagingTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
