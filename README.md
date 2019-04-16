# SwiftJSONi

[![CI Status](https://img.shields.io/travis/akaashdev/SwiftJSONi.svg?style=flat)](https://travis-ci.org/akaashdev/SwiftJSONi)
[![Version](https://img.shields.io/cocoapods/v/SwiftJSONi.svg?style=flat)](https://cocoapods.org/pods/SwiftJSONi)
[![License](https://img.shields.io/cocoapods/l/SwiftJSONi.svg?style=flat)](https://cocoapods.org/pods/SwiftJSONi)
[![Platform](https://img.shields.io/cocoapods/p/SwiftJSONi.svg?style=flat)](https://cocoapods.org/pods/SwiftJSONi)


## Why SwiftJSONi?

The traditional way of handling JSON in Swift is so cumbersome and requires many lines of code. For example, consider a JSON response from a API for bakery items,

```
{
    "items": {
        "item": [
            {
                "id": "0001",
                "type": "donut",
                "name": "Cake",
                "ppu": 0.55,
                "batters": {
                "batter": [
                        { "id": "1001", "type": "Regular" },
                        { "id": "1002", "type": "Chocolate" },
                        { "id": "1003", "type": "Blueberry" },
                        { "id": "1004", "type": "Devil's Food" }
                    ]
                },
                "topping": [
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
```

To get the type of 4th topping in first item, the safest Swift code looks like,

```
if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any],
    let items = object["items"] as? [String: Any],
    let item = items["item"] as? [[String: Any]],
    let firstItem = item.first,
    let toppings = firstItem["topping"] as? [[String: Any]],
    toppings.count >= 3,
    let type = toppings[3]["type"] as? String
{
    print(type)
}
```

It involves lots of typecasting and safe index checks due to Swift's strict typecast and array index policies.
To achieve the same with SwiftJSONi, the code looks like,

```
if let json = JSON(data: jsonData),
    let type = json["items"]["item"][0]["topping"][3]["type"].string
{
    print(type)
}
```

That's it!!  It is so safe and readable. No need to worry about type casting and array index checks. It is all done automatically.

## Installation

SwiftJSONi is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftJSONi'
```

## Usage

### Initialization
```
import SwiftJSONi

let data: Data? // Response from API
let json = JSON(data: data) // Returns JSON?

let any: Any? // Value of Any type
let json = JSON(any) // Returns JSON?

let dictionary: [String: Any]
let json = JSON(dictionary) // Returns JSON

let validatedJSON = JSON(validateObject: dictionary) // Returns JSON?   
        // Returns 'nil' when a value for key has unsupported JSON type.
```

### Accessing values

Consider the bakery items JSON in the above example. Accessing the 'id' of first item be like,

```
let firstItem = json["items"]["item"][0] 
let id = firstItem["id"].string
```

Difference between `.string` and `.stringValue` is,

`.string`  - Returns the String value if available else returns nil

`.stringValue` - Returns the String value if available else returns default value i.e "" (empty String)

So, getting the 'ppu' of first item belike,

```
let ppu = firstItem["ppu"].floatValue  
```

### Methods

For String,

| | |
|--|--|
|`string` | Returns the `String` value if available else returns `nil` |
|`stringValue` | Returns the `String` value if available else returns default value i.e "" (empty String) |

For Int,

| | |
|--|--|
|`int` | Returns the `Int` value if available else returns `nil`|
|`intValue` |Returns the `Int` value if available else returns default value i.e `0`|

For Float,

| | |
|--|--|
|`float` | Returns the `Float` value if available else returns `nil`|
|`floatValue` |Returns the `Float` value if available else returns default value i.e `0.0`|

For Double,

| | |
|--|--|
|`double` |Returns the `Double` value if available else returns `nil`|
|`doubleValue` |Returns the `Double` value if available else returns default value i.e `0.0`|

For Bool,

| | |
|--|--|
|`bool` |Returns the `Bool` value if available else returns `nil`|
|`boolValue` |Returns the `Bool` value if available else returns default value i.e `false`|

For JSON Object,

| | |
|--|--|
|`jsonObject` |Returns `[String: JSON]?`|
|`jsonObjectValue` |Returns `[String: JSON]` else `[:]`|

For JSON Array,

| | |
|--|--|
|`jsonArray` |Returns `[JSON]?`|
|`jsonArrayValue` |Returns `[JSON]` else `[]`|

For Array,

| | |
|--|--|
|`array` |Returns `[Any?]`|
|`arrayValue` |Returns `[Any?]` else `[]`|

For Dictionary,

| | |
|--|--|
|`dictionary` |Returns `[String: Any]?`|
|`dictionaryValue` |Returns `[String: Any]` else `[:]`|

### Type Checks

Since JSON is a custom type, typecasting it to primitive types always fails,
i.e,  
```
let name = json["name"] as? String  // Always fails.
```
So is, 
```
if json["name"] is String {  // Condition always fails.
    // Do something
}
```

Hence, SwiftJSONi uses inbuilt properties to check the type of values.
Only these types will be accepted by JSON. Any other user-defined types cannot be used as JSON value.



| | |
|--|--|
|`isNull` | Returns `true` if the value is `nil`.|
| | |
|`isString` | Returns `true` if the value is `String`.|
|`isInt` | Returns `true` if the value is `Int`.|
|`isFloat` | Returns `true` if the value is `Float`.|
|`isDouble` | Returns `true` if the value is `Double`.|
|`isBool` | Returns `true` if the value is `Bool`.|
| | |
|`isJsonObject` | Returns `true` if the value is `[String: JSON]`.|
|`isJsonArray` | Returns `true` if the value is `[JSON]`.|
| | |
|`isArray` | Returns `true` if the value is `[Any?]`.|
|`isDictionary` | Returns `true` if the value is `[String: Any]`.|


So the above situations can be handled as,

```
if json["name"].isString {
    // Do something
}
```

### Debugging

`debugPrint()` is used to pretty print the JSON in console.
`description` is the valid JSON String for the corresponding JSON.


## Author

Akaash Dev, heatblast.akaash@gmail.com

## License

SwiftJSONi is available under the MIT license. See the LICENSE file for more info.
