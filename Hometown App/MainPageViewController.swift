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
    let pickerData = ["Promotion", "Graduation", "Award"]
    var selectedEvent = "Promotion"
    override func viewDidLoad() {
        super.viewDidLoad()
        eventScroll.dataSource = self
        eventScroll.delegate = self        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedEvent = pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        print("1")
        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    
    
    @IBAction func nextPage(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if selectedEvent == "Award"{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Award Page") as! AwardPage
            self.present(nextViewController, animated:true, completion:nil)
        }
        else if selectedEvent == "Graduation"{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Graduation Page") as! GradutationPage
            self.present(nextViewController, animated:true, completion:nil)
        }
        else if selectedEvent == "Promotion" {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Promotion Page") as! PromotionPage
            self.present(nextViewController, animated:true, completion:nil)
        }
    }

}
