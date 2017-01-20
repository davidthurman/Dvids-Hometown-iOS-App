//
//  MainPageViewController.swift
//  Hometown App
//
//  Created by David Thurman on 10/25/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit
import Alamofire

class MainPageViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var eventScroll: UIPickerView!

    @IBOutlet var subeventLabel: UILabel!
    var events: [String : [String]] = [:]
    
    @IBOutlet var subeventScroll: UIPickerView!
    
    var pickerData = [""]
    var tempSelectedEvent = ""
    var tempSelectedSubevent = ""
    let loadingLabel = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 30))
    var timeoutTracker = 0
    var tempSlugDict: [String: [String : String]] = [:]
    var tempNameToSlugDict: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventScroll.isHidden = true
        eventLabel.isHidden = true
        subeventScroll.isHidden = true
        subeventLabel.isHidden = true
        nextButton.isEnabled = false
        
        
        loadingLabel.center.x = self.view.center.x
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
        loadingLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.view.addSubview(loadingLabel)
        
        fetchJson()
        
    }
    
    func fetchJson() {
        
        Alamofire.request("http://127.0.0.1:8000/events").responseJSON { response in
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
                print("GGG")
                print(jsonTest)
                for x in 0...(jsonTest.count - 1) {
                    var tempDict: [String : String] = [:]
                    var tempArray: [String] = []
                    for y in 0...((jsonTest["\(x)"]["sub_events"].count - 1)) {
                        tempDict[jsonTest["\(x)"]["sub_events"]["\(y)"]["name"].string!] = jsonTest["\(x)"]["sub_events"]["\(y)"]["slug"].string!
                        if x == 0 && y == 0 {
                            self.tempSelectedSubevent = jsonTest["\(x)"]["sub_events"]["0"]["name"].string!
                        }
                        tempArray.append(jsonTest["\(x)"]["sub_events"]["\(y)"]["name"].string!)
                    }
                    self.tempNameToSlugDict[jsonTest["\(x)"]["name"].string!] = jsonTest["\(x)"]["slug"].string!
                    self.tempSlugDict[jsonTest["\(x)"]["slug"].string!] = tempDict
                    self.events[jsonTest["\(x)"]["name"].string!] = tempArray
                    if x == 0 {
                        self.tempSelectedEvent = jsonTest["\(x)"]["name"].string!
                    }
                    
                    let test = self.events.sorted(by: { $0.0 < $1.0 })
                    var eventArray = [String]()
                    for x in test {
                        self.events[x.key] = x.value
                        eventArray.append(String(x.key))
                    }
                    
                    self.pickerData = eventArray
                    
                    self.eventScroll.tag = 0
                    self.eventScroll.delegate = self
                    self.eventScroll.dataSource = self
                    
                    self.subeventScroll.tag = 1
                    self.subeventScroll.delegate = self
                    self.subeventScroll.dataSource = self
                    
                    DispatchQueue.main.async {
                        self.eventScroll.reloadAllComponents()
                        self.subeventScroll.reloadAllComponents()
                        self.eventScroll.reloadAllComponents()
                        self.loadingLabel.isHidden = true
                        self.eventScroll.isHidden = false
                        self.eventLabel.isHidden = false
                        self.subeventScroll.isHidden = false
                        self.subeventLabel.isHidden = false
                        self.nextButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    func popUp() {
        let alert = UIAlertController(title: "No Connection", message: "Your request was unable to submit. Would you like to retry your submission or cancel?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { action in self.fetchJson()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in self.performSegue(withIdentifier: "cancelSegue", sender: self)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return pickerData.count
        }
        else {
            if let x = events[tempSelectedEvent]?.count {
                
                return x
            }
            else {
                return 0
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return pickerData[row]
        }
        else {
            return events[tempSelectedEvent]![row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            tempSelectedEvent = pickerData[row]
            tempSelectedSubevent = events[tempSelectedEvent]![0]
            subeventScroll.reloadAllComponents()
        }
        else {
            tempSelectedSubevent = events[tempSelectedEvent]![row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 0 {
            let titleData = pickerData[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
        }
        else {
            let titleData = events[tempSelectedEvent]![row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
        }
    }
    
    @IBAction func nextPage(_ sender: AnyObject) {
        selectedEvent = tempNameToSlugDict[tempSelectedEvent]!
        selectedSubevent = tempSlugDict[selectedEvent]![tempSelectedSubevent]!
        print("EVENT: " + selectedEvent)
        print("SUB : " + selectedSubevent)
        var tempDict: [String : String] = [:]
        tempDict["event"] = selectedEvent
        tempDict["sub_event"] = selectedSubevent
        submitInfo["event"] = tempDict
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Event Info Form") as! EventInfoForm
        self.present(nextViewController, animated:true, completion:nil)
    }

}
