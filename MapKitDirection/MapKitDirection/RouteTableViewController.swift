//
//  RouteTableViewController.swift
//  MapKitDirection
//
//  Created by wyn on 2020/5/4.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class RouteTableViewController: UITableViewController {
    
    var routeSteps = [MKRoute.Step]()
    
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
        return routeSteps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = routeSteps[indexPath.row].instructions
        
        return cell
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
}
