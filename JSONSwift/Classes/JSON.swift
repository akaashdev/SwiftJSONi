//
//  JSON.swift
//  JSONTest
//
//  Created by Akaash Dev on 19/10/18.
//  Copyright © 2018 Akaash Dev. All rights reserved.
//

import Foundation


//
//    JSON (JavaScript Object Notation) is a lightweight data-interchange format. It is easy for humans to read and write. It is easy for machines to parse and generate. It is based on a subset of the JavaScript Programming Language, Standard ECMA-262 3rd Edition - December 1999. JSON is a text format that is completely language independent but uses conventions that are familiar to programmers of the C-family of languages, including C, C++, C#, Java, JavaScript, Perl, Python, and many others. These properties make JSON an ideal data-interchange language.
//
//    JSON is built on two structures:
//
//     -  A collection of name/value pairs. In various languages, this is realized as an object, record, struct, dictionary, hash table, keyed list, or associative array.
//     -  An ordered list of values. In most languages, this is realized as an array, vector, list, or sequence.
//
//    Source: https://www.json.org
//


public struct JSON {
    
    ///Returns an empty Object - [:]
    public static let emptyObject: JSON = [:]
    
    ///Returns an empty Array - []
    public static let emptyArray: JSON = []
    
    ///Returns an empty Object - [:]
    public static let empty: JSON = emptyObject
    
    
    public typealias Array = [JSONValue]
    public typealias Object = [String: JSONValue]
    
    
    private var object: Object?
    private var array: Array?
    
    
    public init?(validateObject object: [String: Any]) {
        var validJson = [String: JSONValue]()
        for (key, value) in object {
            let value_ = JSONValue(value)
            guard value_.isValid else {
                print("Value ('\(value)') for Key ('\(key)') is invalid JSON Value format.")
                return nil
            }
            validJson[key] = value_
        }
        
        self.object = validJson
        self.array = nil
    }
    
    public init?(validateArray array: [Any?]) {
        var validJson = [JSONValue]()
        for (index, value) in array.enumerated() {
            let value_ = JSONValue(value)
            guard value_.isValid else {
                print("Value ('\(value ?? "nil")') at Indexx ('\(index)') is invalid JSON Value format.")
                return nil
            }
            validJson.append(value_)
        }
        
        self.object = nil
        self.array = validJson
    }
    
    public init(_ object: [String: Any]) {
        self.object = object.mapValues { JSONValue($0) }
        self.array = nil
    }
    
    public init(_ array: [Any?]) {
        self.object = nil
        self.array = array.map { JSONValue($0) }
    }
    
    public init?(jsonString string: String?) {
        guard let string = string else { return nil }
        guard let data = string.data(using: .utf8) else { return nil }
        self.init(data: data)
    }
    
    public init?(data: Data?) {
        guard let data = data else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else { return nil }
        self.init(data: json)
    }
    
    public init?(data: Any?) {
        guard let data = data else { return nil }
        switch data {
        case let data_ as Data: self.init(data: data_)
        case let json as [String: Any]: self.init(json)
        case let array as [Any?]: self.init(array)
        default: return nil
        }
    }

    
    ///Prints the JSON in prettyPrint format.
    public func debugPrint() {
        print(getFormattedString(self, format: .pretty))
    }
    
    
    ///Returns the JSONValue in Object, for the corresponding key.
    ///Returns nullObject if JSON is Array or key doesn't exist.
    public subscript(_ key: String) -> JSONValue {
        get {
            return object?[key] ?? JSONValue.nullObject
        }
        set {
            if let _ = object {
                self.object?[key] = newValue
                return
            }
            if array == nil {
                self.object = [:]
                self.object?[key] = newValue
            }
        }
    }
    
    ///Returns the JSONValue in Array, for the corresponding index.
    ///Returns nullObject if JSON is Object or index doesn't exist.
    public subscript(_ index: Int) -> JSONValue {
        get {
            guard let array = array, index < array.count else {
                return JSONValue.nullObject
            }
            return array[index]
        }
        set {
            if let array = array, index < array.count {
                self.array?[index] = newValue
                return
            }
        }
    }
    
    
    ///Returns the JSON as JSONValue.
    public var asJsonValue: JSONValue {
        if let object = self.object {
            return JSONValue(object)
        }
        if let array = self.array {
            return JSONValue(array)
        }
        return .nullObject
    }
    
    ///Returns the JSON as Object ([String: JSONValue]).
    ///Returns nil if JSON is of type Array ([JSONValue]).
    public var asJsonObject: JSON.Object? {
        return object
    }
    
    ///Returns the JSON as Array ([JSONValue]).
    ///Returns nil if JSON is of type Object ([String: JSONValue]).
    public var asJsonArray: JSON.Array? {
        return array
    }
    
    
    ///Returns true if the JSON is of type Object ([String: JSONValue]).
    public var isObject: Bool {
        return object != nil
    }
    
    ///Returns true if the JSON is of type Array ([JSONValue]).
    public var isArray: Bool {
        return array != nil
    }
    
    
    ///Returns the first JSONValue if the JSON if of type Array.
    ///Returns nil if the JSON is of type Object.
    public var first: JSONValue? {
        if let array = array, array.count > 0 {
            return array[0]
        }
        return nil
    }
    
}


extension JSON: ExpressibleByDictionaryLiteral {
    
    public typealias Key = String
    public typealias Value = Any
    
    public init(dictionaryLiteral elements: (JSON.Key, JSON.Value)...) {
        var json: [String: JSONValue] = [:]
        for (key, value) in elements {
            json[key] = JSONValue(value)
        }
        self.object = json
    }
    
}


extension JSON: ExpressibleByArrayLiteral {
    
    public typealias ArrayLiteralElement = Any?
    
    public init(arrayLiteral elements: JSON.ArrayLiteralElement...) {
        self.array = elements.map { JSONValue($0) }
    }
    
}


extension JSON: CustomStringConvertible {
    
    public var description: String {
        return getFormattedString(self)
    }
    
}


extension JSON: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return getFormattedString(self, format: .pretty)
    }
    
}
