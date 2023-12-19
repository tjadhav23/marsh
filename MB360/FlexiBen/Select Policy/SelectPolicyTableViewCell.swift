//
//  SelectPolicyTableViewCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 02/05/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class SelectPolicyTableViewCell: UITableViewCell {

    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPolicyType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupFontUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setupFontUI(){
        
        lblAmount.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        lblAmount.textColor = FontsConstant.shared.app_FontBlackColor
        
        lblPolicyType.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        lblPolicyType.textColor = FontsConstant.shared.app_FontBlackColor
        
        lblOption.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        lblOption.textColor = FontsConstant.shared.app_FontSecondryColor
        
    }

}

class PolicyHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
