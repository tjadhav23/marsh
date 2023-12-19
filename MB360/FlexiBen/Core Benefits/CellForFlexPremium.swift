//
//  CellForFlexPremium.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 20/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForFlexPremium: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblRelation: UILabel!
    
    @IBOutlet weak var lblPremiumAmount: UILabel!
    
    @IBOutlet weak var bottomConstarint: NSLayoutConstraint!
    @IBOutlet weak var viewBox: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
       self.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)

      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}


class CellForNoTopup: UITableViewCell {

    
    @IBOutlet weak var btnDoNotTopUp: UIButton!
   @IBOutlet weak var nextBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnDoNotTopUp.layer.cornerRadius = 6.0
        self.btnDoNotTopUp.layer.borderColor = #colorLiteral(red: 0.1450980392, green: 0.5490196078, blue: 0.9215686275, alpha: 1)
        self.btnDoNotTopUp.layer.borderWidth = 0.7
        
        
        nextBtn.makeCicular()
        nextBtn.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
