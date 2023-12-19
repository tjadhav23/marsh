//
//  CellForNewDependants.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 12/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForNewDependants: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgViewPlus: UIImageView!
    
    @IBOutlet weak var dashBackView: UIView!

    @IBOutlet weak var leftCutView: UIView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblGst: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftCutView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.dashBackView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.dashBackView.setCornerRadius()
        self.dashBackView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
