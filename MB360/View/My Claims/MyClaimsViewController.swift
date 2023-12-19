//
//  MyClaimsViewController.swift
//  MyBenefits
//
//  Created by Semantic on 16/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import FirebaseCrashlytics
import TrustKit
import AesEverywhere

class MyClaimsViewController: UIViewController,XMLParserDelegate,NewPoicySelectedDelegate {
    @IBOutlet weak var m_tableviewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var m_errorImageView: UIImageView!
    @IBOutlet weak var m_noInternetView: UIView!
    @IBOutlet weak var m_totalCliamsTitleLbl: UILabel!
    @IBOutlet weak var m_titleBackgroundView: UIView!
    @IBOutlet weak var m_ClaimCountLbl: UILabel!
    @IBOutlet weak var m_tableView: UITableView!
    
    @IBOutlet weak var m_errorMsgDetailLbl: UILabel!
    @IBOutlet weak var m_errorMsgTitleLbl: UILabel!
    
    
    @IBOutlet weak var PolicylblView: UIView!
       @IBOutlet weak var policyNamelbl: UILabel!
    
    @IBOutlet weak var GTLShadowView: UIView!
       @IBOutlet weak var GPAShadowView: UIView!
       @IBOutlet weak var GMCShadowView: UIView!
      
      @IBOutlet weak var m_GTLTab: UIButton!
       @IBOutlet weak var m_GPATab: UIButton!
       @IBOutlet weak var m_GMCTab: UIButton!
      
    @IBOutlet weak var vewTopup: UIView!
    
    let reuseIdentifier = "cell"
    var m_employeedict : EMPLOYEE_INFORMATION?
    var m_productCode = String()
    var isFirstTime = Bool()
    var xmlKey = String()
    let dictionaryKeys = ["BeneficiaryName", "ClaimDate", "ClaimNo", "ClaimAmount", "ClaimType", "RelationWithEmployee", "ClaimSrNo", "ClaimStatus", "TOTAL_CLAIM_AMT", "PRE_AUTH_SENT_DATE", "PRE_AUTH_AMOUNT", "HOSPITAL_NAME", "DATE_OF_ADMISSION", "DATE_OF_DISCHARGE", "AILMENT", "DATE_OF_PAYMENT_TO_PROVIDER", "DATE_OF_PAYMENT_TO_MEMBER", "AMOUNT_PAID_TO_PROVIDER", "AMOUNT_PAID_TO_MEMBER", "BANK_CHEQUE_NO", "CHEQUE_NO_TO_MEMBER", "DEDUCTION_REASONS", "DEFICIENCIES_IR_REQUIREMENT", "DEFICIENCY_INTIMATION_DATE", "FIRST_DEFICIENCY_LETTER_DATE", "SECOND_DEFICIENCY_LETTER_DATE", "DEFICIENCIES_RETRIEVAL_DATE"]
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    let menuController = UIMenuController.shared
    
    var claimDetailsArray=Array<MyClaimsDetails>()
    var m_cashlessClaimsArray=Array<MyClaimsDetails>()
    var m_reimbursementClaimsArray=Array<MyClaimsDetails>()
    var isFromSideBar = Bool()
    
    var selectedIndexPosition = -1
       var policyDataArray = [OE_GROUP_BASIC_INFORMATION]()
    var selectedPolicyValue = ""
    var clickedOegrp = ""
    var clickedEmpSrNo = ""
   
    override func viewDidLoad()
    {
        print("Function: \(#function), line: \(#line)")

        super.viewDidLoad()
//        self.tabBarController?.tabBar.isHidden=true
        self.setupFontsUI()
        m_GMCTab.isHidden=true
        m_GPATab.isHidden=true
        m_GTLTab.isHidden=true
        addTarget()
        m_tableView.register(MyClaimsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let nib = UINib (nibName: "MyClaimsTableViewCell", bundle: nil)
        m_tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        m_tableView.tableFooterView=UIView()
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        shadowForCell(view: m_titleBackgroundView)
        m_titleBackgroundView.isHidden=true
        isFirstTime=true
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
                
        print("Contact Page Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
        
        
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
    }
    
    func setupFontsUI(){
        
        m_totalCliamsTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h15))
        m_totalCliamsTitleLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        
        m_ClaimCountLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h15))
        m_ClaimCountLbl.textColor = FontsConstant.shared.app_FontBlackColor

        m_errorMsgTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        m_errorMsgTitleLbl.textColor = FontsConstant.shared.app_errorTitleColor
        
        m_errorMsgDetailLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_errorMsgDetailLbl.textColor = FontsConstant.shared.app_errorTitleColor
        
        
    }
    
  
    override func viewWillAppear(_ animated: Bool)
    {
        print("Function: \(#function), line: \(#line)")

        //navigationItem.rightBarButtonItem=getRightBarButton()
        
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
        
        
        PolicylblView.setBorderToViewSelectPolicy(color:hexStringToUIColor(hex: "E5E5E5"))
        navigationController?.navigationBar.isHidden=false
        navigationItem.title="link6Name".localized()
        navigationItem.leftBarButtonItem=getBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        //navigationItem.rightBarButtonItem=getRightBarButton()
        navigationController?.navigationBar.dropShadow()
       
            
        self.tabBarController?.tabBar.isHidden=false
        menuButton.isHidden=false
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        
//        menuButton.backgroundColor = UIColor.white
//        menuButton.setBackgroundImage(UIImage(named: ""), for: .normal)
//        menuButton.setImage(UIImage(named:"Home"), for: .normal)
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
            getEnrollStatus("GMC", 0, userOegrpNoGMC)
            policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
            
            if policyDataArray.count > selectedIndexPosition{
                print("MyClaimsViewController selectedIndexPosition GMC ",selectedIndexPosition)
            }
            else{
                selectedIndexPosition = 0
                print("MyClaimsViewController selectedIndexPosition GMC ",selectedIndexPosition)
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
           // m_GMCTabLine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            m_GMCTab.setTitleColor(UIColor.white, for: .normal)
            
//            m_GPATabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
//            m_GTLTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
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
            self.resultsDictArray = []
            
            getClaimsJson()

        }
    
    @IBAction func GMCTabSelected(_ sender: Any)
        {
            if isGHIDataPresent{
                m_productCode = "GMC"
                selectedIndexPosition = 0
                GMCTabSeleted()
                
               
                //        getContactDetails()
            }else{
                self.displayActivityAlert(title: "Policy not available!")
            }
        }
        
        @IBAction func GPATabSelected(_ sender: Any)
        {
            if isGPADataPresent{
                m_productCode = "GPA"
                selectedIndexPosition = 0
                GPATabSelect()
            }else{
                self.displayActivityAlert(title: "Policy not available!")
            }
        }
        @IBAction func GTLTabSelected(_ sender: Any)
        {
            if isGTLDataPresent{
                m_productCode = "GTL"
                selectedIndexPosition = 0
                GTLTabSelect()
            }else{
                self.displayActivityAlert(title: "Policy not available!")
            }
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
            
            getEnrollStatus("GMC", 0, userOegrpNoGMC)
            policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
            
            if policyDataArray.count > selectedIndexPosition{
                print("MyClaimsViewController selectedIndexPosition GPA ",selectedIndexPosition)
            }
            else{
                selectedIndexPosition = 0
                print("MyClaimsViewController selectedIndexPosition GPA ",selectedIndexPosition)
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
           // m_GPATabLine.backgroundColor=hexStringToUIColor(hex: "622140")
            m_GPATab.setTitleColor(UIColor.white, for: .normal)
            
//            m_GMCTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
//            m_GTLTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
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
            
            self.resultsDictArray=[]
            getClaimsJson()
            
            
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
            getEnrollStatus("GMC", 0, userOegrpNoGMC)
            policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
            
            if policyDataArray.count > selectedIndexPosition{
                print("MyClaimsViewController selectedIndexPosition GTL ",selectedIndexPosition)
            }
            else{
                selectedIndexPosition = 0
                print("MyClaimsViewController selectedIndexPosition GTL ",selectedIndexPosition)
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
            //m_GTLTabLine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            m_GTLTab.setTitleColor(UIColor.white, for: .normal)
            
//            m_GMCTabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
//            m_GPATabLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
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
            
            
            self.resultsDictArray=[]
            getClaimsJson()
        }
    
    
    func getLeftBarButton()->UIBarButtonItem
    {
        print("Function: \(#function), line: \(#line)")

        let button1 = UIBarButtonItem(image:UIImage(named: "menu"), style: .plain, target: self, action: #selector(leftButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func leftButtonClicked()
    {
        print("Function: \(#function), line: \(#line)")

    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        print("Function: \(#function), line: \(#line)")

        navigationController?.popViewController(animated: true)
//        tabBarController!.selectedIndex = 2
    }
    
    override func didReceiveMemoryWarning()
    {
        print("Function: \(#function), line: \(#line)")

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc override func backButtonClicked()
    {
        print("Function: \(#function), line: \(#line)")

            _ = navigationController?.popViewController(animated: true)
       
    }
    
   
    
    func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString
    {
        print("Function: \(#function), line: \(#line),\(string),\(nonBoldRange)")

        var stringStr = string
        if string == "" {
            stringStr = "0"
        }
        let fontSize = 15.0
        let attrs = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        let nonBoldAttribute = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: CGFloat(fontSize)),
            ]
    
        
        let attrStr = NSMutableAttributedString(string: stringStr, attributes: attrs)
        if let range = nonBoldRange
        {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        print("Returned")
        return attrStr
    }
    
    
    @objc func cashlessClaimsButtonClicked(sender: UIButton)
    {
        print("Function: \(#function), line: \(#line)")

        m_cashlessClaimsArray = DatabaseManager.sharedInstance.retrieveMyClaimsbyType(type: "Cashless")
        claimDetailsArray.removeAll()
        claimDetailsArray=m_cashlessClaimsArray
        isFirstTime=false
        m_tableView.reloadData()
    }
    @objc func reimbursementClaimsButtonClicked(sender: UIButton)
    {
        print("Function: \(#function), line: \(#line)")

         m_reimbursementClaimsArray = DatabaseManager.sharedInstance.retrieveMyClaimsbyType(type: "Reimbursement")
        claimDetailsArray.removeAll()
        claimDetailsArray=m_reimbursementClaimsArray
        isFirstTime=false
        m_tableView.reloadData()
        
    }
    @objc internal func typeButtonTapped(sender: UIButton)
    {
        print("Function: \(#function), line: \(#line)")

        sender.becomeFirstResponder()
         let dict:NSDictionary = resultsDictArray![sender.tag] as NSDictionary
         let TYPE_OF_CLAIM : String = dict.value(forKey: "TYPE_OF_CLAIM") as! String
        menuController.menuItems = [
            UIMenuItem(
                title: TYPE_OF_CLAIM,
                action: #selector(handleCustomAction(_:))
            )
        ]
        
        menuController.setTargetRect(sender.frame, in: sender.superview!)
        menuController.setMenuVisible(true, animated: true)
    }
    override var canBecomeFirstResponder: Bool {
        print("Function: \(#function), line: \(#line)")

        return true
    }
    @objc internal func handleCustomAction(_ controller: UIMenuController)
    {
        print("Function: \(#function), line: \(#line)")

        print("Custom action!")
    }

    @objc func liveStatusButtonClicked(sender : UIButton)
    {
        print("Function: \(#function), line: \(#line)")

        if(claimDetailsArray.count>0)
        {
            if(sender.tag != 0)
            {
                showLiveStatus(index: sender.tag)
            }
        }
    }
    func showLiveStatus(index : Int)
    {
        print("Function: \(#function), line: \(#line)")

        let claimStatusVC : LiveStatusViewController = LiveStatusViewController()
        let dict = claimDetailsArray[index-1]
        let dict1 = resultsDictArray![index-1]
        
        print("claimdetailsarray",dict)

        print("Status dict",dict1)
        
        claimStatusVC.m_claimDetailsDict=dict
        claimStatusVC.statusDict=dict1
        if(claimStatusVC.statusDict?.count ?? 0>0)
        {
            navigationController?.pushViewController(claimStatusVC, animated: true)
        }
        
    }
    func parserDidStartDocument(_ parser: XMLParser)
    {
        print("Function: \(#function), line: \(#line)")

        resultsDictArray = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        print("Function: \(#function)")

//        print(xmlKey)
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
        print("Function: \(#function)")

        self.currentValue += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        print("Function: \(#function)")

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
    
    /*
    func getClaimsJson(){
        if(isConnectedToNet())
        {
            showPleaseWait1(msg: """
Please wait...
Fetching Claims
""")
            m_titleBackgroundView.isHidden=false
            m_productCode = "GMC"
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            m_employeedict=userArray[0]
            
            var employeesrno = String()
            var groupChildSrNo = String()
            
            if let empNo = m_employeedict?.empSrNo
            {
                employeesrno = String(empNo)
            }
            if let groupChlNo = m_employeedict?.groupChildSrNo
            {
                groupChildSrNo=String(groupChlNo)
            }
            let requrl = "http://localhost:56803/api/ClaimProcedure/LoadEmployeeClaimsValues?groupchildsrno=1396&employeesrno=44225"
            
            EnrollmentServerRequestManager.serverInstance.getRequestDataFromServerPost(url: requrl, view: self) { (data, error) in
                
                if error != nil
                {
                    print("error ",error!)
                    //self.hidePleaseWait()
                    self.displayActivityAlert(title: m_errorMsg)
                }else{
                    
                    do{
                        let jsonResult = data as? NSDictionary
                        if let claimInfo = jsonResult?["ClaimInformation"] as? NSArray{
                            let status = DatabaseManager.sharedInstance.deleteClaimDetails()
                            if status{
                                for val in claimInfo{
                                    let dict:NSDictionary = val as! NSDictionary; DatabaseManager.sharedInstance.saveMyClaimDetails(contactDict: dict)
                                }
                            }
                            self.claimDetailsArray = DatabaseManager.sharedInstance.retrieveMyClaimDetails()
                            let count = (self.claimDetailsArray.count)
                            
                            self.m_ClaimCountLbl.text=String(count)
                            self.m_totalCliamsTitleLbl.text="totalClaims".localized()
                            if(count==0)
                            {
                                
                                self.m_tableView.isHidden=true
                                self.m_noInternetView.isHidden=false
                                self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
                                self.m_errorMsgTitleLbl.text="No claims reported"
                                self.m_errorMsgDetailLbl.text=""
                            }
                            
                            self.m_tableView.reloadData()
                            self.hidePleaseWait1()
                        }
                        
                    }
                    catch let JSONError as NSError
                    {
                        print(JSONError)
                    }
                }
            }
            
            
        }else{
            m_noInternetView.isHidden=false
            m_errorMsgTitleLbl.text="No Internet Connection"
            m_errorMsgDetailLbl.text="Slow or no internet connection. Please check your Internet Settings"
            m_errorImageView.image=UIImage(named: "nointernet")
            m_noInternetView.isHidden=false
            self.claimDetailsArray = DatabaseManager.sharedInstance.retrieveMyClaimDetails()
            if(claimDetailsArray.count>0)
            {
                
                
                if let count : Int? = (self.claimDetailsArray.count)
                {
                    self.m_ClaimCountLbl.text=String(count!)
                    self.m_totalCliamsTitleLbl.text="totalClaims".localized()
                }
                
                self.m_tableView.reloadData()
                let deadlineTime = DispatchTime.now() + .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime)
                {
                    self.m_noInternetView.isHidden=true
                    
                }
            }
        }
    }
    */
    
   
    
    func getClaims()
    {
        print("Function: \(#function)")

        if(isConnectedToNet())
        {
            showPleaseWait1(msg: """
Please wait...
Fetching Claims
""")
            m_titleBackgroundView.isHidden=false
            m_productCode = "GMC"
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            if userArray.count > 0{
                m_employeedict=userArray[0]
                
                var employeesrno = String()
                var groupChildSrNo = String()
                
                if let empNo = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String//m_employeedict?.empSrNo
                {
                    employeesrno = String(empNo)
                }
                if let groupChlNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String//m_employeedict?.groupChildSrNo
                {
                    groupChildSrNo=String(groupChlNo)
                }
                /* let yourXML = AEXMLDocument()
                 
                 let dataRequest = yourXML.addChild(name: "DataRequest")
                 dataRequest.addChild(name: "groupchildsrno", value: groupChildSrNo)
                 dataRequest.addChild(name: "employeesrno", value: employeesrno)
                 
                 print(yourXML.xml)*/
                
                 let string="<DataRequest><groupchildsrno>\(groupChildSrNo)</groupchildsrno><employeesrno>\(employeesrno)</employeesrno></DataRequest>"
                //Testing
               // let string="<DataRequest><groupchildsrno>1090</groupchildsrno><employeesrno>109492</employeesrno></DataRequest>"
                
                
                let uploadData = string.data(using: .utf8)
                
                //            var uploadData: Data = NSKeyedArchiver.archivedData(withRootObject: uploadDic)
                //            uploadData = try! JSONSerialization.data(withJSONObject: uploadDic, options: .prettyPrinted)
                
                let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getClaimDetailsPostUrl() as String)
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?// NSURL(string: urlreq)
                request.httpMethod = "POST"
                request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
                
                
                var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
                var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

                let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
                print("m_authUserName_Portal ",encryptedUserName)
                print("m_authPassword_Portal ",encryptedPassword)
                
                let authData = authString.data(using: String.Encoding.utf8)!
                let base64AuthString = authData.base64EncodedString()
                
                //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                // request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
                authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                print("authToken LoadEmployeeClaimsValues:",authToken)
                
                //request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                request.httpBody=uploadData
                
                print("MyClaims LoadEmployeeClaimsValues url: ",request)
                print("string: ",string)
                
                //SSL Pinning
                let sessionConfig = URLSessionConfiguration.default
                sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
                sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
                TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
                let session = URLSession(
                    configuration: sessionConfig,
                    delegate: URLSessionPinningDelegate(),
                    delegateQueue: nil)
                
                
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    //SSL Pinning
                    if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                        // Handle SSL connection failure
                        print("SSL connection error: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.alertForLogout(titleMsg: error.localizedDescription)
                        }
                    }
                    else if error != nil {
                        print("error ",error!)
                        self.hidePleaseWait1()
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            if httpResponse.statusCode == 200
                            {
                                do
                                {
                                    self.xmlKey = "claims"
                                    let parser = XMLParser(data: data!)
                                    parser.delegate = self as? XMLParserDelegate
                                    parser.parse()
                                    DispatchQueue.main.async
                                    {
                                        let status = DatabaseManager.sharedInstance.deleteClaimDetails()
                                        if(status)
                                        {
                                            if self.resultsDictArray != nil
                                            {
                                                for claimDict in self.resultsDictArray!
                                                {
                                                    let dict:NSDictionary = claimDict as NSDictionary; DatabaseManager.sharedInstance.saveMyClaimDetails(contactDict: dict)
                                                    
                                                }
                                            }
                                        }
                                        self.claimDetailsArray = DatabaseManager.sharedInstance.retrieveMyClaimDetails()
                                        
                                        
                                        if let count : Int = (self.resultsDictArray?.count)
                                        {
                                            self.m_ClaimCountLbl.text=String(count)
                                            self.m_totalCliamsTitleLbl.text="totalClaims".localized()
                                            if(count==0)
                                            {
                                                
                                                self.m_tableView.isHidden=true
                                                self.m_noInternetView.isHidden=false
                                                self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
                                                self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
                                                self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                            }
                                        }
                                        self.m_tableView.reloadData()
                                        self.hidePleaseWait1()
                                    }
                                    
                                }
                                catch let JSONError as NSError
                                {
                                    print(JSONError)
                                    self.hidePleaseWait1()
                                    Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                }
                            } else if httpResponse.statusCode == 404
                            {
                                DispatchQueue.main.async{
                                    self.m_tableView.isHidden=true
                                    self.m_noInternetView.isHidden=false
                                    self.m_errorImageView.image=UIImage(named: "error_State")
                                    self.m_errorMsgTitleLbl.text="Something went wrong!"
                                    self.m_errorMsgDetailLbl.text=""
                                    
                                    self.hidePleaseWait1()
                                }
                            }else if httpResponse.statusCode == 401 || httpResponse.statusCode == 400{
                                self.hidePleaseWait1()
                                print("something went wrong.")
                                //self.alertForLogout(titleMsg: "something went wrong.")
                            }
                            else
                            {
                                //                                self.hidePleaseWait1()
                                //                                self.displayActivityAlert(title: m_errorMsg)
                                self.claimDetailsArray = DatabaseManager.sharedInstance.retrieveMyClaimDetails()
                                if self.claimDetailsArray != nil{
                                    let count : Int = self.claimDetailsArray.count
                                    //{
                                    DispatchQueue.main.async{
                                        self.m_ClaimCountLbl.text=String(count)
                                        self.m_totalCliamsTitleLbl.text="totalClaims".localized()
                                    }
                                    if(count==0)
                                    {
                                        DispatchQueue.main.async{
                                            self.m_tableView.isHidden=true
                                            self.m_noInternetView.isHidden=false
                                            self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
                                            self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
                                            self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                        }
                                    }
                                    //}
                                    DispatchQueue.main.async{
                                        self.m_tableView.reloadData()
                                        self.hidePleaseWait1()
                                        //self.loader.stopAnimating()
                                        print("else executed")
                                    }
                                    
                                }else{
                                    let httpResponse = response as? HTTPURLResponse
                                    var msg = self.errorMsg(httpResponse!.statusCode)
                                    self.displayActivityAlert(title: msg)
                                    self.hidePleaseWait1()
                                }
                                print("else executed")
                            }
                            
                        }
                        else
                        {
                            print("Can't cast response to NSHTTPURLResponse")
                            self.displayActivityAlert(title: m_errorMsg)
                            self.hidePleaseWait1()
                            
                        }
                        
                    }
                }
                
                task.resume()
            }else{
                DispatchQueue.main.async{
                    self.m_tableView.isHidden=true
                    self.m_noInternetView.isHidden=false
                    self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
                    self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
                    self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
                    self.hidePleaseWait()
                }
                
            }
                
            }
        else
        {
//            m_noInternetView.isHidden=false
//            m_errorMsgTitleLbl.text="No Internet Connection"
//            m_errorMsgDetailLbl.text="Slow or no internet connection. Please check your Internet Settings"
//            m_errorImageView.image=UIImage(named: "nointernet")
//            m_noInternetView.isHidden=false
//            self.claimDetailsArray = DatabaseManager.sharedInstance.retrieveMyClaimDetails()
//            if(claimDetailsArray.count>0)
//            {
//
//
//                if let count : Int? = (self.claimDetailsArray.count)
//                {
//                    self.m_ClaimCountLbl.text=String(count!)
//                    self.m_totalCliamsTitleLbl.text="totalClaims".localized()
//                }
//
//                self.m_tableView.reloadData()
//                let deadlineTime = DispatchTime.now() + .seconds(2)
//                DispatchQueue.main.asyncAfter(deadline: deadlineTime)
//                {
//                    self.m_noInternetView.isHidden=true
//
//                }
//            }
           
            self.claimDetailsArray = DatabaseManager.sharedInstance.retrieveMyClaimDetails()
            if self.claimDetailsArray != nil{
                let count : Int = self.claimDetailsArray.count
                //{
                DispatchQueue.main.async{
                    self.m_ClaimCountLbl.text=String(count)
                    self.m_totalCliamsTitleLbl.text="totalClaims".localized()
                }
                if(count==0)
                {
                    DispatchQueue.main.async{
                        self.m_tableView.isHidden=true
                        self.m_noInternetView.isHidden=false
                        self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
                        self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
                        self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
                    }
                }
                //}
                DispatchQueue.main.async{
                    self.m_tableView.reloadData()
                    self.hidePleaseWait1()
                    //self.loader.stopAnimating()
                    print("else executed")
                }
                
            }else{
//                let httpResponse = response as? HTTPURLResponse
//                var msg = self.errorMsg(httpResponse!.statusCode)
                self.displayActivityAlert(title: m_errorMsg)
                self.hidePleaseWait1()
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
            print("MyClaimsViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("MyClaimsViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        
        getClaimsJson()
    }
    
    
    
}


extension MyClaimsViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Function: \(#function), line: \(#line)")

        if(claimDetailsArray.count>0)
        {
            if(indexPath.row != 0)
            {
                showLiveStatus(index: indexPath.row)
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("Function: \(#function), line: \(#line)")

        if(claimDetailsArray.count>0)
        {
            return claimDetailsArray.count+1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("Function: \(#function), line: \(#line)")

        let cell : MyClaimsTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyClaimsTableViewCell
        
        cell.selectionStyle=UITableViewCellSelectionStyle.none

        if(claimDetailsArray.count>0)
        {
            m_titleBackgroundView.isHidden=true
            cell.claimNumberDetailsView.isHidden=false
            m_tableviewTopConstraint.constant=0
            m_tableView.isHidden=false
            
            if(indexPath.row==0)
            {
            
                
               cell.m_backGroundView.isHidden=true
                shadowForCell(view: cell.claimNumberDetailsView)
                
//                cell.m_totalClaimsLbl.text=m_ClaimCountLbl.text
                cell.m_cashlessNumberButton.addTarget(self, action: #selector(cashlessClaimsButtonClicked), for: .touchUpInside)
                cell.m_reimbursementNumberButton.addTarget(self, action: #selector(reimbursementClaimsButtonClicked), for: .touchUpInside)
                
                m_cashlessClaimsArray = DatabaseManager.sharedInstance.retrieveMyClaimsbyType(type: "Cashless")
                let prepostClaimsArray = DatabaseManager.sharedInstance.retrieveMyClaimsbyType(type: "Pre / Post Hospitalization")
                m_reimbursementClaimsArray = DatabaseManager.sharedInstance.retrieveMyClaimsbyType(type: "Reimbursement")
                   let reimbursementCount = String(m_reimbursementClaimsArray.count)
                    cell.m_reimbursementNumberButton.setTitle(reimbursementCount, for: .normal)
                cell.m_cashlessNumberButton.setTitle(String(m_cashlessClaimsArray.count+prepostClaimsArray.count), for: .normal)
            cell.m_totalClaimsCountButton.setTitle(String(claimDetailsArray.count)+"   ", for: .normal)
                
            }
            else
            {
               
                
                cell.m_backGroundView.isHidden=false
                m_noInternetView.isHidden=true
                
                shadowForCell(view: cell.m_backGroundView)
                cell.m_backGroundView.layer.cornerRadius=10
                cell.m_liveStatusButton.layer.cornerRadius=cell.m_liveStatusButton.frame.size.height/2
                cell.m_typeButton.layer.masksToBounds=true
                cell.m_typeButton.layer.cornerRadius=10
                cell.m_typeButton.tag=indexPath.row
                
                cell.m_claimTypeTitleLbl.text="claimType".localized()
                cell.m_claimDateLbl.text="claimDate".localized()
                cell.m_claimAmountTitleLbl.text="claimAmount".localized()
                cell.m_liveStatusButton.setTitle("liveStatus".localized(), for: .normal)
                
                let dict:MyClaimsDetails = claimDetailsArray[indexPath.row-1]
                cell.m_nameLbl.text = dict.beneficiary
                cell.m_claimDateLbl.text=dict.claimDate
                cell.m_claimNumberLbl.text=dict.claimNumber
                cell.m_claimStatusLbl.text=dict.claimStatus
                var claimAmount = String()
                if let amount = dict.claimAmount
                {
                    claimAmount = "₹ "+amount.currencyInputFormatting()
                }
                
                //        claimAmount = claimAmount?.replacingOccurrences(of: "Rs.", with: "", options: NSString.CompareOptions.literal, range: nil)
                
                let range = NSMakeRange(1, 1)
                print(indexPath.row)
             // cell.m_claimAmountLbl.attributedText=attributedString(from: claimAmount, nonBoldRange: range)
                 cell.m_claimAmountLbl.text = claimAmount
                print("NEXT")
                let TYPE_OF_CLAIM  = dict.claimType
                cell.m_claimTypeLbl.text=dict.claimType
                
                if dict.claimType == "Reimbursement"{
                    cell.m_claimTypeLbl.textColor = FontsConstant.shared.HosptailLblTertiary
                }
                else if dict.claimType == "Cashless"{
                    cell.m_claimTypeLbl.textColor = FontsConstant.shared.HosptailLblSecondary
                }
                
                switch TYPE_OF_CLAIM {
                case "Reimbursement":
                    cell.m_typeButton.setTitle("R", for: .normal)
                    
                    break
                    
                case "Cashless":
                    cell.m_typeButton.setTitle("C", for: .normal)
                    
                    break
                default:
                    break
                }
                cell.m_typeButton.isUserInteractionEnabled = true
                cell.m_typeButton.becomeFirstResponder()
                cell.m_typeButton.addTarget(self, action: #selector(typeButtonTapped), for: .touchUpInside)
                
                
                cell.m_liveStatusButton.tag=indexPath.row
                cell.m_liveStatusButton.addTarget(self, action: #selector(liveStatusButtonClicked), for: .touchUpInside)
                
                cell.m_backGroundView.isHidden=false
               
            }
           
        }
        else
        {
            m_titleBackgroundView.isHidden=true
            self.m_tableView.isHidden=true
            self.m_noInternetView.isHidden=false
            self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
            self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
            self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
            m_tableviewTopConstraint.constant=80
            
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        print("Function: \(#function), line: \(#line)")

        if(indexPath.row==0)
        {
            return 0
        }
        return UITableViewAutomaticDimension
    }
   func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        print("Function: \(#function), line: \(#line)")

        
        if let postCell = cell as? MyClaimsTableViewCell
        {
//            self.tableView(tableView: m_tableView, willDisplayMyCell: postCell, forRowAtIndexPath: indexPath as NSIndexPath)
        }
        
    }
    private func tableView(tableView: UITableView, willDisplayMyCell myCell: MyClaimsTableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        print("Function: \(#function), line: \(#line)")

        TipInCellAnimator.animate(cell: myCell)
    }
    
    
}

//API call for JSON
extension MyClaimsViewController{
    
    func getClaimsJson(){
        if(isConnectedToNet())
        {
            showPleaseWait1(msg: """
Please wait...
Fetching Claims
""")
            vewTopup.isHidden = false
            
            userEmployeeSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String ?? ""
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
            
//            var employeesrno = String()
//            var groupChildSrNo = String()
//
//            if let empNo = userEmployeeSrno as? String
//            {
//                employeesrno = String(empNo)
//            }
//            if let groupChlNo = userGroupChildNo as? String
//            {
//                groupChildSrNo=String(groupChlNo)
//            }
           
                if (!userGroupChildNo.isEmpty && !clickedEmpSrNo.isEmpty)
                {
                    
                    //let urlString = WebServiceManager.sharedInstance.getClaimDetailsPostUrlJson(groupChildSrNo: userGroupChildNo, employeesrno: clickedEmpSrNo)
                    var userGroupChildNoData = userGroupChildNo
                    print("userGroupChildNoData decrypted: ",userGroupChildNoData)
                    userGroupChildNoData = try! AES256.encrypt(input: userGroupChildNoData, passphrase: m_passphrase_Portal)
                    print("userGroupChildNoData encrypted: ",userGroupChildNoData)
                    
                    var clickedEmpSrNoData = clickedEmpSrNo
                    print("clickedEmpSrNoData decrypted: ",clickedEmpSrNoData)
                    clickedEmpSrNoData = try! AES256.encrypt(input: clickedEmpSrNoData, passphrase: m_passphrase_Portal)
                    print("clickedEmpSrNoData encrypted: ",clickedEmpSrNoData)
                    
                    
                    let urlString = WebServiceManager.sharedInstance.getClaimDetailsPostUrlJson(groupChildSrNo: userGroupChildNoData.URLEncoded, employeesrno: clickedEmpSrNoData.URLEncoded)
                    let url = URL(string: urlString)!
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                    print("authToken getClaimsJson:",authToken)
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
                    
                    print("getClaimsJson: ",urlString)
                    
                    let task = session.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print("getClaimsJson Error: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                self.m_tableView.isHidden=true
                                self.m_noInternetView.isHidden=false
                                    if m_windowPeriodStatus{
                                    self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
                                    self.m_errorMsgTitleLbl.text="During_Enrollment_Header_ErrorMsg".localized()
                                    self.m_errorMsgDetailLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
                                }else{
                                    self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
                                    self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
                                    self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                }
                            }
                            return
                        }
                        
                        // Check if a response was received
                        guard let httpResponse = response as? HTTPURLResponse else {
                            print("No response received")
                            return
                        }
                        
                        print("getClaimsJson httpResponse.statusCode: ",httpResponse.statusCode)
                        if httpResponse.statusCode == 200 {
                            // Parse the JSON data
                            print("Response:: ",response)
                            
                            guard let data = data else {
                                print("No data received")
                                return
                            }
                            
                            do {
                                // Parse the JSON response
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    if let msg = json["message"] as? [String: Any] {
                                        if msg["Status"] as? Bool == true{
                                            if let claimInformation = json["ClaimInformation"] as? [[String: Any]] {
                                                // Store the ClaimInformation in the desired format
                                                var resultsDictArray: [[String: String]] = []
                                                
                                                for claim in claimInformation {
                                                    var claimDict: [String: String] = [:]
                                                    claimDict["BENEFICIARY"] = claim["BENEFICIARY"] as? String
                                                    claimDict["CLAIM_NO"] = claim["CLAIM_NO"] as? String
                                                    claimDict["CLAIM_DATE"] = claim["CLAIM_DATE"] as? String
                                                    claimDict["CLAIM_AMT"] = claim["CLAIM_AMT"] as? String
                                                    claimDict["CLAIM_TYPE"] = claim["CLAIM_TYPE"] as? String
                                                    claimDict["CLAIM_SR_NO"] = claim["CLAIM_SR_NO"] as? String
                                                    claimDict["RELATION_WITH_EMPLOYEE"] = claim["RELATION_WITH_EMPLOYEE"] as? String
                                                    claimDict["CLAIM_STATUS"] = claim["CLAIM_STATUS"] as? String
                                                    
                                                    resultsDictArray.append(claimDict)
                                                    
                                                }
                                                
                                                // Access the resultsDictArray as needed
                                                print("ClaimInformation: \(resultsDictArray)")
                                                self.resultsDictArray = resultsDictArray
                                                
                                                print("ClaimInformation resultsDictArray: \(self.resultsDictArray)")
                                                DispatchQueue.main.async
                                                {
                                                    let status = DatabaseManager.sharedInstance.deleteClaimDetails()
                                                    if(status)
                                                    {
                                                        if self.resultsDictArray != nil
                                                        {
                                                            for claimDict in self.resultsDictArray!
                                                            {
                                                                let dict:NSDictionary = claimDict as NSDictionary; DatabaseManager.sharedInstance.saveMyClaimDetails(contactDict: dict)
                                                                
                                                            }
                                                        }
                                                    }
                                                    self.claimDetailsArray = DatabaseManager.sharedInstance.retrieveMyClaimDetails()
                                                    
                                                    
                                                    if let count : Int = (self.resultsDictArray?.count)
                                                    {
                                                        self.m_ClaimCountLbl.text=String(count)
                                                        self.m_totalCliamsTitleLbl.text="totalClaims".localized()
                                                        if(count==0)
                                                        {
                                                            
                                                            self.m_tableView.isHidden=true
                                                            self.m_noInternetView.isHidden=false
                                                            
                                                            if m_windowPeriodStatus{
                                                                self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
                                                                self.m_errorMsgTitleLbl.text="During_Enrollment_Header_ErrorMsg".localized()
                                                                self.m_errorMsgDetailLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
                                                            }else{
                                                                self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
                                                                self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
                                                                self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                                            }
                                                        }
                                                        else{
                                                            self.m_tableView.isHidden = false
                                                            self.m_noInternetView.isHidden = true
                                                            self.m_tableView.reloadData()
                                                        }
                                                    }
                                                    
                                                    self.hidePleaseWait1()
                                                }
                                            }
                                        } else {
                                            DispatchQueue.main.async{
                                                print("ClaimInformation not found in the JSON response")
                                                self.m_tableView.isHidden=true
                                                self.m_noInternetView.isHidden=false
                                                if m_windowPeriodStatus{
                                                    self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
                                                    self.m_errorMsgTitleLbl.text="During_Enrollment_Header_ErrorMsg".localized()
                                                    self.m_errorMsgDetailLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
                                                }else{
                                                    self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
                                                    self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
                                                    self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                                }
                                                //self.m_tableView.reloadData()
                                                self.hidePleaseWait1()
                                            }
                                        }
                                    }
                                } else {
                                    print("Invalid JSON format")
                                }
                            }
                            catch {
                                print("Error parsing JSON: \(error)")
                                self.hidePleaseWait1()
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                            }
                        }
                        else {
                            print("Request failed with status code: \(httpResponse.statusCode)")
                            DispatchQueue.main.async{
                                print("ClaimInformation not found in the JSON response")
                                self.m_tableView.isHidden=true
                                self.m_noInternetView.isHidden=false
                                if m_windowPeriodStatus{
                                    self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
                                    self.m_errorMsgTitleLbl.text="During_Enrollment_Header_ErrorMsg".localized()
                                    self.m_errorMsgDetailLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
                                }else{
                                    self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
                                    self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
                                    self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                }
                                //self.m_tableView.reloadData()
                                self.hidePleaseWait1()
                            }
                            
                        }
                        
                    }
                    task.resume()
                }
                else{
                    DispatchQueue.main.async{
                        print("ClaimInformation not found in the JSON response")
                        self.m_tableView.isHidden=true
                        self.m_noInternetView.isHidden=false
                        if m_windowPeriodStatus{
                            self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
                            self.m_errorMsgTitleLbl.text="During_Enrollment_Header_ErrorMsg".localized()
                            self.m_errorMsgDetailLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
                        }else{
                            self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
                            self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
                            self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
                        }
                        //self.m_tableView.reloadData()
                        self.hidePleaseWait1()
                    }
                }
            
        }
        else{
            //self.displayActivityAlert(title: "No internet")
            DispatchQueue.main.async{
                self.hidePleaseWait1()
                self.m_tableView.isHidden=true
                self.m_noInternetView.isHidden=false
                self.m_errorImageView.image=UIImage(named: "nointernet")
                self.m_errorMsgTitleLbl.text = error_NoInternet
                self.m_errorMsgDetailLbl.text = ""
            }
            
        }
    }
}
