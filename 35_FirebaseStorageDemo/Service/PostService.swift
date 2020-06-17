//
//  PostService.swift
//  FirebaseDemo
//
//  Created by wyn on 2020/6/4.
//  Copyright © 2020 Wyn. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

final class PostService {
    
    // MARK: - Property
    
    static let shared : PostService = PostService()
    
    private init() {  }
    
    // MARK: - Firebase Database reference
    
    let BASE_DB_REF: DatabaseReference = Database.database().reference()
    
    let POST_DB_REF: DatabaseReference = Database.database().reference().child("posts")
    
    // MARK: - Firebase Storage reference
    
    let PHOTO_STORAGE_REF: StorageReference = Storage.storage().reference().child("posts")
        
    // MARK: - Firebase upload and download method
    
    func uploadImage(image: UIImage, completionHandler: @escaping () -> Void) {
        
        // Create the only postID and prepared for post database reference
        let postDatabaseRef = POST_DB_REF.childByAutoId()
        
        // Use the only key for the image name and prepare for Storage reference
        guard let imageKey = postDatabaseRef.key else {
            return
        }
        
        let imageStorageRef = PHOTO_STORAGE_REF.child("\(imageKey).jpg")
        
        // Adjust the image size
        let scaledImage = image.scale(newWidth: 640.0)
        
        guard let imageData = scaledImage.jpegData(compressionQuality: 0.9) else {
            return
        }
        
        // Create metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // Prepare for upload task
        let uploadTask = imageStorageRef.putData(imageData, metadata: metadata)
        
        // observe the upload state
        uploadTask.observe(.success) { (snapshot) in
            
            guard let displayName = Auth.auth().currentUser?.displayName else {
                return
            }
            
            // Add a reference on the database
            snapshot.reference.downloadURL(completion: { (url, error) in
                guard let url = url else {
                    return
                }
                
                // Add a reference on the database
                let imageFileURL = url.absoluteString
                let timestamp = Int(Date().timeIntervalSince1970 * 1000)
                
                let post: [String: Any] = ["imageFileURL" : imageFileURL,
                                           "votes" : Int(0),
                                           "user" : displayName,
                                           "timestamp" : timestamp]
                
                postDatabaseRef.setValue(post)
                
            })
            
            completionHandler()
            
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("Uploading... \(percentComplete)% complete")
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getRecentPosts(start timestamp: Int? = nil, limit: UInt, completionHandler: @escaping ([Post]) -> Void) {
        
        var postQuery = POST_DB_REF.queryOrdered(byChild: Post.PostInfoKey.timestamp)
        if let latestPostTimestamp = timestamp, latestPostTimestamp > 0 {
            // If there is a specified time stamp, we will get the post with a new time stamp than the given value
            postQuery = postQuery.queryStarting(atValue: latestPostTimestamp + 1, childKey: Post.PostInfoKey.timestamp).queryLimited(toLast: limit)
        } else {
            // If not, we get the recently posts
            postQuery = postQuery.queryLimited(toLast: limit)
        }
        
        // Call Firebase API to get the recentest record
        postQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var newPosts: [Post] = []
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let postInfo = item.value as? [String: Any] ?? [:]
                
                if let post = Post(postId: item.key, postInfo: postInfo) {
                    newPosts.append(post)
                }
            }
            
            if newPosts.count > 0 {
                // Sort by descending power (that is, the latest post becomes the first post)
                newPosts.sort(by: { $0.timestamp > $1.timestamp})
            }
            completionHandler(newPosts)
        })
    }
    
    func getOldPosts(start timestamp: Int, limit: UInt, completionHandler: @escaping ([Post]) -> Void) {
        
        let postOrderedQuery = POST_DB_REF.queryOrdered(byChild: Post.PostInfoKey.timestamp)
        let postLimitedQuery = postOrderedQuery.queryEnding(atValue: timestamp - 1, childKey: Post.PostInfoKey.timestamp).queryLimited(toLast: limit)
        
        postLimitedQuery.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var newPosts: [Post] = []
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                print("Post key: \(item.key)")
                let postInfo = item.value as? [String: Any] ?? [:]
                
                if let post = Post(postId: item.key, postInfo: postInfo) {
                    newPosts.append(post)
                }
                
                // Sort by descending power (that is, the latest post becomes the first post)
                newPosts.sort(by: { $0.timestamp > $1.timestamp })
                completionHandler(newPosts)
            }
        })
    }
}
