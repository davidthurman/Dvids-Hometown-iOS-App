//
//  Form.swift
//  Hometown App
//
//  Created by David Thurman on 11/2/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit
import Alamofire

class Form: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var nextButton: UIButton!
    var testEvents: [String] = []
    var profileFields: [[String : String]] = []
    let loadingLabel = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 30))
    var timeoutTracker = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        nextButton.isEnabled = false
        
        loadingLabel.center.x = self.view.center.x
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
        loadingLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.scrollView.addSubview(loadingLabel)

        fetchJson()
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func popUp() {
        let alert = UIAlertController(title: "No Connection", message: "Your request was unable to submit. Would you like to retry your submission or cancel?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { action in self.fetchJson()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in self.performSegue(withIdentifier: "cancelSegue", sender: self)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchJson() {
        
        Alamofire.request("http://127.0.0.1:8000/profile/" + String(dvidsId)).responseJSON { response in
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
                for x in jsonTest["fields"] {
                    var tempDict = [String:String]()
                    self.testEvents.append(x.1["machine_name"].string!)
                    tempDict["machine_name"] = x.1["machine_name"].string!
                    tempDict["name"] = x.1["name"].string!
                    tempDict["type"] = x.1["type"].string!
                    tempDict["value"] = x.1["value"].string!
                    tempDict["weight"] = x.1["weight"].string!
                    if tempDict["type"] == "text" {
                        tempDict["placeholder"] = x.1["placeholder"].string!
                    }
                    self.profileFields.append(tempDict)
                }
                self.populate()
                self.loadingLabel.isHidden = true
                self.nextButton.isEnabled = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func populate(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let scrollHeight = (testEvents.count * 50) + (testEvents.count * 75) + 300

        self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollHeight));
        
        var test = 50
        
        let genderControl = UISegmentedControl(frame: CGRect(x: 0, y: test, width: 200, height: 21))
        genderControl.center.x = self.view.center.x
        self.scrollView.addSubview(genderControl)
        
        test = test + 50
        
        var inputDictionary : [Int: String] = [:]
        var count = 1
        for x in profileFields{
            if x["type"] == "text" {
                let label = UILabel(frame: CGRect(x: 0, y: test, width: 200, height: 21))
                label.center.x = self.view.center.x
                label.textAlignment = .center
                label.text = x["placeholder"]
                label.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
                self.scrollView.addSubview(label)
                test = test + 50
                let input = UITextField(frame: CGRect(x: 0, y: test, width: 200, height: 30))
                input.center.x = self.view.center.x
                input.textAlignment = .center
                if x["value"] != nil {
                    input.text = x["value"]!
                } else {
                    input.placeholder = "Enter text here"
                }
                input.font = UIFont.systemFont(ofSize: 15)
                input.borderStyle = UITextBorderStyle.roundedRect
                input.autocorrectionType = UITextAutocorrectionType.no
                input.keyboardType = UIKeyboardType.default
                input.returnKeyType = UIReturnKeyType.done
                input.clearButtonMode = UITextFieldViewMode.whileEditing;
                input.tag = count
                inputDictionary[count] = x["name"]
                self.scrollView.addSubview(input)
                test = test + 75
                count = count + 1
            }
            else if x["type"] == "date" {
                let label = UILabel(frame: CGRect(x: 0, y: test, width: 200, height: 21))
                label.center.x = self.view.center.x
                label.textAlignment = .center
                label.text = x["name"]
                label.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
                self.scrollView.addSubview(label)
                test = test + 50
                
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: test, width: Int(screenWidth), height: 100))
                datePicker.center.x = self.view.center.x
                datePicker.datePickerMode = .date
                datePicker.tag = count
                self.scrollView.addSubview(datePicker)
                test = test + 100
                count = count + 1
            }
            else if x["type"] == "options" {
                
            }
            else if x["type"] == "radio" {
                
            }
            
        }
        
    }

    @IBAction func next(_ sender: AnyObject) {
        for x in 1...testEvents.count {
            if let theLabel = self.view.viewWithTag(x) as? UITextField {
                userInfo[testEvents[x-1]] = theLabel.text!
            }
        
            if let datePicker = self.view.viewWithTag(321) as? UIDatePicker {
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (sender as! UIButton).currentTitle! == "Next" {
            for x in 1...testEvents.count {
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
