//
//  EventInfoForm.swift
//  Hometown App
//
//  Created by David Thurman on 11/3/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class EventInfoForm: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    
    var testEventQuestions = ["Event Name", "Place", "Etc", "New question", "And another", "And this"]
    
    var personalInfo: [String : String] = [:]
    
    //var eventInfo: [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        populate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populate() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        var scrollHeight = (testEventQuestions.count * 50) + (testEventQuestions.count * 75) + 125
        
        self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollHeight));
        
        var heightLength = 50
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
        dateLabel.center.x = self.view.center.x
        dateLabel.textAlignment = .center
        dateLabel.text = "Event Date"
        dateLabel.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
        self.scrollView.addSubview(dateLabel)
        
        heightLength = heightLength + 50
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: heightLength, width: Int(screenWidth), height: 100))
        datePicker.center.x = self.view.center.x
        datePicker.datePickerMode = .date
        datePicker.tag = 321
        self.scrollView.addSubview(datePicker)
        
        heightLength = heightLength + 150
        
        var inputDictionary : [Int: String] = [:]
        var count = 1
        for x in testEventQuestions{
            let label = UILabel(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
            label.center.x = self.view.center.x
            label.textAlignment = .center
            label.text = x
            label.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
            self.scrollView.addSubview(label)
            heightLength = heightLength + 50
            let input = UITextField(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
            input.center.x = self.view.center.x
            input.textAlignment = .center
            if eventInfo != [:] {
                input.text = eventInfo[x]
            }
            else {
                input.placeholder = "Enter text here"
            }
            input.font = UIFont.systemFont(ofSize: 15)
            input.borderStyle = UITextBorderStyle.roundedRect
            input.autocorrectionType = UITextAutocorrectionType.no
            input.keyboardType = UIKeyboardType.default
            input.returnKeyType = UIReturnKeyType.done
            input.clearButtonMode = UITextFieldViewMode.whileEditing;
            input.tag = count
            inputDictionary[count] = x
            self.scrollView.addSubview(input)
            heightLength = heightLength + 50
            count = count + 1
            
        }
    }
    @IBAction func next(_ sender: AnyObject) {
        for x in 1...testEventQuestions.count {
            if let theLabel = self.view.viewWithTag(x) as? UITextField {
                eventInfo[testEventQuestions[x-1]] = theLabel.text!
            }
        }
        if let datePicker = self.view.viewWithTag(321) as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdyyyy")
            var newDate = dateFormatter.string(from: datePicker.date)
            eventInfo["Event Date"] = newDate
        }
        print(eventInfo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (sender as! UIButton).currentTitle! == "Next" {
            for x in 1...eventInfo.count {
                if let theLabel = self.view.viewWithTag(x) as? UITextField {
                    if theLabel.text! == "" {
                        return false
                    }
                }
            }
        }
        return true
        
    }
    
    
}
