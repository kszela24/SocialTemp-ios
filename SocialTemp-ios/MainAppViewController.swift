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
    
    override func viewDidLoad() {
        loadInfo()
        super.viewDidLoad()
        
        //NavBar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 67.0/255.0, green: 31.0/255.0, blue: 129.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "SocialTempNU"
        
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        
        self.polarityChange = -0.69
        self.polarityChangeLabel.text = "\(abs(self.polarityChange))"
        pickerTimes = ["Yesterday", "Last Week"]
        
        if polarityChange > 0 {
            trendDirectionBackground.backgroundColor = UIColor(red:0.27, green:0.62, blue:0.1, alpha:1)
            arrowImageView.image = UIImage(named: "arrow_up")
        } else {
            trendDirectionBackground.backgroundColor = UIColor.redColor()
            arrowImageView.image = UIImage(named: "arrow_down")
        }
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
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerTimes[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerTimes.count
    }
    
}
