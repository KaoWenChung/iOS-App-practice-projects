//
//  IconTableViewCell.swift
//  IconStore
//
//  Created by wyn on 2020/5/26.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

class IconTableViewCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!{
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
