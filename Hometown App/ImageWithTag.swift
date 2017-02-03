//
//  ImageWithTag.swift
//  Hometown App
//
//  Created by David Thurman on 11/15/16.
//  Copyright © 2016 David Thurman. All rights reserved.
//

import Foundation
import UIKit

class ImageWithTag
{
    
    var img : UIImage? = nil
    
    var imgID : Int? = nil
    
    var vidUrl : URL? = nil
    
    init (img: UIImage, imgId: Int) {
        self.img = img
        self.imgID = imgId
    }
    init (img: UIImage, imgId: Int, vidUrl: URL){
        self.img = img
        self.imgID = imgId
        self.vidUrl = vidUrl
    }
}
