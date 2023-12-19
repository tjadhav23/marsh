//
//  FirstIntroScreenVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 10/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class FirstIntroScreenVC: UIViewController {

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet weak var lblSecond: UILabel!

    @IBOutlet weak var lblLast: UILabel!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()

    var moveToNextDelegate:MoveCardToNextProtocol? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.innerView.layer.cornerRadius = 8.0

        //self.view.setBackgroundGradientColor(index: 0)


        //shadowForCell(view: self.innerView)
        
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        
        navigationController?.isNavigationBarHidden=false
        self.navigationItem.title = "Enrollment"
        self.navigationItem.leftBarButtonItem=getBackButton()

        self.btnView.makeCicular()
        self.btnView.layer.masksToBounds = true
        
        let array : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: "GMC", relationName: "EMPLOYEE")
                   if(array.count>0)
                   {
                       let personInfo = array[0]
                       if let name = personInfo.personName
                       {
                        self.lblName.text = "hi, " + name
                       }
                       
                   }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           //self.view.myCustomAnimation()

       }

    @IBAction func nextTapped(_ sender: Any) {
   
        if moveToNextDelegate != nil {
            moveToNextDelegate?.moveToNextCard()
        }
    }
    
}
