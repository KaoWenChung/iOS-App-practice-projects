//
//  PostCell.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 21/6/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    private var currentPost: Post?
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var voteButton: LineButton! {
        didSet {
            voteButton.tintColor = .white
        }
    }

    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
            avatarImageView.clipsToBounds = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(post: Post) {
        
        // set currently post
        currentPost = post
        
        // Configure the cell...
        selectionStyle = .none
        
        // Configure the user name and votes
        nameLabel.text = post.user
        voteButton.setTitle("\(post.votes)", for: .normal)
        voteButton.tintColor = .white
        
        // Reset the image of imageView
        photoImageView.image = nil
        
        // Download the post photo
        if let image = CacheManager.shared.getFromCache(key: post.imageFileURL) as? UIImage {
            photoImageView.image = image
        } else {
            if let url = URL(string: post.imageFileURL) {
                
                let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    guard let imageData = data else {
                        return
                    }
                    
                    OperationQueue.main.addOperation {
                        guard let image = UIImage(data: imageData) else { return }
                        if self.currentPost?.imageFileURL == post.imageFileURL {
                            self.photoImageView.image = image
                        }
                        
                        // Add download image to cachedata
                        CacheManager.shared.cache(object: image, key: post.imageFileURL)
                    }
                })
                
                downloadTask.resume()
            }
        }
        
    }

}
