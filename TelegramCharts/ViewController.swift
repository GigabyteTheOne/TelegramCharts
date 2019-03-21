//
//  ViewController.swift
//  TelegramCharts
//
//  Created by Konstantin Simakov on 12/03/2019.
//  Copyright © 2019 Konstantin Simakov (simakov.it). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var chartsDataProvider: ChartsDataProvider
    
    init(chartsDataProvider: ChartsDataProvider) {
        self.chartsDataProvider = chartsDataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with coder is not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Statictics"
        self.view.backgroundColor = UIColor.white
        
        let chartView = ChartView(frame: CGRect.zero)
        self.view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            chartView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            chartView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 300)
            ])
        
        chartView.chartData = chartsDataProvider.chartsData.first
    }

    
}

