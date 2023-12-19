//
//  OverlayForDependantsVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 07/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class OverlayForDependantsVC: UIViewController {

    @IBOutlet weak var firstBoxView: UIView!
    @IBOutlet weak var btnGotIt: UIButton!
    @IBOutlet weak var secondBoxView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var firstImg: UIImageView!
    @IBOutlet weak var secondImg: UIImageView!
    
        var timer = Timer()
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            self.topView.isUserInteractionEnabled = true

            let tapRecognizer = UITapGestureRecognizer(target: self, action:
                #selector(tapped(_:)))
            self.topView.addGestureRecognizer(tapRecognizer)
            //self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
            
            
            
            secondBoxView.setCornerRadius()
            firstBoxView.setCornerRadius()
            firstBoxView.clipsToBounds = true
            secondBoxView.clipsToBounds = true
            
            firstBoxView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            firstBoxView.layer.borderWidth = 1.0
            secondBoxView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            secondBoxView.layer.borderWidth = 1.0


            btnGotIt.makeCicularWithMasks()
            btnGotIt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnGotIt.layer.borderWidth = 1.0
            
        }
        
        @objc private func tapped(_ sender : UITapGestureRecognizer) {
            update()
        }

        @objc func update() {
            self.timer.invalidate()
            self.dismiss(animated: true, completion: nil)
        }

    @IBAction func btnTapped(_ sender: Any) {
        update()
    }
}
