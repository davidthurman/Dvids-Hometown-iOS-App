import Foundation
import XCGLogger
import UIKit

let logger = XCGLogger.default
var userImage: UIImage?
var eventInfo: [String : String] = [:]
var userInfo: [String: String] = [:]
var eventOptions: [String: [String : String]] = [:]
var eventPictures: [ImageWithTag] = []
var currentTag = 0
var dvidsId: Int = 1218286
var selectedEvent: String = ""
var selectedSubevent: String = ""
var submitInfo : [String : Any] = [:]
//var backgroundColor = UIColor(red:255, green:255, blue:255, alpha:1.0)
var textColor = UIColor(red:255, green:255, blue:255, alpha:1.0)
var nextButtonColorGreen = UIColor(hue: 0.3111, saturation: 1, brightness: 0.64, alpha: 1.0)
var nextButtonColorGray = UIColor(hue: 0.0639, saturation: 0, brightness: 0.68, alpha: 1.0)
var nextButtonNotReady = UIColor(red:0.63, green:0.20, blue:0.16, alpha:1.0)

var local = "http://localhost:8000/"
var server = "http://192.168.10.17:8000/"

var url = server




