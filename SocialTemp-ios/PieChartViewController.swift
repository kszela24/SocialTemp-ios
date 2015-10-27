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
    var tally:[Double] = [10.0, 12.0, 43.0, 5.0, 12.0, 21.0, 23.0, 40.0, 50.0, 60.0, 40.0, 23.0, 67.0, 78.0, 98.0, 10.0, 34.0, 70.0, 34.0, 67.0, 90.0, 30.0, 20.0]
    
    private func getTopics() {
        PFCloud.callFunctionInBackground("returnTopics", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            let objects = response as! NSArray
            self.tally = objects[0] as! [Double]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getTopics()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let topics = ["art and entertainment", "automotive and vehicles", "business and industrial",
            "careers", "education", "family and parenting", "finance", "food and drink",
            "health and fitness", "hobbies and interests", "home and garden", "law, govt and politics",
            "news", "pets", "real estate", "religion and spirituality", "science",
            "shopping", "society", "sports", "style and fashion", "technology and computing",
            "travel"]
        setChart(topics, values: self.tally)
        
        
    }
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.centerText = "What NU is Talking About"
        pieChartView.centerTextLineBreakMode = NSLineBreakMode.ByWordWrapping
        pieChartView.descriptionText = "Topics of NU Posts"
        pieChartView.usePercentValuesEnabled = true
        pieChartView.transparentCircleRadiusPercent = 1
        pieChartView.drawSliceTextEnabled = false
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            colors.append(UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1))
        }
        
        pieChartDataSet.colors = colors
        
        
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
