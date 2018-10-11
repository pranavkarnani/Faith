//
//  BaseStructures.swift
//  Faith
//
//  Created by Pranav Karnani on 10/10/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import Foundation

struct MusicJSON : Decodable {
    var myData: [Music]
}

struct Music : Decodable {
    var title : String
    var preview : String
    var artist : String
    var image : String
}

struct PlacesJSON : Decodable {
    var myData : [Places]
}

struct Places : Decodable {
    var name : String
    var address : String
}

struct quotesJSON : Decodable {
    var quotes : [Quote]
}

struct Quote : Decodable {
    var quote : String;
    var author: String
    var category : String
}
