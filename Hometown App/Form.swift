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
    
    @IBOutlet var requiredLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var nextButton: UIButton!
    var testEvents: [String] = []
    var profileFields: [[String : String]] = []
    let loadingLabel = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 30))
    var timeoutTracker = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requiredLabel.isHidden = true
        nextButton.backgroundColor = nextButtonColorGray
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        nextButton.isEnabled = false
        loadingLabel.center.x = self.view.center.x
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = UIColor(red:255, green:255, blue:255, alpha:1.0)
        loadingLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.scrollView.addSubview(loadingLabel)

        fetchJson()
    }
    
    func dismissKeyboard() {
        checkIfReadyToSegue()
        view.endEditing(true)
    }
    
    func checkIfReadyToSegue(){
         //Check if all fields are entered. If so, make the Next button green
        var makeGreen = true
        for x in 1...testEvents.count {
            if let theLabel = self.view.viewWithTag(x) as? UITextField {
                if theLabel.text! == "" {
                    makeGreen = false
                }
            }
        }
        if makeGreen {
            nextButton.backgroundColor = nextButtonColorGreen
        } else {
            nextButton.backgroundColor = nextButtonColorGray
        }
    }
    
    func popUp() {
        let alert = UIAlertController(title: "No Connection", message: "Your request was unable to submit. Would you like to retry your submission or cancel?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { action in self.fetchJson()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in self.performSegue(withIdentifier: "cancelSegue", sender: self)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchJson() {
        Alamofire.request(url + "/profile/" + String(dvidsId)).responseJSON { response in
            debugPrint(response)
            if response.response == nil {
                //If there is still no response after 5 calls, present them with popUp()
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
                //Index every field and append to a temporary dictionary. Then add said dictionary to profileFields
                for x in jsonTest["fields"] {
                    var tempDict = [String:String]()
                    self.testEvents.append(x.1["machine_name"].string!)
                    tempDict["machine_name"] = x.1["machine_name"].string!
                    tempDict["name"] = x.1["name"].string!
                    tempDict["type"] = x.1["type"].string!
                    print(x.1)
                    print("ZZ")
                    if let stringValue = x.1["value"].string {
                        tempDict["value"] = stringValue
                    }
                    else {
                        tempDict["value"] = String(x.1["value"].int!)
                    }
                    tempDict["weight"] = x.1["weight"].string!
                    tempDict["required"] = x.1["required"].string!
                    if tempDict["type"] == "text" {
                        tempDict["placeholder"] = x.1["placeholder"].string!
                    }
                    self.profileFields.append(tempDict)
                    //Find out if they have a profile picture. If so save the url
                    if jsonTest["media"]["profile_image"] != false{
                        var userImageUrl = jsonTest["media"]["profile_image"].string!
                        if let filePath = Bundle.main.path(forResource: "imageName", ofType: "jpg"),
                            let image = UIImage(contentsOfFile: userImageUrl) {
                            //imageView.contentMode = .scaleAspectFit
                            userImage = image
                        }
                    }
                    
                }
                self.populate()
                self.loadingLabel.isHidden = true
                self.nextButton.isEnabled = true
                self.requiredLabel.isHidden = false
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
        
        //This will keep track of what height you need to append each UI Element
        var scrollViewHeightIndex = 50
        scrollViewHeightIndex = scrollViewHeightIndex + 50
        
        var inputDictionary : [Int: String] = [:]
        var count = 1
        for x in profileFields{
            if x["type"] == "text" {
                let label = UILabel(frame: CGRect(x: 0, y: scrollViewHeightIndex, width: 200, height: 21))
                if x["required"] == "1"{
                    label.text = x["placeholder"]! + "*"
                }
                else {
                    label.text = x["placeholder"]
                }
                
                label.center.x = self.view.center.x
                label.textAlignment = .center
                label.textColor = UIColor(red:255, green:255, blue:255, alpha:1.0)
                                
                self.scrollView.addSubview(label)
                scrollViewHeightIndex = scrollViewHeightIndex + 50
                let input = UITextField(frame: CGRect(x: 0, y: scrollViewHeightIndex, width: 200, height: 30))
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
                scrollViewHeightIndex = scrollViewHeightIndex + 75
                count = count + 1
            }
            else if x["type"] == "date" {
                let label = UILabel(frame: CGRect(x: 0, y: scrollViewHeightIndex, width: 200, height: 21))
                if x["required"] == "1" {
                    label.text = x["name"]! + "*"
                }
                else {
                    label.text = x["name"]
                }
                label.center.x = self.view.center.x
                label.textAlignment = .center
                
                label.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
                self.scrollView.addSubview(label)
                scrollViewHeightIndex = scrollViewHeightIndex + 50
                
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: scrollViewHeightIndex, width: Int(screenWidth), height: 100))
                datePicker.center.x = self.view.center.x
                datePicker.datePickerMode = .date
                datePicker.tag = count
                self.scrollView.addSubview(datePicker)
                scrollViewHeightIndex = scrollViewHeightIndex + 100
                count = count + 1
            }
            else if x["type"] == "options" {
                
            }
            else if x["type"] == "radio" {
                
            }
            
        }
        checkIfReadyToSegue()
    }

    @IBAction func next(_ sender: AnyObject) {
        for x in 1...testEvents.count {
            if let theLabel = self.view.viewWithTag(x) as? UITextField {
                userInfo[testEvents[x-1]] = theLabel.text!
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //Check if the button pressed was the back button or the Next button (Next button is UIButton while back button is a NavBarItem)
        if sender is UIButton {
            //Make sure every field has info or else do not perform segue
            if (sender as! UIButton).currentTitle! == "Next" {
                for x in 1...testEvents.count {
                    if let theLabel = self.view.viewWithTag(x) as? UITextField {
                        if theLabel.text! == "" {
                            return false
                        }
                    }
                }
            }
        }
        else{
            //clearCache()
            return true
        }
        return true
    }
    /*
    func clearCache(){
        eventOptions = [:]
        eventPictures = []
        submitInfo = [:]
        eventInfo = [:]
        userInfo = [:]
        profileFields = [[:]]
    }
 */
}
