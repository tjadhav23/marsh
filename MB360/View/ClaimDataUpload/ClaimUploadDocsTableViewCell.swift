//
//  ClaimUploadDocsTableViewCell.swift
//  MyBenefits360
//
//  Created by Thynksight on 12/10/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit

class ClaimUploadDocsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnView: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var vewMain: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
