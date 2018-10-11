//
//  Socket.swift
//  Faith
//
//  Created by Pranav Karnani on 10/10/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import Foundation
import SocketIO
var socketData : [Any] = []
class Socket {
    
    static let sharedInstance = Socket()
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://6bc799c3.ngrok.io")! as URL)
    
    func establishConnection() {
        socket.connect()
        socket.on("emit") {(dataArray, ack) -> Void in
            print(dataArray)
            
        }
        socket.on("update") {(dataArray, ack) -> Void in
            let json = dataArray[0]
            let clustered = json as! [String:AnyObject]
           
            
            
        }
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func listenToServer() {
        socket.on("emit") {(dataArray, ack) -> Void in
            print(dataArray)
            socketData = dataArray
        }
    }
}
