//
//  PolicyFeaturesTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 02/07/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
class ExpandedPolicyDetailsCell
{
    
    var otherInfo = Array<PolicyFeaturesDetails>()
    var expanded : Bool
    
    init(otherInfo : Array<PolicyFeaturesDetails>)
    {
        
        self.otherInfo = otherInfo
        self.expanded = false
    }
}
class PolicyFeaturesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBOutlet weak var term3BottomConstraint: UIView!
    @IBOutlet weak var m_infoLblTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var m_infoLbl4BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_infoLbl3BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_term4BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_term3BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_term2BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_term2TopConstraint: UIView!
    @IBOutlet weak var m_infolbl2BottomConstraint: UIView!
    
    
    @IBOutlet weak var m_detailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var m_backGroundView: UIView!
    
    @IBOutlet weak var m_titleView: UIView!
    
    @IBOutlet weak var m_titleLbl: UILabel!
    
    @IBOutlet weak var m_titleImageView: UIImageView!
    
    @IBOutlet weak var m_expandButton: UIButton!
    
    @IBOutlet weak var m_policyInfoLbl1: UILabel!
    
    @IBOutlet weak var termsConditionsLbl1: UILabel!
    
    @IBOutlet weak var m_policyInfoLbl2: UILabel!
    
    @IBOutlet weak var termsConditionsLbl3: UILabel!
    @IBOutlet weak var termsConditionsLbl2: UILabel!
    @IBOutlet weak var m_policyInfoLbl4: UILabel!
    @IBOutlet weak var m_policyInfoLbl3: UILabel!
    
    @IBOutlet weak var termsConditionsLbl4: UILabel!
    
    @IBOutlet weak var m_policyInfoLbl5: UILabel!
    
    @IBOutlet weak var termsConditionsLbl5: UILabel!
    
    @IBOutlet weak var m_policyInfoLbl6: UILabel!
    
    @IBOutlet weak var termsConditionsLbl6: UILabel!
    
    @IBOutlet weak var m_policyInfoLbl7: UILabel!
    
    @IBOutlet weak var termsConditionsLbl7: UILabel!
    
    @IBOutlet weak var m_policyInfoLbl8: UILabel!
    
    @IBOutlet weak var termsConditionsLbl8: UILabel!
    
    @IBOutlet weak var m_expandButtonHeightConstraint: NSLayoutConstraint!
    @IBAction func expandButtonClicked(_ sender: Any) {
    }
    @IBOutlet weak var m_backgroundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_detailsView: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setContentForPolocyFeatures(data:ExpandedPolicyDetailsCell)
    {
        if(data.expanded)
        {
            m_detailsView.isHidden=false
             
        }
        else
        {

            m_detailsView.isHidden=true
            
        }
    }
    
    func setContent(data:ExpandedPolicyDetailsCell)
    {
        if(data.expanded)
        {
           m_detailsView.isHidden=false
           
        }
        else
        {
            
           m_detailsView.isHidden=true
            
           
//            UIView.animate(withDuration: 0.5) { () -> Void in
//                self.m_detailsButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//            }
            
        }
    }
}
