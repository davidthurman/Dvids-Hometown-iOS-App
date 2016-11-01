//
//  PromotionPage.swift
//  Hometown App
//
//  Created by David Thurman on 10/25/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class PromotionPage: UIViewController {
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var previousTitleField: UITextField!
    @IBOutlet var newTitleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func next(_ sender: AnyObject) {
    }
    @IBAction func back(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Main Page") as! MainPageViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "promotionSegue" ,
            let nextScene = segue.destination as? PromotionResults
        {
            nextScene.firstName = firstNameField.text!
            nextScene.lastName = lastNameField.text!
            nextScene.previousTitle = previousTitleField.text!
            nextScene.newTitle = newTitleField.text!
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if firstNameField.text != "",
            lastNameField.text != "",
            previousTitleField.text != "",
            newTitleField.text != "" {
            return true
        }
        else {
            return false
        }
    }
}
