//
//  DataModel.swift
//  Elbotola
//
//  Created by bendnaiba on 7/24/16.
//  Copyright © 2016 bendnaiba. All rights reserved.
//

import Foundation
import Alamofire
import JHSpinner

protocol DataModelDelegate {
    func fileLoaded(path:String)
}


class DataModel: NSObject {
    
    var delegate : DataModelDelegate?
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate

    //MARK: - load File -
    func downloadFile(url:String, showLoading:Bool)
    {
        let spinner = JHSpinnerView.showOnView(mainDelegate.window!, spinnerColor:UIColor.white, overlay:.roundedSquare, overlayColor:Config.kColor_App)
        if !showLoading {
            spinner.removeFromSuperview()
        }
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        Alamofire.download(url, to: destination).responseData { response in
            spinner.removeFromSuperview()
            self.delegate?.fileLoaded(path: (response.destinationURL?.absoluteString)!)
        }
    }

    
}


extension NSDictionary {
    func getObjectForKey(aKey:String, andClassReturn className:String) -> AnyObject {
        
        if self.object(forKey: aKey) != nil && !(self.object(forKey: aKey) is NSNull) {
            return self.object(forKey:aKey)! as AnyObject
        }
        else{
            let aClass = NSClassFromString(className)
            return type(of: aClass) as AnyObject
        }
    }
    
    func getDictionaryForKey(aKey:String) -> NSDictionary {
        
        if self.object(forKey:aKey) != nil && !(self.object(forKey:aKey) is NSNull) {
            return self.object(forKey:aKey)! as! NSDictionary
        }
        else{
            return NSDictionary()
        }
    }
    
    func getStringForKey(aKey:String) -> String {
        
        if self.object(forKey:aKey) != nil && !(self.object(forKey:aKey) is NSNull) {
            return self.object(forKey:aKey)! as! String
        }
        else{
            return ""
        }
    }
    
    func getArrayForKey(aKey:String) -> NSArray {
        
        if self.object(forKey:aKey) != nil && !(self.object(forKey:aKey) is NSNull) {
            return self.object(forKey:aKey)! as! NSArray
        }
        else{
            return NSArray()
        }
    }
    
    func getNumberForKey(aKey:String) -> NSNumber {
        
        if self.object(forKey:aKey) != nil && !(self.object(forKey:aKey) is NSNull) {
            return self.object(forKey:aKey)! as! NSNumber
        }
        else{
            return NSNumber(value: 0)
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
}

extension UIColor {
    struct MyTheme {
        static var valid: UIColor  { get { return UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1) } }
        static var expired: UIColor { get { return UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1) } }
    }
    
    class func getRandomColor() -> UIColor
    {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

extension Date {
    static func dateFromFormat(format:String, dateString:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
    
    static func stringFromString(formatFrom: String, formatTo: String, dateString:String) -> String {
        let date:Date = Date.dateFromFormat(format: formatFrom, dateString: dateString)
        return date.string(format: formatTo)
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UITextField {
    func setBottomBorder(color:UIColor) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
