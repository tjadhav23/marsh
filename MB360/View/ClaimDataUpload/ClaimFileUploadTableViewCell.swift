//
//  ClaimFileUploadTableViewCell.swift
//  MyBenefits360
//
//  Created by Thynksight on 06/09/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit

class ClaimFileUploadTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var vewMain: UIView!
    
    @IBOutlet weak var vew1: UIView!
    
    @IBOutlet weak var vew2: UIView!
    
    @IBOutlet weak var vewBottom: UIView!
    @IBOutlet weak var imgAttach: UIImageView!
    @IBOutlet weak var imgFileUpload: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblImageStatus: UILabel!
    
    @IBOutlet weak var vewUpload: UIView!
    
    
    @IBOutlet weak var txtVew: UITextView!
    @IBOutlet weak var BtnBrowse: UIButton!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var lblFileName: UILabel!
    
    @IBOutlet weak var lblCounter: UILabel!
    var delegate : tableCellDelegate? = nil
    var index : Int = -1
    
    
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
        vewMain.backgroundColor = FontsConstant.shared.HosptailBtnBG
        lblName.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        //lblName.textColor = FontsConstant.shared.app_FontBlackColor
        lblImageStatus.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h10))
        lblImageStatus.textColor = FontsConstant.shared.app_lightGrayColor
        vewBottom.layer.cornerRadius = cornerRadiusForView
        vewBottom.layer.borderColor = UIColor.black.cgColor
        vewBottom.layer.borderWidth = 1.0
        vewUpload.layer.cornerRadius = 7.0
        txtVew.layer.cornerRadius = 7.0
        txtVew.layer.borderColor = UIColor.gray.cgColor
        txtVew.layer.borderWidth = 1.0
        //BtnBrowse.layer.cornerRadius = 7.0
       
    }
    
    func setData(_ idx : Int){
      index = idx
    }
    
    @IBAction func btnCloseAct(_ sender: UIButton) {
        delegate?.passIndex(type: "delete", index: index)
    }
    
    
    
    @IBAction func btnBrowseAct(_ sender: UIButton) {
        delegate?.passIndex(type: "browse", index: index)
    }
    
}
