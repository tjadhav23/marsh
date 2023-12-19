//
//  TableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 30/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var m_statusButton: UILabel!
    
    @IBOutlet weak var m_viewQueryButton: UIButton!
    @IBOutlet weak var m_noofRepliesLbl: UILabel!
    @IBOutlet weak var m_queryDetailTextLbl: UILabel!
    @IBOutlet weak var m_queryDateLbl: UILabel!
    @IBOutlet weak var m_queryNoLbl: UILabel!

    @IBOutlet weak var m_backGroundView: UIView!

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       // m_noofRepliesLbl.textColor = Color.themeFontColor.value
setupFontUI()
        // Configure the view for the selected state
    }
    
    func setupFontUI(){
        self.m_noofRepliesLbl.textColor = Color.insuranceThemeColor.value
    }
    
}
