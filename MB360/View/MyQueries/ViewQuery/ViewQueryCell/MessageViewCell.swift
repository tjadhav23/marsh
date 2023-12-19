//
//  MessageViewCell.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 14/08/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {

    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var m_firstLblView: UIView!

    @IBOutlet weak var moreTextButton: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var widthForMoreAttachmentButton: NSLayoutConstraint!
    @IBOutlet weak var heightForAttachmentView: NSLayoutConstraint!
    
    @IBOutlet weak var heightMoewText: NSLayoutConstraint!
    @IBOutlet weak var viewAttachment: UIView!
    @IBOutlet weak var lblAttachment: UILabel!
    @IBOutlet weak var imgAttachment: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
