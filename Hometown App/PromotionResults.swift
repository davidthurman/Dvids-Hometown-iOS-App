//
//  PromotionResults.swift
//  Hometown App
//
//  Created by David Thurman on 10/27/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class PromotionResults: UIViewController {
    var firstName = ""
    var lastName = ""
    var previousTitle = ""
    var newTitle = ""
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var previousTitleLabel: UILabel!
    @IBOutlet var newTitleLabel: UILabel!
    @IBOutlet var userPicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameLabel.text = firstName
        lastNameLabel.text = lastName
        previousTitleLabel.text = previousTitle
        newTitleLabel.text = newTitle
        userPicture.image = userImage
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
