//
//  SplashVC.swift
//  HooplaCar
//
//  Created by bendnaiba on 9/25/16.
//  Copyright © 2016 bendnaiba. All rights reserved.
//

import Foundation


class SplashVC: BaseVC {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
    }
    
    func updateView() {
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(SplashVC.launchMainVC), userInfo: nil, repeats: false)
        
    }
    
    func launchMainVC()
    {
        let mainVC:SWRevealViewController = self.mStoryBoard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let mainDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.window?.rootViewController = mainVC

    }
}
