//
//  cellEmployeeDetails2TableViewCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 23/08/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import UIKit

class cellEmployeeDetails2TableViewCell: UITableViewCell {

   
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtValue1: UITextField!
    @IBOutlet weak var valueBorderView1: UIView!
    @IBOutlet weak var btnEditIcon1: UIImageView!
    
    @IBOutlet weak var txtValue2: UITextField!
    @IBOutlet weak var lblHeader2: UILabel!
    @IBOutlet weak var valueBorderView2: UIView!
    @IBOutlet weak var btnEditIcon2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
