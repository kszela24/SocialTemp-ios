//
//  MainAppViewController.swift
//  SocialTemp-ios
//
//  Created by Kyle on 10/9/15.
//  Copyright © 2015 Kyle. All rights reserved.
//

import UIKit
import Parse
import Charts

class MainAppViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet var displayText: UILabel!
    @IBOutlet var chartView: BarChartView!
    var times:[String] = []
    var percentages:[Int] = []
    
    override func viewDidLoad() {
        loadInfo()
        super.viewDidLoad()
        
        //NavBar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 67.0/255.0, green: 31.0/255.0, blue: 129.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "SocialTempNU"
        
        //Chart
        chartView.delegate = self
        chartView.descriptionText = "";
        chartView.noDataTextDescription = "Data will be loaded soon."
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        chartView.maxVisibleValueCount = 60
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.noDataText = ""
        chartView.drawBordersEnabled = false
        chartGetData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func chartGetData() {
        PFCloud.callFunctionInBackground("chartGetData", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            let objects = response as! NSArray
            let percentagesParse = objects[0] as! [Int]
            let timesParse = objects[1] as! [String]
            self.times += timesParse
            self.percentages += percentagesParse
            
            var yVals: [BarChartDataEntry] = []
            
            for (index,percentage) in self.percentages.enumerate() {
                yVals.append(BarChartDataEntry(value: Double(percentage), xIndex: index))
            }
            
            let set1 = BarChartDataSet(yVals: yVals, label: nil)
            set1.barSpace = 0.1
            set1.colors = [UIColor(red: 67.0/255.0, green: 31.0/255.0, blue: 129.0/255.0, alpha: 1)]
            let data = BarChartData(xVals: self.times, dataSet: set1)
            self.chartView.data = data
            self.view.reloadInputViews()
        }
    }
    
    private func loadInfo() {
        PFCloud.callFunctionInBackground("returnSentiment", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            let objects = response as! NSArray
            self.displayText.text = "Northwestern is " + String(objects[0]) + "% " + String(objects[1])
        }
    }
}
