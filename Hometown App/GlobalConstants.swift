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
var dvidsId: Int = 1
var selectedEvent: String = ""
var selectedSubevent: String = ""
var submitInfo : [String : Any] = [:]
//var backgroundColor = UIColor(red:255, green:255, blue:255, alpha:1.0)
var textColor = UIColor(red:255, green:255, blue:255, alpha:1.0)

var local = "http://localhost:8000/"
var server = "http://192.168.10.17:8000/"

var url = server



