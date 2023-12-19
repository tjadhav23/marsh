//
//  DashboardViewController.swift
//  MyBenefits
//
//  Created by Semantic on 12/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,XMLParserDelegate {
   
    
   
    
    @IBOutlet weak var termsVew: UIView!
    
    @IBOutlet weak var innerTermsVew: UIView!
    
    @IBOutlet weak var btnChk: UIButton!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var m_collectionView: UICollectionView!
    var isCheck : Bool = false
    let m_reuseIdentifier = "cell"
    var m_iconImageArray = [#imageLiteral(resourceName: "enrollment1"),#imageLiteral(resourceName: "My_Coverage"),#imageLiteral(resourceName: "My_Claims"),#imageLiteral(resourceName: "Utilities"),#imageLiteral(resourceName: "Contact_Details"),#imageLiteral(resourceName: "My_Claims"),#imageLiteral(resourceName: "Network_Hospitals"),#imageLiteral(resourceName: "Claim_Procedures")]
    var m_titleArray = ["Enrollment","My Coverages","My Claims","Utilities","Contact Details","My Intimations","Network Hospitals","Claim Procedures"]
    
    var xmlKey = String()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    let dictionaryKeys = ["EMPLOYEE_RELATION", "EMPLOYEE_RELATION_ID", "EMPLOYEE_NAME", "EMPLOYEE_DOB","EMPLOYEE_AGE","EMPLOYEE_GENDER","PERSON_SR_NO","OFFICIAL_EMAIL_ID","PERSONAL_EMAIL_ID","CELLPHONE_NO","BASE_SUM_INSURED","TOPUP_SUM_INSURED","EMPLOYEE_IDENTIFICATION_NO","EMPLOYEE_GRADE","EMPLOYEE_DEPARTMENT","EMPLOYEE_DESIGNATION","EMPLOYEE_DOJ","EMP_TOPUP_OPTED","EMP_TOPUP_SI","EMP_TOPUP_PREMIUM","EMP_TOPUP_PREM_DEDTN_MESSAGE","EMP_TOPUP_OPTD_SR_NO","PERSON_SR_NO","DEPENDANT_RELATION","DEPENDANT_RELATION_ID","DEPENDANT_NAME","DEPENDANT_DOB","DEPENDANT_AGE"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
           // App already launched
            termsVew.alpha = 0
            tabBarController?.tabBar.isUserInteractionEnabled = true
            

        } else {
           // This is the first launch ever
            termsVew.alpha = 1
            tabBarController?.tabBar.isUserInteractionEnabled = false
           UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
           UserDefaults.standard.synchronize()
        }
        let nib = UINib (nibName: "DashboardCollectionViewCell", bundle: nil)
        m_collectionView.register(nib, forCellWithReuseIdentifier: m_reuseIdentifier)
//        m_collectionView.register(DashboardCollectionViewCell.self, forCellWithReuseIdentifier: m_reuseIdentifier)
        
        m_collectionView.delegate=self
        m_collectionView.dataSource=self
        m_collectionView.backgroundColor=hexStringToUIColor(hex: "#0c3f7e")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        m_collectionView.collectionViewLayout=layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
      
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: "82A0F6")])
        navigationController?.navigationBar.dropShadow()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        let status=UserDefaults.standard.object(forKey: "isAlreadylogin") as? Bool
        if(status==false)
        {
            getDataSettings()
        }
    }
        func getDataSettings()
        {
           if(isConnectedToNet())
           {
            showPleaseWait(msg: "Please wait...")
           
            
            var employeeDetailsArray : Array<EMPLOYEE_INFORMATION> = []
            employeeDetailsArray = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
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
                    
////                    if let childNo = userDict.groupChildSrNo
////                    {
//                        groupchildsrno = String(userDict.groupChildSrNo)
////                    }
////                    if let oeinfNo = userDict.oe_group_base_Info_Sr_No
////                    {
//                        oegrpbasinfsrno = String(userDict.oe_group_base_Info_Sr_No)
////                    }
                    
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getEnrollmentDataSettings(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno, employeesrno: UserDefaults.standard.value(forKey: "EmployeeSrNo") as! String))
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?// NSURL(string: urlreq)
                    request.httpMethod = "GET"
                    
                    
                    
                    let task = URLSession.shared.dataTask(with: urlreq! as URL)
                    {   (data, response, error) in
                        
                        if data == nil
                        {
                            
                            return
                        }
                        self.xmlKey = "EmployeeSettings"
                        let parser = XMLParser(data: data!)
                        parser.delegate = self as? XMLParserDelegate
                        parser.parse()
                        print(self.resultsDictArray ?? "")
                        for obj in self.resultsDictArray!
                        {
                            
                            print(obj)
                            let userDict : NSDictionary = obj as NSDictionary
                            UserDefaults.standard.set(userDict, forKey: "DataSettingsDict")
                            print(userDict)
                            
                        }
                        
                        let defaults = UserDefaults.standard
                        defaults.set(true, forKey: "isAlreadylogin")
                        self.hidePleaseWait()
                        
                    }
                    task.resume()
                }
            }
        
            }
            
            
        }
    
        
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return m_titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : DashboardCollectionViewCell = collectionView .dequeueReusableCell(withReuseIdentifier: m_reuseIdentifier, for: indexPath) as! DashboardCollectionViewCell
        
        cell.m_titleLbl?.text=m_titleArray[indexPath.row]
        cell.m_imageView?.image=m_iconImageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 0:
//            let enrollMent : EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
//            navigationController?.pushViewController(enrollMent, animated: true)
            return
        case 1:
            let myCoverages : MyCoveragesViewController = MyCoveragesViewController()
            navigationController?.pushViewController(myCoverages, animated: true)
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        case 2:
           
            return
        case 3:
            let utilities : UtilitiesViewController = UtilitiesViewController()
            navigationController?.pushViewController(utilities, animated: true)
            return
        case 4:
            let contactsVC : ContactDetailsViewController = ContactDetailsViewController()
            navigationController?.pushViewController(contactsVC, animated: true)
            return
        case 5:
            let myIntimation : MyIntimationViewController = MyIntimationViewController()
            navigationController?.pushViewController(myIntimation, animated: true)
        case 6:
            let networkHospitals : NetworkHospitalsViewController = NetworkHospitalsViewController()
            navigationController?.pushViewController(networkHospitals, animated: true)
           return
        case 7:
            let claimProcedures : ClaimProcedureViewController = ClaimProcedureViewController()
            navigationController?.pushViewController(claimProcedures, animated: true)
            return
        default:
            return
        }
        
    }

    @IBAction func btnContinueAct(_ sender: Any) {
        termsVew.alpha = 0
        tabBarController?.tabBar.isUserInteractionEnabled = true
        UserDefaults.standard.set(true, forKey: "isTermsConditions") as? Bool
        let isterms = UserDefaults.standard.value(forKey: "isTermsConditions") as? Bool
        print(isterms)
        UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
        
        self.navigationItem.rightBarButtonItem?.isEnabled=true
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.tabBarController?.tabBar.isHidden=false
        menuButton.isHidden = false
    }
    
    @IBAction func btnCancelAct(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "HasLaunchedOnce")
    }
    
    
    @IBAction func btnChkAct(_ sender: Any) {
        if !isCheck{
            isCheck = true
            btnChk.setImage(UIImage(named: "Check Box - Checked-1"), for: .normal)
            btnContinue.isUserInteractionEnabled = true
            btnContinue.backgroundColor = Color.buttonBackgroundGreen.value
        }else{
            isCheck = false
            btnChk.setImage(UIImage(named: "Check Box - Unchecked-1"), for: .normal)
            btnContinue.isUserInteractionEnabled = false
           // btnContinue.backgroundColor = Color.dark_grey.value
        }
    }
    @IBAction func btnTermsOfUseAct(_ sender: Any) {
        let url = URL(string: "https://core.mybenefits360.com/termsOfUse.html")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func btnRefundPolicyAct(_ sender: Any) {
        let url = URL(string: "https://core.mybenefits360.com/RefundPolicy.html")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func btnDisclaimerAct(_ sender: Any) {
        let url = URL(string: "https://core.mybenefits360.com/disclaimer.html")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func btnPrivacyPolicyAct(_ sender: Any) {
        let url = URL(string: "https://core.mybenefits360.com/PrivacyPolicy.html")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func profileButtonClicked(_ sender: Any)
    {
        let profileVC : ProfileViewController = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    
    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
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
            
            if let dict = self.currentDictionary
            {
                self.currentDictionary![elementName] = currentValue
                self.currentValue = ""
            }
            
        }
        
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        
        
    }
}
