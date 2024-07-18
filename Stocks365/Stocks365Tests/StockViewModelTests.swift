//
//  StockViewModelTests.swift
//  Ticker365Tests
//
//  Created by EDGARDO AGNO on 17/07/2024.
//

import XCTest
@testable import Ticker365

final class StockViewModelTests: XCTestCase {
    
    var viewModel: StockViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = StockViewModel()
    }
    
    func testLoadStocks() {
        if let filePath = Bundle(for: type(of: self)).path(forResource: "test-snapshot", ofType: "csv") {
            viewModel.loadStocks(from: filePath)
            XCTAssertEqual(viewModel.numberOfStocks, 4)
        } else {
            XCTFail("CSV file not found")
        }
    }
    
    func testGetStock() {
        let stock = Stock(name: "AAPL", companyName: "Apple Inc", price: 150.00, change: 1.50, chgPercent: "+1.00%", mktCap: "2.5T")
        viewModel.stocks = [stock]
        
        let fetchedStock = viewModel.getStock(at: 0)
        XCTAssertEqual(fetchedStock.name, "AAPL")
    }
    
    func testUpdateStock() {
        let initialStock = Stock(name: "AAPL", companyName: "Apple Inc", price: 150.00, change: 1.50, chgPercent: "+1.00%", mktCap: "2.5T")
        let updatedStock = Stock(name: "", companyName: "", price: 160.00, change: 2.00, chgPercent: "+1.50%", mktCap: "2.6T")
        viewModel.stocks = [initialStock]
        
        viewModel.updateStock(updatedStock, at: 0)
        
        let fetchedStock = viewModel.getStock(at: 0)
        XCTAssertEqual(fetchedStock.name, "AAPL")
        XCTAssertEqual(fetchedStock.companyName, "Apple Inc")
        XCTAssertEqual(fetchedStock.price, 160.00)
        XCTAssertEqual(fetchedStock.change, 2.00)
        XCTAssertEqual(fetchedStock.chgPercent, "+1.50%")
        XCTAssertEqual(fetchedStock.mktCap, "2.6T")
    }
}
