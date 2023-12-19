//
//  ClaimBeneficiaryDetailsTableViewCell.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 07/09/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit


class ClaimBeneficiaryDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var relationIcon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var relation: UILabel!
    @IBOutlet weak var radioBtnImg: UIImageView!
    
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var mobile: UILabel!
    
    @IBOutlet weak var lblClaimNo: UILabel!
    
    @IBOutlet weak var vewClaim: UIView!
    
    @IBOutlet weak var heightVewClaim: NSLayoutConstraint!
    
    @IBOutlet weak var heightFirstVew: NSLayoutConstraint!
    
    @IBOutlet weak var heightFirstView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFontsUI()
    }
    
    func setupFontsUI(){
        
        name.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        name.textColor = FontsConstant.shared.app_lightGrayColor

        relation.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        relation.textColor = FontsConstant.shared.app_FontBlackColor
        
        ageLbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        ageLbl.textColor = FontsConstant.shared.app_lightGrayColor
        
        dobLbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        dobLbl.textColor = FontsConstant.shared.app_lightGrayColor
        
        gender.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        gender.textColor = FontsConstant.shared.app_lightGrayColor
        
        mobile.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        mobile.textColor = FontsConstant.shared.app_lightGrayColor
        vewClaim.layer.cornerRadius = cornerRadiusForView
        
    }

    

}
