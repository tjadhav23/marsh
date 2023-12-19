//
//  ImageViewerVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 11/12/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class ImageViewerVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    var imgUrl = String()
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgView.image = image
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
