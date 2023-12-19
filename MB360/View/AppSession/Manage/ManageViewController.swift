//
//  ManageViewController.swift
//  MyBenefits
//
//  Created by Semantic on 07/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
extension UIView {
    func applyGradient1(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
class ManageViewController: UIViewController {

    @IBOutlet weak var m_getStartedButton: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        headerLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.headerSize30))
        headerLbl.textColor = FontsConstant.shared.app_FontPrimaryColor
        
        contentLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h24))
        contentLbl.textColor = UIColor(hexString: "#545454")//FontsConstant.shared.app_FontSecondryColor
       

        m_getStartedButton.layer.masksToBounds=true
        if(Device.IS_IPAD)
        {
            m_getStartedButton.layer.cornerRadius=23
        }
        else
        {
            m_getStartedButton.layer.cornerRadius=39
        }
        
        m_getStartedButton.dropShadow()
//        m_getStartedButton.applyGradient1(colours: [hexStringToUIColor(hex: "4B66EA"),hexStringToUIColor(hex: "82A0F6")])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.navigationController?.isNavigationBarHidden = true
        
    }

    @IBAction func getStartedButtonClicked(_ sender: Any)
    {
        // Old Login Page
        /*
        let loginVC : LoginViewController = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
         */
        
        //New Login Page added on 26Sept2022 by Shubham
        
        let loginVc : LoginViewController_New = LoginViewController_New()
        navigationController?.pushViewController(loginVc, animated: true)
        
        
    }
   

}
