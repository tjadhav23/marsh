//
//  SumInsuredTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 21/01/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class SumInsuredTableViewCell: UITableViewCell {
    @IBOutlet weak var sumInsuredHeader: UILabel!
    @IBOutlet weak var baseHeader: UILabel!
    @IBOutlet weak var bsiLbl: UILabel!

    @IBOutlet weak var topupLbl: UILabel!
    @IBOutlet weak var sumInsuredStackView: UIStackView!
    
    @IBOutlet weak var totalTitleLbl: UILabel!
    @IBOutlet weak var topupTitleLbl: UILabel!
    @IBOutlet weak var totalSiiew: UIView!
    @IBOutlet weak var bsiView: UIView!
    @IBOutlet weak var sumInsuredTitleView: UIView!
    @IBOutlet weak var sumInsuredView: UIView!
    @IBOutlet weak var totalLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sumInsuredTitleView.backgroundColor = FontsConstant.shared.app_ViewBGColor2
        self.setFontUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFontUI(){
        sumInsuredHeader.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h15))
        sumInsuredHeader.textColor = FontsConstant.shared.app_FontDarkGreyColor
        
        baseHeader.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        baseHeader.textColor = FontsConstant.shared.app_mediumGrayColor
        
        bsiLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        bsiLbl.textColor = FontsConstant.shared.app_FontBlackColor
        

        topupTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        topupTitleLbl.textColor = FontsConstant.shared.app_mediumGrayColor
        
        topupLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        topupLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
    }

}
