//
//  GraduationPage.swift
//  Hometown App
//
//  Created by David Thurman on 10/25/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class GradutationPage: UIViewController {
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var academyLabel: UITextField!
    @IBOutlet var graduationDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(graduationDate.date)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Main Page") as! MainPageViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func next(_ sender: AnyObject) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "graduationSegue" ,
            let nextScene = segue.destination as? GraduationResults
            {
                var myDate: Date
                myDate = graduationDate.date
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdyyyy")
                var newDate = dateFormatter.string(from: myDate)
                
                nextScene.firstName = firstNameField.text!
                nextScene.lastName = lastNameField.text!
                nextScene.academy = academyLabel.text!
                nextScene.graduationDate = newDate
            }
    }
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if firstNameField.text != "",
            lastNameField.text != "",
            academyLabel.text != "" {
            return true
        }
        else {
            return false
        }
    }
}
