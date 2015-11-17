//
//  PieChartViewController.swift
//  SocialTemp-ios
//
//  Created by Kyle Szela on 10/23/15.
//  Copyright © 2015 Kyle. All rights reserved.
//

import UIKit
import Charts
import Parse

class PieChartViewController: UIViewController {
    @IBOutlet weak var topicPieChartView: PieChartView!
    @IBOutlet weak var emotionPieChartView: PieChartView!
    var topicTally:[Double] = []
    var topics:[String] = []
    var emotionTally:[Double] = []
    var emotions:[String] = []
    private func getTopics() {
        PFCloud.callFunctionInBackground("returnTopics", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            let objects = response as! NSArray
            self.topicTally = objects[0] as! [Double]
            self.topics = objects[1] as! [String]
            self.setTopicChart(self.topics, values: self.topicTally)
        }
    }
    private func getEmotions() {
        PFCloud.callFunctionInBackground("returnEmotions", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            let objects = response as! NSArray
            self.emotionTally = objects[0] as! [Double]
            self.emotions = objects[1] as! [String]
            self.setEmotionChart(self.emotions, values: self.emotionTally)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.24, green:0.24, blue:0.25, alpha:1)
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        getTopics()
        getEmotions()
        
    }
    
    func setTopicChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        topicPieChartView.data = pieChartData
        topicPieChartView.centerText = "What is NU Talking About?"
        topicPieChartView.centerTextLineBreakMode = NSLineBreakMode.ByWordWrapping
        topicPieChartView.descriptionText = "Topics of NU Posts"
        topicPieChartView.usePercentValuesEnabled = true
        topicPieChartView.drawSliceTextEnabled = false
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            colors.append(UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1))
        }
       
        pieChartDataSet.colors = colors
        
        topicPieChartView.legend.textColor = UIColor.whiteColor()
        topicPieChartView.descriptionTextColor = UIColor.whiteColor()
        topicPieChartView.legendRenderer.computeLegend(pieChartData)
        topicPieChartView.legend.calculatedLabelBreakPoints = [false, false, false, true, false, false]
        topicPieChartView.legend.neededHeight = 20.0
        
    }
    
    func setEmotionChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataEntries, dataSet: pieChartDataSet)
        emotionPieChartView.data = pieChartData
        emotionPieChartView.centerText = "How is NU Feeling?"
        emotionPieChartView.centerTextLineBreakMode = NSLineBreakMode.ByWordWrapping
        emotionPieChartView.descriptionTextColor = UIColor.whiteColor()
        emotionPieChartView.descriptionText = "Emotions in NU Posts"
        emotionPieChartView.usePercentValuesEnabled = true
        emotionPieChartView.drawSliceTextEnabled = false
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            colors.append(UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1))
        }
        
        pieChartDataSet.colors = colors
        
        emotionPieChartView.legend.textColor = UIColor.whiteColor()
        
        emotionPieChartView.legendRenderer.computeLegend(pieChartData)
        emotionPieChartView.legend.neededHeight = 20.0
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
