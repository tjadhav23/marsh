//
//  InsuranceTypeCellFlex.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 20/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class InsuranceTypeCellFlex: UITableViewCell {

    @IBOutlet weak var lblInsuranceName: UILabel!
    @IBOutlet weak var lblSumInsured: UILabel!
    @IBOutlet weak var lblSumInsuredAmount: UILabel!
    @IBOutlet weak var lblBottom: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}


/*
class AnimationView: UIView {
    enum Direction: Int {
        case FromLeft = 0
        case FromRight = 1
    }

    @IBInspectable var direction : Int = 0
    @IBInspectable var delay :Double = 0.0
    @IBInspectable var duration :Double = 0.0
    
    override func layoutSubviews() {
        initialSetup()
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            if let superview = self.superview {
                           if self.direction == Direction.FromLeft.rawValue {
                               self.center.x += superview.bounds.width
                           } else {
                               self.center.x -= superview.bounds.width
                           }
                       }
        })
    }
    func initialSetup() {
        if let superview = self.superview {
            if direction == Direction.FromLeft.rawValue {
             self.center.x -= superview.bounds.width
            } else {
                self.center.x += superview.bounds.width
            }

        }
    }
}
*/
