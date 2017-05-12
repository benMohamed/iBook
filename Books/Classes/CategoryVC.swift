//
//  NewsTableViewController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MGSwipeTableCell

protocol CategoryVCDelegate {
    func categroyRemoved()
}

class CategoryVC: BaseVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView:UITableView!
    var mArrayCategories:NSMutableArray?
    var delegate:CategoryVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        //ads
        initAdMobBanner()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return (self.mArrayCategories?.count)!
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let dico = self.mArrayCategories?.object(at: indexPath.row) as! NSDictionary
        cell.dicoCategory = dico
        cell.labelTitle.text = dico.object(forKey: "category") as! String?
        //configure right buttons
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: .red){
            (sender: MGSwipeTableCell!) -> Bool in
            self.deleteCategory(dico: dico)
            return true
            }]
        cell.rightSwipeSettings.transition = .border
        return cell
    }
    
    func deleteCategory(dico:NSDictionary) {
        self.mArrayCategories?.remove(dico)
        self.tableView.reloadData()
        UserDefaults.standard.set(self.mArrayCategories, forKey: "BooksList")
        self.delegate?.categroyRemoved()
    }

    // MARK: - Ads delegate

    override func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        super.adViewDidReceiveAd(bannerView)
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
        self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: self.view.frame.size.height - self.tableView.frame.origin.y - self.adMobBannerView.frame.size.height)
        }

    }
    
    override func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        super.adView(bannerView, didFailToReceiveAdWithError: error)
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
        self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: self.view.frame.size.height - self.tableView.frame.origin.y)
        }
    }

}
