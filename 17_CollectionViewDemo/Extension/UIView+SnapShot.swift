//
//  UIView+SnapShot.swift
//  CollectionViewDemo
//
//  Created by wyn on 2020/5/13.
//  Copyright © 2020 AppCoda. All rights reserved.
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
