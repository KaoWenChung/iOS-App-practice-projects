//
//  MaskDetailView.swift
//  maskMapV3
//
//  Created by wyn on 2020/6/27.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit

class MaskDetailView: UIView {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var adultLabel: UILabel!
    @IBOutlet var childLabel: UILabel!
    @IBOutlet var telLabel: UILabel!

    func initView(mask: Mask) {
        nameLabel.text = mask.name
        adultLabel.text = mask.adultCount.description
        childLabel.text = mask.childCount.description
        addressLabel.text = mask.address
        telLabel.text = mask.tel
    }
}
