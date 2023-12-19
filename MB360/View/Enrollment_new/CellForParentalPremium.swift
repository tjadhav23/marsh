//
//  CellForParentalPremium.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 23/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForParentalPremium: UITableViewCell {

    @IBOutlet weak var lblTop: UILabel!
    
    @IBOutlet weak var btnCheckBox: UIButton!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnAddNew: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnAddNew.makeCicular()
        btnAddNew.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


//class CellForParentalInfo: UITableViewCell {
//
//    @IBOutlet weak var backView: UIView!
//
//    @IBOutlet weak var btnEdit: UIButton!
//    @IBOutlet weak var btnDelete: UIButton!
//
//    @IBOutlet weak var m_relationTextfield: SkyFloatingLabelTextField!
//    @IBOutlet weak var m_nameTextfield: SkyFloatingLabelTextField!
//    @IBOutlet weak var m_dobTextField: SkyFloatingLabelTextField!
//
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        backView.layer.cornerRadius = 20.0
//        backView.clipsToBounds = true
//
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}
