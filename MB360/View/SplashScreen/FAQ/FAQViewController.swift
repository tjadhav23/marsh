//
//  FAQViewController.swift
//  MyBenefits
//
//  Created by Semantic on 17/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import FirebaseCrashlytics
import TrustKit
import AesEverywhere

class FAQViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,XMLParserDelegate, NewPoicySelectedDelegate {
    
    
    
    @IBOutlet weak var m_tableView: UITableView!
    
    @IBOutlet weak var GMCShadowView: UIView!
    @IBOutlet weak var GPAShadowView: UIView!
    @IBOutlet weak var GTLShadowView: UIView!
    
    /*@IBOutlet weak var m_GTLTab: UIButton!
    @IBOutlet weak var m_GPATab: UIButton!
    @IBOutlet weak var m_GMCTab: UIButton!
     */
    
    @IBOutlet weak var m_GMCTab: UIButton!
    @IBOutlet weak var m_GPATab: UIButton!
    @IBOutlet weak var m_GTLTab: UIButton!
    
    @IBOutlet weak var m_topBarView: UIView!
    
    @IBOutlet weak var PolicylblView: UIView!
    @IBOutlet weak var policyNamelbl: UILabel!
    @IBOutlet weak var policyButtonView: UIView!
    @IBOutlet weak var policyButtonLbl: UILabel!
   
    @IBOutlet weak var m_noInternetView: UIView!
    @IBOutlet weak var m_errorImageview: UIImageView!
    
    @IBOutlet weak var noInternetHeaderLbl: UILabel!
    @IBOutlet weak var noInternetDescLbl: UILabel!
    
    var selectedIndexPosition = -1
    var policyDataArray = [OE_GROUP_BASIC_INFORMATION]()
    var selectedPolicyValue = ""
    
    var m_productCode = String()
    var reuseIdentifier = "cell"
    var datasource = [ExpandedCell]()
    var selectedRowIndex = -1
    var m_employeedict : EMPLOYEE_INFORMATION?
    var xmlKey = String()
    var resultsDictArray: [[String: String]]? // the whole array of dictionaries
    
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    let dictionaryKeys=["FAQsValues","FAQ_QUESTION","FAQ_ANSWER"]
    var isFromSideBar = Bool()
    var FaqArray = Array<FaqDetails>()
    
    var retryCountFAQPortal = 0
    var maxRetryFAQPortal = 1
    
    var clickedOegrp = ""
    var clickedEmpSrNo = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupFontUI()
        
        //Top bar hide buttons
        m_GMCTab.isHidden=true
        m_GPATab.isHidden=true
        m_GTLTab.isHidden=true
        
        m_GMCTab.layer.borderWidth = 2
        m_GPATab.layer.borderWidth = 2
        m_GTLTab.layer.borderWidth = 2
        
        m_GMCTab.layer.cornerRadius = 8
        m_GPATab.layer.cornerRadius = 8
        m_GTLTab.layer.cornerRadius = 8
        
        addTarget()
        m_tableView.register(FAQTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let nib = UINib (nibName: "FAQTableViewCell", bundle: nil)
        m_tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        m_tableView.tableFooterView=UIView()
        
        PolicylblView.setBorderToViewSelectPolicy(color:hexStringToUIColor(hex: "E5E5E5"))
        m_topBarView.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
       
        navigationController?.isNavigationBarHidden=false
        navigationItem.leftBarButtonItem=getBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        self.tabBarController?.tabBar.isHidden=false
        self.navigationItem.title="FAQs"
        
        menuButton.isHidden = false
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
                
        print("FAQ Page Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
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
            GPATabSelected()
            
        }
        else if m_productCode == "GTL"{
            GTLTabSelected()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        print("FAQ selectedIndexPosition is viewWillAppear  : ",selectedIndexPosition)
        
       
        navigationController?.navigationBar.isHidden=false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        menuButton.isHidden=false
    }
    
    func setupFontUI(){
        m_GMCTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GMCTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_GPATab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GPATab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_GTLTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GTLTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        policyNamelbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        policyNamelbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        policyButtonLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        policyButtonLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        
        noInternetHeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        noInternetHeaderLbl.textColor = FontsConstant.shared.app_FontLightGreyColor
       
        noInternetDescLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        noInternetDescLbl.textColor = FontsConstant.shared.app_FontLightGreyColor
       
        
    }
    
    @objc private func homeButtonClicked(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        //tabBarController!.selectedIndex = 2
    }
    
    @objc override func backButtonClicked()
    {
        print ("backButtonClicked")
        if(isFromSideBar)
        {
            self.tabBarController?.tabBar.isHidden=false
            
        }
        else
        {
            self.tabBarController?.tabBar.isHidden=false
            _ = navigationController?.popViewController(animated: true)
        }
    }
    /*
    func faqDetails()
    {
        if(isConnectedToNetWithAlert())
        {
            let array = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            if(array.count>0)
            {
                m_employeedict=array[0]
                if (m_employeedict==nil)
                {
                    
                    //            m_employeedict=nil
                    //displayActivityAlert(title: "noDataFound".localized())
                    
                }
                else
                {
                    
                    showPleaseWait(msg: "Please wait...")
                    
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    var employeesrno = String()
                    
                    if let childNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String//m_employeedict?.groupChildSrNo
                    {
                        groupchildsrno = String(childNo)
                    }
                    if let oeinfNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String//m_employeedict?.oe_group_base_Info_Sr_No
                    {
                        oegrpbasinfsrno = String(oeinfNo)
                    }
                    if let empNo = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String//m_employeedict?.empSrNo
                    {
                        employeesrno = String(empNo)
                    }
                    
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getFAQDetailsurl(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno))
                    
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?// NSURL(string: urlreq)
                    request.httpMethod = "GET"
                    
                    print("FAQ URL: ",urlreq)
                    let task = URLSession.shared.dataTask(with: urlreq! as URL)
                    { (data, response, error) in
                        
                        if data == nil
                        {
                            
                            return
                        }
                        self.xmlKey = "FAQsValues"
                        let parser = XMLParser(data: data!)
                        parser.delegate = self
                        parser.parse()
                        for dict in self.resultsDictArray!
                        {
                            let dic : NSDictionary = dict as NSDictionary
                            self.datasource.append(ExpandedCell(title: dic.value(forKey: "FAQ_QUESTION") as! String, answer:dic.value(forKey: "FAQ_ANSWER") as! String))
                        }
                        DispatchQueue.main.async
                        {
                            
                            
                            self.m_tableView.reloadData()
                            self.hidePleaseWait()
                            self.scrollToTop()
                        }
                        
                        
                    }
                    task.resume()
                }
            }
        }
        else
        {
            displayActivityAlert(title: "Not connected to Internet")
        }
    }
    */
    
    func faqDetailsPortal(){
        if(isConnectedToNetWithAlert())
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
            
            print("faqDetailsPortal Userdefaults userGroupChildNo: ",userGroupChildNo," clickedOegrp: ",clickedOegrp," m_productCode:",m_productCode," clickedEmpSrNo: ",clickedEmpSrNo," employeeSrNoGMCValue: ",employeeSrNoGMCValue)
            
            if userGroupChildNo != "" && clickedOegrp != ""
            {
                    showPleaseWait(msg: "Please wait...")
                    
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    var employeesrno = String()
                    
                    if let childNo = userGroupChildNo as? String
                    {
                        groupchildsrno = String(childNo)
                        groupchildsrno = try! AES256.encrypt(input: groupchildsrno, passphrase: m_passphrase_Portal)
                        
                    }
                    if let empNo = clickedEmpSrNo as? String
                    {
                        employeesrno = String(empNo)
                        employeesrno = try! AES256.encrypt(input: employeesrno, passphrase: m_passphrase_Portal)
                    }
                    if selectedIndexPosition == 0{
                        if let oegrp = clickedOegrp as? String{
                            oegrpbasinfsrno = String(oegrp)
                            oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                        
                        }
                    }else{
                        oegrpbasinfsrno = selectedPolicyValue
                        oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                    
                    }
                    
                    print("m_productCode : ",m_productCode," : groupchildsrno: ",groupchildsrno," : employeesrno: ",employeesrno," : oegrpbasinfsrno: ",oegrpbasinfsrno)
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getFAQDetailsurlPortal(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded))
                    
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
                    print("authToken FAQ:",authToken)
                 
                    request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                    
                    
                    //SSL Pinning
                    let sessionConfig = URLSessionConfiguration.default
                    sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
                    sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
                    TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
                    let session = URLSession(
                                   configuration: sessionConfig,
                                   delegate: URLSessionPinningDelegate(),
                                   delegateQueue: nil)
                  
                    
                    print("FAQ url: ",urlreq)
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                        //SSL Pinning
                        if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                            // Handle SSL connection failure
                            print("SSL connection error: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                self.alertForLogout(titleMsg: error.localizedDescription)
                            }
                        }
                        else if let error = error {
                            print("faqDetailsPortal() error:", error)
                            DispatchQueue.main.async
                            {
                                self.hidePleaseWait()
                                self.m_noInternetView.isHidden = false
                                self.m_errorImageview.isHidden = false
                                self.noInternetHeaderLbl.isHidden = false
                                self.noInternetDescLbl.isHidden = false
                                if m_windowPeriodStatus{
                                    self.m_errorImageview.image=UIImage(named: "duringEnrollDataNotFound")
                                    self.noInternetHeaderLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                    self.noInternetDescLbl.text = "During_Enrollment_Header_FaqErrorMsg".localized()
                                }else{
                                    self.m_errorImageview.image=UIImage(named: "nodocuments")
                                    self.noInternetHeaderLbl.text = "FAQs not updated for your corporate"
                                    self.noInternetDescLbl.text = "Please contact your HR or Marsh Ops. team for more information"
                                }
                                self.m_tableView.isHidden=true
                                
                            }
                            return
                            
                        }
                        else{
                        
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            print("faqDetailsPortal httpResponse.statusCode: ",httpResponse.statusCode)
                            
                            if httpResponse.statusCode == 200{
                                do{
                                    guard let data = data else { return }
                                    DispatchQueue.main.async {
                                        self.m_noInternetView.isHidden = true
                                    }
                                    let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                                    if let data = json?["FAQ_DATA"] as? [Any] {
                                        self.datasource.removeAll()
                                        
                                        self.resultsDictArray = json?["FAQ_DATA"] as! [[String : String]]
                                        if self.resultsDictArray!.count > 0{
                                            DispatchQueue.main.async{
                                                self.m_tableView.isHidden = false
                                            }
                                            print("resultsDictArray : ",self.resultsDictArray)
                                          
                                            
                                            for item in data {
                                                if let object = item as? [String: Any] {
                                                    
                                                    // Faq_Sr_No
                                                    let Faq_Sr_No = object["Faq_Sr_No"] as? String ?? "0"
                                                    print("Faq_Sr_No: \(Faq_Sr_No)")
                                                    
                                                    // Faq_Question
                                                    let Faq_Question = object["Faq_Question"] as? String ?? ""
                                                    print("Faq_Question: \(Faq_Question)")
                                                    
                                                    // Faq_Ans
                                                    let Faq_Ans = object["Faq_Ans"] as? String ?? ""
                                                    print("Faq_Ans: \(Faq_Ans)")
                                                    
                                                    // Faq_Order
                                                    let Faq_Order = object["Faq_Order"] as? String ?? "0"
                                                    print("Faq_Order: \(Faq_Order)")
                                                    
                                                    
                                                    let dic : NSDictionary = item as! NSDictionary
                                                    self.datasource.append(ExpandedCell(title: dic.value(forKey: "Faq_Question") as! String, answer:dic.value(forKey: "Faq_Ans") as! String))
                                                    // self.resultsDictArray = item as? [[String : String]]
                                                    
                                                }
                                                print("datasource : ",self.datasource)
                                            }
                                            DispatchQueue.main.async{
                                                let status = DatabaseManager.sharedInstance.deleteFaqDetailsData(self.m_productCode)
                                                if status{
                                                    for dict in self.resultsDictArray!{
                                                            DatabaseManager.sharedInstance.saveFaqDetails(contactDict: dict as NSDictionary, productCode: self.m_productCode)
                                                        
                                                    }
                                                }
                                            }
                                            //self.FaqArray = DatabaseManager.sharedInstance.retrieveFaqDetails(productCode: self.m_productCode)
                                            print("datasource count : ",self.datasource.count)
                                            print("FAQArray: ",self.FaqArray)
                                            print("resultsDictArray: ",self.resultsDictArray?.count)
                                            DispatchQueue.main.async
                                            {
                                                //                            self.m_tableView.reloadData()
                                                //                            if self.datasource.count > 0{
                                                //                                let indexPath = IndexPath(row: 0, section: 0)
                                                //                                self.m_tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                                                //                                self.m_tableView.delegate?.tableView?(self.m_tableView, didSelectRowAt: indexPath)
                                                //                            }
                                                //                            self.hidePleaseWait()
                                                //                            self.scrollToTop()
                                                if self.resultsDictArray!.count > 0{
                                                    self.m_tableView.reloadData()
                                                    if self.datasource.count > 0{
                                                        let indexPath = IndexPath(row: 0, section: 0)
                                                        self.m_tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                                                        self.m_tableView.delegate?.tableView?(self.m_tableView, didSelectRowAt: indexPath)
                                                    }
                                                    self.hidePleaseWait()
                                                    self.scrollToTop()
                                                }else{
                                                    //self.displayActivityAlert(title: "noDataFound".localized())
                                                    print("No data found!")
                                                }
                                            }
                                        }else{
                                                self.hidePleaseWait()
                                            DispatchQueue.main.sync{
                                                self.m_tableView.isHidden = true
                                                self.m_noInternetView.isHidden=false
                                                
                                                print(m_windowPeriodStatus)
                                                if m_windowPeriodStatus{
                                                    self.m_errorImageview.image=UIImage(named: "duringEnrollDataNotFound")
                                                    self.noInternetHeaderLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                    self.noInternetDescLbl.text = "During_Enrollment_Header_FaqErrorMsg".localized()
                                                }else{
                                                    self.m_errorImageview.image=UIImage(named: "nodocuments")
                                                    self.noInternetHeaderLbl.text = "FAQs not updated for your corporate"
                                                    self.noInternetDescLbl.text = "Please contact your HR or Marsh Ops. team for more information"
                                                }
                                            }
                                            //self.displayActivityAlert(title: "noDataFound".localized())
                                            print("No data found!")
                                            }
                                        }
                                        
                                        
                                    }catch{
                                    
                                }
                            }else if httpResponse.statusCode == 401{
                                self.retryCountFAQPortal+=1
                                print("retryCountFAQPortal: ",self.retryCountFAQPortal)
                                
                                if self.retryCountFAQPortal <= self.maxRetryFAQPortal{
                                    print("Some error occured getNewPolicyFeaturesPortal",httpResponse.statusCode)
                                    self.getUserTokenGlobal(completion: { (data,error) in
                                        self.faqDetailsPortal()
                                    })
                                }
                                else{
                                    print("retryCountFAQPortal 401 else : ",self.retryCountFAQPortal)
                                    DispatchQueue.main.async
                                    {
                                        self.hidePleaseWait()
                                        self.m_tableView.isHidden = true
                                        self.m_noInternetView.isHidden=false
                                        
                                        if m_windowPeriodStatus{
                                            self.m_errorImageview.image=UIImage(named: "duringEnrollDataNotFound")
                                            self.noInternetHeaderLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                            self.noInternetDescLbl.text = "During_Enrollment_Header_FaqErrorMsg".localized()
                                        }else{
                                            self.m_errorImageview.image=UIImage(named: "nodocuments")
                                            self.noInternetHeaderLbl.text = "FAQs not updated for your corporate"
                                            self.noInternetDescLbl.text = "Please contact your HR or Marsh Ops. team for more information"
                                        }
                                        
                                    }
                                }
                            }
                            else if httpResponse.statusCode == 400{
                                DispatchQueue.main.sync(execute: {
                                    self.retryCountFAQPortal+=1
                                    print("retryCountFAQPortal: ",self.retryCountFAQPortal)
                                    
                                    if self.retryCountFAQPortal <= self.maxRetryFAQPortal{
                                        print("Some error occured getNewPolicyFeaturesPortal",httpResponse.statusCode)
                                        self.getUserTokenGlobal(completion: { (data,error) in
                                            self.faqDetailsPortal()
                                        })
                                    }
                                    else{
                                        print("retryCountFAQPortal 400 else : ",self.retryCountFAQPortal)
                                        DispatchQueue.main.async
                                        {
                                            self.hidePleaseWait()
                                            self.m_tableView.isHidden = true
                                            self.m_noInternetView.isHidden=false
                                            
                                            if m_windowPeriodStatus{
                                                self.m_errorImageview.image=UIImage(named: "duringEnrollDataNotFound")
                                                self.noInternetHeaderLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                self.noInternetDescLbl.text = "During_Enrollment_Header_FaqErrorMsg".localized()
                                            }else{
                                                self.m_errorImageview.image=UIImage(named: "nodocuments")
                                                self.noInternetHeaderLbl.text = "FAQs not updated for your corporate"
                                                self.noInternetDescLbl.text = "Please contact your HR or Marsh Ops. team for more information"
                                            }
                                        }
                                    }
                                })
                            }
                            else{
                                DispatchQueue.main.async
                                {
                                    self.hidePleaseWait()
                                    self.m_tableView.isHidden = true
                                    self.m_noInternetView.isHidden=false
                                    
                                    if m_windowPeriodStatus{
                                        self.m_errorImageview.image=UIImage(named: "duringEnrollDataNotFound")
                                        self.noInternetHeaderLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                        self.noInternetDescLbl.text = "During_Enrollment_Header_FaqErrorMsg".localized()
                                    }else{
                                        self.m_errorImageview.image=UIImage(named: "nodocuments")
                                        self.noInternetHeaderLbl.text = "FAQs not updated for your corporate"
                                        self.noInternetDescLbl.text = "Please contact your HR or Marsh Ops. team for more information"
                                    }
                                }
                            }
                            
                        }
                        }
                    }
                    task.resume()
                
            }else{
                
                DispatchQueue.main.async
                {
                    self.hidePleaseWait()
                    self.m_tableView.isHidden = true
                    self.m_noInternetView.isHidden=false
                    
                    if m_windowPeriodStatus{
                        self.m_errorImageview.image=UIImage(named: "duringEnrollDataNotFound")
                        self.noInternetHeaderLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                        self.noInternetDescLbl.text = "During_Enrollment_Header_FaqErrorMsg".localized()
                    }else{
                        self.m_errorImageview.image=UIImage(named: "nodocuments")
                        self.noInternetHeaderLbl.text = "FAQs not updated for your corporate"
                        self.noInternetDescLbl.text = "Please contact your HR or Marsh Ops. team for more information"
                    }
                    self.m_tableView.isHidden=true
                    self.m_tableView.reloadData()
                }
                
            }
        }else{
            DispatchQueue.main.async
            {
                self.hidePleaseWait()
                self.m_noInternetView.isHidden = false
                self.m_errorImageview.isHidden = false
                self.noInternetHeaderLbl.isHidden = false
                self.m_errorImageview.image = UIImage(named: "nointernet")
                self.noInternetHeaderLbl.text = error_NoInternet
                self.noInternetDescLbl.text=""
                self.m_tableView.isHidden=true
                self.m_tableView.reloadData()
            }
        }
    }
    
    func scrollToTop()
    {
        let indexpath = IndexPath(row: 0, section: 0)
        m_tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isConnectedToNet(){
            return resultsDictArray?.count ?? 0
        }else{
            return FaqArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : FAQTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! FAQTableViewCell
        
        if !datasource.isEmpty{
            shadowForCell(view: cell.m_backGroundView)
            cell.m_questionBackgroundView.layer.masksToBounds=true
            cell.m_questionBackgroundView.layer.cornerRadius=cornerRadiusForView//8
            cell.m_answerBackgroundView.layer.masksToBounds=true
            cell.m_answerBackgroundView.layer.cornerRadius=cornerRadiusForView//8
            cell.m_questionBackgroundView.layer.shadowColor=UIColor.white.cgColor
            
            cell.setContent(data: datasource[indexPath.row])
            //let dict : NSDictionary = resultsDictArray?[indexPath.row] as! NSDictionary
            //        cell.m_questionLbl.text=dict.value(forKey: "FAQ_QUESTION") as? String
            
           //  cell.m_expandButton.addTarget(self, action: #selector(expandButtonClicked), for: .touchUpInside)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        //this is to make the expandable false for slected index if the index is already selected
        if selectedRowIndex == indexPath.row
        {
            selectedRowIndex = -1
            let content = datasource[indexPath.row]
            content.expanded = !content.expanded
        }
        else
        {
            // to make expandable false for previously selected cell
            if self.selectedRowIndex != -1
            {
                let content = datasource[selectedRowIndex]
                content.expanded = !content.expanded
                tableView.reloadData()
                
                
            }
            //common for all
            selectedRowIndex = indexPath.row
            let content = datasource[indexPath.row]
            content.expanded = !content.expanded
            
        }
        //        tableView.reloadData()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        m_tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
        
        
        
        /* let content = datasource[indexPath.row]
         content.expanded = !content.expanded
         let cell : FAQTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! FAQTableViewCell
         if(datasource.count>0)
         {
         cell.setContent(data: datasource[indexPath.row])
         }
         
         tableView.reloadRows(at: [indexPath], with: .automatic)
         //        tableView.reloadData()
         m_tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)*/
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == selectedRowIndex
        {
            if(datasource[indexPath.row].expanded)
            {
                return UITableViewAutomaticDimension
            }
            else
            {
                return 60
            }
            
            
        }
        return UITableViewAutomaticDimension
    }
    
    @objc func expandButtonClicked(sender:UIButton)
    {
        let indexPath = IndexPath(row:sender.tag, section:0)
        tableView(m_tableView, didSelectRowAt: indexPath)
    }
    
 
    @IBAction func GMCTabSelected(_ sender: Any)
    {
        if isGHIDataPresent{
            m_productCode = "GMC"
            selectedRowIndex = -1
            selectedIndexPosition = 0
            GMCTabSeleted()
            
        }
        else{
            self.displayActivityAlert(title: "Policy not available!")
        }
    }
    
    func GMCTabSeleted()
    {
        m_productCode="GMC"
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        }
        
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        
        if policyDataArray.count > selectedIndexPosition{
            print("FAQViewController selectedIndexPosition GMC ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("FAQViewController selectedIndexPosition GMC ",selectedIndexPosition)
        }
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        //GMCShadowView.dropShadow()
        GPAShadowView.layer.masksToBounds=true
        GTLShadowView.layer.masksToBounds=true
        
        m_GMCTab.layer.masksToBounds=true
        m_GMCTab.layer.cornerRadius=cornerRadiusForView//m_GMCTab.frame.size.height/2
        m_GMCTab.layer.borderWidth=0
        m_GMCTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        m_GMCTab.setTitleColor(UIColor.white, for: .normal)
        
        
       
        
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
        faqDetailsPortal()
    }
    
    @IBAction func GPATabSelected(_ sender: Any)
    {
//        if userEmployeeSrnoGPA == ""{
//            self.displayActivityAlert(title: "Please contact your HR or Marsh Ops. team")
//        }else{
            if isGPADataPresent{
                m_productCode = "GPA"
                selectedRowIndex = -1
                selectedIndexPosition = 0
                GPATabSelected()
                
            }
            else{
                self.displayActivityAlert(title: "Policy not available!")
            }
//        }
    }
    func GPATabSelected(){
        
        m_productCode = "GPA"
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        }
        
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        if policyDataArray.count > selectedIndexPosition{
            print("FAQViewController selectedIndexPosition GPA ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("FAQViewController selectedIndexPosition GPA ",selectedIndexPosition)
        }
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        //GPAShadowView.dropShadow()
        
        GMCShadowView.layer.masksToBounds=true
        GTLShadowView.layer.masksToBounds=true
        
        m_GPATab.layer.masksToBounds=true
        m_GPATab.layer.cornerRadius=cornerRadiusForView//m_GPATab.frame.size.height/2
        m_GPATab.layer.borderWidth=0
        m_GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        m_GPATab.setTitleColor(UIColor.white, for: .normal)
        
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderWidth = 2
       
        m_GTLTab.layer.borderWidth = 2
        
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
        
        m_GTLTab.layer.cornerRadius = cornerRadiusForView//8
        GPAShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        m_GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GTLTab.setBackgroundImage(nil, for: .normal)
        faqDetailsPortal()
    }
    
    @IBAction func GTLTabSelected(_ sender: Any)
    {
//        if userEmployeeSrnoGTL == ""{
//            self.displayActivityAlert(title: "Please contact your HR or Marsh Ops. team")
//        }else{
            if isGTLDataPresent{
                selectedIndexPosition = 0
                m_productCode = "GTL"
                selectedRowIndex = -1
                GTLTabSelected()
                
            }
            else{
                self.displayActivityAlert(title: "Policy not available!")
            }
//        }
    }
    
    func GTLTabSelected(){
        
        m_productCode = "GTL"
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        }
        
        print("windowperiodstatus",m_windowPeriodStatus)
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        if policyDataArray.count > selectedIndexPosition{
            print("FAQViewController selectedIndexPosition GTL ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("FAQViewController selectedIndexPosition GTL ",selectedIndexPosition)
        }
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        //GTLShadowView.dropShadow()
        GMCShadowView.layer.masksToBounds=true
        GPAShadowView.layer.masksToBounds=true
       
        
        m_GTLTab.layer.masksToBounds=true
        m_GTLTab.layer.cornerRadius=cornerRadiusForView//m_GTLTab.frame.size.height/2
        
        m_GTLTab.layer.borderWidth=0
        m_GTLTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        m_GTLTab.setTitleColor(UIColor.white, for: .normal)
        
        m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        m_GPATab.layer.borderColor=UIColor.white.cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        
        m_GMCTab.layer.borderWidth = 2
        
        m_GPATab.layer.borderWidth = 2
        
        m_GMCTab.layer.cornerRadius = cornerRadiusForView
        m_GPATab.layer.cornerRadius = cornerRadiusForView
        GTLShadowView.layer.cornerRadius = cornerRadiusForView
    
        
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        m_GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        faqDetailsPortal()
    }
    
    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        print(xmlKey)
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
            print(currentDictionary)
            resultsDictArray?.append(currentDictionary!)
            self.currentDictionary = [:]
            //            xmlKey="claims"
        }
        else if dictionaryKeys.contains(elementName)
        {
            self.currentDictionary![elementName] = currentValue
            self.currentValue = ""
            
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
            print("FAQViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("FAQViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        faqDetailsPortal()
    }
    
    
}
