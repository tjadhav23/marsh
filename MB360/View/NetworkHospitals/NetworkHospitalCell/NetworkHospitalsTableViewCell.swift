//
//  NetworkHospitalsTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 18/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class NetworkHospitalsTableViewCell: UITableViewCell {
    @IBOutlet weak var m_searchNearbyButton: UIButton!
    
    @IBOutlet weak var NumberOfHospitalHeaderLbl: UILabel!
    @IBOutlet weak var m_totalCountLbl: UILabel!
    @IBOutlet weak var m_tertiaryCountLbl: UILabel!
    @IBOutlet weak var m_secondaryCountLbl: UILabel!
    @IBOutlet weak var m_primaryCountLbl: UILabel!
    @IBOutlet weak var m_headerTitleView: UIView!
    @IBOutlet weak var m_headerView: UIView!
    @IBOutlet weak var m_naLbelLeadingConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var m_nonCareHospitalCountView: UIView!
    @IBOutlet weak var m_withoutCareHospitalCount: UILabel!
    @IBOutlet weak var m_searchNearbyButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_tertiaryCountButton: UIButton!
    
    @IBOutlet weak var m_secondaryCountButton: UIButton!
    
    @IBOutlet weak var secondaryLbl: UILabel!
    @IBOutlet weak var m_primaryCountButton: UIButton!
    
    @IBOutlet weak var tertiayLbl: UILabel!
    
    @IBOutlet weak var m_OtherCountLbl: UIButton!
    @IBOutlet weak var m_OtherCountButton: UIButton!
    @IBOutlet weak var otherLbl: UILabel!
    
    
   
  
    @IBOutlet weak var m_topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var m_contactNumberButton: UIButton!
    @IBOutlet weak var m_colorCodeLbl: UILabel!
    @IBOutlet weak var m_backGroundView: UIView!
    @IBOutlet weak var m_smsButton: UIButton!
    @IBOutlet weak var m_showMapButton: UIButton!
    @IBOutlet weak var m_contactDetailsLbl: UILabel!
    @IBOutlet weak var m_levelLbl: UILabel!
    @IBOutlet weak var m_locationLbl: UILabel!
    @IBOutlet weak var m_nameLbl: UILabel!
    
    //addedby geeta
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var numberLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //m_headerTitleView.backgroundColor = FontsConstant.shared.app_ViewBGColor
        self.setupFontsUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         // Configure the view for the selected state
    }
    
    func setupFontsUI(){
        //Header
        NumberOfHospitalHeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        NumberOfHospitalHeaderLbl.textColor =  FontsConstant.shared.app_FontBlackColor
      
        
        m_totalCountLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        m_totalCountLbl.textColor =  FontsConstant.shared.app_FontBlackColor
      
        
        //Number count
        m_primaryCountButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        m_primaryCountButton.titleLabel?.textColor =  FontsConstant.shared.app_FontBlackColor
        
        m_secondaryCountButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        m_secondaryCountButton.titleLabel?.textColor =  FontsConstant.shared.app_FontBlackColor
        
        m_tertiaryCountButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        m_tertiaryCountButton.titleLabel?.textColor =  FontsConstant.shared.app_FontBlackColor
        
        m_OtherCountButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        m_OtherCountButton.titleLabel?.textColor =  FontsConstant.shared.app_FontBlackColor
        
        
        
        //Lbl Text
        m_primaryCountLbl.font =  UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        m_primaryCountLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        secondaryLbl.font =  UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        secondaryLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        tertiayLbl.font =  UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        tertiayLbl.textColor = FontsConstant.shared.app_FontBlackColor
     
        
        otherLbl.font =  UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        otherLbl.textColor = FontsConstant.shared.app_FontBlackColor
     
     
        //Search Button
        
        m_searchNearbyButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        m_searchNearbyButton.titleLabel?.textColor =  FontsConstant.shared.app_FontBlackColor
        m_searchNearbyButton.backgroundColor = FontsConstant.shared.app_ViewBGColor
        
        
        //Mback Ground View fonts
        m_nameLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        m_nameLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        m_contactDetailsLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_contactDetailsLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        
        m_smsButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        m_smsButton.titleLabel?.textColor = FontsConstant.shared.app_FontAppColor
        
        
        m_locationLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_locationLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        
        distanceLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        distanceLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        
        numberLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h13))
        numberLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        m_showMapButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        m_showMapButton.titleLabel?.textColor = FontsConstant.shared.app_FontPrimaryColor
       
        m_contactNumberButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_contactNumberButton.titleLabel?.textColor = FontsConstant.shared.app_FontAppColor
        
        m_levelLbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        m_levelLbl.textColor = FontsConstant.shared.app_FontSecondryColor
     
        
    }
}
