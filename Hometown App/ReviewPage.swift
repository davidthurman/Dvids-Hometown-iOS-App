//
//  ReviewPage.swift
//  Hometown App
//
//  Created by David Thurman on 11/7/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class ReviewPage: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.backgroundColor = nextButtonColorGreen
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
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
        
        for x in eventInfo{
            var label = UILabel(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
            label.center.x = self.view.center.x
            label.textAlignment = .center
            label.text = x.key
            label.textColor = UIColor(red:255, green:255, blue:255, alpha:1.0)
            label.font = UIFont.boldSystemFont(ofSize: 18.0)
            self.scrollView.addSubview(label)
            heightLength = heightLength + 50
            label = UILabel(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
            label.center.x = self.view.center.x
            label.textAlignment = .center
            if x.value == ""{
                label.text = "(Blank)"
            }
            else {
                label.text = x.value
            }
            label.textColor = UIColor(red:255, green:255, blue:255, alpha:1.0)
            self.scrollView.addSubview(label)
            heightLength = heightLength + 50
        }
        for x in eventOptions {
            var label = UILabel(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
            label.center.x = self.view.center.x
            label.textAlignment = .center
            label.text = x.key
            label.textColor = UIColor(red:255, green:255, blue:255, alpha:1.0)
            label.font = UIFont.boldSystemFont(ofSize: 18.0)
            self.scrollView.addSubview(label)
            heightLength = heightLength + 50
            for y in x.value {
                label = UILabel(frame: CGRect(x: 0, y: heightLength, width: 200, height: 21))
                label.center.x = self.view.center.x
                label.textAlignment = .center
                label.text = "\(y.key) : \(y.value)"
                label.textColor = UIColor(red:255, green:255, blue:255, alpha:1.0)
                self.scrollView.addSubview(label)
                heightLength = heightLength + 50
            }
        }
        for x in eventPictures {
            let eventPicture = UIImageView(image: x.img)
            eventPicture.contentMode = .scaleAspectFit
            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            eventPicture.frame = CGRect(x: 0, y: heightLength, width: Int(screenWidth), height: 200)
            
            self.scrollView.addSubview(eventPicture)
            heightLength = heightLength + 250
            
            
            }
    }
    @IBAction func submit(_ sender: AnyObject) {
        SwiftSpinner.show("Creating New Event")
        
        var tempUserDict: [String : Any] = [:]
        tempUserDict["first_name"] = "david"
        tempUserDict["last_name"] = "thurman"
        tempUserDict["id"] = "123"
        submitInfo["user"] = tempUserDict
        let submitJSON : JSON = JSON(submitInfo)
        print(submitInfo)
        let urlString: String = url + "/profile/123/event"
        
        Alamofire.request(urlString,method: .post, parameters: submitInfo, encoding: JSONEncoding.default)
            .responseJSON { response in
                if response.response == nil {
                    sleep(2)
                    self.submissionFailed()
                }
                else {
                    sleep(2)
                    if eventPictures.count == 0 {
                        self.clearCache()
                        self.submissionSuccess()
                    }
                    else {
                        self.myImageUploadRequest()
                    }
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
    
    func myImageUploadRequest() {
        for x in eventPictures {
            var counter = 0
            
            //This is a video
            if x.vidUrl != nil {
                print(x.vidUrl!)
                var urlString = (String(describing: x.vidUrl!))
                print(urlString)
                //urlString = "file:///Users/davidthurman/Library/Developer/CoreSimulator/Devices/9F84EEFF-7DB8-4BEF-86F1-DC4135BD1F75/data/Containers/Data/Application/F505FBFE-696B-46BB-A197-F9E7EA9D251F/tmp/trim.6920EAB3-BE5F-439C-86FD-8B7ACC617BF4"
                //let test = Bundle.main.url
                let fileURL = Bundle.main.url(forResource: urlString, withExtension: "mov")
                print(fileURL)
                Alamofire.upload(x.vidUrl!, to: url + "/profile/123/event/" + "1" + "/media").responseJSON { response in
                    debugPrint(response)
                    if response.response == nil {
                        self.submissionFailed()
                        print("fail")
                    } else {
                        if x.imgID == eventPictures.last?.imgID {
                            self.clearCache()
                            self.submissionSuccess()
                        }
                        print("pass")
                    }
                
                }
            }
 
            //This is an image
            else {
                let imageData = UIImageJPEGRepresentation(x.img, 1)
                Alamofire.upload(imageData!, to: url + "/profile/123/event/" + "1" + "/media").responseJSON { response in
                    if response.response == nil {
                        counter = counter + 1
                        if counter == 5 {
                            print("Unable to upload media")
                            self.submissionFailed()
                        }
                    }
                    else {
                        if x.imgID == eventPictures.last?.imgID {
                            self.clearCache()
                            self.submissionSuccess()
                        }
                        
                    }
                }
            }

            
            
            
        }
        
    }
    
    func submissionSuccess(){
        SwiftSpinner.hide()
        let alert = UIAlertController(title: "Submission Succeeded", message: "Your submission was successfully received.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in self.returnHome()}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func submissionFailed(){
        SwiftSpinner.hide()
        let alert = UIAlertController(title: "Submission Failed", message: "Your submission was not received.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in self.handleFail()}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleFail(){
        
    }
    
    func returnHome(){
        performSegue(withIdentifier: "submitSegue", sender: nil)
    }
    
    func clearCache(){
        eventOptions = [:]
        eventPictures = []
        submitInfo = [:]
        eventInfo = [:]
        userInfo = [:]
    }
}
