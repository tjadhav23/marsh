//
//  CellForButtonAddNewDependant.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 04/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CellForButtonAddNewDependant: UITableViewCell {

    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblLabel: UILabel!

    @IBOutlet weak var backView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnAdd.makeCicular()
        self.btnAdd.layer.masksToBounds = true
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class CustomDashedView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0

    var dashBorder: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
