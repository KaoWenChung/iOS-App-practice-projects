//
//  UserListViewController.swift
//  GitHub_UsersList
//
//  Created by wyn on 2020/6/29.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var viewModel = UserViewModel()
    
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadUserData()
        startSpinner()
    }
    
    private func startSpinner() {
        spinner.style = .medium
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        // Define the constraint of spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0), spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        // Start animation
        spinner.startAnimating()
    }
    
    private func loadUserData() {
        viewModel.fetchUsersData { [weak self] in
            self?.tableView.dataSource = self
            self?.spinner.stopAnimating()
            self?.tableView.reloadData()
        }
    }
}
// MARK: - TableView
extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserListTableViewCell
        
        let user = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(user)

        return cell
    }
}
