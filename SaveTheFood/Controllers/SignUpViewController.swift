//
//  SignUpViewController.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-07-03.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//


import UIKit
import Firebase
class SignUpViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func signUpPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) {authresult, error in
                if let e = error {
                    self.showAlert(msg: e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: K.signupToHomeSegue, sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeViewController{
            //Change the title of back button
            let backItem = UIBarButtonItem()
            backItem.title = "Exit"
            navigationItem.backBarButtonItem = backItem
        }
    }
}
