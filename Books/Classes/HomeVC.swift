//
//  NewsTableViewController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import RMPScrollingMenuBarController


class HomeVC: RMPScrollingMenuBarController, RMPScrollingMenuBarControllerDelegate, AddBookViewDelegate, CategoryVCDelegate {

    @IBOutlet weak var btnSwitch: UIButton!
    var mArrayVC:NSMutableArray?
    var mStoryBoard:UIStoryboard?
    var categoryVC:CategoryVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        self.delegate = self;
        
        self.getArrayVC()
        self.setViewControllers(self.mArrayVC as! [Any]!, animated: true)
        self.view.backgroundColor = UIColor.white
        self.menuBar.indicatorColor = UIColor(red: 91/255.0, green: 192/255.0, blue: 191/255.0, alpha: 1.0)
        self.menuBar.showsIndicator = true;
        self.menuBar.showsSeparatorLine = true
        self.menuBar.frame = CGRect(x: 0, y: 100, width: self.menuBar.frame.size.width, height: self.menuBar.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: - Action -
    @IBAction func menuPushed(sender:UIButton) {
        revealViewController().revealToggle(nil)
    }
    
    @IBAction func addBooks(_ sender: UIButton) {
        var addType:AddType = .book
        if self.btnSwitch.isSelected {
            addType = .category
        }
        let addBookView:AddBookView = AddBookView.instanceFromNib(addType: addType) as! AddBookView
        addBookView.frame = self.view.frame
        addBookView.parentVC = self
        addBookView.delegate = self
        addBookView.mArrayCategory = NSMutableArray()
        let arrayCategory = UserDefaults.standard.object(forKey: "BooksList") as! NSArray
        for i in 0 ..< arrayCategory.count {
            let dico:NSDictionary = arrayCategory.object(at: i) as! NSDictionary
            addBookView.mArrayCategory?.add(dico.getStringForKey(aKey: "category"))
        }
        self.view.addSubview(addBookView)
    }
    
    @IBAction func switchPushed(_ sender: UIButton) {
        self.btnSwitch.isSelected = !self.btnSwitch.isSelected
        if self.categoryVC == nil {
            self.categoryVC = self.mStoryBoard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
            self.categoryVC?.view.frame = CGRect(x: 0, y: 70, width: self.view.frame.size.width, height: self.view.frame.height - 70)
            self.categoryVC?.delegate = self
        }
        self.categoryVC?.mArrayCategories = NSMutableArray(array:UserDefaults.standard.object(forKey: "BooksList") as! NSArray)
        if !self.btnSwitch.isSelected {
            self.categoryVC?.view.removeFromSuperview()
            return
        }
        self.view.addSubview((self.categoryVC?.view)!)
    }
    //Mark: get ViewController
    func getArrayVC() {
        self.mArrayVC = NSMutableArray()
        let arrayCategorie:NSArray = NSMutableArray(array:UserDefaults.standard.object(forKey: "BooksList") as! NSArray)
        for i in 0 ..< arrayCategorie.count {
            let dico:NSDictionary = arrayCategorie.object(at: i) as! NSDictionary
            let bookVC:BooksVC = self.mStoryBoard?.instantiateViewController(withIdentifier: "BooksVC") as! BooksVC
            bookVC.mDico = NSMutableDictionary(dictionary:dico)
            bookVC.arrayBooks = NSMutableArray(array:dico.object(forKey: "liste") as! NSArray)
            self.mArrayVC?.add(bookVC)
        }
    }
    
    //Mark: - RMPScrollingMenuBarController delegate -
    
    func menuBarController(_ menuBarController: RMPScrollingMenuBarController, menuBarItemAt index: Int) -> RMPScrollingMenuBarItem {
        let item = RMPScrollingMenuBarItem()
        let arrayCategorie:NSArray = NSMutableArray(array:UserDefaults.standard.object(forKey: "BooksList") as! NSArray)
        let dico:NSDictionary = arrayCategorie.object(at: index) as! NSDictionary
        item.title = dico.object(forKey: "category") as! String!
        item.button().setTitleColor(UIColor.init(netHex:0x93A8AC), for: UIControlState.normal)
        item.button().setTitleColor(UIColor.init(netHex:0xA4B7BA), for: UIControlState.selected)
        return item
    }
    
    func menuBarController(_ menuBarController: RMPScrollingMenuBarController, willSelect viewController: UIViewController) {
        print("will select \(viewController)")
    }
    
    func menuBarController(_ menuBarController: RMPScrollingMenuBarController, didSelect viewController: UIViewController) {
        print("did select \(viewController)")
    }
    
    func menuBarController(_ menuBarController: RMPScrollingMenuBarController, didCancel viewController: UIViewController) {
        print("did cancel \(viewController)")
    }

    //Mark: - AddBook delegate -
    
    func bookAdded() {
        let arrayCategorie:NSArray = NSMutableArray(array:UserDefaults.standard.object(forKey: "BooksList") as! NSArray)
        for i in 0 ..< arrayCategorie.count {
            let dico:NSDictionary = arrayCategorie.object(at: i) as! NSDictionary
            let bookVC:BooksVC = self.mArrayVC?.object(at: i) as! BooksVC
            bookVC.arrayBooks = NSMutableArray(array:dico.object(forKey: "liste") as! NSArray)
            if (bookVC.tableView != nil) {
                bookVC.tableView.reloadData()
            }
        }
    }
    
    func categoryAdded() {
        //update home
        self.getArrayVC()
        self.setViewControllers(self.mArrayVC as! [Any]!, animated: true)
        //update category VC
        self.categoryVC?.mArrayCategories = NSMutableArray(array:UserDefaults.standard.object(forKey: "BooksList") as! NSArray)
        self.categoryVC?.tableView.reloadData()
    }
    
    //Mark: - CategoryVC Delegate -
    
    func categroyRemoved() {
        //update home
        self.getArrayVC()
        self.setViewControllers(self.mArrayVC as! [Any]!, animated: true)
    }

}
