//
//  ReviewPage.swift
//  Hometown App
//
//  Created by David Thurman on 11/7/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class ReviewPage: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        populate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func populate() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        var scrollHeight = (eventInfo.count * 100) + 100 + (eventPictures.count * 250)
        self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollHeight));
        
        var heightLength = 50
        
        
        for x in eventInfo{
            var label = UILabel(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
            label.center.x = self.view.center.x
            label.textAlignment = .center
            label.text = x.key
            label.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
            label.font = UIFont.boldSystemFont(ofSize: 18.0)
            self.scrollView.addSubview(label)
            heightLength = heightLength + 50
            label = UILabel(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
            label.center.x = self.view.center.x
            label.textAlignment = .center
            label.text = x.value
            label.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
            self.scrollView.addSubview(label)
            heightLength = heightLength + 50
        }
        for x in eventPictures {
            var eventPicture = UIImageView(image: x.img)
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            eventPicture.frame = CGRect(x: 0, y: heightLength, width: Int(screenWidth), height: 200)
            eventPicture.contentMode = .scaleAspectFit
            self.scrollView.addSubview(eventPicture)
            heightLength = heightLength + 250
        }
    }
}
