//
//  ErrorHandlerVC.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 16/05/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit

class ErrorHandlerVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var HeaderLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var errorBtn: UIButton!
    var perviousTermsCondtion = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("INSIDE ErrorHandlerVC: ")
        self.setupFontsUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        menuButton.isHidden = true
        DispatchQueue.main.async()
        {
            menuButton.isHidden=true
            menuButton.accessibilityElementsHidden=true
        }
    }
    
    @IBAction func errorBtnClicked(_ sender: Any) {
        print("errorBtnClicked: ")
        self.clearUserDeafults()
        
    }
    
    func setupFontsUI(){
        //Header Lbl set
        
        HeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: 20)
        HeaderLbl.textColor = FontsConstant.shared.app_mediumGrayColor
        
        contentLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h18))
        contentLbl.textColor = FontsConstant.shared.app_FontLightGreyColor
        contentLbl.text = "Sorry, there appears to be an error loading the data. Please try re-login the app or try again later. If you are logging in for the first time please make sure that you log into the web portal first."
        errorBtn.layer.cornerRadius = 10
        
    }

    func clearUserDeafults(){
        UserDefaults.standard.set("", forKey: "ExtGroupSrNo")
        UserDefaults.standard.set("", forKey: "ExtFamilySrNo")
        UserDefaults.standard.set("", forKey: "OrderMasterNo")
        UserDefaults.standard.set("", forKey: "GroupChildSrNo")
        UserDefaults.standard.set("", forKey: "emailid")
        UserDefaults.standard.set("", forKey: "userEmployeeSrnoValue")
        UserDefaults.standard.set("", forKey: "userOegrpNoValue")
        UserDefaults.standard.set("", forKey: "userGroupChildNoValue")
        
        UserDefaults.standard.set(nil, forKey: "MEMBER_ID")
        
        //for Added for Terms and codition on 1st time login
        if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
            self.perviousTermsCondtion = "true"
        }
        else{
            self.perviousTermsCondtion = "false"
        }
        //To display disclaimer every time
        UserDefaults.standard.setValue(nil, forKey: "isFitnessFirstTime")
        UserDefaults.standard.setValue(nil, forKey: "cigaretteCount")
        UserDefaults.standard.setValue(nil, forKey: "drinkCount")
        UserDefaults.standard.setValue(nil, forKey: "getOfflineTabs")

        UserDefaults.standard.set(false, forKey: "isInsurance")
        UserDefaults.standard.set(false, forKey: "isWellness")
        UserDefaults.standard.set(false, forKey: "isFitness")
        UserDefaults.standard.set(nil, forKey: "userEmployeeSrnoValue")
        UserDefaults.standard.set(nil, forKey: "userEmployeIdNoValue")
        UserDefaults.standard.set(nil, forKey: "userPersonSrnNoValue")
        UserDefaults.standard.setValue(nil, forKey: "LoginUserName")
        UserDefaults.standard.set("", forKey: "userOTP")
        authToken = ""
        UserDefaults.standard.set(authToken, forKey: "userAppToken") as? String
        
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
        center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

        center.removeAllPendingNotificationRequests()
        if self.perviousTermsCondtion == "true"{
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
        }

        let login : LoginViewController_New = LoginViewController_New()
        self.navigationController?.pushViewController(login, animated: true)
    }
}
