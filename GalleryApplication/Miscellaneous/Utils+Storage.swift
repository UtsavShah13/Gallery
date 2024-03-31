//
//  Utils+Storage.swift
//
//
//  Created by Utsav Shah on 31/03/24.
//

import UIKit

extension Utils {
    
    private enum Key: String {
        case accessToken
        case authorizedUserInfo
    }
    
    func resetUserData() {
        UserDefaults.standard.removeObject(forKey: Key.authorizedUserInfo.rawValue)
        UserDefaults.standard.removeObject(forKey: Key.accessToken.rawValue)
    }
    
    func didSessionEnd() -> Bool {
        let data = UserDefaults.standard.object(forKey: "isLogedIn") as? Bool
        return data ?? false
    }
    
    func setSession(_ isSessionEnd: Bool?) {
        UserDefaults.standard.set(isSessionEnd, forKey: "isSessionEnd")
    }
    
//    func saveAuthorizedUserInfo(_ userInfo: User?) {
//        let v = try? JSONEncoder().encode(userInfo)
//        UserDefaults.standard.set(v, forKey: Key.authorizedUserInfo.rawValue)
//    }
//
//    func getAuthorizedUserInfo() -> User? {
//        if let data = UserDefaults.standard.object(forKey: Key.authorizedUserInfo.rawValue) as? Data {
//            return try? JSONDecoder().decode(User.self, from: data)
//        } else {
//            return nil
//        }
//    }
    
    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: Key.accessToken.rawValue)
    }

    func getAccessToken() -> String {
        return UserDefaults.standard.object(forKey: Key.accessToken.rawValue) as? String ?? ""
    }
    
    func isAuthorized() -> Bool {
        return true
//        getAuthorizedUserInfo() != nil
    }
    
    func saveUserLogedIn(_ isLogedIn: Bool?) {
        UserDefaults.standard.set(isLogedIn, forKey: "isLogedIn")
    }
    
    func getIsUserLogedIn() -> Bool {
        let data = UserDefaults.standard.object(forKey: "isLogedIn") as? Bool
        return data ?? false
    }
    
    func isUserLogedIn() -> Bool {
        return getIsUserLogedIn()
    }
    
}
