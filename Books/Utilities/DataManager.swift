//
//  DataManager.swift
//  Elbotola
//
//  Created by bendnaiba on 7/12/16.
//  Copyright © 2016 bendnaiba. All rights reserved.
//

import Foundation
import SwiftMessages

protocol DataManagerDelegate {
    func didAppIs(connected isConnected:Bool)
}



class DataManager {
    
    var delegate:DataManagerDelegate?
    static var isConnected:Bool = true
    var dataModel : DataModel = DataModel()
    
    static let sharedInstance = DataManager()
    //MARK: init DataManager
    init() {
        DataManager.creatCachFolder()
    }
    
    //MARK: - Gestion iCloud && Cash -
    
    class func creatCachFolder()
    {
        let fileManager: FileManager = FileManager.default
        var cacheDirectoryName: String = ""
        let os5: String = "5.0"
        let currSysVer: String = UIDevice.current.systemVersion
        let path: String = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents")!.absoluteString
        if currSysVer.compare(os5) == ComparisonResult.orderedAscending {
            cacheDirectoryName = path
        }
        else if currSysVer.compare(os5) == ComparisonResult.orderedDescending {
            cacheDirectoryName = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent("Books")!.absoluteString
            
        }
        else {
            cacheDirectoryName = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/Cookies/Elbotola")!.absoluteString
            
        }
        
        cacheDirectoryName = cacheDirectoryName.replacingOccurrences(of: "file://", with: "")
        
        var isDirectory: ObjCBool = false
        let folderExists: Bool = fileManager.fileExists(atPath: cacheDirectoryName, isDirectory: &isDirectory) && isDirectory.boolValue
        if !folderExists {
            do {
                try FileManager.default.createDirectory(atPath: cacheDirectoryName, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("\(error.localizedDescription)")
            }
        }
    }
    
    class func savePath() -> NSString {
        let os5: String = "5.0"
        let currSysVer: String = UIDevice.current.systemVersion
        var path: String = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents")!.absoluteString
        if currSysVer.compare(os5) == ComparisonResult.orderedAscending {
            path = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents")!.absoluteString
        }
        else if currSysVer.compare(os5) == ComparisonResult.orderedDescending {
            path = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/Books/")!.absoluteString
        }
        else {
            path = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/@")!.absoluteString
        }
        
        path = path.replacingOccurrences(of: "file://", with: "")
        
        return path as NSString
    }
    
    class func writeDataIntoCachWith(data: NSData, andKey key: String) {
        do {
            try
                data.write(toFile: DataManager.savePath().appendingPathComponent(key), options: NSData.WritingOptions.atomic)
        } catch let error as NSError {
            NSLog("\(error.localizedDescription)")
        }
    }
    
    class func readDataIntoCachWith(key: String) -> NSData? {
        let path: String = DataManager.savePath().appendingPathComponent(key)
        let data: NSData? = NSData(contentsOfFile: path)
        return data
    }
    
    class func deleteFileFromCache(key: String) {
        let fileManager: FileManager = FileManager.default
        let documentsDirectory: String = DataManager.savePath().appendingPathComponent(key)
        var filePath: String = NSURL(fileURLWithPath: documentsDirectory).absoluteString!
        filePath.removeSubrange(filePath.range(of: "file://")!)
        do {
            try
                fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            NSLog("\(error.localizedDescription)")
        }
    }
    
    //MARK: - Message View -
    
    class func showMessage(message:String, theme:Theme) {
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .StatusLine)
        
        // Theme message elements with the warning style.
        view.configureTheme(theme)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        let iconText = ""
        view.configureContent(title: "Warning", body: message, iconText: iconText)
        view.backgroundColor = UIColor(red: 110.0/255.0, green: 202.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        // Show the message.
        SwiftMessages.show(view: view)
    }
    
    //MARK: - UI -
    
    class func addCorner(radius:CGFloat, view:UIView) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = radius
    }
}
