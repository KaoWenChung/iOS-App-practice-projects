//
//  IconCollectionViewController.swift
//  CollectionViewDemo
//
//  Created by Simon Ng on 22/11/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class IconCollectionViewController: UICollectionViewController {
    
    @IBOutlet var shareButton: UIBarButtonItem!
    
    private var shareEnabled = false
    private var selectedIcons: [(icon: Icon, snapshot: UIImage)] = []
    private var iconSet: [Icon] = [ Icon(name: "Candle icon", imageName: "candle", description: "Halloween icons designed by Tania Raskalova.", price: 3.99, isFeatured: false),
                                    Icon(name: "Cat icon", imageName: "cat", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: true),
                                    Icon(name: "dribbble", imageName: "dribbble", description: "Halloween icon designed by Tania Raskalova.", price: 1.99, isFeatured: false),
                                    Icon(name: "Ghost icon", imageName: "ghost", description: "Halloween icon designed by Tania Raskalova.", price: 4.99, isFeatured: false),
                                    Icon(name: "Hat icon", imageName: "hat", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: false),
                                    Icon(name: "Owl icon", imageName: "owl", description: "Halloween icon designed by Tania Raskalova.", price: 5.99, isFeatured: true),
                                    Icon(name: "Pot icon", imageName: "pot", description: "Halloween icon designed by Tania Raskalova.", price: 1.99, isFeatured: false),
                                    Icon(name: "Pumkin icon", imageName: "pumkin", description: "Halloween icon designed by Tania Raskalova.", price: 0.99, isFeatured: false),
                                    Icon(name: "RIP icon", imageName: "rip", description: "Halloween icon designed by Tania Raskalova.", price: 7.99, isFeatured: false),
                                    Icon(name: "Skull icon", imageName: "skull", description: "Halloween icon designed by Tania Raskalova.", price: 8.99, isFeatured: false),
                                    Icon(name: "Sky icon", imageName: "sky", description: "Halloween icon designed by Tania Raskalova.", price: 0.99, isFeatured: false),
                                    Icon(name: "Toxic icon", imageName: "toxic", description: "Halloween icon designed by Tania Raskalova.", price: 2.99, isFeatured: false),
                                    Icon(name: "Book icon", imageName: "ic_book", description: "Colorful icon designed by Marin Begović.", price: 2.99, isFeatured: false),
                                    Icon(name: "Backpack icon", imageName: "ic_backpack", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: false),
                                    Icon(name: "Camera icon", imageName: "ic_camera", description: "Colorful camera icon designed by Marin Begović.", price: 4.99, isFeatured: false),
                                    Icon(name: "Coffee icon", imageName: "ic_coffee", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: true),
                                    Icon(name: "Glasses icon", imageName: "ic_glasses", description: "Colorful icon designed by Marin Begović.", price: 3.99, isFeatured: false),
                                    Icon(name: "Icecream icon", imageName: "ic_ice_cream", description: "Colorful icon designed by Marin Begović.", price: 4.99, isFeatured: false),
                                    Icon(name: "Smoking pipe icon", imageName: "ic_smoking_pipe", description: "Colorful icon designed by Marin Begović.", price: 6.99, isFeatured: false),
                                    Icon(name: "Vespa icon", imageName: "ic_vespa", description: "Colorful icon designed by Marin Begović.", price: 9.99, isFeatured: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items
        return iconSet.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IconCollectionViewCell
        
        // Configure the cell
        let icon = iconSet[indexPath.row]
        cell.iconImageView.image = UIImage(named: icon.imageName)
        cell.iconPriceLabel.text = "$\(icon.price)"
        cell.backgroundView = (icon.isFeatured) ? UIImageView(image: UIImage(named: "feature-bg")) : nil
        cell.selectedBackgroundView = UIImageView(image: UIImage(named: "icon-selected"))
        
        return cell
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIconDetail" {
            if let indexPaths = collectionView?.indexPathsForSelectedItems {
                let destinationController = segue.destination as! IconDetailViewController
                destinationController.icon = iconSet[indexPaths[0].row]
                collectionView?.deselectItem(at: indexPaths[0], animated: false)
            }
        }
    }
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        
        guard shareEnabled else {
            // Change shareEnabled to yes and change button text to done
            shareEnabled = true
            collectionView?.allowsMultipleSelection = true
            shareButton.title = "Done"
            shareButton.style = UIBarButtonItem.Style.plain
            
            return
        }
        
        // Check selected at least one icon
        guard selectedIcons.count > 0 else {
            return
        }
        
        // Get snapshot from selected icon
        let snapshots = selectedIcons.map{ $0.snapshot }
        
        // Create view controller to share
        let activityController = UIActivityViewController(activityItems: snapshots, applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { (activityType, completed, returnedItem, error) in
            // Cancel all of the selected items
            if let indexPaths = self.collectionView?.indexPathsForSelectedItems {
                for indexPath in indexPaths {
                    self.collectionView?.deselectItem(at: indexPath, animated: false)
                }
            }
            
            // Remove all of the items in selectedIcon array
            self.selectedIcons.removeAll(keepingCapacity: true)
            
            // Turn share mode to NO
            self.shareEnabled = false
            self.collectionView?.allowsMultipleSelection = false
            self.shareButton.title = "Share"
            self.shareButton.style = UIBarButtonItem.Style.plain
        }
        
        present(activityController, animated: true, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Check share mode turn on or not, return if it's not
        guard shareEnabled else {
            return
        }
        
        // Use indexPath to determine selected item and bring into a snapshot
        let selectedIcon = iconSet[indexPath.row]
        if let snapshot = collectionView.cellForItem(at: indexPath)?.snapshot {
            // Add the selected item into an array
            selectedIcons.append((icon: selectedIcon, snapshot: snapshot))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Check share mode turn on or not, return if it's not
        guard shareEnabled else {
            return
        }
        
        let deSelectedIcon = iconSet[indexPath.row]
        
        // Find selected indexPath, use the index method to send a closure. compare deSelected icon and selected icon in the closure. Return the index and delete it if the name conform
        
        if let index = selectedIcons.firstIndex(where: { $0.icon.name == deSelectedIcon.name }) {
            selectedIcons.remove(at: index)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showIconDetail" {
            if shareEnabled {
                return false
            }
        }
        
        return true
    }
}
