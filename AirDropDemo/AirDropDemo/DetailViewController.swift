//
//  DetailViewController.swift
//  AirDropDemo
//
//  Created by Simon Ng on 18/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var actionButtonItem: UIBarButtonItem!
    
    var filename = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the full path of the file
        if let fileURL = fileToURL(file: filename) {
            let urlRequest = URLRequest(url: fileURL)
            webView.load(urlRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fileToURL(file: String) -> URL? {
        // Get the full path of the file
        let fileComponents = file.components(separatedBy: ".")
        
        if let filePath = Bundle.main.path(forResource: fileComponents[0], ofType: fileComponents[1]) {
            return URL(fileURLWithPath: filePath) 
        }
        
        return nil
    }
    
    @IBAction func share(sender: AnyObject) {
        if let fileURL = fileToURL(file: filename) {
            let objectsToShare = [fileURL]
            let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            let excludedActivities = [UIActivity.ActivityType.postToFlickr,
                                      UIActivity.ActivityType.postToWeibo,
                                      UIActivity.ActivityType.message,
                                      UIActivity.ActivityType.mail,
                                      UIActivity.ActivityType.print,
                                      UIActivity.ActivityType.copyToPasteboard,
                                      UIActivity.ActivityType.assignToContact,
                                      UIActivity.ActivityType.saveToCameraRoll,
                                      UIActivity.ActivityType.addToReadingList,
                                      UIActivity.ActivityType.postToFlickr,
                                      UIActivity.ActivityType.postToVimeo,
                                      UIActivity.ActivityType.postToTencentWeibo]
            
            activityController.excludedActivityTypes = excludedActivities
            
            if let popOverController = activityController.popoverPresentationController {
                popOverController.barButtonItem = actionButtonItem
            }
            
            present(activityController, animated: true, completion: nil)
            
        }
    }
}
