//
//  CellForTopupInsurance.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 28/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForTopupInsurance: UITableViewCell {

    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var imgDot: UIImageView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPremium: UILabel!
    @IBOutlet weak var lblGst: UILabel!
    @IBOutlet weak var imgCorrect: UIImageView!
    @IBOutlet weak var sideCutView: UIView!
    
    
    @IBOutlet weak var deleteBackView: UIView!
    @IBOutlet weak var lblDelete: UILabel!
    @IBOutlet weak var m_deleteButton: UIButton!

    @IBOutlet weak var lblCriticalIllness: UILabel!
    @IBOutlet weak var lblRupee: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.setCornerRadius()
        self.backView.clipsToBounds = true
        
        dotView.layer.masksToBounds = true
        dotView.layer.cornerRadius = dotView.frame.width/2

        self.sideCutView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.deleteBackView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.deleteBackView.setCornerRadius()
        self.deleteBackView.clipsToBounds = true


     mekeMenuButtonGray()

          }
          
          func mekeMenuButtonGray() {
              let origImage = UIImage(named:"deletew")
              let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
              m_deleteButton.setImage(tintedImage, for: .normal)
              m_deleteButton.tintColor = UIColor.red
              
          }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
