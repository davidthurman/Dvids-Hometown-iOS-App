//
//  EventMediaController.swift
//  Hometown App
//
//  Created by David Thurman on 11/10/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit
import Photos

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
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            imageFromSource.allowsEditing = false
            imageFromSource.sourceType = .photoLibrary
            imageFromSource.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            print("ZZZ")
            present(imageFromSource, animated: true, completion: nil)
            print("YYY")
        }
        else {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.imageFromSource.allowsEditing = false
                    self.imageFromSource.sourceType = .photoLibrary
                    self.imageFromSource.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                    self.tempPresent()
                }
                    
                else {
                    self.needToAuthorize(notAllowed: "library")
                }
            })
        }
    }
    
    func tempPresent(){
        present(self.imageFromSource, animated: true, completion: nil)
    }
    
    func needToAuthorize(notAllowed: String){
        let alert = UIAlertController(title: "Permission Denies", message: "You must allow this app to access your " + notAllowed + " from your settings in order to use this functionality", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        print("AA")
        var chosenImage: UIImage?
        var type = "image"
        var vidUrl: URL?
        if let temp = info[UIImagePickerControllerOriginalImage] as? UIImage {
            chosenImage = temp
        }
        else {
            var videoURL = info["UIImagePickerControllerMediaURL"] as? NSURL
            print(videoURL)
            let filePath: URL = videoURL as! URL
            vidUrl = filePath
            do {
                let asset = AVURLAsset(url: filePath , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                chosenImage = thumbnail
                // thumbnail here
                type = "video"
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
        }
        
        //let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("BB")
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
        var myImage: ImageWithTag?
        if type == "image" {
            myImage = ImageWithTag(img: chosenImage!, imgId: currentTag)
            eventPictures.append(myImage!)
        }
        else{
            myImage = ImageWithTag(img: chosenImage!, imgId: currentTag, vidUrl: vidUrl!)
            eventPictures.append(myImage!)
        }
        
        var myWidth: Float = 0
        let imageRatio: Float = Float(myImage!.img!.size.width) / Float(myImage!.img!.size.height)
        let viewRatio: Float = Float(eventPicture.frame.size.width) / Float(eventPicture.frame.size.height)
        if imageRatio < viewRatio {
            let scale: Float = Float(eventPicture.frame.size.height) / Float(myImage!.img!.size.height)
            let width: Float = scale * Float(myImage!.img!.size.width)
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
