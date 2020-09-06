//
//  UserManager.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-09-06.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import Foundation
import Firebase

protocol UserManagerDelegate {
    func didRequestUser(_ userManager: UserManeger, user: AuthDataResult)
    func didFailWithError(error: String)
}

struct UserManeger{
    
    var delegate: UserManagerDelegate?
    
    func doLoginWithEmailPass(email: String?, pass: String?) {
        if let email = email, let password = pass {
            Auth.auth().signIn(withEmail: email, password: password) { authresult, error in
                if let e = error {
                    self.delegate?.didFailWithError(error: e.localizedDescription)
                } else {
                    self.delegate?.didRequestUser(self, user: authresult!)
                }
            }
        } else {
            self.delegate?.didFailWithError(error: "Error login")
        }
    }
}
