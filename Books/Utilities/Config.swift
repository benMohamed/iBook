//
//  Config.swift
//  Elbotola
//
//  Created by bendnaiba on 7/11/16.
//  Copyright © 2016 bendnaiba. All rights reserved.
//

import Foundation


class Config : NSObject {
    
    //plist host
    static let kPLIST = "http://www.yourserver.com/Books.plist"
    
    //ads
    static let ADMOB_BANNER_UNIT_ID = "ca-app-pub-5302089836633659/3538452128"

    //Share
    static let kMSG_SHARE = "Telecharger l'application #Books sur iphone"
    static let kURL = "https://itunes.apple.com/us/app/pdf-books-load-and-save-your-pdf/id1125489689"

    //StoryBoard
    static let kMAIN_STORYBOARD : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    //Color
    static let kColor_App = UIColor.init(red: 91.0/255.0, green: 192.0/255.0, blue: 190.0/255.0, alpha: 1.0)
    
}
