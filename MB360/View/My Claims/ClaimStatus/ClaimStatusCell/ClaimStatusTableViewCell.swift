//
//  ClaimStatusTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 16/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class ClaimStatusTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var m_statusLbl: UILabel!
    
    @IBOutlet weak var m_title6Lbl: UILabel!
    @IBOutlet weak var m_title5Lbl: UILabel!
    @IBOutlet weak var m_title4Lbl: UILabel!
    @IBOutlet weak var m_title3Lbl: UILabel!
    @IBOutlet weak var m_title2Lbl: UILabel!
    @IBOutlet weak var m_title1Lbl: UILabel!
    @IBOutlet weak var m_genderLbl: UILabel!
    @IBOutlet weak var m_relationLbl: UILabel!
    @IBOutlet weak var TPACodeLbl: UILabel!
    @IBOutlet weak var m_policyPeriodLbl: UILabel!
    @IBOutlet weak var m_policyNoLbl: UILabel!
    @IBOutlet weak var m_nameLbl: UILabel!
    @IBOutlet weak var m_statusButton: UIButton!
    @IBOutlet weak var m_backGroundView: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
