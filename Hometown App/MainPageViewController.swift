//
//  MainPageViewController.swift
//  Hometown App
//
//  Created by David Thurman on 10/25/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var eventScroll: UIPickerView!

    var events: [String : [String]] = [:]
    
    @IBOutlet var subeventScroll: UIPickerView!
    
    var pickerData = [""]
    var selectedEvent = "Army Cadet Command"
    var selectedSubevent = "taco"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "http://127.0.0.1:8000/events")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        let json2 = JSON(data: data!)
                        var testDict : [String : [String]] = [:]
                        for x in 0...(json2.count - 1) {
                            var testArray: [String] = []
                            for y in 0...((json2["\(x)"]["sub_events"].count - 1)) {
                                testArray.append(json2["\(x)"]["sub_events"]["\(y)"]["name"].string!)
                            }
                            self.events[json2["\(x)"]["name"].string!] = testArray
                        }
                     
                        self.pickerData = Array(self.events.keys)
                        
                        
                        self.eventScroll.tag = 0
                        self.eventScroll.delegate = self
                        self.eventScroll.dataSource = self
                        
                        self.subeventScroll.tag = 1
                        self.subeventScroll.delegate = self
                        self.subeventScroll.dataSource = self
                        
                        DispatchQueue.main.async {
                            self.eventScroll.reloadAllComponents()
                            self.subeventScroll.reloadAllComponents()
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
        print("1")
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            print("2")
            return pickerData.count
        }
        else {
            print("3")
            return events[selectedEvent]!.count
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
            print("7")
            selectedSubevent = events[selectedEvent]![row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 0 {
            print("8")
            let titleData = pickerData[row]
            var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
            return myTitle
        }
        else {
            print("9")
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
