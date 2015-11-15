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
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var radarChartView: RadarChartView!
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
            self.setPieChart(self.topics, values: self.topicTally)
        }
    }
//    private func getEmotions() {
//        PFCloud.callFunctionInBackground("returnEmotions", withParameters: nil) {
//            (response: AnyObject?, error: NSError?) -> Void in
//            let objects = response as! NSArray
//            self.emotionTally = objects[0] as! [Double]
//            self.emotions = objects[1] as! [String]
//            self.setRadarChart(self.emotions, values: self.emotionTally)
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.24, green:0.24, blue:0.25, alpha:1)
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        getTopics()
        //getEmotions()
        let emotionTally1 = [1.0, 5.0, 20.0, 15.0, 7.0]
        let emotions1 = ["joy", "sadness", "anger", "fear", "excitment"]
        self.setRadarChart(emotions1, values: emotionTally1)
    }
    
    func setPieChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.centerText = "What is NU Talking About?"
        pieChartView.centerTextLineBreakMode = NSLineBreakMode.ByWordWrapping
        pieChartView.descriptionText = "Topics of NU Posts"
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawSliceTextEnabled = false
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            colors.append(UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1))
        }
       
        pieChartDataSet.colors = colors
        
        pieChartView.legendRenderer.computeLegend(pieChartData)
        pieChartView.legend.calculatedLabelBreakPoints = [false, false, false, true, false, false]
        pieChartView.legend.neededHeight = 20.0
        
    }
    
//    func setRadarChart(dataPoints: [String], values: [Double]) {
//        
//        var dataEntries: [ChartDataEntry] = []
//        
//        for i in 0..<dataPoints.count {
//            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
//            dataEntries.append(dataEntry)
//        }
//        let radarChartDataSet = RadarChartDataSet(yVals: dataEntries, label: "")
//        let radarChartData = RadarChartData(xVals: dataEntries, dataSet: radarChartDataSet)
//        radarChartView.data = radarChartData
//        
//        var colors: [UIColor] = []
//        
//        for _ in 0..<dataPoints.count {
//            let red = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue = Double(arc4random_uniform(256))
//            colors.append(UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1))
//        }
//        
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        
//        // Dispose of any resources that can be recreated.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
