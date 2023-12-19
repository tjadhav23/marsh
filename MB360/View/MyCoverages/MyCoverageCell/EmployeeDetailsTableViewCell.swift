//
//  EmployeeDetailsTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 21/01/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class EmployeeDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var empNameLbl: UILabel!
    
    @IBOutlet weak var relationLbl: UILabel!
    
    @IBOutlet weak var employeeDetailsTitleView: UIView!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var empDetailsView: UIView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var ageHeader: UILabel!
    @IBOutlet weak var dobHeader: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        employeeDetailsTitleView.backgroundColor = FontsConstant.shared.app_ViewBGColor2
        self.setFontUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFontUI(){
        
        
        empNameLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        empNameLbl.textColor = FontsConstant.shared.app_FontBlackColor

        relationLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        relationLbl.textColor = FontsConstant.shared.app_FontSecondryColor

        ageHeader.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        ageHeader.textColor = FontsConstant.shared.app_FontSecondryColor

        ageLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        ageLbl.textColor = FontsConstant.shared.app_FontBlackColor

        
        dobHeader.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        dobHeader.textColor = FontsConstant.shared.app_FontSecondryColor

        dobLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        dobLbl.textColor = FontsConstant.shared.app_FontBlackColor

    }
}
