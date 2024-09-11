//
//  Extenstions.swift
//  TestProjectSep10
//
//  Created by Rafsan Nazmul on 9/11/24.
//

import Foundation


// MARK: Date Formatter


extension DateFormatter{
    enum DateFormats: String {
        /// Time
        case time = "HH:mm:ss"
        case dispalyTime = "hh:mm a"
        
        /// Date with hours
        case dateWithTime = "yyyy-MM-dd HH:mm:ss"
        
        case date = "dd-MM-yyyy"
    }
    static func formatter(for type: DateFormats) -> DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        return formatter
    }
    static func formatDate(fromString string : String, of type : DateFormats) -> Date?{
        return self.formatter(for: type).date(from: string)
    }
    static func formatString(fromDate date : Date,to type : DateFormats) -> String{
        return self.formatter(for: type).string(from: date)
    }
    
    
}
extension Date{
    func format(to type : DateFormatter.DateFormats) -> String{
        return DateFormatter.formatString(fromDate: self, to: type)
    }
}
extension String{
    func format(of type : DateFormatter.DateFormats) -> Date?{
        return DateFormatter.formatDate(fromString: self, of: type)
    }
}

// MARK: Decodable

public extension KeyedDecodingContainer{
    
    func safeDecodeValue<T: SafeDecodable & Decodable>(forKey key: Self.Key) -> T {
        if let value = try? self.decodeIfPresent(T.self, forKey: key) {
            return value
        } else if let stringValue = try? self.decodeIfPresent(String.self, forKey: key),
                  let castedValue = stringValue as? T {
            return castedValue
        } else if let intValue = try? self.decodeIfPresent(Int.self, forKey: key),
                  let castedValue = intValue as? T {
            return castedValue
        } else if let floatValue = try? self.decodeIfPresent(Float.self, forKey: key),
                  let castedValue = floatValue as? T {
            return castedValue
        } else if let doubleValue = try? self.decodeIfPresent(Double.self, forKey: key),
                  let castedValue = doubleValue as? T {
            return castedValue
        } else if let boolValue = try? self.decodeIfPresent(Bool.self, forKey: key),
                  let castedValue = boolValue as? T {
            return castedValue
        }
        return T.init()
    }

}

//MARK:- protocol SafeDecodable
public protocol Initializable {
    init()
}

public protocol DefaultValue : Initializable {}
extension DefaultValue {
    static var `default` : Self{return Self.init()}
}

public protocol SafeDecodable : DefaultValue{}
extension SafeDecodable{
    func cast<T: SafeDecodable>() -> T{return T.init()}
}
//MARK:- Int
extension Int : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.default
    }
    
    
}
//MARK:- Double
extension Double : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- Float
extension Float : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- String
extension String : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is Int.Type:
            castValue = Int(self.description) as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = ["true","yes","1"]
                .contains(self.lowercased()) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- Bool
extension Bool : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Double.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Bool.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Float.Type:
            castValue = (self ? 1 : 0) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- Array
extension Array : SafeDecodable{
    public static var `default` : Array<Element> {return Array<Element>()}
    public func cast<T>() -> T where T : SafeDecodable {
        return T.init()
    }
}

