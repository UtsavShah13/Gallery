//
//  ServerCommunicationManager.swift
//  DeliverIt
//
//  Created by i Mac on 09/01/20.
//  Copyright © 2020 i Mac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Reachability
import SystemConfiguration

extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd.ms-powerpoint",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
    ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
}

enum MediaType {
    
    case image
    case bitmapImage
    case gifImage
    case pdfFile
    case ppt
    case jpeg
    case tiff
    case vnd
    case plain
    case none
    case video
    
    var mimeType: String {
        switch self {
        case .image:       return "image/png"
        case .gifImage:    return "image/gif"
        case .bitmapImage: return "image/bitmap"
        case .pdfFile:     return "application/pdf"
        case .ppt:         return "application/vnd.ms-powerpoint"
        case .jpeg:        return "image/jpeg"
        case .tiff:        return "image/tiff"
        case .vnd:         return "application/vnd"
        case .plain:       return "text/plain"
        case .video:       return "video/mp4"
        case .none:        return ""
        }
    }
    
    var fileExtension: String {
        switch self {
        case .image:        return ".png"
        case .bitmapImage:  return ".bmp"
        case .gifImage:     return ".gif"
        case .pdfFile:      return ".pdf"
        case .ppt:          return ".ppt"
        case .jpeg:         return ".jpeg"
        case .tiff:         return ".tiff"
        case .vnd:          return ".vnd"
        case .plain:        return ".plain"
        case.video:         return ".mp4"
        case .none:         return ""
        }
    }
    
}

// MARK: - EnumWebService

enum EnumWebService {

// Eg :-   case uploadNewFeed(Data, Data, [String : Any])
    
    var url : String {
        var apiName = ""
        switch self {
// EG:-        case .signInWithEmail:             apiName = ServerConstant.WebService.SignInWithEmail.name

        }
        
        return "\(ServerConstant.WebService.apiURL)\(apiName)"
    }
    
    var encoding : ParameterEncoding {
        switch self{
//        case .signInWithEmail,
//    eg:-              .addRemoveFavouriteHashTag:                  return URLEncoding.httpBody
//        case .misc,
//Eg:                .getAllOldMessagesForSingleUser:             return URLEncoding.queryString
        default:                                             return JSONEncoding.default
        }
    }
    
    //    MARK: - HTTPMethod
    
    var httpMethod : HTTPMethod {
        switch self {
//        case .signInWithEmail,
//                .uploadNewFeed:                                  return HTTPMethod.post
//        case .getIntrest,
//                .getAllOldMessagesForSingleUser:                    return HTTPMethod.get
        default:                                                    return HTTPMethod.delete
        }
    }
    
    var isMultipart : Bool {
        switch self{
//        case .misc,
//                .uploadNewFeed:                   return true
        default:                                  return false
        }
    }
    
    var mediaType: MediaType {
        switch self {
//        case .misc:                       return MediaType.gifImage
//        case .updateProfileImage:         return MediaType.image
        default:                          return MediaType.none
        }
    }
    
    //    MARK: - HTTPHeaders
    
    var httpHeaders : HTTPHeaders {
        switch self {
//        case .getIntrest,
//                .getAllOldMessagesForSingleUser:  return ServerCommunicationManager.getAuthotizationTokenHeader()
        default:                                  return ServerCommunicationManager.getDefaultlHeader()
        }
    }
    
    
    //    MARK: - Parameters
    
    var parameters : [String : Any]? {
        switch self {
//        case .uploadNewFeed(let thumbnail, let feed, let param):
//            var parameter = [String : Any].init()
//            parameter.updateValue(thumbnail, forKey: "thumbnail")
//            parameter.updateValue(feed, forKey: "feed")
//            parameter.merge(param) { (current, _) in current }
//            return parameter
        default:
            return nil
        }
    }
}

class ServerCommunicationManager {
    
    typealias APICompletion = (Bool,String,Int,Any?,Error?) -> Void
    let manager : SessionManager
    init() {
        self.manager = Alamofire.SessionManager.default
    }
}

extension ServerCommunicationManager {
    
    fileprivate class func getAuthotizationTokenHeader() -> HTTPHeaders {
        var httpHeader = HTTPHeaders.init()
        httpHeader.updateValue(Constant.appDelegate.autorization!, forKey: "Authorization")
        return httpHeader
    }
    
    fileprivate class func getDefaultlHeader() -> HTTPHeaders {
        let httpheader = HTTPHeaders.init()
        //        httpheader.updateValue("application/x-www-form-urlencoded", forKey: "Content-Type")
        return httpheader
    }
    
    fileprivate class func getFormHeader() -> HTTPHeaders {
        //         var httpheader = HTTPHeaders.init()
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
    
}

extension ServerCommunicationManager {
    
    @discardableResult
    func apiCall(forWebService webService: EnumWebService, completion:@escaping APICompletion) -> DataRequest? {
        
        if (Reachability.isConnectedToNetwork()) {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            if webService.isMultipart == true {
                self.multipartFormRequest(webService: webService, completion: completion)
            } else {
                print("************* Request Parameters: *************\n\(JSON(webService.parameters ?? [:]).rawString() ?? "")\n***********************************************\n")
                let dataRequest = self.apiCall(withURL: webService.url, method: webService.httpMethod, parameters: webService.parameters, encoding: webService.encoding, headers: webService.httpHeaders, completion: completion, webService: webService)
                return dataRequest
            }
        } else {
            print("Internet connection not available.")
            //  completion(false, "", 0, nil, nil)
            GeneralUtility.endProcessing()
            GeneralUtility.showToast(message: "Please check your network connection")
        }
        return nil
        
    }
    
    fileprivate func apiCall(withURL stringURL: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders? = nil, completion:@escaping APICompletion, webService: EnumWebService = .misc) -> DataRequest {
        
        let dataRequest = self.manager.request(stringURL, method: method, parameters: parameters, encoding: encoding, headers: headers).validate(statusCode: [StatusCode.OK.code]).responseJSON { (dataResponse) in
            
            let tastInterval = (dataResponse.metrics?.taskInterval ?? DateInterval.init())
            
            print("\n************* Task Interval: *************\nRequest URL:\t\(dataResponse.request?.url?.absoluteString ?? "")\nTask Interval:\t\(tastInterval)\nDuration:\t\t\(tastInterval.duration)\n******************************************\n")
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            let statusCode = dataResponse.response?.statusCode ?? 0
            
            switch dataResponse.result {
            case .success(let value):
                self.handleSuccess(webService: webService, value: value, completion: { (status, message, response, error) in
                    completion(status, message, statusCode, response, error)
                })
                break
            case .failure(let error):
                self.handleError(dataResponse: dataResponse, error: error, completion: completion)
                break
            }
            
        }
        
        //        dataRequest.cURLDescription { (description) in
        print("*********** curl request: ***********\n\(dataRequest)\n*************************************")
        //        }
        
        return dataRequest
        
    }
    
    func multipartFormRequest(webService: EnumWebService, completion:@escaping APICompletion) {
        
        self.manager.upload(multipartFormData: { (multipartFormData) in
            print(webService.parameters as Any)
            for (key,value) in webService.parameters ?? [:] {
                print("\(key) & \(value)")
                if let dataValue = value as? Data {
                    if key == "thumbnail" {
                        let filename = GeneralUtility.getUniqueFilename() + "image" + ".png"
                        multipartFormData.append(dataValue, withName: key, fileName: filename, mimeType: "image/png")
                    } else if key == "feed" {
                        let filename = GeneralUtility.getUniqueFilename() + "video" + ".mp4"
                        multipartFormData.append(dataValue, withName: key, fileName: filename, mimeType: "video/mp4")
                    } else {
                        let filename = GeneralUtility.getUniqueFilename() + webService.mediaType.fileExtension
                        multipartFormData.append(dataValue, withName: key, fileName: filename, mimeType: webService.mediaType.mimeType)
                    }
                    
                } else if let stringValue = value as? String {
                    multipartFormData.append(stringValue.utf8Encoded(), withName: key)
                } else if let intValue = value as? Int {
                    multipartFormData.append("\(intValue)".utf8Encoded(), withName: key)
                } else if let boolValue = value as? Bool {
                    multipartFormData.append("\(boolValue)".utf8Encoded(), withName: key)
                }else if let dictionary = value as? [String: Any] {
                    if let dictionaryOnlyData = dictionary.filter({$0.value is Data}) as? [String: Data] {
                        for (dataKey, dataValue) in dictionaryOnlyData {
                            let filename = GeneralUtility.getUniqueFilename() + webService.mediaType.fileExtension
                            multipartFormData.append(dataValue, withName: dataKey, fileName: filename, mimeType: webService.mediaType.mimeType)
                        }
                    }
                    let filteredDictionary = dictionary.filter({!($0.value is Data)})
                    if let dataDictionary = try? JSON.init(filteredDictionary).rawData() {
                        multipartFormData.append(dataDictionary, withName: key)
                    }
                } else {
                    print("Not added key: \(key)")
                }
            }
            
        }, to: webService.url, method: webService.httpMethod, headers: webService.httpHeaders) { (encodingResult) in
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                let dataRequest = upload.validate(statusCode: [StatusCode.OK.code]).responseJSON { dataResponse in
                    
                    let statusCode = dataResponse.response?.statusCode ?? 0
                    
                    switch dataResponse.result {
                    case .success(let value):
                        self.handleSuccess(webService: webService, value: value, completion: { (status, message, response, error) in
                            completion(status, message, statusCode, response, error)
                        })
                        break
                    case .failure(let error):
                        self.handleError(dataResponse: dataResponse, error: error, completion: completion)
                        break
                    }
                    
                }
                print("*********** curl request: ***********\n\(dataRequest)\n*************************************")
                
            case .failure(let error):
                self.handleError(error: error)
                completion(false, error.localizedDescription, 0, nil, error)
            }
            
        }
        
    }
    
}

extension ServerCommunicationManager {
    
    func handleSuccess(webService: EnumWebService, value: Any, completion:@escaping (Bool, String, Any?, Error?) -> Void) {
        let responseJSON = JSON(value)
        print("************* Response: *************\n\(responseJSON)\n*************************************\n")
        
        let message = self.errorMessage(fromResponse: responseJSON)
        let data = self.dataObject(fromResponse: responseJSON)
        
        if data == nil {
            if let responseDictionary = responseJSON.dictionaryObject {
                let status : String = responseDictionary["status"] as? String ?? "fail"
                let messageError : String = responseDictionary["msg"] as? String ?? ""
                if status == "fail" || status == "error" {
                    completion(false, messageError, responseJSON.dictionaryObject, nil)
                } else {
                    completion(true
                               , messageError, responseJSON.dictionaryObject, nil)
                }
            } else if responseJSON.arrayObject != nil {
                completion(true, message, responseJSON.arrayObject, nil)
            } else {
                if let errorMessageString = responseJSON.rawString() {
                    completion(false, errorMessageString, responseJSON, nil)
                } else {
                    completion(false, ServerConstant.WebService.defaultErrorMessage, nil, nil)
                    
                }
            }
            return
        }
        
        completion(true, message, data, nil)
        return
        
    }
    
    func handleError(error: Error?) {
        print("Error: \n\(error?.localizedDescription ?? "")\n")
    }
    
    func handleError(dataResponse: Alamofire.DataResponse<Any>, error: Error, completion:@escaping APICompletion) {
        self.handleError(error: error)
        let statusCode = dataResponse.response?.statusCode ?? 0
        
        // IF statuscode 401
        
        if statusCode == StatusCode.Unauthorized.code {
            // self.performLogout()
            return
        }
        if let responseData = dataResponse.data {
            do {
                let responseJSON = try JSON.init(data: responseData)
                print("************* Response: *************\n\(responseJSON)\n*************************************\n")
                let data = self.dataObject(fromResponse: responseJSON)
                var errorMessage = self.errorMessage(fromResponse: responseJSON)
                if errorMessage.count == 0 {
                    errorMessage = self.messageFromStatusCode(statusCode)
                }
                completion(false, errorMessage, statusCode, data, error)
                return
            } catch {
                completion(false, error.localizedDescription, statusCode, nil, error)
                return
            }
        }
        completion(false, error.localizedDescription, statusCode, nil, error)
        return
    }
    
    
    func handleImageUploadingError(dataResponse: Alamofire.DataResponse<Data?>, error: Error, completion:@escaping APICompletion) {
        self.handleError(error: error)
        let statusCode = dataResponse.response?.statusCode ?? 0
        
        // IF statuscode 401
        
        if statusCode == StatusCode.Unauthorized.code {
            // self.performLogout()
            return
        }
        if let responseData = dataResponse.data {
            do {
                let responseJSON = try JSON.init(data: responseData)
                print("************* Response: *************\n\(responseJSON)\n*************************************\n")
                let data = self.dataObject(fromResponse: responseJSON)
                var errorMessage = self.errorMessage(fromResponse: responseJSON)
                if errorMessage.count == 0 {
                    errorMessage = self.messageFromStatusCode(statusCode)
                }
                completion(false, errorMessage, statusCode, data, error)
                return
            } catch {
                completion(false, error.localizedDescription, statusCode, nil, error)
                return
            }
        }
        completion(false, error.localizedDescription, statusCode, nil, error)
        return
    }
    
}

extension ServerCommunicationManager {
    
    func dataDictionary(fromResponse response: JSON) -> [String: Any]? {
        let dataDictionary = response.dictionaryObject?[ServerConstant.WebService.Response.data] as? [String: Any]
        return dataDictionary
    }
    
    func dataArray(fromResponse response: JSON) -> [Any]? {
        let dataArray = response.dictionaryObject?[ServerConstant.WebService.Response.data] as? [Any]
        return dataArray
    }
    
    func dataObject(fromResponse response: JSON) -> Any? {
        if let dataDictionary = self.dataDictionary(fromResponse: response) {
            return dataDictionary
        } else {
            return self.dataArray(fromResponse: response)
        }
    }
    
    func errorMessage(fromResponse response: JSON) -> String {
        
        if let dataDictionary = response.dictionaryObject {
            if let arrayMessages = dataDictionary[ServerConstant.WebService.Response.message] as? [String], arrayMessages.count > 0 {
                let message = arrayMessages.joined(separator: "\n")
                return message
            }
            if let message = dataDictionary[ServerConstant.WebService.Response.message] as? String, message.count > 0 {
                return message
            }
        }
        return ""
        
    }
    
    func getErrorMessage(fromErrorDictionary errorDictionary: [String: Any]?) -> String? {
        if errorDictionary?.count ?? 0 > 0 {
            var arrayErrorMessages:[String] = []
            let keys = errorDictionary!.keys
            for key in keys {
                if let message = errorDictionary![key] as? String {
                    arrayErrorMessages.append(message)
                } else if let dictionary = errorDictionary![key] as? [String: Any] {
                    let keys = dictionary.keys
                    for key in keys {
                        if let message = dictionary[key] as? String {
                            arrayErrorMessages.append(message)
                        }
                    }
                }
            }
            let errorMessage = arrayErrorMessages.joined(separator: "\n")
            return errorMessage
        }
        return nil
        
    }
    
    func messageFromStatusCode(_ statusCode: Int) -> String {
        if statusCode == StatusCode.InternalServerError.code {
            return StatusCode.InternalServerError.message
        }
        return ServerConstant.WebService.defaultErrorMessage
    }
    
    func acceptableStatusCode() -> IndexSet {
        var indexSet = IndexSet.init()
        indexSet.insert(StatusCode.Accepted.code)
        indexSet.insert(StatusCode.BadGateway.code)
        indexSet.insert(StatusCode.BadRequest.code)
        indexSet.insert(StatusCode.Conflict.code)
        indexSet.insert(StatusCode.Continue.code)
        indexSet.insert(StatusCode.Created.code)
        indexSet.insert(StatusCode.ExpectationFailed.code)
        indexSet.insert(StatusCode.Forbidden.code)
        indexSet.insert(StatusCode.Found.code)
        indexSet.insert(StatusCode.GatewayTimeout.code)
        indexSet.insert(StatusCode.Gone.code)
        indexSet.insert(StatusCode.HTTPVersionNotSupported.code)
        indexSet.insert(StatusCode.InternalServerError.code)
        indexSet.insert(StatusCode.LengthRequired.code)
        indexSet.insert(StatusCode.MethodNotAllowed.code)
        indexSet.insert(StatusCode.MovedPermanently.code)
        indexSet.insert(StatusCode.MultipleChoices.code)
        indexSet.insert(StatusCode.NoContent.code)
        indexSet.insert(StatusCode.NonAuthoritativeInformation.code)
        indexSet.insert(StatusCode.NotAcceptable.code)
        indexSet.insert(StatusCode.NotFound.code)
        indexSet.insert(StatusCode.NotImplemented.code)
        indexSet.insert(StatusCode.NotModified.code)
        indexSet.insert(StatusCode.OK.code)
        indexSet.insert(StatusCode.PartialContent.code)
        indexSet.insert(StatusCode.PaymentRequired.code)
        indexSet.insert(StatusCode.PreconditionFailed.code)
        indexSet.insert(StatusCode.ProxyAuthenticationRequired.code)
        indexSet.insert(StatusCode.RequestedRangeNotSatisfiable.code)
        indexSet.insert(StatusCode.RequestEntityTooLarge.code)
        indexSet.insert(StatusCode.RequestTimeout.code)
        indexSet.insert(StatusCode.RequestURITooLong.code)
        indexSet.insert(StatusCode.ResetContent.code)
        indexSet.insert(StatusCode.SeeOther.code)
        indexSet.insert(StatusCode.ServiceUnavailable.code)
        indexSet.insert(StatusCode.SwitchingProtocols.code)
        indexSet.insert(StatusCode.TemporaryRedirect.code)
        indexSet.insert(StatusCode.Unauthorized.code)
        indexSet.insert(StatusCode.UnProcessableEntity.code)
        indexSet.insert(StatusCode.UnsupportedMediaType.code)
        indexSet.insert(StatusCode.Unused.code)
        indexSet.insert(StatusCode.UseProxy.code)
        return indexSet
    }
    
}
public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}
