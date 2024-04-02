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
        navigationItem.title = "Profile"
        self.navigationController?.navigationBar.tintColor = .black
        let userName = Utils.shared.getUserName()
        let userEmail = Utils.shared.getEmailId()
        emailLabel.text = userEmail
        nameLabel.text = userName
        
        // fetch first image store in databaase to show as profile image
        let data = CoreDataManager.shared.fetch() as! [ImageList]
        let imageData = data.first?.previewImage ?? Data()
        let image = getImage(from: imageData)
        profieImageVIew.image = image
    }
    
    
    // convert data to image
    func getImage(from data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func logout() {
        let signInConfig = GIDConfiguration(clientID: Key.googleClientId)
        GIDSignIn.sharedInstance.configuration = signInConfig
        GIDSignIn.sharedInstance.signOut()
        Utils.shared.resetUserData()
        AppDelegate.shared?.setAuthorizationStoryBoard()
        CoreDataManager.shared.deleteAllData()
        navigationController?.popToRootViewController(animated: true)

    }
    
//    MARK: - Button Action
    
    @IBAction func logoutAction(_ sender: UIButton) {
        logout()
    }
    
}
