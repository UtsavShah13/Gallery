//
//  UIDevice+Extension.swift
//  TasteMaker
//
//  Created by ideveloper1 on 07/04/21.
//

import UIKit

struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenMaxLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

enum ScreenInches: String, CaseIterable {
    // swiftlint:disable identifier_name
    case in3_5 // iPhone 4 (S)
    case in4 // iPhone 5 (C/S/SE)
    case in4_7 // iPhone 6/7/8
    case in5_5 // iPhone 6/7/8 Plus (S)
    case in5_6 // Iphone 12 mini
    case in5_8 // iPhone X/Xs
    case in6_1 // iPhone Xr, Pro
    case in6_5 // iPhone Xs Max, Pro max
    case unknown
}

enum ScreenSizeType {
    case small
    case medium
    case large
    case largest
}

extension UIDevice {

    var screenSizeType: ScreenSizeType {
        switch UIDevice.current.screenInches {
        case .in3_5, .in4:
            return .small
        case .in4_7, .in5_5, .in5_6:
            return .medium
        case .in5_8:
            return .large
        case .in6_5, .in6_1:
            return .largest
        default:
            return .large
        }
    }
    
    var screenInches: ScreenInches {
        switch ScreenSize.screenHeight {
        case 480:
            return .in3_5
        case 568:
            return .in4
        case 667:
            return .in4_7
        case 736:
            return .in5_5
        case 768:
            return .in5_6
        case 812:
            return .in5_8
        case 896:
            return .in6_1
        default:
            return .in6_5
        }
    }
    
}
