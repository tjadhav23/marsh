//
//  moduleCollectionViewCell.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 17/03/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit

class moduleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var horizontalView: UIView!
    @IBOutlet weak var horizontalImg: UIImageView!
    @IBOutlet weak var horizontalHeaderLbl: UILabel!
    @IBOutlet weak var horizontalDetailLbl: UILabel!
    
    @IBOutlet weak var verticalView: UIView!
    @IBOutlet weak var verticalImg: UIImageView!
    @IBOutlet weak var verticalHeaderLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        horizontalHeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        horizontalHeaderLbl.textColor = FontsConstant.shared.app_FontPrimaryColor
        
        horizontalDetailLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        horizontalDetailLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        verticalHeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        verticalHeaderLbl.textColor = FontsConstant.shared.app_FontPrimaryColor
    }

}
