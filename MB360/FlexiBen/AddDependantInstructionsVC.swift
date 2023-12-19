//
//  AddDependantInstructionsVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 27/12/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class AddDependantInstructionsVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnCLose: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        scrollView.backgroundColor = UIColor.white

        scrollView.layer.cornerRadius = 4.0
    }
   
    @IBAction func closeTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
