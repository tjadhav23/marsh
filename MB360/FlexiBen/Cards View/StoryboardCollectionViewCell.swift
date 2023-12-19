//
//  StoryboardCollectionViewCell.swift
//  CenteredCollectionView_Example
//
//  Created by Benjamin Emdon on 2018-04-12.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class StoryboardCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var label: UILabel!
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var imgViewForVideo: UIImageView!
    var isAnimated = false
    
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet weak var lblSecond: UILabel!

    @IBOutlet weak var lblLast: UILabel!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var lblHeading: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15.0
        self.contentView.layer.cornerRadius = 6.0
        
        self.innerView.layer.cornerRadius = 10.0
        
        // Shadow and Radius
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
        
        btnView.makeCicular()
        btnView.dropShadow()
        
        
    }
    
    override func prepareForReuse() {
         print("PREPARE_FOR_REUSE")
    }
}
