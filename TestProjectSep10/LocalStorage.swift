//
//  LocalStorage.swift
//  TestProjectSep10
//
//  Created by Rafsan Nazmul on 9/11/24.
//

import Foundation
import UIKit

class LocalStorage {
    
    enum LocalValue:String {
        case fcmToken
        case deviceToken = "device_token"
        
        case userID = "user_id"
        case access_token
        
    }
    
    static var shared = LocalStorage()
    

    
    func setSting(_ key:LocalValue,text:String = "" ){
        UserDefaults.standard.set(text, forKey: key.rawValue)
    }
    
    func setInt(_ key:LocalValue,value:Int = 0) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func setBool(_ key :LocalValue,value:Bool = false) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func setDouble(_ key :LocalValue,value:Double = 0.0) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
   
    func getString(key:LocalValue)->String{
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setSting(key)
        }
        if let result = UserDefaults.standard.string(forKey: key.rawValue) {
            return result
        }
        return  ""
    }
    
    func getInt(key:LocalValue)->Int{
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setInt(key)
        }
        let result = UserDefaults.standard.integer(forKey: key.rawValue)
        return result
    }
    
    func getBool(key:LocalValue)->Bool {
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setBool(key)
        }
        let result = UserDefaults.standard.bool(forKey: key.rawValue)
        return result
    }
    func getDouble(key:LocalValue)->Double {
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            self.setDouble(key)
        }
        let result = UserDefaults.standard.double(forKey: key.rawValue)
        return result
    }
    
    
  
    static func isLogin()->Bool {
        return LocalStorage.shared.getString(key: .access_token).count > 0
    }

}

