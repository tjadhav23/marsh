//
//  ProfileTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 20/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var m_backGroundView: UIView!
    
    @IBOutlet weak var m_selectButton: UIButton!
    @IBOutlet weak var m_detailsLbl: UILabel!
    @IBOutlet weak var m_iconImageView: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
