//
//  CellForInstructionHeaderCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 24/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForInstructionHeaderCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblHeaderName: UILabel!
    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var btnInfo: UIButton!
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnTimer: UIButton!
    
    @IBOutlet weak var ImgTimer: UIImageView!
    @IBOutlet weak var vewTimer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
         if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
         {
            lblDescription.font = Font(.installed(.MontserratRegular), size: .standard(.h4)).instance
            lblHeaderName.font = Font(.installed(.MontserratBold), size: .custom(22.0)).instance

        }
         else {
            lblDescription.font = Font(.installed(.MontserratRegular), size: .standard(.h3)).instance
            lblHeaderName.font = Font(.installed(.MontserratBold), size: .standard(.bold)).instance

        }
        

        lblHeaderName.dropShadow()
        //lblHeaderName.textDropShadow()
        btnInfo.makeCicular()
        setImgTintColor(ImgTimer, color: UIColor.white)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
