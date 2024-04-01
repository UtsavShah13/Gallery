//
//  Constant.swift
//  
//
//  Created by Utsav Shah on 31/03/24.
//

import UIKit

let kHeaderHeight = ScreenFrame.screenHeight * 0.4
let screenWidth: CGFloat = UIScreen.main.bounds.width
let screenHeight: CGFloat = UIScreen.main.bounds.height

// MARK: enumration
struct ScreenFrame {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
}

struct StoryBoard {
    static let main = "Main"
    static let authorization = "Authorization"
}

struct Controller {
    static let loginVC = "LoginViewController"
    static let galleryVC = "GalleryViewController"
    static let profileVC = "ProfileViewController"
}

// MARK: Cell
struct Cell {
 static let galleryCollectionViewCell = "GalleryCollectionViewCell"
}

// MARK: Header
struct Header {
}

// MARK: String
struct Text {
}

struct Key {
   static let googleClientId = "222496290584-i4bqsqr3s07712gl0k4ems64t6fdhinv.apps.googleusercontent.com" // "222496290584-2kfcm8v8ah214dnsfgq04d88nuo5neuk.apps.googleusercontent.com"
}

struct Message {
}

struct Color {
}
