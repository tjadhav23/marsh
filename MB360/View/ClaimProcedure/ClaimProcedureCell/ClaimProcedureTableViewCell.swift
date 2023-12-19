//
//  ClaimProcedureTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 19/06/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
class ExpandedCaimProcedure
{
    var title : String?
//    var otherInfo : Intimations?
    var expanded : Bool
    
    init(title:String)
    {
        self.title = title
//        self.otherInfo = otherInfo
        self.expanded = false
    }
}
class ClaimProcedureTableViewCell: UITableViewCell {
    @IBOutlet weak var m_detailView: UIView!
    @IBOutlet weak var lbl1: UILabel!
    
    @IBOutlet weak var m_gmcWebView: UIWebView!
    @IBOutlet weak var m_linelbl5: UILabel!
    
    @IBOutlet weak var m_webViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_lineLbl4: UILabel!
    @IBOutlet weak var m_lineLbl6: UILabel!
    @IBOutlet weak var m_backGroundView: UIView!
    @IBOutlet weak var lbl7: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
   
    @IBOutlet weak var m_bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_separator: UILabel!
    @IBOutlet weak var m_lineLbl2: UILabel!
    @IBOutlet weak var m_detailViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var m_checklistLbl: UILabel!
    @IBOutlet weak var m_lineLbl3: UILabel!
    
    @IBOutlet weak var m_title1Lbl: UILabel!
    
    @IBOutlet weak var m_detail1Lbl: UILabel!
    
    @IBOutlet weak var m_title2Lbl: UILabel!
    
    @IBOutlet weak var m_title4Lbl: UILabel!
    @IBOutlet weak var m_detail3Lbl: UILabel!
    @IBOutlet weak var m_title3Lbl: UILabel!
    @IBOutlet weak var m_detail2Lbl: UILabel!
    
    @IBOutlet weak var m_detail4Lbl: UILabel!
    
    @IBOutlet weak var m_title5Lbl: UILabel!
    
    @IBOutlet weak var m_detail5Lbl: UILabel!
    
    @IBOutlet weak var m_title6Lbl: UILabel!
    
    @IBOutlet weak var m_detail7Lbl: UILabel!
    @IBOutlet weak var m_title7Lbl: UILabel!
    @IBOutlet weak var m_detail6Lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setContent(data:ExpandedCaimProcedure)
    {
    
        if(data.expanded)
        {

            
            m_detailView.isHidden=false
        }
        else
        {
            
           
            m_detailView.isHidden=false
            
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
