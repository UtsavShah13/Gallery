//
//  GeneralUtility.swift
//  bogo
//
//  Created by flamingo on 12/07/19.
//  Copyright © 2019 Appernaut. All rights reserved.
//
//
//  GeneralUtility.swift
//  TemplateProjSwift
//
//  Created by Mac22 on 24/09/18.
//  Copyright © 2018 Mac22. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import CoreTelephony
import CoreLocation
import Toast_Swift
//import SwiftToast

struct GeneralUtility {
    
    private static var npCommonLoaderView: NPCommonLoaderView = {
        let instance = NPCommonLoaderView.init(frame: Constant.appDelegate.window!.bounds)
        instance.behaviour = NPCommonLoaderViewBehaviour.inactiveNavigationBar
        return instance
    }()
    
    static var currentViewController: UIViewController? {
        var currentVC: UIViewController?
        let rootVC = Constant.appDelegate.window?.rootViewController
        if let navController = rootVC as? UINavigationController  {
            currentVC = navController.topViewController
        } else {
            currentVC = rootVC
        }
        return currentVC
    }
    
    static func showProcessing(withFrame frame: CGRect = Constant.appDelegate.window!.bounds, message:String? = nil) {
          DispatchQueue.main.async {
              GeneralUtility.npCommonLoaderView.showProcessing(withFrame: frame, title: message)
          }
      }
      
    static func endProcessing(completion: (()->())? = nil) {
        DispatchQueue.main.async {
            GeneralUtility.npCommonLoaderView.endProcessing ({
                completion?()
            })
        }
    }
    
    static func endAllProcessing(completion: (()->())? = nil) {
        DispatchQueue.main.async {
            GeneralUtility.npCommonLoaderView.endProcessing {
                Constant.appDelegate.window?.removeFromSuperview()
            }
        }
    }
    
    static func showAlert(withTitle title: String = Constant.appDisplayName, message: String, actions:[UIAlertAction] = [], defaultButtonAction:(()->())? = nil) {
        
      //  GeneralUtility.endAllProcessing()
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if actions.count > 0 {
            for action in actions {
                alertController.addAction(action)
            }
        } else {
            let action = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (alertAction) in
                defaultButtonAction?()
            }
            alertController.addAction(action)
        }
      UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
     //   GeneralUtility.currentViewController?.present(alertController, animated: true) {
    //    }
        
    }
    
    static func showToast(message: String) {
        DispatchQueue.main.async {
            UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController?.view.makeToast(message)
        }
    }
    
    static func chekLocationPermission() -> Bool {
        let permission : Bool = self.chekLocationPermission()
        if permission == true
        {
            return true
        }
        else
        {
            settingAlertViewController()
            return false
        }
    }
    
    static func settingAlertViewController() {
        
        let alertController = UIAlertController.init(title: "Location is disable", message: "We need your location for getting restaurant near by you\n for Enable location CLick on Setting", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            var presentVC = Constant.appDelegate.window?.rootViewController
            while let next = presentVC?.presentedViewController {
                presentVC = next
            }
            presentVC?.present(alertController, animated: true, completion: nil)
        }
    }
}
extension GeneralUtility {
    
    static func isNonEmptyString(_ text: String?) -> Bool {
        return (text?.count ?? 0) > 0
    }
    
    static func isValidEmail(_ email: String?) -> Bool {
        if (email?.count ?? 0) > 0 {
            let regexPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            do {
                let regex = try NSRegularExpression.init(pattern: regexPattern, options: NSRegularExpression.Options.caseInsensitive)
                let regexMatches = regex.numberOfMatches(in: email!, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: email!.count))
                if regexMatches == 0 {
                    return false
                } else {
                    return true
                }
            } catch {
                print(error)
            }
        }
        return false
    }
    
}

extension GeneralUtility {
    
    static func openMail(withSenderEmail to: String, subject: String?, body: String?) {
        let stringURL = "mailto:\(to)?subject=\(subject ?? "")&body=\(body ?? "")"
        if let url = URL.init(string: stringURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { (_) in
                }
            }
        }
    }
    
    static func shareURL(_ stringURL: String?, sourceView: UIView?) {
        
        if stringURL?.count ?? 0 > 0 {
            let activityViewController = UIActivityViewController.init(activityItems: [stringURL ?? ""], applicationActivities: nil)
            activityViewController.excludedActivityTypes = nil
            activityViewController.popoverPresentationController?.sourceView = sourceView ?? GeneralUtility.currentViewController?.view
            if sourceView != nil {
                activityViewController.popoverPresentationController?.sourceRect = sourceView!.bounds
            }
            activityViewController.popoverPresentationController?.permittedArrowDirections = [.up, .down]
            GeneralUtility.currentViewController?.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    static func getUniqueFilename() -> String {
           let uniqueName = Date.stringDate(fromDate: Date.init(), dateFormat: DateFormat.uniqueString)
           return uniqueName!
       }
       
    
}
extension UIImage
{
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        self.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print(newImage ?? "")
        
        return newImage!
    }
    func resizeImageHeightWidth(newWidth: CGFloat,newHeight : CGFloat) -> UIImage {
        
        //        let scale = newWidth / self.size.width
        //         newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        self.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print(newImage ?? "")
        
        return newImage!
    }
}

extension GeneralUtility {
   static func getCountryCode() -> String {
    
    let locale = Locale.current
    let country : String = locale.regionCode ?? "IN"
    
    let countryDictionary  = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
         if let countryCode = countryDictionary[country] {
             return "+\(countryCode)"
         }
         return ""
    
    }
    static func getCountryPhonceCode (_ country : String) -> String {
        
        let countryDictionary  = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
        if let countryCode = countryDictionary[country] {
            return countryCode
        }
        return ""
    }
}

extension GeneralUtility {
    //    Time Diffrence
   static func timeAgoDisplay(date: Date) -> String {
            
            // From Time
            let fromDate = date
            
            // To Time
            let toDate = Date()
            // Estimation
            // Year
            if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0 {
                return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
            }
            // Month
            if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0 {
                return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
            }
            // Day
            if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0 {
                return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
            }
            // Hours
            if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
                return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
            }
    //         Minute
            if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
                return interval == 1 ? "\(interval)" + " " + "min ago" : "\(interval)" + " " + "min ago"
            }
            
            return "Just Now"
    }
}

extension GeneralUtility {
    
   static func timeConvert(duraction: Double) -> String {
       
        var time = 0.0
        if duraction > 60 {
            time = (duraction) / 60
        } else {
            time = (duraction) / 100
        }
       
       let stringTime = String(format: "%.2f", time)
       let newString = stringTime.replacingOccurrences(of: ".", with: ":", options: .literal, range: nil)

        return newString
    }
    
}
