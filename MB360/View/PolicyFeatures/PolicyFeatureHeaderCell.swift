//
//  PolicyFeatureHeaderCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 28/09/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class PolicyFeatureHeaderCell: UITableViewCell {
    @IBOutlet weak var m_expandButton: UIButton!
    @IBOutlet weak var m_expandButtonHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var m_titleImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var imgRibbon: UIImageView!

    @IBOutlet weak var indexNumber: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFontsUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupFontsUI(){
        lblTitle.font = UIFont(name: FontsConstant.shared.bold, size: CGFloat(FontsConstant.shared.h15))
        lblTitle.textColor = FontsConstant.shared.app_FontSecondryColor

        indexNumber.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h12))
        indexNumber.textColor = FontsConstant.shared.app_WhiteColor  
    }
}
