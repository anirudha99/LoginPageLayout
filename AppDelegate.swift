//
//  AppDelegate.swift
//  LoginPageLayout
//
//  Created by Anirudha SM on 18/10/21.
//

import UIKit
import Firebase
import CoreData
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
//import FirebaseFirestore 

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application : UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?)  -> Bool{
        
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    //    func application(_ app: UIApplication,
    //                     open url: URL,
    //                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    //    ) -> Bool {
    //        ApplicationDelegate.shared.application(
    //            app,
    //            open: url,
    //            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
    //            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
    //        )
    //    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var handled: Bool
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        // If not handled by this app, return false.
        return false
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "LoginPageLayout")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}



