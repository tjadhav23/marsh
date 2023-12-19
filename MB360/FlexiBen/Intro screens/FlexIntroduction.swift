//
//  FlexIntroduction.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 23/12/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class FlexIntroduction: UITableViewController {
    
    @IBOutlet weak var viewFirst: UIView!
    
    @IBOutlet weak var viewSecond: UIView!
    
    @IBOutlet weak var viewThird: UIView!
    
    @IBOutlet weak var viewFourth: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Introduction"
        
        
        //hide back button
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()

        
        
        //hide back button
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        setColors()
        self.btnNext.makeCicular()
        btnNext.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true

    }
    
    
    private func setColors() {
        viewFirst.layer.borderColor = #colorLiteral(red: 0.4666666667, green: 0.9176470588, blue: 0.8862745098, alpha: 1)
        viewSecond.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.5843137255, blue: 0.8941176471, alpha: 1)
        viewThird.layer.borderColor = #colorLiteral(red: 0.5725490196, green: 0.7333333333, blue: 0.9960784314, alpha: 1)
        viewFourth.layer.borderColor = #colorLiteral(red: 0.9803921569, green: 0.5607843137, blue: 0.5882352941, alpha: 1)

        setBorder(view: viewFirst)
        setBorder(view: viewSecond)
        setBorder(view: viewThird)
        setBorder(view: viewFourth)
    }
    
    private func setBorder(view:UIView) {
        view.layer.cornerRadius = 10.0
        view.layer.borderWidth = 3.0
        
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func nextTapped(_ sender: Any) {
//        let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
//        enrollmentVC.m_isEnrollmentConfirmed = m_isEnrollmentConfirmed
//        enrollmentVC.m_windowPeriodEndDate = m_windowPeriodEndDate
//        navigationController?.pushViewController(enrollmentVC, animated: true)
    }
    
}
