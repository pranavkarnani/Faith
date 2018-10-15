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
import AVFoundation

class FaithViewController: UIViewController, UIGestureRecognizerDelegate {
    var selectedIndex = -1
    var state = 0;
    var initTransform = CGAffineTransform()
    var musicData :[Music] = []
    var quotes : [Quote] = []
    var places : [Places] = []
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    @IBOutlet weak var speechText: UILabel!
    var selected = "";
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var logo: UIImageView!
    var query = ""
    
    @objc func longTap(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == .began) {
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
                    let mydata = data["message"] as! NSDictionary
                    let y = mydata["mydata"] as! NSArray
                    for item in y {
                        let z = item as! NSDictionary
                        let artist = z["artist"] as? String ?? ""
                        let image = z["image"] as? String ?? ""
                        let preview = z["preview"] as? String ?? ""
                        let title = z["title"] as? String ?? ""
                        let music = Music(title: title, preview: preview, artist: artist, image: image)
                        self.musicData.append(music)
                    }
                    self.makeRoom()
                }
                    
                else if(x.contains("place")) {
                    self.selected = "place"
                    let mydata = data["message"] as! NSDictionary
                    let y = mydata["mydata"] as! NSArray
                    for item in y {
                        let z = item as! NSDictionary
                        let name = z["name"] as? String ?? ""
                        let image = z["image"] as? String ?? ""
                        let address = z["address"] as? String ?? ""
                        let place = Places(name: name, address: address, image: image)
                        self.places.append(place)
                    }
                    self.makeRoom()
                }
                else if(x.contains("quote")) {
                    let mydata = data["message"] as! NSArray
                    let random = Int.random(in: 0...(mydata.count-1))
                    let block = mydata[random] as! NSDictionary
                    let quote = block["quote"] as? String ?? ""
                    let author = block["author"] as? String ?? ""
                    let text = quote + "by" + author
                    self.textToSpeech(text: text)
                }
                else {
                    self.collection.reloadData()
                    self.selected = ""
                }
            }
            speech = resp["speech"] as? String ?? ""
            completion(speech)
        }, failure: { (request, error) in
            print(error)
        })
        ApiAI.shared().enqueue(request)
    }
    
    var preferences : [MyPreferences] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTransform = logo.transform
        collection.dataSource = self
        collection.delegate = self
        collection.alpha = 0
        collection.isUserInteractionEnabled = false
        textToSpeech(text: "Hi! I am Faith. I am here to help")
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        longGesture.minimumPressDuration = 0.3
        logo.addGestureRecognizer(longGesture)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: width, height: view.frame.height*0.5)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collection?.collectionViewLayout = layout
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
    func textToSpeech(text : String) {
        speechText.text = text
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.2
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
    
    func makeRoom() {
        let value = -(view.frame.height/2)+100 + self.logo.frame.height/2
        if(state == 0) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1, animations: {
                    self.logo.transform = CGAffineTransform(translationX: 0, y: CGFloat(value))
                }) { (true) in
                    self.collection.reloadData()
                    self.collection.alpha = 1
                    self.collection.isUserInteractionEnabled = true
                    
                }
            }
            state = 1
        }
    }
}

extension FaithViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selected == "music" {
            return musicData.count
        }
        else if selected == "place" {
            return places.count
        }
        else if selected == "quote" {
            return quotes.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! CustomCollectionViewCell
        if(selected == "music") {
            let mdata = musicData[indexPath.row]
            item.title.text = mdata.title
            item.subContent.text = mdata.artist
            Services.shared.getData(from: URL(string: mdata.image)!, completion: { (datas, response, error) in
                DispatchQueue.main.async {
                    item.albumArt.image = UIImage(data: (datas ?? nil)!)
                    item.albumArt.layer.cornerRadius = item.albumArt.frame.width/2
                    item.albumArt.clipsToBounds = true
                }
            })
        }
        else if(selected == "place") {
            let pdata = places[indexPath.row]
            item.title.text = pdata.name
            item.subContent.text = pdata.address
            print(pdata)
            Services.shared.getData(from: URL(string: pdata.image)!, completion: { (datas, response, error) in
                DispatchQueue.main.async {
                    item.albumArt.image = UIImage(data: (datas ?? nil)!)
                    item.albumArt.layer.cornerRadius = item.albumArt.frame.width/2
                    item.albumArt.clipsToBounds = true
                }
            })
        }
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selected == "music" && selectedIndex == -1 {
            selectedIndex = indexPath.row
            let url = URL(string: musicData[indexPath.row].preview)
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            player!.play()
        }
        else if selected == "music" && selectedIndex == indexPath.row {
            player!.pause()
        }
    }
}
