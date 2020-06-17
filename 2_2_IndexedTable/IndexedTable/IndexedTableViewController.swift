//
//  IndexedTableViewController.swift
//  IndexedTable
//
//  Created by wyn on 2020/4/28.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit

class IndexedTableViewController: UITableViewController {
    
    
    let names = ["Bear", "Black Swan", "Buffalo", "Camel", "Cockatoo", "Dog", "Donkey", "Emu", "Giraffe", "Greater Rhea", "Hippopotamus", "Horse", "Koala", "Lion", "Llama", "Manatus", "Meerkat", "Panda", "Peacock", "Pig", "Platypus", "Polar Bear", "Rhinoceros", "Seagull", "Tasmania Devil", "Whale", "Whale Shark", "Wombat"]
    var namesDict = [String:[String]]()
    var nameSectionTitles = [String]()
    let nameIndexTitles = ["A", "B", "C","D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create names dictionary
        createNameDict()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return nameSectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return the section title
        return nameSectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        let firstLetter = nameSectionTitles[section]
        guard let nameValues = namesDict[firstLetter] else {
            return 0
        }
        return nameValues.count
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        guard let index = nameSectionTitles.firstIndex(of: title) else {
            return -1
        }
        return index
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nameIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell
        let firstLetter = nameSectionTitles[indexPath.section]
        if let nameValues = namesDict[firstLetter] {
            cell.textLabel?.text = nameValues[indexPath.row]
        }
        return cell
    }
    
    func createNameDict() {
        for name in names {
            let firstLetter = String(name.prefix(1))
            if var nameValues = namesDict[firstLetter]{
                nameValues.append(name)
                namesDict[firstLetter] = nameValues
            } else {
                namesDict[firstLetter] = [name]
            }
            // Get keys from dict and sort by section title
            nameSectionTitles = [String](namesDict.keys)
            nameSectionTitles = nameSectionTitles.sorted(by: {$0 < $1})
        }
    }
}
