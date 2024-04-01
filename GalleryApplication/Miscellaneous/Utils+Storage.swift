//
//  Utils+Storage.swift
//
//
//  Created by Utsav Shah on 31/03/24.
//

import UIKit
import GoogleSignIn

extension Utils {
    
    private enum Key: String {
        case emailId
        case userName
        case isLogedIn
    }
    
    func resetUserData() {
        UserDefaults.standard.removeObject(forKey: Key.userName.rawValue)
        UserDefaults.standard.removeObject(forKey: Key.emailId.rawValue)
        UserDefaults.standard.removeObject(forKey: Key.isLogedIn.rawValue)
    }
    
    func saveUserName(_ token: String) {
        UserDefaults.standard.set(token, forKey: Key.userName.rawValue)
    }
    
    func saveEmailId(_ token: String) {
        UserDefaults.standard.set(token, forKey: Key.emailId.rawValue)
    }

    
    func getUserName() -> String {
        let data = UserDefaults.standard.object(forKey: Key.userName.rawValue) as? String
        return data ?? ""
    }
    
    func getEmailId() -> String {
        let data = UserDefaults.standard.object(forKey: Key.emailId.rawValue) as? String
        return data ?? ""
    }

    
    func saveUserLogedIn(_ isLogedIn: Bool?) {
        UserDefaults.standard.set(isLogedIn, forKey: Key.isLogedIn.rawValue)
    }
    
    func getIsUserLogedIn() -> Bool {
        let data = UserDefaults.standard.object(forKey: Key.isLogedIn.rawValue) as? Bool
        return data ?? false
    }
    
    func isUserLogedIn() -> Bool {
        return getIsUserLogedIn()
    }
    
}
