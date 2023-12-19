//
//  CellForCoverageInfo.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 24/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForCoverageInfo: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var backView: UIView!
    
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblSumInsureType: UILabel!
    
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var lblPremium: UILabel!
    @IBOutlet weak var lblPremiumAmount: UILabel!
    @IBOutlet weak var lblPremiumType: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
    
    
    @IBOutlet weak var imgTimer: UIImageView!
    @IBOutlet weak var btnTimer: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backView.setCornerRadius()
        
        
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setImgTintColor(imgTimer, color: UIColor.white)

        if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
                {
                   lblAmount.font = Font(.systemBold, size: .custom(25.0)).instance
                    lblName.font = Font(.installed(.MontserratRegular), size: .standard(.h4)).instance

               }
                else {
                   lblAmount.font = Font(.systemBold, size: .custom(30.0)).instance
            lblName.font = Font(.installed(.MontserratRegular), size: .standard(.h3)).instance


               }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
