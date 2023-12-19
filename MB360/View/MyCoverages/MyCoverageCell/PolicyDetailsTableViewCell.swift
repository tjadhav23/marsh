//
//  PolicyDetailsTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 13/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class PolicyDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var m_headerView: UIView!
    
    @IBOutlet weak var m_polocyDateLbl: UILabel!
    @IBOutlet weak var m_tpaLbl: UILabel!
    @IBOutlet weak var m_insurerLbl: UILabel!
    @IBOutlet weak var m_brokerLbl: UILabel!
    @IBOutlet weak var m_policyLbl: UILabel!
    @IBOutlet weak var m_headerTitleLbl: UILabel!
    @IBOutlet weak var m_groupNameLbl: UILabel!
    @IBOutlet weak var m_tpaNameLbl: UILabel!
    @IBOutlet weak var m_insurerNameLbl: UILabel!
    @IBOutlet weak var m_brokerNameLbl: UILabel!
    @IBOutlet weak var m_backgroundView: UIView!
   
    @IBOutlet weak var m_tpavalueBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_tpaTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_tpaTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFontsUI()
        m_headerView.backgroundColor = FontsConstant.shared.app_ViewBGColor2
        sizeToFit()
        layoutIfNeeded()
    }

    @IBOutlet weak var m_bottomVerticalConstraint: NSLayoutConstraint!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupFontsUI(){
        
        m_headerTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h15))
        m_headerTitleLbl.textColor = FontsConstant.shared.app_FontDarkGreyColor
        
        m_policyLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h12))
        m_policyLbl.textColor = FontsConstant.shared.app_mediumGrayColor
        
        m_groupNameLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_groupNameLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_polocyDateLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_polocyDateLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_brokerLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h12))
        m_brokerLbl.textColor = FontsConstant.shared.app_mediumGrayColor
        
        
        m_brokerNameLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_brokerNameLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        m_insurerLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h12))
        m_insurerLbl.textColor = FontsConstant.shared.app_mediumGrayColor
        
        m_insurerNameLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_insurerNameLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_tpaLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h12))
        m_tpaLbl.textColor = FontsConstant.shared.app_mediumGrayColor
        
       
        m_tpaNameLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_tpaNameLbl.textColor = FontsConstant.shared.app_FontBlackColor
       
    }

}
