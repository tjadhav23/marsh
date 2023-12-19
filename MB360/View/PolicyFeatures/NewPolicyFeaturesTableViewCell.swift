//
//  NewPolicyFeaturesTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 20/02/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
class ExpandedPolicyDetailsCellold
{
    
    var otherInfo = Array<PolicyFeaturesDetails>()
    var expanded : Bool
    
    init(otherInfo : Array<PolicyFeaturesDetails>)
    {
        
        self.otherInfo = otherInfo
        self.expanded = false
    }
}
class NewPolicyFeaturesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var m_backGroundView: UIView!
    
    @IBOutlet weak var m_titleView: UIView!
    
    @IBOutlet weak var m_titleLbl: UILabel!
    
    @IBOutlet weak var m_titleImageView: UIImageView!
    
    @IBOutlet weak var m_policyInfoLbl1: UILabel!
    
    @IBOutlet weak var termsConditionsLbl1: UILabel!
    
    @IBOutlet weak var m_policyInfoLbl2: UILabel!
    
    @IBOutlet weak var termsConditionsLbl3: UILabel!
    @IBOutlet weak var termsConditionsLbl2: UILabel!
    @IBOutlet weak var m_policyInfoLbl4: UILabel!
    @IBOutlet weak var m_policyInfoLbl3: UILabel!
    
    @IBOutlet weak var termsConditionsLbl4: UILabel!
    
    
    @IBOutlet weak var m_expandButton: UIButton!
    @IBOutlet weak var m_detailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var m_expandButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_backgroundViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var m_detailView: UIStackView!
    
    
    
    
    func setContentForPolocyFeatures(data:ExpandedPolicyDetailsCellold)
    {
        if(data.expanded)
        {
            m_detailView.isHidden=false
            
        }
        else
        {
            
            m_detailView.isHidden=true
            
        }
    }
}
