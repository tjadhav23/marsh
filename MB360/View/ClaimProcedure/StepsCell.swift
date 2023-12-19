//
//  StepsCell.swift
//  MyBenefits360
//
//  Created by ThynkSight on 21/10/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import UIKit
import WebKit

class StepsCell: UITableViewCell {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var icon: UIImageView?
    @IBOutlet var headerLbl: UILabel?
    @IBOutlet weak var stepsWebView: WKWebView!
    
    @IBOutlet weak var bottomIcon: UIImageView!
    @IBOutlet var stepsLbl: UILabel?
    
    @IBOutlet weak var mainViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var verticalVew: UIView!
    
    
    static let identifer = "StepsCell"
    static func nib() -> UINib{
        return UINib(nibName: "StepsCell", bundle: nil)
    }
    
    public func configure(with imageName: String){
        icon?.image = UIImage(named: imageName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupFontUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFontUI(){
        
        headerLbl?.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h15))
        headerLbl?.textColor = FontsConstant.shared.app_FontPrimaryColor
           
        stepsLbl?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        stepsLbl?.textColor = FontsConstant.shared.app_FontBlackColor
           
        
    }
}
