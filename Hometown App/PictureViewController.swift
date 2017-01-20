//
//  PictureViewController.swift
//  Hometown App
//
//  Created by David Thurman on 10/27/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit
import Alamofire

class PictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var eventPicture: UIImageView!
    let imageFromSource = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageFromSource.delegate = self
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
        let postUrl = "http://192.168.10.17:8000/profile/" + String(dvidsId)
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
                self.popUp()
            }
            else {
                self.performSegue(withIdentifier: "updateSegue", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func takePicture(_ sender: AnyObject) {
        imageFromSource.allowsEditing = false
        imageFromSource.sourceType = UIImagePickerControllerSourceType.camera
        imageFromSource.cameraCaptureMode = .photo
        imageFromSource.modalPresentationStyle = .fullScreen
        present(imageFromSource,animated: true,completion: nil)
    }

    @IBAction func fromLibrary(_ sender: AnyObject) {
        imageFromSource.allowsEditing = false
        imageFromSource.sourceType = .photoLibrary
        imageFromSource.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imageFromSource, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        eventPicture.contentMode = .scaleAspectFit
        eventPicture.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        myImageUploadRequest()
        if segue.identifier == "pictureSegue"
        {
            userImage = eventPicture.image
        }
    }

    @IBAction func updateButton(_ sender: AnyObject) {
        if UIImagePNGRepresentation(eventPicture.image!) != UIImagePNGRepresentation(#imageLiteral(resourceName: "avatar.png")) {
            profileUpdate()
        }
        
    }

    
    func myImageUploadRequest() {
        let imageData = UIImageJPEGRepresentation(eventPicture.image!, 1)
        Alamofire.upload(imageData!, to: "http://localhost:8000/profile/" + String(dvidsId) + "/media").responseJSON { response in
            debugPrint(response)
        }
    }

}


