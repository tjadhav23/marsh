//
//  ContactDetailsTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 18/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class ContactDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var m_typeColorlbl: UILabel!
    
    //@IBOutlet weak var m_contactNumberButton: UIButton!
    @IBOutlet weak var m_badgeImageView: UIImageView!
    
    @IBOutlet weak var m_backGroundView: UIView!
    //@IBOutlet weak var m_mobileNumberLbl: UILabel!
    
    @IBOutlet weak var m_levelNumberLbl: UILabel!
    
    @IBOutlet weak var m_nameLbl: UILabel!
    
    @IBOutlet weak var m_locationLbl: UILabel!
    
    @IBOutlet weak var phoneHeaderLbl: UILabel!
    @IBOutlet weak var phoneTextView: UITextView!
    
    @IBOutlet weak var faxHeaderLbl: UILabel!
    @IBOutlet weak var m_faxLbl: UILabel!
    
    @IBOutlet weak var emailHeaderLbl: UILabel!
    @IBOutlet weak var m_emailLbl: UILabel!
    @IBOutlet weak var m_mailIDButton: UIButton!
    
    
    @IBOutlet weak var heightAddress: NSLayoutConstraint!
    @IBOutlet weak var heightFaxHeader: NSLayoutConstraint!
    
    @IBOutlet weak var heightFaxLbl: NSLayoutConstraint!
    
    @IBOutlet weak var heightPhnHeader: NSLayoutConstraint!
    
    @IBOutlet weak var heightPhnText: NSLayoutConstraint!
    
    @IBOutlet weak var heightemailHeader: NSLayoutConstraint!
    
    @IBOutlet weak var heightEmailLbl: NSLayoutConstraint!

    @IBOutlet weak var heightEmailBtn: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFontsUI()
        sizeToFit()
        layoutIfNeeded()
        
        let fixedWidth = phoneTextView.frame.size.width
        let newSize = phoneTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        phoneTextView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)

        phoneTextView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            phoneTextView.textDragInteraction?.isEnabled = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setupFontsUI(){
        
        m_levelNumberLbl.font = UIFont(name: FontsConstant.shared.bold, size: CGFloat(FontsConstant.shared.h15))
        m_levelNumberLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        m_nameLbl.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h15))
        m_nameLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_locationLbl.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h12))
        m_locationLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        phoneHeaderLbl.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h15))
        phoneHeaderLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        phoneTextView.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h12))
        phoneTextView.textColor = FontsConstant.shared.app_FontBlackColor
        
        faxHeaderLbl.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h15))
        faxHeaderLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_faxLbl.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h12))
        m_faxLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        emailHeaderLbl.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h15))
        emailHeaderLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_emailLbl.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h12))
        m_emailLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_mailIDButton.titleLabel?.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h12))
               
       
    }
}
