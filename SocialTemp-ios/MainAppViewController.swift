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
    @IBOutlet var chartView: LineChartView!
    var times:[String] = []
    var percentages:[Int] = []
    var polarityCumulative:[Float] = []
    var polarityTweets:[Float] = []
    var polarityYaks:[Float] = []
    
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
        chartView.noDataTextDescription = "Loading..."
        chartView.pinchZoomEnabled = false
        chartView.highlightEnabled = false
        chartView.fitScreen()
        chartView.xAxis.enabled = true
        chartView.rightAxis.enabled = false
        chartView.maxVisibleValueCount = 60
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = true
        chartView.noDataText = ""
        chartView.drawBordersEnabled = false
        chartView.animate(yAxisDuration: 2.0)
        chartGetData()
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
            let polarityCumulativeParse = objects[2] as! [Float]
            let polarityTweetsParse = objects[3] as! [Float]
            let polarityYaksParse = objects[4] as! [Float]
            
            self.times += timesParse
            self.percentages += percentagesParse
            self.polarityCumulative += polarityCumulativeParse
            self.polarityTweets += polarityTweetsParse
            self.polarityYaks += polarityYaksParse
            
            
            var yVals: [ChartDataEntry] = []
            var yValsTweets: [ChartDataEntry] = []
            var yValsYaks: [ChartDataEntry] = []
            
            
            for (index, polarity) in self.polarityCumulative.enumerate() {
                yVals.append(ChartDataEntry(value: Double(polarity), xIndex: index))
            }
            
            for (index, polarity) in self.polarityTweets.enumerate() {
                yValsTweets.append(ChartDataEntry(value: Double(polarity), xIndex: index))
            }
            
            for (index, polarity) in self.polarityYaks.enumerate() {
                yValsYaks.append(ChartDataEntry(value: Double(polarity), xIndex:index))
            }
            
            
            
            let set1 = LineChartDataSet(yVals: yVals, label: "Cumulative Positivity")
            set1.colors = [UIColor.redColor()]
            set1.drawValuesEnabled = false
            set1.drawCubicEnabled = true
            set1.cubicIntensity = 0.2
            set1.drawCirclesEnabled = false
            
            let set2 = LineChartDataSet(yVals: yValsTweets, label: "Tweet Positivity")
            set2.colors = [UIColor.blueColor()]
            set2.drawValuesEnabled = false
            set2.drawCubicEnabled = true
            set2.cubicIntensity = 0.2
            set2.drawCirclesEnabled = false
            
            let set3 = LineChartDataSet(yVals: yValsYaks, label: "YikYak Positivity")
            set3.colors = [UIColor(red:0, green:0.72, blue:0.42, alpha:1)]
            set3.drawValuesEnabled = false
            set3.drawCubicEnabled = true
            set3.cubicIntensity = 0.2
            set3.drawCirclesEnabled = false
            
            let xAxis = self.chartView.xAxis
            let yAxis = self.chartView.leftAxis
            
            yAxis.drawGridLinesEnabled = false
            xAxis.drawGridLinesEnabled = false
            self.chartView.xAxis.labelPosition = .Bottom
            let data = LineChartData(xVals: self.times, dataSets: [set1, set2, set3])
            self.chartView.data = data
            self.view.reloadInputViews()
        }
    }
    
    private func loadInfo() {
        PFCloud.callFunctionInBackground("returnSentiment", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            let objects = response as! NSArray
            self.displayText.text = "Northwestern is feeling " + String(objects[1])
        }
    }
}
