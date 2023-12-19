//
//  UtilitiesTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 20/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class UtilitiesTableViewCell: UITableViewCell {
    @IBOutlet weak var m_backgroundView: UIView!
    @IBOutlet weak var m_iconImageView: UIImageView!
    
    @IBOutlet weak var utilitiesButtonClicked: UIButton!
    @IBOutlet weak var m_fileNameLbl: UILabel!
    
    @IBOutlet weak var m_downloadButton: UIButton!
    
  
    @IBOutlet weak var m_ViewAnnexureButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFontsUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupFontsUI(){
        m_fileNameLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_fileNameLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_downloadButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        m_downloadButton.titleLabel?.textColor = FontsConstant.shared.app_FontSecondryColor
      
        m_ViewAnnexureButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_ViewAnnexureButton.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
    }
    
}
