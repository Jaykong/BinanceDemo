//
//  BinanceDemoTests.swift
//  BinanceDemoTests
//
//  Created by JayKong on 2018/7/2.
//  Copyright © 2018 EF Education. All rights reserved.
//

import XCTest
@testable import BinanceDemo

class BinanceDemoTests: XCTestCase {
    var datum:Datum!
    var product:BIProduct!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "test", ofType: "json")
       
        let contents = try! String.init(contentsOfFile: path!, encoding: .utf8)
        product = BIProduct(contents)

        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(product.data[0].activeSell == 24879.06)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
