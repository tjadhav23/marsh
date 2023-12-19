//
//  CellForParentalInfoCell.swift
//  MyBenefits360
//
//  Created by home on 09/12/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import UIKit

class CellForParentalInfoCell: UITableViewCell {
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var m_relationTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var m_nameTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var m_dobTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var ageTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var premiumTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //backView.layer.cornerRadius = 20.0
        //backView.clipsToBounds = true
        
        btnDelete.layer.masksToBounds = true
        btnDelete.makeCicular()
        btnEdit.makeCicular()
        btnEdit.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

//=================================================================

class CellForBtnAddParentCell: UITableViewCell {
    
    @IBOutlet weak var btnAddParent: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnAddParent.makeCicular()
        btnAddParent.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
