//
//  AppDelegate.swift
//  GalleryApplication
//
//  Created by Utsav Shah on 31/03/24.
//

import UIKit
import CoreData
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var autorization: String?
    let defaults = UserDefaults.standard
    
    static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
        return false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
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
        
    func setMainStoryBoard() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigat = UINavigationController()
        navigat.isNavigationBarHidden = false
        
        let mainStoryBoard = UIStoryboard(name: StoryBoard.main, bundle: nil)
        let galleryVc = mainStoryBoard.instantiateViewController(withIdentifier: Controller.galleryVC) as? GalleryViewController ?? GalleryViewController()
        
        // Push the vcw  to the navigat
        navigat.pushViewController(galleryVc, animated: false)
        
        // Set the window’s root view controller
        self.window!.rootViewController = navigat
        // Present the window
        self.window!.makeKeyAndVisible()
    }
    
    func setupThirdParty() {
    }

}
