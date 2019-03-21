//
//  ChartData.swift
//  TelegramCharts
//
//  Created by Konstantin Simakov on 12/03/2019.
//  Copyright © 2019 Konstantin Simakov (simakov.it). All rights reserved.
//

import UIKit

class ChartData {
    var columns = [String: Array<Int>]()
    var types = [String: String]()
    var names = [String: String]()
    var colors = [String: String]()
    
    init(json: Dictionary<String, Any>) {
        guard let jsonColumns = json["columns"] as? [[Any]] else { return }
        guard let jsonTypes = json["types"] as? [String: String] else { return }
        guard let jsonNames = json["names"] as? [String: String] else { return }
        guard let jsonColors = json["colors"] as? [String: String] else { return }
        
        // Filling columns values
        columns.removeAll()
        for var jsonColumn in jsonColumns {
            if let columnName = jsonColumn.remove(at: 0) as? String, let jsonColumnValues = jsonColumn as? [Int] {
                columns[columnName] = jsonColumnValues
            }
        }
        
        types = jsonTypes
        names = jsonNames
        colors = jsonColors
    }
}
