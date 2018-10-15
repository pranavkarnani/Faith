//
//  Services.swift
//  Faith
//
//  Created by Pranav Karnani on 23/08/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct MyPreferences {
    var music : String
    var place : String
    var cuisine : String
}

struct PrefData {
    var pref : [MyPreferences]
    var username : String
    var password : String
}

class Services {
    static let shared : Services = Services()
    
    func fetchUserData(username : String, password : String, completion : @escaping([MyPreferences]) -> ()) {
        DispatchQueue.main.async {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Preferences")
            let usernamePredicate = NSPredicate(format: "username = %@", username)
            let passwordPredicate = NSPredicate(format: "password = %@", password)
            var pref: [MyPreferences] = []
            do {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [usernamePredicate,passwordPredicate])
                var z = 0;
                do {
                    let results = try context.fetch(request)
                    for result in results as! [NSManagedObject] {
                        let music = result.value(forKey: "music_pref") as? String ?? ""
                        let place = result.value(forKey: "place_pref") as? String ?? ""
                        let cuisine = result.value(forKey: "cuisine_pref") as? String ?? ""
                        z=z+1
                        pref.append(MyPreferences(music : music, place : place, cuisine : cuisine))
                    }
                    if(z==results.count) {
                        completion(pref)
                    }
                }
            } catch {
                print("error")
            }
        }
    }
    
    func persistUserData(data : [PrefData], completion: @escaping (Bool) -> ()) {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                let delegate = UIApplication.shared.delegate as! AppDelegate;
                let context = delegate.persistentContainer.viewContext
                
                let entity = NSEntityDescription.insertNewObject(forEntityName: "Preferences", into: context)
                
                for item in data {
                    for preferences in item.pref {
                        entity.setValue(item.username, forKey: "username")
                        entity.setValue(item.password, forKey: "password")
                        entity.setValue(preferences.music, forKey: "music_pref")
                        entity.setValue(preferences.cuisine, forKey: "cuisine_pref")
                        entity.setValue(preferences.place, forKey: "place_pref")
                        entity.setValue(1, forKey: "isLoggedIn")
                    }
                }
                do {
                    try context.save()
                    completion(true)
                }
                catch {
                    print("error")
                }
            }
        }
    }
    
    func showAlert(title : String, message : String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let bttn = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alert.addAction(bttn)
        vc.show(alert, sender: Any?.self)
    }
    
    func fetchUserLoggedIn(completion : @escaping([MyPreferences]) -> ()) {
        DispatchQueue.main.async {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Preferences")
            let loginpredicate = NSPredicate(format: "isLoggedIn = %@", NSNumber(value: true))

            var pref: [MyPreferences] = []
            do {
                request.predicate = loginpredicate
                var z = 0;
                do {
                    let results = try context.fetch(request)
                    for result in results as! [NSManagedObject] {
                        let music = result.value(forKey: "music_pref") as? String ?? ""
                        let place = result.value(forKey: "place_pref") as? String ?? ""
                        let cuisine = result.value(forKey: "cuisine_pref") as? String ?? ""
                        z=z+1
                        pref.append(MyPreferences(music : music, place : place, cuisine : cuisine))
                    }
                    if(z==results.count) {
                        completion(pref)
                    }
                }
            } catch {
                print("error")
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
    }
}
