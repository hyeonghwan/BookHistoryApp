//
//  AppDelegate.swift
//  BookHistoryApp
//
//  Created by 박형환 on 2022/11/08.
//

import UIKit
import CoreData

 @main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    lazy var persistentContainer: NSPersistentContainer = {
        
        ValueTransformer.setValueTransformer(NSAttributedStringTransformer(), forName: NSValueTransformerName( "NSAttributedStringTransformer"))
        
        ValueTransformer.setValueTransformer(BlockObjectTransformer(), forName: NSValueTransformerName( "BlockObjectTransformer"))
        
        ValueTransformer.setValueTransformer(IdentifierTransformer(), forName: NSValueTransformerName("IdentifierTransformer"))
        
        let container = NSPersistentContainer(name:"BookData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                
                fatalError("coredata Container load Failed : \(error)")
            }
        })
        
        return container
    }()
    
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
                
            }catch{
                let nsError = error as NSError
                fatalError("UnresolvedError : \(nsError), \(nsError.userInfo)")
                
            }
        }
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    

}

