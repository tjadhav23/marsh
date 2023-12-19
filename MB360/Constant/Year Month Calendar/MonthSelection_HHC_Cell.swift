//
//  MonthSelection_HHC_Cell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 16/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class MonthSelection_HHC_Cell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        backView.layer.cornerRadius = cornerRadiusForView//8.0
        backView.layer.borderWidth = 1.0
        backView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        backView.isUserInteractionEnabled = true
    }
    
}
