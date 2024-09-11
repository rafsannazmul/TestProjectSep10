//
//  FirebaseSupport.swift
//  TestProjectSep10
//
//  Created by Rafsan Nazmul on 9/11/24.
//

import Foundation
import UIKit
import FirebaseDatabase

protocol FirebaseObserver:class {
    func didReceive(fcm message:Chat, at reservationid:String)
}


class FirebaseSupport: NSObject {
    
    enum FirebaseJSONKey:String {
        case userName = "user_from"
        case userImage = "sender_profile"
        case reservationID = "reservation_id"
        case message
    }
    var userID :String
    var observerDelegate:FirebaseObserver?
    var isForInbox = Bool()
    
    var chatRef:DatabaseReference?
    
    init(delegate:FirebaseObserver) {
        self.userID = LocalStorage.shared.getString(key: .userID)
        self.observerDelegate = delegate
        
    }
    
    
    func updateChatToReceiver(_ message:String, reservationID:String, hostID:String,userImage:String) {
        guard hostID.count > 0 else {
            return
        }
        let observer = self.chatRef?.child(hostID)
        let autoId = self.chatRef?.childByAutoId()
        var messageJSON = JSONS()
        messageJSON[FirebaseJSONKey.message.rawValue] = message
        messageJSON[FirebaseJSONKey.userImage.rawValue] = userImage
        observer?.child(autoId?.key ?? "key").setValue(messageJSON, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                print(ref)
            }
                            
        })
    }
    
    
    func startObserver() {
        let serverNode = k_WebServerUrl == AppURL.demo.instance ? "Demo" : "Live"
         self.chatRef = Database.database().reference().child(serverNode).child("message")
        
        self.chatRef?.observe(.value, with: { (snapshot) in
            if snapshot.hasChild(self.userID) {
                let chatSnapShot = snapshot.childSnapshot(forPath: self.userID)
                if var  response = chatSnapShot.value as? JSONS {
                    
                    for (index,key) in response.keys.enumerated() {
                        if index == response.keys.count - 1 {
                            response =  response[key] as! JSONS
                        }
                    }
                 
                    print("Ø Chat Value \(chatSnapShot.value ?? "")")
//                    print("Ø  responseType \(type(of: chatSnapShot.value))")
                        let json = response
                    print("ØØØØ \(json)")
    //                        MARK: - New Message Delegate
                       let chatModel = Chat(fcm: json.string(FirebaseJSONKey.message.rawValue),
                                            userName: json.string(FirebaseJSONKey.userName.rawValue),
                                            image: json.string(FirebaseJSONKey.userImage.rawValue))
                       self.observerDelegate?.didReceive(fcm: chatModel,at: json.string(FirebaseJSONKey.reservationID.rawValue))
//                    if !self.isForInbox {
                        self.chatRef?.child(self.userID).removeValue(completionBlock: { (error, ref) in
                            if let error = error {
                                print("Ø error \(error.localizedDescription)")
                            }
                            print("ØØ ref: \(ref)")
                        })
//                    }
                        
                    
                }
            }else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.stopObserver()
                    self.startObserver()
                }
            }
        })
        

    }
    
    func stopObserver() {
        self.chatRef?.removeAllObservers()
        self.chatRef = nil
    }
    
    
    deinit {
        self.stopObserver()
    }
    
    
}
