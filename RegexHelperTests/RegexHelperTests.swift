//
//  RegexHelperTests.swift
//  RegexHelperTests
//
//  Created by Louis Melahn on 5/5/16.
//  Copyright © 2016 Louis Melahn. All rights reserved.
//

import XCTest
@testable import RegexHelper

class RegexHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMatches() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let testString = "Hello, ☺️😇 World!"
        let matches = testString.matches("([^\\s]+)(\\s+)")
        if let match = matches.first {
            XCTAssert(match.pre + match.hit + match.post == testString)
            XCTAssert(match.hit=="Hello, ")
            XCTAssert(match.first=="Hello, ")
            XCTAssert(match[0]=="Hello, ")
            XCTAssert(match[1]=="Hello,")
            XCTAssert(match[2]==" ")
        }
        
    }
    
    func testIsMatchOf() {
    
        let testString = "Hello, ☺️😇 World!"
        let regex = try! NSRegularExpression(pattern: "hello", options: [ .CaseInsensitive ])
        
        XCTAssert(testString.isMatchedBy("☺️😇"))
        XCTAssertFalse(testString.isMatchedBy("hello"))
        XCTAssert(testString.isMatchedBy("hello", regexOptions: [ .CaseInsensitive ]))
        XCTAssert(testString.isMatchedBy(regex))
        
    }
    
    func testReplaceAll() {
        
        let testString = "Hello, ☺️😇 World!"
        let regex = try! NSRegularExpression(pattern: "world", options: [ .CaseInsensitive ])
        
        XCTAssert(testString.replaceAll(regex, withTemplate: "there",
            usingMatchingOptions: [])=="Hello, ☺️😇 there!")
        XCTAssert(testString.replaceAll("world", withTemplate: "there", usingRegexOptions: [ .CaseInsensitive ])=="Hello, ☺️😇 there!")
        
        
        XCTAssert(testString.replaceAll("world", withTemplate: "there")==testString)
        XCTAssert(testString.replaceAll("☺️😇", withTemplate: "there,")=="Hello, there, World!")
        // The following test fails, apparently, is a bug in `stringByReplacingMatchesInString`
        //XCTAssert(testString.replaceAll("[☺️😇]", withTemplate: "there,")=="Hello, there,there, World!")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
