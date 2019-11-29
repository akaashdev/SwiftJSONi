//
//  Formatter.swift
//  Pods-SwiftJSONi_Tests
//
//  Created by Akaash Dev on 01/04/19.
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


internal func getFormattedString(_ json: JSON, format jsonFormat: JSONPrintFormat = .normal, literalizeString: Bool, level: Int = 0) -> String {
    let format = jsonFormat.format
    var str: String = ""
    
    
    if let json = json.jsonObject {
        str += "{\(format.newline)"
        var notFirstFlag = false
        for (key, value) in json {
            if notFirstFlag {
                str += ",\(format.newline)"
            }
            str += "\(getTabSpace(string: format.tab, level: level+1))\"\(key)\" : \(getFormattedString(value, format: jsonFormat, literalizeString: literalizeString, level: level + 1))"
            notFirstFlag = true
        }
        str += "\(format.newline)\(getTabSpace(string: format.tab, level: level))}"
    }
        
    else if let array = json.jsonArray {
        str += "[\(format.newline)"
        var notFirstFlag = false
        for element in array {
            if notFirstFlag {
                str += ",\(format.newline)"
            }
            str += "\(getTabSpace(string: format.tab, level: level+1))\(getFormattedString(element, format: jsonFormat, literalizeString: literalizeString, level: level + 1))"
            notFirstFlag = true
        }
        str += "\(format.newline)\(getTabSpace(string: format.tab, level: level))]"
    }
        
    else if json.isDouble {
        str += "\(json.stringValue)"
    }
        
    else if let bool = json.bool {
        str += "\(bool)"
    }
        
    else if let string = json.string {
        str += "\"\(literalizeString ? string.literalized() : string)\""
    }
    
    if str.isEmpty {
        return "null"
    }
    
    return str
}


fileprivate func getTabSpace(string: String, level: Int) -> String {
    return (0..<level).reduce("") { result, _ in result + "\(string)" }
}


extension String {
    static let escapeSequences = [
        (original: "\0", escaped: "\\0"),
        (original: "\\", escaped: "\\\\"),
        (original: "\t", escaped: "\\t"),
        (original: "\n", escaped: "\\n"),
        (original: "\r", escaped: "\\r"),
        (original: "\"", escaped: "\\\""),
        (original: "\'", escaped: "\\'"),
    ]
    
    mutating func literalize() {
        self = self.literalized()
    }
    
    func literalized() -> String {
        return String.escapeSequences.reduce(self) {
            $0.replacingOccurrences(of: $1.original, with: $1.escaped)
        }
    }
}
