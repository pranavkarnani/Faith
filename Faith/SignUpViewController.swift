//
//  SignUpViewController.swift
//  Faith
//
//  Created by Pranav Karnani on 23/08/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    var current = CGAffineTransform()
    var x=0
    var question = ["What do I call you?","Please set a password","How old are you?"]
    
    var response:[String] = []
    
    @IBOutlet weak var nextAction: UIButton!
    
    @IBAction func nextBttn(_ sender: Any) {
        if(x>=3) {
            self.performSegue(withIdentifier: "setPreferences", sender: Any?.self)
        }
        else {
            
            if(valid(text: cardField.text!)) {
                response.append(cardField.text!)
                cardField.text = ""
                animate()
                setUpCard()
            }
            else {
                Services.shared.showAlert(title: "Error", message: "Invalid Input", vc: self)
            }
        }
    }
    
    @IBOutlet weak var cardField: UITextField!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardholder: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(x==0) {
            setUpCard()
        }
        current = cardholder.transform
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        //        cardholder.clipsToBounds = false
        cardholder.layer.cornerRadius = 20.0
        
    }
    
    func animate() {
        
        UIView.animate(withDuration: 0.5, animations: {
            let transform = CGAffineTransform(translationX: -CGFloat(self.cardholder.frame.width + self.cardholder.frame.origin.x), y: 0)
            self.cardholder.transform = transform
        }) { (true) in
            self.cardholder.transform = CGAffineTransform(translationX: CGFloat(self.view.frame.width), y: 0)
            UIView.animate(withDuration: 0.5, animations: {
                self.cardholder.transform = self.current
            }, completion: nil)
        }
    }
    
    func setUpCard() {
        cardLabel.text = question[x]
        if(x==1) {
            cardField.isSecureTextEntry = true
        }
        else {
            cardField.isSecureTextEntry = false
        }
        x=x+1;
    }
    
    func valid(text : String) -> Bool {
        if(text == "") {
            return false
        }
        else {
            return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PreferencesViewController
        vc.username = response[0]
        vc.password = response[1]
    }
    
    
}
