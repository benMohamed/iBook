//
//  BaseVC.swift
//  Fives
//
//  Created by bendnaiba on 6/16/16.
//  Copyright © 2016 FV iMAGINATION. All rights reserved.
//

import Foundation
import GoogleMobileAds


class BaseVC: UIViewController, HeaderDelegate, DataManagerDelegate, GADBannerViewDelegate
{
    var mStoryBoard:UIStoryboard?
    //header
    var isShowHeader: Bool = false
    var isShowBack: Bool = false
    var isShowShare: Bool = false
    var headerView:HeaderView?
    var mainDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var dataManager:DataManager?
    //ads
    var adMobBannerView = GADBannerView()

    
    override func viewDidLoad() {
        self.mStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        self.showHeader()
        self.dataManager = DataManager.sharedInstance
        self.dataManager?.delegate = self
        if revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    // MARK: Header
    
    func showHeader() {
        if self.isShowHeader {
            let nibsView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil) as? [UIView]
            self.headerView = nibsView![0] as UIView as? HeaderView
            self.headerView?.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: (self.headerView?.frame.size.height)!)
            self.headerView!.delegate = self
            self.headerView?.btnBack.isHidden = !self.isShowBack
            self.headerView?.btnMenu.isHidden = self.isShowBack
            
            self.view.addSubview(self.headerView!)
        }
    }
    
    //MARK: reachability
    
    func didAppIs(connected isConnected: Bool) {
    }
    
    
    func someSelector() {
        // Something after a delay
    }
    
    // MARK: Action
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Hedear delegate
    
    func openMenu() {
        revealViewController().revealToggle(nil)
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setting() {
    }
    
    func edit() {
    }
    
    func send() {
    }
    
    func share()
    {
    }
    
    // MARK: - ADMOB BANNER METHODS
    
    func initAdMobBanner() {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            // iPad banner
            adMobBannerView.adSize = GADAdSizeFromCGSize(CGSize(width:self.view.frame.size.width, height:90))
            adMobBannerView.frame = CGRect(x:0, y:self.view.frame.size.height, width:self.view.frame.size.width, height:90)
            
        } else {
            // iPhone banner
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width:self.view.frame.size.width, height:50))
            adMobBannerView.frame = CGRect(x:0, y:self.view.frame.size.height, width:self.view.frame.size.width, height:50)
        }
        
        adMobBannerView.adUnitID = Config.ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        // adMobBannerView.hidden = true
        view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adMobBannerView.load(request)
    }
    
    
    // Hide the banner
    func hideBanner(banner: UIView) {
        if banner.isHidden == false {
            UIView.beginAnimations("hideBanner", context: nil)
            banner.frame = CGRect(x:0, y:view.frame.size.height, width:banner.frame.size.width, height:banner.frame.size.height)
            UIView.commitAnimations()
            banner.isHidden = true
        }
    }
    
    // Show the banner
    func showBanner(banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x:view.frame.size.width/2 - banner.frame.size.width/2,
                                  y:view.frame.size.height - banner.frame.size.height,
                                  width:banner.frame.size.width, height:banner.frame.size.height);
        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("AdMob loaded!")
        showBanner(banner: adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("AdMob Can't load ads right now, they'll be available later \n\(error)")
        hideBanner(banner: adMobBannerView)
    }
    
    
    
}
