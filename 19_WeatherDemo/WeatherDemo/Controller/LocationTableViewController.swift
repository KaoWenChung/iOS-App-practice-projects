//
//  LocationTableViewController.swift
//  WeatherDemo
//
//  Created by Simon Ng on 27/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {

    var defaults = UserDefaults(suiteName: "group.com.wyn.weatherappdemo")!
    
    let locations = ["Paris, France", "Kyoto, Japan", "Sydney, Australia", "Seattle, U.S.", "New York, U.S.", "Hong Kong, Hong Kong", "Taipei, Taiwan", "London, U.K.", "Vancouver, Canada"]
    
    var selectedLocation = "" {
        didSet {
            let locations = selectedLocation.split { $0 == "," }.map { String($0) }
            
            selectedCity = locations[0]
            selectedCountry = locations[1].trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private(set) var selectedCity = ""
    private(set) var selectedCountry = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = locations[indexPath.row]
        cell.accessoryType = (locations[indexPath.row] == selectedLocation) ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        if let location = cell?.textLabel?.text {
            selectedLocation = location
            
            defaults.setValue(selectedCity, forKey: "city")
            defaults.setValue(selectedCountry, forKey: "country")
        }
        
        tableView.reloadData()
    }
}
