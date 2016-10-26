//
//  AwardPage.swift
//  Hometown App
//
//  Created by David Thurman on 10/25/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class AwardPage: UIViewController {
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var awardNameField: UITextField!
    @IBOutlet var reasonForAwardField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func back(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Main Page") as! MainPageViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func next(_ sender: AnyObject) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "awardSegue" ,
            let nextScene = segue.destination as? AwardResults
        {
            nextScene.firstName = firstNameField.text!
            nextScene.lastName = lastNameField.text!
            nextScene.award = awardNameField.text!
            nextScene.reason = reasonForAwardField.text!
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if firstNameField.text != "",
            lastNameField.text != "",
            awardNameField.text != "",
            reasonForAwardField.text != "" {
            return true
        }
        else {
            return false
        }
    }
}
