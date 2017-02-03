//
//  StartViewController.swift
//  Hometown App
//
//  Created by David Thurman on 10/21/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import UIKit


class StartViewController: UIViewController {
    
    @IBOutlet var LogInImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(StartViewController.login))
        LogInImage.addGestureRecognizer(tap)
        LogInImage.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func login(){
        self.performSegue(withIdentifier: "TempLogInSegue", sender: nil)
        //NotificationNames.appOpenedWithUrl.add(observer: self, selector: #selector(onAppOpenedWithUrl(_:)))
        //presentSafariViewController(url: DvidsOauth.authorizeUrl)
    }

    func onAppOpenedWithUrl(_ notification: Notification) {
        NotificationNames.appOpenedWithUrl.remove(observer: self)
        guard let url = notification.userInfo?["URL"] as? URL else { return }
        let urlComponents = NSURLComponents(string: url.absoluteString)
        if let code = urlComponents?.queryItems?.filter({$0.name == "code"}).first?.value {
            DvidsOauth.getAccessToken(withCode: code) {
                [weak self] (success: Bool) in
                guard let s = self else { return }
                
                OperationQueue.main.addOperation {
                    if success {
                        s.dismiss(animated: true, completion: nil)                        
                        if #available(iOS 10.0, *) { } else {
                            UIApplication.shared.statusBarStyle = .lightContent
                        }
                    } else {
                        s.dismiss(animated: true) {
                            s.presentOkAlert(withMessage: "Could not get access token. Check your connection and try again", title: "Error")
                        }
                    }
                }
            }
        } else {
            dismiss(animated: true) { [weak self] in
                self?.presentOkAlert(withMessage: "Could not get access token. Check your connection and try again", title: "Error")
            }
        }
    }
}
