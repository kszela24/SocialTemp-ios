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
    @IBOutlet weak var todayMarker: UIView!
    @IBOutlet weak var otherDayMarker: UIView!
    @IBOutlet weak var polarityGradientView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var trendDirectionBackground: UIView!
    @IBOutlet weak var polarityChangeLabel: UILabel!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var todayFeelingLabel: UILabel!



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
    
    var otherDayMarkerYConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        loadInfo()
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.24, green:0.24, blue:0.25, alpha:1)
        
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
            self.setSentimentTier()
            
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
        
        otherDayLabel.text = "\(self.pickerTimes[pickerDateIndex])"
        let polarityChangeSinceX = ((self.currentAveragePolarity - self.dailyAveragePolarities[pickerDateIndex]) / 2) * 100
        self.polarityChangeLabel.text = String(format: "%.1f", abs(polarityChangeSinceX)) + "%"
        
    }
    
    func placeGradientMarkers() {
        let gradientHeight = polarityGradientView.frame.height
        
        let todayMarkerYConstraint = NSLayoutConstraint (item: polarityGradientView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: todayMarker,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: gradientHeight/2 + CGFloat(currentAveragePolarity) * gradientHeight/2)
        view.addConstraint(todayMarkerYConstraint)
      
        todayMarker.layer.zPosition = 1
        otherDayMarker.layer.zPosition = 1
        
        otherDayMarkerYConstraint = NSLayoutConstraint (item: polarityGradientView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: otherDayMarker,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: gradientHeight/2 + CGFloat(dailyAveragePolarities[pickerDateIndex]) * gradientHeight/2)
        view.addConstraint(otherDayMarkerYConstraint!)
        
        UILabel.animateWithDuration(1, animations: {
            self.todayMarker.layoutIfNeeded()
            self.otherDayMarker.layoutIfNeeded()
        })
    }
    
    func updateOtherDayMarker() {
        let gradientHeight = polarityGradientView.frame.height
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(1, animations: {
            self.otherDayMarkerYConstraint!.constant = gradientHeight/2 + CGFloat(self.dailyAveragePolarities[self.pickerDateIndex]) * gradientHeight/2
            self.view.layoutIfNeeded()
        })
    
    }
    
    func setSentimentTier() {
        if currentAveragePolarity < -0.75 {
            // set color to blue, "very negative"
        } else if currentAveragePolarity < -0.25 {
            // set color to blue, "negative"
        } else if currentAveragePolarity < 0 {
            // set color to blue, "somewhat negative"
        } else if currentAveragePolarity < 0.25 {
            // set color to green, "somewhat positive"
            todayFeelingLabel.textColor = UIColor(red:0, green:0.84, blue:0.4, alpha:1)
            todayFeelingLabel.text = "Northwestern is feeling slightly positive today."
        } else if currentAveragePolarity < 0.75 {
            // set color to green, "positive"
        } else {
            // set color to green, "very positive today!"
        }
    }
    
    // PickerView delegate methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerTimes.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerDateIndex = row
        updateTrendUI()
        updateOtherDayMarker()
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: self.pickerTimes[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
    }
    
}
