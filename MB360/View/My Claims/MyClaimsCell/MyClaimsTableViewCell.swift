//
//  MyClaimsTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 16/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class MyClaimsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var m_totalClaimsCountButton: UIButton!
    @IBOutlet weak var m_totalClaimsLbl: UILabel!
    @IBOutlet weak var m_reimbursementNumberButton: UIButton!
    @IBOutlet weak var m_cashlessNumberButton: UIButton!
    @IBOutlet weak var claimNumberDetailsView: UIView!
    
    @IBOutlet weak var m_dataNotFoundView: UIView!
    
    
    
    @IBOutlet weak var m_statusLbl: UILabel!
    
    @IBOutlet weak var m_backGroundView: UIView!
    
    // Top start
    @IBOutlet weak var m_nameLbl: UILabel!
    
    @IBOutlet weak var m_typeButton: UIButton!
    
    @IBOutlet weak var m_liveStatusButton: UIButton!
    
    @IBOutlet weak var m_claimTypeTitleLbl: UILabel!
    @IBOutlet weak var m_claimTypeLbl: UILabel!
    
    @IBOutlet weak var m_claimDateTitleLbl: UILabel!
    @IBOutlet weak var m_claimDateLbl: UILabel!
    
    @IBOutlet weak var m_ClaimNumberTitle: UILabel!
    @IBOutlet weak var m_claimNumberLbl: UILabel!
    
    @IBOutlet weak var m_claimAmountTitleLbl: UILabel!
    @IBOutlet weak var m_claimAmountLbl: UILabel!
    
    @IBOutlet weak var m_claimStatusTitleLbl: UILabel!
    @IBOutlet weak var m_claimStatusLbl: UILabel!
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.setupFontsUI()
        
    }
    
    func setupFontsUI(){
        
        m_nameLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        m_nameLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_typeButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        
        m_claimTypeTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        m_claimTypeTitleLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_claimTypeLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        //m_claimTypeLbl.textColor = FontsConstant.shared.HosptailLblTertiary
        
        m_claimDateTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        m_claimDateTitleLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_claimDateLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_claimDateLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_ClaimNumberTitle.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        m_ClaimNumberTitle.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_claimNumberLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_claimNumberLbl.textColor = FontsConstant.shared.app_FontBlackColor
       
        m_claimAmountTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        m_claimAmountTitleLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_claimAmountLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_claimAmountLbl.textColor = FontsConstant.shared.app_FontBlackColor
       
        m_claimStatusTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        m_claimStatusTitleLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_claimStatusLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_claimStatusLbl.textColor = FontsConstant.shared.app_FontBlackColor
       
      
        
    }
    
}
