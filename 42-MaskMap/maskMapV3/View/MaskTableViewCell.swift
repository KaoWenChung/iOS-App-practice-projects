//
//  MaskTableViewCell.swift
//  maskMapV3
//
//  Created by wyn on 2020/3/16.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit

class MaskTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var adultLabel: UILabel!
    @IBOutlet weak var childLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func setUpView(mask: Mask){
        nameLabel.text = mask.name
        addressLabel.text = mask.address
        telLabel.text = "Tel: \(mask.tel)"
        adultLabel.text = "Adult:\(mask.adultCount)"
        childLabel.text = "Child:\(mask.childCount)"
        timeLabel.text = "\(mask.time)"
    }
}
