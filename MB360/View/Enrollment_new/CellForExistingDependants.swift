//
//  CellForExistingDependants.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 26/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForExistingDependants: UITableViewCell {

    @IBOutlet weak var m_titleLbl: UILabel!
    @IBOutlet weak var m_backGroundView: UIView!
    @IBOutlet weak var sideCutView: UIView!
    @IBOutlet weak var btnInfo: UIButton!
    
    @IBOutlet weak var m_nameTextField: UILabel!
    
    @IBOutlet weak var m_dobTextField: UILabel!
    
    @IBOutlet weak var m_ageTextField: UILabel!
    
    @IBOutlet weak var m_editButton: UIButton!

    @IBOutlet weak var m_deleteButton: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var m_parentalPremiumAmountLbl: UILabel!
    
    @IBOutlet weak var m_acceptConditionsButton: UIButton!
    @IBOutlet weak var heightBtnConstant: NSLayoutConstraint!
    
    @IBOutlet weak var imgTwins: UIImageView!
    @IBOutlet weak var imgDisabled: UIImageView!
    @IBOutlet weak var imgDisabled1: UIImageView!
    @IBOutlet weak var m_docButton: UIButton!
    @IBOutlet weak var m_docButton1: UIButton!
    
    @IBOutlet weak var lblPremium: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblGst: UILabel!

    @IBOutlet weak var deleteBackView: UIView!
    @IBOutlet weak var lblDelete: UILabel!
    
    var delegate : tableCellDelegate? = nil
    var index : Int?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.sideCutView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.m_backGroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        self.deleteBackView.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        

        self.m_backGroundView.setCornerRadius()
        self.m_backGroundView.clipsToBounds = true
        
        self.deleteBackView.setCornerRadius()
        self.deleteBackView.clipsToBounds = true
        
        
         if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
         {
            lblAmount.font = Font(.system, size: .custom(13.0)).instance
            m_dobTextField.font = Font(.installed(.MontserratRegular), size: .custom(14.0)).instance
            m_nameTextField.font = Font(.installed(.MontserratRegular), size: .custom(14.0)).instance
            m_ageTextField.font = Font(.installed(.MontserratRegular), size: .custom(14.0)).instance

        }
        

        
        mekeMenuButtonGray()

    }
    
    func getIndex(_ ind : Int){
        index = ind
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
    
    @IBAction func btnDeleteAct(_ sender: Any) {
        delegate?.passIndex(type: "delete", index: index!)
    }
}
