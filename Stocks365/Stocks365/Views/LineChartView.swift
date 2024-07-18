//
//  LineChartView.swift
//  Stocks365
//
//  Created by EDGARDO AGNO on 18/07/2024.
//

import UIKit

class LineChartView: UIView {
    
    private var dataPoints: [CGFloat] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
        
    // Add a new data point and keep only the last 5 points
    func addDataPoint(_ value: CGFloat) {
        if dataPoints.count >= 5 {
            dataPoints.removeFirst()
        } else if dataPoints.count == 0 {
            dataPoints = Array(repeating: value, count: 4)
        }
        dataPoints.append(value)
        setNeedsDisplay() // Trigger a redraw
    }
    
    // Override draw method to render the chart
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Clear the view
        context.clear(rect)
        
        // Set up drawing properties
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.systemRed.cgColor)
        
        // Calculate scaling factors
        let maxValue = dataPoints.max() ?? 1
        let minValue = dataPoints.min() ?? 0
        let yScale = rect.height / (maxValue - minValue)
        let xStep = rect.width / CGFloat(max(1, dataPoints.count - 1))
        
        // Draw the data points
        context.beginPath()
        for (index, value) in dataPoints.enumerated() {
            let x = CGFloat(index) * xStep
            let y = rect.height - (value - minValue) * yScale
            if index == 0 {
                context.move(to: CGPoint(x: x, y: y))
            } else {
                context.addLine(to: CGPoint(x: x, y: y))
            }
        }
        context.strokePath()
    }
}
