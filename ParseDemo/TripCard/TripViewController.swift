//
//  TripViewController.swift
//  TripCard
//
//  Created by Simon Ng on 8/11/2019.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import Parse

class TripViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TripCollectionCellDelegate {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    private var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTripsFromParse()
        
        // Set swipe gesture
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeUpRecognizer.direction = .up
        swipeUpRecognizer.delegate = self
        self.collectionView.addGestureRecognizer(swipeUpRecognizer)
        
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: "cloud")
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        // Make the colleciton view transparent
        collectionView.backgroundColor = UIColor.clear
     
        if UIScreen.main.bounds.size.height == 568.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSize(width: 250.0, height: 330.0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Collection view delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TripCollectionViewCell
        
        // Configure the cell
        cell.cityLabel.text = trips[indexPath.row].city
        cell.countryLabel.text = trips[indexPath.row].country
        cell.priceLabel.text = "$\(String(trips[indexPath.row].price))"
        cell.totalDaysLabel.text = "\(trips[indexPath.row].totalDays) days"
        cell.isLiked = trips[indexPath.row].isLiked
        cell.delegate = self
        
        // Load image at background
        cell.imageView.image = UIImage()
        if let featuredImage = trips[indexPath.row].featuredImage {
            featuredImage.getDataInBackground(block: { (imageData, error) in
                if let tripImageData = imageData {
                    cell.imageView.image = UIImage(data: tripImageData)
                }
            })
        }
        
        // Apply round corner
        cell.layer.cornerRadius = 4.0
        
        return cell
    }
    
    // MARK: - TripCollectionCellDelegate methods
    
    func didLikeButtonPressed(cell: TripCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            trips[indexPath.row].isLiked = trips[indexPath.row].isLiked ? false : true
            cell.isLiked = trips[indexPath.row].isLiked
            
            // Update trip data on parse
            trips[indexPath.row].toPFObject().saveInBackground(block: { (success, error) -> Void in
                if (success) {
                    print("Successfully updated the trip")
                } else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                }
            })
        }
    }
    
    func loadTripsFromParse() {
        // Clear the array
        trips.removeAll(keepingCapacity: true)
        collectionView.reloadData()
        
        // Get data from parse
        let query = PFQuery(className: "Trip")
        query.cachePolicy = PFCachePolicy.networkElseCache
        query.findObjectsInBackground{ (objects, error) -> Void in
            if let error = error {
                print("Error: \(error)\(error.localizedDescription)")
                return
            }
            
            if let objects = objects {
                for (index, object) in objects.enumerated() {
                    // Transform PFObject to Trip object
                    let trip = Trip(pfObject: object)
                    self.trips.append(trip)
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    self.collectionView.insertItems(at: [indexPath])
                }
            }
        }
        
    }
    
    @IBAction func reloadButtonTapped(sender: Any) {
        loadTripsFromParse()
    }
}

extension TripViewController: UIGestureRecognizerDelegate {
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        let point = gesture.location(in: self.collectionView)
        
        if (gesture.state == UIGestureRecognizer.State.ended) {
            if let indexPath = collectionView.indexPathForItem(at: point) {
                // Delete trip, array and collectionView from parse
                trips[indexPath.row].toPFObject().deleteInBackground(block: { (success, error) -> Void in
                    if (success) {
                        print("Successfully removed the trip")
                    } else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    self.trips.remove(at: indexPath.row)
                    self.collectionView.deleteItems(at: [indexPath])
                })
            }
        }
    }
}
