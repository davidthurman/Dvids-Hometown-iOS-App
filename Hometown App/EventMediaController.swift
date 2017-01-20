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
        scrollViewHeight = eventPictures.count * 250
        self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollViewHeight));
        if eventPictures.count != 0 {
            
            self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollViewHeight));
            for myImage in eventPictures {
                
                var eventPicture = UIImageView(image: myImage.img)
                eventPicture.contentMode = .scaleAspectFit
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
                    myWidth = width
                }
                
                let testing = Int(screenWidth / 2) + Int(myWidth / 2)
                let deleteButton = UIButton(frame: CGRect(x:Int(testing - 24), y:pictureHeightIndex, width:25, height:25))
                deleteButton.backgroundColor = .red
                deleteButton.setTitle("x", for: .normal)
                deleteButton.addTarget(self, action: #selector(EventMediaController.clickMe), for: UIControlEvents.touchUpInside)
                deleteButton.tag = Int(myImage.imgID!)
                pictureHeightIndex = pictureHeightIndex + 250
                self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollViewHeight))
                self.scrollView.addSubview(deleteButton)
                currentTag = currentTag + 1
                
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Next(_ sender: AnyObject) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (sender as! UIButton).currentTitle! == "Next" {
            for x in 0...eventInfo.count {
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
        let eventPicture = UIImageView(image: chosenImage)
        eventPicture.contentMode = .scaleAspectFit
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        eventPicture.frame = CGRect(x: 0, y: pictureHeightIndex, width: Int(screenWidth), height: 200)
        eventPicture.contentMode = .scaleAspectFit
        scrollViewHeight = scrollViewHeight + 250
        self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollViewHeight));
        self.scrollView.addSubview(eventPicture)
        dismiss(animated:true, completion: nil) //5
        let myImage = ImageWithTag(img: chosenImage, imgId: currentTag)
        eventPictures.append(myImage)
        var myWidth: Float = 0
        let imageRatio: Float = Float(myImage.img!.size.width) / Float(myImage.img!.size.height)
        let viewRatio: Float = Float(eventPicture.frame.size.width) / Float(eventPicture.frame.size.height)
        if imageRatio < viewRatio {
            let scale: Float = Float(eventPicture.frame.size.height) / Float(myImage.img!.size.height)
            let width: Float = scale * Float(myImage.img!.size.width)
            myWidth = width
        }
        let testing = Int(screenWidth / 2) + Int(myWidth / 2)
        let deleteButton = UIButton(frame: CGRect(x:Int(testing - 24), y:pictureHeightIndex, width:25, height:25))
        deleteButton.backgroundColor = .red
        deleteButton.setTitle("x", for: .normal)
        deleteButton.addTarget(self, action: #selector(EventMediaController.clickMe), for: UIControlEvents.touchUpInside)
        deleteButton.tag = currentTag
        pictureHeightIndex = pictureHeightIndex + 250
        self.scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(scrollViewHeight))
        self.scrollView.addSubview(deleteButton)
        currentTag = currentTag + 1
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    

}
