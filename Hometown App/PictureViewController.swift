//
//  PictureViewController.swift
//  Hometown App
//
//  Created by David Thurman on 10/27/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var eventPicture: UIImageView!
    let imageFromSource = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageFromSource.delegate = self
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
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        eventPicture.contentMode = .scaleAspectFit //3
        eventPicture.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pictureSegue" ,
            let nextScene = segue.destination as? MainPageViewController
        {
            userImage = eventPicture.image
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if UIImagePNGRepresentation(eventPicture.image!) != UIImagePNGRepresentation(#imageLiteral(resourceName: "avatar.png")) {
            return true
        }
        else {
            return false
        }
    }
}
