//
//  ChartsDataProvider.swift
//  TelegramCharts
//
//  Created by Konstantin Simakov on 12/03/2019.
//  Copyright © 2019 Konstantin Simakov (simakov.it). All rights reserved.
//

import Foundation

class ChartsDataProvider: NSObject {
    var chartsData = [ChartData]()
    
    func load(chartsJson: [Any]) {
        chartsData.removeAll()
        for item in chartsJson {
            if let item = item as? [String: Any] {
                let chartData = ChartData(json: item)
                chartsData.append(chartData)
            }
        }
    }
}
