//
//  HomeScreenViewController.swift
//  Hometown App
//
//  Created by David Thurman on 2/17/17.
//  Copyright © 2017 David Thurman. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("DD")
        print(UserDefaultsKeys.oauthMemberId.intValue)
        print("DD")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
