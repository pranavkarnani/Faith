//
//  LoginViewController.swift
//  Faith
//
//  Created by Pranav Karnani on 23/08/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var pref : [MyPreferences] = []
    @IBAction func loginBttnTapped(_ sender: Any) {
        performLogin()
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var card: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        card.layer.cornerRadius = 20.0
    }
    
    func performLogin() {
        if(valid(text: usernameTextField.text!) && valid(text: passwordTextField.text!)) {
            Services.shared.fetchUserData(username: usernameTextField.text!, password: passwordTextField.text!, completion:{ (preferencesData) in
                self.pref = preferencesData
                self.performSegue(withIdentifier: "loginSuccessful", sender: Any?.self)
            })
        }
        else {
            Services.shared.showAlert(title: "Error", message: "One of the fields have been not been filled", vc: self)
        }
    }
    
    func valid(text : String) -> Bool {
        if(text == "") {
            return false
        }
        else {
            return true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = FaithViewController()
        vc.preferences = pref
    }
}
