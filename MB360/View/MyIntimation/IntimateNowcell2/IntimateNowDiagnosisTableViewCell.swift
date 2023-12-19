//
//  IntimateNowDiagnosisTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 13/02/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class IntimateNowDiagnosisTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var m_diagnosisTextView: UITextView!
    @IBOutlet weak var m_errorMsgLbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
