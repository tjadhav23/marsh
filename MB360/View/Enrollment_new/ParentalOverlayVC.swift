//
//  ParentalOverlayVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 23/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class ParentalOverlayVC: UIViewController {

    
    @IBOutlet weak var btnGotIt: UIButton!
    @IBOutlet weak var lblMsg: UILabel!

    @IBOutlet weak var backview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnGotIt.makeCicularWithMasks()
                   btnGotIt.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                   btnGotIt.layer.borderWidth = 1.0
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        backview.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        backview.layer.borderWidth = 1.0
        backview.layer.cornerRadius = 6.0

    }
    

   @objc func update() {
              self.dismiss(animated: true, completion: nil)
          }

      @IBAction func btnTapped(_ sender: Any) {
          update()
      }

}
