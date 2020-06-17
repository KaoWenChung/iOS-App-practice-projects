//
//  Icon.swift
//  CollectionViewDemo
//
//  Created by Simon Ng on 22/11/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

struct Icon {
    var name: String = ""
    var imageName = ""
    var description = ""
    var price: Double = 0.0
    var isFeatured: Bool = false
    
    init(name: String, imageName: String, description: String, price: Double, isFeatured: Bool) {
        self.name = name
        self.imageName = imageName
        self.description = description
        self.price = price
        self.isFeatured = isFeatured
    }
}
