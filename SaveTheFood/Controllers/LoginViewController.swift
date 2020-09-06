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
    
    private var userManager = UserManeger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userManager.delegate = self
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
            userManager.doLoginWithEmailPass(email: email, pass: password)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeViewController{
            //Change the title of back button
            let backItem = UIBarButtonItem()
            backItem.title = "Exit"
            navigationItem.backBarButtonItem = backItem
        }
    }
}

//MARK: delegate manager
extension LoginViewController : UserManagerDelegate {
    func didRequestUser(_ userManager: UserManeger, user: AuthDataResult) {
        self.performSegue(withIdentifier: K.loginHomeSegue, sender: self)
    }
    
    func didFailWithError(error: String) {
        showAlert(msg: error)
    }
}
