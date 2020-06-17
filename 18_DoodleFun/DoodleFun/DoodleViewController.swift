//
//  DoodleViewController.swift
//  DoodleFun
//
//  Created by Simon Ng on 12/11/2019.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class DoodleViewController: UIViewController {
    private var doodleImages = ["DoodleIcons-1", "DoodleIcons-2", "DoodleIcons-3", "DoodleIcons-4", "DoodleIcons-5", "DoodleIcons-6", "DoodleIcons-7", "DoodleIcons-8", "DoodleIcons-9", "DoodleIcons-10", "DoodleIcons-11", "DoodleIcons-12", "DoodleIcons-13", "DoodleIcons-14", "DoodleIcons-15", "DoodleIcons-16", "DoodleIcons-17", "DoodleIcons-18", "DoodleIcons-19", "DoodleIcons-20"]
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewSize = collectionView.frame.size
        let collectionViewArea = Double(collectionViewSize.width * collectionViewSize.height)
        
        print(collectionViewSize.width)
        print(collectionViewSize.height)
        print(collectionViewArea)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        collectionView.reloadData()

    }
}

extension DoodleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return doodleImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DoodleCollectionViewCell
        
        cell.imageView.image = UIImage(named: doodleImages[indexPath.row])
        
        return cell
    }
}

extension DoodleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSize = (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular) ? 80.0 : 128.0
        return CGSize(width: sideSize, height: sideSize)
    }
}
