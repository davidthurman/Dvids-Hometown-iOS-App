//
//  GraduationResults.swift
//  Hometown App
//
//  Created by David Thurman on 10/26/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class GraduationResults: UIViewController {
    var firstName = ""
    var lastName = ""
    var academy = ""
    var graduationDate = ""
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var academyLabel: UILabel!
    @IBOutlet var graduationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(firstName)
        print(lastName)
        print(academy)
        print(graduationDate)
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName
        academyLabel.text = academy
        graduationLabel.text = graduationDate
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*@IBAction func back(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Main Page") as! MainPageViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
*/
    
    
}
