//
//  StockTests.swift
//  Ticker365Tests
//
//  Created by EDGARDO AGNO on 17/07/2024.
//

import XCTest
@testable import Stocks365

final class StockTests: XCTestCase {
    
    func testStockInitialization() {
        let line = "AAPL,Apple Inc,150.00,1.50,+1.00%,2.5T"
        let stock = Stock(for: line)
        XCTAssertNotNil(stock)
        XCTAssertEqual(stock?.name, "AAPL")
        XCTAssertEqual(stock?.companyName, "Apple Inc")
        XCTAssertEqual(stock?.price, 150.00)
        XCTAssertEqual(stock?.change, 1.50)
        XCTAssertEqual(stock?.chgPercent, "+1.00%")
        XCTAssertEqual(stock?.mktCap, "2.5T")
    }
    
    func testStockInitializationInvalidData() {
        let line = "Invalid Data"
        let stock = Stock(for: line)
        XCTAssertNil(stock)
    }
}
