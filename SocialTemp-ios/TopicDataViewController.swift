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

class TopicDataViewController: UIViewController, ChartViewDelegate {


    @IBOutlet weak var numTweetsTodayLabel: UILabel!
    @IBOutlet weak var sampleTweetTopicLabel: UILabel!
    @IBOutlet weak var sampleTweetBodyLabel: UILabel!
    
    @IBOutlet weak var topicPieChartView: PieChartView!

//    var topicTally:[Double] = []
//    var topics:[String] = []
    var topicTweetSamples = [String]()
    
    var topicFrequencies = [Double]()
    var topTopicsIndices = [Int]()
    var otherCount:Double = 0
    var topicColors = [UIColor]()
    
    
    let topics = ["Entertainment", "Automotive", "Business",
        "Careers", "Education", "Family", "Finance", "Food",
        "Health", "Hobbies and Interests", "Home and Garden", "Law, Govt and Politics",
        "News", "Pets", "Real Estate", "Religion and Spirituality", "Science",
        "Shopping", "Society", "Sports", "Fashion", "Technology",
        "Travel"]

    
    private func getTopics() {
        PFCloud.callFunctionInBackground("returnTopics", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            let objects = response as! NSArray
//            self.topicTally = objects[0] as! [Double]
//            self.topics = objects[1] as! [String]
            self.topTopicsIndices = objects[3] as! [Int]
            self.otherCount = objects[4] as! Double
            self.topicFrequencies = objects[5] as! [Double]
            
            
            var topTopics = [String]()
            var topFrequencies = [Double]()
            for idx in self.topTopicsIndices[0..<6] {
                topTopics.append(self.topics[idx])
                topFrequencies.append(self.topicFrequencies[idx])
            }
            topTopics.append("Other")
            topFrequencies.append(self.otherCount)
            
            self.setTopicChart(topTopics, values: topFrequencies)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.24, green:0.24, blue:0.25, alpha:1)
        self.title = "Topics"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        topicPieChartView.delegate = self
        
        
        
        let query = PFQuery(className:"DailyAverage")
        query.orderByDescending("createdAt")
        query.getFirstObjectInBackgroundWithBlock(){
            (dailyAverage: PFObject?, error: NSError?) -> Void in
            if let dailyAvg = dailyAverage,
            topicSamples = dailyAvg["topicSamples"] as? [String],
            numTweetsToday = dailyAvg["totalTweetsYaks"] as? Int
            where error == nil {
                self.topicTweetSamples = topicSamples
                
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                
                if let formattedNum = numberFormatter.stringFromNumber(numTweetsToday) {
                    self.numTweetsTodayLabel.text = "\(formattedNum) tweets today"
                }
                self.getTopics()
                
            } else {
                print(error)
            }
        }

        
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
        topicPieChartView.descriptionTextColor = UIColor.whiteColor()
        topicPieChartView.legend.textColor = UIColor.whiteColor()
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            colors.append(UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1))
        }
       
        pieChartDataSet.colors = [UIColor(red: CGFloat(Double(220)/255), green: CGFloat(Double(20)/255), blue: CGFloat(Double(60)/255), alpha: 1),
            UIColor(red: CGFloat(Double(25)/255), green: CGFloat(Double(25)/255), blue: CGFloat(Double(112)/255), alpha: 1),
            UIColor.blueColor(),
            UIColor(red: CGFloat(Double(0)/255), green: CGFloat(Double(128)/255), blue: CGFloat(Double(0)/255), alpha: 1),
            UIColor(red:0.91, green:0.85, blue:0.25, alpha:1),
            UIColor(red: CGFloat(Double(139)/255), green: CGFloat(Double(0)/255), blue: CGFloat(Double(0)/255), alpha: 1),
            UIColor.purpleColor(),
            UIColor(red: CGFloat(Double(138)/255), green: CGFloat(Double(43)/255), blue: CGFloat(Double(226)/255), alpha: 1)]
        topicColors = pieChartDataSet.colors
        
        topicPieChartView.legend.textColor = UIColor.whiteColor()
        topicPieChartView.descriptionTextColor = UIColor.whiteColor()
        topicPieChartView.legendRenderer.computeLegend(pieChartData)
        topicPieChartView.legend.calculatedLabelBreakPoints = [false, false, false, true, false, false]
        topicPieChartView.legend.neededHeight = 20.0
        topicPieChartView.backgroundColor = UIColor.darkGrayColor()
        
        topicPieChartView.highlightValue(xIndex: 0, dataSetIndex: 0, callDelegate: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        if entry.xIndex < 6 {
            sampleTweetTopicLabel.text = "Sample tweet about \(topics[topTopicsIndices[entry.xIndex]])"
            sampleTweetTopicLabel.textColor = topicColors[entry.xIndex]
            
            if entry.xIndex < topicTweetSamples.count {
                sampleTweetBodyLabel.text = "@anonymous: \(topicTweetSamples[topTopicsIndices[entry.xIndex]])"
            }
            
        } else if entry.xIndex == 6 {
            sampleTweetTopicLabel.text = "No tweets about Other"
            sampleTweetTopicLabel.textColor = topicColors[entry.xIndex]
            sampleTweetBodyLabel.text = ""
        }
    }
    
    
}
