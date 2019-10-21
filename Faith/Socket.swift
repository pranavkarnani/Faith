//
//  Socket.swift
//  Faith
//
//  Created by Pranav Karnani on 10/10/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import Foundation
import SocketIO

var data : NSDictionary = [:]

class Socket {
    
    static let sharedInstance = Socket()
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://67dc7413.ngrok.io")! as URL)
    
    func establishConnection() {
        socket.connect()
        socket.on("emit") {(dataArray, ack) -> Void in
            data = dataArray[0] as! NSDictionary
        }
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}

extension Decodable {
    init(from any: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: any)
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}
