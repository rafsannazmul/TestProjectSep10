//
//  CodeHelpers.swift
//  TestProjectSep10
//
//  Created by Rafsan Nazmul on 9/11/24.
//

import Foundation
public typealias JSONS = [String: Any]

extension Dictionary where Dictionary == JSONS {
    var statusCode : Int{
        return Int(self["status_code"] as? String ?? String()) ?? Int()
    }
    var isSuccess : Bool{
        return statusCode != 0
    }
    var statusMessage:String {
        if let message =  self["status_message"] as? String, !message.isEmpty{
            return message
        }
        return self["success_message"] as? String ?? String()
        
    }
    func value<T>(forKeyPath path : String) -> T?{
        var keys = path.split(separator: ".")
        var childJSON = self
        let lastKey : String
        if let last = keys.last{
            lastKey = String(last)
        }else{
            lastKey = path
        }
        keys.removeLast()
        for key in keys{
            childJSON = childJSON.json(String(key))
        }
        return childJSON[lastKey] as? T
    }
    func array<T>(_ key : String) -> [T]{
        return self[key] as? [T] ?? [T]()
    }
    func array(_ key : String) -> [JSONS]{
        return self[key] as? [JSONS] ?? [JSONS]()
    }
    func arrayofarray(_ key : String) -> [[JSONS]]{
        return self[key] as? [[JSONS]] ?? [[JSONS]]()
    }
    func json(_ key : String) -> JSONS{
        return self[key] as? JSONS ?? JSONS()
    }
    
    func string(_ key : String)-> String{
        // return self[key] as? String ?? String()
        let value = self[key]
        if let str = value as? String{
            return str
        }else if let int = value as? Int{
            return int.description
        }else if let double = value as? Double{
            return double.description
        }else{
            return String()
        }
    }
    
    func nsString(_ key: String)-> NSString {
        return self.string(key) as NSString
    }
    func int(_ key : String)-> Int{
        //return self[key] as? Int ?? Int()
        let value = self[key]
        if let str = value as? String{
            return Int(str) ?? Int()
        }else if let int = value as? Int{
            return int
        }else if let double = value as? Double{
            return Int(double)
        }else{
            return Int()
        }
    }
    func double(_ key : String)-> Double{
        //return self[key] as? Double ?? Double()
        let value = self[key]
        if let str = value as? String{
            return Double(str) ?? Double()
        }else if let int = value as? Int{
            return Double(int)
        }else if let double = value as? Double{
            return double
        }else{
            return Double()
        }
    }
    
    func bool(_ key : String) -> Bool{
        let value = self[key]
        if let bool = value as? Bool{
            return bool
        }else if let int = value as? Int{
            return int == 1
        }else if let str = value as? String{
            return ["1","true"].contains(str)
        }else{
            return Bool()
        }
    }
    
    func setModelArray<T:BaseClass>(_ key:String, type:T.Type)-> [T] {
        var baseModel = [T]()
        self.array(key).forEach { (json) in
            let model = T(json)
            baseModel.append(model)
        }
        return baseModel
        
    }
    
    func setModel<T:BaseClass>(_ key:String, type:T.Type)-> T {
        let baseModel = T(self.json(key))
        return baseModel
        
    }
    
    func setModelWithNull<T:BaseClass>(_ key:String, type:T.Type)-> T? {
        
        if self.json(key).isEmpty{
            return nil
        }
        else{
            let baseModel = T(self.json(key))
            return baseModel
        }
        
    }
    
    func setModelWithNullArray<T:BaseClass>(_ key:String, type:T.Type)-> [T] {
        
        if self.json(key).isEmpty{
            return []
        }
        else{
            var baseModel = [T]()
            self.array(key).forEach { (json) in
                let model = T(json)
                baseModel.append(model)
            }
            return baseModel
        }
        
    }
    
    func setModel<T:BaseClass>( type:T.Type)-> T {
        let baseModel = T(self)
        return baseModel
    }
    
}

class BaseClass {
    
    required init(_ json:JSONS) {
        
    }
    
    init(){
        
    }
}

