//
//  Form.swift
//  Hometown App
//
//  Created by David Thurman on 11/2/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class Form: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var nextButton: UIButton!
    var testEvents: [String] = []
    var profileFields: [[String : String]] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        
        let loadingLabel = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 30))
        loadingLabel.center.x = self.view.center.x
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
        loadingLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.scrollView.addSubview(loadingLabel)

        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "http://127.0.0.1:8000/profile/" + String(dvidsId))!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        let json2 = JSON(data: data!)
                        print("TEST")
                        print(json.count)
                        //print(json)
                        var count: Int = 0
                        var fieldsArray: [String]
                        while json2["fields"]["\(count)"] != nil{
                            var tempDict: [String : String] = [:]
                            self.testEvents.append(json2["fields"]["\(count)"]["machine_name"].string!)
                            tempDict["name"] = json2["fields"]["\(count)"]["name"].string!
                            tempDict["machine_name"] = json2["fields"]["\(count)"]["machine_name"].string!
                            tempDict["type"] = json2["fields"]["\(count)"]["type"].string!
                            tempDict["weight"] = json2["fields"]["\(count)"]["weight"].string!
                            tempDict["placeholder"] = json2["fields"]["\(count)"]["placeholder"].string!
                            tempDict["value"] = json2["fields"]["\(count)"]["value"].string!
                            self.profileFields.append(tempDict)
                            count = count + 1
                        }
                        print(self.profileFields)
                        
                        DispatchQueue.main.async {
                            self.populate()
                            loadingLabel.isHidden = true
                            self.nextButton.isEnabled = true
                        }
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func populate(){
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        var scrollHeight = (testEvents.count * 50) + (testEvents.count * 75) + 300

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
        }
        if let datePicker = self.view.viewWithTag(321) as? UIDatePicker {
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        for x in profileFields {
            
        }
        
        if segue.identifier == "personalSegue" ,
            let nextScene = segue.destination as? PictureViewController
        {
        }
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
