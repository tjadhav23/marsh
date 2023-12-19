//
//  CellForNextButtonBottom.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 07/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForNextButtonBottom: UITableViewCell {

    @IBOutlet weak var btnNext: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnNext.makeCicular()
        btnNext.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
