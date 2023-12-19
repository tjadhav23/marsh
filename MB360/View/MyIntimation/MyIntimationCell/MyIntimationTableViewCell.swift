//
//  MyIntimationTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 16/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
class ExpandedTableviewCellContent
{
    var title : String?
    var otherInfo : Intimations?
    var expanded : Bool
    
    init(title:String, otherInfo : Intimations)
    {
        self.title = title
        self.otherInfo = otherInfo
        self.expanded = false
    }
}

class MyIntimationTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupFontUI()
    }
    @IBOutlet weak var m_dataNotFoundView: UIView!
    @IBOutlet weak var m_backgrounView: UIView!
    
    @IBOutlet weak var m_titleView: UIView!
    
    @IBOutlet weak var m_detailView: UIView!
   
    @IBOutlet weak var m_claimDateTitleLbl: UILabel!
  
    @IBOutlet weak var m_claimAmountTitleLbl: UILabel!
    @IBOutlet weak var m_admissionDateTitleLbl: UILabel!
    @IBOutlet weak var m_nameOfHospitalTitleLbl: UILabel!
    @IBOutlet weak var m_claimDateLbl: UILabel!
   
    @IBOutlet weak var m_alimentTitle: UILabel!
    @IBOutlet weak var m_claimAmountLbl: UILabel!
    @IBOutlet weak var m_dateofAdmissionLbl: UILabel!
    @IBOutlet weak var m_hospitalNameLbl: UILabel!
    @IBOutlet weak var m_claimNumber: UILabel!
    @IBOutlet weak var m_nameLbl: UILabel!
    
    @IBOutlet weak var noIntimatedClaimsHeaderLbl: UILabel!
    
    @IBOutlet weak var claimantHeaderLbl: UILabel!
    
    @IBOutlet weak var lblIntimationNo: UILabel!
    
    @IBOutlet weak var employee: UILabel!
    
    @IBOutlet weak var lblEmployee: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var m_ailmentLbl: UILabel!
    @IBOutlet weak var m_expandButton: UIButton!
    func setContent(data:ExpandedTableviewCellContent)
    {
        self.m_nameLbl.text=data.title
        let font = m_nameLbl.font

        if(data.expanded)
        {
            let dict = data.otherInfo
            print(dict)
            self.m_nameLbl.text=dict?.claimant
            self.m_claimDateLbl.text=dict?.claimIntimationDate
            self.m_hospitalNameLbl.text=dict?.claimHospital
            self.m_ailmentLbl.text=dict?.claimDiagnosis
            self.m_dateofAdmissionLbl.text=dict?.dateOfAdmission
            self.lblEmployee.text=dict?.employee_Name
            let claimAmount = dict?.claimAmount
//            claimAmount = claimAmount?.replacingOccurrences(of: "Rs.", with: "", options: NSString.CompareOptions.literal, range: nil)
            self.m_claimAmountLbl.text=claimAmount
            
            m_claimNumber.text="Claim Number"
            
            m_detailView.isHidden=false
//
//            UIView.animate(withDuration: 0.5) { () -> Void in
//                self.m_expandButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//            }
           
            //self.m_expandButton.setImage(UIImage (named: "arrow_Reverse"), for: .normal)
            
//            if #available(iOS 13.0, *) {
//                self.m_expandButton.setImage(UIImage(systemName: "minus"), for: .normal)
//            } else {
//                self.m_expandButton.setImage(UIImage (named: "minus"), for: .normal)
//            }
            
            self.m_expandButton.setImage(UIImage (named: "minus"), for: .normal)


            self.m_nameLbl.isHidden = false
            self.m_claimDateLbl.isHidden = false
            self.m_hospitalNameLbl.isHidden = false
            self.m_nameOfHospitalTitleLbl.isHidden=false
            self.m_claimNumber.isHidden=false
            self.m_ailmentLbl.isHidden=false
            self.m_claimDateTitleLbl.isHidden=false
            self.m_dateofAdmissionLbl.isHidden=false
            self.m_claimAmountTitleLbl.isHidden = false
            self.m_admissionDateTitleLbl.isHidden = false
            self.m_claimAmountLbl.isHidden = false
            self.m_dateofAdmissionLbl.isHidden = false
            self.m_alimentTitle.isHidden = false
            self.employee.isHidden = false
            self.lblEmployee.isHidden = false
        }
        else
        {
            
            self.m_expandButton.isHidden=false
            m_detailView.isHidden=false
            //self.m_expandButton.setImage(UIImage (named: "arrow"), for: .normal)
            
           if #available(iOS 13.0, *) {
               self.m_expandButton.setImage(UIImage(systemName: "plus"), for: .normal)
           } else {
               self.m_expandButton.setImage(UIImage (named: "plus"), for: .normal)
           }
        }
    }
    
    func setupFontUI(){
        
        noIntimatedClaimsHeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h17))
        noIntimatedClaimsHeaderLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_claimNumber.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_claimNumber.textColor = FontsConstant.shared.app_FontSecondryColor
        
        
        m_nameOfHospitalTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_nameOfHospitalTitleLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_admissionDateTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_admissionDateTitleLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_claimAmountTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_claimAmountTitleLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_claimDateTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_claimDateTitleLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        claimantHeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        claimantHeaderLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_hospitalNameLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_hospitalNameLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        m_dateofAdmissionLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_dateofAdmissionLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        
        m_claimAmountLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_claimAmountLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_claimNumber.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_claimNumber.textColor = FontsConstant.shared.app_FontBlackColor
        
        lblEmployee.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        lblEmployee.textColor = FontsConstant.shared.app_FontBlackColor
        
        employee.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        employee.textColor = FontsConstant.shared.app_FontSecondryColor
        
        lblIntimationNo.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        lblIntimationNo.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_alimentTitle.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_alimentTitle.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_nameLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_nameLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        btnReadMore.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        btnReadMore.titleLabel?.textColor = FontsConstant.shared.app_FontPrimaryColor
        
        
        
        m_ailmentLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_ailmentLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_claimDateLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h14))
        m_claimDateLbl.textColor = FontsConstant.shared.app_FontBlackColor
        
    }
    
}
