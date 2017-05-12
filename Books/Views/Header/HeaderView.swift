//
//  HeaderView.swift
//  Elbotola
//
//  Created by bendnaiba on 7/10/16.
//  Copyright © 2016 bendnaiba. All rights reserved.
//

import Foundation

protocol HeaderDelegate {
    func openMenu()
    func back()
    func share()
    func setting()
    func edit()
    func send()
}

class HeaderView: UIView
{
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var delegate:HeaderDelegate?
    
    // MARK: Action
    @IBAction func menuPushed(sender: UIButton) {
        self.delegate?.openMenu()
    }
    @IBAction func backPushed(sender: UIButton) {
        self.delegate?.back()
    }
    @IBAction func settingPushed(sender: AnyObject) {
        self.delegate?.setting()
    }

}
