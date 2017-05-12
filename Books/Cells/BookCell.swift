//
//  NewsTableViewCell.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import MGSwipeTableCell

protocol BookCellDelegate {
    func relaodData()
}

class BookCell: MGSwipeTableCell {
    
    @IBOutlet weak var imgBook:UIImageView!
    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    var dicoBook:NSDictionary?
    var bookDelegate : BookCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DataManager.addCorner(radius: 3, view: self.imgBook)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func checkFavorited(){
        //check if alerady favorite
        let data : NSData? = DataManager.readDataIntoCachWith(key:"favorites")
        if (data != nil)
        {
            let mArrayFavorite : NSArray = NSKeyedUnarchiver.unarchiveObject(with:data as! Data) as! NSArray
            for i in 0 ..< mArrayFavorite.count
            {
                let dico:NSDictionary = mArrayFavorite.object(at:i) as! NSDictionary
                if(dico.getStringForKey(aKey: "name") == self.dicoBook?.getStringForKey(aKey: "name"))
                {
                    self.btnFavorite.isSelected = true
                    break
                }
            }
        }
    }
    
    @IBAction func favoritePushed(_ sender: UIButton) {
        var mArrayFavorite : NSMutableArray = NSMutableArray.init()
        var data : NSData? = DataManager.readDataIntoCachWith(key:"favorites")
        if (sender.isSelected)
        {
            if (data != nil)
            {
                mArrayFavorite = NSKeyedUnarchiver.unarchiveObject(with:data as! Data) as! NSMutableArray
                for var i in 0 ..< mArrayFavorite.count
                {
                    let dico:NSDictionary = mArrayFavorite.object(at:i) as! NSDictionary
                    if (dico.getStringForKey(aKey:"name") == self.dicoBook?.getStringForKey(aKey: "name"))
                    {
                        mArrayFavorite.removeObject(at:mArrayFavorite.index(of:dico))
                        i = i - 1
                        break
                    }
                }
            }
        }
        else
        {
            if (data != nil)
            {
                mArrayFavorite = NSKeyedUnarchiver.unarchiveObject(with:data as! Data) as! NSMutableArray
            }
            else
            {
                mArrayFavorite = NSMutableArray.init()
            }
            mArrayFavorite.add(self.dicoBook!)
        }
        //save into disc
        data = NSKeyedArchiver.archivedData(withRootObject:mArrayFavorite) as NSData?
        DataManager.writeDataIntoCachWith(data: data!, andKey: "favorites")
        sender.isSelected = !sender.isSelected;
        self.bookDelegate?.relaodData()
    }
    
}
