//
//  Formatter.swift
//  JSONTest
//
//  Created by Akaash Dev on 24/11/18.
//  Copyright © 2018 Akaash Dev. All rights reserved.
//

import Foundation


public enum JSONPrintFormat {
    case pretty, normal, custom(tab: String, newline: String)
    
    var format: PrintFormat {
        switch self {
        case .pretty:
            return PrintFormat(tab: "\t", newline: "\n")
            
        case .normal:
            return PrintFormat(tab: "", newline: "")
            
        case .custom(let tab, let newline):
            return PrintFormat(tab: tab, newline: newline)
        }
    }
}


internal struct PrintFormat {
    let tab: String
    let newline: String
}


internal func getFormattedString(_ json: JSON, format jsonFormat: JSONPrintFormat = .normal, level: Int = 0) -> String {
    let format = jsonFormat.format
    var str: String = ""
    
    if let json = json.asJsonObject {
        str += "{\(format.newline)"
        var notFirstFlag = false
        for (key, value) in json {
            if notFirstFlag {
                str += ",\(format.newline)"
            }
            str += "\(getTabSpace(string: format.tab, level: level+1))\"\(key)\" : \(getFormattedString(value, format: jsonFormat, level: level + 1))"
            notFirstFlag = true
        }
        str += "\(format.newline)\(getTabSpace(string: format.tab, level: level))}"
    }
    
    if let array = json.asJsonArray {
        str += "[\(format.newline)"
        var notFirstFlag = false
        for element in array {
            if notFirstFlag {
                str += ",\(format.newline)"
            }
            str += "\(getTabSpace(string: format.tab, level: level+1))\(getFormattedString(element, format: jsonFormat, level: level + 1))"
            notFirstFlag = true
        }
        str += "\(format.newline)\(getTabSpace(string: format.tab, level: level))]"
    }
    
    return str
}


internal func getFormattedString(_ value: JSONValue, format jsonFormat: JSONPrintFormat = .normal, level: Int = 0) -> String {
    var str = ""
    switch value.value {
    case is String: str += "\"\(value.stringValue)\""
    case is Bool: str += "\(value.boolValue)"
    case is Int: str += "\(value.intValue)"
    case is Double: str += "\(value.doubleValue)"
    case is JSONValue.Array: str += "\(getFormattedString(value.jsonValue, format: jsonFormat, level: level))"
    case is JSONValue.Dictionary: str += "\(getFormattedString(value.jsonValue, format: jsonFormat, level: level))"
    default: str += "null"
    }
    return str
}



fileprivate func getTabSpace(string: String, level: Int) -> String {
    return (0..<level).reduce("") { result, _ in result + "\(string)" }
}
