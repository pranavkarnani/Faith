//
//  LandingViewController.swift
//  Faith
//
//  Created by Pranav Karnani on 23/08/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Services.shared.fetchUserLoggedIn() { (preferences) in
            if(preferences.count > 0) {
                self.performSegue(withIdentifier: "loggedIn", sender: Any?.self)
            }
            else {
                self.performSegue(withIdentifier: "logIn", sender: Any?.self)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
