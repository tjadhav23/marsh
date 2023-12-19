//
//  LeftSideViewController.swift
//  MyBenefits
//
//  Created by Semantic on 22/01/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var m_profileImageView: UIImageView!
    var perviousTermsCondtion = ""
    let emptyArray: [[String: String]] = []
    @IBAction func logOutButtonClicked(_ sender: Any)
    {
        
        let alertController = UIAlertController(title: "Do you want to logout?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
            
        }
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        {(result : UIAlertAction) -> Void in
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isAlreadylogin")
            
            menuButton.isHidden=true
            menuButton.removeFromSuperview()
            
            DatabaseManager.sharedInstance.deleteContactDetails(productCode: self.m_productCode)
            
            let loginVC :LoginViewController_New = LoginViewController_New()
            
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
            UserDefaults.standard.set(false, forKey: "loadsessionStatusValue")
            UserDefaults.standard.setValue(0, forKey: "Selected_Index_Position")
            UserDefaults.standard.setValue(0, forKey: "hospitalCountData")
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
            center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])
            globalHospitalList.removeAll()
            UserDefaults.standard.set(self.emptyArray, forKey: "groupGMCPolicyEmpDependants_UserDefault")
            center.removeAllPendingNotificationRequests()
            if self.perviousTermsCondtion == "true"{
                UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            }
            
            //Profile Clear
            UserDefaults.standard.set("", forKey: "emp_name") as? String
            UserDefaults.standard.set("", forKey: "designation") as? String
            UserDefaults.standard.set("", forKey: "gender") as? String
            UserDefaults.standard.set("", forKey: "email") as? String
            UserDefaults.standard.set("", forKey: "dob") as? String
            UserDefaults.standard.set("", forKey: "age") as? String
            UserDefaults.standard.set("", forKey: "address") as? String
            UserDefaults.standard.set("", forKey: "phoneno") as? String
            UserDefaults.standard.set("", forKey: "age") as? String
            UserDefaults.standard.set("", forKey: "loginMobileNo") as? String

            self.navigationController?.pushViewController(loginVC, animated: true)
            //        navigationController?.popToViewController(loginVC, animated: true)
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    @IBOutlet weak var m_tableView: UITableView!
    @IBOutlet weak var m_designationLbl: UILabel!
    @IBOutlet weak var m_nameLbl: UILabel!
    @IBOutlet weak var m_appVersion: UILabel!
    
    
    @IBOutlet weak var viewProfileBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var titleArray = ["My Coverages","Provider Network","My Claims","Claim Procedures","Intimate Claim","Policy Features","FAQs"]
  
    var imageArray = [#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "NetworkHospital-1"),#imageLiteral(resourceName: "MyClaims"),#imageLiteral(resourceName: "ClaimProcedure-1"),#imageLiteral(resourceName: "IntimateClaim-1"),#imageLiteral(resourceName: "PolicyFeature"),#imageLiteral(resourceName: "faq-2")]
    var m_personArray : [PERSON_INFORMATION]?
    var m_productCode = String()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupFontsUI()
        self.setNavBar()
        print("Group Code: ",getGroupCode())
        
        if getGroupCode().uppercased() == "CNHI1"{
            
            var index2 = titleArray.indexes(of: "Intimate Claim")
            titleArray.remove(at: index2)
            imageArray.remove(at: index2)
            
            print("titleArray data if: ",titleArray)
        }
        else{
            print("titleArray data else: ",titleArray)
        }
        
        m_tableView.register(LeftSideTableViewCell.self, forCellReuseIdentifier: "cell")
        m_tableView.register(UINib (nibName: "LeftSideTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.singleLine
        m_tableView.separatorColor=hexStringToUIColor(hex: "EAEAEA")
        
        // Product Code "" to "GMC" 14 Oct
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        m_personArray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: "GMC", relationName: "EMPLOYEE")
        
        if((m_personArray?.count)!>0)
        {
            let profileDict = m_personArray![0]
            if(profileDict.gender=="MALE" || profileDict.gender=="Male" || profileDict.gender=="male")
            {
                m_profileImageView.image = UIImage(named: "avatar_male11")
                
            }
            else
            {
                m_profileImageView.image = UIImage(named: "avatar_female11")
            }
        }
        else{
            var gender = UserDefaults.standard.value(forKey: "LoginUserGender") as? String ?? ""
            if(gender.uppercased() == "MALE")
            {
                m_profileImageView.image = UIImage(named: "avatar_male11")
                
            }
            else if(gender.uppercased() == "FEMALE")
            {
                m_profileImageView.image = UIImage(named: "avatar_female11")
            }
        }
        
        if(userArray.count>0)
        {
            let dict = userArray[0]
            if let designation = dict.designation
            {
                if designation.lowercased() == "not available" || designation.lowercased() == ""{
                    m_designationLbl.text = "-"
                }
                else{
                    m_designationLbl.text=designation
                }
            }
        }
        else{
            userDESIGNATION = UserDefaults.standard.value(forKey: "userDESIGNATIONValue") as? String ?? ""
            if userDESIGNATION.lowercased() == "not available" || userDESIGNATION.lowercased() == ""{
                m_designationLbl.text = "-"
            }
            else{
                m_designationLbl.text=userDESIGNATION
            }
        }
        
        var userName = UserDefaults.standard.value(forKey: "LoginUserName") as? String ?? ""
        var gender = UserDefaults.standard.value(forKey: "LoginUserGender") as? String ?? ""
        print("userName: ",userName," : gender: ",gender," userDESIGNATION:",userDESIGNATION)
        m_nameLbl.text=userName//employeeName
        m_profileImageView.layer.masksToBounds=true
        m_profileImageView.layer.cornerRadius=m_profileImageView.frame.height/2
        m_profileImageView.layer.borderWidth=1
        m_profileImageView.layer.borderColor=UIColor.lightGray.cgColor
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        print("appVersion: ",appVersion," build :",build)
        
        
        if let mobno = UserDefaults.standard.value(forKey: "loginMobileNo") as? String {
               print("Mobile no in LeftsidePage is ", mobno)

               var appVersionText = "App Version: \(appVersion)"
               if mobno == "9867163058" {
                   appVersionText += " (\(build))"
               }

               m_appVersion.text = appVersionText
           } else {
               
           }
        
          //  m_appVersion.text = "App Version: "+(appVersion ?? "0")
        
        
    }
    @IBAction func viewProfileButtonClicked(_ sender: Any)
    {
        let profile : ProfileViewController = ProfileViewController()
        navigationController?.pushViewController(profile, animated: true)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden=false
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        menuButton.isHidden=false
//        menuButton.backgroundColor = UIColor.white
//        menuButton.setBackgroundImage(UIImage(named: ""), for: .normal)
//        menuButton.setImage(UIImage(named:"Home"), for: .normal)
        navigationItem.title="My Profile"
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "back button"), style: .plain, target: self, action: #selector(backButtonClicked1))
        navigationItem.leftBarButtonItem = button1
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        print("m_productCode::",self.m_productCode)
        if m_productCode == "GMC"{
            print("m_productCode GMC",self.m_productCode)
            self.titleArray.removeAll()
            self.imageArray.removeAll()
            self.titleArray = ["My Coverages","Provider Network","My Claims","Claim Procedures","Intimate Claim","Policy Features","FAQs"]
          
            self.imageArray = [#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "NetworkHospital-1"),#imageLiteral(resourceName: "MyClaims"),#imageLiteral(resourceName: "ClaimProcedure-1"),#imageLiteral(resourceName: "IntimateClaim-1"),#imageLiteral(resourceName: "PolicyFeature"),#imageLiteral(resourceName: "faq-2")]
        }
        else{
            print("m_productCode:: ? ",self.m_productCode)
            
            self.titleArray.removeAll()
            self.imageArray.removeAll()
            self.titleArray = ["My Coverages","Claim Procedures","Policy Features","FAQs"]
          
            self.imageArray = [#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "ClaimProcedure-1"),#imageLiteral(resourceName: "PolicyFeature"),#imageLiteral(resourceName: "faq-2")]
            
        }
        m_tableView.reloadData()
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
//        navigationController?.popViewController(animated: true)
        tabBarController!.selectedIndex = 2
    }
    @objc func backButtonClicked1()
    {
        tabBarController!.selectedIndex = 2
    }
    
    func setupFontsUI(){
        
        m_nameLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h17))
        m_nameLbl.textColor = FontsConstant.shared.app_FontBlackColor
           
        m_designationLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h12))
        m_designationLbl.textColor = FontsConstant.shared.app_FontSecondryColor
     
        m_appVersion.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h12))
        m_appVersion.textColor = FontsConstant.shared.app_FontSecondryColor

        viewProfileBtn.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        viewProfileBtn.titleLabel?.textColor = FontsConstant.shared.app_FontSecondryColor
              
        logoutBtn.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        logoutBtn.titleLabel?.textColor = FontsConstant.shared.app_FontSecondryColor
            
    }
    
    func setNavBar(){
        navigationController?.isNavigationBarHidden=false
        navigationItem.title="profileTitle".localized()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        navigationItem.leftBarButtonItem = getBackButton()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : LeftSideTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeftSideTableViewCell
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        
        
        cell.m_titleLbl.text=titleArray[indexPath.row]
        cell.m_imageView.image=imageArray[indexPath.row]
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
       
        if m_productCode == "GMC"{
            switch indexPath.row
            {
            case 0:
                let myCoverages : MyCoveragesViewController = MyCoveragesViewController()
                navigationController?.pushViewController(myCoverages, animated: true)
                
                return
            case 1:
                let networkHospitals : NetworkHospitalsViewController = NetworkHospitalsViewController()
                navigationController?.pushViewController(networkHospitals, animated: true)
                
                
                return
            case 2:
                let myClaims:MyClaimsViewController = MyClaimsViewController()
                navigationController?.pushViewController(myClaims, animated: true)
                
                return
        
            case 3:
                let claimProcedure : ClaimProcedureVC_New = ClaimProcedureVC_New()
                navigationController?.pushViewController(claimProcedure, animated: true)
                return
            case 4:

                let intimation : MyIntimationViewController = MyIntimationViewController()
                navigationController?.pushViewController(intimation, animated: true)
                return
                
            case 5:
                let policyFeatures : PolicyFeaturesViewController = PolicyFeaturesViewController()
                navigationController?.pushViewController(policyFeatures, animated: true)
                
                return
                
            case 6:
                let FAQVC : FAQViewController = FAQViewController()
                navigationController?.pushViewController(FAQVC, animated: true)
                return
                
            case 8:
                
                return
            default:
                return
            }
        }
        else{
            switch indexPath.row
            {
            case 0:
                let myCoverages : MyCoveragesViewController = MyCoveragesViewController()
                navigationController?.pushViewController(myCoverages, animated: true)
                
                return
                
            case 1:
                let claimProcedure : ClaimProcedureVC_New = ClaimProcedureVC_New()
                navigationController?.pushViewController(claimProcedure, animated: true)
                return
                
            case 2:
                let policyFeatures : PolicyFeaturesViewController = PolicyFeaturesViewController()
                navigationController?.pushViewController(policyFeatures, animated: true)
                
                return
                
            case 3:
                let FAQVC : FAQViewController = FAQViewController()
                navigationController?.pushViewController(FAQVC, animated: true)
                return
            
            default:
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 60
    }
    
   
    func setTabbar()
    {
        let tabBarController = UITabBarController()
        
        let tabViewController1 = ContactDetailsViewController(
            nibName: "ContactDetailsViewController",
            bundle: nil)
        let tabViewController2 = NewDashboardViewController(
            nibName:"NewDashboardViewController",
            bundle: nil)
        let tabViewController3 = NewDashboardViewController(
            nibName: "NewDashboardViewController",
            bundle: nil)
        let tabViewController4 = UtilitiesViewController(
            nibName:"UtilitiesViewController",
            bundle: nil)
        let tabViewController5 = ProfileViewController(
            nibName:"ProfileViewController",
            bundle: nil)
        
        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
        
        
        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
        tabBarController.viewControllers = controllers as? [UIViewController]
        
        nav1.tabBarItem = UITabBarItem(
            title: "Contact",
            image: UIImage(named: "call-1"),
            tag: 1)
        nav2.tabBarItem = UITabBarItem(
            title: "E-card",
            image:UIImage(named: "ecard1") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Utilities",
            image:UIImage(named: "utilities") ,
            tag:2)
        
        nav5.tabBarItem = UITabBarItem(
            title: "Profile",
            image:UIImage(named: "profile") ,
            tag:2)
        
        let myCoverages : MyCoveragesViewController = MyCoveragesViewController()
        let leftSideMenuNav = UINavigationController(rootViewController: tabBarController)
        
        
//        leftSideMenuNav.pushViewController(myCoverages, animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
