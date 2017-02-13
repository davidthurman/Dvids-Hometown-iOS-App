//
//  PictureViewController.swift
//  Hometown App
//
//  Created by David Thurman on 10/27/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import Photos

class PictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var updateButton: UIButton!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var eventPicture: UIImageView!
    let imageFromSource = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.backgroundColor = nextButtonColorGreen
        imageFromSource.delegate = self
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        //If they already have a profile picture, display that. Otherwise display a temprorary avatar
        if userImage != nil {
            eventPicture.image = userImage
        }
    }
    
    func popUp() {
        let alert = UIAlertController(title: "No Connection", message: "Your request was unable to submit. Would you like to retry your submission or cancel?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { action in self.profileUpdate()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in self.performSegue(withIdentifier: "updateSegue", sender: self)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func profileUpdate() {
        userImage = eventPicture.image
        let postUrl = url + "/profile/" + String(dvidsId)
        var fields: [String:String] = [:]
        for x in userInfo {
            fields[x.key] = x.value
        }
        let parameters: [String: Any] = [
            "fields":
            fields
        ]
        Alamofire.request(postUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
            if response.response == nil {
                SwiftSpinner.hide()
                self.popUp()
            }
            else {
                self.uploadImage()
            }
        }
    }
    
    func uploadImage(){
        if UIImagePNGRepresentation(eventPicture.image!) != UIImagePNGRepresentation(#imageLiteral(resourceName: "avatar.png")) {
            let imageData = UIImageJPEGRepresentation(eventPicture.image!, 1)
            Alamofire.upload(imageData!, to: url + "/profile/" + String(dvidsId) + "/media").responseJSON { response in
                if response.response == nil {
                    SwiftSpinner.hide()
                    self.popUp()
                }
                else {
                    
                    self.submissionSuccess()
                }
            }
        }
        else {
            self.submissionSuccess()
        }
    }
    
    func submissionSuccess(){
        SwiftSpinner.hide()
        let alert = UIAlertController(title: "Submission Succeeded", message: "Your submission was successfully received.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in self.returnHome()}))
        self.present(alert, animated: true, completion: nil)
        
    }
    func returnHome(){
        performSegue(withIdentifier: "updateSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func takePicture(_ sender: AnyObject) {
        //If they have allowed camera access, use it. Otherwise, ask them for it
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized
        {
            imageFromSource.allowsEditing = false
            imageFromSource.sourceType = UIImagePickerControllerSourceType.camera
            imageFromSource.cameraCaptureMode = .photo
            imageFromSource.modalPresentationStyle = .fullScreen
            present(imageFromSource,animated: true,completion: nil)
        }
        else
        {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                    self.imageFromSource.allowsEditing = false
                    self.imageFromSource.sourceType = UIImagePickerControllerSourceType.camera
                    self.imageFromSource.cameraCaptureMode = .photo
                    self.imageFromSource.modalPresentationStyle = .fullScreen
                    self.presentImage()
                }
                else
                {
                    self.needToAuthorize(notAllowed: "camera")
                }
            });
        }
        
    }

    @IBAction func fromLibrary(_ sender: AnyObject) {
        //If they have allowed photo library access, use it. Otherwise, ask them for it
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            imageFromSource.allowsEditing = false
            imageFromSource.sourceType = .photoLibrary
            imageFromSource.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(imageFromSource, animated: true, completion: nil)
        }
        else {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.imageFromSource.allowsEditing = false
                    self.imageFromSource.sourceType = .photoLibrary
                    self.imageFromSource.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                    self.presentImage()
                }
                    
                else {
                    self.needToAuthorize(notAllowed: "library")
                }
            })
        }
    }
    
    func presentImage(){
        present(self.imageFromSource, animated: true, completion: nil)
    }
    
    func needToAuthorize(notAllowed: String){
        let alert = UIAlertController(title: "Permission Denies", message: "You must allow this app to access your " + notAllowed + " from your settings in order to use this functionality", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        eventPicture.contentMode = .scaleAspectFit
        eventPicture.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pictureSegue"
        {
            userImage = eventPicture.image
        }
        else {
            if eventPicture.image != #imageLiteral(resourceName: "avatar.png") {
                userImage = eventPicture.image
            }
        }
    }

    @IBAction func updateButton(_ sender: AnyObject) {
            SwiftSpinner.show("Updating Profile")
            profileUpdate()
    }
    
    /*
    func myImageUploadRequest() {
        
            let imageData = UIImageJPEGRepresentation(eventPicture.image!, 1)
            Alamofire.upload(imageData!, to: url + "/profile/" + String(dvidsId) + "/media").responseJSON { response in
                debugPrint(response)
            }
        
        
    }
*/
}


