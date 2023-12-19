//
//  EnrollmentNavigationController.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 25/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class EnrollmentNavigationController: UINavigationController {
    
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    var isFromLogin = true
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        //To change Navigation Bar Background Color
        UINavigationBar.appearance().barTintColor = UIColor.blue
        //To change Back button title & icon color
        UINavigationBar.appearance().tintColor = UIColor.white
        //To change Navigation Bar Title Color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Montserrat-Regular", size: 18)!]
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    


}
