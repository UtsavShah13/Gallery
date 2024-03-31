//
//  LoginViewController.swift
//  GalleryApplication
//
//  Created by Utsav Shah on 31/03/24.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    private lazy var viewModel = LoginViewModel (
            delegate: self
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func moveToGalleryScreen() {
        let storyBoard = UIStoryboard(name: StoryBoard.main, bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: Controller.galleryVC) as? GalleryViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
//    MARK: - Button Action
    
    @IBAction func googleLogin(_ sender: UIButton) {
//        viewModel.performApiCallingForSocialSignIn(controller: self)
        moveToGalleryScreen()
    }
    
}

extension LoginViewController: LoginViewModelDelegate {
    
    func handleSocialSignInResponse() {
        print("Success")
    }

}
