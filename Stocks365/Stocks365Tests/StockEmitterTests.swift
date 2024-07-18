//
//  StockEmitterTests.swift
//  Ticker365Tests
//
//  Created by EDGARDO AGNO on 17/07/2024.
//

import XCTest
@testable import Ticker365

final class StockEmitterTests: XCTestCase {
    var stockEmitter: StockEmitter!
    var mockViewModel: StockViewModel!

    override func setUp() {
        super.setUp()
        
        if let filePath = Bundle(for: type(of: self)).path(forResource: "test-deltas", ofType: "csv") {
            stockEmitter = StockEmitter(filePath: filePath)
        } else {
            XCTFail("CSV file not found")
        }
        
        mockViewModel = StockViewModel()
        if let filePath =  Bundle(for: type(of: self)).path(forResource: "test-snapshot", ofType: "csv") {
            mockViewModel.loadStocks(from: filePath)
        }
    }

    override func tearDown() {
        super.tearDown()
        stockEmitter = nil
    }

    func testStockEmitterEmitsStocks() {
        let expectation1 = expectation(description: "Stock 657.69 updated")
        let expectation2 = expectation(description: "Stock 159.82 updated")
        let expectation3 = expectation(description: "Stock 11.78 updated")
        let expectation4 = expectation(description: "Stock 657.55 updated")
        let expectation5 = expectation(description: "Stock 159.79 updated")

        var expectations = [expectation1, expectation2, expectation3, expectation4, expectation5]

        mockViewModel.onUpdate = { [weak self] (stock, index, isChanged) in

            if !expectations.isEmpty {
                
                if expectations.first == expectation1 {
                    XCTAssertEqual(self?.mockViewModel.stocks[0].price, 657.69)
                    XCTAssertEqual(self?.mockViewModel.stocks[1].price, 160.19)
                    XCTAssertEqual(self?.mockViewModel.stocks[2].price, 11.80)
                    XCTAssertEqual(self?.mockViewModel.stocks[3].price, 13.43)
                } else if expectations.first == expectation2 {
                    XCTAssertEqual(self?.mockViewModel.stocks[0].price, 657.69)
                    XCTAssertEqual(self?.mockViewModel.stocks[1].price, 159.82)
                    XCTAssertEqual(self?.mockViewModel.stocks[2].price, 11.80)
                    XCTAssertEqual(self?.mockViewModel.stocks[3].price, 13.43)
                } else if expectations.first == expectation3 {
                    XCTAssertEqual(self?.mockViewModel.stocks[0].price, 657.69)
                    XCTAssertEqual(self?.mockViewModel.stocks[1].price, 159.82)
                    XCTAssertEqual(self?.mockViewModel.stocks[2].price, 11.78)
                    XCTAssertEqual(self?.mockViewModel.stocks[3].price, 13.43)
                } else if expectations.first == expectation4 {
                    XCTAssertEqual(self?.mockViewModel.stocks[0].price, 657.55)
                    XCTAssertEqual(self?.mockViewModel.stocks[1].price, 159.82)
                    XCTAssertEqual(self?.mockViewModel.stocks[2].price, 11.78)
                    XCTAssertEqual(self?.mockViewModel.stocks[3].price, 13.43)
                } else if expectations.first == expectation5 {
                    XCTAssertEqual(self?.mockViewModel.stocks[0].price, 657.55)
                    XCTAssertEqual(self?.mockViewModel.stocks[1].price, 159.79)
                    XCTAssertEqual(self?.mockViewModel.stocks[2].price, 11.78)
                    XCTAssertEqual(self?.mockViewModel.stocks[3].price, 13.43)
                }
                
                expectations.removeFirst().fulfill()
            }
        }
            
        stockEmitter.start(emittingTo: self.mockViewModel)
        
        waitForExpectations(timeout: 3) { error in
            XCTAssertNil(error, "Test timed out: \(String(describing: error))")
            XCTAssertEqual(self.mockViewModel.stocks.count, 4)
            XCTAssertEqual(self.mockViewModel.stocks[0].name, "GOOG")
            XCTAssertEqual(self.mockViewModel.stocks[1].name, "BIDU")
            XCTAssertEqual(self.mockViewModel.stocks[2].name, "YNDX")
            XCTAssertEqual(self.mockViewModel.stocks[3].name, "BCOR")
            
            XCTAssertEqual(self.mockViewModel.stocks[0].price, 657.55)
            XCTAssertEqual(self.mockViewModel.stocks[1].price, 159.79)
            XCTAssertEqual(self.mockViewModel.stocks[2].price, 11.78)
            XCTAssertEqual(self.mockViewModel.stocks[3].price, 13.43)
        }
    }
}
