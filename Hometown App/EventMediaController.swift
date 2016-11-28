//
//  EventMediaController.swift
//  Hometown App
//
//  Created by David Thurman on 11/10/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class EventMediaController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    let imageFromSource = UIImagePickerController()
    var scrollHeight: Int = 50
    var pictureHeightIndex: Int = 50
    var scrollViewHeight: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageFromSource.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        populate()
    }
    
    func populate () {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        var scrollHeight = 2000
        scrollViewHeight = eventPictures.count * 250
        self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollViewHeight));
        if eventPictures.count != 0 {
            
            self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollViewHeight));
            for myImage in eventPictures {
                
                var eventPicture = UIImageView(image: myImage.img)
                let screenSize: CGRect = UIScreen.main.bounds
                let screenWidth = screenSize.width 
                eventPicture.frame = CGRect(x: 0, y: pictureHeightIndex, width: Int(screenWidth), height: 200)
                eventPicture.contentMode = .scaleAspectFit
                self.scrollView.addSubview(eventPicture)
 
                
                var myWidth: Float = 0
                
                let imageRatio: Float = Float(myImage.img!.size.width) / Float(myImage.img!.size.height)
                let viewRatio: Float = Float(eventPicture.frame.size.width) / Float(eventPicture.frame.size.height)
                if imageRatio < viewRatio {
                    let scale: Float = Float(eventPicture.frame.size.height) / Float(myImage.img!.size.height)
                    let width: Float = scale * Float(myImage.img!.size.width)
                    var topLeftX: Float = (Float(eventPicture.frame.size.width) - width) * 0.5
                    print(width)
                    print("Please work")
                    myWidth = width
                }
                else {
                    let scale: Float = Float(eventPicture.frame.size.width) / Float(myImage.img!.size.width)
                    let height: Float = scale * Float(myImage.img!.size.height)
                    var topLeftY: Float = (Float(eventPicture.frame.size.height) - height) * 0.5
                }
                
                var testing = Int(screenWidth / 2) + Int(myWidth / 2)
                
                
                print(myImage.img!.size.width)
                print("BOOM")
                let deleteButton = UIButton(frame: CGRect(x:Int(testing - 24), y:pictureHeightIndex, width:25, height:25))
                deleteButton.backgroundColor = .red
                //deleteButton.center = CGPoint(x:0.0, y:0.0)
                deleteButton.setTitle("x", for: .normal)
                deleteButton.addTarget(self, action: #selector(EventMediaController.clickMe), for: UIControlEvents.touchUpInside)
                deleteButton.tag = Int(myImage.imgID!)
                //scrollViewHeight = scrollViewHeight + 100
                pictureHeightIndex = pictureHeightIndex + 250
                self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollViewHeight))
                self.scrollView.addSubview(deleteButton)
                currentTag = currentTag + 1
                
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Next(_ sender: AnyObject) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (sender as! UIButton).currentTitle! == "Next" {
            for x in 1...eventInfo.count {
                if let theLabel = self.view.viewWithTag(x) as? UITextField {
                    if theLabel.text! == "" {
                        return false
                    }
                }
            }
        }
        return true
        
    }
    @IBAction func uploadPhotos(_ sender: AnyObject) {
        imageFromSource.allowsEditing = false
        imageFromSource.sourceType = .photoLibrary
        imageFromSource.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imageFromSource, animated: true, completion: nil)
    }
    
    @IBAction func uploadVideos(_ sender: AnyObject) {
    }
    func clickMe(sender:UIButton!){
        print("TESTING123123")
        print(sender.tag)
        var x = 0
        for picture in eventPictures {
            if picture.imgID == sender.tag {
                eventPictures.remove(at: x)
                scrollView.subviews.forEach({ $0.removeFromSuperview() })
                pictureHeightIndex = 50
                populate()
            }
            x = x + 1
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        var eventPicture = UIImageView(image: chosenImage)
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        eventPicture.frame = CGRect(x: 0, y: pictureHeightIndex, width: Int(screenWidth), height: 200)
        eventPicture.contentMode = .scaleAspectFit
        scrollViewHeight = scrollViewHeight + 250
        self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollViewHeight));
        self.scrollView.addSubview(eventPicture)
        //pictureHeightIndex = pictureHeightIndex + 250
        //eventPicture.contentMode = .scaleAspectFit //3
        //eventPicture.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
        //chosenImage.tag = currentTag
        var myImage = ImageWithTag(img: chosenImage, imgId: currentTag)
        eventPictures.append(myImage)
        
        
        
        var myWidth: Float = 0
        
        let imageRatio: Float = Float(myImage.img!.size.width) / Float(myImage.img!.size.height)
        let viewRatio: Float = Float(eventPicture.frame.size.width) / Float(eventPicture.frame.size.height)
        if imageRatio < viewRatio {
            let scale: Float = Float(eventPicture.frame.size.height) / Float(myImage.img!.size.height)
            let width: Float = scale * Float(myImage.img!.size.width)
            var topLeftX: Float = (Float(eventPicture.frame.size.width) - width) * 0.5
            print(width)
            print("Please work")
            myWidth = width
        }
        else {
            let scale: Float = Float(eventPicture.frame.size.width) / Float(myImage.img!.size.width)
            let height: Float = scale * Float(myImage.img!.size.height)
            var topLeftY: Float = (Float(eventPicture.frame.size.height) - height) * 0.5
        }
        
        var testing = Int(screenWidth / 2) + Int(myWidth / 2)
        

        print(myImage.img!.size.width)
        print("BOOM")
        let deleteButton = UIButton(frame: CGRect(x:Int(testing - 24), y:pictureHeightIndex, width:25, height:25))
        deleteButton.backgroundColor = .red
        //deleteButton.center = CGPoint(x:0.0, y:0.0)
        deleteButton.setTitle("x", for: .normal)
        deleteButton.addTarget(self, action: #selector(EventMediaController.clickMe), for: UIControlEvents.touchUpInside)
        deleteButton.tag = currentTag
        //scrollViewHeight = scrollViewHeight + 100
        pictureHeightIndex = pictureHeightIndex + 250
        self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollViewHeight))
        self.scrollView.addSubview(deleteButton)
        currentTag = currentTag + 1
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    

}
