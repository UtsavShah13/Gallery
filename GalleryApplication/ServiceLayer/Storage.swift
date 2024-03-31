//
//  Storage.swift
//  Lomo
//
//  Created by Apple on 12/12/22.
//

import UIKit

protocol Storage: AnyObject {
    
    func saveAuthorizedUserInfo(_ userInfo: SignInWithEmailData?)
    func getAuthorizedUserInfo() -> SignInWithEmailData?
    func saveRecentSearch(_ recentSearch: [String]?)
    func getRecentSearch() -> [String]?
    func removeAllRecentSearch()
    
}

class StorageServices: Storage {
    
    private var authorizedUserId: Int?
    
    private let defaults = UserDefaults.standard
    
    private enum Key: String {
        case deviceId
        case accessToken
        case userInfo
        case search
    }
    
    func resetUserData() {
        saveAPIAccessToken("")
        defaults.removeObject(forKey: Key.userInfo.rawValue)
        authorizedUserId = nil
    }

    func getAPIAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: Key.accessToken.rawValue)
    }
    
    func saveAPIAccessToken(_ accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: Key.accessToken.rawValue)
    }

    func saveAuthorizedUserInfo(_ userInfo: SignInWithEmailData?) {
        try? defaults.setData(object: userInfo, forKey: "userInfo")
    }
    
    func getAuthorizedUserInfo() -> SignInWithEmailData? {
        return try? defaults.getData(objectType: SignInWithEmailData.self, forKey: "userInfo")
    }
    
    func getRecentSearch() -> [String]? {
        return UserDefaults.standard.object(forKey: "searchText") as? [String]
    }
    
    func saveRecentSearch(_ recentSearch: [String]?) {
        UserDefaults.standard.set(recentSearch, forKey: "searchText")
    }
    
    func removeAllRecentSearch() {
        UserDefaults.standard.removeObject(forKey: "searchText")
    }

}
