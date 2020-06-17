//
//  UIView+Snapshot.swift
//  CollectionViewDemo
//
//  Created by Simon Ng on 23/11/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

extension UIView {
    var snapshot: UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
        return image
    }
}
