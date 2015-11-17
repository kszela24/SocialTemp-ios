//
//  PolarityViewController.swift
//  SocialTemp-ios
//
//  Created by Kyle Szela on 11/16/15.
//  Copyright © 2015 Kyle. All rights reserved.
//

import UIKit
import Charts
import Parse

class PolarityViewController: UIViewController {
    @IBOutlet weak var polarityPieChartView: PieChartView!
    var topicTally:[Double] = []
    var topics:[String] = []
    
    private func getTopics() {
        PFCloud.callFunctionInBackground("returnTopics", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            let objects = response as! NSArray
            self.topicTally = objects[2] as! [Double]
            self.topics = objects[1] as! [String]
            self.setPolarityChart(self.topics, values: self.topicTally)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        getTopics()
    }
    
    
    func setPolarityChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count - 1 {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        polarityPieChartView.data = pieChartData
        polarityPieChartView.centerText = "How is NU Feeling?"
        polarityPieChartView.centerTextLineBreakMode = NSLineBreakMode.ByWordWrapping
        polarityPieChartView.descriptionText = "Polarity in NU Posts"
        polarityPieChartView.usePercentValuesEnabled = true
        polarityPieChartView.drawSliceTextEnabled = false
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            colors.append(UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1))
        }
        
        pieChartDataSet.colors = colors
        
        polarityPieChartView.legendRenderer.computeLegend(pieChartData)
        polarityPieChartView.legend.calculatedLabelBreakPoints = [false, false, false, true, false, false]
        polarityPieChartView.legend.neededHeight = 20.0
        
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
