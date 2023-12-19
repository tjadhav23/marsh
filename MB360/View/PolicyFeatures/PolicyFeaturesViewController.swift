//
//  PolicyFeaturesViewController.swift
//  MyBenefits
//
//  Created by Semantic on 21/06/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import FirebaseCrashlytics
import TrustKit
import AesEverywhere

struct PolicyModel {
    var featureType : String?
    var polictDetailsArray = [PolicyDetails]()
    var isExpanded = false
    var isAnnexture = false
    
    var isDownloadableFeature = false
    
    var annexturePath : String?
    var annextureDesc : String?
}

struct PolicyDetails {
    var title: String?
    var details: String?
}

class PolicyFeaturesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate,UIDocumentInteractionControllerDelegate, NewPoicySelectedDelegate {
    
    @IBOutlet weak var m_GPATab: UIButton!
    
    
    @IBOutlet weak var m_descriptionTitleLbl: UILabel!
    
    @IBOutlet weak var m_GTLTab: UIButton!
    @IBOutlet weak var m_GMCTab: UIButton!
    @IBOutlet weak var m_GTLShadowView: UIView!
    @IBOutlet weak var m_GPAShadowView: UIView!
    @IBOutlet weak var m_GMCShadowView: UIView!
    @IBOutlet weak var m_topBar: UIView!
    @IBOutlet weak var m_tableView: UITableView!
    
    @IBOutlet weak var noDataFoundImage: UIImageView!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    
    @IBOutlet weak var m_noInternetView: UIView!
    @IBOutlet weak var m_errorImageview: UIImageView!
    @IBOutlet weak var noInternetHeaderLbl: UILabel!
    @IBOutlet weak var noInternetDescLbl: UILabel!
    
    
    @IBOutlet weak var PolicylblView: UIView!
    @IBOutlet weak var policyNamelbl: UILabel!
    @IBOutlet weak var policyButtonView: UIView!
    @IBOutlet weak var policyButtonLbl: UILabel!
    
    var selectedIndexPosition = -1
    var policyDataArray = [OE_GROUP_BASIC_INFORMATION]()
    var selectedPolicyValue = ""
    
    var documentController: UIDocumentInteractionController = UIDocumentInteractionController()
    var isFromSideBar = Bool()
    let reuseIdentifier = "cell"
    var m_productCode = String()
    
    let dictionaryKeys = ["PolicyFeatures", "ANNEXURE_NAME", "ANNEXURE_DESC","ANNEXURE_PATH", "FILE_NAME","SYS_GEN_FILE_NAME","POL_FEAT_DISPLAY_TYPE","POL_FEAT_TYPE","POL_INFORMATION","POL_TERMS_CONDITIONS","POL_INFO_DISPLAY_TO"]
    
    var array1 = Array<Int>()
    var array2 = Array<PolicyFeaturesDetails>()
    var m_policyFeatureType = String()
    var m_policyID : Int = -1
    
    var xmlKey = String()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    var m_policyFeatureArray = Array<PolicyFeaturesDetails>()
    var m_imageArray = ["policyInfo","FamilyInfo","CorporateInfo","OPDBenefits","RoomRent"]
    var m_policyAnnexuresArray = Array<PolicyAnnexure>()
    var datasource = [ExpandedPolicyDetailsCell]()
    var isDataAvailable = Bool()
    var m_downloadPdfLink = String()
    
    var retryCountPolicyFeaturesPortal = 0
    var maxRetryPolicyFeaturesPortal = 1
    
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
        userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
        
        addTarget()
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        
        print("Selected values ",selectedPolicyValue," : ",m_productCode)
        
        
        m_tableView.register(PolicyFeaturesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        m_tableView.register(UINib (nibName: "PolicyFeaturesTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        m_tableView.register(PolicyFeatureHeaderCell.self, forCellReuseIdentifier: "PolicyFeatureHeaderCell")
        m_tableView.register(UINib (nibName: "PolicyFeatureHeaderCell", bundle: nil), forCellReuseIdentifier: "PolicyFeatureHeaderCell")
        
        m_tableView.register(PolicyDetailsCell.self, forCellReuseIdentifier: "PolicyDetailsCell")
        m_tableView.register(UINib (nibName: "PolicyDetailsCell", bundle: nil), forCellReuseIdentifier: "PolicyDetailsCell")
        
        m_tableView.register(AnnexureTableViewCell.self, forCellReuseIdentifier: "Cell")
        m_tableView.register(UINib (nibName: "AnnexureTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        
        isDataAvailable=true
        
        m_topBar.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
        
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        m_tableView.tableFooterView=UIView()
        //        self.tabBarController?.tabBar.isHidden=true
        
        self.m_tableView.estimatedRowHeight = 100;
        self.m_tableView.rowHeight = UITableViewAutomaticDimension;
        
        //Remove Extra space on tablview Content inset
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        m_tableView.tableHeaderView = UIView(frame: frame)
        
        
        
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        
        print("Policy Feature Page Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
        
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
        
        if m_productCode == "GMC"{
            GMCTabSeleted()
        }
        else if m_productCode == "GPA"{
            GPATabSelected()
        }
        else if m_productCode == "GTL"{
            GTLTabSelected()
        }
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        print("m_productCode: ",m_productCode)
        
      
        
        setData()
    }
    
    //MARK:- DATASOURCE
    var titleArray = [String]()
    func createDataSource() {
        print("CREATE DATASOURCE...............")
        self.titleArray.removeAll()
        self.policyModelArray.removeAll()
        
        let serialQueue = DispatchQueue(label: "PolicyFeatureQueue")
        serialQueue.sync {
            var dbDataSource =  DatabaseManager.sharedInstance.retrievePolicyFeatures(productCode: self.m_productCode)
            
            for obj in dbDataSource {
                if !(titleArray.contains(obj.policyFeatureType ?? "")) {
                    if let title = obj.policyFeatureType {
                        if(title != "" && (obj.policyInfoDisplayTo == "1" || obj.policyInfoDisplayTo == "3")){
                            self.titleArray.append(title)
                            print("title: ",title)
                        }
                    }
                }
            }
            
            
        } //sync
        serialQueue.sync {
            //print(titleArray)
            createMainDataSource()
        }
        
        print(policyModelArray.count)
        //print(policyModelArray)
    }
    
    var policyModelArray = [PolicyModel]()
    func createMainDataSource() {
        print("CREATE MAIN DATASOURCE...............",titleArray)
        
        
        if titleArray.count > 0 {
            for title in titleArray {
                let policyDetailsArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: title)
                print(policyDetailsArray)
                var policyDetailsModelArray = [PolicyDetails]()
                
                for dbObj in policyDetailsArray
                {
                    let obj = PolicyDetails.init(title: dbObj.policyInfo ?? "", details: dbObj.policyTermsCondition ?? "")
                    
                    if dbObj.policyInfoDisplayTo == "1" || dbObj.policyInfoDisplayTo == "3"{
                        policyDetailsModelArray.append(obj)
                    }
                }
                
                var isDownloadableFeature = false
                print(title)
                if title.uppercased() == "POLICY FEATURE LINK" {
                    isDownloadableFeature = true
                }
                let finalObj = PolicyModel.init(featureType: title, polictDetailsArray: policyDetailsModelArray,isDownloadableFeature: isDownloadableFeature)
                self.policyModelArray.append(finalObj)
            }
        }
        
        let annextureArray =  DatabaseManager.sharedInstance.retrieveAnnexuresforTcl(productCode: self.m_productCode)
        
        for obj in annextureArray {
            if !(titleArray.contains(obj.annexureName ?? "")) {
                if let title = obj.annexureName {
                    if title != "" && title != "NOT AVAILABLE" {
                        //  self.titleArray.append(title)
                        let finalObj = PolicyModel.init(featureType: title, polictDetailsArray: [PolicyDetails](),isExpanded: false,isAnnexture: true,annexturePath: obj.annexurePath,annextureDesc: obj.annexureDesc)
                        
                        self.policyModelArray.append(finalObj)
                    }
                }
            }
        }
        
        
        self.m_tableView.reloadData()
        print("END COUNT = \(policyModelArray.count)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        print("PolicyFeature selectedIndexPosition is viewWillAppear  : ",selectedIndexPosition)
        
       
        PolicylblView.setBorderToViewSelectPolicy(color:hexStringToUIColor(hex: "E5E5E5"))
        
        navigationController?.navigationBar.isHidden=false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        
    }
    @IBAction func GPATabSelected(_ sender: Any)
    {
//        if userEmployeeSrnoGPA == ""{
//            self.displayActivityAlert(title: "Please contact your HR or Marsh Ops. team")
//        }else{
            if isGPADataPresent{
                selectedIndexPosition = 0
                GPATabSelected()
            }else{
                self.displayActivityAlert(title: "Policy not available!")
            }
//        }
    }
    
    @IBAction func GMCTabSelected(_ sender: Any)
    {
        if isGHIDataPresent{
            selectedIndexPosition = 0
            GMCTabSeleted()
        }else{
            self.displayActivityAlert(title: "Policy not available!")
        }
    }
    
    @IBAction func GTLTabselected(_ sender: Any)
    {
//        if userEmployeeSrnoGTL == ""{
//            self.displayActivityAlert(title: "Please contact your HR or Marsh Ops. team")
//        }else{
            if isGTLDataPresent{
                selectedIndexPosition = 0
                GTLTabSelected()
            }else{
                self.displayActivityAlert(title: "Policy not available!")
            }
//        }
    }
    
    
    func displayData(indexPath:IndexPath,cell:PolicyFeaturesTableViewCell)
    {
        cell.m_policyInfoLbl1.isHidden=true
        cell.termsConditionsLbl1.isHidden=true
        cell.m_policyInfoLbl2.isHidden=true
        cell.termsConditionsLbl2.isHidden=true
        cell.m_policyInfoLbl3.isHidden=true
        cell.termsConditionsLbl3.isHidden=true
        cell.m_policyInfoLbl4.isHidden=true
        cell.termsConditionsLbl4.isHidden=true
        cell.m_policyInfoLbl5.isHidden=true
        cell.termsConditionsLbl5.isHidden=true
        cell.m_policyInfoLbl6.isHidden=true
        cell.termsConditionsLbl6.isHidden=true
        cell.m_policyInfoLbl7.isHidden=true
        cell.termsConditionsLbl7.isHidden=true
        cell.m_policyInfoLbl8.isHidden=true
        cell.termsConditionsLbl8.isHidden=true
        
        
        let len =  m_policyFeatureArray.count
        for index in 0..<len
        {
            
            let policyDict:PolicyFeaturesDetails=m_policyFeatureArray[index]
            var info = policyDict.policyTermsCondition?.replacingOccurrences(of: "<br>", with: "")
            info = info?.replacingOccurrences(of: "</br>", with: " ")
            info = info?.replacingOccurrences(of: "<span>", with: "")
            info = info?.replacingOccurrences(of: "</span>", with: "")
            info = info?.replacingOccurrences(of: "\r\n  ", with: " ")
            info = info?.replacingOccurrences(of: "\r\n", with: " ")
            cell.m_titleLbl.text=policyDict.policyFeatureType
            
            print("info: ",info)
            print("cell.m_titleLbl.text: ",policyDict.policyFeatureType)
            
            
            switch policyDict.policyFeatureType
            {
                
            case "FAMILY INFORMATION" :
                if(policyDict.policyInfo=="FAMILY SIZE")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                else if(policyDict.policyInfo=="FAMILY DEFINITION")
                {
                    cell.m_policyInfoLbl2.text=policyDict.policyInfo
                    cell.termsConditionsLbl2.text=info
                    
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=false
                cell.termsConditionsLbl2.isHidden=false
                cell.m_policyInfoLbl3.isHidden=true
                cell.termsConditionsLbl3.isHidden=true
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                cell.m_policyInfoLbl3.text=""
                cell.termsConditionsLbl3.text=""
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                
                break
            case "POLICY INFORMATION" :
                if(policyDict.policyInfo=="POLICY TYPE")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                else if(policyDict.policyInfo=="SUM INSURED")
                {
                    cell.m_policyInfoLbl2.text=policyDict.policyInfo
                    let array = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
                    cell.termsConditionsLbl2.text=array[0].baseSumInsured
                    
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=false
                cell.termsConditionsLbl2.isHidden=false
                cell.m_policyInfoLbl3.isHidden=true
                cell.termsConditionsLbl3.isHidden=true
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                cell.m_policyInfoLbl3.text=""
                cell.termsConditionsLbl3.text=""
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            case "CASHLESS FACILITY" :
                if(policyDict.policyInfo=="CASHLESS FACILITY")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=true
                cell.termsConditionsLbl2.isHidden=true
                cell.m_policyInfoLbl3.isHidden=true
                cell.termsConditionsLbl3.isHidden=true
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                
                cell.m_policyInfoLbl2.text=""
                cell.termsConditionsLbl2.text=""
                cell.m_policyInfoLbl3.text=""
                cell.termsConditionsLbl3.text=""
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            case "POLICY AGE" :
                if(policyDict.policyInfo=="ENTRY AGE LIMIT")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                else if(policyDict.policyInfo=="MINIMUM AGE")
                {
                    cell.m_policyInfoLbl2.text=policyDict.policyInfo
                    cell.termsConditionsLbl2.text=info
                    
                }
                else if(policyDict.policyInfo=="MAXIMUM AGE")
                {
                    cell.m_policyInfoLbl3.text=policyDict.policyInfo
                    cell.termsConditionsLbl3.text=info
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=false
                cell.termsConditionsLbl2.isHidden=false
                cell.m_policyInfoLbl3.isHidden=false
                cell.termsConditionsLbl3.isHidden=false
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            case "AILMENT COVERED" :
                if(policyDict.policyInfo=="PRE EXISTING AILMENT COVER")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                else if(policyDict.policyInfo=="30 DAYS WAITING PERIOD")
                {
                    cell.m_policyInfoLbl2.text=policyDict.policyInfo
                    cell.termsConditionsLbl2.text=info
                    
                }
                else if(policyDict.policyInfo=="1st, 2nd, 3rd, 4th YEAR EXCLUSION")
                {
                    cell.m_policyInfoLbl3.text=policyDict.policyInfo
                    cell.termsConditionsLbl3.text=info
                }
                else if(policyDict.policyInfo=="DAYCARE PROCEDURES")
                {
                    cell.m_policyInfoLbl4.text=policyDict.policyInfo
                    cell.termsConditionsLbl4.text=info
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=false
                cell.termsConditionsLbl2.isHidden=false
                cell.m_policyInfoLbl3.isHidden=false
                cell.termsConditionsLbl3.isHidden=false
                cell.m_policyInfoLbl4.isHidden=false
                cell.termsConditionsLbl4.isHidden=false
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            case "OPD BENEFITS" :
                if(policyDict.policyInfo=="OPD BENEFIT")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                else if(policyDict.policyInfo=="OPD BENEFIT SUBLIMIT")
                {
                    cell.m_policyInfoLbl2.text=policyDict.policyInfo
                    cell.termsConditionsLbl2.text=info
                    
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=false
                cell.termsConditionsLbl2.isHidden=false
                cell.m_policyInfoLbl3.isHidden=true
                cell.termsConditionsLbl3.isHidden=true
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                
                cell.m_policyInfoLbl3.text=""
                cell.termsConditionsLbl3.text=""
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            case "MATERNITY BENEFITS" :
                
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=false
                cell.termsConditionsLbl2.isHidden=false
                cell.m_policyInfoLbl3.isHidden=false
                cell.termsConditionsLbl3.isHidden=false
                cell.m_policyInfoLbl4.isHidden=false
                cell.termsConditionsLbl4.isHidden=false
                cell.m_policyInfoLbl5.isHidden=false
                cell.termsConditionsLbl5.isHidden=false
                cell.m_policyInfoLbl6.isHidden=false
                cell.termsConditionsLbl6.isHidden=false
                cell.m_policyInfoLbl7.isHidden=false
                cell.termsConditionsLbl7.isHidden=false
                cell.m_policyInfoLbl8.isHidden=false
                cell.termsConditionsLbl8.isHidden=false
                
                if(policyDict.policyInfo=="MATERNITY BENEFIT")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                else if(policyDict.policyInfo=="NINE MONTHS WAITING PERIOD FOR MATERNITY BENEFIT")
                {
                    cell.m_policyInfoLbl2.text=policyDict.policyInfo
                    cell.termsConditionsLbl2.text=info
                    
                }
                else if(policyDict.policyInfo=="SUBLIMIT SUM INSURED FOR NORMAL DELIVERY")
                {
                    cell.m_policyInfoLbl3.text=policyDict.policyInfo
                    cell.termsConditionsLbl3.text=info
                }
                else if(policyDict.policyInfo=="SUBLIMIT SUM INSURED FOR CAESARIAN DELIVERY")
                {
                    cell.m_policyInfoLbl4.text=policyDict.policyInfo
                    cell.termsConditionsLbl4.text=info
                }
                if(policyDict.policyInfo=="PRE & POST NATAL COVER WITH MATERNITY SI LIMIT")
                {
                    cell.m_policyInfoLbl5.text=policyDict.policyInfo
                    cell.termsConditionsLbl5.text=info
                }
                else if(policyDict.policyInfo=="NEW BORN BABY COVER")
                {
                    cell.m_policyInfoLbl6.text=policyDict.policyInfo
                    cell.termsConditionsLbl6.text=info
                    
                }
                else if(policyDict.policyInfo=="COVERED FROM")
                {
                    cell.m_policyInfoLbl7.text=policyDict.policyInfo
                    cell.termsConditionsLbl7.text=info
                }
                else if(policyDict.policyInfo=="COVERAGE WITHIN")
                {
                    cell.m_policyInfoLbl8.text=policyDict.policyInfo
                    cell.termsConditionsLbl8.text=info
                }
                break
            case "ROOM RENT CAPPING" :
                if(policyDict.policyInfo=="NORMAL ROOM RENT")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                else if(policyDict.policyInfo=="ICU ROOM RENT")
                {
                    cell.m_policyInfoLbl2.text=policyDict.policyInfo
                    cell.termsConditionsLbl2.text=info
                    
                }
                else if(policyDict.policyInfo=="AMBULANCE CHARGES LIMIT")
                {
                    cell.m_policyInfoLbl3.text=policyDict.policyInfo
                    cell.termsConditionsLbl3.text=info
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=false
                cell.termsConditionsLbl2.isHidden=false
                cell.m_policyInfoLbl3.isHidden=false
                cell.termsConditionsLbl3.isHidden=false
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            case "PPN NETWORK" :
                if(policyDict.policyInfo=="PPN NETWORK")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=true
                cell.termsConditionsLbl2.isHidden=true
                cell.m_policyInfoLbl3.isHidden=true
                cell.termsConditionsLbl3.isHidden=true
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                cell.m_policyInfoLbl2.text=""
                cell.termsConditionsLbl2.text=""
                cell.m_policyInfoLbl3.text=""
                cell.termsConditionsLbl3.text=""
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            case "HOSPITAL EXPENSE" :
                if(policyDict.policyInfo=="PRE HOSPITALIZATION EXPENSES COVER")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                else if(policyDict.policyInfo=="POST HOSPITALIZATION EXPENSES COVER")
                {
                    cell.m_policyInfoLbl2.text=policyDict.policyInfo
                    cell.termsConditionsLbl2.text=info
                    
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=false
                cell.termsConditionsLbl2.isHidden=false
                cell.m_policyInfoLbl3.isHidden=true
                cell.termsConditionsLbl3.isHidden=true
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                
                cell.m_policyInfoLbl3.text=""
                cell.termsConditionsLbl3.text=""
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            case "CO-PAYMENT" :
                if(policyDict.policyInfo=="CO-PAYMENT ON CLAIMS")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                else if(policyDict.policyInfo=="CO-PAYMENT AMOUNT")
                {
                    cell.m_policyInfoLbl2.text=policyDict.policyInfo
                    cell.termsConditionsLbl2.text=info
                    
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=false
                cell.termsConditionsLbl2.isHidden=false
                cell.m_policyInfoLbl3.isHidden=true
                cell.termsConditionsLbl3.isHidden=true
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                
                cell.m_policyInfoLbl3.text=""
                cell.termsConditionsLbl3.text=""
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            case "CLAIM INTIMATION" :
                if(policyDict.policyInfo=="CLAIM SUBMISSION")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                else if(policyDict.policyInfo=="CLAIM INTIMATION")
                {
                    cell.m_policyInfoLbl2.text=policyDict.policyInfo
                    cell.termsConditionsLbl2.text=info
                    
                }
                else if(policyDict.policyInfo=="CLAIM INTIMATION CLAUSE")
                {
                    cell.m_policyInfoLbl3.text=policyDict.policyInfo
                    cell.termsConditionsLbl3.text=info
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=false
                cell.termsConditionsLbl2.isHidden=false
                cell.m_policyInfoLbl3.isHidden=false
                cell.termsConditionsLbl3.isHidden=false
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            case "AILMENTWISE CAPPING" :
                if(policyDict.policyInfo=="AILMENTWISE CLAIM CAPPING")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                else if(policyDict.policyInfo=="AILMENTWISE CLAIM CAPPING SUBLIMIT")
                {
                    cell.m_policyInfoLbl2.text=policyDict.policyInfo
                    cell.termsConditionsLbl2.text=info
                    
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=false
                cell.termsConditionsLbl2.isHidden=false
                cell.m_policyInfoLbl3.isHidden=true
                cell.termsConditionsLbl3.isHidden=true
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                
                cell.m_policyInfoLbl3.text=""
                cell.termsConditionsLbl3.text=""
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            case "SPECIAL REMARKS" :
                if(policyDict.policyInfo=="SPECIAL REMARKS")
                {
                    cell.m_policyInfoLbl1.text=policyDict.policyInfo
                    cell.termsConditionsLbl1.text=info
                }
                cell.m_policyInfoLbl1.isHidden=false
                cell.termsConditionsLbl1.isHidden=false
                cell.m_policyInfoLbl2.isHidden=true
                cell.termsConditionsLbl2.isHidden=true
                cell.m_policyInfoLbl3.isHidden=true
                cell.termsConditionsLbl3.isHidden=true
                cell.m_policyInfoLbl4.isHidden=true
                cell.termsConditionsLbl4.isHidden=true
                cell.m_policyInfoLbl5.isHidden=true
                cell.termsConditionsLbl5.isHidden=true
                cell.m_policyInfoLbl6.isHidden=true
                cell.termsConditionsLbl6.isHidden=true
                cell.m_policyInfoLbl7.isHidden=true
                cell.termsConditionsLbl7.isHidden=true
                cell.m_policyInfoLbl8.isHidden=true
                cell.termsConditionsLbl8.isHidden=true
                cell.m_policyInfoLbl2.text=""
                cell.termsConditionsLbl2.text=""
                cell.m_policyInfoLbl3.text=""
                cell.termsConditionsLbl3.text=""
                cell.m_policyInfoLbl4.text=""
                cell.termsConditionsLbl4.text=""
                cell.m_policyInfoLbl5.text=""
                cell.termsConditionsLbl5.text=""
                cell.m_policyInfoLbl6.text=""
                cell.termsConditionsLbl6.text=""
                cell.m_policyInfoLbl7.text=""
                cell.termsConditionsLbl7.text=""
                cell.m_policyInfoLbl8.text=""
                cell.termsConditionsLbl8.text=""
                break
            default:
                break
            }
            
        }
        
    }
    func fetchDataFromDatabase(indexPath:IndexPath, cell:PolicyFeaturesTableViewCell)
    {
        if(m_productCode=="GMC")
        {
            
            switch indexPath.row {
            case 0:
                if(m_downloadPdfLink != "")
                {
                    cell.m_titleLbl.text="Download Policy Features"
                    cell.m_titleImageView?.image=UIImage(named: "pdf-1")
                    cell.m_expandButton.setImage(UIImage(named: "download"), for: .normal)
                    cell.m_expandButtonHeightConstraint.constant=20
                    
                }
                else
                {
                    m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "FAMILY INFORMATION")
                    displayData(indexPath: indexPath,cell: cell)
                    cell.m_titleImageView.image=UIImage(named: "family")
                    
                }
                
                break
            case 1:
                
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "POLICY INFORMATION")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "PolicyFeature")
                
                break
                
            case 2:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "CASHLESS FACILITY")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "CashlessFacility")
                
                break
            case 3:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "POLICY AGE")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "policyage")
                break
            case 4:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "AILMENT COVERED")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "ailment")
                break
            case 5:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "OPD BENEFITS")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "OPDBenefits")
                break
            case 6:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "MATERNITY BENEFITS")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "maternity")
                break
            case 7:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "ROOM RENT CAPPING")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "RoomRent")
                break
            case 8:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "PPN NETWORK")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "ppn")
                break
            case 9:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "HOSPITAL EXPENSE")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "HosExp")
                break
            case 10:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "CO-PAYMENT")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "copayment")
                break
            case 11:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "CLAIM INTIMATION")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "IntimateClaim-1")
                break
            case 12:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "AILMENTWISE CAPPING")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "ailmentcaping")
                break
            case 13:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "SPECIAL REMARKS")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "SpecialRemark")
                break
                
                
            default:
                break
            }
            
            
        }
        else if(m_productCode=="GPA")
        {
            switch indexPath.row {
            case 0:
                if(m_downloadPdfLink != "")
                {
                    cell.m_titleLbl.text="Download Policy Features"
                    cell.m_titleImageView?.image=UIImage(named: "pdf-1")
                }
                else
                {
                    m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "FAMILY INFORMATION")
                    displayData(indexPath: indexPath,cell: cell)
                    cell.m_titleImageView.image=UIImage(named: "family")
                }
                
                break
            case 1:
                
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "POLICY INFORMATION")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "policyInfo")
                
                break
                
                //            case 2:
                //                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "CASHLESS FACILITY")
                //                displayData(indexPath: indexPath,cell: cell)
                //                break
            case 2:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "POLICY AGE")
                displayData(indexPath: indexPath,cell: cell)
                break
            case 3:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "CLAIM INTIMATION")
                displayData(indexPath: indexPath,cell: cell)
                break
            case 4:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "OTHER BENEFITS")
                displayData(indexPath: indexPath,cell: cell)
                break
                
            default:
                break
            }
            
        }
        else if(m_productCode=="GTL")
        {
            switch indexPath.row
            {
            case 0:
                if(m_downloadPdfLink != "")
                {
                    cell.m_titleLbl.text="Download Policy Features"
                    cell.m_titleImageView?.image=UIImage(named: "pdf-1")
                }
                else
                {
                    m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "FAMILY INFORMATION")
                    displayData(indexPath: indexPath,cell: cell)
                    cell.m_titleImageView.image=UIImage(named: "family")
                }
                
                break
            case 1:
                
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "POLICY INFORMATION")
                displayData(indexPath: indexPath,cell: cell)
                cell.m_titleImageView.image=UIImage(named: "policyInfo")
                
                break
                
                //            case 2:
                //                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "CASHLESS FACILITY")
                //                displayData(indexPath: indexPath,cell: cell)
                //                break
            case 2:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "POLICY AGE")
                displayData(indexPath: indexPath,cell: cell)
                break
            case 3:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "CLAIM INTIMATION")
                displayData(indexPath: indexPath,cell: cell)
                break
            case 4:
                m_policyFeatureArray = DatabaseManager.sharedInstance.retrievePolicyFeaturesByName(productCode: m_productCode, name: "OTHER BENEFITS")
                displayData(indexPath: indexPath,cell: cell)
                break
            default:
                break
            }
            
        }
        
    }
    
    //MARK:- Annexture Tapped
    @objc func viewAnnexureButtonClicked(sender:UIButton)
    {
        let index = sender.tag
        if let pathUrl = policyModelArray[index].annexturePath {
            displayAnnexture(fileName: pathUrl)
        }
        
        //let index = IndexPath(row: sender.tag, section: 1)
        //tableView(m_tableView, didSelectRowAt: index)
    }
    
    func displayAnnexture(fileName:String) {
        showPleaseWait(msg: "")
        
        DispatchQueue.main.async
        {
            let url : NSString = fileName as NSString
            var urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            
            if var searchURL : NSURL = NSURL(string: urlStr as String)
            {
                //                    let url : URL = URL(string:fileName as! String)
                let request = URLRequest(url: searchURL as URL)
                let session = URLSession(configuration: URLSessionConfiguration.default)
                
                let task = session.dataTask(with: request, completionHandler:
                                                {(data, response, error) -> Void in
                    
                    
                    let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                    
                    
                    if var fileName = searchURL.lastPathComponent
                    {
                        
                        
                        let destinationUrl = documentsUrl.appendingPathComponent(fileName)
                        let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
                        if let data = data
                        {
                            do
                            {
                                try self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
                                try data.write(to: destinationUrl!, options: .atomic)
                            }
                            catch
                            {
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                print(error)
                            }
                            
                            //                                            self.documentController = UIDocumentInteractionController(url: destinationUrl!)
                        }
                        else
                        {
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
                            
                        }
                    }
                    
                    
                })
                task.resume()
            }
            else
            {
                self.hidePleaseWait()
                self.displayActivityAlert(title: m_errorMsg)
            }
        }
        
    }
    
    
    /*  func displayData(indexPath:IndexPath,cell:PolicyFeaturesTableViewCell)
     {
     
     
     let len =  m_policyFeatureArray.count
     for index in 0..<len
     {
     
     let policyDict:PolicyFeaturesDetails=m_policyFeatureArray[index]
     var info = policyDict.policyTermsCondition?.replacingOccurrences(of: "<br>", with: "")
     info = info?.replacingOccurrences(of: "</br>", with: " ")
     info = info?.replacingOccurrences(of: "<span>", with: "")
     info = info?.replacingOccurrences(of: "</span>", with: "")
     info = info?.replacingOccurrences(of: "\r\n  ", with: " ")
     info = info?.replacingOccurrences(of: "\r\n", with: " ")
     
     policyDict.policyTermsCondition=info
     if(index==0)
     {
     cell.m_term2BottomConstraint.constant=0
     cell.m_infoLbl3BottomConstraint.constant=0
     cell.m_term3BottomConstraint.constant=0
     cell.m_infoLbl4BottomConstraint.constant=0
     print("Condition :"+policyDict.policyTermsCondition!)
     cell.m_titleLbl.text=policyDict.policyFeatureType
     cell.m_policyInfoLbl1.text=policyDict.policyInfo
     if(policyDict.policyFeatureType=="POLICY INFORMATION")
     {
     let array = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
     cell.termsConditionsLbl1.text=array[0].baseSumInsured
     }
     else
     {
     cell.termsConditionsLbl1.text=info
     }
     if(cell.m_titleLbl.text=="CASHLESS FACILITY")
     {
     cell.m_backgroundViewHeightConstraint.constant = 180
     }
     if(cell.m_titleLbl.text=="PPN NETWORK")
     {
     cell.m_backgroundViewHeightConstraint.constant = 150
     }
     
     cell.m_policyInfoLbl1.isHidden=false
     cell.m_policyInfoLbl2.isHidden=true
     cell.m_policyInfoLbl3.isHidden=true
     cell.m_policyInfoLbl4.isHidden=true
     cell.termsConditionsLbl1.isHidden=false
     cell.termsConditionsLbl2.isHidden=true
     cell.termsConditionsLbl3.isHidden=true
     cell.termsConditionsLbl4.isHidden=true
     cell.m_backgroundViewHeightConstraint.constant = 130
     
     }
     else if(index==1)
     {
     //                cell.m_titleImageView.image=UIImage(named: "family")
     
     cell.m_term2BottomConstraint.constant=0
     cell.m_infoLbl3BottomConstraint.constant=0
     cell.m_term3BottomConstraint.constant=0
     cell.m_infoLbl4BottomConstraint.constant=0
     //                cell.m_term4BottomConstraint.constant=0
     
     cell.m_policyInfoLbl2.text=policyDict.policyInfo
     cell.termsConditionsLbl2.text=info
     cell.m_policyInfoLbl1.isHidden=false
     cell.m_policyInfoLbl2.isHidden=false
     cell.m_policyInfoLbl3.isHidden=true
     cell.m_policyInfoLbl4.isHidden=true
     cell.termsConditionsLbl1.isHidden=false
     cell.termsConditionsLbl2.isHidden=false
     cell.termsConditionsLbl3.isHidden=true
     cell.termsConditionsLbl4.isHidden=true
     cell.m_backgroundViewHeightConstraint.constant = 150
     if(cell.m_titleLbl.text=="FAMILY INFORMATION")
     {
     cell.m_backgroundViewHeightConstraint.constant = 230
     }
     if(cell.m_titleLbl.text=="POLICY INFORMATION")
     {
     cell.m_backgroundViewHeightConstraint.constant = 230
     }
     if(cell.m_titleLbl.text=="OPD BENEFITS")
     {
     cell.m_backgroundViewHeightConstraint.constant = 230
     }
     if(cell.m_titleLbl.text=="HOSPITAL EXPENSE")
     {
     cell.m_backgroundViewHeightConstraint.constant = 230
     }
     if(cell.m_titleLbl.text=="CO-PAYMENT")
     {
     cell.m_backgroundViewHeightConstraint.constant = 190
     }
     if(cell.m_titleLbl.text=="AILMENTWISE CAPPING")
     {
     cell.m_backgroundViewHeightConstraint.constant = 230
     }
     
     }
     else if(index==2)
     {
     //                 cell.m_titleImageView.image=UIImage(named: "CorporateInfo")
     
     cell.m_term2BottomConstraint.constant=0
     cell.m_infoLbl3BottomConstraint.constant=0
     cell.m_term3BottomConstraint.constant=0
     cell.m_infoLbl4BottomConstraint.constant=0
     //                cell.m_term4BottomConstraint.constant=0
     
     cell.m_policyInfoLbl3.text=policyDict.policyInfo
     cell.termsConditionsLbl3.text=info
     cell.m_policyInfoLbl1.isHidden=false
     cell.m_policyInfoLbl2.isHidden=false
     cell.m_policyInfoLbl3.isHidden=false
     cell.m_policyInfoLbl4.isHidden=true
     cell.termsConditionsLbl1.isHidden=false
     cell.termsConditionsLbl2.isHidden=false
     cell.termsConditionsLbl3.isHidden=false
     cell.termsConditionsLbl4.isHidden=true
     cell.m_backgroundViewHeightConstraint.constant = 180
     
     if(cell.m_titleLbl.text=="FAMILY INFORMATION")
     {
     cell.m_policyInfoLbl3.isHidden=true
     cell.termsConditionsLbl3.isHidden=true
     }
     if(cell.m_titleLbl.text=="POLICY AGE")
     {
     cell.m_backgroundViewHeightConstraint.constant = 250
     }
     if(cell.m_titleLbl.text=="ROOM RENT CAPPING")
     {
     cell.m_backgroundViewHeightConstraint.constant = 250
     }
     if(cell.m_titleLbl.text=="CLAIM INTIMATION")
     {
     cell.m_backgroundViewHeightConstraint.constant = 330
     }
     
     
     }
     else if(index==3)
     {
     //                cell.m_titleImageView.image=UIImage(named: "OPDBenefits")
     
     cell.m_term2BottomConstraint.constant=0
     cell.m_infoLbl3BottomConstraint.constant=0
     cell.m_term3BottomConstraint.constant=0
     cell.m_infoLbl4BottomConstraint.constant=0
     //                cell.m_term4BottomConstraint.constant=0
     
     cell.m_policyInfoLbl4.text=policyDict.policyInfo
     cell.termsConditionsLbl4.text=info
     cell.m_policyInfoLbl1.isHidden=false
     cell.m_policyInfoLbl2.isHidden=false
     cell.m_policyInfoLbl3.isHidden=false
     cell.m_policyInfoLbl4.isHidden=false
     cell.termsConditionsLbl1.isHidden=false
     cell.termsConditionsLbl2.isHidden=false
     cell.termsConditionsLbl3.isHidden=false
     cell.termsConditionsLbl4.isHidden=false
     cell.m_backgroundViewHeightConstraint.constant = 310
     if(cell.m_titleLbl.text=="MATERNITY BENEFITS")
     {
     cell.m_backgroundViewHeightConstraint.constant = 600
     }
     if(cell.m_titleLbl.text=="AILMENT COVERED")
     {
     cell.m_backgroundViewHeightConstraint.constant = 350
     }
     
     }
     }
     //
     
     }*/
    
    
    
    func downloadFileByPath(link:String)
    {
        if(isConnectedToNetWithAlert())
        {
            let fileName = link
            
            showPleaseWait(msg: """
    Please wait...
    Fetching details
    """)
            DispatchQueue.main.async
            {
                let url : NSString = fileName as NSString
                let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                
                if var searchURL : NSURL = NSURL(string: url as String)
                {
                    //                    let url : URL = URL(string:fileName as! String)
                    let request = URLRequest(url: searchURL as URL)
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    
                    let task = session.dataTask(with: request, completionHandler:
                                                    {(data, response, error) -> Void in
                        
                        
                        let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                        
                        
                        if var fileName = searchURL.lastPathComponent
                        {
                            if(self.m_productCode=="GMC")
                            {
                                fileName="GHI_Policy_Features"
                            }
                            else if(self.m_productCode=="GPA")
                            {
                                fileName="GPA_Policy_Features"
                            }
                            else
                            {
                                fileName="GTL_Policy_Features"
                            }
                            
                            let destinationUrl = documentsUrl.appendingPathComponent(fileName)?.appendingPathExtension("pdf")
                            let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")?.appendingPathExtension("pdf")
                            if let data = data
                            {
                                do
                                {
                                    try self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
                                    try data.write(to: destinationUrl!, options: .atomic)
                                }
                                catch
                                {
                                    print(error)
                                }
                            }
                            else
                            {
                                self.hidePleaseWait()
                                self.isConnectedToNetWithAlert()
                            }
                        }
                        self.hidePleaseWait()
                        
                    })
                    task.resume()
                    
                }
                else
                {
                    self.hidePleaseWait()
                    self.displayActivityAlert(title: "File not found")
                    
                }
            }
        }
        else
        {
            displayActivityAlert(title: "Not Connected to Internet!")
        }
        
        
    }
    
    func preloadData(toURL: NSURL) {
        print("=== Success and print toURL ===")
        print(toURL)
    }
    
    func downloadFile()
    {
        if(isConnectedToNetWithAlert())
        {
            let fileName = self.m_downloadPdfLink
            
            showPleaseWait(msg: """
Please wait...
Fetching details
""")
            DispatchQueue.main.async
            {
                let url : NSString = fileName as! NSString
                var urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                
                if var searchURL : NSURL = NSURL(string: urlStr as String)
                {
                    //                    let url : URL = URL(string:fileName as! String)
                    let request = URLRequest(url: searchURL as URL)
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    
                    let task = session.dataTask(with: request, completionHandler:
                                                    {(data, response, error) -> Void in
                        
                        
                        let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                        
                        
                        if var fileName = searchURL.lastPathComponent
                        {
                            if(self.m_productCode=="GMC")
                            {
                                fileName="GHI_Policy_Features"
                            }
                            else if(self.m_productCode=="GPA")
                            {
                                fileName="GPA_Policy_Features"
                            }
                            else
                            {
                                fileName="GTL_Policy_Features"
                            }
                            let destinationUrl = documentsUrl.appendingPathComponent(fileName)?.appendingPathExtension("pdf")
                            let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")?.appendingPathExtension("pdf")
                            if let data = data
                            {
                                do
                                {
                                    try self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
                                    try data.write(to: destinationUrl!, options: .atomic)
                                }
                                catch
                                {
                                    print(error)
                                }
                                
                                //                                    self.documentController = UIDocumentInteractionController(url: destinationUrl!)
                            }
                            else
                            {
                                self.hidePleaseWait()
                                self.isConnectedToNetWithAlert()
                            }
                        }
                        self.hidePleaseWait()
                        
                    })
                    task.resume()
                    
                }
                else
                {
                    self.hidePleaseWait()
                    self.displayActivityAlert(title: "File not found")
                    
                }
            }
        }
        else
        {
            displayActivityAlert(title: "Not Connected to Internet!")
        }
        
        /*  showPleaseWait()
         DispatchQueue.main.async
         {
         
         
         let url : URL = URL(string:self.m_downloadPdfLink)!
         let request = URLRequest(url: url )
         let session = URLSession(configuration: URLSessionConfiguration.default)
         
         let task = session.dataTask(with: request, completionHandler:
         {(data, response, error) -> Void in
         
         
         let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
         
         
         let fileName = url.lastPathComponent
         
         
         let destinationUrl = documentsUrl.appendingPathComponent(fileName)
         let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
         if let data = data
         {
         do
         {
         self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
         try data.write(to: destinationUrl!, options: .atomic)
         }
         catch
         {
         print(error)
         }
         
         self.documentController = UIDocumentInteractionController(url: destinationUrl!)
         }
         
         
         
         })
         task.resume()
         }
         //                    else
         //                    {
         //                        self.hidePleaseWait()
         //                        self.displayActivityAlert(title: "File not found")
         //
         //                    }
         */
        
        
        
    }
    func readDocument()
    {
        if let dict : NSDictionary = resultsDictArray![0] as? NSDictionary
        {
            
            if let fileName = dict.value(forKey: "FILE_NAME")
            {
                showPleaseWait(msg: "Please wait...")
                DispatchQueue.main.async
                {
                    
                    if let urlStr = NSURL(string:fileName as! String )
                    {
                        //                    let url : URL = URL(string:fileName as! String)
                        let request = URLRequest(url: urlStr as! URL)
                        let session = URLSession(configuration: URLSessionConfiguration.default)
                        
                        let task = session.dataTask(with: request, completionHandler:
                                                        {(data, response, error) -> Void in
                            
                            
                            let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                            
                            
                            if let fileName = urlStr.lastPathComponent
                            {
                                
                                let destinationUrl = documentsUrl.appendingPathComponent(fileName)
                                let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
                                if let data = data
                                {
                                    do
                                    {
                                        try self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
                                        try data.write(to: destinationUrl!, options: .atomic)
                                    }
                                    catch
                                    {
                                        print(error)
                                    }
                                    
                                    //                                        self.documentController = UIDocumentInteractionController(url: destinationUrl!)
                                }
                            }
                            
                            
                        })
                        task.resume()
                        
                    }
                    else
                    {
                        self.hidePleaseWait()
                        self.displayActivityAlert(title: "File not found")
                        
                    }
                }
            }
            else
            {
                displayActivityAlert(title: "File not found")
            }
            
            
        }
        
        
    }
    
    
    private func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    private func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
        
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        hidePleaseWait()
        
        return self
    }
    
    func openSelectedDocumentFromURL(documentURLString: String) throws {
        DispatchQueue.main.async(){
            //code
            
            if let documentURL: NSURL? = NSURL(fileURLWithPath: documentURLString)
            {
                UINavigationBar.appearance().barTintColor = self.hexStringToUIColor(hex: hightlightColor)
                UINavigationBar.appearance().tintColor = self.hexStringToUIColor(hex: hightlightColor)
                UINavigationBar.appearance().backgroundColor = self.hexStringToUIColor(hex: hightlightColor)
                UINavigationBar.appearance().titleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: FontsConstant.shared.app_FontPrimaryColor
                ]
                self.documentController = UIDocumentInteractionController(url: documentURL! as URL)
                self.documentController.delegate = self
                self.documentController.presentPreview(animated: true)
                
            }
            self.hidePleaseWait()
            
        }
    }
    func getPolicyAnnexures()
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
                    showPleaseWait(msg: "Please wait...")
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    
                    if let empNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String{//m_employeedict?.oe_group_base_Info_Sr_No {
                        oegrpbasinfsrno = String(empNo)
                    }
                    if let groupChlNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String{//m_employeedict?.groupChildSrNo {
                        groupchildsrno=String(groupChlNo)
                    }
                    
                    //                    groupchildsrno = String(userDict.groupChildSrNo)
                    //                    oegrpbasinfsrno = String(userDict.oe_group_base_Info_Sr_No)
                    
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getPolicyAnnexuresUrl(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno))
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?// NSURL(string: urlreq)
                    request.httpMethod = "GET"
                    
                    
                    
                    let task = URLSession.shared.dataTask(with: urlreq! as URL)
                    { (data, response, error) in
                        
                        if data == nil
                        {
                            
                            return
                        }
                        self.xmlKey = "PolicyAnnexures"
                        let parser = XMLParser(data: data!)
                        parser.delegate = self
                        parser.parse()
                        print(self.resultsDictArray)
                        DispatchQueue.main.async
                        {
                            let status = DatabaseManager.sharedInstance.deleteAnnexuresforTcl(productCode: self.m_productCode)
                            if(status)
                            {
                                print(self.resultsDictArray!)
                                for dict in self.resultsDictArray!
                                {
                                    DatabaseManager.sharedInstance.saveAnnexuresforTcl(contactDict: dict as NSDictionary, productCode: self.m_productCode)
                                }
                            }
                            self.m_policyAnnexuresArray =  DatabaseManager.sharedInstance.retrieveAnnexuresforTcl(productCode: self.m_productCode)
                            
                            print(self.m_policyAnnexuresArray.count)
                            
                            
                            //self.m_tableView.reloadData()
                            
                            self.createDataSource()
                            
                            self.hidePleaseWait()
                            if(self.m_policyAnnexuresArray.count==0)
                            {
                                //                                    self.displayActivityAlert(title: "No Data Found")
                                //                                    self.m_tableView.isHidden=true
                            }
                        }
                    }
                    task.resume()
                    
                }
                
            }
            else
            {
                //                displayActivityAlert(title: "There is no data available")
                resultsDictArray = []
                //m_tableView.reloadData()
                self.createDataSource()
                
            }
            
        }
        else
        {
            
            self.m_policyAnnexuresArray =  DatabaseManager.sharedInstance.retrieveAnnexuresforTcl(productCode: self.m_productCode)
            
            print(self.m_policyAnnexuresArray.count)
            
            
            self.m_tableView.reloadData()
            self.createDataSource()
            
            
        }
    }
   
    
    func getNewPolicyFeaturesPortal()  {
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
            
            print("getNewPolicyFeaturesPortal Userdefaults userGroupChildNo: ",userGroupChildNo," clickedOegrp: ",clickedOegrp," m_productCode:",m_productCode," clickedEmpSrNo: ",clickedEmpSrNo," employeeSrNoGMCValue: ",employeeSrNoGMCValue)
         
                if (!userGroupChildNo.isEmpty && !clickedOegrp.isEmpty)
                {
                    showPleaseWait(msg: "")
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    
                    if selectedIndexPosition == 0{
                        if let oegrp = clickedOegrp as? String
                        {
                            oegrpbasinfsrno = String(oegrp)
                            print("oegrpbasinfsrno : ",oegrpbasinfsrno)
                            oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                        }
                    }else{
                        oegrpbasinfsrno = selectedPolicyValue
                        print("oegrpbasinfsrno : ",oegrpbasinfsrno)
                        oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                    }
                    
                    if let groupChlNo = userGroupChildNo as? String
                    {
                        groupchildsrno=String(groupChlNo)
                        print("groupchildsrno : ",groupchildsrno)
                        groupchildsrno = try! AES256.encrypt(input: groupchildsrno, passphrase: m_passphrase_Portal)
                        
                    }
                    
                    print("m_productCode : ",m_productCode," : groupchildsrno: ",groupchildsrno," : oegrpbasinfsrno: ",oegrpbasinfsrno)
                    
                    
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getPolicyFeatresUrlPortal(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded,productId:m_productCode))
                    
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
                    // request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
                    authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                    print("authToken Policy Feature:",authToken)
                    
                    request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                    
                    
                    print("Policy Feature url: ",urlreq)
                    self.resultsDictArray?.removeAll()
                    
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
                            print("getNewPolicyFeaturesPortal() error:", error)
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
                                    self.noInternetDescLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                }else{
                                    self.m_errorImageview.image = UIImage(named: "PEPolicyNotFound")
                                    //self.noInternetHeaderLbl.text = error_State
                                    self.noInternetHeaderLbl.text="During_PostEnrollment_Header_PolicyFeatureErrorMsg".localized()
                                    self.noInternetDescLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
                                
                                }
                                self.m_tableView.isHidden=true
                                
                            }
                            return
                        }
                        else{
                            print("response123: ",response)
                            if let httpResponse = response as? HTTPURLResponse
                            {
                                print("getNewPolicyFeaturesPortal httpResponse.statusCode: ",httpResponse.statusCode)
                                
                                if httpResponse.statusCode == 200{
                                    do{
                                        guard let data = data else { return }
                                        DispatchQueue.main.async {
                                            self.m_noInternetView.isHidden=true
                                        }
                                        
                                        if let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] {
                                            
                                            self.resultsDictArray = json as? [[String : String]]
                                            
                                            
                                            // print("resultsDictArray : ",self.resultsDictArray)
                                            
                                            for item in json {
                                                if let object = item as? [String: Any] {
                                                    
                                                    // POL_FEAT_DISPLAY_TYPE
                                                    let POL_FEAT_DISPLAY_TYPE = object["POL_FEAT_DISPLAY_TYPE"] as? String ?? ""
                                                    print("POL_FEAT_DISPLAY_TYPE: \(POL_FEAT_DISPLAY_TYPE)")
                                                    
                                                    // POL_FEAT_TYPE
                                                    let POL_FEAT_TYPE = object["POL_FEAT_TYPE"] as? String ?? ""
                                                    print("POL_FEAT_TYPE: \(POL_FEAT_TYPE)")
                                                    
                                                    // POL_INFORMATION
                                                    let POL_INFORMATION = object["POL_INFORMATION"] as? String ?? ""
                                                    print("POL_INFORMATION: \(POL_INFORMATION)")
                                                    
                                                    // POL_TERMS_CONDITIONS
                                                    let POL_TERMS_CONDITIONS = object["POL_TERMS_CONDITIONS"] as? String ?? ""
                                                    print("POL_TERMS_CONDITIONS: \(POL_TERMS_CONDITIONS)")
                                                    
                                                    //POL_INFO_DISPLAY_TO
                                                    let POL_INFO_DISPLAY_TO = object["POL_INFO_DISPLAY_TO"] as? String ?? ""
                                                    print("POL_INFO_DISPLAY_TO: \(POL_INFO_DISPLAY_TO)")
                                                }
                                            }
                                        }
                                        
                                        
                                        DispatchQueue.main.async
                                        {
                                            let status = DatabaseManager.sharedInstance.deletePolicyFeatures(productCode: self.m_productCode)
                                            var data = self.resultsDictArray ?? nil
                                            
                                            if(status && data != nil)
                                            {
                                                print(self.resultsDictArray!)
                                                for dict in self.resultsDictArray!
                                                {
                                                    let policyDict = dict as? NSDictionary
                                                    if let policyFeatureType = policyDict?.value(forKey: "POL_FEAT_TYPE") as? String
                                                    {
                                                        if(policyFeatureType=="POLICY FEATURE LINK")
                                                        {
                                                            self.m_downloadPdfLink=policyDict?.value(forKey: "POL_TERMS_CONDITIONS") as! String
                                                        }
                                                        
                                                        print(policyFeatureType)
                                                        
                                                        if(policyFeatureType=="BASE POLICY INFORMATION" || policyFeatureType=="CORPORATE BUFFER")
                                                        {
                                                            
                                                        }
                                                        else if(policyFeatureType=="NOT AVAILABLE"){
                                                            
                                                        }
                                                        else
                                                        {
                                                            DatabaseManager.sharedInstance.saveNewPolicyFeatures(contactDict: dict as NSDictionary, productCode: self.m_productCode)
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                            self.m_policyFeatureArray =  DatabaseManager.sharedInstance.retrievePolicyFeatures(productCode: self.m_productCode)
                                            
                                            if(self.m_policyFeatureArray.count==0)
                                            {
                                                //self.displayActivityAlert(title: "No Data Found")
                                                //                                                self.noDataFoundImage.isHidden = false
                                                //                                                self.noDataFoundLbl.isHidden = false
                                                //                                                self.noDataFoundLbl.text = "No Data Found"
                                                //                                                self.m_tableView.isHidden=true
                                                
                                                self.m_noInternetView.isHidden=false
                                                self.m_tableView.isHidden=true
                                                if m_windowPeriodStatus{
                                                    self.m_errorImageview.image=UIImage(named: "duringEnrollDataNotFound")
                                                    self.noInternetHeaderLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                    self.noInternetDescLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                                }else{
                                                    self.m_errorImageview.image = UIImage(named: "PEPolicyNotFound")
                                                    //self.noInternetHeaderLbl.text = error_State
                                                    self.noInternetHeaderLbl.text="During_PostEnrollment_Header_PolicyFeatureErrorMsg".localized()
                                                    self.noInternetDescLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
                                                
                                                }
                                            }
                                            else{
                                                self.noDataFoundImage.isHidden = true
                                                self.m_noInternetView.isHidden=true
                                                self.noDataFoundLbl.isHidden = true
                                                self.m_tableView.isHidden=false
                                            }
                                            
                                            for array in self.m_policyFeatureArray
                                            {
                                                self.datasource.append(ExpandedPolicyDetailsCell(otherInfo:self.m_policyFeatureArray))
                                            }
                                            
                                            print("datasource : ",self.datasource)
                                            
                                            self.createDataSource()
                                            
                                            self.m_tableView.reloadData()
                                            
                                            self.hidePleaseWait()
                                            
                                        }
                                        
                                    }catch{
                                        Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                        print(error)
                                        self.hidePleaseWait()
                                    }
                                }
                                else if httpResponse.statusCode == 401{
                                    self.retryCountPolicyFeaturesPortal+=1
                                    print("retryCountPolicyFeaturesPortal: ",self.retryCountPolicyFeaturesPortal)
                                    
                                    if self.retryCountPolicyFeaturesPortal <= self.maxRetryPolicyFeaturesPortal{
                                        print("Some error occured getNewPolicyFeaturesPortal",httpResponse.statusCode)
                                        self.getUserTokenGlobal(completion: { (data,error) in
                                            self.getNewPolicyFeaturesPortal()
                                        })
                                    }
                                    else{
                                        print("retryCountPolicyFeaturesPortal 401 else : ",self.retryCountPolicyFeaturesPortal)
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
                                                self.noInternetDescLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                            }else{
                                                self.m_errorImageview.image = UIImage(named: "PEPolicyNotFound")
                                                //self.noInternetHeaderLbl.text = error_State
                                                self.noInternetHeaderLbl.text="During_PostEnrollment_Header_PolicyFeatureErrorMsg".localized()
                                                self.noInternetDescLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
                                            
                                            }
                                            self.m_tableView.isHidden=true
                                            
                                        }
                                    }
                                }
                                else if httpResponse.statusCode == 400{
                                    DispatchQueue.main.sync(execute: {
                                        self.retryCountPolicyFeaturesPortal+=1
                                        print("retryCountPolicyFeaturesPortal: ",self.retryCountPolicyFeaturesPortal)
                                        
                                        if self.retryCountPolicyFeaturesPortal <= self.maxRetryPolicyFeaturesPortal{
                                            print("Some error occured getNewPolicyFeaturesPortal",httpResponse.statusCode)
                                            self.getUserTokenGlobal(completion: { (data,error) in
                                                self.getNewPolicyFeaturesPortal()
                                            })
                                        }
                                        else{
                                            print("retryCountPolicyFeaturesPortal 400 else : ",self.retryCountPolicyFeaturesPortal)
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
                                                    self.noInternetDescLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                                }else{
                                                    self.m_errorImageview.image = UIImage(named: "PEPolicyNotFound")
                                                    //self.noInternetHeaderLbl.text = error_State
                                                    self.noInternetHeaderLbl.text="During_PostEnrollment_Header_PolicyFeatureErrorMsg".localized()
                                                    self.noInternetDescLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
                                                
                                                }
                                                self.m_tableView.isHidden=true
                                            }
                                        }
                                    })
                                }
                                else{
                                    
                                    DispatchQueue.main.async
                                    {
                                        self.hidePleaseWait()
                                        self.hidePleaseWait1()
                                        self.m_noInternetView.isHidden = false
                                        self.m_errorImageview.isHidden = false
                                        self.noInternetHeaderLbl.isHidden = false
                                        self.noInternetDescLbl.isHidden = false
                                        if m_windowPeriodStatus{
                                            self.m_errorImageview.image=UIImage(named: "duringEnrollDataNotFound")
                                            self.noInternetHeaderLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                            self.noInternetDescLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                        }else{
                                            self.m_errorImageview.image = UIImage(named: "PEPolicyNotFound")
                                            //self.noInternetHeaderLbl.text = error_State
                                            self.noInternetHeaderLbl.text="During_PostEnrollment_Header_PolicyFeatureErrorMsg".localized()
                                            self.noInternetDescLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
                                        
                                        }
                                        self.m_tableView.isHidden=true
                                        
                                    }
                                }
                            }
                            else{
                                print("httpResponse  data ")
                            }
                        }
                    }
                    task.resume()
                }
                else
                {
                    self.m_noInternetView.isHidden=false
                    self.m_tableView.isHidden=true
                    self.m_errorImageview.isHidden = false
                    self.noInternetHeaderLbl.isHidden = false
                    self.noInternetDescLbl.isHidden = false
                    if m_windowPeriodStatus{
                        self.m_errorImageview.image=UIImage(named: "duringEnrollDataNotFound")
                        self.noInternetHeaderLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                        self.noInternetDescLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                    }else{
                        self.m_errorImageview.image = UIImage(named: "PEPolicyNotFound")
                        //self.noInternetHeaderLbl.text = error_State
                        self.noInternetHeaderLbl.text="During_PostEnrollment_Header_PolicyFeatureErrorMsg".localized()
                        self.noInternetDescLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
                    
                    }
                    m_policyFeatureArray.removeAll()
                    m_downloadPdfLink=""
                    resultsDictArray = []
                    array1.removeAll()
                    isDataAvailable = false
                    self.m_tableView.isHidden=true
                    self.hidePleaseWait()
                    self.hidePleaseWait1()
                    m_tableView.reloadData()
                }
            
        }
        else{
            self.m_noInternetView.isHidden=false
            self.m_tableView.isHidden=true
            self.m_errorImageview.isHidden = false
            self.noInternetHeaderLbl.isHidden = false
            self.m_errorImageview.image=UIImage(named: "nointernet")
            self.noInternetHeaderLbl.text=error_NoInternet
            self.noInternetDescLbl.text=""
            m_policyFeatureArray.removeAll()
            m_downloadPdfLink=""
            resultsDictArray = []
            array1.removeAll()
            isDataAvailable = false
            self.m_tableView.isHidden=true
            self.hidePleaseWait()
            self.hidePleaseWait1()
            m_tableView.reloadData()
            
        }
        
    }
    
    //MARK:- GET IMAGE
    func getImage(policyName:String) -> UIImage {
        var image = UIImage()
        switch policyName {
        case "FAMILY INFORMATION":
            image = UIImage(named: "family") ?? UIImage()
        case "POLICY INFORMATION":
            image = UIImage(named: "policyInfo") ?? UIImage()
        case "CASHLESS FACILITY" :
            image = UIImage(named: "CashlessFacility") ?? UIImage()
        case "POLICY AGE" :
            image = UIImage(named: "policyage") ?? UIImage()
            
        case "AILMENT COVERED" :
            image = UIImage(named: "ailment") ?? UIImage()
            
        case "OPD BENEFITS" :
            image = UIImage(named: "OPDBenefits") ?? UIImage()
            
        case "MATERNITY BENEFITS" :
            image = UIImage(named: "maternity") ?? UIImage()
            
        case "ROOM RENT CAPPING" :
            image = UIImage(named: "RoomRent") ?? UIImage()
            
        case "PPN NETWORK" :
            image = UIImage(named: "ppn") ?? UIImage()
            
        case "HOSPITAL EXPENSE" :
            image = UIImage(named: "HosExp") ?? UIImage()
            
        case "CO-PAYMENT" :
            image = UIImage(named: "copayment") ?? UIImage()
        case "CLAIM INTIMATION" :
            image = UIImage(named: "IntimateClaim-1") ?? UIImage()
        case "AILMENTWISE CAPPING" :
            image = UIImage(named: "ailmentcaping") ?? UIImage()
        case "SPECIAL REMARKS" :
            image = UIImage(named: "SpecialRemark") ?? UIImage()
            
            
        default:
            image = UIImage(named: "policyInfo") ?? UIImage()
            
            break
        }
        
        return image
    }
    
    /*func getPolicyFeatures()
     {
     if(isConnectedToNet())
     {
     var employeeDetailsArray : Array<EMPLOYEE_INFORMATION> = []
     
     employeeDetailsArray = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
     
     
     if(employeeDetailsArray.count>0)
     {
     
     if let userDict:EMPLOYEE_INFORMATION = employeeDetailsArray[0]
     {
     showPleaseWait()
     var groupchildsrno = String()
     var oegrpbasinfsrno = String()
     
     groupchildsrno = String(userDict.groupChildSrNo)
     oegrpbasinfsrno = String(userDict.oe_group_base_Info_Sr_No)
     
     let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getPolicyFeatresUrl(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno,productId:m_productCode))
     let request : NSMutableURLRequest = NSMutableURLRequest()
     request.url = urlreq as URL?// NSURL(string: urlreq)
     request.httpMethod = "GET"
     
     
     
     let task = URLSession.shared.dataTask(with: urlreq! as URL)
     { (data, response, error) in
     
     if data == nil
     {
     
     return
     }
     self.xmlKey = "PolicyFeatures"
     let parser = XMLParser(data: data!)
     parser.delegate = self
     parser.parse()
     
     
     DispatchQueue.main.async
     {
     let status = DatabaseManager.sharedInstance.deletePolicyFeatures(productCode: self.m_productCode)
     if(status)
     {
     print(self.resultsDictArray!)
     for dict in self.resultsDictArray!
     {
     let policyDict = dict as? NSDictionary
     if let policyFeatureType = policyDict?.value(forKey: "POL_FEAT_TYPE") as? String
     {
     if(policyFeatureType=="POLICY FEATURE LINK")
     {
     self.m_downloadPdfLink=policyDict?.value(forKey: "POL_TERMS_CONDITIONS") as! String
     }
     if(policyFeatureType == self.m_policyFeatureType)
     {
     print(policyFeatureType)
     
     if(policyFeatureType=="BASE POLICY INFORMATION" || policyFeatureType=="CORPORATE BUFFER")
     {
     
     }
     else
     {
     
     DatabaseManager.sharedInstance.savePolicyFeatures(contactDict: dict as NSDictionary, productCode: self.m_productCode,policyIDType:self.m_policyID)
     
     }
     
     }
     else
     {
     
     if(self.m_policyID == -1)
     {
     if(policyFeatureType=="BASE POLICY INFORMATION" || policyFeatureType=="CORPORATE BUFFER")
     {
     
     }
     else
     {
     DatabaseManager.sharedInstance.savePolicyFeatures(contactDict: dict as NSDictionary, productCode: self.m_productCode,policyIDType:0)
     
     }
     }
     if(policyFeatureType=="BASE POLICY INFORMATION" || policyFeatureType=="CORPORATE BUFFER")
     {
     
     }
     else
     {
     self.m_policyID += 1
     }
     print(self.m_policyID)
     self.m_policyFeatureType = policyFeatureType
     }
     }
     
     
     //                                        DatabaseManager.sharedInstance.savePolicyFeatures(contactDict: dict as NSDictionary, productCode: self.m_productCode)
     }
     }
     self.m_policyFeatureArray =  DatabaseManager.sharedInstance.retrievePolicyFeatures(productCode: self.m_productCode)
     for dict in self.m_policyFeatureArray
     {
     self.array1.append(Int(dict.policyID))
     }
     print(self.m_policyFeatureArray.count,self.array1)
     if(self.m_policyFeatureArray.count==0)
     {
     self.displayActivityAlert(title: "No Data Found")
     self.m_tableView.isHidden=true
     }
     
     for array in self.m_policyFeatureArray
     {
     self.datasource.append(ExpandedPolicyDetailsCell(otherInfo:self.m_policyFeatureArray))
     }
     
     if(self.m_downloadPdfLink == "")
     {
     self.getPolicyAnnexures()
     }
     
     self.m_tableView.reloadData()
     
     self.hidePleaseWait()
     
     }
     }
     task.resume()
     
     }
     
     }
     else
     {
     displayActivityAlert(title: "noDataFound".localized())
     m_policyFeatureArray.removeAll()
     resultsDictArray = []
     array1.removeAll()
     isDataAvailable = false
     m_tableView.reloadData()
     
     }
     
     }
     else
     {
     
     
     
     m_noInternetView.isHidden=false
     self.m_policyFeatureArray =  DatabaseManager.sharedInstance.retrievePolicyFeatures(productCode: self.m_productCode)
     if(m_policyFeatureArray.count>0)
     {
     
     for dict in self.m_policyFeatureArray
     {
     self.array1.append(Int(dict.policyID))
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
    @objc override func backButtonClicked()
    {
        print ("backButtonClicked")
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func setData()
    {
        self.navigationItem.title="Policy Features"
        navigationController?.isNavigationBarHidden=false
        navigationItem.leftBarButtonItem=getBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        //    menuButton.backgroundColor = UIColor.white
        //    menuButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        //    menuButton.setImage(UIImage(named:"Home"), for: .normal)
        
        //setTopbarProducts()
        //getNewPolicyFeaturesPortal()
        
    }
    /*
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
     GPATabSelected()
     m_GMCTab.isUserInteractionEnabled=false
     m_GTLTab.isUserInteractionEnabled=false
     m_GPATab.isUserInteractionEnabled=false
     
     m_GMCTab.setTitleColor(UIColor.white, for: .normal)
     m_GTLTab.setTitleColor(UIColor.white, for: .normal)
     }
     else if(m_productCodeArray.contains("GTL"))
     {
     GTLTabSelected()
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
     GPATabSelected()
     
     }
     else
     {
     
     }
     }
     else
     {
     GMCTabSeleted()
     }
     }
     */
    func setTopbarProducts()
    {
        
        if(m_productCodeArray.count==1)
        {
            if(m_productCodeArray.contains("GMC"))
            {
                m_productCode = "GMC"
                GMCTabSeleted()
                
                m_GMCTab.isUserInteractionEnabled=false
                m_GPATab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=false
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
                m_GPATab.setTitleColor(UIColor.clear, for: .normal)
                
                m_GTLTab.setTitleColor(UIColor.clear, for: .normal)
            }
            else if(m_productCodeArray.contains("GPA"))
            {
                m_productCode = "GPA"
                GPATabSelected()
                m_GMCTab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=false
                m_GPATab.isUserInteractionEnabled=false
                m_GPATab.setTitleColor(UIColor.white, for: .normal)
                m_GMCTab.setTitleColor(UIColor.clear, for: .normal)
                m_GTLTab.setTitleColor(UIColor.clear, for: .normal)
            }
            else if(m_productCodeArray.contains("GTL"))
            {
                m_productCode = "GTL"
                GTLTabSelected()
                m_GPATab.isUserInteractionEnabled=false
                m_GMCTab.isUserInteractionEnabled=false
                m_GTLTab.isUserInteractionEnabled=false
                m_GTLTab.setTitleColor(UIColor.white, for: .normal)
                m_GPATab.setTitleColor(UIColor.clear, for: .normal)
                m_GMCTab.setTitleColor(UIColor.clear, for: .normal)
            }
            
            // self.heightTopTabs.constant = 0
            // self.m_topBar.isHidden = true
        }
        else if(m_productCodeArray.count==2)
        {
            
            if(m_productCodeArray.contains("GMC") && m_productCodeArray.contains("GPA"))
            {
                m_productCode = "GMC"
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
                m_productCode = "GMC"
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
                m_productCode = "GPA"
                m_GMCTab.isUserInteractionEnabled=false
                m_GPATab.isUserInteractionEnabled=true
                m_GTLTab.isUserInteractionEnabled=true
                m_GMCTab.isHidden=true
                m_GPATab.isHidden=false
                m_GTLTab.isHidden=false
                GPATabSelected()
                
            }
            else
            {
                
            }
        }
        else
        {
            m_productCode = "GMC"
            GMCTabSeleted()
        }
    }
    
    func getLeftBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:UIImage(named: "menu"), style: .plain, target: self, action: #selector(leftButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func leftButtonClicked()
    {
        //        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        //        appdelegate.drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
        //
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        //        tabBarController!.selectedIndex = 2
    }
    
    func GMCTabSeleted()
    {
        m_productCode="GMC"
        m_policyID = -1
        
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
            print("PolicyFeaturesViewController selectedIndexPosition GMC ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("PolicyFeaturesViewController selectedIndexPosition GMC ",selectedIndexPosition)
        }
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        //m_GMCShadowView.dropShadow()
        m_GTLShadowView.layer.masksToBounds=true
        m_GPAShadowView.layer.masksToBounds=true
        m_GMCTab.layer.masksToBounds=true
        m_GMCTab.layer.cornerRadius=cornerRadiusForView//m_GMCTab.frame.size.height/2
        //m_GMCTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GMCTab.layer.borderWidth=0
        m_GMCTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        //        GMCLine.backgroundColor=hexStringToUIColor(hex: "4B66EA")
        m_GMCTab.setTitleColor(UIColor.white, for: .normal)
        
        //        GPALine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        //        GTLLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GPATab.layer.borderColor=UIColor.white.cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        m_GTLTab.layer.borderColor=UIColor.white.cgColor
        m_GTLTab.setBackgroundImage(nil, for: .normal)
        
        m_descriptionTitleLbl.text="All you ever wanted to know about your Health Insurance Benefits"
        
        getNewPolicyFeaturesPortal()
        
        m_GPATab.layer.borderWidth = 2
        m_GTLTab.layer.borderWidth = 2
        
        m_GPATab.layer.cornerRadius = cornerRadiusForView//8
        m_GTLTab.layer.cornerRadius = cornerRadiusForView//8
        m_GMCShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        m_GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        m_GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GTLTab.setBackgroundImage(nil, for: .normal)
        //getPolicyAnnexures()
        //m_tableView.reloadData()
        
    }
    func GPATabSelected()
    {
        m_productCode = "GPA"
        m_policyID = -1
        
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
            print("PolicyFeaturesViewController selectedIndexPosition GPA ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("PolicyFeaturesViewController selectedIndexPosition GPA ",selectedIndexPosition)
        }
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        //m_GPAShadowView.dropShadow()
        m_GMCShadowView.layer.masksToBounds = true
        m_GTLShadowView.layer.masksToBounds=true
        
        m_GPATab.layer.masksToBounds=true
        m_GPATab.layer.cornerRadius=cornerRadiusForView//m_GPATab.frame.size.height/2
        //GPATab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GPATab.layer.borderWidth=0
        m_GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        m_GPATab.setTitleColor(UIColor.white, for: .normal)
        
        //        GPALine.backgroundColor=hexStringToUIColor(hex: "4B66EA")
        //        GMCLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        //        GTLLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        m_GTLTab.layer.borderColor=UIColor.white.cgColor
        m_GTLTab.setBackgroundImage(nil, for: .normal)
        
        m_policyAnnexuresArray.removeAll()
        
        m_descriptionTitleLbl.text="All you ever wanted to know about your Personal Accident Benefits"
        
        getNewPolicyFeaturesPortal()
        m_GMCTab.layer.borderWidth = 2
        m_GTLTab.layer.borderWidth = 2
        
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
        m_GTLTab.layer.cornerRadius = cornerRadiusForView//8
        m_GPAShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        m_GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GTLTab.setBackgroundImage(nil, for: .normal)
        
        //m_tableView.reloadData()
    }
    func GTLTabSelected()
    {
        m_productCode = "GTL"
        m_policyID = -1
        
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
            print("PolicyFeaturesViewController selectedIndexPosition GTL ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("PolicyFeaturesViewController selectedIndexPosition GTL ",selectedIndexPosition)
        }
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        //m_GTLShadowView.dropShadow()
        m_GPAShadowView.layer.masksToBounds=true
        m_GMCShadowView.layer.masksToBounds=true
        m_GTLTab.layer.masksToBounds=true
        m_GTLTab.layer.cornerRadius=cornerRadiusForView//m_GTLTab.frame.size.height/2
        //GTLTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GTLTab.layer.borderWidth=0
        m_GTLTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        m_GTLTab.setTitleColor(UIColor.white, for: .normal)
        
        //        GTLLine.backgroundColor=hexStringToUIColor(hex: "4B66EA")
        //        GMCLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        //        GPALine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        
        m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        m_GPATab.layer.borderColor=UIColor.white.cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        
        m_policyAnnexuresArray.removeAll()
        
        m_descriptionTitleLbl.text="All you ever wanted to know about your Term Life Benefits"
        
        getNewPolicyFeaturesPortal()
            m_GPATab.layer.borderWidth = 2
            m_GMCTab.layer.borderWidth = 2
            
            m_GPATab.layer.cornerRadius = cornerRadiusForView//8
            m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
            m_GTLShadowView.layer.cornerRadius = cornerRadiusForView//8
            
            m_GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
            m_GPATab.setBackgroundImage(nil, for: .normal)
            m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
            m_GMCTab.setBackgroundImage(nil, for: .normal)
        
        //m_tableView.reloadData()
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
            self.currentDictionary![elementName] = currentValue
            self.currentValue = ""
            
        }
        
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        
        
    }
    
    /*
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
     
     //        if(section==1)
     //        {
     //            return m_policyAnnexuresArray.count
     //        }
     //        else
     //        {
     
     
     //Comment by geeta
     //            if(m_downloadPdfLink != "")
     //            {
     //                return 1 //return 2
     //            }
     //            else {
     //                if self.policyModelArray[section].isExpanded {
     //                    return policyModelArray[section].polictDetailsArray.count + 1
     //                }
     //                else {
     //                    return 1
     //                }
     //            }
     //.......
     return 1
     
     
     
     //            if(m_downloadPdfLink != "")
     //            {
     //                return 1 //return 2
     //            }
     //            else if(policyModelArray.count>0)
     //            {
     //                return 14
     //            }
     //            else
     //            {
     //                return 0
     //            }
     
     
     /*if let arrayCount = array1.max()
      {
      if(arrayCount==0)
      {
      print(m_downloadPdfLink)
      if(m_downloadPdfLink != "")
      {
      return 1 //return 2
      }
      return 1
      }
      return arrayCount
      }*/
     // }
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     //        if policyModelArray[indexPath.section].isAnnexture {
     //            let cell : AnnexureTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AnnexureTableViewCell
     //            //let policyDict:PolicyAnnexure=m_policyAnnexuresArray[indexPath.row]
     //            customShadowPath(view: cell.m_titleView)
     //            //shadowForCell(view: cell.m_backgroundView)
     //
     //            cell.m_titleLbl.text = policyModelArray[indexPath.section].featureType ?? ""
     //            cell.m_nameLbl.text = policyModelArray[indexPath.section].annextureDesc ?? ""
     //            cell.m_viewAnnexureButton.layer.masksToBounds=true
     //            cell.m_viewAnnexureButton.layer.cornerRadius=cell.m_viewAnnexureButton.frame.size.height/2
     //            cell.m_viewAnnexureButton.setImage(UIImage(named: ""), for: .normal)
     //            cell.m_viewAnnexureButton.setBackgroundImage(UIImage(named: ""), for: .normal)
     //            cell.m_viewAnnexureButton.backgroundColor=hexStringToUIColor(hex: "e7be2a")
     //            cell.m_viewAnnexureButton.tag=indexPath.section
     //            cell.m_viewAnnexureButton.addTarget(self, action: #selector(viewAnnexureButtonClicked), for: .touchUpInside)
     //
     //            cell.selectionStyle=UITableViewCellSelectionStyle.none
     //            return cell
     //
     //        }
     //        else {
     
     //        if indexPath.row == 0 {
     //            if(self.policyModelArray[indexPath.section].isDownloadableFeature)
     //            {
     //                let cell : PolicyFeatureHeaderCell = tableView.dequeueReusableCell(withIdentifier: "PolicyFeatureHeaderCell", for: indexPath) as! PolicyFeatureHeaderCell
     //
     //                cell.lblTitle.text = "Download Policy Features"
     //                cell.m_titleImage?.image=UIImage(named: "pdf-1")
     //                cell.m_expandButton.setImage(UIImage(named: "download"), for: .normal)
     //                cell.m_expandButtonHeightConstraint.constant=20
     //                return cell
     //            }
     //            else {
     //                let cell : PolicyFeatureHeaderCell = tableView.dequeueReusableCell(withIdentifier: "PolicyFeatureHeaderCell", for: indexPath) as! PolicyFeatureHeaderCell
     //                cell.lblTitle.text = policyModelArray[indexPath.section].featureType ?? ""
     //                cell.m_titleImage.image=UIImage(named: "family")
     //                cell.m_expandButton.setImage(UIImage(named: "arrow"), for: .normal)
     //                cell.m_titleImage.image = getImage(policyName:policyModelArray[indexPath.section].featureType ?? "")
     //                return cell
     //            }
     //        }
     //        else {
     //            let cell : PolicyDetailsCell = tableView.dequeueReusableCell(withIdentifier: "PolicyDetailsCell", for: indexPath) as! PolicyDetailsCell
     //            cell.lblTitle.text = policyModelArray[indexPath.section].polictDetailsArray[indexPath.row - 1].title ?? ""
     //            cell.lblDetails.text = policyModelArray[indexPath.section].polictDetailsArray[indexPath.row - 1].details ?? ""
     //            return cell
     //
     //            }
     //}
     
     
     let cell : PolicyFeatureHeaderCell = tableView.dequeueReusableCell(withIdentifier: "PolicyFeatureHeaderCell", for: indexPath) as! PolicyFeatureHeaderCell
     
     cell.m_titleImage.image=UIImage(named: "pdf-1")
     
     var m_employeeDict : EMPLOYEE_INFORMATION?
     var groupChildSrNo = String()
     let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
     if(userArray.count>0){
     m_employeeDict=userArray[0]
     }
     if(userArray.count>0){
     if let groupChlNo = m_employeeDict?.groupChildSrNo{
     groupChildSrNo=String(groupChlNo)
     print("groupChildSrNo : \(groupChildSrNo)")
     }
     }
     if m_productCode == "GPA" {
     cell.lblTitle.text  = "Group Accident Policy"
     }else if m_productCode == "GMC"{
     cell.lblTitle.text  = "Group Health Insurance Policy"
     }else if m_productCode == "GTL" {
     cell.lblTitle.text  = "Group Term Life Policy"
     }
     
     
     //cell.m_expandButton.setImage(UIImage(named: "arrow"), for: .normal)
     //cell.m_titleImage.image = getImage(policyName:policyModelArray[indexPath.section].featureType ?? "")
     return cell
     
     }
     
     
     
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
     if section != 0 {
     
     return 10
     }
     return 0
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
     
     //        if policyModelArray[indexPath.section].isDownloadableFeature {
     //            if let path = policyModelArray[indexPath.section].polictDetailsArray[0].details as? String {
     //                if path != "" {
     //                    downloadFileByPath(link: path)
     //                }
     //            }
     //        }
     //        else {
     //            if policyModelArray[indexPath.section].isAnnexture == false{
     //                if indexPath.section < self.policyModelArray.count {
     //                    if self.policyModelArray[indexPath.section].isExpanded == false {
     //                       self.policyModelArray[indexPath.section].isExpanded = true
     //                    }
     //                    else {
     //                        self.policyModelArray[indexPath.section].isExpanded = false
     //                    }
     //                }
     //                self.m_tableView.reloadData()
     //            }
     //        }
     
     var m_employeeDict : EMPLOYEE_INFORMATION?
     var groupChildSrNo = String()
     var oegrpbseSrNo = String()
     let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
     if(userArray.count>0){
     m_employeeDict=userArray[0]
     }
     if(userArray.count>0){
     if let groupChlNo = m_employeeDict?.groupChildSrNo{
     groupChildSrNo=String(groupChlNo)
     print("groupChildSrNo : \(groupChildSrNo)")
     }
     if let oeGroupBase = m_employeeDict?.oe_group_base_Info_Sr_No{
     oegrpbseSrNo=String(oeGroupBase)
     print("oegrpbseSrNo : \(oegrpbseSrNo)")
     }
     }
     
     
     if groupChildSrNo == "1225" { //For STT
     
     switch oegrpbseSrNo {
     case "686":
     downloadFileByPath(link: "https://core.mybenefits360.com/images/documents/STTGDCIGroupPersonalAccidentInsurancePolicy21-22.pdf")
     break
     
     case "685":
     downloadFileByPath(link: "https://core.mybenefits360.com/images/documents/STTGDCIGroupMediclaimInsurancePolicy21-22.pdf")
     break
     
     case "687":
     downloadFileByPath(link: "https://core.mybenefits360.com/images/documents/STTGDCIGroupTermLifeInsurancePolicy21-22.pdf")
     break
     
     default:
     break
     }
     
     } else if groupChildSrNo == "1221"{ // tcl
     
     switch oegrpbseSrNo {
     case "683":
     downloadFileByPath(link: "https://core.mybenefits360.com/images/documents/Group_Accident_Policy.pdf")
     break
     
     case "682":
     downloadFileByPath(link: "https://core.mybenefits360.com/images/documents/Group_Health_Insurance_Policy.pdf")
     break
     
     case "684":
     downloadFileByPath(link: "https://core.mybenefits360.com/images/documents/Group_Term_Life_Policy.pdf")
     break
     
     default:
     break
     }
     
     }
     
     /*
      TCL ->
      GROUPCHILDSRNO = 1221
      OE_GRP_BAS_INF_SR_NO = 682 (GHI)
      OE_GRP_BAS_INF_SR_NO = 683 (GPA)
      OE_GRP_BAS_INF_SR_NO = 684 (GTL)
      
      STT
      GROUPCHILDSRNO = 1225
      OE_GRP_BAS_INF_SR_NO = 685 (GHI)
      OE_GRP_BAS_INF_SR_NO = 686 (GPA)
      OE_GRP_BAS_INF_SR_NO = 687 (GTL)
      */
     
     
     /*
      TCL --
      1)  GMC - https://core.mybenefits360.com/images/documents/Group_Health_Insurance_Policy.pdf
      2)  GPA - https://core.mybenefits360.com/images/documents/Group_Accident_Policy.pdf
      3)  GTL - https://core.mybenefits360.com/images/documents/Group_Term_Life_Policy.pdf
      
      
      STGL --
      
      1)  GMC - https://core.mybenefits360.com/images/documents/STTGDCIGroupMediclaimInsurancePolicy21-22.pdf
      2)  GPA - https://core.mybenefits360.com/images/documents/STTGDCIGroupPersonalAccidentInsurancePolicy21-22.pdf
      3)  GTL - https://core.mybenefits360.com/images/documents/STTGDCIGroupTermLifeInsurancePolicy21-22.pdf
      */
     
     
     /*
      if(indexPath.section==1)
      {
      if let dict : PolicyAnnexure = m_policyAnnexuresArray[indexPath.row]
      {
      
      
      if let fileName = dict.annexurePath
      {
      showPleaseWait(msg: """
      Please wait...
      Fetching details
      """)
      DispatchQueue.main.async
      {
      let url : NSString = fileName as NSString
      var urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
      
      if var searchURL : NSURL = NSURL(string: urlStr as String)
      {
      //                    let url : URL = URL(string:fileName as! String)
      let request = URLRequest(url: searchURL as URL)
      let session = URLSession(configuration: URLSessionConfiguration.default)
      
      let task = session.dataTask(with: request, completionHandler:
      {(data, response, error) -> Void in
      
      
      let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
      
      
      if var fileName = searchURL.lastPathComponent
      {
      
      
      let destinationUrl = documentsUrl.appendingPathComponent(fileName)
      let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
      if let data = data
      {
      do
      {
      try self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
      try data.write(to: destinationUrl!, options: .atomic)
      }
      catch
      {
      Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
      print(error)
      }
      
      //                                            self.documentController = UIDocumentInteractionController(url: destinationUrl!)
      }
      else
      {
      self.hidePleaseWait()
      self.displayActivityAlert(title: m_errorMsg)
      
      }
      }
      
      
      })
      task.resume()
      
      }
      else
      {
      self.hidePleaseWait()
      self.displayActivityAlert(title: m_errorMsg)
      
      }
      }
      }
      else
      {
      hidePleaseWait()
      displayActivityAlert(title: m_errorMsg)
      }
      
      
      }
      
      
      }
      else
      {
      if(m_downloadPdfLink != "" && indexPath.row==0)
      {
      downloadFile()
      }
      else if (datasource.count>indexPath.row)
      {
      let content = datasource[indexPath.row]
      content.expanded = !content.expanded
      let cell : PolicyFeaturesTableViewCell = m_tableView.cellForRow(at: indexPath) as! PolicyFeaturesTableViewCell
      
      cell.setContentForPolocyFeatures(data: content)
      
      if(content.expanded==true)
      {
      cell.m_expandButton.setImage(UIImage(named: "arrow"), for: .normal)
      }
      else
      {
      cell.m_expandButton.setImage(UIImage(named: "arrow_Reverse"), for: .normal)
      }
      
      //                tableView.reloadData()
      
      tableView.reloadRows(at: [indexPath], with: .automatic)
      }
      
      m_tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
      
      }
      */
     }
     
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
     {
     
     if let postCell = cell as? PolicyFeaturesTableViewCell
     {
     //            self.tableView(tableView: m_tableView, willDisplayMyCell: postCell, forRowAtIndexPath: indexPath as NSIndexPath)
     }
     
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
     {
     //        if(datasource.count>indexPath.row && indexPath.section==0)
     //        {
     //            if(datasource[indexPath.row].expanded)
     //            {
     //
     //                return UITableViewAutomaticDimension
     //            }
     //            else
     //            {
     //                return 75
     //            }
     //        }
     //        else if(indexPath.section==1)
     //        {
     //            return UITableViewAutomaticDimension
     //        }
     //        return 75
     
     //        if policyModelArray[indexPath.section].isAnnexture {
     //            return UITableViewAutomaticDimension
     //        }
     //        else {
     //            if policyModelArray[indexPath.section].isDownloadableFeature {
     //                return 60
     //            }
     //            else {
     //
     //                if indexPath.row == 0 {
     //                    return 50
     //                }
     //                else {
     //                    return UITableViewAutomaticDimension
     //                }
     //            }
     //        }
     
     return 50
     }
     func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
     return UITableViewAutomaticDimension
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
     // return self.policyModelArray.count
     return 1
     }
     
     
     */
    
    
    //Added from AIB project
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.policyModelArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        //        if(section==1)
        //        {
        //            return m_policyAnnexuresArray.count
        //        }
        //        else
        //        {
        
        if(m_downloadPdfLink != "")
        {
            return 1 //return 2
        }
        else {
            if self.policyModelArray[section].isExpanded {
                return policyModelArray[section].polictDetailsArray.count + 1
            }
            else {
                return 1
            }
        }
        
        //            if(m_downloadPdfLink != "")
        //            {
        //                return 1 //return 2
        //            }
        //            else if(policyModelArray.count>0)
        //            {
        //                return 14
        //            }
        //            else
        //            {
        //                return 0
        //            }
        
        
        /*if let arrayCount = array1.max()
         {
         if(arrayCount==0)
         {
         print(m_downloadPdfLink)
         if(m_downloadPdfLink != "")
         {
         return 1 //return 2
         }
         return 1
         }
         return arrayCount
         }*/
        // }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if policyModelArray[indexPath.section].isAnnexture {
            let cell : AnnexureTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AnnexureTableViewCell
            //let policyDict:PolicyAnnexure=m_policyAnnexuresArray[indexPath.row]
            customShadowPath(view: cell.m_titleView)
            //shadowForCell(view: cell.m_backgroundView)
            
            cell.m_titleLbl.text = policyModelArray[indexPath.section].featureType ?? ""
            cell.m_nameLbl.text = policyModelArray[indexPath.section].annextureDesc ?? ""
            cell.m_viewAnnexureButton.layer.masksToBounds=true
            cell.m_viewAnnexureButton.layer.cornerRadius=cell.m_viewAnnexureButton.frame.size.height/2
            cell.m_viewAnnexureButton.setImage(UIImage(named: ""), for: .normal)
            cell.m_viewAnnexureButton.setBackgroundImage(UIImage(named: ""), for: .normal)
            cell.m_viewAnnexureButton.backgroundColor=hexStringToUIColor(hex: "e7be2a")
            cell.m_viewAnnexureButton.tag=indexPath.section
            cell.m_viewAnnexureButton.addTarget(self, action: #selector(viewAnnexureButtonClicked), for: .touchUpInside)
            
            
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            return cell
            
        }
        else {
            
            if indexPath.row == 0 {
                if(self.policyModelArray[indexPath.section].isDownloadableFeature)
                {
                    let cell : PolicyFeatureHeaderCell = tableView.dequeueReusableCell(withIdentifier: "PolicyFeatureHeaderCell", for: indexPath) as! PolicyFeatureHeaderCell
                    cell.imgRibbon.isHidden = true
                    cell.m_titleImage.isHidden = false
                    cell.indexNumber.isHidden = true
                    cell.lblTitle.text = "Download Policy Features"
                    cell.m_titleImage?.image=UIImage(named: "pdf-1")
                    cell.m_expandButton.setImage(UIImage(named: "download"), for: .normal)
                    cell.m_expandButtonHeightConstraint.constant=20
                    return cell
                }
                else {
                    let cell : PolicyFeatureHeaderCell = tableView.dequeueReusableCell(withIdentifier: "PolicyFeatureHeaderCell", for: indexPath) as! PolicyFeatureHeaderCell
                    cell.lblTitle.text = policyModelArray[indexPath.section].featureType ?? ""
                    cell.m_titleImage.image=UIImage(named: "family")
                    cell.indexNumber.text = (indexPath.section + 1).description
                    cell.imgRibbon.isHidden = false
                    cell.m_titleImage.isHidden = true
                    cell.indexNumber.isHidden = false
                    if self.policyModelArray[indexPath.section].isExpanded == true{
                        cell.m_expandButton.setImage(UIImage(named: "arrow_Reverse"), for: .normal)
                    }
                    else{
                        cell.m_expandButton.setImage(UIImage(named: "arrow"), for: .normal)
                    }
                    cell.m_titleImage.image = getImage(policyName:policyModelArray[indexPath.section].featureType ?? "")
                    return cell
                }
            }
            else {
                let cell : PolicyDetailsCell = tableView.dequeueReusableCell(withIdentifier: "PolicyDetailsCell", for: indexPath) as! PolicyDetailsCell
                
                
                cell.lblTitle.text = policyModelArray[indexPath.section].polictDetailsArray[indexPath.row - 1].title ?? ""
                
                cell.lblDetails.text = policyModelArray[indexPath.section].polictDetailsArray[indexPath.row - 1].details ?? ""
                
                if let details = policyModelArray[indexPath.section].polictDetailsArray[indexPath.row - 1].details {
                    var detailsStr = details.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    detailsStr = detailsStr.replacingOccurrences(of: "\\\\n", with: "")
                    detailsStr = detailsStr.replacingOccurrences(of: "\\\n", with: "")
                    detailsStr = detailsStr.replacingOccurrences(of: "\\n", with: "")
                    detailsStr = detailsStr.replacingOccurrences(of: "\n", with: "")
                    detailsStr = detailsStr.replacingOccurrences(of: "&nbsp;", with: "")
                    detailsStr = detailsStr.replacingOccurrences(of: "&nbsp", with: "")
                    detailsStr = detailsStr.replacingOccurrences(of: "\r\n  ", with: " ")
                    detailsStr = detailsStr.replacingOccurrences(of: "\r\n", with: " ")
                    detailsStr = detailsStr.replacingOccurrences(of: "&amp;", with: " ")
                    detailsStr = detailsStr.replacingOccurrences(of: "\r\n", with: " ")
                    
                    cell.lblDetails.text = detailsStr.trimmingCharacters(in: .whitespaces)
                }
                
                
                
                return cell
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 0 {
            
            return 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if policyModelArray[indexPath.section].isDownloadableFeature {
            if let path = policyModelArray[indexPath.section].polictDetailsArray[0].details as? String {
                if path != "" {
                    downloadFileByPath(link: path)
                }
            }
        }
        else {
            if policyModelArray[indexPath.section].isAnnexture == false{
                if indexPath.section < self.policyModelArray.count {
                    if self.policyModelArray[indexPath.section].isExpanded == false {
                        self.policyModelArray[indexPath.section].isExpanded = true
                    }
                    else {
                        self.policyModelArray[indexPath.section].isExpanded = false
                    }
                }
                self.m_tableView.reloadData()
            }
            //tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        /*
         if(indexPath.section==1)
         {
         if let dict : PolicyAnnexure = m_policyAnnexuresArray[indexPath.row]
         {
         
         
         if let fileName = dict.annexurePath
         {
         showPleaseWait(msg: """
         Please wait...
         Fetching details
         """)
         DispatchQueue.main.async
         {
         let url : NSString = fileName as NSString
         var urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
         
         if var searchURL : NSURL = NSURL(string: urlStr as String)
         {
         //                    let url : URL = URL(string:fileName as! String)
         let request = URLRequest(url: searchURL as URL)
         let session = URLSession(configuration: URLSessionConfiguration.default)
         
         let task = session.dataTask(with: request, completionHandler:
         {(data, response, error) -> Void in
         
         
         let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
         
         
         if var fileName = searchURL.lastPathComponent
         {
         
         
         let destinationUrl = documentsUrl.appendingPathComponent(fileName)
         let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
         if let data = data
         {
         do
         {
         try self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
         try data.write(to: destinationUrl!, options: .atomic)
         }
         catch
         {
         Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
         print(error)
         }
         
         //                                            self.documentController = UIDocumentInteractionController(url: destinationUrl!)
         }
         else
         {
         self.hidePleaseWait()
         self.displayActivityAlert(title: m_errorMsg)
         
         }
         }
         
         
         })
         task.resume()
         
         }
         else
         {
         self.hidePleaseWait()
         self.displayActivityAlert(title: m_errorMsg)
         
         }
         }
         }
         else
         {
         hidePleaseWait()
         displayActivityAlert(title: m_errorMsg)
         }
         
         
         }
         
         
         }
         else
         {
         if(m_downloadPdfLink != "" && indexPath.row==0)
         {
         downloadFile()
         }
         else if (datasource.count>indexPath.row)
         {
         let content = datasource[indexPath.row]
         content.expanded = !content.expanded
         let cell : PolicyFeaturesTableViewCell = m_tableView.cellForRow(at: indexPath) as! PolicyFeaturesTableViewCell
         
         cell.setContentForPolocyFeatures(data: content)
         
         if(content.expanded==true)
         {
         cell.m_expandButton.setImage(UIImage(named: "arrow"), for: .normal)
         }
         else
         {
         cell.m_expandButton.setImage(UIImage(named: "arrow_Reverse"), for: .normal)
         }
         
         //                tableView.reloadData()
         
         tableView.reloadRows(at: [indexPath], with: .automatic)
         }
         
         m_tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
         
         }
         */
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if let postCell = cell as? PolicyFeaturesTableViewCell
        {
            //            self.tableView(tableView: m_tableView, willDisplayMyCell: postCell, forRowAtIndexPath: indexPath as NSIndexPath)
        }
        
    }
    private func tableView(tableView: UITableView, willDisplayMyCell myCell: PolicyFeaturesTableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        TipInCellAnimator.animate(cell: myCell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //        if(datasource.count>indexPath.row && indexPath.section==0)
        //        {
        //            if(datasource[indexPath.row].expanded)
        //            {
        //
        //                return UITableViewAutomaticDimension
        //            }
        //            else
        //            {
        //                return 75
        //            }
        //        }
        //        else if(indexPath.section==1)
        //        {
        //            return UITableViewAutomaticDimension
        //        }
        //        return 75
        
        if policyModelArray[indexPath.section].isAnnexture {
            return UITableViewAutomaticDimension
        }
        else {
            if policyModelArray[indexPath.section].isDownloadableFeature {
                return 60
            }
            else {
                
                if indexPath.row == 0 {
                    return 50
                }
                else {
                    return UITableViewAutomaticDimension
                }
            }
        }
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setupFontUI(){
        
        m_descriptionTitleLbl.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h15))
        m_descriptionTitleLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
       
        m_GMCTab.titleLabel?.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h17))
        m_GMCTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_GPATab.titleLabel?.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h17))
        m_GPATab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_GTLTab.titleLabel?.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.h17))
        m_GTLTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        
        policyNamelbl.font = UIFont(name: FontsConstant.shared.semiBold, size: CGFloat(FontsConstant.shared.h14))
        policyNamelbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        policyButtonLbl.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h17))
        policyButtonLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        noDataFoundLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h20))
        noDataFoundLbl.textColor = FontsConstant.shared.app_FontLightGreyColor
        
        
        noInternetHeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        noInternetHeaderLbl.textColor = FontsConstant.shared.app_errorTitleColor
        
        noInternetDescLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        noInternetDescLbl.textColor = FontsConstant.shared.app_errorTitleColor
          
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
            print("PolicyFeaturesViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("PolicyFeaturesViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        
        getNewPolicyFeaturesPortal()
    }
    
    
}
