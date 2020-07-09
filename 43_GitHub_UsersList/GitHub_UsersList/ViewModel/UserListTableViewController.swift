//
//  UserListTableViewController.swift
//  GitHub_UsersList
//
//  Created by wyn on 2020/6/29.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserListTableViewCell
        
        // Configure the cell
        let user = users[indexPath.row]
        print("user: \(user)")
        cell.nameLabel.text = user.login
        return cell
    }
}
