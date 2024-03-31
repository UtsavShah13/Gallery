//
//  NetworkManager+API.swift
//  TasteMaker
//
//  Created by ideveloper1 on 31/03/21.
//

import Foundation
import UIKit

extension NetworkManager {
    
    func handleResponse(result: Any?, complition: ((_ response: [String: Any]) -> Void)) {
        if let data = result as? [String: Any] {
            if let status = data["status"] as? Bool {
                if status == false {
                    Utils.hideSpinner()
                    Utils.alert(message: data["msg"] as? String ?? "")
                } else {
                    complition(data)
                }
            } else if let error = data["errors"] as? String {
                
                Utils.hideSpinner()
                
                if error == "Unauthorized" {
                    Utils.alert(message: "login again")
                } else {
                    Utils.alert(message: error)
                }
                
            } else {
                complition(data)
            }
        } else {
            Utils.hideSpinner()
            Utils.alert(message: "Something went wrong.")
        }
    }
    
    
    func handleError(_ message: String) {
        Utils.hideSpinner()
        if !message.isEmpty {
            Utils.alert(message: message)
        }
    }
    
    func decodeObject<T: Decodable>(fromData data: Any?) -> T? {
        if let data = data {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
                        
            return try? jsonDecoder.decode(
                T.self, from: JSONSerialization.data(withJSONObject: data, options: [])
            ) as T?
        } else {
            return nil
        }
    }
}
