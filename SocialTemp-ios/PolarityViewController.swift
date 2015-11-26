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
        polarityBarChartView.leftAxis.labelTextColor = UIColor.whiteColor()
        polarityBarChartView.rightAxis.drawLabelsEnabled = false
        //polarityBarChartView.lowestVisibleXIndex = -1
        polarityBarChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            colors.append(UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1))
        }
        
          barChartDataSet1.colors = colors

        polarityBarChartView.legendRenderer.computeLegend(barChartData1)
        polarityBarChartView.legend.setCustom(colors: Array(colors[0..<6]), labels: Array(dataPoints[0..<6]))
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
