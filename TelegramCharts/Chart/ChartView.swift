//
//  ChartView.swift
//  TelegramCharts
//
//  Created by Konstantin Simakov on 12/03/2019.
//  Copyright © 2019 Konstantin Simakov (simakov.it). All rights reserved.
//

import UIKit

class ChartView: UIView {
    var chartData: ChartData? {
        didSet {
            updateChart()
            updateXAxis()
        }
    }
    var showXAxis = false
    var showYAxis = false
    var showYLines = false
    
    private let linesLayer = CALayer()
    private let xAxisLayer = CALayer()
    private let xAxisHeight: CGFloat = 30
    private let maxXAxisLabels = 6
    private let dateFormatter = DateFormatter()
    
    private var minY: Int = 0
    private var maxY: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.layer.addSublayer(linesLayer)
        self.layer.addSublayer(xAxisLayer)
        
        dateFormatter.dateFormat = "MMM d"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        linesLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - xAxisHeight)
        xAxisLayer.frame = CGRect(x: 0, y: bounds.height - xAxisHeight, width: bounds.width, height: xAxisHeight)
        
        updateChart()
        updateXAxis()
    }
    
    func updateChart() {
        minY = 0
        maxY = 0
        linesLayer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
        
        guard let chartData = chartData else { return }
        let xType = chartData.types.first { (key: String, value: String) -> Bool in
            return value == "x"
        }
        guard let xKey = xType?.key else { return }
        guard let xValues = chartData.columns[xKey] else { return }
        
        let lineTypes = chartData.types.filter { (key: String, value: String) -> Bool in
            return value == "line"
        }
        let lineKeys = Array(lineTypes.keys)
        for lineKey in lineKeys {
            guard let values = chartData.columns[lineKey] else { continue }
            minY = min(minY, values.min() ?? 0)
            maxY = max(maxY, values.max() ?? 0)
        }
        
        var xDelta: CGFloat = 0
        var yDelta: CGFloat = 0
        if xValues.count > 0 {
            xDelta = linesLayer.bounds.width / CGFloat(xValues.count - 1)
        }
        if maxY - minY > 0 {
            yDelta = linesLayer.bounds.height / CGFloat(maxY - minY)
        }
        
        for lineKey in lineKeys {
            guard let colorHex = chartData.colors[lineKey] else { return }
            guard let color = UIColor(hexString: colorHex) else { return }
            guard let values = chartData.columns[lineKey] else { continue }
            
            var xCoordinate: CGFloat = 0
            let path = UIBezierPath()
            
            for value in values {
                let yCoordinate = CGFloat(value - minY) * yDelta
                
                let point = CGPoint(x: xCoordinate, y: yCoordinate)
                if xCoordinate > 0 {
                    path.addLine(to: point)
                }
                else {
                    path.move(to: point)
                }
                
                xCoordinate += xDelta
            }
            
            let lineLayer = CAShapeLayer()
            lineLayer.strokeColor = color.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.path = path.cgPath
            linesLayer.addSublayer(lineLayer)
        }
    }
    
    func updateXAxis() {
        xAxisLayer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
        
        guard let chartData = chartData else { return }
        let xType = chartData.types.first { (key: String, value: String) -> Bool in
            return value == "x"
        }
        guard let xKey = xType?.key else { return }
        guard let xValues = chartData.columns[xKey] else { return }
        
        // Axis line
        let width = xAxisLayer.bounds.size.width
        let color = UIColor.lightGray
        let axisPath = UIBezierPath()
        axisPath.move(to: CGPoint(x: 0, y: 1))
        axisPath.addLine(to: CGPoint(x: width, y: 1))
        
        let axisLineLayer = CAShapeLayer()
        axisLineLayer.strokeColor = color.cgColor
        axisLineLayer.lineWidth = 0.5
        axisLineLayer.fillColor = UIColor.clear.cgColor
        axisLineLayer.path = axisPath.cgPath
        xAxisLayer.addSublayer(axisLineLayer)
        
        // Values
        var xDelta: CGFloat = 0
        if xValues.count > 0 {
            xDelta = linesLayer.bounds.width / CGFloat(xValues.count - 1)
        }
        let xValueIndexDelta = Int(floorf(Float(xValues.count) / Float(maxXAxisLabels - 1)))
        
        let yCoordinate: CGFloat = round(xAxisHeight / 2)
        
        var index = 0
        while index < xValues.count {
            let value = xValues[index]
            let date = Date(timeIntervalSince1970: Double(value))
            let text = dateFormatter.string(from: date)
            
            let xCoordinate = CGFloat(index) * xDelta
            let point = CGPoint(x: round(xCoordinate), y: yCoordinate)
            
            let valueTextLayer = CATextLayer()
            valueTextLayer.contentsScale = UIScreen.main.scale
            valueTextLayer.shouldRasterize = false
            valueTextLayer.foregroundColor = color.cgColor
            valueTextLayer.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
            valueTextLayer.fontSize = 12
            valueTextLayer.string = text
            valueTextLayer.alignmentMode = CATextLayerAlignmentMode.center
            valueTextLayer.allowsFontSubpixelQuantization = true
            valueTextLayer.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: valueTextLayer.preferredFrameSize())
            valueTextLayer.position = point
            xAxisLayer.addSublayer(valueTextLayer)
            
            index += xValueIndexDelta
        }
        
    }

}


extension UIColor {
    convenience init?(hexString: String) {
        let charSet = CharacterSet(charactersIn: "#")
        let hexString = hexString.trimmingCharacters(in: charSet)
        var hex: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&hex)
        self.init(hex: Int32(hex))
    }
    
    convenience init(hex: Int32) {
        let red = CGFloat(UInt8((hex & 0xFF0000) >> 16)) / 255.0
        let green = CGFloat(UInt8((hex & 0x00FF00) >> 8)) / 255.0
        let blue = CGFloat(UInt8(hex & 0x0000FF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
