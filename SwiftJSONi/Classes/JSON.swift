//
//  JSON.swift
//  Pods-SwiftJSONi_Tests
//
//  Created by Akaash Dev on 31/03/19.
//

import Foundation

fileprivate typealias Array__ = [Any?]
fileprivate typealias Dictionary__ = [String: Any]

public struct JSON {
    
// MARK: Static Properties
    /// Empty JSON Object
    /// - Returns: [:]
    public static let emptyObject: JSON.Object = [:]
    
    /// Empty JSON Array
    /// - Returns: []
    public static let emptyArray: JSON.Array = []
    
    /// Empty JSON Object
    /// - Returns: [:]
    public static let empty: JSON = [:]
    public static let null: JSON = JSON(nil)
    

// MARK: TypeAliases
    public typealias Array = [JSON]
    public typealias Object = [String: JSON]
    
    
//MARK: Private Properties
    private var _object: JSON.Object?
    private var _array: JSON.Array?
    
    private let _value: Any?
    
    private let _isValidType: Bool
    
    
//MARK: Get-Only Properties
    /// A Boolean that tells whether the JSON is of valid type or not
    /// - Returns: true if the JSON is of valid type
    public var isValidType: Bool {
        return _isValidType
    }
    
    /// Initialize JSON Object with value of type
    /// - Parameter value: Any object. [String: Any] or [Any] will positively return a valid JSON
    /// - Returns: a valid or invalid JSON depending on the value passed
    public init(_ value: Any?) {
        
        if value == nil {
            self._isValidType = true
            self._value = nil
            return
        }
        
        if value is Array__ || value is Dictionary__ {
            
            if let dict = value as? Dictionary__ {
                self._object = dict.mapValues { JSON($0) }
            }
            
            if let array = value as? Array__ {
                self._array = array.map { JSON($0) }
            }
            
            self._isValidType = true
            self._value = value
            return
            
        }
        
        let isValid: Bool
        switch value {
        case is String,
             is Double,
             is Float,
             is Int,
             is NSNumber,
             is Bool,
             is Array__,
             is Dictionary__:
            isValid = true
            
        default:
            isValid = false
        }
        
        self._isValidType = isValid
        self._value = isValid ? value : nil
        
    }
    
    /// Initializes only valid JSON Object
    /// - Parameter object: [String: Any]
    /// - Returns: 'nil' if passed Dictionary contains User Defined Objects or if JSON is invalid
    public init?(validateObject object: [String: Any]) {
        var validJson = [String: JSON]()
        var valid = true
        for (key, value) in object {
            let value_ = JSON(validateAny: value)
            guard let val = value_ else {
                print("Value ('\(value)') for Key ('\(key)') is invalid JSON Value format.")
                valid = false
                continue
            }
            validJson[key] = val
        }
        
        if !valid {
            return nil
        }
        
        self._value = validJson
        self._object = validJson
        self._array = nil
        
        self._isValidType = true
    }
    
    /// Initializes only valid JSON Array
    /// - Parameter array: [Any]
    /// - Returns: 'nil' if passed Array contains User Defined Objects or if JSON is invalid
    public init?(validateArray array: [Any?]) {
        var validJson = [JSON]()
        var valid = true
        for (index, value) in array.enumerated() {
            let value_ = JSON(value)
            guard value_._isValidType else {
                print("Value ('\(value ?? "nil")') at Indexx ('\(index)') is invalid JSON Value format.")
                valid = false
                continue
            }
            validJson.append(value_)
        }
        
        if !valid {
            return nil
        }
        
        self._value = validJson
        self._object = nil
        self._array = validJson
        self._array = nil
        
        self._isValidType = true
    }
    
    /// Initializes only valid JSON Array.
    /// - Parameter string: JSON Data represented as String
    /// - Returns: 'nil' if jsonString is nil or if jsonString is invalid
    public init?(jsonString string: String?) {
        guard let string = string else { return nil }
        guard let data = string.data(using: .utf8) else { return nil }
        self.init(data: data)
    }
    
    /// Initializes JSON with Data using JSONSerialization with options '.allowFragments'.
    /// - Parameter data: Data received from API
    /// - Returns: 'nil' if JSON parsing fails
    public init?(data: Data?) {
        guard let data = data else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return nil }
        self.init(json)
    }
    
    public init?(validateAny any: Any?) {
        guard let any = any else {
            return nil
        }
        
        switch any {
        case is String,
             is Double,
             is Float,
             is Int,
             is NSNumber,
             is Bool:
            self.init(any)
            
        case let array as Array__:
            self.init(validateArray: array)
            
        case let dict as Dictionary__:
            self.init(validateObject: dict)
            
        case let data as Data:
            self.init(data: data)
            
        default:
            return nil
        }
    }
    
    
    public var value: Any? { return _value }
    
    /// - Returns: the String value for the corresponding Key.
    /// - Returns: 'nil' if String value doesn't exist.
    public var string: String? { return getAsString() }
    
    /// - Returns: the Int value for the corresponding Key.
    /// - Returns: 'nil' if Int value doesn't exist.
    public var int: Int? { return getAsInt() }
    
    /// - Returns: the Float value for the corresponding Key.
    /// - Returns: 'nil' if Float value doesn't exist.
    public var float: Float? { return getAsFloat() }
    
    /// - Returns: the Double value for the corresponding Key.
    /// - Returns: 'nil' if Double value doesn't exist.
    public var double: Double? { return getAsDouble() }
    
    /// - Returns: the Bool value for the corresponding Key.
    /// - Returns: 'nil' if Bool value doesn't exist.
    public var bool: Bool? { return getAsBool() }
    
    
    
    /// - Returns: the JSON.Object ([String: JSONValue]) for the corresponding Key.
    /// - Returns: 'nil' if JSON.Object doesn't exist.
    public var jsonObject: JSON.Object? { return _object }
    
    /// - Returns: the JSON.Array ([JSONValue]) for the corresponding Key.
    /// - Returns: 'nil' if JSON.Array doesn't exist.
    public var jsonArray: JSON.Array? { return _array }
    
    
    /// - Returns: the Array ([Any?]) value for the corresponding key.
    /// - Returns: 'nil' if Array value doesn't exist.
    public var array: [Any?]? { return value as? Array__ }
    
    /// - Returns: the Dictionary ([String: Any]) value for the corresponding key.
    /// - Returns: 'nil' if Dictionary value doesn't exist.
    public var dictionary: [String: Any]? { return value as? Dictionary__ }
    
    
    
    /// - Returns: the String value for the corresponding key.
    /// - Returns: default String ("") if String value doesn't exist.
    public var stringValue: String { return string ?? "" }
    
    /// - Returns: the Int value for the corresponding key.
    /// - Returns: default Int (0) if Int value doesn't exist.
    public var intValue: Int { return int ?? 0 }
    
    /// - Returns: the Float value for the corresponding key.
    /// - Returns: default Float (0.0) if Float value doesn't exist.
    public var floatValue: Float { return float ?? 0.0 }
    
    /// - Returns: the Double value for the corresponding key.
    /// - Returns: default Double (0.0) if Double value doesn't exist.
    public var doubleValue: Double { return double ?? 0.0 }
    
    /// - Returns: the Bool value for the corresponding key.
    /// - Returns: default Bool (false) if Bool value doesn't exist.
    public var boolValue: Bool { return bool ?? false }
    
    
    
    /// - Returns: the JSON.Object ([String: JSONValue]) value for the corresponding key.
    /// - Returns: default JSON.Object ([:]) if JSON.Object value doesn't exist.
    public var jsonObjectValue: JSON.Object { return jsonObject ?? JSON.emptyObject }
    
    /// - Returns: the JSON.Array ([JSONValue]) value for the corresponding key.
    /// - Returns: default JSON.Array ([]) if JSON.Array value doesn't exist.
    public var jsonArrayValue: JSON.Array { return jsonArray ?? JSON.emptyArray }
    
    
    /// - Returns: the Array value for the corresponding key.
    /// - Returns: default Array ([]) if Array value doesn't exist.
    public var arrayValue: [Any?] { return array ?? [] }
    
    /// - Returns: the Dictionary value for the corresponding key.
    /// - Returns: default Dictionary ([:]) if Dictionary value doesn't exist.
    public var dictionaryValue: [String: Any] { return dictionary ?? [:] }
    
    
    /// - Returns: true if the value for the corresponding key is nil.
    public var isNull: Bool { return value == nil }
    
    /// - Returns: true if the value for the corresponding key is of type String.
    public var isString: Bool { return value is String }
    
    /// - Returns: true if the value for the corresponding key is of type Int.
    public var isInt: Bool { return value is Int }
    
    /// - Returns: true if the value for the corresponding key is of type Float.
    public var isFloat: Bool { return value is Float }
    
    /// - Returns: true if the value for the corresponding key is of type Double.
    public var isDouble: Bool { return value is Double }
    
    /// - Returns: true if the value for the corresponding key is of type Bool.
    public var isBool: Bool { return value is Bool }
    
    
    
    /// - Returns: true if the value for the corresponding key is of type JSON.Object ([String: JSONValue]).
    public var isJsonObject: Bool { return jsonObject != nil }
    
    /// - Returns: true if the value for the corresponding key is of type JSON.Array ([JSONValue]).
    public var isJsonArray: Bool { return jsonArray != nil }
    
    
    /// - Returns: true if the value for the corresponding key is of type Array ([Any?]).
    public var isArray: Bool { return value is Array__ }
    
    /// - Returns: true if the value for the corresponding key is of type Dictionary ([String: Any]).
    public var isDictionary: Bool { return value is Dictionary__ }
    
    
    
    ///Prints the JSON in prettyPrint format.
    public func debugPrint() {
        print(debugDescription)
    }
    
    
    /// - Returns: the JSONValue in Object, for the corresponding key.
    /// - Returns: nullObject if JSON is Array or key doesn't exist.
    public subscript(_ key: String) -> JSON {
        get {
            return _object?[key] ?? JSON.null
        }
        set {
            if let _ = _object {
                self._object?[key] = newValue
                return
            }
        }
    }
    
    /// - Returns: the JSONValue in Array, for the corresponding index.
    /// - Returns: nullObject if JSON is Object or index doesn't exist.
    public subscript(_ index: Int) -> JSON {
        get {
            guard let array = _array, index < array.count else {
                return JSON.null
            }
            return array[index]
        }
        set {
            if let array = _array, index < array.count {
                self._array?[index] = newValue
                return
            }
        }
    }
    
    
    /// - Returns: the first JSONValue if the JSON if of type Array.
    /// - Returns: nil if the JSON is of type Object.
    public var first: JSON? {
        if let array = _array, array.count > 0 {
            return array[0]
        }
        return nil
    }
    
    public var count: Int {
        if let array = _array {
            return array.count
        }
        if let dict = _object {
            return dict.count
        }
        return 0
    }
    
    
    /// Boolean that indicates whether the JSON is empty
    /// - Returns: true for nullJson.
    public var isEmpty: Bool {
        if let array = _array {
            return array.isEmpty
        }
        if let obj = _object {
            return obj.isEmpty
        }
        return value == nil
    }
    
    
    public var validate: JSON? {
        if value == nil {
            return nil
        }
        return self
    }
    
    
    private func getAsString() -> String? {
        if let string = value as? String {
            return string
        }
        if let value_ = value {
            return String(describing: value_)
        }
        return nil
    }
    
    private func getAsInt() -> Int? {
        switch value {
        case let string as String:
            return Int(string)
            
        case let int as Int:
            return int
            
        case let float as Float:
            return Int(float)
            
        case let double as Double:
            return Int(double)
            
        case let number as NSNumber:
            return Int(truncating: number)
            
        case let bool as Bool:
            return bool ? 1 : 0
            
        default:
            return nil
        }
    }
    
    private func getAsFloat() -> Float? {
        switch value {
        case let string as String:
            return Float(string)
            
        case let int as Int:
            return Float(int)
            
        case let float as Float:
            return float
            
        case let double as Double:
            return Float(double)
            
        case let number as NSNumber:
            return Float(truncating: number)
            
        case let bool as Bool:
            return bool ? 1 : 0
            
        default:
            return nil
        }
    }
    
    private func getAsDouble() -> Double? {
        switch value {
        case let string as String:
            return Double(string)
            
        case let int as Int:
            return Double(int)
            
        case let float as Float:
            return Double(float)
            
        case let double as Double:
            return double
            
        case let number as NSNumber:
            return Double(truncating: number)
            
        case let bool as Bool:
            return bool ? 1 : 0
            
        default:
            return nil
        }
    }
    
    private func getAsBool() -> Bool? {
        switch value {
        case let string as String:
            return Bool(string)
            
        case let double as Double:
            return double > 0
            
        case let number as NSNumber:
            return Bool(truncating: number)
            
        case let bool as Bool:
            return bool
            
        default:
            return nil
        }
    }
    
}


extension JSON: ExpressibleByDictionaryLiteral {
    
    public typealias Key = String
    public typealias Value = Any
    
    public init(dictionaryLiteral elements: (JSON.Key, JSON.Value)...) {
        var dict: [String: Any] = [:]
        for (key, value) in elements {
            dict[key] = value
        }
        self.init(dict)
    }
    
}


extension JSON: ExpressibleByArrayLiteral {
    
    public typealias ArrayLiteralElement = Any?
    
    public init(arrayLiteral elements: JSON.ArrayLiteralElement...) {
        self.init(elements)
    }
    
}


extension JSON: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: JSON.StringLiteralType) {
        guard let data = value.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            else {
                self.init(value)
                return
        }
        self.init(json)
    }
    
}


extension JSON: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: JSON.IntegerLiteralType) {
        self.init(value)
    }
    
}


extension JSON: ExpressibleByFloatLiteral {
    
    public typealias FloatLiteralType = Float
    
    public init(floatLiteral value: JSON.FloatLiteralType) {
        self.init(value)
    }
    
}


extension JSON: ExpressibleByBooleanLiteral {
    
    public typealias BooleanLiteralType = Bool
    
    public init(booleanLiteral value: JSON.BooleanLiteralType) {
        self.init(value)
    }
    
}


extension JSON: ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {
        self.init(nil)
    }
    
}



extension JSON: CustomStringConvertible {
    
    public var description: String {
        return getFormattedString(self, literalizeString: true)
    }
    
}


extension JSON: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return getFormattedString(self, format: .pretty, literalizeString: true)
    }
    
}
