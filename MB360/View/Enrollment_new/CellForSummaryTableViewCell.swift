//
//  CellForSummaryTableViewCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 18/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFirst: UILabel!

    @IBOutlet weak var lblSecond: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
        {
            lblFirst.font = Font(.installed(.MontserratRegular), size: .custom(14.0)).instance
            lblFirst.font = Font(.system, size: .custom(13.0)).instance

        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



class CellForHeaderSummary: UITableViewCell {

    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblSeparator: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblSeparator.lineBreakMode = .byClipping
        
        if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
                {
                    lblFirst.font = Font(.installed(.MontserratMedium), size: .custom(15.0)).instance
               }
                
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}


class CellForYouPayCell: UITableViewCell {

    @IBOutlet weak var lblTotalPremium: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblSeparator: UILabel!
    @IBOutlet weak var lblGST: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        //lblSeparator.lineBreakMode = .byClipping
        
        btnConfirm.layer.cornerRadius = 4.0
        btnConfirm.layer.borderColor = #colorLiteral(red: 0.6737065911, green: 0.8981016278, blue: 0.1015828773, alpha: 1)
        btnConfirm.layer.borderWidth = 1.5
        
        if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
        {
            lblAmount.font = Font(.installed(.MontserratMedium), size: .custom(14.0)).instance
            lblFirst.font = Font(.installed(.MontserratMedium), size: .custom(14.0)).instance
            
            lblTotalPremium.font = Font(.installed(.MontserratMedium), size: .custom(14.0)).instance
            lblGST.font = Font(.installed(.MontserratRegular), size: .custom(14.0)).instance

            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


class SeparatorCell: UITableViewCell {
    
    @IBOutlet weak var lblSeparator: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblSeparator.lineBreakMode = .byClipping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
