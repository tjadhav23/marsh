//
//  ParentalSectionHeaderCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 13/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class ParentalSectionHeaderCell: UITableViewCell {

    @IBOutlet weak var lblSumInsured: UILabel!
    @IBOutlet weak var lblSetOfParents: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var backView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
       // self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.backView.backgroundColor = UIColor.clear
        self.backView.setCornerRadius()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
