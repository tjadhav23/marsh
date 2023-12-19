//
//  AnnexureTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 03/07/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class AnnexureTableViewCell: UITableViewCell {
    @IBOutlet weak var m_viewAnnexureButton: UIButton!
    
    @IBOutlet weak var m_titleView: UIView!
    @IBOutlet weak var m_titleLbl: UILabel!
    @IBOutlet weak var m_nameLbl: UILabel!
    @IBOutlet weak var m_backgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupFontUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFontUI(){
        
        m_viewAnnexureButton.titleLabel?.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h12))
        m_viewAnnexureButton.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor

        m_titleLbl.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h17))
        m_titleLbl.textColor = FontsConstant.shared.app_FontAppColor

        m_nameLbl.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h17))
        m_nameLbl.textColor = FontsConstant.shared.app_FontBlackColor
    }
}
