//
//  NewsTableViewController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class FavoriteVC: BooksVC {
    
    override func viewDidLoad() {
        self.isShowHeader = true;
        super.viewDidLoad()
        self.arrayBooks = NSMutableArray()
        self.relaodData()
        //ads
        initAdMobBanner()
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.frame = CGRect(x: 0, y: (self.headerView?.frame.size.height)!, width: self.tableView.frame.width, height: self.view.frame.height-(self.headerView?.frame.size.height)!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.relaodData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func relaodData()
    {
        //read favorite from disc
        let data:NSData? = DataManager.readDataIntoCachWith(key: "favorites")
        if (data != nil)
        {
            self.arrayBooks = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? NSMutableArray
        }
        self.tableView.reloadData()
    }
    
    //MARK: - tableView delegate -
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! BookCell
        cell.rightButtons = []
        return cell
    }

    
}
