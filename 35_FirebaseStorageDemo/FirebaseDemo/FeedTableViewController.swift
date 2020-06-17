//
//  FeedTableViewController.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 21/6/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import ImagePicker
import Firebase

class FeedTableViewController: UITableViewController {
    
    var postfeed: [Post] = []
    fileprivate var isLoadingPost = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the Drop-down update
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.black
        refreshControl?.tintColor = UIColor.white
        refreshControl?.addTarget(self, action: #selector(loadRecentPosts), for: UIControl.Event.valueChanged)
        
        // Load recent post
        loadRecentPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openCamera(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Handle post download and display
    
    @objc fileprivate func loadRecentPosts() {
        
        isLoadingPost = true
        
        PostService.shared.getRecentPosts(start: postfeed.first?.timestamp, limit: 10) { (newPosts) in
            
            if newPosts.count > 0 {
                // Add post array to beginning of the array
                self.postfeed.insert(contentsOf: newPosts, at: 0)
            }
            
            self.isLoadingPost = false
            
            if let _ = self.refreshControl?.isRefreshing {
                // Because of better of animation effect, delay 0.5 second after updated
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.refreshControl?.endRefreshing()
                    self.displayNewPosts(newPosts: newPosts)
                })
            } else {
                self.displayNewPosts(newPosts: newPosts)
            }
        }
    }
    
    private func displayNewPosts(newPosts posts: [Post]) {
        // Confirm that we get new post to display
        guard posts.count > 0 else {
            return
        }
        
        // Inset posts to tableView to display
        var indexPaths: [IndexPath] = []
        self.tableView.beginUpdates()
        for num in 0...(posts.count - 1) {
            let indexPath = IndexPath(row: num, section: 0)
            indexPaths.append(indexPath)
        }
        self.tableView.insertRows(at: indexPaths, with: .fade)
        self.tableView.endUpdates()
    }
}

// MARK: ImagePicker Delegate

extension FeedTableViewController: ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        // Get the first image
        guard let image = images.first else {
            dismiss(animated: true, completion: nil)
            
            return
        }
        
        // Update image to service
        PostService.shared.uploadImage(image: image) {
            self.dismiss(animated: true, completion: nil)
            self.loadRecentPosts()
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource method

extension FeedTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
        
        let currentPost = postfeed[indexPath.row]
        cell.configure(post: currentPost)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postfeed.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Upload when user slide to the last two rows
        guard !isLoadingPost, postfeed.count - indexPath.row == 2 else {
            return
        }
        
        isLoadingPost = true
        
        guard let lastPostTimestamp = postfeed.last?.timestamp else {
            isLoadingPost = false
            return
        }
        
        PostService.shared.getOldPosts(start: lastPostTimestamp, limit: 3) { (newPosts) in
            // Add new post to current array and tableView
            var indexPaths:[IndexPath] = []
            self.tableView.beginUpdates()
            for newPost in newPosts {
                self.postfeed.append(newPost)
                let indexPath = IndexPath(row: self.postfeed.count - 1, section: 0)
                indexPaths.append(indexPath)
            }
            self.tableView.insertRows(at: indexPaths, with: .fade)
            self.tableView.endUpdates()
            
            self.isLoadingPost = false
        }
    }
}
