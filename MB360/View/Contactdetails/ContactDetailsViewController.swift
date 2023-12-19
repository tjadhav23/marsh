//
//  ContactDetailsViewController.swift
//  MyBenefits
//
//  Created by Semantic on 18/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import FirebaseCrashlytics
import TrustKit
import AesEverywhere

class ContactDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate, NewPoicySelectedDelegate {
    
    
    @IBOutlet weak var m_tableview: UITableView!
    
    @IBOutlet weak var m_errorMsgDetailLbl: UILabel!
    @IBOutlet weak var m_errorMsgTitleLbl: UILabel!
    @IBOutlet weak var m_errorImageView: UIImageView!
    @IBOutlet weak var m_noInternetView: UIView!
    @IBOutlet weak var GTLShadowView: UIView!
    @IBOutlet weak var GPAShadowView: UIView!
    @IBOutlet weak var GMCShadowView: UIView!
    @IBOutlet weak var m_topbarView: UIView!
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_stackView: UIStackView!
    @IBOutlet weak var m_tabBarView: UIView!
   
    
    @IBOutlet weak var m_GTLTabLine: UILabel!
    @IBOutlet weak var m_GPATabLine: UILabel!
    @IBOutlet weak var m_GMCTabLine: UILabel!
    @IBOutlet weak var m_GTLTab: UIButton!
    @IBOutlet weak var m_GPATab: UIButton!
    @IBOutlet weak var m_GMCTab: UIButton!
    @IBOutlet weak var m_topbarTopVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var PolicylblView: UIView!
    @IBOutlet weak var policyNamelbl: UILabel!
    @IBOutlet weak var policyButtonView: UIView!
    @IBOutlet weak var policyButtonLbl: UILabel!
    
    
    var selectedIndexPosition = -1
    var policyDataArray = [OE_GROUP_BASIC_INFORMATION]()
    
    let reuseIdentifier = "cell"
    
    let dictionaryKeys = ["Escalations1","Escalations2","Escalations3","Escalations4","Escalations5","Escalations6","Escalations7","Escalations8","Escalations9","Escalations10","Escalations11","Escalations12","EscalationNo", "EscalationPerson", "EscalationAddress", "EscalationContact","LandlineNo","MobileNo","EscalationFax","EscalationEmailID","EscalationType"]
    
    var xmlKey = String()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    var enrollmentDetailsDict : EnrollmentDetails?
     var contactDetailsArray = Array<ContactDetails>()
    var m_productCode = String()
     var m_escalationsArray: [[String: String]]?
    var isFromSideBar = Bool()
    
    var retryCountContacts = 0
    var maxRetryContacts = 1
    
    var selectedPolicyValue = ""
    
    var clickedOegrp = ""
    var clickedEmpSrNo = ""
    
    let sortOrder = ["TPA", "BROKER", "CORPORATE", "HR"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupFontsUI()
        //Top bar hide buttons
        m_GMCTab.isHidden=true
        m_GPATab.isHidden=true
        m_GTLTab.isHidden=true
        userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
        addTarget()
        self.tabBarController?.tabBar.isHidden=false
        m_tableview.register(ContactDetailsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        m_tableview.register(UINib (nibName: "ContactDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.m_tableview.estimatedRowHeight = 400.0;
        self.m_tableview.rowHeight = UITableViewAutomaticDimension;
        
        self.m_tableview.setNeedsLayout()
        self.m_tableview.layoutIfNeeded()
        
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
                
        print("Contact Page Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
        
        //Top Bar Policy Hide Show
        m_productCodeArray=UserDefaults.standard.value(forKey: "ProductsArray") as! Array<String>
        print("m_productCodeArray: ",m_productCodeArray)
        
        print("Active Policy: ",m_productCodeArray)
        
        if(m_productCodeArray.contains("GMC")){
            print("GMC present")
            m_GMCTab.isHidden = false
        }
        if(m_productCodeArray.contains("GPA")){
            print("GPA present")
            m_GPATab.isHidden = false
        }
        if(m_productCodeArray.contains("GTL")){
            print("GTL present")
            m_GTLTab.isHidden = false
        }
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        print("m_productCode: ",m_productCode)
        
        if m_productCode == "GMC"{
            GMCTabSeleted()
        }
        else if m_productCode == "GPA"{
            GPATabSelect()
        }
        else if m_productCode == "GTL"{
            GTLTabSelect()
        }
        
        navigationItem.leftBarButtonItem = getBackButton()
        
    }
    
    func setupFontsUI(){
        
        m_GMCTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GMCTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_GPATab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GPATab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_GTLTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GTLTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
         
        m_errorMsgTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        m_errorMsgTitleLbl.textColor = FontsConstant.shared.app_errorTitleColor
        
        m_errorMsgDetailLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_errorMsgDetailLbl.textColor = FontsConstant.shared.app_errorTitleColor

        
        policyNamelbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        policyNamelbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        policyButtonLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        policyButtonLbl.textColor = FontsConstant.shared.app_WhiteColor
    }
    
    func setTopbarProducts()
    {
        
        if(m_productCodeArray.count==1)
        {
            if(m_productCodeArray.contains("GMC"))
            {
                GMCTabSeleted()
                m_GMCTab.isUserInteractionEnabled=false
                m_GPATab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=false
                
                m_GPATab.setTitleColor(UIColor.white, for: .normal)
                m_GTLTab.setTitleColor(UIColor.white, for: .normal)
            }
            else if(m_productCodeArray.contains("GPA"))
            {
                GPATabSelect()
                m_GMCTab.isUserInteractionEnabled=false
                m_GPATab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=false
                
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
                m_GTLTab.setTitleColor(UIColor.white, for: .normal)
            }
            else if(m_productCodeArray.contains("GTL"))
            {
                GTLTabSelect()
                m_GPATab.isUserInteractionEnabled=false
                m_GMCTab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=false
                m_GPATab.setTitleColor(UIColor.white, for: .normal)
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
            }
        }
        else if(m_productCodeArray.count==2)
        {
            
            if(m_productCodeArray.contains("GMC") && m_productCodeArray.contains("GPA"))
            {
                
                m_GMCTab.isUserInteractionEnabled=true
                m_GPATab.isUserInteractionEnabled=true
                m_GTLTab.isUserInteractionEnabled=false
                m_GMCTab.isHidden=false
                m_GPATab.isHidden=false
                m_GTLTab.isHidden=true
                GMCTabSeleted()
                
            }
            else if(m_productCodeArray.contains("GMC") && m_productCodeArray.contains("GTL"))
            {
                
                m_GMCTab.isUserInteractionEnabled=true
                m_GPATab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=true
                m_GMCTab.isHidden=false
                m_GPATab.isHidden=true
                m_GTLTab.isHidden=false
                GMCTabSeleted()
            }
            else if(m_productCodeArray.contains("GPA") && m_productCodeArray.contains("GTL"))
            {
                
                m_GMCTab.isUserInteractionEnabled=false
                m_GPATab.isUserInteractionEnabled=true
                m_GTLTab.isUserInteractionEnabled=true
                m_GMCTab.isHidden=true
                m_GPATab.isHidden=false
                m_GTLTab.isHidden=false
                GPATabSelect()
                
            }
            else
            {
                
            }
        }
        else
        {
           // GMCTabSeleted()
            
            m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
            selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
                    
            print("Contact Page Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
            
            if m_productCode == "GMC"{
                GMCTabSeleted()
            }
            else if m_productCode == "GPA"{
                GPATabSelect()
            }
            else if m_productCode == "GTL"{
                GTLTabSelect()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       
        //TopUp Bar
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        print("m_productCode: ",m_productCode)
        
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        print("ContactDetailsViewController selectedIndexPosition is viewWillAppear  : ",selectedIndexPosition)
        
        if m_productCode == "GMC"{
            GMCTabSeleted()
        }
        else if m_productCode == "GPA"{
            GPATabSelect()
        }
        else if m_productCode == "GTL"{
            GTLTabSelect()
        }
        
        m_tabBarView.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
        PolicylblView.setBorderToViewSelectPolicy(color:hexStringToUIColor(hex: "E5E5E5"))
       
       
        
        setData()
        
        
        //navigationItem.rightBarButtonItem=getRightBarButton()
        navigationController?.isNavigationBarHidden=false
        navigationItem.title="link11Name".localized()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        navigationItem.leftBarButtonItem = getBackButton()
        //navigationItem.leftBarButtonItem = nil
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
//        menuButton.backgroundColor = UIColor.white
//        menuButton.setBackgroundImage(UIImage(named: ""), for: .normal)
//        menuButton.setImage(UIImage(named:"Home"), for: .normal)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        //setTopbarProducts()
    }
    func getLeftBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:UIImage(named: "menu"), style: .plain, target: self, action: #selector(leftButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func leftButtonClicked()
    {
      
        
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
//        navigationController?.popViewController(animated: true)
        tabBarController!.selectedIndex = 2
    }
    @objc override func backButtonClicked()
    {
        print ("backButtonClicked")
        tabBarController!.selectedIndex = 2
    }
    
    func setData()
    {
        
        m_tableview.separatorStyle=UITableViewCellSeparatorStyle.none
        
        
    }
    func GMCTabSeleted()
    {
        m_productCode="GMC"
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        print("selectedIndexPosition:::",selectedIndexPosition)
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
            print("Selected userdefault value in if ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
            print("Selected userdefault value in else ",selectedIndexPosition)
        }
        print("selectedIndexPosition:: ",selectedIndexPosition)
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        if policyDataArray.count > selectedIndexPosition{
            print("ContactDetailsViewController selectedIndexPosition GMC ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("ContactDetailsViewController selectedIndexPosition GMC ",selectedIndexPosition)
        }
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        GTLShadowView.layer.masksToBounds=true
        GPAShadowView.layer.masksToBounds=true
        //GMCShadowView.dropShadow()
        
        m_GMCTab.layer.masksToBounds=true
        m_GMCTab.layer.cornerRadius=cornerRadiusForView//m_GMCTab.frame.size.height/2
//        m_GMCTab.layer.borderColor=hexStringToUIColor(hex: "622140").cgColor
        m_GMCTab.layer.borderWidth=0
        m_GMCTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        m_GMCTabLine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
        m_GMCTab.setTitleColor(UIColor.white, for: .normal)
        
        m_GPATabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GTLTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GPATab.layer.borderWidth = 2
        m_GTLTab.layer.borderWidth = 2
        
       
        m_GPATab.layer.cornerRadius = cornerRadiusForView//8
        m_GTLTab.layer.cornerRadius = cornerRadiusForView//8
        GMCShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        m_GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GTLTab.setBackgroundImage(nil, for: .normal)
        
        //getPostContactDetails()
        getPostContactDetailsPortal()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*//Not in use
    func getPostContactDetails()
    {
        if(isConnectedToNet())
        {
            
            
            var employeeDetailsArray : Array<EMPLOYEE_INFORMATION> = []
            
            employeeDetailsArray = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: self.m_productCode)
            
            
            var oegrpno = getOegrpNo(self.m_productCode)
            if userGroupChildNo != "" && oegrpno != ""
            {
                
                let userDict:EMPLOYEE_INFORMATION = employeeDetailsArray[0]
                
                showPleaseWait(msg: "Please wait...Fetching Contact Details")
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    groupchildsrno = String(userDict.groupChildSrNo)
                    oegrpbasinfsrno = String(userDict.oe_group_base_Info_Sr_No)
           
           
                /* let yourXML = AEXMLDocument()
                 
                 let dataRequest = yourXML.addChild(name: "DataRequest")
                 dataRequest.addChild(name: "groupchildsrno", value: groupChildSrNo)
                 dataRequest.addChild(name: "oegrpbasinfsrno", value: oegrpbasinfsrno)
                 
                 print(yourXML.xml)*/
                
                
               
                let string="<DataRequest><groupchildsrno>\(groupchildsrno)</groupchildsrno><oegrpbasinfsrno>\(oegrpbasinfsrno)</oegrpbasinfsrno></DataRequest>"
                let uploadData = string.data(using: .utf8)
                
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getContactDetailsPostUrl() as String)
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody=uploadData
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if error != nil {
                    print("error ",error!)
                    self.hidePleaseWait()
                    self.displayActivityAlert(title: m_errorMsg)
                }
                else
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                                do {
                                    
                                    self.xmlKey = "EscalationInformation"
                                    let parser = XMLParser(data: data!)
                                    parser.delegate = self
                                    parser.parse()
                                    
                                    DispatchQueue.main.async
                                        {
                                            let status = DatabaseManager.sharedInstance.deleteContactDetails(productCode: self.m_productCode)
                                            if(status)
                                            {
                                                for contactDict in self.m_escalationsArray!
                                                {
                                                    DatabaseManager.sharedInstance.saveContactDetails(contactDict: contactDict as NSDictionary,productCode:self.m_productCode)
                                                }
                                            }
                                            self.contactDetailsArray =  DatabaseManager.sharedInstance.retrieveContactDetails(productCode: self.m_productCode)
                                            
                                            
                                        if(self.contactDetailsArray.count==0)
                                            {
                                                self.m_tableview.isHidden=true
                                                self.m_noInternetView.isHidden=false
                                                self.m_errorImageView.image=UIImage(named: "nocontacts")
                                                self.m_errorMsgTitleLbl.text="No contacts found!"
                                                self.m_errorMsgDetailLbl.text=""
                                            }
                                            else
                                            {
                                                print(self.contactDetailsArray.count)
                                                self.m_tableview.isHidden=false
                                                self.m_noInternetView.isHidden=true
                                                
//                                                self.scrollToTop()
                                            }
                                            self.m_tableview.reloadData()
                                            self.hidePleaseWait()
                                    }
                                }
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                                self.hidePleaseWait()
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                            }
                        }
                        else
                        {
                            self.hidePleaseWait()
//                            Crashlytics.sharedInstance().recordError(m_errorMsg as! Error)
                            print("else executed")
                        }
                        
                    } else {
                        print("Can't cast response to NSHTTPURLResponse")
                        Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                        self.hidePleaseWait()
                        
                    }
                    
                }
            }
            
            task.resume()
            
            }
            else
            {
                if(self.contactDetailsArray.count==0)
                {
                    self.m_tableview.isHidden=true
                    self.m_noInternetView.isHidden=false
                    self.m_errorImageView.image=UIImage(named: "nocontacts")
                    self.m_errorMsgTitleLbl.text="No contacts found!"
                    self.m_errorMsgDetailLbl.text=""
                }
            }
        }
        else
        {
            m_noInternetView.isHidden=false
            m_errorImageView.image=UIImage(named: "nointernet")
            m_errorMsgTitleLbl.text="No internet connection"
            m_errorMsgDetailLbl.text="Slow or no internet connection. Please check your Internet Settings"
            self.contactDetailsArray =  DatabaseManager.sharedInstance.retrieveContactDetails(productCode: self.m_productCode)
            
            if(contactDetailsArray.count>0)
            {
                
                
                self.m_tableview.reloadData()
                let deadlineTime = DispatchTime.now() + .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime)
                {
                    self.m_noInternetView.isHidden=true
                    
                }
            }
            
        }
    }
    */
    
    func getPostContactDetailsPortal()
    {
       
            if(isConnectedToNet())
            {
                
                userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
                userOegrpNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String ?? ""
                userOegrpNoGPA = UserDefaults.standard.value(forKey: "userOegrpNoValueGPA") as? String ?? ""
                userOegrpNoGTL = UserDefaults.standard.value(forKey: "userOegrpNoValueGTL") as? String ?? ""
                
                userEmployeeSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String ?? ""
                userEmployeeSrnoGPA = UserDefaults.standard.value(forKey: "userEmployeeSrnoValueGPA") as? String ?? ""
                userEmployeeSrnoGTL = UserDefaults.standard.value(forKey: "userEmployeeSrnoValueGTL") as? String ?? ""
                employeeSrNoGMCValue = UserDefaults.standard.value(forKey: "employeeSrNoGMCValue") as? String ?? ""
                
                if m_productCode == "GMC"{
                    clickedOegrp = userOegrpNo
                    clickedEmpSrNo = userEmployeeSrno
                }
                else if m_productCode == "GPA"{
                    clickedOegrp = userOegrpNoGPA
                    clickedEmpSrNo = userEmployeeSrnoGPA
                }
                else if m_productCode == "GTL"{
                    clickedOegrp = userOegrpNoGTL
                    clickedEmpSrNo = userEmployeeSrnoGTL
                }
                
                print("getPostContactDetailsPortal Userdefaults userGroupChildNo: ",userGroupChildNo," clickedOegrp: ",clickedOegrp," m_productCode:",m_productCode," clickedEmpSrNo: ",clickedEmpSrNo," employeeSrNoGMCValue: ",employeeSrNoGMCValue," selectedIndexPosition: ",selectedIndexPosition)
                
                
                if (!userGroupChildNo.isEmpty && !clickedOegrp.isEmpty)
                {
                    
                    showPleaseWait(msg: "Please wait...Fetching Contact Details")
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    
                    groupchildsrno = userGroupChildNo as! String
                    print("groupchildsrno : ",groupchildsrno)
                    groupchildsrno = try! AES256.encrypt(input: groupchildsrno, passphrase: m_passphrase_Portal)
                    
                    
                    if selectedIndexPosition == 0{
                        oegrpbasinfsrno = clickedOegrp as! String
                        print("oegrpbasinfsrno : ",oegrpbasinfsrno)
                        oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                        
                    }else{
                        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
                        oegrpbasinfsrno = selectedPolicyValue
                        print("oegrpbasinfsrno : ",oegrpbasinfsrno)
                        oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                        
                    }
                    
                    
                    
                    print("m_productCode : ",m_productCode," : groupchildsrno: ",groupchildsrno," : oegrpbasinfsrno: ",oegrpbasinfsrno)
                    let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getContactDetailsPostUrlPortal(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded) as String)
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?
                    request.httpMethod = "GET"
                    
                    var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
                    var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)
                    
                    let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
                    print("m_authUserName_Portal ",encryptedUserName)
                    print("m_authPassword_Portal ",encryptedPassword)
                    
                    let authData = authString.data(using: String.Encoding.utf8)!
                    let base64AuthString = authData.base64EncodedString()
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                    print("authToken GetGroupEscalationInfo:",authToken)
                    
                    request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                    
                    print("GetGroupEscalationInfo url: ",urlreq)
                    
                    //SSL Pinning
                    let sessionConfig = URLSessionConfiguration.default
                    sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
                    sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
                    TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
                    let session = URLSession(
                        configuration: sessionConfig,
                        delegate: URLSessionPinningDelegate(),
                        delegateQueue: nil)
                    
                    
                    let task = session.dataTask(with: request as URLRequest) { data, response, error in
                        //SSL Pinning
                        if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                            // Handle SSL connection failure
                            print("SSL connection error: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                self.alertForLogout(titleMsg: error.localizedDescription)
                            }
                        }
                        else if let error = error {
                            print("getPostContactDetailsPortal error:", error)
                            DispatchQueue.main.async
                            {
                                self.hidePleaseWait()
                                self.m_noInternetView.isHidden = false
                                self.m_errorImageView.isHidden = false
                                self.m_errorMsgTitleLbl.isHidden = false
                                self.m_errorMsgDetailLbl.isHidden = false
                                self.m_errorImageView.image = UIImage(named: "PEContactNotFound")
                                //self.m_errorMsgTitleLbl.text = error_State
                                self.m_tableview.isHidden=true
                                self.m_errorMsgTitleLbl.text = "During_PostEnrollment_Header_ContactErrorMsg".localized()
                                self.m_errorMsgDetailLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                            }
                            
                        }
                        else{
                            
                            if let httpResponse = response as? HTTPURLResponse
                            {
                                print("getPostContactDetailsPortal httpResponse.statusCode: ",httpResponse.statusCode)
                                
                                if httpResponse.statusCode == 200{
                                    do{
                                        guard let data = data else { return }
                                        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                                        if let data = json?["GroupEscalationInfo"] as? [Any] {
                                            
                                            self.resultsDictArray = json?["GroupEscalationInfo"] as? [[String : String]]
                                            self.m_escalationsArray = self.resultsDictArray
                                            
                                            //print("resultsDictArray : ",self.resultsDictArray)
                                            
                                            for item in data {
                                                if let object = item as? [String: Any] {
                                                    
                                                    // PERSON_ID
                                                    let PERSON_ID = object["PERSON_ID"] as? String ?? "0"
                                                    print("PERSON_ID: \(PERSON_ID)")
                                                    
                                                    // ADDRESS_ID
                                                    let ADDRESS_ID = object["ADDRESS_ID"] as? String ?? ""
                                                    print("ADDRESS_ID: \(ADDRESS_ID)")
                                                    
                                                    // EMAIL_ID
                                                    let EMAIL_ID = object["EMAIL_ID"] as? String ?? ""
                                                    print("EMAIL_ID: \(EMAIL_ID)")
                                                    
                                                    // NUMBER_ID
                                                    let NUMBER_ID = object["NUMBER_ID"] as? String ?? "0"
                                                    print("NUMBER_ID: \(NUMBER_ID)")
                                                    
                                                    // DESCRIPTION
                                                    let DESCRIPTION = object["DESCRIPTION"] as? String ?? "0"
                                                    print("DESCRIPTION: \(DESCRIPTION)")
                                                    
                                                    // ADDRESS
                                                    let ADDRESS = object["ADDRESS"] as? String ?? "0"
                                                    print("ADDRESS: \(ADDRESS)")
                                                    
                                                    // CONTACT_PERSON
                                                    let CONTACT_PERSON = object["CONTACT_PERSON"] as? String ?? "0"
                                                    print("CONTACT_PERSON: \(CONTACT_PERSON)")
                                                    
                                                    // LANDLINE_NO
                                                    let LANDLINE_NO = object["LANDLINE_NO"] as? String ?? "0"
                                                    print("LANDLINE_NO: \(LANDLINE_NO)")
                                                    
                                                    // MOBILE_NO
                                                    let MOBILE_NO = object["MOBILE_NO"] as? String ?? "0"
                                                    print("MOBILE_NO: \(MOBILE_NO)")
                                                    
                                                    // FAX_NO
                                                    let FAX_NO = object["FAX_NO"] as? String ?? "0"
                                                    print("FAX_NO: \(FAX_NO)")
                                                    
                                                    // EMAIL
                                                    let EMAIL = object["EMAIL"] as? String ?? "0"
                                                    print("EMAIL: \(EMAIL)")
                                                    
                                                    // ESCALATION
                                                    let ESCALATION = object["ESCALATION"] as? String ?? "0"
                                                    print("ESCALATION: \(ESCALATION)")
                                                    
                                                    // ADDITIONAL_TEXT
                                                    let ADDITIONAL_TEXT = object["ADDITIONAL_TEXT"] as? String ?? "0"
                                                    print("ADDITIONAL_TEXT: \(ADDITIONAL_TEXT)")
                                                    
                                                    // DISP_EMAIL
                                                    let DISP_EMAIL = object["DISP_EMAIL"] as? String ?? "0"
                                                    print("DISP_EMAIL: \(DISP_EMAIL)")
                                                    
                                                    // DISP_MOB
                                                    let DISP_MOB = object["DISP_MOB"] as? String ?? "0"
                                                    print("DISP_MOB: \(DISP_MOB)")
                                                    
                                                    // DISP_ADD
                                                    let DISP_ADD = object["DISP_ADD"] as? String ?? "0"
                                                    print("DISP_ADD: \(DISP_ADD)")
                                                    
                                                    // DISP_FAX
                                                    let DISP_FAX = object["DISP_FAX"] as? String ?? "0"
                                                    print("DISP_FAX: \(DISP_FAX)")
                                                    
                                                    // DISP_EMAIL_HR
                                                    let DISP_EMAIL_HR = object["DISP_EMAIL_HR"] as? String ?? "0"
                                                    print("DISP_EMAIL_HR: \(DISP_EMAIL_HR)")
                                                    
                                                    // DISP_MOB_HR
                                                    let DISP_MOB_HR = object["DISP_MOB_HR"] as? String ?? "0"
                                                    print("DISP_MOB_HR: \(DISP_MOB_HR)")
                                                    
                                                    // DISP_ADD_HR
                                                    let DISP_ADD_HR = object["DISP_ADD_HR"] as? String ?? "0"
                                                    print("DISP_ADD_HR: \(DISP_ADD_HR)")
                                                    
                                                    // DISP_FAX_HR
                                                    let DISP_FAX_HR = object["DISP_FAX_HR"] as? String ?? "0"
                                                    print("DISP_FAX_HR: \(DISP_FAX_HR)")
                                                    
                                                    
                                                    
                                                    
                                                }
                                                
                                            }
                                            
                                            print("resultsDictArray count : ",self.resultsDictArray?.count)
                                            print("m_escalationsArray count : ",self.m_escalationsArray?.count)
                                            print("m_escalationsArray from API data : ",self.m_escalationsArray)
                                            
                                            
                                            let categoryOrder = ["TPA", "BROKER", "CORPORATE", "HR"]

                                            // Sort the array based on the category order
                                            let sortedArray = self.m_escalationsArray?.sorted { (entry1, entry2) -> Bool in
                                                guard let description1 = entry1["DESCRIPTION"] as? String,
                                                      let description2 = entry2["DESCRIPTION"] as? String else {
                                                    return false
                                                }
                                                
                                                // Get the index of the description in the category order array
                                                guard let index1 = categoryOrder.firstIndex(of: description1),
                                                      let index2 = categoryOrder.firstIndex(of: description2) else {
                                                    return false
                                                }
                                                
                                                // Compare the indices
                                                return index1 < index2
                                            }

                                            // Print the sorted array
                                            print("sortedArray  in format",sortedArray)
                                            self.m_escalationsArray = sortedArray
                                            
                                            print("m_escalationsArray from sorting data : ",self.m_escalationsArray)
                                            
                                        }
                                        DispatchQueue.main.async
                                        {
                                                let status = DatabaseManager.sharedInstance.deleteContactDetails(productCode: self.m_productCode)
                                            if(status)
                                            {
                                                if self.m_escalationsArray != nil{
                                                    
                                                    if !self.m_escalationsArray!.isEmpty {


                                                        for contactDict in self.m_escalationsArray! {

                                                            // Skip saving if DISP_EMAIL, DISP_MOB, DISP_ADD, and DISP_FAX are all "0"
                                                            if self.shouldSkipSavingContact(contactDict: contactDict) {
                                                                continue
                                                            }

                                                            DatabaseManager.sharedInstance.saveContactDetails(contactDict: contactDict as NSDictionary, productCode: self.m_productCode)
                                                        }
                                                    }


                                                }
                                            }
                                            self.contactDetailsArray =  DatabaseManager.sharedInstance.retrieveContactDetails(productCode: self.m_productCode)
                                            
                                            
                                            self.contactDetailsArray.sort { contact1, contact2 in
                                                guard let type1 = contact1.contactType, let type2 = contact2.contactType else {
                                                    return false
                                                }
                                                
                                                let index1 = self.sortOrder.firstIndex(of: type1) ?? Int.max
                                                let index2 = self.sortOrder.firstIndex(of: type2) ?? Int.max
                                                
                                                if index1 != index2 {
                                                    // If contact types are different, sort by sortOrder
                                                    return index1 < index2
                                                } else {
                                                    // If contact types are the same, sort by ESCALATION
                                                    guard let escalation1 = contact1.escalation, let escalation2 = contact2.escalation else {
                                                        return false
                                                    }
                                                    return escalation1.compare(escalation2, options: .numeric) == .orderedAscending
                                                }
                                            }

                                            
                                            print("self.contactDetailsArray::::",self.contactDetailsArray)
                                            if(self.contactDetailsArray.count==0)
                                            {
                                                self.m_tableview.isHidden=true
                                                self.m_noInternetView.isHidden=false
                                                if m_windowPeriodStatus{
                                                    self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
                                                    self.m_errorMsgTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                    self.m_errorMsgDetailLbl.text = "During_Enrollment_Header2_ContactErrorMsg".localized()
                                                }else{
                                                    self.m_errorImageView.image=UIImage(named: "PEContactNotFound")
                                                    self.m_errorMsgTitleLbl.text = "During_PostEnrollment_Header_ContactErrorMsg".localized()
                                                    self.m_errorMsgDetailLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                                }
                                            }
                                            else
                                            {
                                                print(self.contactDetailsArray.count)
                                                self.m_tableview.isHidden=false
                                                self.m_noInternetView.isHidden=true
                                                
                                                //self.scrollToTop()
                                            }
                                            
                                            self.m_tableview.reloadData()
                                            self.hidePleaseWait()
                                        }
                                    }catch{
                                        print("Eroor in getPostContactDetailsPortal do ",error)
                                    }
                                }
                                else if httpResponse.statusCode == 401{
                                    self.retryCountContacts+=1
                                    print("retryCountContacts: ",self.retryCountContacts)
                                    
                                    if self.retryCountContacts <= self.maxRetryContacts{
                                        print("Some error occured getPostContactDetailsPortal",httpResponse.statusCode)
                                        self.getUserTokenGlobal(completion: { (data,error) in
                                            self.getPostContactDetailsPortal()
                                        })
                                    }
                                    else{
                                        print("retryCountContacts 401 else : ",self.retryCountContacts)
                                        DispatchQueue.main.async
                                        {
                                            self.hidePleaseWait()
                                            self.m_noInternetView.isHidden = false
                                            self.m_errorImageView.isHidden = false
                                            self.m_errorMsgTitleLbl.isHidden = false
                                            self.m_errorMsgDetailLbl.isHidden = false
                                            if m_windowPeriodStatus{
                                                self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
                                                self.m_errorMsgTitleLbl.text = "During_Enrollment_Header1_ContactErrorMsg".localized()
                                                self.m_errorMsgDetailLbl.text = "During_Enrollment_Header2_ContactErrorMsg".localized()
                                            }else{
                                                self.m_errorImageView.image=UIImage(named: "PEContactNotFound")
                                                self.m_errorMsgTitleLbl.text = "During_PostEnrollment_Header_ContactErrorMsg".localized()
                                                self.m_errorMsgDetailLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                            }
                                            self.m_tableview.isHidden=true
                                            
                                        }
                                    }
                                }
                                else if httpResponse.statusCode == 400{
                                    DispatchQueue.main.sync(execute: {
                                        self.retryCountContacts+=1
                                        print("retryCountContacts: ",self.retryCountContacts)
                                        
                                        if self.retryCountContacts <= self.maxRetryContacts{
                                            print("Some error occured getPostContactDetailsPortal",httpResponse.statusCode)
                                            self.getUserTokenGlobal(completion: { (data,error) in
                                                self.getPostContactDetailsPortal()
                                            })
                                        }
                                        else{
                                            print("retryCountContacts 400 else : ",self.retryCountContacts)
                                            DispatchQueue.main.async
                                            {
                                                self.hidePleaseWait()
                                                self.m_noInternetView.isHidden = false
                                                self.m_errorImageView.isHidden = false
                                                self.m_errorMsgTitleLbl.isHidden = false
                                                self.m_errorMsgDetailLbl.isHidden = false
                                                if m_windowPeriodStatus{
                                                    self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
                                                    self.m_errorMsgTitleLbl.text = "During_Enrollment_Header1_ContactErrorMsg".localized()
                                                    self.m_errorMsgDetailLbl.text = "During_Enrollment_Header2_ContactErrorMsg".localized()
                                                }else{
                                                    self.m_errorImageView.image=UIImage(named: "PEContactNotFound")
                                                    self.m_errorMsgTitleLbl.text = "During_PostEnrollment_Header_ContactErrorMsg".localized()
                                                    self.m_errorMsgDetailLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                                }
                                                self.m_tableview.isHidden=true
                                                
                                            }
                                        }
                                    })
                                }
                                else{
                                    self.hidePleaseWait()
                                    print("retryCountContacts 400 else : ",self.retryCountContacts)
                                    DispatchQueue.main.async
                                    {
                                        self.hidePleaseWait()
                                        self.m_noInternetView.isHidden = false
                                        self.m_errorImageView.isHidden = false
                                        self.m_errorMsgTitleLbl.isHidden = false
                                        if m_windowPeriodStatus{
                                            self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
                                            self.m_errorMsgTitleLbl.text = "During_Enrollment_Header1_ContactErrorMsg".localized()
                                            self.m_errorMsgDetailLbl.text = "During_Enrollment_Header2_ContactErrorMsg".localized()
                                        }else{
                                            self.m_errorImageView.image=UIImage(named: "PEContactNotFound")
                                            self.m_errorMsgTitleLbl.text = "During_PostEnrollment_Header_ContactErrorMsg".localized()
                                            self.m_errorMsgDetailLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                        }
                                        self.m_tableview.isHidden=true
                                        
                                        
                                    }
                                }
                            }
                            else {
                                print("Can't cast response to NSHTTPURLResponse")
                                self.displayActivityAlert(title: m_errorMsg)
                                self.hidePleaseWait()
                            }
                        }
                        
                    }
                    task.resume()
                    
                }
                else
                {
                    DispatchQueue.main.async
                    {
                        self.hidePleaseWait()
                        self.m_noInternetView.isHidden = false
                        self.m_errorImageView.isHidden = false
                        self.m_errorMsgTitleLbl.isHidden = false
                        self.m_errorMsgDetailLbl.isHidden = false
                        if m_windowPeriodStatus{
                            self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
                            self.m_errorMsgTitleLbl.text = "During_Enrollment_Header1_ContactErrorMsg".localized()
                            self.m_errorMsgDetailLbl.text = "During_Enrollment_Header2_ContactErrorMsg".localized()
                        }else{
                            self.m_errorImageView.image=UIImage(named: "PEContactNotFound")
                            self.m_errorMsgTitleLbl.text = "During_PostEnrollment_Header_ContactErrorMsg".localized()
                            self.m_errorMsgDetailLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                        }
                        self.m_tableview.isHidden=true
                        
                    }
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.hidePleaseWait()
                    self.m_noInternetView.isHidden = false
                    self.m_errorImageView.isHidden = false
                    self.m_errorMsgTitleLbl.isHidden = false
                    self.m_errorImageView.image = UIImage(named: "nointernet")
                    self.m_errorMsgTitleLbl.text = error_NoInternet
                    self.m_errorMsgDetailLbl.text = ""
                    self.m_tableview.isHidden=true
                    
                }
            }
        
    }
    
    /* // Not in use
    func getContactDetails()
    {
        if(isConnectedToNet())
        {
            var employeeDetailsArray : Array<EMPLOYEE_INFORMATION> = []
            employeeDetailsArray = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: self.m_productCode)
            var m_employeedict : EMPLOYEE_INFORMATION?
                
           if(employeeDetailsArray.count>0)
           {
            m_employeedict = employeeDetailsArray[0]
            //if let userDict:EMPLOYEE_INFORMATION = employeeDetailsArray[0]
            if(employeeDetailsArray.count>0)
            {
                var groupchildsrno = String()
                var oegrpbasinfsrno = String()
                
                if let empNo = m_employeedict?.oe_group_base_Info_Sr_No {
                    oegrpbasinfsrno = String(empNo)
                }
                if let groupChlNo = m_employeedict?.groupChildSrNo {
                    groupchildsrno=String(groupChlNo)
                }
//                groupchildsrno = String(userDict.groupChildSrNo)
//                oegrpbasinfsrno = String(userDict.oe_group_base_Info_Sr_No)
               
               
                let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getContactDetailsUrl(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno))
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?// NSURL(string: urlreq)
                request.httpMethod = "GET"
                
                
                
                
                let task = URLSession.shared.dataTask(with: urlreq! as URL)
                {
                    (data, response, error)  -> Void in
                    if error != nil
                    {
                        print("error ",error!)
                        self.hidePleaseWait()
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            if httpResponse.statusCode == 200
                            {
                                do {
                                    
                                    self.xmlKey = "Escalations"
                                    let parser = XMLParser(data: data!)
                                    parser.delegate = self
                                    parser.parse()
                                    print(self.resultsDictArray)
                                    DispatchQueue.main.async
                                        {
                                            let status = DatabaseManager.sharedInstance.deleteContactDetails(productCode: self.m_productCode)
                                            if(status)
                                            {
                                                for contactDict in self.resultsDictArray!
                                                {
                                                    DatabaseManager.sharedInstance.saveContactDetails(contactDict: contactDict as NSDictionary,productCode:self.m_productCode)
                                                }
                                            }
                                            self.contactDetailsArray =  DatabaseManager.sharedInstance.retrieveContactDetails(productCode: self.m_productCode)
                            
                            
                                        if(self.contactDetailsArray.count==0)
                                            {
                                                self.displayActivityAlert(title: "noDataFound".localized())
                                            }
                                            self.m_tableview.reloadData()
                                            self.hidePleaseWait()
                                    }
                                }
                                catch let JSONError as NSError
                                {
                                    print(JSONError)
                                    Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                }
                                
                            }
                            else
                            {
                                self.hidePleaseWait()
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                            }
                        }
                        else
                        {
                            //Crashlytics.sharedInstance().recordError(m_errorMsg as! Error)
                            Crashlytics.crashlytics().record(error: m_errorMsg as! Error)

                            print("Can't cast response to NSHTTPURLResponse")
                        }
                        
                    }
                    
                }
                task.resume()
                hidePleaseWait()
            }
           
           }
            else
           {
                self.displayActivityAlert(title: "noDataFound".localized())
                m_tableview.reloadData()
            }
           
        }
        else
        {
            
          
            m_noInternetView.isHidden=false
            contactDetailsArray =  DatabaseManager.sharedInstance.retrieveContactDetails(productCode: self.m_productCode)
            
            if(contactDetailsArray.count>0)
            {
                 m_tableview.reloadData()
                let deadlineTime = DispatchTime.now() + .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime)
                {
                    self.m_noInternetView.isHidden=true
                    
                }
            }
            
        }
    }
     */
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return contactDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ContactDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)as! ContactDetailsTableViewCell
        
        shadowForCell(view: cell.m_backGroundView)
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        
        if(contactDetailsArray.count==0)
        {
            m_tableview.isHidden=true
            m_noInternetView.isHidden=false
            m_errorImageView.image=UIImage(named: "nocontacts")
            m_errorMsgTitleLbl.text = "During_PostEnrollment_Header_ContactErrorMsg".localized()
            m_errorMsgDetailLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
        }
        else if(contactDetailsArray.count>0)
        {
            print("contactDetailsArray",contactDetailsArray)
            m_tableview.isHidden=false
            m_noInternetView.isHidden=true
            let contactDict : ContactDetails = contactDetailsArray[indexPath.row]
            
            if contactDict.dispAdd == "0"{
                cell.m_locationLbl.isHidden = true
                cell.heightAddress.constant = 0
                print("contactDict.dispAdd 0",indexPath.row)
            }else{
                cell.m_locationLbl.isHidden = false
                cell.m_locationLbl.sizeToFit()
                // Update the constant value of the heightAddress constraint
                cell.heightAddress.constant = cell.m_locationLbl.frame.height
                print("contactDict.dispAdd 24",indexPath.row)
            }
            
            if contactDict.dispMob == "0"{
                cell.phoneHeaderLbl.isHidden = true
                cell.phoneTextView.isHidden = true
                cell.heightPhnHeader.constant = 0
                cell.heightPhnText.constant = 0
            }else{
                cell.phoneHeaderLbl.isHidden = false
                cell.phoneTextView.isHidden = false
                cell.heightPhnHeader.constant = 15
                cell.heightPhnText.constant = 30
            }
            //Fax -> Lineline
//            if contactDict.dispFax == "0"{
//                cell.faxHeaderLbl.isHidden = true
//                cell.m_faxLbl.isHidden = true
//                cell.heightFaxHeader.constant = 0
//                cell.heightFaxLbl.constant = 0
//            }else{
//                cell.faxHeaderLbl.isHidden = false
//                cell.m_faxLbl.isHidden = false
//                cell.heightFaxHeader.constant = 12
//                cell.heightFaxLbl.constant = 30
//            }
            if contactDict.dispEmail == "0"{
                cell.heightemailHeader.constant = 0
                cell.heightEmailLbl.constant = 0
                cell.heightEmailBtn.constant = 0
                cell.m_emailLbl.isHidden = true
                cell.emailHeaderLbl.isHidden = true
                cell.m_mailIDButton.isHidden = true
            }else{
                cell.heightemailHeader.constant = 15
                cell.heightEmailLbl.constant = 15
                cell.heightEmailBtn.constant = 20
                cell.m_emailLbl.isHidden = true
                cell.emailHeaderLbl.isHidden = false
                cell.m_mailIDButton.isHidden = false
            }
            
            
            if contactDict.dispFax == "0"{
                cell.faxHeaderLbl.isHidden = true
                cell.m_faxLbl.isHidden = true
                cell.heightFaxHeader.constant = 0
                cell.heightFaxLbl.constant = 0
            }
            else{
                cell.faxHeaderLbl.isHidden = false
                cell.m_faxLbl.isHidden = false
                cell.faxHeaderLbl.text = "Toll Free Number"
                cell.m_faxLbl.text = contactDict.phoneNumber?.uppercased() ?? "-"
                cell.heightFaxHeader.constant = 12
                cell.heightFaxLbl.constant = 30
            }
            
            
            cell.m_locationLbl.text=contactDict.address
            //cell.m_contactNumberButton.tag=indexPath.row
            //cell.m_contactNumberButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
           
//            let mobNumber = String()
            var numbers = String()
            var mobNumber = contactDict.mobileNumber
            var phoneNo = contactDict.phoneNumber
            
            print("mobNumber: ",mobNumber," :phoneNo ",phoneNo)
           
            if(mobNumber == "-" || mobNumber == "" || mobNumber?.uppercased() == "NOT AVAILABLE")
            {
                numbers = phoneNo ?? ""
            
            }
            else if(phoneNo == "-" || phoneNo == "" || phoneNo?.uppercased() == "NOT AVAILABLE")
            {
                 numbers = mobNumber ?? ""
            
            }
            else
            {
                if phoneNo == "NOT AVAILABLE" || phoneNo == "NOTAVAILABLE"{
                    phoneNo = ""
                }
                if mobNumber == "NOT AVAILABLE" || mobNumber == "NOTAVAILABLE"{
                    mobNumber = ""
                }
                if mobNumber != nil && phoneNo != nil{
                    mobNumber = mobNumber!.replacingOccurrences(of: " ", with: "")
                    numbers = mobNumber! + " " + phoneNo!
                    numbers = numbers.replacingOccurrences(of: "-", with: "")
                }
            }
            
//                       let totalCUG = "CUG"
//                       let totalDir = "| Direct"
//
//                        let mainStatment = numbers
//                        if mainStatment.contains(totalCUG) || mainStatment.contains(totalDir) {
//
//                            let attributedWithTextColor: NSAttributedString = mainStatment.attributedStringWithColor(["CUG", "| Direct"], color: UIColor.darkGray)
//
//                            cell.phoneTextView.attributedText = attributedWithTextColor
//
//                        }else{
//                            cell.phoneTextView.text = numbers
//                        }
                       
            print("phoneTextView numbers: ",numbers)
            cell.phoneTextView.text = numbers
            //cell.m_contactNumberButton.setTitle(numbers, for: .normal)
            
            var emailIDStr = contactDict.emailID?.replace(string: "&nbsp;", replacement: "")
            cell.m_mailIDButton.setTitle(emailIDStr, for: .normal)
            cell.m_mailIDButton.tag=indexPath.row
            cell.m_mailIDButton.addTarget(self, action: #selector(sendMailButtonTapped), for: .touchUpInside)
            if contactDict.faxNo?.lowercased() == "not available"{
                cell.m_faxLbl.text="-"
            }else{
                cell.m_faxLbl.text=contactDict.faxNo
            }
            
            //cell.m_faxLbl.text=contactDict.faxNo
            cell.m_emailLbl.text=contactDict.emailID
            var name = contactDict.person_Name
            name = name?.replacingOccurrences(of: "nbsp", with: "")
            name = name?.replacingOccurrences(of: ";", with: "")
            cell.m_nameLbl.text=name
            
            switch contactDict.contactType
            {
            case "BROKER"?:
//                cell.m_badgeImageView.image =  UIImage(named: "Badge_Red")
//                cell.m_typeColorlbl.backgroundColor=hexStringToUIColor(hex: "FF1000")
                cell.m_badgeImageView.image =  UIImage(named: "Badge_Broker") //Pink
                cell.m_typeColorlbl.backgroundColor=FontsConstant.shared.app_FontAppColor
//                cell.m_typeColorlbl.isHidden=false
                
                break
            case "TPA"?:
//                cell.m_badgeImageView.image = UIImage(named: "Badge_Blue")
//                cell.m_typeColorlbl.backgroundColor=hexStringToUIColor(hex: "4672B9")
                cell.m_badgeImageView.image = UIImage(named: "Badge_TPA") //Dark Blue
                cell.m_typeColorlbl.backgroundColor=FontsConstant.shared.HosptailLblPrimary
//                cell.m_typeColorlbl.isHidden=false
                break
            case "HR"?:
//                cell.m_badgeImageView.image = UIImage(named: "Badge_Yellow")
//                cell.m_typeColorlbl.backgroundColor=hexStringToUIColor(hex: "E7BE2A")
                cell.m_badgeImageView.image = UIImage(named: "Badge_Red") //Purple
                cell.m_typeColorlbl.backgroundColor=FontsConstant.shared.HosptailLblTertiary
//                cell.m_typeColorlbl.isHidden=false
                break
            case "CORPORATE"?:
//                cell.m_badgeImageView.image = UIImage(named: "Badge_Red")
//                cell.m_typeColorlbl.backgroundColor=hexStringToUIColor(hex: "FF1000")
                cell.m_badgeImageView.image = UIImage(named: "Badge_Corporate") //Green
                cell.m_typeColorlbl.backgroundColor=FontsConstant.shared.corporate
//                cell.m_typeColorlbl.isHidden=false
                break
            case ""?:
                cell.m_badgeImageView.image=nil
//                cell.m_typeColorlbl.isHidden=true
                
                break
            default:
                cell.m_badgeImageView.image =  UIImage(named: "Badge_TPA")
                cell.m_typeColorlbl.backgroundColor=FontsConstant.shared.HosptailLblPrimary
                break
            }
            
            /*
           if let level = contactDict.escalation?.components(separatedBy: " ")
           {
            if(level.count>1)
            {
            if let levelNumber : String = level[1]
            {
                if(levelNumber=="APPLICABLE")
                {
                    cell.m_levelNumberLbl.isHidden=true
                    cell.m_badgeImageView.image=nil
                }
                else
                {
                    cell.m_levelNumberLbl.isHidden=false
                    cell.m_levelNumberLbl.text=levelNumber
                }
            }
            else
            {
                cell.m_levelNumberLbl.isHidden=true
                cell.m_badgeImageView.image=nil
            }
            }
            else
            {
                cell.m_levelNumberLbl.isHidden=true
                cell.m_badgeImageView.image=nil
            }
            }
            */
            
            //Added By Pranit
            if let level = contactDict.escalation {
                cell.m_levelNumberLbl.text = level
                cell.m_levelNumberLbl.isHidden = false
                cell.m_badgeImageView.isHidden = false
            }
            else {
                cell.m_levelNumberLbl.isHidden = true
                cell.m_badgeImageView.isHidden = true
            }
            
            cell.m_levelNumberLbl.text = (indexPath.row + 1).description
        }
        else
        {
            m_tableview.isHidden=true
            m_noInternetView.isHidden=false
            m_errorImageView.image=UIImage(named: "nocontacts")
            m_errorMsgTitleLbl.text = "During_PostEnrollment_Header_ContactErrorMsg".localized()
            m_errorMsgDetailLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
        }
        
       
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if let postCell = cell as? ContactDetailsTableViewCell
        {
//            self.tableView(tableView: m_tableview, willDisplayMyCell: postCell, forRowAtIndexPath: indexPath as NSIndexPath)
        }
        
    }
    private func tableView(tableView: UITableView, willDisplayMyCell myCell: ContactDetailsTableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        TipInCellAnimator.animate(cell: myCell)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 250
//        return calculateHeightForRow(indexPath: indexPath)
        return UITableViewAutomaticDimension
        
    }
    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
        m_escalationsArray = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        
        if elementName == xmlKey
        {
            currentDictionary = [String : String]()
        }
        else if dictionaryKeys.contains(elementName)
        {
            
            self.currentValue = String()
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        self.currentValue += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == xmlKey
        {
            resultsDictArray?.append(currentDictionary!)
            self.currentDictionary = [:]
            
        }
        else if dictionaryKeys.contains(elementName)
        {
            if(elementName=="Escalations1"||elementName=="Escalations2"||elementName=="Escalations3"||elementName=="Escalations4"||elementName=="Escalations5" || elementName=="Escalations6"||elementName=="Escalations7"||elementName=="Escalations8"||elementName=="Escalations9"||elementName=="Escalations10")
            {
                m_escalationsArray?.append(currentDictionary!)
            }
            else
            {
                self.currentDictionary![elementName] = currentValue
                self.currentValue = ""
            }
            
        }
        
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        
        
    }
    
    @IBAction func GMCTabSelected(_ sender: Any)
    {
        if isGHIDataPresent{
            m_productCode = "GMC"
            selectedIndexPosition = 0
            self.resultsDictArray?.removeAll()
            self.m_escalationsArray?.removeAll()
            GMCTabSeleted()
            
            contactDetailsArray=[]
            //        getContactDetails()
        }else{
            self.displayActivityAlert(title: "Policy not available!")
        }
    }
    
    @IBAction func GPATabSelected(_ sender: Any)
    {
//        if userEmployeeSrnoGPA == ""{
//            self.displayActivityAlert(title: "Please contact your HR or Marsh Ops. team")
//        }else{
            if isGPADataPresent{
                m_productCode = "GPA"
                selectedIndexPosition = 0
                self.resultsDictArray?.removeAll()
                self.m_escalationsArray?.removeAll()
                GPATabSelect()
            }else{
                self.displayActivityAlert(title: "Policy not available!")
            }
//        }
    }
    @IBAction func GTLTabSelected(_ sender: Any)
    {
//        if userEmployeeSrnoGTL == ""{
//            self.displayActivityAlert(title: "Please contact your HR or Marsh Ops. team")
//        }else{
            if isGTLDataPresent{
                m_productCode = "GTL"
                selectedIndexPosition = 0
                self.resultsDictArray?.removeAll()
                self.m_escalationsArray?.removeAll()
                GTLTabSelect()
            }else{
                self.displayActivityAlert(title: "Policy not available!")
            }
//        }
    }
    func GPATabSelect()
    {
        m_productCode = "GPA"
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        }
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        if policyDataArray.count > selectedIndexPosition{
            print("ContactDetailsViewController selectedIndexPosition GPA ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("ContactDetailsViewController selectedIndexPosition GPA ",selectedIndexPosition)
        }
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        //GPAShadowView.dropShadow()
        GTLShadowView.layer.masksToBounds=true
        GMCShadowView.layer.masksToBounds=true
        
        m_GPATab.layer.masksToBounds=true
        m_GPATab.layer.cornerRadius=cornerRadiusForView//m_GPATab.frame.size.height/2
        //        m_GPATab.layer.borderColor=hexStringToUIColor(hex: "622140").cgColor
        m_GPATab.layer.borderWidth=0
        m_GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        m_GPATabLine.backgroundColor=hexStringToUIColor(hex: "622140")
        m_GPATab.setTitleColor(UIColor.white, for: .normal)
        
        m_GMCTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GTLTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GMCTab.layer.borderWidth = 2
        m_GTLTab.layer.borderWidth = 2
        
       
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
        m_GTLTab.layer.cornerRadius = cornerRadiusForView//8
        GPAShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        m_GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GTLTab.setBackgroundImage(nil, for: .normal)
        
        contactDetailsArray=[]
        //getPostContactDetails()
        getPostContactDetailsPortal()
        
        
    }
    
    func GTLTabSelect()
    {
        m_productCode = "GTL"
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        }
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        if policyDataArray.count > selectedIndexPosition{
            print("ContactDetailsViewController selectedIndexPosition GTL ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("ContactDetailsViewController selectedIndexPosition GTL ",selectedIndexPosition)
        }
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
       
        //GTLShadowView.dropShadow()
        GPAShadowView.layer.masksToBounds=true
        GMCShadowView.layer.masksToBounds=true
        
        m_GTLTab.layer.masksToBounds=true
        m_GTLTab.layer.cornerRadius=cornerRadiusForView//m_GTLTab.frame.size.height/2
        //        m_GTLTab.layer.borderColor=hexStringToUIColor(hex: "622140").cgColor
        m_GTLTab.layer.borderWidth=0
        m_GTLTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        m_GTLTabLine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
        m_GTLTab.setTitleColor(UIColor.white, for: .normal)
        
        m_GMCTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GPATabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GPATab.layer.borderWidth = 2
        m_GMCTab.layer.borderWidth = 2
        
       
        m_GPATab.layer.cornerRadius = cornerRadiusForView//8
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
        GTLShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        
        
        contactDetailsArray=[]
        //getPostContactDetails()
        getPostContactDetailsPortal()
    }
    func scrollToTop()
    {
        let indexpath = IndexPath(row: 0, section: 0)
        m_tableview.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
    }
    @objc func callButtonTapped(sender:UIButton)
    {
        var number = sender.titleLabel?.text?.replacingOccurrences(of:" ", with: "", options: NSString.CompareOptions.literal, range: nil)
        number = number?.replacingOccurrences(of:"+91", with: "", options: NSString.CompareOptions.literal, range: nil)
        print(number ?? "8412985355")
        if let url = URL(string: "tel://"+number!), UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10, *)
            {
                UIApplication.shared.open(url)
            }
            else
            {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @objc func sendMailButtonTapped(sender:UIButton)
    {
        let mailID = sender.titleLabel?.text
       
        
        if let mailURL = NSURL(string: "mailto://"+mailID!), UIApplication.shared.canOpenURL(mailURL as URL)
        {
            if #available(iOS 10, *)
            {
                UIApplication.shared.open(mailURL as URL)
            }
            else
            {
                UIApplication.shared.openURL(mailURL as URL)
            }
        }
        
    }
    
    func addTarget()
    {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.selectPolicyName (_:)))
        self.PolicylblView.addGestureRecognizer(gesture)
        
    }
    
    @objc func selectPolicyName(_ sender:UITapGestureRecognizer)
    {
        print("selectPolicyName 1029")
        
        let policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        print("policyDataArray: ",policyDataArray)
        
        if policyDataArray.count > 0 {
            let vc  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"SelectPolicyOptionsVC") as! SelectPolicyOptionsVC
            //vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            vc.policyDelegateObj = self
            vc.policyCount = policyDataArray.count
            UserDefaults.standard.set(true, forKey: "isPolicyChanged")
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func policyChangedDelegateMethod() {
        print("Called policyChangedDelegateMethod")
        
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        print("selectedIndexPosition is : ",selectedIndexPosition)
        
        if policyDataArray.count > selectedIndexPosition{
            print("ContactDetailsViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("ContactDetailsViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        
        getPostContactDetailsPortal()
    }
    
    func shouldSkipSavingContact(contactDict: [String: String]) -> Bool {
        let dispEmail = contactDict["DISP_EMAIL"] ?? ""
        let dispMob = contactDict["DISP_MOB"] ?? ""
        let dispAdd = contactDict["DISP_ADD"] ?? ""
        let dispFax = contactDict["DISP_FAX"] ?? ""

        // Add your condition here
        return dispEmail == "0" && dispMob == "0" && dispAdd == "0" && dispFax == "0"
    }
    
    func calculateHeightForRow(indexPath: IndexPath) -> CGFloat {
        
        let contactDetails: ContactDetails = contactDetailsArray[indexPath.row]
        // Ensure m_escalationsArray is not nil and has enough elements
         guard let m_escalationsArray = self.m_escalationsArray, indexPath.row < m_escalationsArray.count else {
             return UITableViewAutomaticDimension
         }

         let contactDict = m_escalationsArray[indexPath.row]
        // Check the value of "DISP_ADD" in the current contact dictionary
        if let dispAdd = contactDict["DISP_ADD"], dispAdd == "0" {
            return 170
        } else {
            return UITableViewAutomaticDimension
        }
    }

}

extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}
