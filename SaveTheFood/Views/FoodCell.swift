//
//  FoodCell.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-08-16.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var foodNameLabel: UILabel!
    @IBOutlet var foodImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
