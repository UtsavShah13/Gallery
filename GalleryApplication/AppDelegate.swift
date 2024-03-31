//
//  AppDelegate.swift
//  GalleryApplication
//
//  Created by Utsav Shah on 31/03/24.
//

import UIKit
import CoreData
import GoogleSignIn
//import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var autorization: String?
    let defaults = UserDefaults.standard
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        checkRegistrationFlow()
        setupThirdParty()
        return true
    }
        
    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
                
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    
    class var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func checkRegistrationFlow() {
        
        if Utils.shared.getIsUserLogedIn() {
            setMainStoryBoard()
        } else {
            setAuthorizationStoryBoard()
        }
    }
    
    func setAuthorizationStoryBoard() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigat = UINavigationController()
        navigat.isNavigationBarHidden = false
        
        let mainStoryBoard = UIStoryboard(name: StoryBoard.authorization, bundle: nil)
        let optionVc = mainStoryBoard.instantiateViewController(withIdentifier: Controller.loginVC) as? LoginViewController ?? LoginViewController()
        
        // Push the vcw  to the navigat
        navigat.pushViewController(optionVc, animated: false)
        // Set the window’s root view controller
        self.window!.rootViewController = navigat
        // Present the window
        self.window!.makeKeyAndVisible()
    }
    
    func setupThirdParty() {
    }
    
    func setMainStoryBoard() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigat = UINavigationController()
        navigat.isNavigationBarHidden = false
//
        let mainStoryBoard = UIStoryboard(name: StoryBoard.main, bundle: nil)
        let galleryVc = mainStoryBoard.instantiateViewController(withIdentifier: Controller.galleryVC) as? GalleryViewController ?? GalleryViewController()
        
        // Push the vcw  to the navigat
        // Set the window’s root view controller
        self.window!.rootViewController = navigat
        // Present the window
        self.window!.makeKeyAndVisible()
        
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "GalleryApplication")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

