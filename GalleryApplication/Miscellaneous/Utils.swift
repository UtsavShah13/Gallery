//
//  Utils.swift
//  
//
//  Created by Utsav Shah on 31/03/24.
//

import UIKit
import SVProgressHUD
import AVKit
import Photos

class Utils: NSObject {
    static let shared = Utils()
}

// MARK: - Alerts
extension Utils {
    class func notReadyAlert() {
        let alert = UIAlertController(title: "In development!", message: "This component isn't ready", preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
        alert.addAction(action)
        alert.show()
    }
    
    class func alertWithTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "No Thanks", style: .default) { _ in completion("") })
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            if
                let textFields = alert.textFields,
                let tf = textFields.first,
                let result = tf.text
            { completion(result) }
            else
            { completion("") }
        })
        alert.show()
    }
    
    class func alert(message: String, title: String? = "") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.view.tintColor = UIColor.white
            /*
            if #available(iOS 13.0, *) {
                alert.view.overrideUserInterfaceStyle = .dark
            } else {
                // Fallback on earlier versions
            }
            */
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
            action.setValue(UIColor.black, forKey: "titleTextColor")
            alert.addAction(action)
            alert.show()
        }
    }
    
    class func showAlertMsg(title: String, message: String, complition: @escaping((_ finished: Bool) -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = UIColor.white
        /*
        if #available(iOS 13.0, *) {
            alert.view.overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
        */
        alertController.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alertController.dismiss(animated: true, completion: nil)
            complition(true)
        }
    }
    
    class func alert(message: String? = nil, title: String? = nil, titleImage: UIImage? = nil, buttons: [String], cancel: String? = nil, destructive: String? = nil, type: UIAlertController.Style = .alert, handler :@escaping (Int) -> Void) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: type)
            alert.view.tintColor = UIColor.white
            /*
            if #available(iOS 13.0, *) {
                alert.view.overrideUserInterfaceStyle = .dark
            } else {
                // Fallback on earlier versions
            }
            */
            // Set Image with Title
            if titleImage != nil {
                // Create Attachment
                let imageAttachment =  NSTextAttachment()
                imageAttachment.image = titleImage
                let imageOffsetY: CGFloat = -15.0
                imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                
                let completeText = NSMutableAttributedString(string: "")
                completeText.append(attachmentString)
                
                let text = "\n" + (title ?? "")
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 0.7
                paragraphStyle.alignment = .center
                paragraphStyle.lineHeightMultiple = 1.4
                let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.regular(size: 16.0), NSAttributedString.Key.paragraphStyle: paragraphStyle]
                let titleImage = NSMutableAttributedString(string: text, attributes: attributes)
                completeText.append(titleImage)
                alert.setValue(completeText, forKey: "attributedTitle")
            }
            
            for button in buttons {
                let action = UIAlertAction(title: button, style: .default) { (action) in
                    if let index = buttons.firstIndex(of: action.title!) {
                        DispatchQueue.main.async {
                            handler(index)
                        }
                    }
                }
                alert.addAction(action)
                action.setValue(UIColor.black, forKey: "titleTextColor")
            }
            
            if let destructiveText = destructive {
                let action = UIAlertAction(title: destructiveText, style: .destructive) { (_) in
                    handler(buttons.count)
                }
                alert.addAction(action)
                action.setValue(UIColor.black, forKey: "titleTextColor")
            }
            
            if let cancelText = cancel {
                let action = UIAlertAction(title: cancelText, style: .cancel) { (_) in
                    let index = buttons.count + (destructive != nil ? 1 : 0)
                    handler(index)
                }
                alert.addAction(action)
                action.setValue(UIColor.black, forKey: "titleTextColor")
            }
            
            alert.show()
        }
    }
}

// MARK: - Spinner
extension Utils {
    class func showSpinner() {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.show()
        }
    }
    
    class func showSpinner(message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.show(withStatus: message)
        }
    }
    class func hideSpinner() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}

// MARK: - UserDefault Functions
extension Utils {
    class func saveDataToUserDefault(_ data: Any, _ key: String) {
        let archived = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
        UserDefaults.standard.set(archived, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getDataFromUserDefault(_ key: String) -> Any? {
        guard let archived =  UserDefaults.standard.object(forKey: key) else {
            return nil
        }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archived as? Data ?? Data())
    }
    
    class func removeDataFromUserDefault(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    class func saveData(_ value: Any?, forKey key: String?) {
        UserDefaults.standard.set(value, forKey: key ?? "")
    }
    
    class func getDataForKey(_ key: String?) -> Any? {
        return UserDefaults.standard.object(forKey: key ?? "")
    }
    
}

// MARK: - PHOTO LIBRARY
extension  Utils {
    enum PhotoLibraryAuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
    }

    class func authorizePhoto(completion: ((PhotoLibraryAuthorizationStatus) -> Void)?) {
        self.authorize(completion: completion)
    }
    
    private class func authorize(completion: ((PhotoLibraryAuthorizationStatus) -> Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion?(.alreadyAuthorized)
        case .denied:
            completion?(.alreadyDenied)
        case .restricted:
            completion?(.restricted)
        case .notDetermined:
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    // self.openCameraOrLibrary(type: .photoLibrary)
                    completion?(.justAuthorized)
                } else {
                    completion?(.justDenied)
                }
            })
        @unknown default:
            fatalError()
        }
    }
    
    class func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!

        let alert = UIAlertController(
            title: "Camera Access",
            message: "Camera access is required to make full use of this app.",
            preferredStyle: UIAlertController.Style.alert
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in

        }
        alert.addAction(cancelAction)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        let settingAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            DispatchQueue.main.async {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(settingAction)
        settingAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.show()
    }

    class func photoLibraryPermissionAlert() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Photo Album",
            message: "Permission is required to add photo.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        
        }
        alert.addAction(cancelAction)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        let settingAction = UIAlertAction(title: "Settings", style: .default) { (_) in
                DispatchQueue.main.async {
                    UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
                }
        }
        alert.addAction(settingAction)
        settingAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.show()
    }
    
    enum VideoAuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
    }
    
    class func authorizeVideo(completion: ((VideoAuthorizationStatus) -> Void)?) {
        self.authorize(mediaType: AVMediaType.video, completion: completion)
    }
    
    private class func authorize(mediaType: AVMediaType, completion: ((VideoAuthorizationStatus) -> Void)?) {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        case .authorized:
            completion?(.alreadyAuthorized)
        case .denied:
            completion?(.alreadyDenied)
        case .restricted:
            completion?(.restricted)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    if granted {
                        completion?(.justAuthorized)
                    } else {
                        completion?(.justDenied)
                    }
                }
            })
        @unknown default:
            fatalError()
        }
    }
}

// MARK: - Global functions
func print(_ item: @autoclosure () -> Any, separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(item(), separator: separator, terminator: terminator)
    #endif
}

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    var idx = items.startIndex
    let endIdx = items.endIndex
    repeat {
        Swift.print(items[idx], separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator)
        idx += 1
    } while idx < endIdx
    #endif
}
