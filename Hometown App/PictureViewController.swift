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
    //var personalInfo: [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageFromSource.delegate = self
        if userImage != nil {
            eventPicture.image = userImage
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
        
        
        var request = URLRequest(url: URL(string: "http://localhost:8000/profile/test")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
        
        myImageUploadRequest()
        
        
        
        
        
        
//        let json = (fieldDict)
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//            print("QQQ")
//            print(jsonData)
//            // create post request
//            let url = NSURL(string: "http://localhost:8000/profile/test")!
//            let request = NSMutableURLRequest(url: url as URL)
//            request.httpMethod = "POST"
//            
//            // insert json data to the request
//            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonData
//            print("III")
//            print(request)
//            
//            print(<#T##items: Any...##Any#>)
//            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
//                if error != nil{
//                    print("Error -> \(error)")
//                    return
//                }
//                
//                do {
//                    let result = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:AnyObject]
//                    
//                    print("Result -> \(result)")
//                    
//                } catch {
//                    print("TESTqwe")
//
//                    print("Error -> \(error)")
//                }
//            }
//            
//            task.resume()            
//            
//            
//        } catch {
//            print(error)
//        }
 
        
        print("TEST123")
        print(userInfo)
        
        
        
        if segue.identifier == "pictureSegue" ,
            let nextScene = segue.destination as? MainPageViewController
        {
            userImage = eventPicture.image
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (sender as! UIButton).currentTitle! == "Next" {
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
    
    
    
    func myImageUploadRequest()
    {
        
        let myUrl = NSURL(string: "http://localhost:8000/profile/upload");
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = [
            "firstName"  : "Sergey",
            "lastName"    : "Kargopolov",
            "userId"    : "9"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(eventPicture.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        //myActivityIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                print(json)
                
                //dispatch_async(dispatch_get_main_queue(),{
                   // self.myActivityIndicator.stopAnimating()
                   // self.myImageView.image = nil;
               // });
                
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
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
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

