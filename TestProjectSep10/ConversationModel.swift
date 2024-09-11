//
//  ConversationModel.swift
//  TestProjectSep10
//
//  Created by Rafsan Nazmul on 9/11/24.
//

import Foundation
import UIKit

class ConversationModel : NSObject
{
    //MARK Properties
    var success_message : String = ""
    var status_code : String = ""
    var receiver_thumb_image : String = ""
    var receiver_user_name : String = ""
    var receiver_message_status : String = ""
    var receiver_details : JSONS = JSONS()
    var receiver_messages_time : String = ""
    
    var receiver_messages : String = ""
    var sender_thumb_image : String = ""
    var sender_user_name : String = ""
    var sender_message_status : String = ""
    var sender_details : JSONS = JSONS()
    var sender_messages : String = ""
    var sender_messages_time : String = ""
    
    
    //    var is_message_read : String = ""
    
    //MARK: Inits
    init(responseDict: JSONS)
    {
        receiver_thumb_image = responseDict.string("receiver_thumb_image")
        receiver_user_name = responseDict.string("receiver_user_name")
        receiver_message_status = responseDict.string("receiver_message_status")
        receiver_messages = responseDict.string("receiver_messages")
        receiver_messages_time = responseDict.string("receiver_messages_date/time")
        sender_thumb_image = responseDict.string("sender_thumb_image")
        sender_user_name = responseDict.string("sender_user_name")
        sender_message_status = responseDict.string("sender_message_status")
        sender_messages = responseDict.string("sender_messages")
        
        if var latestValue = responseDict["sender_details"] as? JSONS
        {
            sender_details = latestValue
        }
        
        if var latestValue = responseDict["receiver_details"] as? JSONS
        {
            receiver_details = latestValue
        }
        
    }
    
    
}


class ConversationChatModel:BaseClass {
    var successMessage: String = ""
    var statusCode: String = ""
    var senderUserName: String = ""
    var senderThumbImage: String = ""
    var receiverUserName: String = ""
    var receiverThumbImage: String = ""
    var chat: [Chat] = []
    
    required init(_ json: JSONS) {
        self.successMessage = json.statusMessage
        self.statusCode = "\(json.statusCode)"
        self.senderUserName = json.string("sender_user_name")
        self.senderThumbImage = json.string("sender_thumb_image")
        self.receiverUserName = json.string("receiver_user_name")
        self.receiverThumbImage = json.string("receiver_thumb_image")
        self.chat = json.setModelArray("data", type: Chat.self)
        super.init(json)
    }
}

class Chat :BaseClass {
    var receiver_thumb_image : String = ""
    var receiver_user_name : String = ""
    var receiver_message_status : String = ""
    var receiver_details : ErDetails!
    var receiver_messages_time : String = ""
    
    var receiver_messages : String = ""
    var sender_thumb_image : String = ""
    var sender_user_name : String = ""
    var sender_message_status : String = ""
    var sender_details : ErDetails!
    var sender_messages : String = ""
    var sender_messages_time : String = ""
    var is_deleted_user : Bool = false
    
    
    init(fromSocketChat chat : SocketChatModel){
        self.receiver_messages = chat.message
        self.receiver_thumb_image = chat.senderProfile
        self.receiver_messages_time = Date().format(to: .dispalyTime)
        self.receiver_user_name = chat.userFrom.description//name is need to show cell
        super.init(JSONS())
    }
    
    required init(_ json: JSONS) {
        receiver_thumb_image = json.string("receiver_thumb_image")
        receiver_user_name = json.string("receiver_user_name")
        receiver_message_status = json.string("receiver_message_status")
        receiver_messages = json.string("receiver_messages").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.removingPercentEncoding ?? ""
        //            ((responseDict.string("receiver_messages") as NSString).removingPercentEncoding)! as String
        receiver_messages_time = json.string("receiver_messages_date/time")
        sender_thumb_image = json.string("sender_thumb_image")
        sender_user_name = json.string("sender_user_name")
        sender_message_status = json.string("sender_message_status")
        sender_messages = json.string("sender_messages").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.removingPercentEncoding ?? ""
        //            ((responseDict.string("sender_messages") as NSString).removingPercentEncoding)! as String
        sender_messages_time = json.string("sender_messages_date/time")
        is_deleted_user = json.bool("is_deleted_user")
        
        if let latestValue = json["sender_details"] as? JSONS
        {
            let erDetails = ErDetails(
                status: latestValue.string("status"),
                dateTime: latestValue.string("date_time"),
                title: latestValue.string("title"),
                message: latestValue.string("message")
            )
            sender_details = erDetails
        }
        
        if let latestValue = json["receiver_details"] as? JSONS
        {
            let erDetails = ErDetails(
                status: latestValue.string("status"),
                dateTime: latestValue.string("date_time"),
                title: latestValue.string("title"),
                message: latestValue.string("message")
            )
            receiver_details = erDetails
        }
        super.init(json)
        
    }
    
    init(asSentMessage message : String) {
        self.sender_user_name = "sender" //for now just keeping it simple but later I will add per user name
        self.sender_messages = message
        self.sender_messages_time = Date().format(to: .dispalyTime)
        super.init(JSONS())
    }
    
    
    convenience init(fcm message:String, userName:String, image:String) {
        self.init(JSONS())
        self.receiver_messages = message
        self.receiver_user_name = userName
        self.receiver_thumb_image = image
        self.receiver_messages_time = Date().format(to: .dispalyTime)
    }
}

class ErDetails {
    var status: String = ""
    var dateTime: String = ""
    var title : String = ""
    var message : String = ""
    
    init(status: String, dateTime: String,title : String, message : String) {
        self.status = status
        self.dateTime = dateTime
        self.title = title
        self.message = message
    }
}

class SocketChatModel : Codable{
    let message : String
    let senderProfile : String
    let userFrom : Int
    
    enum CodingKeys: String, CodingKey {
        case message
        case senderProfile = "sender_profile"
        case userFrom = "user_from"
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = container.safeDecodeValue(forKey: .message)
        self.senderProfile = container.safeDecodeValue(forKey: .senderProfile)
        self.userFrom = container.safeDecodeValue(forKey: .userFrom)
    }
}

