//
//  StockEmitter.swift
//  Ticker365
//
//  Created by EDGARDO AGNO on 17/07/2024.
//

import Foundation

class StockEmitter {
    private let filePath: String
    private var currentIndex: Int = 0
    private var lines: [String] = []

    init(filePath: String) {
        self.filePath = filePath
        loadFile()
    }

    private func loadFile() {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            lines = content.components(separatedBy: "\n")
        } catch {
            print("Error reading file: \(error)")
        }
    }

    func start(emittingTo observer: StockObserving) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.emitLoop(observer)
        }
    }

    private func emitLoop(_ observer: StockObserving) {
        while true {
            guard let line = getNextLine() else {
                loadFile()
                currentIndex = 0
                continue
            }
            
            let index = self.currentIndex % (observer.count + 1) - 1
            
            if let delay = Int(line) {
                usleep(useconds_t(delay * 1000))
            } else if let stock = Stock(for: line) {
                DispatchQueue.main.async {
                    observer.updateStock(stock, at: index)
                }
            }
        }
    }

    private func getNextLine() -> String? {
        guard currentIndex < lines.count else {
            return nil
        }
        let line = lines[currentIndex].trimmingCharacters(in: .whitespacesAndNewlines)
        currentIndex += 1
        return line
    }
}
