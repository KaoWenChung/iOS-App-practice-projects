//
//  NewsTableViewController.swift
//  SlidebarMenu
//
//  Created by Simon Ng on 24/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet var extraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.estimatedRowHeight = 242.0
        tableView.rowHeight = UITableView.automaticDimension
        
        addSideBarMenu(leftMenuButton: menuButton, rightMenuButton: extraButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell

        // Configure the cell...
        if indexPath.row == 0 {
            cell.postImageView.image = UIImage(named: "watchkit-intro")
            cell.postTitleLabel.text = "高飛 (迪士尼角色)"
            cell.authorLabel.text = "Goofy"
            cell.authorImageView.image = UIImage(named: "author")
            
        } else if indexPath.row == 1 {
            cell.postImageView.image = UIImage(named: "custom-segue-featured-1024")
            cell.postTitleLabel.text = "是迪士尼經典動畫人物之一，首次出現於1932年5月25日米奇老鼠卡通片《米奇的時事諷刺劇》（Mickey's Revue） 一片中扮演觀眾角色"
            cell.authorLabel.text = "Gabriel Theodoropoulos"
            cell.authorImageView.image = UIImage(named: "appcoda-fav-logo")
            
        } else {
            cell.postImageView.image = UIImage(named: "webkit-featured")
            cell.postTitleLabel.text = "當時名叫迪皮·道格（英語：Dippy Dawg），片中他發出的刺耳笑聲令牠在觀眾中顯得有點鶴立雞群。高飛是一隻心地善良但腦袋瓜不大靈活的狗"
            cell.authorImageView.image = UIImage(named: "appcoda-fav-logo")
            
        }

        return cell
    }


}
