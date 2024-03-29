//
//  HotelTableViewCell.swift
//  SelfSizingCell
//
//  Created by Simon Ng on 24/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class HotelTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel:UILabel! {
        didSet {
            nameLabel.adjustsFontForContentSizeCategory = false
        }
    }
    @IBOutlet weak var addressLabel:UILabel! {
        didSet {
            addressLabel.adjustsFontForContentSizeCategory = false
        }
    }
    @IBOutlet weak var descriptionLabel:UILabel! {
        didSet {
            descriptionLabel.adjustsFontForContentSizeCategory = false
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

}
