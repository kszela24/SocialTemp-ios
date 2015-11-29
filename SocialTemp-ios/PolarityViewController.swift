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
    @IBOutlet weak var polarityBarChartView: BarChartView!
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
        view.backgroundColor = UIColor(red:0.24, green:0.24, blue:0.25, alpha:1)

        getTopics()
    }
    
    
    func setPolarityChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count - 1 {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let barChartDataSet1 = BarChartDataSet(yVals: dataEntries, label: "")
        let barChartData1 = BarChartData(xVals: dataPoints, dataSet: barChartDataSet1)
        polarityBarChartView.data = barChartData1
        barChartDataSet1.drawValuesEnabled = false
        polarityBarChartView.descriptionText.removeAll()
        polarityBarChartView.xAxis.drawLabelsEnabled = false
        
        barChartDataSet1.colors = [UIColor(red: CGFloat(Double(220)/255), green: CGFloat(Double(20)/255), blue: CGFloat(Double(60)/255), alpha: 1),
            UIColor(red: CGFloat(Double(25)/255), green: CGFloat(Double(25)/255), blue: CGFloat(Double(112)/255), alpha: 1),
            UIColor.blueColor(),
            UIColor(red: CGFloat(Double(0)/255), green: CGFloat(Double(128)/255), blue: CGFloat(Double(0)/255), alpha: 1),
            UIColor.yellowColor(),
            UIColor(red: CGFloat(Double(139)/255), green: CGFloat(Double(0)/255), blue: CGFloat(Double(0)/255), alpha: 1),
            UIColor.purpleColor(),
            UIColor(red: CGFloat(Double(138)/255), green: CGFloat(Double(43)/255), blue: CGFloat(Double(226)/255), alpha: 1)]
        
        let colors = barChartDataSet1.colors
        polarityBarChartView.legendRenderer.computeLegend(barChartData1)
        polarityBarChartView.legend.setCustom(colors: [colors[0], colors[1], colors[2], colors[3], colors[4], colors[5]], labels: [dataPoints[0], dataPoints[1], dataPoints[2], dataPoints[3], dataPoints[4], dataPoints[5]])
        polarityBarChartView.legend.calculatedLabelBreakPoints = [true, true, true, true, true, true]
        polarityBarChartView.legend.neededHeight = 100.0
        polarityBarChartView.legend.textColor = UIColor.whiteColor()
        
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
