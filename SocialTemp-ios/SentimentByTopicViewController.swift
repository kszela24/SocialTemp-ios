//
//  SentimentByTopicViewController.swift
//  SocialTemp-ios
//
//  Created by Henry Spindell on 11/29/15.
//  Copyright © 2015 Kyle. All rights reserved.
//

import Foundation

//
//  SentimentByTopicViewController.swift
//  SocialTemp-ios
//
//  Created by Henry on 11/29/15.
//  Copyright © 2015 Henry. All rights reserved.
//

import UIKit
import Parse


class SentimentByTopicViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var firstTopicPicker: UIPickerView!
    @IBOutlet weak var secondTopicPicker: UIPickerView!
    @IBOutlet weak var polarityGradientView: UIView!
    @IBOutlet weak var secondTopicMarker: UIView!
    @IBOutlet weak var firstTopicMarker: UIView!
    @IBOutlet weak var firstTopicLabel: UILabel!
    @IBOutlet weak var secondTopicLabel: UILabel!
    @IBOutlet weak var sentimentDifferenceLabel: UILabel!
    
    var averageTopicSentiments = [Float]()
    var topics = [String]()
    var firstSelectedTopic:Int = 0
    var secondSelectedTopic:Int = 1
    
    var minTopicPolarity: Float = 0
    var maxTopicPolarity: Float = 0
    
    var topicSentimentDifference: Float = 0
    
    func scaleWithBounds(value: Float, minimum: Float, maximum: Float) -> Float {
        if value > maximum {
            return 1
        }
        
        if value < minimum {
            return -1
        }
        // assuming all values are within 0.1 to 0.2 range, rescale them to go from -1 to 1
        let c:Float = -1.0
        let d:Float = 1.0
        let a:Float = minimum
        let b:Float = maximum
        return (((d-c)*(value-a)) / (b-a)) + c
    }

    private func getTopics() {
        PFCloud.callFunctionInBackground("returnTopics", withParameters: nil) {
            (response: AnyObject?, error: NSError?) -> Void in
            let objects = response as! NSArray
            
            self.topics = objects[1] as! [String]
            self.topics.removeLast()
            
            let unscaledSentiments = objects[2] as! [Float]
            let minElt = unscaledSentiments.minElement()!
            let maxElt = unscaledSentiments.maxElement()!
            self.averageTopicSentiments = unscaledSentiments.map({ (f) -> Float in
                return self.scaleWithBounds(f, minimum: minElt, maximum: maxElt)
            })
            print(self.topics)
            print(self.averageTopicSentiments)
            
            self.minTopicPolarity = self.averageTopicSentiments.minElement()!
            self.maxTopicPolarity = self.averageTopicSentiments.maxElement()!
            
            self.firstTopicPicker.delegate = self
            self.firstTopicPicker.dataSource = self
            self.secondTopicPicker.delegate = self
            self.secondTopicPicker.dataSource = self
            
            self.secondTopicPicker.selectRow(1, inComponent: 0, animated: false)

            self.updateUI()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sentiment by Topic"
        view.backgroundColor = UIColor(red:0.24, green:0.24, blue:0.25, alpha:1)
        getTopics()
    }
    
    func updateUI() {
        firstTopicLabel.text = "Tweets about \(topics[firstSelectedTopic]) today are"
        secondTopicLabel.text = "than they are about \(topics[secondSelectedTopic])"
        
        
        topicSentimentDifference = (averageTopicSentiments[firstSelectedTopic] - averageTopicSentiments[secondSelectedTopic]) * 50
        
        var relationPhrase = "more"
        
        if topicSentimentDifference >= 0 {
            sentimentDifferenceLabel.textColor = UIColor(red:0, green:0.84, blue:0.4, alpha:1)
        } else if topicSentimentDifference < 0 {
            relationPhrase = "less"
            sentimentDifferenceLabel.textColor = UIColor(red:0.01, green:0.81, blue:1, alpha:1)
        }
        
        sentimentDifferenceLabel.text = "\(String(format: "%.0f", abs(topicSentimentDifference)))% \(relationPhrase) positive"
    }
    
    
    // PickerView delegate methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return topics.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            firstSelectedTopic = row

        } else {
            secondSelectedTopic = row
        }
        
        updateUI()
    }
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: topics[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
    }
    
}
