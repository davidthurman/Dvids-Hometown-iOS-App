//
//  ReviewPage.swift
//  Hometown App
//
//  Created by David Thurman on 11/7/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit
import Alamofire

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
        var scrollHeight = (eventInfo.count * 100) +  100 + (eventPictures.count * 250)
        for x in eventOptions {
            scrollHeight = scrollHeight + 50
            for y in x.value {
                scrollHeight = scrollHeight + 50
            }
        }
        self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollHeight));
        
        var heightLength = 50
        print("YYY")
        print(eventOptions)
        print("ZZZ")
        
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
        for x in eventOptions {
            var label = UILabel(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
            label.center.x = self.view.center.x
            label.textAlignment = .center
            label.text = x.key
            label.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
            label.font = UIFont.boldSystemFont(ofSize: 18.0)
            self.scrollView.addSubview(label)
            heightLength = heightLength + 50
            for y in x.value {
                label = UILabel(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
                label.center.x = self.view.center.x
                label.textAlignment = .center
                label.text = "\(y.key) : \(y.value)"
                label.textColor = UIColor(red:0.50, green:0.17, blue:0.16, alpha:1.0)
                self.scrollView.addSubview(label)
                heightLength = heightLength + 50
            }
        }
        for x in eventPictures {
            let eventPicture = UIImageView(image: x.img)
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            eventPicture.frame = CGRect(x: 0, y: heightLength, width: Int(screenWidth), height: 200)
            eventPicture.contentMode = .scaleAspectFit
            self.scrollView.addSubview(eventPicture)
            heightLength = heightLength + 250
        }
    }
    @IBAction func submit(_ sender: AnyObject) {
        SwiftSpinner.show("Creating New Event")
        
        var tempUserDict: [String : Any] = [:]
        tempUserDict["first_name"] = "david"
        tempUserDict["last_name"] = "thurman"
        tempUserDict["user_id"] = "123"
        submitInfo["user"] = tempUserDict
        let submitJSON : JSON = JSON(submitInfo)
        print(submitInfo)
        let urlString: String = "http://127.0.0.1:8000/profile/123/event"
        
        Alamofire.request(urlString,method: .post, parameters: submitInfo, encoding: JSONEncoding.default)
            .responseJSON { response in
                if response.response == nil {
                    sleep(2)
                    SwiftSpinner.hide()
                    self.createEventFail()
                }
                else {
                    sleep(2)
                    SwiftSpinner.hide()
                    self.createEventSuccess()
                }
        }
        /*
        SwiftSpinner.hide()
         */
        
 
        /*
        SwiftSpinner.show("Event Created")
        sleep(2)
        SwiftSpinner.hide()
        SwiftSpinner.show("Uploading Media")
        sleep(2)
        SwiftSpinner.hide()
        SwiftSpinner.show("Upload Successful")
        sleep(2)
        SwiftSpinner.hide()
 */
    }
    
    func createEventFail() {
        print("Fail")
    }
    
    func createEventSuccess() {
        print("Success")
        SwiftSpinner.show("Submitting Media")
    }
    
    func myImageUploadRequest() {
        for x in eventPictures {
            let imageData = UIImageJPEGRepresentation(x.img!, 1)
            Alamofire.upload(imageData!, to: "http://localhost:8000/profile/123/event/1" + String(dvidsId) + "/media").responseJSON { response in
                debugPrint(response)
            }
        }
    }
}
