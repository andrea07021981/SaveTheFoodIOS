//
//  LoginViewController.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-06-29.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import UIKit

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
        if (emailTextField.text == "" ||
            pswTextField.text == "") {
                showAlert();
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Attention", message: "Email and password required", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.white
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true)
        }
    }
}
