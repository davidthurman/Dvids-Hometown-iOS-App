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
    //var personalInfo: [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageFromSource.delegate = self
        if userImage != nil {
            eventPicture.image = userImage
        }
        
    }
    func popUp() {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        
        var postString = ""
        var fieldDict: [String: [String: [String: String]]] = [:]
        var fieldNumDict: [String: [String: String]] = [:]
        var count = 0
        for x in userInfo {
            if count != 0 {
                postString.append("&")
            }
            fieldNumDict[String(count)] = [x.key : x.value]
            count = count + 1
            postString.append(x.key + "=" + x.value)
        }
        fieldDict["fields"] = fieldNumDict
        print("LLLL")
        print(fieldDict)
        
        let dic = ["2": "B", "1": "A", "3": "C"]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                let postUrl = "http://localhost:8000/profile/" + String(dvidsId)
                
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
                        
                        print(response.response)
                        print("TEST999")
                }
            }
        } catch {
            print("TEST000")
            print(error.localizedDescription)
        }

        myImageUploadRequest()


        
        if segue.identifier == "pictureSegue" ,
            let nextScene = segue.destination as? MainPageViewController
        {
            userImage = eventPicture.image
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (sender as! UIButton).currentTitle! == "Update" {
            //popUp()
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return true
            if UIImagePNGRepresentation(eventPicture.image!) != UIImagePNGRepresentation(#imageLiteral(resourceName: "avatar.png")) {
                
                return true
            }
            else {
                return false
            }
        }
        return true
    }
    @IBAction func update(_ sender: AnyObject) {
        print("asasasa")
        userImage = eventPicture.image
    }
    
    

    
    func myImageUploadRequest() {
        let imageData = UIImageJPEGRepresentation(eventPicture.image!, 1)
        
        Alamofire.upload(imageData!, to: "http://localhost:8000/profile/" + String(dvidsId) + "/media").responseJSON { response in
            debugPrint(response)
        }
    }
    
    

    
    func generateBoundaryString() -> String {
        
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    

}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

