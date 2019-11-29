//
//  ViewController.swift
//  SwiftJSONi
//
//  Created by heatblast.akaash@gmail.com on 11/26/2019.
//  Copyright (c) 2019 heatblast.akaash@gmail.com. All rights reserved.
//

import UIKit
import SwiftJSONi

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = example7.data(using: .utf8)
        
        let directlyFromData = JSON(data: data)
        directlyFromData!.debugPrint()
        
        let any_ = data! as Any
//        let fromAny = JSON(data: any_)
        let fromAny = JSON(validateAny: any_)!
        fromAny.debugPrint()
        
        let dictionary: [String: Any] = ["hello": 234e-1, "array": [1, 0.45, 0.00, nil], "bool": true]
        let json_ = JSON(dictionary)
        json_.debugPrint()
        
        let any = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
        
        let json = JSON(any)
        
        json.debugPrint()
        
        var constructingJson = JSON()
        constructingJson["firstKey"] = 123
        constructingJson["secondKey"] = "yes"
        constructingJson["array"] = [1,"string","c",0.34,true]
        constructingJson.debugPrint()
        
        
        var complexJson = JSON()
        complexJson["data"] = json["items"]
        complexJson.debugPrint()
        
        
        let invalidDict: [Int: Any] = [1: "one", 2: "two", 3: ["t", 3.000, "ee"]]
        var invalidJson: JSON = JSON()
        invalidJson["data"] = ["abcd": invalidDict]
        invalidJson.debugPrint()
        
        let arrayData = arrayExample.data(using: .utf8)!
        let arrayJson = JSON(data: arrayData)!
        arrayJson.debugPrint()
        print(arrayJson.description)
        
//        let plainString = ["hello world"]
//        let data_ = plainString.data(using: .utf8)!
//        print(JSONSerialization.isValidJSONObject(plainString))
        
//        let doubleCheck = "{\"amount\": 9159795.995, \"currency\": \"INR\"}"
//        let doubleDate = doubleCheck.data(using: .utf8)!
//        let doubleAny = try! JSONSerialization.jsonObject(with: doubleDate, options: .allowFragments)
//        let doubleJson = JSON(data: doubleAny)!
//        doubleJson.debugPrint()
        
        
        let doubleCheck = "98.567"
        let doubleData = doubleCheck.data(using: .utf8)!
        JSON(data: doubleData)?.debugPrint()
        print(JSONSerialization.isValidJSONObject(doubleData))

        
        let emojiJson = JSON(jsonString: emojiExample)!
        emojiJson.debugPrint()
        
        
//        let json__ = JSON(jsonString: generalExample)!
//        json__.debugPrint()
        
        let bigIntTest_ = JSON(jsonString: bigIntTest)!
        bigIntTest_.debugPrint()
        
        print("As Int - ", bigIntTest_["bigInt"].intValue)
        print("As Float - ", bigIntTest_["bigInt"].floatValue)
        print("As Double - ", bigIntTest_["bigInt"].doubleValue)
        print("As String - ", bigIntTest_["bigInt"].stringValue)
        
        print("Converted From Double - ", Int(bigIntTest_["bigInt"].doubleValue))
        print("Converted From Float - ", Int(bigIntTest_["bigInt"].floatValue))
        print("Converted From String - ", Int(bigIntTest_["bigInt"].stringValue) ?? -1)
        
        print("Converted To Double - ", Double(bigIntTest_["bigInt"].intValue))
        print("Converted To Float - ", Float(bigIntTest_["bigInt"].intValue))
        print("Converted To Number - ", NSNumber(value: bigIntTest_["bigInt"].intValue))
        
        print("As String - ", bigIntTest_["bigIntString"].stringValue)
        print("Converted To Double - ", bigIntTest_["bigIntString"].doubleValue)
        print("Converted To Float - ", bigIntTest_["bigIntString"].floatValue)
        print("Converted To Int - ", bigIntTest_["bigIntString"].intValue)
        
        let invalidJson_ = JSON(jsonString: invalidExample)
        print("Invalid - ", invalidJson_?.debugDescription ?? "nil")
        
        
        justAnExample()
        
    }
    
    func justAnExample() {
        let jsonData = example8.data(using: .utf8)!
        
        if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments),
            let object = json as? [String: Any],
            let items = object["items"] as? [String: Any],
            let item = items["item"] as? [[String: Any]],
            let firstItem = item.first,
            let toppings = firstItem["topping"] as? [[String: Any]],
            toppings.count >= 3,
            let type = toppings[3]["type"] as? String
        {
            print(type)
        }
        
        if let json = JSON(data: jsonData),
            let type = json["items"]["item"][0]["topping"][3]["type"].string
        {
            print(type)
        }
        
    }


}

let invalidExample = """
{"data": { "hello" } }
"""

let emojiExample = """
{ "face": "😂",
 "face_text": "\\uD83D\\uDE02" }
"""

let arrayExample =
"[1, 2, 4, \"hello \\u2022\", 0.4]"

let generalExample =
"""
{
"string": "hello world",
"number": 1234567890,
"object": {
            "key": "value"
          },
"array": [1, "ecd"],
"boolT": true,
"boolF": false,
"null": null
}
"""

let escapeSequenceExample =
"""
{
"quotation": "\\"",
"backslash": "\\\\",
"forwardslash": "\\/",
"formfeed": "\\f",
"newline": "\\n",
"return": "\\r",
"tabspace": "\\t",
"unicode": "\\u2022"
}
"""

let numberExample = """
                    {
                        "number": 1.314E+1
                    }
                    """

let example1 =  """
                [ 100, 500, 300, 200, 400 ]
                """


let example2 =  """
                [
                {
                "color": "red",
                "value": "#f00"
                },
                {
                "color": "green",
                "value": "#0f0"
                },
                {
                "color": "blue",
                "value": "#00f"
                },
                {
                "color": "cyan",
                "value": "#0ff"
                },
                {
                "color": "magenta",
                "value": "#f0f"
                },
                {
                "color": "yellow",
                "value": "#ff0"
                },
                {
                "color": "black",
                "value": "#000"
                }
                ]
                """


let example3 =  """
                {
                "color": "red",
                "value": "#f00"
                }
                """


let example4 =  """
                {
                "id": "0001",
                "type": "donut",
                "name": "Cake",
                "ppu": 0.55,
                "batters":
                {
                "batter":
                [
                { "id": "1001", "type": "Regular" },
                { "id": "1002", "type": "Chocolate" },
                { "id": "1003", "type": "Blueberry" },
                { "id": "1004", "type": "Devil's Food" }
                ]
                },
                "topping":
                [
                { "id": "5001", "type": "None" },
                { "id": "5002", "type": "Glazed" },
                { "id": "5005", "type": "Sugar" },
                { "id": "5007", "type": "Powdered Sugar" },
                { "id": "5006", "type": "Chocolate with Sprinkles" },
                { "id": "5003", "type": "Chocolate" },
                { "id": "5004", "type": "Maple" }
                ]
                }
                """


let example5 =  """
                [
                {
                "id": "0001",
                "type": "donut",
                "name": "Cake",
                "ppu": 0.55,
                "batters":
                {
                "batter":
                [
                { "id": "1001", "type": "Regular" },
                { "id": "1002", "type": "Chocolate" },
                { "id": "1003", "type": "Blueberry" },
                { "id": "1004", "type": "Devil's Food" }
                ]
                },
                "topping":
                [
                { "id": "5001", "type": "None" },
                { "id": "5002", "type": "Glazed" },
                { "id": "5005", "type": "Sugar" },
                { "id": "5007", "type": "Powdered Sugar" },
                { "id": "5006", "type": "Chocolate with Sprinkles" },
                { "id": "5003", "type": "Chocolate" },
                { "id": "5004", "type": "Maple" }
                ]
                },
                {
                "id": "0002",
                "type": "donut",
                "name": "Raised",
                "ppu": 0.55,
                "batters":
                {
                "batter":
                [
                { "id": "1001", "type": "Regular" }
                ]
                },
                "topping":
                [
                { "id": "5001", "type": "None" },
                { "id": "5002", "type": "Glazed" },
                { "id": "5005", "type": "Sugar" },
                { "id": "5003", "type": "Chocolate" },
                { "id": "5004", "type": "Maple" }
                ]
                },
                {
                "id": "0003",
                "type": "donut",
                "name": "Old Fashioned",
                "ppu": 0.55,
                "batters":
                {
                "batter":
                [
                { "id": "1001", "type": "Regular" },
                { "id": "1002", "type": "Chocolate" }
                ]
                },
                "topping":
                [
                { "id": "5001", "type": "None" },
                { "id": "5002", "type": "Glazed" },
                { "id": "5003", "type": "Chocolate" },
                { "id": "5004", "type": "Maple" }
                ]
                }
                ]
                """


let example6 =  """
                {
                "id": "0001",
                "type": "donut",
                "name": "Cake",
                "image":
                {
                "url": "images/0001.jpg",
                "width": 200,
                "height": 200
                },
                "thumbnail":
                {
                "url": "images/thumbnails/0001.jpg",
                "width": 32,
                "height": 32
                }
                }
                """


let example7 =  """
                {
                "items":
                {
                "item":
                [
                {
                "id": "0001",
                "type": "donut",
                "name": "Cake",
                "ppu": 0.55,
                "batters":
                {
                "batter":
                [
                { "id": "1001", "type": "Regular" },
                { "id": "1002", "type": "Chocolate" },
                { "id": "1003", "type": "Blueberry" },
                { "id": "1004", "type": "Devil's Food" }
                ]
                },
                "topping":
                [
                { "id": "5001", "type": "None" },
                { "id": "5002", "type": "Glazed" },
                { "id": "5005", "type": "Sugar" },
                { "id": "5007", "type": "Powdered Sugar" },
                { "id": "5006", "type": "Chocolate with Sprinkles" },
                { "id": "5003", "type": "Chocolate" },
                { "id": "5004", "type": "Maple" }
                ]
                }
                ]
                }
                }
                """


let example8 =  """
                {
                "items":
                {
                "item":
                [
                {
                "id": "0001",
                "type": "donut",
                "name": "Cake",
                "ppu": 0.55,
                "batters":
                {
                "batter":
                [
                { "id": "1001", "type": "Regular" },
                { "id": "1002", "type": "Chocolate" },
                { "id": "1003", "type": "Blueberry" },
                { "id": "1004", "type": "Devil's Food" }
                ]
                },
                "topping":
                [
                { "id": "5001", "type": "None" },
                { "id": "5002", "type": "Glazed" },
                { "id": "5005", "type": "Sugar" },
                { "id": "5007", "type": "Powdered Sugar" },
                { "id": "5006", "type": "Chocolate with Sprinkles" },
                { "id": "5003", "type": "Chocolate" },
                { "id": "5004", "type": "Maple" }
                ]
                }
                ]
                }
                }
                """


let bigIntTest = """
                 {
                    "bigInt" : 245094000000017009,
                    "bigIntString" : "245094000000017009"
                 }
                 """

