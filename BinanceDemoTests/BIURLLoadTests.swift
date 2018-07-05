//
//  BIURLLoadTests.swift
//  BinanceDemoTests
//
//  Created by JayKong on 2018/7/5.
//  Copyright © 2018 EF Education. All rights reserved.
//

import XCTest
@testable import BinanceDemo

class BIURLLoadTests: XCTestCase {
    var datum:Datum!
    var product:BIProduct!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let url = URL(string: "https://www.binance.com/exchange/public/product")
        let data = try! Data(contentsOf: url!)
        let str = String.init(data: data, encoding: .utf8)
        product = BIProduct.init(str!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(product.data[0].quoteAsset.rawValue == "BNB")

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
