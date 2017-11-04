//
//  AppDelegate.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ReaderViewControllerDelegate {

    var window: UIWindow?
    var splashVC: SplashVC?
    var readerViewController:ReaderViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //spalsh
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.splashVC = Config.kMAIN_STORYBOARD.instantiateViewController(withIdentifier: "SplashVC") as? SplashVC
        self.window!.rootViewController = self.splashVC
        self.window?.makeKeyAndVisible()

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Thread.detachNewThreadSelector(#selector(self.loadData), toTarget: self, with: nil)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var urlString = url.absoluteString
        urlString = urlString.replacingOccurrences(of: "file://", with: "")
        let reader = ReaderDocument(filePath: urlString, password: "nil")
        
        if reader == nil {
            let popup:Popup = Popup.init(title: "Only PDF are supported \n", subTitle: "", cancelTitle: "Cancel", successTitle: nil)
            popup.backgroundBlurType = .dark
            popup.roundedCorners = true
            popup.tapBackgroundToDismiss = true
            popup.titleColor = UIColor(red: 110.0/255.0, green: 202.0/255.0, blue: 202.0/255.0, alpha: 1.0)
            popup.backgroundColor = UIColor.white
            popup.show()
            return true
        }
        self.readerViewController = ReaderViewController.init(readerDocument: reader)
        self.readerViewController?.delegate = self
        self.window?.rootViewController?.present(self.readerViewController!, animated: true, completion: nil)
 
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    // MARK: - Load Data -
    
    func loadData() {
        //read local data
        if UserDefaults.standard.object(forKey: "BooksList") == nil {
            let plistPath: String? = Bundle.main.path(forResource: "Books", ofType: "plist")
            let arrayBooks:NSArray = NSArray(contentsOfFile: plistPath!)!
            UserDefaults.standard.set(arrayBooks, forKey: "BooksList")
        }
        //load data from server
        let headers = ["Content-Type": "application/json"]
        Alamofire.request(Config.kPLIST, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(_):
                switch response.response!.statusCode{
                case 200, 201, 202:
                    //Save Data
                    if (response.result.value != nil)
                    {
                        let arrayBooks:NSArray = response.result.value as! NSArray
                        if arrayBooks.count != 0 {
                            //erase local data
                            UserDefaults.standard.set(arrayBooks, forKey: "BooksList")
                        }
                    }
                    break
                default:
                    break
                }
                break
            case .failure(let error):
                break
            }
        }
    }
    
    //Mark: - ReaderViewController Delegate -
    func dismiss(_ viewController: ReaderViewController!) {
        self.readerViewController?.dismiss(animated: true, completion: nil)
    }
}
