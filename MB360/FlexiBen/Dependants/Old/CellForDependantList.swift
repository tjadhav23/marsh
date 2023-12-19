//
//  CellForDependantList.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 05/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForDependantList: UITableViewCell {

    
    @IBOutlet weak var m_premiumStatementLbl: UILabel!
    @IBOutlet weak var m_titleLbl: UILabel!
    @IBOutlet weak var m_backGroundView: UIView!
    
    @IBOutlet weak var m_nameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var m_dobTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var m_ageTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var m_editButton: UIButton!

    @IBOutlet weak var m_deleteButton: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var m_parentalPremiumAmountLbl: UILabel!
    
    @IBOutlet weak var m_acceptConditionsButton: UIButton!
    @IBOutlet weak var heightBtnConstant: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        m_editButton.makeCicular()
        m_deleteButton.makeCicular()
        
        m_editButton.layer.masksToBounds=true
        m_deleteButton.layer.masksToBounds=true
    }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
