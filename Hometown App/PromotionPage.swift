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
}
