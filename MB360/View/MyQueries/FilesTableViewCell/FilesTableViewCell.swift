//
//  FilesTableViewCell.swift
//  MyBenefits
//
//  Created by Semantic on 28/02/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class FilesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var m_deleteButton: UIButton!
    @IBOutlet weak var m_fileNameLbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
