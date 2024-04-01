//
//  ProfileViewController.swift
//  GalleryApplication
//
//  Created by Utsav Shah on 31/03/24.
//

import UIKit
import GoogleSignIn
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profieImageVIew: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let userName = Utils.shared.getUserName()
        let userEmail = Utils.shared.getEmailId()
        emailLabel.text = userEmail
        nameLabel.text = userName
        navigationItem.title = "Profile"
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        let signInConfig = GIDConfiguration(clientID: Key.googleClientId)
        GIDSignIn.sharedInstance.configuration = signInConfig
        GIDSignIn.sharedInstance.signOut()
        Utils.shared.resetUserData()
        AppDelegate.shared?.setAuthorizationStoryBoard()
        navigationController?.popToRootViewController(animated: true)
    }
    
}
