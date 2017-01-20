//
//  EventInfoForm.swift
//  Hometown App
//
//  Created by David Thurman on 11/3/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit
import Alamofire

class EventInfoForm: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    
    var eventNames: [String] = []
    
    var personalInfo: [String : String] = [:]
    
    var timeoutTracker = 0
    
    var optionsDict: [String : [String : UISwitch]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        fetchJson()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func popUp() {
        let alert = UIAlertController(title: "No Connection", message: "Your request was unable to submit. Would you like to retry your connection or cancel?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { action in self.fetchJson()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in self.performSegue(withIdentifier: "cancelSegue", sender: self)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchJson(){
        Alamofire.request("http://127.0.0.1:8000/events/\(selectedEvent)/\(selectedSubevent)").responseJSON { response in
            debugPrint(response)
            
            if response.response == nil {
                self.timeoutTracker = self.timeoutTracker + 1
                if self.timeoutTracker == 5 {
                    self.timeoutTracker = 0
                    self.popUp()
                }
                else {
                    sleep(2)
                    self.fetchJson()
                }
            }
            
            if let json = response.result.value {
                let jsonTest = JSON(json)
                var sortedJson: [JSON] = []
                var tempIndex: Int = 0
                while let x = jsonTest["fields"]["\(tempIndex)"]["name"].string {
                    sortedJson.append(jsonTest["fields"]["\(tempIndex)"])
                    tempIndex = tempIndex + 1
                    
                    self.eventNames.append(x)
                }
                var count = 1
                var heightLength = 50
                let screenSize: CGRect = UIScreen.main.bounds
                let screenWidth = screenSize.width
                var inputDictionary : [Int: String] = [:]
                //NEED TO UPDATE HEIGHT
                let scrollHeight = 2000//(self.eventNames.count * 50) + (self.eventNames.count * 75) + 125
                self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollHeight));
                var textIndex = 0
                var sortedByWeight: [String: JSON] = [:]
                for x in jsonTest["fields"] {
                    sortedByWeight[x.1["weight"].string!] = x.1
                }
                for x in sortedJson {
                    let label = UILabel(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
                    label.center.x = self.view.center.x
                    label.textAlignment = .center
                    label.text = x["name"].string!
                    label.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
                    self.scrollView.addSubview(label)
                    heightLength = heightLength + 50
                    
                    if x["type"].string! == "text" {
                        let input = UITextField(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
                        input.center.x = self.view.center.x
                        input.textAlignment = .center
                        if eventInfo != [:] {
                            input.text = eventInfo[x["name"].string!]
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
                        inputDictionary[count] = x["name"].string!
                        self.scrollView.addSubview(input)
                        heightLength = heightLength + 50
                        textIndex = textIndex + 1
                    }
                    if x["type"].string! == "date" {
                        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: heightLength, width: Int(screenWidth), height: 100))
                        datePicker.center.x = self.view.center.x
                        datePicker.datePickerMode = .date
                        datePicker.tag = count
                        self.scrollView.addSubview(datePicker)
                        
                        heightLength = heightLength + 150
                    }
                    if x["type"].string! == "options" {
                        var tempIndex = 1
                        var tempOptionDict: [String : UISwitch] = [:]
                        for y in x["options"]["values"] {
                            
                            let labelPosition = (screenWidth / 2) + 75
                            
                            let label = UILabel(frame: CGRect(x: 310, y: heightLength, width: 200, height: 21))
                            print("QQQ")
                            print(screenWidth)
                            label.center.x = self.view.center.x
                            //label.textAlignment = .center
                            label.text = y.1.string!
                            label.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
                            self.scrollView.addSubview(label)
                            
                            let switchDemo=UISwitch(frame: CGRect(x:Int(labelPosition),y: heightLength, width:Int(screenWidth), height: 50))
                            switchDemo.isOn = true
                            switchDemo.setOn(true, animated: false);
                            switchDemo.tag = count
                            //switchDemo.addTarget(self, action: "switchValueDidChange:", for: .valueChanged);
                            self.scrollView.addSubview(switchDemo);
                            heightLength = heightLength + 50
                            tempOptionDict[y.1.string!] = switchDemo
                            
                            tempIndex = tempIndex + 1
                        }
                        self.optionsDict["\(count)"] = tempOptionDict
                        
                    }
                    if x["type"].string! == "radio" {
                        var radioValues: [String] = []
                        for y in x["options"]["values"] {
                            radioValues.append(y.1.string!)
                        }
                        let radioButtons = UISegmentedControl(items: radioValues)
                        radioButtons.frame = CGRect(x: 0, y: heightLength, width:200, height: 30)
                        radioButtons.selectedSegmentIndex = 0
                        radioButtons.center.x = self.view.center.x
                        radioButtons.tag = count
                        self.scrollView.addSubview(radioButtons)
                        heightLength = heightLength + 50
                    }
                    
                    
                    count = count + 1
                }
            }
        }
    }
    
    @IBAction func next(_ sender: AnyObject) {
        var formDict : [String : Any] = [:]
        for x in 1...eventNames.count {
            var tempFormDict : [String : Any] = [:]
            if let theLabel = self.view.viewWithTag(x) as? UITextField {
                eventInfo[eventNames[x - 1]] = theLabel.text!
                print("TEXT : " + theLabel.text!)
                print("QUESTION : " + eventNames[x-1])
                tempFormDict["type"] = "text"
                tempFormDict["value"] = theLabel.text!
                tempFormDict["name"] = eventNames[x-1]
            }
            else if let chosenDate = self.view.viewWithTag(x) as? UIDatePicker {
                print("DATE")
                print(chosenDate.date)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdyyyy")
                let newDate = dateFormatter.string(from: chosenDate.date)
                eventInfo[eventNames[x - 1]] = String(describing: newDate)
                tempFormDict["type"] = "date"
                tempFormDict["value"] = String(describing: newDate)
                tempFormDict["name"] = eventNames[x-1]
            }
            else if let options = self.view.viewWithTag(x)  as? UISwitch {
                print("OPTIONS123")
                var tempDict: [String : String] = [:]
                var tempOptionDict: [String: String] = [:]
                for y in optionsDict["\(x)"]! {
                    print(y.key)
                    print(y.value.isOn)
                    tempDict[y.key] = String(y.value.isOn)
                    tempOptionDict["\(y.key)"] = String(y.value.isOn)
                }
                tempFormDict["type"] = "options"
                tempFormDict["value"] = tempOptionDict
                tempFormDict["name"] = eventNames[x-1]
                eventOptions[eventNames[x-1]] = tempOptionDict
                
            }
            else if let radio = self.view.viewWithTag(x) as? UISegmentedControl {
                print("RADIO")
                print(radio.selectedSegmentIndex)
                eventInfo[eventNames[x - 1]] = String(radio.selectedSegmentIndex)
                tempFormDict["type"] = "radio"
                tempFormDict["value"] = String(radio.selectedSegmentIndex)
                tempFormDict["name"] = eventNames[x-1]
            }
            formDict["\(x)"] = tempFormDict
        }
        submitInfo["form"] = formDict
        if let datePicker = self.view.viewWithTag(321) as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdyyyy")
            let newDate = dateFormatter.string(from: datePicker.date)
            eventInfo["Event Date"] = newDate
            print("JJJ")
            print(newDate)
        }
    }
    
    func isValidInput(Input:String) -> Bool {
        let RegEx = "\\A\\w{7,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func invalidInput() {
        let alert = UIAlertController(title: "Invalid Input", message: "Your input was invalid.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (sender as! UIButton).currentTitle! == "Next" {
            print(eventInfo)
            print(eventInfo.count)
            for x in 1...eventInfo.count {
                print(x)
                if let theLabel = self.view.viewWithTag(x) as? UITextField {
                    if theLabel.text! == "" {
                        invalidInput()
                        return false
                    }
                   /* if !isValidInput(Input: theLabel.text!) {
                        invalidInput()
                        return false
                    }*/
                }
            }
        }
        return true
        
    }
    
    
}
