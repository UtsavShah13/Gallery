//
//  LoginViewModel.swift
//  GalleryApplication
//
//  Created by Utsav Shah on 31/03/24.
//

import Foundation
import GoogleSignIn

protocol LoginViewModelDelegate : AnyObject {
    func handleSocialSignInResponse()
}


class LoginViewModel: NSObject {

    private weak var delegate : LoginViewModelDelegate?
    
    init(delegate : LoginViewModelDelegate? = nil) {
        self.delegate = delegate
    }
}

extension LoginViewModel {
    
    func performApiCallingForSocialSignIn(controller: UIViewController) {
        let signInConfig = GIDConfiguration(clientID: Key.googleClientId)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: controller) { signInResult, error in
          guard error == nil else { return }
            self.delegate?.handleSocialSignInResponse()

          // If sign in succeeded, display the app's main content View.
        }

    }
}
