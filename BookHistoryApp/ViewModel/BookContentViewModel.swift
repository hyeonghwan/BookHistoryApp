//
//  BookContentViewModel.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/26.
//

import Foundation
import RxSwift
import CoreData


protocol ContentViewModelType {
    var onParagraphData: AnyObserver<NSAttributedString> {get}
}

class BookContentViewModel: NSObject, ContentViewModelType{
    
    var onParagraphData: AnyObserver<NSAttributedString>
    
    var disposeBag = DisposeBag()
    
    var container: NSPersistentContainer?
    
    override init() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        container = appDelegate.persistentContainer
        
        let paragraphPipe = PublishSubject<NSAttributedString>()
        
        onParagraphData = paragraphPipe.asObserver()
        
        super.init()
        
        paragraphPipe
            .subscribe(onNext: { [weak self] data in
                guard let self = self else {return}
                
                print("ssibal")
                self.addToCoreData(data)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func addBookPageData(_ object: BookMO){
        guard let container = container else {return}
        
        guard let entity = NSEntityDescription.entity(forEntityName: "BookPage", in: container.viewContext ) else {return}
        
        let data = NSManagedObject(entity: entity, insertInto: container.viewContext)
        
        data.setValue("\(String(describing: object.bookTitle))", forKey: "bookName")
        data.setValue(object, forKey: "bookData")
        print("addBookPageData")
        print(data)
        saveContext()
    }
    
    private func addToCoreData(_ attributedString: NSAttributedString ) {
        guard let container = container else {return}
        
        guard let entity = NSEntityDescription.entity(forEntityName: "BookData", in: container.viewContext ) else {return}
        
        let data = NSManagedObject(entity: entity, insertInto: container.viewContext)
        
        data.setValue("BookHistory", forKey: "bookTitle")
        data.setValue(attributedString, forKey: "bookContent")
        
        let obj = data as! BookMO
        
        addBookPageData(obj)
    }
    
    
    
    private func saveContext() {
        guard let container = container else {return}
        do {
            try container.viewContext.save()
            print("success save")
        }catch{
            print("catch Error 1")
            print(error.localizedDescription)
        }
    }
    
    private func getContainer() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.container = appDelegate.persistentContainer
    }
}
