//
//  LoginViewModel.swift
//  GalleryApplication
//
//  Created by Utsav Shah on 31/03/24.
//

import Foundation
import GoogleSignIn

protocol LoginViewModelDelegate : AnyObject {
    func handleGoogleSignInResponse()
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
        GIDSignIn.sharedInstance.configuration = signInConfig

        GIDSignIn.sharedInstance.signIn(withPresenting: controller) { signInResult, error in
          guard error == nil else { return }
            Utils.shared.saveUserLogedIn(true)
            Utils.shared.saveEmailId(signInResult?.user.profile?.email ?? "")
            Utils.shared.saveUserName(signInResult?.user.profile?.name ?? "")
            self.delegate?.handleGoogleSignInResponse()
        }

    }
}
