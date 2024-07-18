//
//  StockViewModel.swift
//  Ticker365
//
//  Created by EDGARDO AGNO on 16/07/2024.
//

import Foundation

class StockViewModel {
    var stocks: [Stock] = []
    
    var onUpdate: ((_ stock: Stock, _ index: Int, _ isChanged: Bool) -> Void)?
    
    func loadStocks(from filePath: String) {
        if let newStocks = readCSV(filePath: filePath) {
            self.stocks = newStocks
        }
    }
    
    func getStock(at index: Int) -> Stock { stocks[index] }
    
    var numberOfStocks: Int { stocks.count }
}


protocol StockObserving {
    
    var count: Int { get }
    
    func updateStock(_ stock: Stock, at index: Int)
}

extension StockViewModel: StockObserving {
    var count: Int { stocks.count }
    
    func updateStock(_ stock: Stock, at index: Int) {
        guard index < stocks.count else { return }
        let named = stocks[index]
        let isChanged: Bool = stock.price == nil ? false : (named.price != stock.price)
        let merged = named.merge(with: stock)
        stocks[index] = merged
        self.onUpdate?(merged, index, isChanged)
    }
}


fileprivate func readCSV(filePath: String) -> [Stock]? {
    do {
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        var lines = content.components(separatedBy: "\n")
        lines.removeFirst() // Remove header line
        
        var stockList = [Stock]()
        
        for line in lines {
            if let stock = Stock(for: line) {
                stockList.append(stock)
            }
        }
        return stockList
    } catch {
        print("Error reading CSV file: \(error)")
        return nil
    }
}

fileprivate extension Stock {
    func merge(with unnamed: Stock) -> Stock {
        Stock(name: name,
              companyName: companyName,
              price: unnamed.price ?? price,
              change: unnamed.change ?? change,
              chgPercent: unnamed.chgPercent,
              mktCap: unnamed.mktCap)
    }
}
