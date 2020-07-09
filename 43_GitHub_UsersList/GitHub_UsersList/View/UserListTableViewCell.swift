//
//  UserListTableViewCell.swift
//  GitHub_UsersList
//
//  Created by wyn on 2020/6/29.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var siteAdmin: UIImageView!
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.layer.cornerRadius = 36.0
            userImage.clipsToBounds = true
        }
    }
    
    private var urlString:String = ""
    
    // Setup users values
    func setCellWithValuesOf(_ user:User) {
        updateUI(name: user.name, image: user.image, badge: user.badge)
    }
    
    // Update the UI views
    private func updateUI(name: String?, image: String?, badge: Bool?) {
        
        self.nameLabel.text = name
        
        // Display badge
        if badge == false {
            self.siteAdmin.isHidden = true
        }
        
        guard let ImageString = image else { return }
        urlString = ImageString
        
        guard let userImageURL = URL(string: urlString) else {
            self.userImage.image = UIImage(named: "noImageAvailable")
            return
        }
        
        // Before we download the image, clear out the old one
        self.userImage.image = nil
        
        getImageDataFrom(url: userImageURL)
    }
    
    // MARK: - Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { ( data, response, error ) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.userImage.image = image
                }
            }
        }.resume()
    }
}
