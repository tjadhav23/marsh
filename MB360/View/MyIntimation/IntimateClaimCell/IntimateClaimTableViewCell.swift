//
//  IntimateClaimTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 17/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class IntimateClaimTableViewCell: UITableViewCell {
    @IBOutlet weak var m_leadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_selectButton: UIButton!
    
    @IBOutlet weak var m_diagnosisTextview: UITextView!
    @IBOutlet weak var m_errorMsglbl: UILabel!
    @IBOutlet weak var m_titleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
