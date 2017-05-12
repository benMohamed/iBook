//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import AAShareBubbles
import Social
import MessageUI

class MenuController: UITableViewController, AAShareBubblesDelegate {
    
    var homeVC:HomeVC?
    var favoriteVC:FavoriteVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if self.homeVC == nil {
                self.homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
            }
            let nav = UINavigationController(rootViewController: self.homeVC!)
            nav.isNavigationBarHidden = true
            self.revealViewController().pushFrontViewController(nav, animated: true)
            break
        case 1:
            if self.favoriteVC == nil {
                self.favoriteVC = storyboard?.instantiateViewController(withIdentifier: "FavoriteVC") as? FavoriteVC
            }
            let nav = UINavigationController(rootViewController: self.favoriteVC!)
            nav.isNavigationBarHidden = true
            self.revealViewController().pushFrontViewController(nav, animated: true)
            break
        case 2:
            let shareBubbles:AAShareBubbles = AAShareBubbles.init(centeredInWindowWithRadius: 140)
            shareBubbles.delegate = self
            shareBubbles.bubbleRadius = 40 // Default is 40
            shareBubbles.showFacebookBubble = true
            shareBubbles.showTwitterBubble = true
            shareBubbles.showMailBubble = true
            shareBubbles.showMessageBubble = true
            shareBubbles.show()
            break
        default:
            break
        }
    }

    //MAKE : - AAShareBubblesDelegate
    func aaShareBubbles(_ shareBubbles: AAShareBubbles!, tappedBubbleWith bubbleType: AAShareBubbleType) {
        switch (bubbleType) {
        case AAShareBubbleType.facebook:
            let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            composeSheet?.setInitialText(Config.kMSG_SHARE)
            composeSheet?.add(URL.init(string: Config.kURL))
            present(composeSheet!, animated: true, completion: nil)
            break;
        case AAShareBubbleType.twitter:
            let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            composeSheet?.setInitialText(Config.kMSG_SHARE)
            composeSheet?.add(URL.init(string: Config.kURL))
            present(composeSheet!, animated: true, completion: nil)
            break
        case AAShareBubbleType.mail:
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.setMessageBody(Config.kMSG_SHARE + " " + Config.kURL, isHTML: false)
                present(mail, animated: true)
            } else {
            }
            break
        case AAShareBubbleType.message:
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = Config.kMSG_SHARE + " " + Config.kURL
                present(controller, animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
    
}
