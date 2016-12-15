//
//  MainPageViewController.swift
//  Hometown App
//
//  Created by David Thurman on 10/25/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var eventScroll: UIPickerView!

    @IBOutlet var subeventLabel: UILabel!
    var events: [String : [String]] = [:]
    
    @IBOutlet var subeventScroll: UIPickerView!
    
    var pickerData = [""]
    var selectedEvent = ""
    var selectedSubevent = ""
    let loadingLabel = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 30))
    
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
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "http://127.0.0.1:8000/events")!
        
        //fetch json from url
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.fetchJson()
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        let json2 = JSON(data: data!)
                        var testDict : [String : [String]] = [:]
                        for x in 0...(json2.count - 1) {
                            var testArray: [String] = []
                            for y in 0...((json2["\(x)"]["sub_events"].count - 1)) {
                                if x == 0 && y == 0 {
                                }
                                testArray.append(json2["\(x)"]["sub_events"]["\(y)"]["name"].string!)
                            }
                            self.events[json2["\(x)"]["name"].string!] = testArray
                            if x == 0 {
                                
                                self.selectedEvent = json2["\(x)"]["name"].string!
                            }
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
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return pickerData.count
        }
        else {
            if let x = events[selectedEvent]?.count {
                
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
            return events[selectedEvent]![row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            selectedEvent = pickerData[row]
            selectedSubevent = events[selectedEvent]![0]
            subeventScroll.reloadAllComponents()
        }
        else {
            selectedSubevent = events[selectedEvent]![row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 0 {
            let titleData = pickerData[row]
            var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
        }
        else {
            let titleData = events[selectedEvent]![row]
            var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
        }
    }
    
    
    
    @IBAction func nextPage(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Event Info Form") as! EventInfoForm
        self.present(nextViewController, animated:true, completion:nil)
    }

}
