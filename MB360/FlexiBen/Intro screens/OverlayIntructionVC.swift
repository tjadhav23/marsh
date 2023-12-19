//
//  OverlayIntructionVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 06/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class OverlayIntructionVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imgView: UIImageView!

    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        if #available(iOS 13.0, *) {
        
        }
        else {
            imgView.image = UIImage(named: "back button")
            imgView.transform = imgView.transform.rotated(by: CGFloat(Double.pi / 1))

        }
        
        self.topView.isUserInteractionEnabled = true

        let tapRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(tapped(_:)))
        self.topView.addGestureRecognizer(tapRecognizer)
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)

    }
    
    @objc private func tapped(_ sender : UITapGestureRecognizer) {
        self.timer.invalidate()
        self.dismiss(animated: true, completion: nil)

    }

    @objc func update() {
        self.timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }

}
