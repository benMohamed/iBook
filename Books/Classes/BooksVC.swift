//
//  NewsTableViewController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import GoogleMobileAds
import MGSwipeTableCell

class BooksVC: BaseVC, UITableViewDelegate, UITableViewDataSource, BookCellDelegate, DataModelDelegate, ReaderViewControllerDelegate {

    @IBOutlet var tableView:UITableView!
    var arrayBooks:NSMutableArray?
    var mDico:NSMutableDictionary?
    var readerViewController:ReaderViewController?

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
        return (self.arrayBooks?.count)!
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        let dico = self.arrayBooks?.object(at: indexPath.row) as! NSDictionary
        cell.dicoBook = dico
        cell.bookDelegate = self
        cell.labelTitle.text = dico.object(forKey: "name") as! String?
        cell.labelAuthor.text = dico.object(forKey: "author") as! String?
        cell.checkFavorited()
        Alamofire.request(dico.object(forKey: "image") as! String).responseImage { response in
            if let image = response.result.value {
                cell.imgBook.image = image
            }
        }
        //configure right buttons
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: .red){
            (sender: MGSwipeTableCell!) -> Bool in
            self.deleteBook(dico: dico)
            return true
            }]
        cell.rightSwipeSettings.transition = .border
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dico:NSDictionary = (self.arrayBooks?.object(at: indexPath.row) as? NSDictionary)!
        self.dataManager?.dataModel.delegate = self
        let fileName:String = NSString(string: dico.getStringForKey(aKey: "url")).lastPathComponent
        if UserDefaults.standard.object(forKey: fileName) != nil {
            let path = DataManager.savePath().appending(UserDefaults.standard.object(forKey: fileName) as! String)
            self.openPdfFileWithReader(path: path)
        }
        else{
            self.dataManager?.dataModel.downloadFile(url: dico.getStringForKey(aKey: "url"), showLoading: true)
        }
    }
    
    //MARK: - open pdf file -
    
    func openPdfFileWithReader(path: String) {
        var urlString = String(path)
        urlString = urlString?.replacingOccurrences(of: "file://", with: "")
        let reader = ReaderDocument(filePath: urlString, password: "nil")

        if reader == nil {
            let popup:Popup = Popup.init(title: "Only PDF are supported \n", subTitle: "", cancelTitle: "Cancel", successTitle: nil)
            popup.backgroundBlurType = .dark
            popup.roundedCorners = true
            popup.tapBackgroundToDismiss = true
            popup.titleColor = UIColor(red: 110.0/255.0, green: 202.0/255.0, blue: 202.0/255.0, alpha: 1.0)
            popup.backgroundColor = UIColor.white
            popup.show()
            return
        }
        self.readerViewController = ReaderViewController.init(readerDocument: reader)
        self.readerViewController?.delegate = self
        self.present(self.readerViewController!, animated: true, completion: nil)
    }
    
    func deleteBook(dico:NSDictionary) {
        self.arrayBooks?.remove(dico)
        self.mDico?.setValue(self.arrayBooks, forKey: "liste")
        self.tableView.reloadData()
        
        let mArrayCategorie:NSMutableArray = NSMutableArray(array:UserDefaults.standard.object(forKey: "BooksList") as! NSArray)
        for i in 0 ..< mArrayCategorie.count {
            let dicoCategory:NSMutableDictionary = NSMutableDictionary(dictionary:mArrayCategorie.object(at: i) as! NSDictionary)
            if dicoCategory.getStringForKey(aKey: "category") == self.mDico?.getStringForKey(aKey: "category") {
                mArrayCategorie.replaceObject(at: i, with: self.mDico!)
                break
            }
        }
        UserDefaults.standard.set(mArrayCategorie, forKey: "BooksList")
    }
    
    // MARK: - DataModel Delegate -
    
    func fileLoaded(path: String) {
        if path.contains("file://") {
            //save file
            let fileName:String = NSString(string: path).lastPathComponent
            UserDefaults.standard.setValue(fileName, forKey: fileName)
            UserDefaults.standard.synchronize()
            //open file
            self.openPdfFileWithReader(path: path)
        }
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
    

    func relaodData()
    {
    }
    
    //Mark: - ReaderViewController Delegate -
    func dismiss(_ viewController: ReaderViewController!) {
        self.readerViewController?.dismiss(animated: true, completion: nil)
    }
}
