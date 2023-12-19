//
//  PolicyDetailsCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 28/09/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class PolicyDetailsCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFontsUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupFontsUI(){
        lblTitle.font = UIFont(name: FontsConstant.shared.semiBold, size: CGFloat(FontsConstant.shared.h12))
        lblTitle.textColor = FontsConstant.shared.app_FontSecondryColor

        lblDetails.font = UIFont(name: FontsConstant.shared.semiBold, size: CGFloat(FontsConstant.shared.h15))
        lblDetails.textColor = FontsConstant.shared.app_FontBlackColor

    }
}
