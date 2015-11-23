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
        //polarityBarChartView.data!.removeXValue(0)
        

//        let barChartDataSet2 = BarChartDataSet(yVals: [dataEntries[1]], label: dataPoints[1])
//        let barChartData2 = BarChartData(xVals: [dataPoints[1]], dataSet: barChartDataSet2)
//        polarityBarChartView.data = barChartData2
//        barChartDataSet2.drawValuesEnabled = false
//
//        let barChartDataSet3 = BarChartDataSet(yVals: [dataEntries[2]], label: dataPoints[2])
//        let barChartData3 = BarChartData(xVals: [dataPoints[2]], dataSet: barChartDataSet3)
//        polarityBarChartView.data = barChartData3
//        barChartDataSet3.drawValuesEnabled = false
//        
//        let barChartDataSet4 = BarChartDataSet(yVals: [dataEntries[3]], label: dataPoints[3])
//        let barChartData4 = BarChartData(xVals: [dataPoints[3]], dataSet: barChartDataSet4)
//        polarityBarChartView.data = barChartData4
//        barChartDataSet4.drawValuesEnabled = false
//
//        let barChartDataSet5 = BarChartDataSet(yVals: [dataEntries[4]], label: dataPoints[4])
//        let barChartData5 = BarChartData(xVals: [dataPoints[4]], dataSet: barChartDataSet5)
//        polarityBarChartView.data = barChartData5
//        barChartDataSet5.drawValuesEnabled = false
//        
//        let barChartDataSet6 = BarChartDataSet(yVals: [dataEntries[5]], label: dataPoints[5])
//        let barChartData6 = BarChartData(xVals: [dataPoints[5]], dataSet: barChartDataSet6)
//        polarityBarChartView.data = barChartData6
//        barChartDataSet6.drawValuesEnabled = false
        
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            colors.append(UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1))
        }
        
          barChartDataSet1.colors = colors
//        barChartDataSet2.colors = colors
//        barChartDataSet3.colors = colors
//        barChartDataSet4.colors = colors
//        barChartDataSet5.colors = colors
//        barChartDataSet6.colors = colors
//
//
        polarityBarChartView.legendRenderer.computeLegend(barChartData1)
        polarityBarChartView.legend.setCustom(colors: [colors[0], colors[1], colors[2], colors[3], colors[4], colors[5]], labels: [dataPoints[0], dataPoints[1], dataPoints[2], dataPoints[3], dataPoints[4], dataPoints[5]])
        polarityBarChartView.legend.calculatedLabelBreakPoints = [true, true, true, true, true, true]
        polarityBarChartView.legend.neededHeight = 100.0
        
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
