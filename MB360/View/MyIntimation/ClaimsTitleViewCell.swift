//
//  ClaimsTitleViewCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 08/08/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class ClaimsTitleViewCell: UITableViewCell {
    
    @IBOutlet weak var m_claimNumber: UILabel!
    

    @IBOutlet weak var backDetailsView: UIView!
   
    @IBOutlet weak var IntimationNo: UILabel!
    
    @IBOutlet weak var lblIntimationNo: UILabel!
    
    @IBOutlet weak var claimantHeader: UILabel!
    
    @IBOutlet weak var m_nameLbl: UILabel!
    
    @IBOutlet weak var claimIntimatedOnHeader: UILabel!
    
    @IBOutlet weak var m_claimDateLbl: UILabel!
    
    
    @IBOutlet weak var m_expandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupFontUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFontUI(){
        
        IntimationNo.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        IntimationNo.textColor = FontsConstant.shared.app_FontSecondryColor
        
        lblIntimationNo.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        lblIntimationNo.textColor = FontsConstant.shared.app_FontBlackColor
        
        claimantHeader.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        claimantHeader.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_nameLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_nameLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        claimIntimatedOnHeader.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        claimIntimatedOnHeader.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_claimDateLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_claimDateLbl.textColor = FontsConstant.shared.app_FontBlackColor
    }
        
}
