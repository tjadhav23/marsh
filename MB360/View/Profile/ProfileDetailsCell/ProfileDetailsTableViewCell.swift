//
//  ProfileDetailsTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 17/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
//class ExpandedCellContent
//{
//
//    var otherInfo : PERSON_INFORMATION?
//    var expanded : Bool
//
//    init(otherInfo : PERSON_INFORMATION)
//    {
//
//        self.otherInfo = otherInfo
//        self.expanded = false
//    }
//}

class ExpandedCellContent
{
   
    var otherInfo : [ProfileDetails]
    var expanded : Bool
    
    init(otherInfo : [ProfileDetails])
    {
        
        self.otherInfo = otherInfo
        self.expanded = false
    }
}


class ProfileDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var m_backgroundView: UIView!
    @IBOutlet weak var m_iconImageview: UIImageView!
    @IBOutlet weak var m_titleLbl: UILabel!
    @IBOutlet weak var m_detailsButton: UIButton!
    @IBOutlet weak var m_titleBackgroundView: UIView!
    @IBOutlet weak var m_cancelButton: UIButton!
    @IBOutlet weak var m_detilsBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupFontsUI()
    }

    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var m_saveChangesButton: UIButton!
    @IBOutlet weak var m_addressTxtField: UITextField!
    
    @IBOutlet weak var emgContactRelation: UITextField!
    @IBOutlet weak var emgContactNumber: UITextField!
    @IBOutlet weak var m_emailIDTxtField: UITextField!
    @IBOutlet weak var m_mobileNumberTxtField: UITextField!
    @IBOutlet weak var m_addressTxtArea: UITextView!
    @IBOutlet weak var cellGender: UITextField!
    @IBOutlet weak var cellAge: UITextField!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(data:ExpandedCellContent)
    {
       
        
        if(data.expanded)
        {
//            let dict = data.otherInfo
//            self.m_claimDateLbl.text=dict?.claimIntimationDate
//            self.m_hospitalNameLbl.text=dict?.claimHospital
//            self.m_dateofAdmissionLbl.text=dict?.dateOfAdmission
//            self.m_claimAmountLbl.text=dict?.claimAmount
//            m_claimNumber.text="Medical Claim"
//            m_iconImageview.transform = ImageView.transform.rotated(by: CGFloat(180))
          
        }
        else
        {
            
            m_detilsBackgroundView.isHidden=true
            m_detilsBackgroundView.isHidden=false
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.m_detailsButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            
        }
    }
    
    func setupFontsUI(){
     
        m_titleLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        m_titleLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_mobileNumberTxtField.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_mobileNumberTxtField.textColor = FontsConstant.shared.app_FontBlackColor

        m_emailIDTxtField.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_emailIDTxtField.textColor = FontsConstant.shared.app_FontBlackColor

        emgContactNumber.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        emgContactNumber.textColor = FontsConstant.shared.app_FontBlackColor

        emgContactRelation.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        emgContactRelation.textColor = FontsConstant.shared.app_FontBlackColor

        m_addressTxtField.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_addressTxtField.textColor = FontsConstant.shared.app_FontBlackColor
        
        cellAge.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        cellAge.textColor = FontsConstant.shared.app_FontBlackColor
        
        cellGender.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        cellGender.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        m_addressTxtArea.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_addressTxtArea.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_saveChangesButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        m_saveChangesButton.titleLabel?.textColor = FontsConstant.shared.app_FontSecondryColor
             
        m_cancelButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        m_cancelButton.titleLabel?.textColor = FontsConstant.shared.app_FontSecondryColor
             
        logOutButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        logOutButton.titleLabel?.textColor = FontsConstant.shared.app_FontSecondryColor
             

        
    }
}
