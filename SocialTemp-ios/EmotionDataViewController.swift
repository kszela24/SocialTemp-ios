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

class EmotionDataViewController: UIViewController, ChartViewDelegate {
    
    
    @IBOutlet weak var numTweetsTodayLabel: UILabel!
    @IBOutlet weak var emotionPieChartView: PieChartView!

    @IBOutlet weak var sampleTweetEmotionLabel: UILabel!
    @IBOutlet weak var sampleTweetBodyLabel: UILabel!
    
    var emotionTally:[Double] = []
    var emotions:[String] = []
    var emotionTweetSamples = [String]()
    var emotionColors = [UIColor]()

    
    private func getEmotions() {
        PFCloud.callFunctionInBackground("returnEmotions", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            let objects = response as! NSArray
            self.emotionTally = objects[0] as! [Double]
            self.emotions = objects[1] as! [String]
            self.setEmotionChart(self.emotions, values: self.emotionTally)
            self.emotionPieChartView.highlightValue(xIndex: 0, dataSetIndex: 0, callDelegate: true)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.24, green:0.24, blue:0.25, alpha:1)
        self.title = "Emotions"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        emotionPieChartView.delegate = self
        
        
        let query = PFQuery(className:"DailyAverage")
        query.orderByDescending("createdAt")
        query.getFirstObjectInBackgroundWithBlock(){
            (dailyAverage: PFObject?, error: NSError?) -> Void in
            if let dailyAvg = dailyAverage,
                emotionSamples = dailyAvg["emotionSamples"] as? [String],
                numTweetsToday = dailyAvg["totalTweetsYaks"] as? Int
                where error == nil {
                    self.emotionTweetSamples = emotionSamples
                    
                    let numberFormatter = NSNumberFormatter()
                    numberFormatter.numberStyle = .DecimalStyle
                    
                    if let formattedNum = numberFormatter.stringFromNumber(numTweetsToday) {
                        self.numTweetsTodayLabel.text = "\(formattedNum) tweets today"
                    }
            } else {
                print(error)
            }
        }

        getEmotions()
    }

    
    func setEmotionChart(dataPoints: [String], values: [Double]) {

        var dataEntries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        emotionPieChartView.data = pieChartData
        emotionPieChartView.centerText = "How is NU feeling?"
        emotionPieChartView.centerTextLineBreakMode = NSLineBreakMode.ByWordWrapping
        emotionPieChartView.descriptionText = "Emotions of NU Posts"
        emotionPieChartView.usePercentValuesEnabled = true
        emotionPieChartView.drawSliceTextEnabled = false
        emotionPieChartView.descriptionTextColor = UIColor.whiteColor()
        emotionPieChartView.legend.textColor = UIColor.whiteColor()
        emotionPieChartView.backgroundColor = UIColor.darkGrayColor()


        pieChartDataSet.colors = [UIColor(red: CGFloat(Double(220)/255), green: CGFloat(Double(20)/255), blue: CGFloat(Double(60)/255), alpha: 1),
            UIColor(red: CGFloat(Double(25)/255), green: CGFloat(Double(25)/255), blue: CGFloat(Double(112)/255), alpha: 1),
            UIColor.blueColor(),
            UIColor(red: CGFloat(Double(0)/255), green: CGFloat(Double(128)/255), blue: CGFloat(Double(0)/255), alpha: 1),
            UIColor.yellowColor(),
            UIColor(red: CGFloat(Double(139)/255), green: CGFloat(Double(0)/255), blue: CGFloat(Double(0)/255), alpha: 1),
            UIColor.purpleColor(),
            UIColor(red: CGFloat(Double(138)/255), green: CGFloat(Double(43)/255), blue: CGFloat(Double(226)/255), alpha: 1)]
        
        emotionColors = pieChartDataSet.colors

        emotionPieChartView.legend.textColor = UIColor.whiteColor()

        emotionPieChartView.legendRenderer.computeLegend(pieChartData)
        emotionPieChartView.legend.calculatedLabelBreakPoints = [false, false, false, false, true, false, false]


        emotionPieChartView.legend.neededHeight = 20.0

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        // set topic label color to topicColors[entry.xIndex]

        sampleTweetEmotionLabel.text = "Sample tweet displaying \(emotions[entry.xIndex])"
        sampleTweetEmotionLabel.textColor = emotionColors[entry.xIndex]
        
        if entry.xIndex < emotionTweetSamples.count {
            sampleTweetBodyLabel.text = "@anonymous: \(emotionTweetSamples[entry.xIndex])"
        }
    }
    
    
}