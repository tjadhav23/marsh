//
//  TipInCellAnimator.swift
//  MyBenefits
//
//  Created by Semantic on 21/06/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

let TipInCellAnimatorStartTransform:CATransform3D = {
    let rotationDegrees: CGFloat = 0
    let rotationRadians: CGFloat = rotationDegrees * (CGFloat(M_PI)/180)
    let offset = CGPoint(x:-200,y:0)
    var startTransform = CATransform3DIdentity
    startTransform = CATransform3DRotate(CATransform3DIdentity,
                                         rotationRadians, 0.0, 0.0, 1.0)
    startTransform = CATransform3DTranslate(startTransform, offset.x, offset.y, 0.0)
    
    return startTransform
}()

class TipInCellAnimator
{
    class func animate(cell:UITableViewCell)
    {
        let view = cell.contentView
        
        view.layer.transform = TipInCellAnimatorStartTransform
        view.layer.opacity = 0.8
        
        UIView.animate(withDuration: 0.4)
        {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        }
    }
}
class animateImageView
{
    class func animate(view:UIImageView)
    {
//        let view = cell.contentMode
        
        view.layer.transform = TipInCellAnimatorStartTransform
        view.layer.opacity = 0.8
        
        UIView.animate(withDuration: 0.4)
        {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        }
    }
}
