//
//  GMCTableViewCell.swift
//  MyBenefits360
//
//  Created by Semantic on 13/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class GMCTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainimageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
