//
//  TextFieldExtension.swift
//  TasteMaker
//
//  Created by ideveloper1 on 27/03/21.
//

import Foundation
import UIKit

enum TextFieldType {
    case text
    case email
    case password
}

extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
