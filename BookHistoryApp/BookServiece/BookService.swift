//
//  BookService.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/26.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa


protocol RxBookService {
    var observable: Observable<[BookMO]> { get }
    
    func rxAddParagraphData(_ attributedString: NSAttributedString) -> Observable<Result<Bool,Error>>
    
    func rxGetPages() -> Observable<[BookMO]>
    
    func rxDeletePage() -> Observable<Bool>

}

enum CoreDataError: Error{
    case fetchContainerError
    case entityNameError
    case saveContextError
}


class BookService: NSObject, RxBookService{

    
    var container: NSPersistentContainer?
    
    var observable: Observable<[BookMO]>
    
    override init() {
        
        let booksPipe = PublishSubject<[BookMO]>()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        container = appDelegate.persistentContainer
        
        observable = booksPipe
        
        super.init()
        
    }
    
    func rxAddParagraphData(_ attributedString: NSAttributedString) -> Observable<Result<Bool,Error>> {
        return Observable.create{ [weak self] emitter in
            guard let self = self else {return Disposables.create()}
            
            let result = self.addToCoreData(attributedString)
            
            emitter.onNext(result)
            
            return Disposables.create()
        }
    }
    
    func rxDeletePage() -> Observable<Bool> {
        return Observable.create{ [weak self] emiter in
            
            guard let self = self else { return Disposables.create()}
            
            let data = self.deleteData()
            
            emiter.onNext(data)
            
            return Disposables.create()
        }
    }
    
    
    
    //delete ALL Data in CoreData(entityName -> "BookData")
    func deleteData() -> Bool {
        
        guard let container = self.container else {return false}
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookData")
        
        do{
            
            let result = try container.viewContext.fetch(fetchRequest)
            
            print(result)
            
            result.forEach{ obj in
                
                container.viewContext.delete(obj)
            }
            
            self.saveContext()
            
            return true
            
        }catch{
            return false
        }
    
    }
    
    
    
    func rxGetPages() -> Observable<[BookMO]>{

        return Observable.create { [weak self] observer in
            
            guard let self = self else {return Disposables.create()}
            guard let pageMO = self.getPageData() else {return Disposables.create()}
            
            observer.onNext(pageMO)
            
            return Disposables.create()
        }
    }
    
    
    private func addBookPageData(_ object: BookMO) -> Result<Bool,Error> {
        guard let container = container else {return .failure(CoreDataError.fetchContainerError)}
        
        guard let entity = NSEntityDescription.entity(forEntityName: "BookPage", in: container.viewContext ) else {return .failure(CoreDataError.entityNameError)}
        
        let data = NSManagedObject(entity: entity, insertInto: container.viewContext)
        
        data.setValue("\(String(describing: object.bookTitle))", forKey: "bookName")
        data.setValue(object, forKey: "bookData")
        print("addBookPageData")
        print(data)
        return saveContext()
    }
    
    private func addToCoreData(_ attributedString: NSAttributedString ) -> Result<Bool,Error> {
        guard let container = container else {return .failure(CoreDataError.fetchContainerError)}
        
        guard let entity = NSEntityDescription.entity(forEntityName: "BookData", in: container.viewContext ) else {return .failure(CoreDataError.entityNameError)}
        
        let data = NSManagedObject(entity: entity, insertInto: container.viewContext)
        
        
        data.setValue("BookHistory", forKey: "bookTitle")
        data.setValue(attributedString, forKey: "bookContent")
        
        let obj = data as! BookMO
        
        return addBookPageData(obj)
    }
    
    
    
   
    func getPageData() -> [BookMO]? {
        
        guard let container = self.container else {return []}
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookData")
        
        do{
            let result = try container.viewContext.fetch(fetchRequest) as? [BookMO]
            
            return result
        }catch{
            print("viewContext.fetch(fetchRequest) failed")
            return nil
        }
    }

    
    private func saveContext() -> Result<Bool,Error> {
        guard let container = container else {return .failure(CoreDataError.fetchContainerError)}
        do {
            try container.viewContext.save()
            return .success(true)
        }catch{
            print("catch Error 1")
            print(error.localizedDescription)
            return .failure(CoreDataError.saveContextError)
        }
    }
    
    private func fetchData(){
        guard let container = container else {return}
        do {
            
            let content = try container.viewContext.fetch(BookMO.fetchRequest()) as! [BookPageMO]
            
            content.forEach{ entity in
                
                print(entity.bookName)
                print(entity.bookData)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
}
