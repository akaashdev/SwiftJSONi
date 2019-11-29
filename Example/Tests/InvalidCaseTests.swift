import XCTest
import SwiftJSONi

class InvalidCaseTests: XCTestCase {
    
    func testInvalidCase1() {
        let invalidExample1 = """
        {"data": { "hello" } }
        """
        
        XCTAssertNil(JSON(jsonString: invalidExample1))
        
        guard let data = invalidExample1.data(using: .utf8) else {
            assertionFailure("String to data conversion failed")
            return
        }
        
        XCTAssertNil(JSON(data: data))
    }
    
    func testInvalidJSONConstructionCase1() {
        let invalidDict: [Int: Any] = [1: "one", 2: "two", 3: ["t", 3.000, "ee"]]
        var invalidJson: JSON = JSON()
        invalidJson["data"] = ["abcd": invalidDict]
        
        XCTAssertFalse(invalidJson["data"]["abcd"].isValidType)
        XCTAssertFalse(invalidJson["data"].isNull)
        
        XCTAssertTrue(invalidJson["data"]["abcd"].isNull)
        XCTAssertTrue(invalidJson["data"]["abcd"].isEmpty)
    }
     
    func testInvalidConversionCase1() {
        let invalidExample2: [String: Any] = [
            "data": [
                "abcd": [
                    1: "hello",
                    2: "world",
                    3: "test"
                ]
            ]
        ]
        
        let invalidJson2 = JSON(invalidExample2)
        XCTAssertNotNil(invalidJson2)
        
        XCTAssertFalse(invalidJson2["data"]["abcd"].isValidType)
        XCTAssertFalse(invalidJson2["data"].isNull)
        
        XCTAssertTrue(invalidJson2["data"]["abcd"].isNull)
        XCTAssertTrue(invalidJson2["data"]["abcd"].isEmpty)
        
        XCTAssertNil(JSON(validateObject: invalidExample2))
    }
     
    func testInvalidConversionCase2() {
        let invalidExample3: [String: Any] = [
            "abcd": [
                1: "hello",
                2: "world",
                3: "test"
            ]
        ]
        let invalidJson3 = JSON(invalidExample3)
        XCTAssertNotNil(invalidJson3)
        
        XCTAssertFalse(invalidJson3["abcd"].isValidType)
        XCTAssertFalse(invalidJson3.isNull)
        
        XCTAssertTrue(invalidJson3["abcd"].isNull)
        XCTAssertTrue(invalidJson3["abcd"].isEmpty)
        
        XCTAssertNil(JSON(validateObject: invalidExample3))
    }
    
}


let bigIntTest = """
                 {
                    "bigInt" : 245094000000017009,
                    "bigIntString" : "245094000000017009"
                 }
                 """
