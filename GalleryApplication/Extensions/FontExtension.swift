//
//  FontExtension.swift
//  TasteMaker
//
//  Created by ideveloper1 on 19/03/21.
//

import UIKit

extension UIFont {

    class func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    class func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size)!
    }

    class func heavy(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Heavy", size: size)!
    }

//    class func light(size: CGFloat) -> UIFont {
//        return UIFont(name: "Roboto-UltraLight", size: size)!
//    }

    class func semibold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
    
    class func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    class func regularNew(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
//    class func regularNew(size: CGFloat) -> UIFont {
//        return UIFont(name: "OpenSansCondensed-Light", size: size)!
//    }
}
