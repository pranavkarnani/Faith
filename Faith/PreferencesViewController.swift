//
//  PreferencesViewController.swift
//  Faith
//
//  Created by Pranav Karnani on 23/08/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import UIKit
import CoreLocation
import Magnetic

class PreferencesViewController: UIViewController, MagneticDelegate {

    @IBOutlet weak var bttnContainer: UIView!
    var selected : [Node] = []
    @IBOutlet weak var nextBttn: UIButton!
    @IBAction func nextBttnTapped(_ sender: Any) {
        if(validate()) {
            clear()
            x=x+1
            
            setUpView()
        }
    }
    
    func validate() -> Bool {
        if(x==0 && selected.count == 3) {
            return true
        }
        if(x==1 && selected.count == 6) {
            return true
        }
        if(x==2 && selected.count == 9) {
            return true
        }
        else {
            return false
        }
    }
    
    
    @IBOutlet weak var cardText: UILabel!
    var locationManager : CLLocationManager!
    var username = ""
    var password = ""
    
    var music = ["Pop","Rock","Indie","Trance","EDM","Punk","HipHop","Bollywood","Tamil","Hindi","Telugu","Guitar","Rap"]
    var places = ["Parks","Temple","Church","Fuel","Atm","Cafes","Hospitals","Stations","Mosques","Restaurants"]
    var cuisine = ["Chinese","Indian","Mexican","Italian","Mediterranean","South Indian","North Indian","Thai","BBQ","Pizza"]
    var data :[String] = []
    var refined : [String] = []
    
    var x = 0
    
    var magnetic: Magnetic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let magneticView = MagneticView(frame: self.view.bounds)
        magnetic = magneticView.magnetic
        self.view.addSubview(magneticView)
        view.bringSubview(toFront: cardText)
        
        view.bringSubview(toFront: bttnContainer)
        view.bringSubview(toFront: nextBttn)
        magnetic?.magneticDelegate = self
        setUpView()
    }
    
    func setUpView() {
        
        
        var pref : [PrefData] = []
        var mypref = PrefData(pref: [], username: "", password: "")
        
        
        if(x==0) {
            cardText.text = "Choose exactly 3 different genres of music"
            addData(data: music)
        }
        else if(x==1) {
            cardText.text = "Choose exactly 3 different places of visit"
            addData(data: cuisine)
        }
        else if(x==2) {
            cardText.text = "Choose exactly 3 different types of cuisine"
            addData(data: places)
        }
            
        else {
            
            mypref.username = username
            mypref.password = password
            for i in 0...2 {
                mypref.pref.append(MyPreferences(music: selected[i].text!, place: selected[i+3].text!, cuisine: selected[i+6].text!))
            }
            pref.append(mypref)
            
            Services.shared.persistUserData(data: pref) { (status) in
                if(status) {
                    self.performSegue(withIdentifier: "SignUpSuccessful", sender: Any?.self)
                }
            }
        }
        
        
    }
    
    func clear() {
        magnetic?.removeAllChildren()
        magnetic?.reloadInputViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        if(selected.count <= 3*(x+1)) {
            selected.append(node)
        }
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
    }
    
    func addData(data : [String]) {
        for item in data {
            let node = Node(text: item, image: nil, color: .red, radius: 60)
            magnetic?.addChild(node)
        }
    }
}
