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
var dvidsId: Int = 1044846
var selectedEvent: String = ""
var selectedSubevent: String = ""
var submitInfo : [String : Any] = [:]
