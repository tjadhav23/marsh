//
//  UploadedClaimListTableViewCell.swift
//  MyBenefits360
//
//  Created by Thynksight on 08/09/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit

class UploadedClaimListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblRequest: UILabel!
    
    @IBOutlet weak var btnStatus: UIButton!
    
    @IBOutlet weak var lblClaim: UILabel!
    
    @IBOutlet weak var lblClaimIntimated: UILabel!
    
    @IBOutlet weak var lblIntimationNo: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblRelation: UILabel!
    
    @IBOutlet weak var lblDob: UILabel!
    
    @IBOutlet weak var vewMain: UIView!
    
    
    @IBOutlet weak var btnViewDocs: UIButton!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var VewBtnvew: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(){
        vewMain.layer.cornerRadius = cornerRadiusForView
        vewMain.layer.borderWidth = 1.0
        vewMain.layer.borderColor = UIColor(hexString: "#E4E6EA").cgColor
        btnStatus.layer.cornerRadius = 2
        btnViewDocs.layer.cornerRadius = cornerRadiusForView
        btnViewDocs.layer.borderWidth = 0
        btnViewDocs.layer.borderColor =  FontsConstant.shared.app_BlueHyperlinkColor.cgColor
        btnEdit.layer.borderWidth = 1
        btnEdit.layer.borderColor =  FontsConstant.shared.app_BlueHyperlinkColor.cgColor
        btnEdit.layer.cornerRadius = 4
        
        
        
        
        lblDate.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        lblDate.textColor = FontsConstant.shared.app_FontBlackColor
        lblRequest.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        lblRequest.textColor = FontsConstant.shared.app_FontBlackColor
//        lblDetails1.font = UIFont(name: FontsConstant.shared.NotoSansRegular, size: CGFloat(FontsConstant.shared.h12))
//        lblDetails1.textColor = UIColor(hexString: "#6B7280")
//        lblDetails2.font = UIFont(name: FontsConstant.shared.NotoSansRegular, size: CGFloat(FontsConstant.shared.h12))
//        lblDetails2.textColor = UIColor(hexString: "#6B7280")
        
        btnViewDocs.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h12))
        btnViewDocs.titleLabel?.textColor = FontsConstant.shared.app_BlueHyperlinkColor
    }
    
    
    
}
