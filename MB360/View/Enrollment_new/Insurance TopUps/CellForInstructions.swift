//
//  CellForInstructions.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 24/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForInstructions: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblDescription.font = Font(.installed(.MontserratRegular), size: .standard(.h4)).instance
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
