//
//  ViewController.swift
//  Faith
//
//  Created by Pranav Karnani on 22/08/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation
import NRSpeechToText

class FaithViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var selected = "";
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var logo: UIImageView!
    var query = ""
    
    @objc func longTap(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == .began) {
            animate()
            NRSpeechToText.shared.authorizePermission { (authorize) in
                if authorize {
                    if !NRSpeechToText.shared.isRunning {
                        self.startRecording(completion: { (result) in
                            self.query = result
                            self.processQuery(completion: { (text) in
                                self.textToSpeech(text: text)
                            })
                            
                        })
                    }
                }
            }
        }
        else if(sender.state == .ended) {
            stopAnimation()
            NRSpeechToText.shared.stop()
        }
    }
    
    func processQuery(completion : @escaping(String) -> ()) {
        let request = ApiAI.shared().textRequest()
        request?.query = [query]
        var speech = ""
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            let resp = response.result.fulfillment.messages[0]
            for(key,_) in response.result.parameters {
                let x = key as? String ?? ""
                if(x.contains("music")) {
                    self.selected = "music"
                }
                else if(x.contains("place")) {
                    self.selected = "place"
                }
                else if(x.contains("quote")) {
                    self.selected = "quote"
                }
                else {
                    self.resetViews()
                }
            }
            speech = resp["speech"] as? String ?? ""
//            print(speech)
            completion(speech)
        }, failure: { (request, error) in
            print(error)
        })
        ApiAI.shared().enqueue(request)
    }
    
    var preferences : [MyPreferences] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        
        textToSpeech(text: "Hi! I am Faith. I am here to help")
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        longGesture.minimumPressDuration = 0.3
        logo.addGestureRecognizer(longGesture)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tapped() {
        
    }
    
    func startRecording(completion : @escaping(String) -> ()) {
        var x = 0
        NRSpeechToText.shared.startRecording {(result: String?, isFinal: Bool, error: Error?) in
            if error == nil {
               
            }
            if(isFinal && x == 0) {
                x=1
                completion(result!)
            }
        }
    }
    
    func animate() {
        
    }
    
    func stopAnimation() {
        self.logo.layer.removeAllAnimations()
        self.logo.layoutIfNeeded()
    }
    
    func textToSpeech(text : String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.2
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
    
    func resetViews() {
        
    }
    
}

extension FaithViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socketData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! CustomCollectionViewCell
        if(selected == "music") {
            let data = socketData[indexPath.row] as! Music
            item.title.text = data.title
            item.subContent.text = data.artist
        }
        else if(selected == "quotes") {
            let data = socketData[indexPath.row] as! Quote
            item.title.text = data[indexPath.row].quote
            item.subContent.text = data[indexPath.row].author
        
        else if(selected == "place") {
            
        }
        return item
    }
}

