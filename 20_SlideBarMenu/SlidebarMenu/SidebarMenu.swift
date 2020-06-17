//
//  SidebarMenu.swift
//  SlidebarMenu
//
//  Created by wyn on 2020/5/17.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func addSideBarMenu(leftMenuButton: UIBarButtonItem?, rightMenuButton: UIBarButtonItem? = nil) {
        if revealViewController() != nil {
            if let menuButton = leftMenuButton {
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }
            
            if let extraButton = rightMenuButton {
                revealViewController().rightViewRevealWidth = 150
                extraButton.target = revealViewController()
                extraButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
