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

## Author

Akaash Dev, heatblast.akaash@gmail.com

## License

SwiftJSONi is available under the MIT license. See the LICENSE file for more info.
