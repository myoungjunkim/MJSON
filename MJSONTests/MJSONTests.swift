//
//  MJSONTests.swift
//  MJSONTests
//
//  Created by MJ Kim on 2016. 9. 10..
//  Copyright © 2016년 Swifter. All rights reserved.
//

import XCTest
@testable import MJSON

class MJSONTests: XCTestCase {
    
    let jData = Data(referencing: NSData(contentsOfFile: Bundle(for: MJSONTests.self).path(forResource: "sample", ofType: "json")!)!)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    enum Enum {
        case a
        case b
        case c
        
        var mjson: MJSON {
            switch self {
            case .a:
                return MJSON("a")
            case .b:
                return MJSON("b")
            case .c:
                return MJSON("c")
            }
        }
    }
    
    func testEqualable() {
        
        let source: [String : MJSON] = [
            "aaa":"AAA",
            "bbb":["BBB":"AAA"],
            "a":[1,2,3],
            "enum":Enum.a.mjson,
            ]
        
        let mjson = MJSON(source)
        let mjson2 = MJSON(source)
        
        XCTAssert(mjson == mjson2)
    }
    
    func testDictionaryInit() {
        
        let dictionary: [AnyHashable : Any] = [
            "title" : "Swift",
            "name" : "MJ",
            "age" : 38,
            "height" : 170,
            ]
        
        do {
            let mjson = try MJSON(any: dictionary)
            let data = try mjson.data()
            _ = try MJSON(data: data)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testIsArray() {
        
        let mjson = MJSON([
            108,109,110,
            ])
        XCTAssert(mjson.isArray)
    }
    
    func testIsDictionary() {
        
        let mjson = MJSON(
            [
                "aaa":"AAA",
                "bbb":["BBB":"AAA"],
                "a":[1,2,3],
                "enum":Enum.a.mjson,
                ]
        )
        XCTAssert(mjson.isDictionary)
    }
    
    func testNext() {
        do {
            let j = try MJSON(data: jData)
            let v = j["a"]["b"][1]
            XCTAssert(v.isNull)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let j = try MJSON(data: jData)
            
            do {
                let v = try j.next("a").next("b").next("c")
                XCTFail()
            } catch {
                print("Success \(error)")
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testImportExport() {
        
        do {
            let j = try MJSON(data: jData)
            let data = try j.data()
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testBack() {
        
        do {
            let j = try MJSON(data: jData)
            let value = try j
                .next("tree1")
                .next("tree2")
                .back()
                .next("tree2")
                .back()
                .back()
                .next("tree1")
                .next("tree2")
                .next("tree3")
                .next(0)
                .next("index")
                .getString()
            
            XCTAssertEqual(value, "myvalue")
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testBuild() {
        var j = MJSON()
        j["number"] = 1234
        j["text"] = "Swifter"
        j["bool"] = true
        j["null"] = MJSON.null
        j["tree1"] = MJSON(
            [
                "tree2" : MJSON(
                    [
                        "tree3" : MJSON(
                            [
                                MJSON(["index" : "myvalue"])
                            ]
                        )
                    ]
                )
            ]
        )
        
        do {
            let data = try j.data(options: .prettyPrinted)
            let text = String(data: data, encoding: .utf8)!
            print(text)
        } catch {
            print(j.source)
            XCTFail("\(error)")
        }
    }
    
    func testJSONWritable() {
        
        var mjson = MJSON()
        
        mjson["String"] = "String"
        mjson["NSString"] = MJSON("NSString" as NSString)
        mjson["Int"] = 64
        mjson["Int8"] = MJSON(8 as Int8)
        mjson["Int16"] = MJSON(16 as Int16)
        mjson["Int32"] = MJSON(32 as Int32)
        mjson["Int64"] = MJSON(64 as Int64)
        
        mjson["UInt"] = MJSON(64 as UInt)
        mjson["UInt8"] = MJSON(8 as UInt8)
        mjson["UInt16"] = MJSON(16 as UInt16)
        mjson["UInt32"] = MJSON(32 as UInt32)
        mjson["UInt64"] = MJSON(64 as UInt64)
        
        mjson["Bool_true"] = true
        mjson["Bool_false"] = false
        
        mjson["Float"] = MJSON(1.0 / 3.0 as Float)
        mjson["Double"] = MJSON(1.0 / 3.0 as Double)
        
        let answer = "{\"UInt8\":8,\"Int32\":32,\"UInt\":64,\"UInt16\":16,\"UInt32\":32,\"Int16\":16,\"Int\":64,\"String\":\"String\",\"Int8\":8,\"UInt64\":64,\"Float\":0.3333333,\"Double\":0.3333333333333333,\"Bool_true\":true,\"Int64\":64,\"Bool_false\":false,\"NSString\":\"NSString\"}"
        let value = String(data: try! mjson.data(), encoding: .utf8)!
        
        XCTAssert(answer == value)
        
    }
   
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
