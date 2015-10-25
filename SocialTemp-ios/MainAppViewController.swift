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

class MainAppViewController: UIViewController, ChartViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var trendDirectionBackground: UIView!
    @IBOutlet weak var polarityChangeLabel: UILabel!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet var displayText: UILabel!
    @IBOutlet var chartView: LineChartView!
    var times:[String] = []
    var percentages:[Int] = []
    var polarityCumulative:[Float] = []
    var polarityTweets:[Float] = []
    var polarityYaks:[Float] = []
    var pickerTimes = [String]()
    var polarityChange: Float = 0.0
    var pickerDateIndex:Int = 0
    
    var currentAveragePolarity:Float = 0
    var relativeSentiments = [Float]()
    
    override func viewDidLoad() {
        loadInfo()
        super.viewDidLoad()
        
        //NavBar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 67.0/255.0, green: 31.0/255.0, blue: 129.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "SocialTempNU"
        
        
        getSentimentTrends()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadInfo() {
        PFCloud.callFunctionInBackground("returnSentiment", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            _ = response as! NSArray
        }
    }
    
    private func getSentimentTrends() {
        PFCloud.callFunctionInBackground("returnRelativeSentiment", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            
            
            // what exactly is being returned? percent or something else?
            let objects = response as! NSArray
            let currentAvgPolarity = objects[0] as! Float
            let relativeSentiments = objects[1] as! [Float]
            let times = objects[2] as! [String]
            
            self.currentAveragePolarity = currentAvgPolarity
            self.relativeSentiments = relativeSentiments
            self.pickerTimes = times
            
            self.timePicker.delegate = self
            self.timePicker.dataSource = self
            
            self.pickerDateIndex = 0
            
            self.updateTrendUI()

        }
    }
    
    
    func updateTrendUI() {
        self.polarityChange = self.relativeSentiments[self.pickerDateIndex]
        if self.polarityChange > 0 {
            self.trendDirectionBackground.backgroundColor = UIColor(red:0.27, green:0.62, blue:0.1, alpha:1)
            self.arrowImageView.image = UIImage(named: "arrow_up")
        } else if self.polarityChange < 0 {
            self.trendDirectionBackground.backgroundColor = UIColor.redColor()
            self.arrowImageView.image = UIImage(named: "arrow_down")
        } else {
            self.trendDirectionBackground.backgroundColor = UIColor(red:0.7, green:0.71, blue:0.71, alpha:1)
            self.arrowImageView.image = UIImage(named: "no_change")
        }
        
        self.polarityChangeLabel.text = "\(abs(self.polarityChange))%"
    }
    
    // PickerView delegate methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerTimes[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerTimes.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerDateIndex = row
        updateTrendUI()
    }
    
}
