//
//  Stock.swift
//  Ticker365
//
//  Created by EDGARDO AGNO on 16/07/2024.
//

import Foundation

struct Stock {
    let name: String
    let companyName: String
    let price: Double?
    let change: Double?
    let chgPercent: String
    let mktCap: String
    
    init?(for line: String) {
        // This line processing could be a regular expression, though it might be over engineered.
        let columns = line.components(separatedBy: ",")
        
        guard columns.count == 6 else {
            return nil
        }
        self.name = columns[0]
        self.companyName = columns[1]
        self.price = Double(columns[2])
        self.change = Double(columns[3])
        self.chgPercent = columns[4]
        self.mktCap = columns[5].trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(name: String, companyName: String, price: Double?, change: Double?, chgPercent: String, mktCap: String) {
        self.name = name
        self.companyName = companyName
        self.price = price
        self.change = change
        self.chgPercent = chgPercent
        self.mktCap = mktCap
    }
}
