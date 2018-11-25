//
//  JSONValue.swift
//  JSONTest
//
//  Created by Akaash Dev on 21/10/18.
//  Copyright © 2018 Akaash Dev. All rights reserved.
//

import Foundation


//
//    A value can be a string in double quotes, or a number, or true or false or null, or an object or an array. These structures can be nested.
//
//    A string is a sequence of zero or more Unicode characters, wrapped in double quotes, using backslash escapes. A character is represented as a single character string. A string is very much like a C or Java string.
//
//    A number is very much like a C or Java number, except that the octal and hexadecimal formats are not used.
//
//  Source: https://www.json.org
//


public struct JSONValue {
    
    ///Returns JSONValue(nil).
    public static let nullObject: JSONValue = JSONValue(nil)
    
    
    public typealias Array = [Any?]
    public typealias Dictionary = [String: Any]
    
    
    private let _value: Any?
    
    private let _string: String?
    private let _double: Double?
    private let _bool: Bool?
    

    public var isValid: Bool
    
    
    public init(_ value: Any?) {
        
        if value == nil {
            self.isValid = true
            self._value = nil
            self._string = nil
            self._double = nil
            self._bool = nil
            return
        }
        
        var isValid = true
        
        switch value {
        case let bool as Bool:
            self._bool = bool
            self._double = bool ? 1 : 0
            self._string = String(describing: bool)
            
        case let double as Double:
            self._double = double
            self._bool = double > 0
            self._string = String(describing: double)
            
        case let float as Float:
            self._double = Double(float)
            self._bool = float > 0
            self._string = String(describing: float)
            
        case let int as Int:
            self._double = Double(int)
            self._bool = int > 0
            self._string = String(describing: int)
            
        case let number as NSNumber:
            self._double = Double(truncating: number)
            self._bool = Int(truncating: number) > 0
            self._string = String(describing: number)
            
        case let string as String:
            self._double = Double(string)
            self._bool = Bool(string)
            self._string = string
            
        default:
            isValid = false
            self._double = nil
            self._bool = nil
            self._string = nil
        }
        
        self.isValid = isValid
        self._value = isValid ? value : nil
        
    }
    
    
    public var value: Any? { return _value }
    
    ///Returns the String value for the corresponding Key.
    ///Returns 'nil' if String value doesn't exist.
    public var string: String? { return _string }
    
    ///Returns the Int value for the corresponding Key.
    ///Returns 'nil' if Int value doesn't exist.
    public var int: Int? { return _double == nil ? nil : Int(_double!) }
    
    ///Returns the Float value for the corresponding Key.
    ///Returns 'nil' if Float value doesn't exist.
    public var float: Float? { return _double == nil ? nil : Float(_double!) }
    
    ///Returns the Double value for the corresponding Key.
    ///Returns 'nil' if Double value doesn't exist.
    public var double: Double? { return _double }
    
    ///Returns the Bool value for the corresponding Key.
    ///Returns 'nil' if Bool value doesn't exist.
    public var bool: Bool? { return _bool }
    
    
    ///Returns the JSON for the corresponding Key.
    ///Returns 'nil' if JSON doesn't exist.
    public var json: JSON? { return JSON(data: value) }
    
    ///Returns the JSON.Object ([String: JSONValue]) for the corresponding Key.
    ///Returns 'nil' if JSON.Object doesn't exist.
    public var jsonObject: JSON.Object? { return json?.asJsonObject }
    
    ///Returns the JSON.Array ([JSONValue]) for the corresponding Key.
    ///Returns 'nil' if JSON.Array doesn't exist.
    public var jsonArray: JSON.Array? { return json?.asJsonArray }
    
    
    ///Returns the Array ([Any?]) value for the corresponding key.
    ///Returns 'nil' if Array value doesn't exist.
    public var array: Array? { return value as? Array }
    
    ///Returns the Dictionary ([String: Any]) value for the corresponding key.
    ///Returns 'nil' if Dictionary value doesn't exist.
    public var dictionary: Dictionary? { return value as? Dictionary }
    
    
    
    ///Returns the String value for the corresponding key.
    ///Returns default String ("") if String value doesn't exist.
    public var stringValue: String { return string ?? "" }
    
    ///Returns the Int value for the corresponding key.
    ///Returns default Int (0) if Int value doesn't exist.
    public var intValue: Int { return int ?? 0 }
    
    ///Returns the Float value for the corresponding key.
    ///Returns default Float (0.0) if Float value doesn't exist.
    public var floatValue: Float { return float ?? 0.0 }
    
    ///Returns the Double value for the corresponding key.
    ///Returns default Double (0.0) if Double value doesn't exist.
    public var doubleValue: Double { return double ?? 0.0 }
    
    ///Returns the Bool value for the corresponding key.
    ///Returns default Bool (false) if Bool value doesn't exist.
    public var boolValue: Bool { return bool ?? false }
    
    
    ///Returns the JSON for the corresponding key.
    ///Returns default JSON ([:]) if JSON value doesn't exist.
    public var jsonValue: JSON { return json ?? .empty }
    
    ///Returns the JSON.Object ([String: JSONValue]) value for the corresponding key.
    ///Returns default JSON.Object ([:]) if JSON.Object value doesn't exist.
    public var jsonObjectValue: JSON.Object { return jsonObject ?? JSON.emptyObject.asJsonObject! }
    
    ///Returns the JSON.Array ([JSONValue]) value for the corresponding key.
    ///Returns default JSON.Array ([]) if JSON.Array value doesn't exist.
    public var jsonArrayValue: JSON.Array { return jsonArray ?? JSON.emptyArray.asJsonArray! }
    
    
    ///Returns the Array value for the corresponding key.
    ///Returns default Array ([]) if Array value doesn't exist.
    public var arrayValue: Array { return array ?? [] }
    
    ///Returns the Dictionary value for the corresponding key.
    ///Returns default Dictionary ([:]) if Dictionary value doesn't exist.
    public var dictionaryValue: Dictionary { return dictionary ?? [:] }
    
    
    ///Returns true if the value for the corresponding key is of type String.
    public var isString: Bool { return string != nil }
    
    ///Returns true if the value for the corresponding key is of type Int.
    public var isInt: Bool { return int != nil }
    
    ///Returns true if the value for the corresponding key is of type Float.
    public var isFloat: Bool { return float != nil }
    
    ///Returns true if the value for the corresponding key is of type Double.
    public var isDouble: Bool { return double != nil }
    
    ///Returns true if the value for the corresponding key is of type Bool.
    public var isBool: Bool { return bool != nil }
    
    
    ///Returns true if the value for the corresponding key is of type JSON.
    public var isJson: Bool { return json != nil }
    
    ///Returns true if the value for the corresponding key is of type JSON.Object ([String: JSONValue]).
    public var isJsonObject: Bool { return jsonObject != nil }
    
    ///Returns true if the value for the corresponding key is of type JSON.Array ([JSONValue]).
    public var isJsonArray: Bool { return jsonArray != nil }
    
    
    ///Returns true if the value for the corresponding key is of type Array ([Any?]).
    public var isArray: Bool { return array != nil }
    
    ///Returns true if the value for the corresponding key is of type Dictionary ([String: Any]).
    public var isDictionary: Bool { return dictionary != nil }
    
    
    public subscript(_ key: String) -> JSONValue {
        guard let json_ = json else { return JSONValue(nil) }
        return json_[key]
    }
    
    public subscript(_ index: Int) -> JSONValue {
        guard let json_ = json else { return JSONValue(nil) }
        return json_[index]
    }

    
    ///Prints the JSONValue in prettyPrint format.
    public func debugPrint() {
        print(getFormattedString(self, format: .pretty))
    }
    
}


extension JSONValue: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: JSONValue.StringLiteralType) {
        self.init(value)
    }
    
}


extension JSONValue: ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: JSONValue.IntegerLiteralType) {
        self.init(value)
    }
    
}


extension JSONValue: ExpressibleByFloatLiteral {
    
    public typealias FloatLiteralType = Float
    
    public init(floatLiteral value: JSONValue.FloatLiteralType) {
        self.init(value)
    }
    
}


extension JSONValue: ExpressibleByBooleanLiteral {
    
    public typealias BooleanLiteralType = Bool
    
    public init(booleanLiteral value: JSONValue.BooleanLiteralType) {
        self.init(value)
    }
    
}


extension JSONValue: ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {
        self.init(nil)
    }
    
}


extension JSONValue: ExpressibleByArrayLiteral {
    
    public typealias ArrayLiteralElement = Any?
    
    public init(arrayLiteral elements: JSONValue.ArrayLiteralElement...) {
        var array = [Any?]()
        for element in elements {
            array.append(element)
        }
        self.init(array)
    }
    
}


extension JSONValue: ExpressibleByDictionaryLiteral {
    
    public typealias Key = String
    public typealias Value = Any
    
    public init(dictionaryLiteral elements: (JSONValue.Key, JSONValue.Value)...) {
        var json: [String: Any] = [:]
        for (key, value) in elements {
            json[key] = value
        }
        self.init(json)
    }
    
}
