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
    
    
//    MARK: - Button Action
    
    @IBAction func googleLogin(_ sender: UIButton) {
        viewModel.performApiCallingForSocialSignIn(controller: self)
    }
    
}

extension LoginViewController: LoginViewModelDelegate {
    
    func handleSocialSignInResponse() {
        print("Success")
    }

}
