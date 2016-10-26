//
//  AwardResults.swift
//  Hometown App
//
//  Created by David Thurman on 10/26/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class AwardResults: UIViewController {
    var firstName = ""
    var lastName = ""
    var award = ""
    var reason = ""

    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var awardLabel: UILabel!
    @IBOutlet var reasonLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName
        awardLabel.text = award
        reasonLabel.text = reason
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
