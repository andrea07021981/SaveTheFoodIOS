//
//  LoginViewController.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-06-29.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var pswTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func signInPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = pswTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authresult, error in
                if let e = error {
                    self.showAlert(msg: e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: K.loginHomeSegue, sender: self)
                }
            }
        } else {
            showAlert(msg: "Email and password required")
        }
    }
    
    func showAlert(msg: String, t: String = "Attention") {
        let alert = UIAlertController(title: t, message: msg, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.white
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true)
        }
    }
    @IBAction func signUpPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.loginSegue, sender: self)
    }
}
