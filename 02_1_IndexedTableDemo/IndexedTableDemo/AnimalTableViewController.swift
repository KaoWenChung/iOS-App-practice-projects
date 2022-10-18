//
//  AnimalTableViewController.swift
//  IndexedTableDemo
//
//  Created by wyn on 2020/4/26.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit

final class AnimalTableViewController: UITableViewController {
    
    let animals: [String] = ["Bear", "Black Swan", "Buffalo", "Camel", "Cockatoo", "Dog", "Donkey", "Emu", "Giraffe", "Greater Rhea", "Hippopotamus", "Horse", "Koala", "Lion", "Llama", "Manatus", "Meerkat", "Panda", "Peacock", "Pig", "Platypus", "Polar Bear", "Rhinoceros", "Seagull", "Tasmania Devil", "Whale", "Whale Shark", "Wombat"]
    
    private var animalsDict: [String: [String]] = [:]
    private var animalSectionTitles: [String] = []
    private let animalIndexTitles: [String] = ["A", "B", "C","D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAnimalDict()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return animalSectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return animalSectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        let firstLetter = animalSectionTitles[section]
        guard let animalValues = animalsDict[firstLetter] else {
            return 0
        }
        
        return animalValues.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        let firstLetter = animalSectionTitles[indexPath.section]
        if let animalValues = animalsDict[firstLetter]{
            cell.textLabel?.text = animalValues[indexPath.row]
            
            // Convert animals name to lower case and replace space " " by "_"
            let imageFilename = animalValues[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "_")
            cell.imageView?.image = UIImage(named: imageFilename)
            
        }
        
        return cell
    }
    func createAnimalDict() {
        for animal in animals {
            
            let firstLetter = String(animal.prefix(1))
            if var animalValues = animalsDict[firstLetter] {
                animalValues.append(animal)
                animalsDict[firstLetter] = animalValues
            } else {
                animalsDict[firstLetter] = [animal]
            }
            
            // Get key from dict and sort by section title
            animalSectionTitles = [String](animalsDict.keys)
            animalSectionTitles = animalSectionTitles.sorted (by: { $0 < $1 })
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return animalIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        guard let index = animalSectionTitles.firstIndex(of: title) else {
            return -1
        }
        
        return index
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection setcion: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = UIColor(red: 236.0/255.0, green: 76.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        headerView.textLabel?.textColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        
        headerView.textLabel?.font = UIFont(name: "Avenir", size: 25.0)
    }


}
