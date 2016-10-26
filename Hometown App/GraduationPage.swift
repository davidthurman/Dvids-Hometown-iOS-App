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
    
}
