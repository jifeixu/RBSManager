//
//  RBSSubscriber.swift
//  Pods
//
//  Created by Wes Goodhoofd on 2018-01-06.
//

import UIKit
import ObjectMapper

class RBSSubscriber: NSObject {
    var manager: RBSManager
    var messageClass: Mappable
    var topic: String
    var callback: ((_ message: Mappable) -> (Void))
    
    // configuration options
    var active: Bool = false
    var tag: String?
    
    // ROS specific options
    var messageType: String?
    var subscriberId: String?
    var throttleRate: Int?
    var queueLength: Int?
    var fragmentSize: Int?
    var compression: String?
    
    init(manager m: RBSManager, topic t: String, messageClass mc: Mappable, callback c: @escaping (_ message: Mappable) -> (Void)) {
        self.manager = m
        self.topic = t
        self.messageClass = mc
        self.callback = c
    }
    
    /// Tell ROSBridge to begin passing messages when they are received
    func subscribe() {
        self.active = true
        
        // build the dictionary to send to ROS
        var data = [String : String]()
        data["op"] = "subscribe"
        data["topic"] = self.topic
        
        // add options to configure the subscriber
        if let messageTypeOption = messageType {
            data["type"] = messageTypeOption
        }
        
        if let subscriberIdOption = subscriberId {
            data["id"] = subscriberIdOption
        }
        
        if let throttleRateOption = throttleRate {
            data["throttle_rate"] = String(describing: throttleRateOption)
        }
        
        if let queueLengthOption = queueLength {
            data["queue_length"] = String(describing: queueLengthOption)
        }
        
        if let fragmentSizeOption = fragmentSize {
            data["fragment_size"] = String(describing: fragmentSizeOption)
        }
        
        if let compressionOption = compression {
            data["compression"] = compressionOption
        }
        
        // pass the data to the manager
        self.manager.sendData(dictionary: data)
    }
    
    /// Tell ROS to stop sending messages
    func unsubscribe() {
        self.active = false
        
        var data = [
            "op" : "unsubscribe",
            "topic" : self.topic
        ]
        
        if let subscriberIdOption = subscriberId {
            data["id"] = subscriberIdOption
        }
        
        self.manager.sendData(dictionary: data)
    }
}