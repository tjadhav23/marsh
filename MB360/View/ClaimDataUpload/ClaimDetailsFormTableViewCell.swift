//
//  ClaimDetailsFormTableViewCell.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 06/09/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit

class ClaimDetailsFormTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var radioBtn: UIImageView!
    @IBOutlet weak var msgLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainView.layer.borderColor=UIColor.lightGray.cgColor
        mainView.layer.borderWidth=1
        mainView.tintColor=UIColor.lightGray
        mainView.layer.cornerRadius = cornerRadiusForView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
