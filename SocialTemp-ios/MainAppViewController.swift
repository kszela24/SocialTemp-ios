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
    
    @IBOutlet weak var otherDayLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var polarityGradientView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var trendDirectionBackground: UIView!
    @IBOutlet weak var polarityChangeLabel: UILabel!
    @IBOutlet weak var timePicker: UIPickerView!



    var percentages:[Int] = []
    var polarityCumulative:[Float] = []
    var polarityTweets:[Float] = []
    var polarityYaks:[Float] = []
    var pickerTimes = [String]()
    var polarityChange: Float = 0.0
    var pickerDateIndex:Int = 0
    
    var currentAveragePolarity:Float = 0
    var relativeSentiments = [Float]()
    var dailyAveragePolarities = [Float]()
    
    var otherDayLabelYConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        loadInfo()
        super.viewDidLoad()
        
        //NavBar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 67.0/255.0, green: 31.0/255.0, blue: 129.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "Social Temperature"

        getSentimentTrends()
    }

    override func viewDidAppear(animated: Bool) {
        let topColor = UIColor(red:0.27, green:0.62, blue:0.1, alpha:1).CGColor
        let bottomColor = UIColor(red:0.01, green:0.36, blue:0.69, alpha:1).CGColor

        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.polarityGradientView.bounds
        gradientLayer.colors = [topColor,bottomColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.polarityGradientView.layer.addSublayer(gradientLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadInfo() {
        PFCloud.callFunctionInBackground("returnSentiment", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            _ = response as? NSArray
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
            let dailyAveragePolarities = objects[3] as! [Float]
            
            self.currentAveragePolarity = currentAvgPolarity
            self.relativeSentiments = relativeSentiments
            self.pickerTimes = times
            self.dailyAveragePolarities = dailyAveragePolarities
            
            self.timePicker.delegate = self
            self.timePicker.dataSource = self
            
            self.pickerDateIndex = 0
            
            self.updateTrendUI()
            
            self.placeGradientMarkers()
        }
    }
    
    
    func updateTrendUI() {
        self.polarityChange = self.relativeSentiments[self.pickerDateIndex]
        if self.polarityChange > 0 {
            self.trendDirectionBackground.backgroundColor = UIColor(red:0.27, green:0.62, blue:0.1, alpha:1)
            self.arrowImageView.image = UIImage(named: "arrow_up")
        } else if self.polarityChange < 0 {
            self.trendDirectionBackground.backgroundColor = UIColor(red:0.01, green:0.36, blue:0.69, alpha:1)
            self.arrowImageView.image = UIImage(named: "arrow_down")
        } else {
            self.trendDirectionBackground.backgroundColor = UIColor(red:0.7, green:0.71, blue:0.71, alpha:1)
            self.arrowImageView.image = UIImage(named: "no_change")
        }
        
        otherDayLabel.text = self.pickerTimes[pickerDateIndex]
        self.polarityChangeLabel.text = "\(abs(self.polarityChange))%"
        
    }
    
    func placeGradientMarkers() {
        let gradientHeight = polarityGradientView.frame.height
        
        let todayLabelYConstraint = NSLayoutConstraint (item: polarityGradientView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: todayLabel,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: gradientHeight/2 + CGFloat(currentAveragePolarity) * gradientHeight/2)
        view.addConstraint(todayLabelYConstraint)
        print(currentAveragePolarity)
        print(relativeSentiments)
        print(dailyAveragePolarities)
      
        todayLabel.layer.zPosition = 1
        otherDayLabel.layer.zPosition = 1
        
        otherDayLabelYConstraint = NSLayoutConstraint (item: polarityGradientView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: otherDayLabel,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: gradientHeight/2 + CGFloat(dailyAveragePolarities[pickerDateIndex]) * gradientHeight/2)
        view.addConstraint(otherDayLabelYConstraint!)
        
        UILabel.animateWithDuration(1, animations: {
            self.todayLabel.layoutIfNeeded()
            self.otherDayLabel.layoutIfNeeded()
        })
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
        
        // TODO update other day marker position, update constraint
    }
    
}
