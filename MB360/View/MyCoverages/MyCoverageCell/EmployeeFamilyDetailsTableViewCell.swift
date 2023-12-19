//
//  EmployeeFamilyDetailsTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 13/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
class ExpandedCoveragesCellContent
{
    
    var otherInfo : PERSON_INFORMATION?
    var expanded : Bool
    
    init(otherInfo : PERSON_INFORMATION)
    {
        
        self.otherInfo = otherInfo
        self.expanded = false
    }
}
class EmployeeFamilyDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var m_totalSIRsLbl: UILabel!
    @IBOutlet weak var m_detailsView: UIView!
    @IBOutlet weak var m_bsiRupeesBracketLbl: UIImageView!
    @IBOutlet weak var m_relationButton: UIButton!
    
    @IBOutlet weak var m_expandButton: UIButton!
    @IBOutlet weak var m_dataNotFoundView: UIView!
    
    
    @IBAction func relationButton(_ sender: Any) {
    }
    @IBOutlet weak var m_tsiRupeesImageview: UIImageView!
    @IBOutlet weak var m_bsiRupeesImageview: UILabel!
    
    @IBOutlet weak var m_totalSITitle: UILabel!
    @IBOutlet weak var m_totalSILbl: UILabel!
    @IBOutlet weak var m_relationLabel: UILabel!
    @IBOutlet weak var m_tsiRupeesBracketLbl: UILabel!
    @IBOutlet weak var m_relationImageView: UIImageView!
   
    @IBOutlet weak var m_baseSumInsuredTitleLbl: UILabel!
    
    @IBOutlet weak var m_tsiTitleLbl: UILabel!
    
    @IBOutlet weak var m_headerView: UIView!
    @IBOutlet weak var m_BackgroundView: UIView!
    @IBOutlet weak var m_ageLbl: UILabel!
    @IBOutlet weak var m_baseSumeInsuredLbl: UILabel!
   
    @IBOutlet weak var m_totalSITitleLbl: UILabel!
    @IBOutlet weak var m_TSITitleLbl: UILabel!
    @IBOutlet weak var m_sITitleLbl: UILabel!
    @IBOutlet weak var m_ageTitleLbl: UILabel!
    @IBOutlet weak var m_dobTitleLbl: UILabel!
    @IBOutlet weak var m_relationTitleLbl: UILabel!
    @IBOutlet weak var m_tsiLbl: UILabel!
    @IBOutlet weak var m_DOBLbl: UILabel!
    @IBOutlet weak var m_nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(data:ExpandedCoveragesCellContent)
    {
        
        
        if(data.expanded)
        {
            m_expandButton.setImage(UIImage(named: "arrow_Reverse"), for: .normal)
            
//            UIView.animate(withDuration: 0.5) { () -> Void in
//                self.m_expandButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//            }
        }
        else
        {
            m_expandButton.setImage(UIImage(named: "arrow"), for: .normal)
            m_detailsView.isHidden=false
           
        }
            
    }
    
    
    
    
}
