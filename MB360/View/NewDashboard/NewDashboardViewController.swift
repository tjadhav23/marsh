//
//  NewDashboardViewController.swift
//  MyBenefits
//
//  Created by Semantic on 14/01/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import FirebaseCrashlytics
import CoreLocation
import AVKit
import AVFoundation
import UserNotifications
import SlideMenuControllerSwift
import IOSSecuritySuite
import TrustKit
import AesEverywhere
import Foundation

//var isRemoveFlag = 0

class modelMainArray {
    let modelName : String
    var modelDetails : String
    let modelImg : String
    
    init(modelName : String, modelDetails: String, modelImg: String) {
        self.modelName = modelName
        self.modelDetails = modelDetails
        self.modelImg = modelImg
    }
}

class NewDashboardViewController: UIViewController,UITabBarDelegate,UITabBarControllerDelegate,UIDocumentInteractionControllerDelegate,NewPoicySelectedDelegate,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate{
    
    @IBOutlet weak var m_claimsIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var m_enrollmentDetailLoader: UIActivityIndicatorView!
    @IBOutlet weak var m_hospitalActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var overLappingView: UIView!
    @IBOutlet weak var m_enrollmentView: UIView!
    
    @IBOutlet weak var enrollmentWindowHeaderLbl: UILabel!
    @IBOutlet weak var m_enrollmentStatusImgview: UIImageView!
    @IBOutlet weak var m_enrollmentStatusLbl: UILabel!
    @IBOutlet weak var enrollMentImageView: UIImageView!
    @IBOutlet weak var m_daysLeftTitleLbl: UILabel!
    @IBOutlet weak var m_familyDefinationLbl: UILabel!
    @IBOutlet weak var m_view4: UIView!
    @IBOutlet weak var m_view3: UIView!
    @IBOutlet weak var m_view2: UIView!
    @IBOutlet weak var m_view1: UIView!
    @IBOutlet weak var m_nameLbl: UILabel!
    @IBOutlet weak var m_scrollView: UIScrollView!
    
    @IBOutlet weak var m_view5: UIView!
    @IBOutlet weak var m_view6: UIView!
    @IBOutlet weak var m_view7: UIView!
    @IBOutlet weak var m_view8: UIView!
    
    
    @IBOutlet weak var m_myCoveragesView: UIView!
    
    @IBOutlet weak var m_MyHospitalsView: UIView!
    
    @IBOutlet weak var m_cliamProcedureNameLbl: UILabel!
    
    @IBOutlet weak var m_queriesView: UIView!
    @IBOutlet weak var m_claimProcedureView: UIView!
    
    @IBOutlet weak var m_mycliamsView: UIView!
    @IBOutlet weak var m_intimateClaimsView: UIView!
    @IBOutlet weak var m_policyFeaturesView: UIView!
    @IBOutlet weak var m_faqView: UIView!
    
    
    @IBOutlet weak var m_daysLbl: UILabel!
    @IBOutlet weak var m_windowPeriodStatusLbl: UILabel!
    @IBOutlet weak var m_claimCountLbl: UILabel!
    
    
    @IBOutlet weak var m_queryActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var m_queryCountLbl: UILabel!
    @IBOutlet weak var m_hospitalsCountLbl: UILabel!
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    
    //To Hide Enrollment View
    @IBOutlet weak var enrollmentCardSuperView: UIView!
    @IBOutlet weak var heightOfEnrollmentCardSuperView: NSLayoutConstraint!
    @IBOutlet weak var topView: UILabel!
    @IBOutlet weak var dividerView: UILabel!
    
    //TOPUP BAR
    
    @IBOutlet weak var PolicylblView: UIView!
    @IBOutlet weak var policyNamelbl: UILabel!
    
    @IBOutlet weak var m_topBarView: UIView!
    @IBOutlet weak var m_stackView: UIStackView!

    @IBOutlet weak var m_shadowView: UIView!
    @IBOutlet weak var m_GMCTab: UIButton!
    
    @IBOutlet weak var GPAShadowView: UIView!
    @IBOutlet weak var GPATab: UIButton!
    
    @IBOutlet weak var GTLShadowView: UIView!
    @IBOutlet weak var GTLTab: UIButton!
    
    @IBOutlet weak var GMCLine: UILabel!
    @IBOutlet weak var GPALine: UILabel!
    @IBOutlet weak var GTLLine: UILabel!
    
    @IBOutlet weak var termsVew: UIView!
    
    @IBOutlet weak var innerTermsVew: UIView!
    
    @IBOutlet weak var header_UA: UILabel!
    @IBOutlet weak var content1_UA: UILabel!
    @IBOutlet weak var content2_UA: UILabel!
    
    @IBOutlet weak var btnChk: UIButton!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var moduleViewCollection: UIView!
    @IBOutlet weak var moduleCollectionView: UICollectionView!
    
    var policyDataArray = [OE_GROUP_BASIC_INFORMATION]()
    var empolyeeDetailArray: [[String : Any]]?
    var relationDataArray = [String]()
    
    var selectedPolicyStatus = 0
    var errorState = 0
    var clickedOegrp = ""
    var clickedEmpSrNo = ""
    
    //END TOP UP BAR

    
    var claimDetailsArray=Array<MyClaimsDetails>()
    var m_employeedict : EMPLOYEE_INFORMATION?
    var m_employeeDict : EMPLOYEE_INFORMATION?
    var m_addressString = String()
    
    var dependantsDictArray: [[String: String]]?
    var latitude: Double!
    var longitude: Double!
    
    var locationManager: CLLocationManager!
    var m_enrollmentStatus = Bool()
    var servicesArray = ["Insurance"]
    
    
    
    var claimCount = 0
    var hospCount = "0"
    var maxRetryLoadsession = 1
    var maxRetryAdmin = 1
    var maxRetryCoverage = 1
    var maxRetryClaims = 1
    var maxRetryHospital = 1
    var maxretryCountEnrollStatus = 1
    var retryCountLoadsession = 0
    var retryCountAdmin = 0
    var retryCountCoverages = 0
    var retryCountClaims = 0
    var retryCountHospital = 0
    var retryCountEnrollStatus = 0
    
    var apiRequestLoadSession: URLSessionDataTask?
    var apiRequestAdminSetting: URLSessionDataTask?
    var apiRequestCoveragesData: URLSessionDataTask?
    var apiRequestHospitalCount: URLSessionDataTask?
    var apiRequestClaimsCount: URLSessionDataTask?



    var m_iconImageArray = [#imageLiteral(resourceName: "Enroll"),#imageLiteral(resourceName: "MyCoverage-1"),#imageLiteral(resourceName: "MyClaims"),#imageLiteral(resourceName: "IntimateClaim-1"),#imageLiteral(resourceName: "NetworkHospital-1"),#imageLiteral(resourceName: "Claim"),#imageLiteral(resourceName: "PolicyFeature"),#imageLiteral(resourceName: "ClaimProcedure"),#imageLiteral(resourceName: "Utility"),#imageLiteral(resourceName: "faq-1"),#imageLiteral(resourceName: "ContactDetails"),#imageLiteral(resourceName: "MyQuery")]
    var m_titleArray = ["link1Name".localized(),"link2Name".localized(),"link3Name".localized(),"link4Name".localized(),"link5Name".localized(),"link6Name".localized(),"link7Name".localized(),"link8Name".localized(),"link9Name".localized(),"link10Name".localized(),"link11Name".localized(),"link12Name".localized()]
    
    var indexNumber = Int()
    var xmlKey = String()
    var topupXmlKey = String()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue : String?
    var dictionaryKeys = ["WINDOW_PERIOD_ACTIVE","PARENTAL_PREMIUM", "CROSS_COMBINATION_ALLOWED", "PAR_POL_INCLD_IN_MAIN_POLICY", "LIFE_EVENT_DOM","LIFE_EVENT_CHILDDOB","SON_MAXAGE","DAUGHTER_MAXAGE","PARENTS_MAXAGE","LIFE_EVENT_DOM_VALDTN_MSG","LIFE_EVENT_CHILDDOB_VALDTN_MSG","SON_MAXAGE_VALDTN_MSG","DAUGHTER_MAXAGE_VALDTN_MSG","PARENTS_MAXAGE_VALDTN_MSG","IS_TOPUP_OPTION_AVAILABLE","TOPUP_OPTIONS","TOPUP_PREMIUMS","ENRL_CNRFM_ALLOWED_FREQ","ENRL_CNRFM_MESSAGE","WINDOW_PERIOD_END_DATE","WINDOW_PERIOD_ACTIVE_TILL_MESSAGE","TOTAL_POLICY_FAMILY_COUNT","RELATION_COVERED_IN_FAMILY","RELATION_ID_COVERED_IN_FAMILY","MAIN_POLICY_FAMILY_COUNT","PARENTAL_POLICY_FAMIL_COUNT","IS_ENROLLMENT_CONFIRMED","EMPLOYEE_EDITABLE_FIELDS","TOPUP_OPT_TOTAL_DAYS_LAPSED","EMPLOYEE_RELATION", "EMPLOYEE_RELATION_ID", "EMPLOYEE_NAME", "EMPLOYEE_DOB","EMPLOYEE_AGE","EMPLOYEE_GENDER","PERSON_SR_NO","OFFICIAL_EMAIL_ID","PERSONAL_EMAIL_ID","CELLPHONE_NO","BASE_SUM_INSURED","TOPUP_SUM_INSURED","EMPLOYEE_IDENTIFICATION_NO","EMPLOYEE_GRADE","EMPLOYEE_DEPARTMENT","EMPLOYEE_DESIGNATION","EMPLOYEE_DOJ","EMP_TOPUP_OPTED","EMP_TOPUP_SI","EMP_TOPUP_PREMIUM","EMP_TOPUP_PREM_DEDTN_MESSAGE","EMP_TOPUP_OPTD_SR_NO","PERSON_SR_NO","DEPENDANT_RELATION","DEPENDANT_RELATION_ID","DEPENDANT_NAME","DEPENDANT_DOB","DEPENDANT_AGE","EcardInformation","IsEnrollmentDoneThroughMyBenefits","EnrollmentType","PolicyDefinition","Description","DependantCount","IncludedRelations","relation","Relation","RelationName","RelationID","MinAge","MaxAge","OpenEnrollmentWindowPeriodInformation","WindowPeriodForNewJoinee","Duration","StartDate","EndDate","WindowPeriodDurationForOptingParentalCoverage","NTimesEnrollmentCanBeConfirmed","NoOfTimesEnrollmentActuallyConfirmed","Childbirth","Marriage","Dependant1","Dependant2","Dependant3","Dependant4","Dependant5","Dependant6","Dependant7","Dependant8","ServerDate","TopupApplicability","GMCTopup","GPATopup","GTLTopup","TopupSumInsured","GMCTopupOptions","GPATopupOptions","GTLTopupOptions","BaseSumInsured","TopSumInsureds","TopupSumInsured","TSumInsured","TSumInsuredPremium","GPATopupOptions","GTLTopupOptions","date_of_datainsert","Hospitals","HospitalName","HospitalAddress","HospitalContactNo","HospitalLevelOfCare","TopupSumInsuredVal","V_COUNT"]
    
    
    var xmlKeysArray = ["GroupAdminBasicSettings","GroupRelations","GroupWindowPeriodInformation","EnrollmentLifeEventInfo","EnrollmentTopUpOptions","EnrollmentMiscInformation"]
    
    var m_topupIndexNumber = Int()
    var relationsDictArray: [[String: String]]?
    var newJoineeEnrollmentDict = [String: String]()
    var openEnrollmentDict = [String: String]()

    var GMCbaseSumInsuredDictArray : [[String: String]]?
    var GPAbaseSumInsuredDictArray : [[String: String]]?
    var GTLbaseSumInsuredDictArray : [[String: String]]?
    var GTLTopupSumInsuredDictArray : [[String: String]]?
    var GMCTopupSumInsuredDictArray : [[String: String]]?
    var GPATopupSumInsuredDictArray : [[String: String]]?
    //var m_productCode = String()
    var m_userDict : EMPLOYEE_INFORMATION?
    //    var documentController: UIDocumentInteractionController = UIDocumentInteractionController()
    var m_groupAdminBasicSettingsDict = NSDictionary()
    var m_enrollmentMiscInformationDict = NSDictionary()
    var hospitalResultsDictArray = [[String: String]]()
    var m_windowPeriodEndDate = Date()
    var dashboarCollectionViewdDelegate : DashboardCollectionViewProtocol? = nil

    
    var refreshControl: UIRefreshControl!
    var isWindowPeriodOpen = false

    
    var claimRefresh = false
    var hospitalRefresh = false
    var queriesRefresh = false
    let center = UNUserNotificationCenter.current()
    var isPresentedPolicySelection = 0
    var policyDetailsArray = Array<CoveragesDetails>()
    var selectedPolicyValue = ""
    var m_productCode = String()
    var selectedIndexPosition = -1
    var isCheck : Bool = false
    var isJailbrokenDevice : Bool = false
    var model : [modelMainArray] = []
    var model1 = modelMainArray(modelName: "My Coverages", modelDetails: "", modelImg: "MyCoverage-1")
    var model2 = modelMainArray(modelName: "Provider Network", modelDetails: "", modelImg: "NetworkHospital-1")
    var model3 = modelMainArray(modelName: "My Claims", modelDetails: "", modelImg: "MyClaims")
    var model4 = modelMainArray(modelName: "My Queries", modelDetails: "", modelImg: "myQueries")
    var model5 = modelMainArray(modelName: "Claim\nProcedures", modelDetails: "", modelImg: "ClaimProcedure-1")
    var model6 = modelMainArray(modelName: "Intimate\nNow", modelDetails: "", modelImg: "IntimateClaim-1")
    var model7 = modelMainArray(modelName: "Policy\nFeatures", modelDetails: "", modelImg: "PolicyFeature")
    var model8 = modelMainArray(modelName: "FAQs", modelDetails: "", modelImg: "faq-2")
    var model9 = modelMainArray(modelName: "Claim\nSubmission", modelDetails: "", modelImg: "faq-2")
    
    var loadsessionStatusValue = false
    var IsEnrollmentSavedStatus = -1
    var IsWindowPeriodOpenStatus = -1
    var enrollmentStatusData = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "loadsessionStatusValue")
        loadsessionStatusValue = UserDefaults.standard.value(forKey: "loadsessionStatusValue") as? Bool ?? false
        print("UserDefault loadsessionStatusValue viewDidLoad: ",loadsessionStatusValue)
        setupFontsUI()
        //getNewLoadSessionDataFromServerNew()
        userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
        userOegrpNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String ?? ""
        userEmployeeSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String ?? ""
        
        //Test Crash
        //let array = NSArray()
        //array.object(at: 10)
        self.enrollMentImageView.isHidden = true
        model.removeAll()
        print("group code: ",getGroupCode())
        //For CNHI1 group code 
        if getGroupCode().uppercased() == "CNHI1"{
                model.append(model1)
                model.append(model2)
                model.append(model3)
                
                model.append(model5)
                
                model.append(model7)
                model.append(model8)
            
            }
            else{
                model.append(model1)
                model.append(model2)
                model.append(model3)
                //model.append(model9)
                model.append(model5)
                model.append(model6)
                model.append(model7)
                model.append(model8)
            }
        
            let nibName = UINib(nibName: "CellForInsuranceTopView", bundle:nil)
             topCollectionView.register(nibName, forCellWithReuseIdentifier: "CellForInsuranceTopView")
            let nibName1 = UINib(nibName: "moduleCollectionViewCell", bundle:nil)
            moduleCollectionView.register(nibName1, forCellWithReuseIdentifier: "moduleCollectionViewCell")
          
            isJailbrokenDevice = false
            m_GMCTab.isHidden=true
            m_shadowView.isHidden=true
            GPATab.isHidden=true
            GTLTab.isHidden=true
            btnContinue.isUserInteractionEnabled = false
            btnContinue.backgroundColor = Color.dark_grey.value
            btnContinue.layer.cornerRadius = 5.0
            btnCancel.layer.cornerRadius = 5.0
            innerTermsVew.layer.cornerRadius = 5.0
            let isterms = UserDefaults.standard.value(forKey: "isTermsConditions") as? Bool
            print(isterms)
            if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
               // App already launched
                if isterms == true{
                    termsVew.alpha = 0
                    tabBarController?.tabBar.isUserInteractionEnabled = true
                    tabBarController?.tabBar.isHidden = false
                }else{
                    termsVew.alpha = 1
                    tabBarController?.tabBar.isUserInteractionEnabled = false
                    tabBarController?.tabBar.isHidden = true
                }

            } else {
                // This is the first launch ever
                termsVew.alpha = 1
                tabBarController?.tabBar.isUserInteractionEnabled = false
                tabBarController?.tabBar.isHidden = true
                UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
                UserDefaults.standard.synchronize()
            }
            
            UserDefaults.standard.setValue("true", forKey: "firstTimeInstall")
            
            m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
            selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
            
            print("NewDashBoard Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
            
            
            self.tabBarController?.tabBar.isHidden=false
            tabBarController?.tabBar.tintColor=hexStringToUIColor(hex: hightlightColor)
            tabBarController?.tabBar.backgroundColor=hexStringToUIColor(hex: "E3EAFD")
            
            tabBarController?.delegate=self
            //deleteDependant()
            //hideUnhideEnrollment()
            //getWindowPeriodDetails()
            
            setBottomShadow(view: m_view1)
            //        shadowForCell(view: m_view1)
            setBottomShadow(view: m_view2)
            setBottomShadow(view: m_view3)
            setBottomShadow(view: m_view4)
            setBottomShadow(view: m_view5)
            setBottomShadow(view: m_view6)
            setBottomShadow(view: m_view7)
            setBottomShadow(view: m_view8)
            
           
            
            
            m_enrollmentView.layer.masksToBounds=true
            m_enrollmentView.layer.cornerRadius=7
            //        m_enrollmentView.setGradientBackground(colorTop: hexStringToUIColor(hex: gradiantColor2), colorBottom:hexStringToUIColor(hex: hightlightColor))
            
            //UserDefaults.standard.setValue(m_productCodeArray, forKey: "ProductsArray")
            m_productCodeArray=UserDefaults.standard.value(forKey: "ProductsArray") as! Array<String>
            print("m_productCodeArray: ",m_productCodeArray)
            addTarget()
            
            showActivityIndicatory()
            setupMiddleButton()
            
            
            
            m_scrollView.alwaysBounceVertical = true
            m_scrollView.bounces  = true
            m_scrollView.showsVerticalScrollIndicator = false
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: UIControlEvents.valueChanged)
            self.m_scrollView.addSubview(refreshControl)
            
            getCoreDataDBPath()
             if let tabs = UserDefaults.standard.value(forKey: "getOfflineTabs") as? Bool {
                 getTopThreeButtonsOffline()
             }
            else {
             //getTopThreeButtonsAPI()
             }
            
            print("Active Policy: ",m_productCodeArray)
            
            if(m_productCodeArray.contains("GMC")){
                print("GMC present")
                m_GMCTab.isHidden = false
                m_shadowView.isHidden=false
            }
            if(m_productCodeArray.contains("GPA")){
                print("GPA present")
                GPATab.isHidden = false
            }
            if(m_productCodeArray.contains("GTL")){
                print("GTL present")
                GTLTab.isHidden = false
            }
            
           //TopUp Bar
            
            m_GMCTab.layer.borderWidth = 2
            GPATab.layer.borderWidth = 2
            GTLTab.layer.borderWidth = 2
            
            m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
            GPATab.layer.cornerRadius = cornerRadiusForView//8
            GTLTab.layer.cornerRadius = cornerRadiusForView//8
            
            m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
            print("m_productCode: ",m_productCode)
            
            if m_productCode == "GMC" && m_productCodeArray.contains("GMC"){
                GMCTabSeleted()
            }
            else if m_productCode == "GPA" && m_productCodeArray.contains("GPA"){
                GPATabSelect()
            }
            else if m_productCode == "GTL" && m_productCodeArray.contains("GTL"){
                GTLTabSelect()
            }
            moduleCollectionView.dataSource = self
            moduleCollectionView.delegate = self
            
            moduleViewCollection.addSubview(moduleCollectionView)
        //}
       
        
    }
    
    
    func setupFontsUI(){
        
        policyNamelbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        policyNamelbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_GMCTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        
        GPATab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        
        GTLTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        
        enrollmentWindowHeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h18))
        enrollmentWindowHeaderLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        m_windowPeriodStatusLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.contentSize25))
        m_windowPeriodStatusLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        m_enrollmentStatusLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h13))
        m_enrollmentStatusLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        m_daysLeftTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h13))
        m_daysLeftTitleLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        m_daysLbl.font = UIFont(name: FontsConstant.shared.medium, size: CGFloat(FontsConstant.shared.hDayCount))
        m_daysLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        header_UA.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h17))
        header_UA.textColor = FontsConstant.shared.app_FontBlackColor
        
        content1_UA.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        content1_UA.textColor = FontsConstant.shared.app_FontBlackColor
        
        content2_UA.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        content2_UA.textColor = FontsConstant.shared.app_FontBlackColor
        
    }
    
    @IBAction func GMCTabSelected(_ sender: Any)
    {
        if isGHIDataPresent{
            selectedPolicyStatus = 1
            selectedIndexPosition = 0
            GMCTabSeleted()
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
                selectedPolicyStatus = 1
                selectedIndexPosition = 0
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
                selectedPolicyStatus = 1
                selectedIndexPosition = 0
                GTLTabSelect()
            }else{
                self.displayActivityAlert(title: "Policy not available!")
            }
//        }
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
        
        
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isAlreadylogin")
        
        menuButton.isHidden=true
        menuButton.removeFromSuperview()
        
        
        let loginVC :LoginViewController_New = LoginViewController_New()
        
        UserDefaults.standard.set("", forKey: "ExtGroupSrNo")
        UserDefaults.standard.set("", forKey: "ExtFamilySrNo")
        UserDefaults.standard.set("", forKey: "OrderMasterNo")
        UserDefaults.standard.set("", forKey: "GroupChildSrNo")
        UserDefaults.standard.set("", forKey: "emailid")
        
        UserDefaults.standard.set(nil, forKey: "MEMBER_ID")
        
       
        //To display disclaimer every time
        UserDefaults.standard.setValue(nil, forKey: "isFitnessFirstTime")
        UserDefaults.standard.setValue(nil, forKey: "cigaretteCount")
        UserDefaults.standard.setValue(nil, forKey: "drinkCount")
        UserDefaults.standard.setValue(nil, forKey: "getOfflineTabs")

        UserDefaults.standard.set(false, forKey: "isInsurance")
        UserDefaults.standard.set(false, forKey: "isWellness")
        UserDefaults.standard.set(false, forKey: "isFitness")
        UserDefaults.standard.set(false, forKey: "HasLaunchedOnce")

        
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
        center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

        center.removeAllPendingNotificationRequests()
        

        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
    @IBAction func btnChkAct(_ sender: Any) {
        if !isCheck{
            isCheck = true
            btnChk.setImage(UIImage(named: "Check Box - Checked-1"), for: .normal)
            btnContinue.isUserInteractionEnabled = true
            var blueColor = UIColor(red:0/255, green:44/255, blue:119/255, alpha: 1)
            btnContinue.backgroundColor = blueColor
        }else{
            isCheck = false
            btnChk.setImage(UIImage(named: "Check Box - Unchecked-1"), for: .normal)
            btnContinue.isUserInteractionEnabled = false
            btnContinue.backgroundColor = Color.dark_grey.value
        }
    }
    @IBAction func btnTermsOfUseAct(_ sender: Any) {
        
        if let url = URL(string: "https://www.marsh.com/in/terms-of-use.html") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            print("btnTermsOfUseAct is empty")
        }
    }
    
    @IBAction func btnRefundPolicyAct(_ sender: Any) {
        if let url = URL(string: "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            print("btnRefundPolicyAct is empty")
        }
    }
    @IBAction func btnDisclaimerAct(_ sender: Any) {
        if let url = URL(string: "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            print("btnDisclaimerAct is empty")
        }
    }
    
    @IBAction func btnPrivacyPolicyAct(_ sender: Any) {
        if let url = URL(string: "https://www.marsh.com/in/privacy-notice.html") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            print("btnPrivacyPolicyAct is empty")
        }
    }
    
    func GMCTabSeleted()
    {
        addModules()
        DispatchQueue.main.async{
            self.moduleCollectionView.reloadData()
        }
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
        print("policyDataArray GMC :: ",policyDataArray)
        print("policyDataArray GMC count :: ",policyDataArray.count)
        print("selectedIndexPosition GMC :: ",selectedIndexPosition)
        
        
        if policyDataArray.count > selectedIndexPosition{
            print("NewDashboardViewController selectedIndexPosition GMC ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("NewDashboardViewController selectedIndexPosition GMC ",selectedIndexPosition)
        }
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        self.errorState = 0
        m_GMCTab.setTitle("GHI", for: .normal)
        //m_shadowView.dropShadow()
        m_shadowView.layer.cornerRadius = cornerRadiusForView
        GTLShadowView.layer.masksToBounds=true
        GPAShadowView.layer.masksToBounds=true
        m_GMCTab.layer.masksToBounds=true
        //m_GMCTab.layer.cornerRadius=m_GMCTab.frame.size.height/2
        //m_GMCTab.layer.cornerRadius=5
        //m_GMCTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GMCTab.layer.borderWidth=0
        m_GMCTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        GMCLine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
        m_GMCTab.setTitleColor(UIColor.white, for: .normal)
        
        GPALine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        GTLLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        GPATab.layer.borderWidth = 2
        GTLTab.layer.borderWidth = 2
        
        GPATab.layer.cornerRadius = cornerRadiusForView//8
        GTLTab.layer.cornerRadius = cornerRadiusForView//8
        
        GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GTLTab.setBackgroundImage(nil, for: .normal)
        
        //getEnrollmentDetails()
        loadsessionStatusValue = UserDefaults.standard.value(forKey: "loadsessionStatusValue") as? Bool ?? false
        print("UserDefault loadsessionStatusValue GMC: ",loadsessionStatusValue)
        if loadsessionStatusValue{
            getPolicyCoveragesDetails_Data()
        }
        else{
            print("loadsessionStatusValue: ",loadsessionStatusValue)
        }
        self.getEnrollStatus()
    }
    
    func GPATabSelect()
    {
        //print("Testing Crashlytics GPATabSelect....")
        //Crashlytics.crashlytics().log("Testing Crashlytics GPATabSelect")
        //Crashlytics.crashlytics().record(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test Crash GPATabSelect"]))
//        if userEmployeeSrnoGPA == ""{
//           GMCTabSeleted()
//        }else{
            
            removeModules()
            DispatchQueue.main.async{
                self.moduleCollectionView.reloadData()
            }
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
                print("NewDashboardViewController selectedIndexPosition GPA ",selectedIndexPosition)
            }
            else{
                selectedIndexPosition = 0
                print("NewDashboardViewController selectedIndexPosition GPA ",selectedIndexPosition)
            }
            if policyDataArray.count > 0{
                policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
            }
            else{
                policyNamelbl.text = ""
            }
            self.errorState = 0
            GPATab.setTitle("GPA", for: .normal)
            //GPAShadowView.dropShadow()
            GPAShadowView.layer.cornerRadius = cornerRadiusForView//8
            m_shadowView.layer.masksToBounds = true
            GTLShadowView.layer.masksToBounds=true
            
            
            GPATab.layer.masksToBounds=true
            //GPATab.layer.cornerRadius=GPATab.frame.size.height/2
            //GPATab.layer.cornerRadius=5
            //GPATab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
            GPATab.layer.borderWidth=0
            GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
            GPALine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            GPATab.setTitleColor(UIColor.white, for: .normal)
            
            GMCLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
            GTLLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
            m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
            GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
            
            m_GMCTab.layer.borderWidth = 2
            GTLTab.layer.borderWidth = 2
            
            m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
            GTLTab.layer.cornerRadius = cornerRadiusForView//8
            
            m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
            m_GMCTab.setBackgroundImage(nil, for: .normal)
            GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
            GTLTab.setBackgroundImage(nil, for: .normal)
            
            loadsessionStatusValue = UserDefaults.standard.value(forKey: "loadsessionStatusValue") as? Bool ?? false
            print("UserDefault loadsessionStatusValue GPA: ",loadsessionStatusValue)
            if loadsessionStatusValue{
                getPolicyCoveragesDetails_Data()
            }
            else{
                print("loadsessionStatusValue: ",loadsessionStatusValue)
            }
        //}
        self.getEnrollStatus()
        
    }
    
    func GTLTabSelect()
    {
//        if userEmployeeSrnoGTL == ""{
//           GMCTabSeleted()
//        }else{
            removeModules()
            DispatchQueue.main.async{
                self.moduleCollectionView.reloadData()
            }
            m_productCode = "GTL"
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
                print("NewDashboardViewController selectedIndexPosition GTL ",selectedIndexPosition)
            }
            else{
                selectedIndexPosition = 0
                print("NewDashboardViewController selectedIndexPosition GTL ",selectedIndexPosition)
            }
            if policyDataArray.count > 0{
                policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
            }
            else{
                policyNamelbl.text = ""
            }
            self.errorState = 0
            GTLTab.setTitle("GTL", for: .normal)
            //GTLShadowView.dropShadow()
            GTLShadowView.layer.cornerRadius = cornerRadiusForView//8
            GPAShadowView.layer.masksToBounds=true
            m_shadowView.layer.masksToBounds=true
            GTLTab.layer.masksToBounds=true
            //GTLTab.layer.cornerRadius=GTLTab.frame.size.height/2
            //GTLTab.layer.cornerRadius=5
            //GTLTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
            GTLTab.layer.borderWidth=0
            GTLTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
            GTLLine.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            GTLTab.setTitleColor(UIColor.white, for: .normal)
            
            GMCLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
            GPALine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
            GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
            m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
            
            
            m_GMCTab.layer.borderWidth = 2
            GPATab.layer.borderWidth = 2
            
            m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
            GPATab.layer.cornerRadius = cornerRadiusForView//8
            
            m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
            m_GMCTab.setBackgroundImage(nil, for: .normal)
            GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
            GPATab.setBackgroundImage(nil, for: .normal)
            
            
            loadsessionStatusValue = UserDefaults.standard.value(forKey: "loadsessionStatusValue") as? Bool ?? false
            print("UserDefault loadsessionStatusValue GTL: ",loadsessionStatusValue)
            if loadsessionStatusValue{
                getPolicyCoveragesDetails_Data()
            }
            else{
                print("loadsessionStatusValue: ",loadsessionStatusValue)
            }
        //}
        self.getEnrollStatus()
        
    }
    
    
    
    
    @objc func didPullToRefresh() {
        print("Refersh")
        if isConnectedToNet(){
            hospitalRefresh = false
            //queriesRefresh = true
            claimRefresh = false
            
            let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .default)
            anotherQueue.async {
                self.getAdminSettingsJSONNew()
                //self.getNewLoadSessionDataFromServer()
                self.getNewLoadSessionDataFromServerNew()
                
                self.getClaimsJson()
                //self.getAllQueries()
                self.getHospitalCountsJson()
                
            }
            
            anotherQueue.async {
                self.hideRefreshLoader()
            }
        }else{
            let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .default)
            anotherQueue.async {
                self.displayActivityAlert(title: "No internet")
            }
            anotherQueue.async {
                self.hideRefreshLoader()
            }
        }
        
    }
    
     func hideUnhideEnrollment() {
        //Hide/show enrollment window details card
        if let isEnrollmentThroughtMB = UserDefaults.standard.value(forKey: "isEnrollmentThroughtMB") as? Bool {
            if isEnrollmentThroughtMB {
                m_enrollmentDetailLoader.stopAnimating()
            }
            else {
                //m_windowPeriodStatus = false
                //m_enrollmentStatusLbl.text=""
                //m_enrollmentStatusLbl.text=self.enrollmentStatusData
                //m_enrollmentStatusImgview.image=UIImage(named: "")
                m_enrollmentDetailLoader.stopAnimating()
                //m_windowPeriodStatusLbl.text="CLOSED"
                //m_windowPeriodStatus=false
                //m_daysLbl.isHidden=true
                //m_daysLeftTitleLbl.isHidden=true
                enrollMentImageView.image=UIImage(named: "enrollment-1")
                //enrollMentImageView.isHidden=false

                
//                print("Hide Enrollment")
//                self.dividerView.isHidden = true
//                self.topView.isHidden = true
//                self.m_enrollmentView.isHidden = true
//                self.enrollmentCardSuperView.isHidden = true
//                self.heightOfEnrollmentCardSuperView.constant = 0

            }
        }
    }
    
    func getCoreDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

        print("Core Data DB Path :: \(path ?? "Not found")")
    }
    
    //Hide Loader
    private func hideRefreshLoader() {
        print("hideRefreshLoader()")
        print(claimRefresh,hospitalRefresh)
        if claimRefresh && hospitalRefresh {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.hospitalRefresh = false
                self.claimRefresh = false
            }
        }
        else if(!isConnectedToNet()) {
            self.refreshControl.endRefreshing()
            self.hospitalRefresh = false
            self.claimRefresh = false
        }
    }
    
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    
    func playVideo(url: URL) {
        
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    func showActivityIndicatory()
    {
        //m_enrollmentDetailLoader.startAnimating()
        m_hospitalActivityIndicator.startAnimating()
        m_claimsIndicator.startAnimating()
        //self.m_queryActivityIndicator.startAnimating()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Cancel the API request if it's ongoing
        apiRequestLoadSession?.cancel()
        apiRequestAdminSetting?.cancel()
        apiRequestCoveragesData?.cancel()
        apiRequestHospitalCount?.cancel()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        if IOSSecuritySuite.amIJailbroken() {
            print("This device is jailbroken")
            isJailbrokenDevice = true
            //self.showAlert(message: "This device is jailbroken")
            let alertController = UIAlertController(title: "This device is jailbroken", message: "", preferredStyle: UIAlertControllerStyle.alert)

//            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
//            {
//                (result : UIAlertAction) -> Void in
//                print("Cancel")
//
//            }
            let yesAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
            {(result : UIAlertAction) -> Void in

                let defaults = UserDefaults.standard
                defaults.set(false, forKey: "isAlreadylogin")

                menuButton.isHidden=true
                menuButton.removeFromSuperview()


                let loginVC :LoginViewController_New = LoginViewController_New()

                UserDefaults.standard.set("", forKey: "ExtGroupSrNo")
                UserDefaults.standard.set("", forKey: "ExtFamilySrNo")
                UserDefaults.standard.set("", forKey: "OrderMasterNo")
                UserDefaults.standard.set("", forKey: "GroupChildSrNo")
                UserDefaults.standard.set("", forKey: "emailid")

                UserDefaults.standard.set(nil, forKey: "MEMBER_ID")

                //for Added for Terms and codition on 1st time login
//                if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
//                    self.perviousTermsCondtion = "true"
//                }
//                else{
//                    self.perviousTermsCondtion = "false"
//                }
                //To display disclaimer every time
                UserDefaults.standard.setValue(nil, forKey: "isFitnessFirstTime")
                UserDefaults.standard.setValue(nil, forKey: "cigaretteCount")
                UserDefaults.standard.setValue(nil, forKey: "drinkCount")
                UserDefaults.standard.setValue(nil, forKey: "getOfflineTabs")

                UserDefaults.standard.set(false, forKey: "isInsurance")
                UserDefaults.standard.set(false, forKey: "isWellness")
                UserDefaults.standard.set(false, forKey: "isFitness")


                let center = UNUserNotificationCenter.current()
                center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
                center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

                center.removeAllPendingNotificationRequests()
//                if self.perviousTermsCondtion == "true"{
//                    UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
//                }

                self.navigationController?.pushViewController(loginVC, animated: true)
                //        navigationController?.popToViewController(loginVC, animated: true)
                UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                       to: UIApplication.shared, for: nil)

            }
            //alertController.addAction(cancelAction)
            alertController.addAction(yesAction)

            self.present(alertController, animated: true, completion: nil)

//        } else if IOSSecuritySuite.amIProxied(){
//            //showalertforJailbreakDevice("This device is proxied")
//            alertForLogout(titleMsg: "This device is proxied")
//        }
//        else if IOSSecuritySuite.amIRunInEmulator(){
//            //showalertforJailbreakDevice("Emulator device is not allowed")
//            alertForLogout(titleMsg: "Emulator device is not allowed")
//        }
//        else if IOSSecuritySuite.amIDebugged(){
//            //showalertforJailbreakDevice("Debugging is not allowed")
//            alertForLogout(titleMsg: "Debugging is not allowed")
        }
        else {
            
             getNewLoadSessionDataFromServerNew()
             //TopUp Bar
             m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
             selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
             selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
             print("Selected values ",selectedPolicyValue," : ",m_productCode," : ",selectedIndexPosition)
             
             //TopUp Bar
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
             
             //PolicyHeaderView.setBorderToViewSelectPolicy(color:hexStringToUIColor(hex: "E5E5E5"))
             //PolicyTypeView.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
             PolicylblView.setBorderToViewSelectPolicy(color:hexStringToUIColor(hex: "E5E5E5"))
             //setBottomShadow(view: PolicyHeaderView)
             
             
             if isRemoveFlag == 1 {
                 self.setupMiddleButton()
                 isRemoveFlag = 0
             }
             
             //Navbar color change for all pages
             //self.tabBarController?.view.backgroundColor = UIColor.white
             self.tabBarController?.view.setGradientBackground(colorTop: hexStringToUIColor(hex: hightlightColor), colorBottom:hexStringToUIColor(hex: gradiantColor2))
             
            //Tabbar bottom nav
            let colorSelected = hexStringToUIColor(hex: hightlightColor)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
             self.tabBarController?.tabBar.tintColor = hexStringToUIColor(hex: hightlightColor)
             self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.lightGray
             
             menuButton.backgroundColor = hexStringToUIColor(hex: hightlightColor)
             menuButton.setImage(UIImage(named:"Home-2"), for: .normal)
             menuButton.setBackgroundImage(UIImage(named: "blueEsclip"), for: .normal)
             menuButton.contentMode = .scaleAspectFill
             
             navigationController?.navigationBar.isHidden=false
             navigationController?.isNavigationBarHidden=false
             self.tabBarController?.tabBar.isHidden=false
             let isterms = UserDefaults.standard.value(forKey: "isTermsConditions") as? Bool
             if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
                // App already launched
                 if isterms == true{
                     termsVew.alpha = 0
                     menuButton.isHidden=false
                     tabBarController?.tabBar.isUserInteractionEnabled = true
                     tabBarController?.tabBar.isHidden = false
                 }else{
                     termsVew.alpha = 1
                     tabBarController?.tabBar.isUserInteractionEnabled = false
                     tabBarController?.tabBar.isHidden = true
                     menuButton.isHidden=true
                 }

             } else {
                 // This is the first launch ever
                 termsVew.alpha = 1
                 tabBarController?.tabBar.isUserInteractionEnabled = false
                 tabBarController?.tabBar.isHidden = true
                 menuButton.isHidden=true
                 UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
                 UserDefaults.standard.synchronize()
             }
            
             
             UINavigationBar.appearance().tintColor = UIColor.white
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
             self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
             navigationController?.navigationBar.dropShadow()
             
             //let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "notification"), style: .plain, target: self, action: #selector(self.rightButtonClicked)) // action:#selector(Class.MethodName) for swift 3
             //navigationItem.rightBarButtonItem = button1
             
             let policyCount = self.getPolicyCountFromDatabase()
             
             //Navigation bar right side icon
             if policyCount > 1 {
                 let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "LatestChangePolicy"), style: .plain, target: self, action: #selector(self.rightButtonClicked))
                 
                 navigationItem.rightBarButtonItem = button1
             }
             //Hide top right Icon
             self.navigationItem.rightBarButtonItem=nil
             self.navigationItem.rightBarButtonItem?.isEnabled=false
             navigationItem.rightBarButtonItem?.accessibilityElementsHidden=true
             
             //Hide top left Icon
             self.navigationItem.leftBarButtonItem=nil
             self.navigationItem.leftBarButtonItem?.isEnabled=false
             navigationItem.leftBarButtonItem?.accessibilityElementsHidden=true
             
             
             let logo = UIImage(named: "mb360_white")
             let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height:10))
             imageView.image=logo
             imageView.contentMode=UIViewContentMode.scaleAspectFit
             self.navigationItem.titleView = imageView
             
             
             self.navigationController?.navigationBar.layer.shouldRasterize=false
             
             
             //Changed "m_productCode" var to "GMC" str for name change issue
             let array : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: "GMC", relationName: "EMPLOYEE")
             if(array.count>0)
             {
                 let personInfo = array[0]
                 if let name = personInfo.personName
                 {
                     m_nameLbl.text="Hello, "+name
                     employeeName = name
                     
                 }
                 
             }
             setLayout()
             
             /* menuButton.isHidden=false
              menuButton.backgroundColor = hexStringToUIColor(hex: hightlightColor)
              menuButton.setBackgroundImage(UIImage(named: "blueEsclip"), for: .normal)
              menuButton.setImage(UIImage(named:"Home-2"), for: .normal)*/
             
             //        getMyCoveragesPostUrl()
             UINavigationBar.appearance().backgroundColor = UIColor.clear
             
            
        }
        
       
    }
    
    private func getPolicyCountFromDatabase() -> Int {
              let policyArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "GMC")
           return policyArray.count
       }
    
    
    func getWindowPeriodDetails(){
        if (isConnectedToNetWithAlert()){
            let appendUrl = "getWindowPeriodDetails"
            
            webServices().getDataForEnrollment(appendUrl, completion: {(data,error) in
                if error == ""{
                    do{
                        let json = try JSONDecoder().decode(WindowPeriodDetails.self, from: data)
                        print(json)
                        var endD = json.windowPeriod.windowEndDate_gmc
                        let currentDate = getCurrentDate()
                        let dateFormatter : DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        var endDate = dateFormatter.date(from: GlobalendDate)
                        if currentDate.compare(endDate!) == .orderedAscending {
                            print("current date is small")
                            DispatchQueue.main.async{
                                //self.m_enrollmentStatusLbl.text="Add Dependant"
                                //self.m_enrollmentStatusLbl.text=self.enrollmentStatusData
                                //self.m_enrollmentStatusImgview.image=UIImage(named: "add")
                                self.m_enrollmentDetailLoader.stopAnimating()
                                //self.m_windowPeriodStatusLbl.text="OPEN"
                                //m_windowPeriodStatus=true
                                
                                let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate!)!
                                let endDateComp = Calendar.current.dateComponents([.year, .month, .day], from: modifiedDate)
                                //        let nextTriggerDate = Calendar.current.date(byAdding: .day, value: 1, to: EndDate)!
                                //        let comps = Calendar.current.dateComponents([.year, .month, .day], from: nextTriggerDate)
                                let nextBirthDate = Calendar.current.nextDate(after: Date(), matching: endDateComp, matchingPolicy: .nextTime)!
                                
                                let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: nextBirthDate)
                                
                                print(difference.day)
                                //self.m_daysLbl.isHidden=false
                                self.m_daysLbl.text = String(format: "%02d", difference.day!)
                                //self.m_daysLeftTitleLbl.isHidden=false
                                //self.enrollMentImageView.isHidden=true
                                
                            }
                        }else{
                            print("current date is big")
                            
                            DispatchQueue.main.async{
                                //self.m_enrollmentStatusLbl.text="Download Summary"
                                //self.m_enrollmentStatusLbl.text=self.enrollmentStatusData
                                
                                //self.m_enrollmentStatusImgview.image=UIImage(named: "download-2")
                                self.m_enrollmentDetailLoader.stopAnimating()
                                //self.m_windowPeriodStatusLbl.text="CLOSED"
                                //m_windowPeriodStatus=false
                                //self.m_daysLbl.isHidden=true
                                //self.m_daysLeftTitleLbl.isHidden=true
                                self.enrollMentImageView.image=UIImage(named: "enrollment-1")
                                //self.enrollMentImageView.isHidden=false
                            }
                        }
                        
                        
                    }catch{
                        
                    }
                }else{
                    DispatchQueue.main.sync{
                        self.showAlertwithOk(message: error)
                    }
                }
                
            })
        }
    }
    
    override func rightButtonClicked()
    {
        print("rightButtonClicked 445")
        isPresentedPolicySelection = 1
        
        // playVideo(url: url)
        
        
        
        let policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "")
        
        
        if policyDataArray.count > 0 {
            let vc  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"SelectPolicyOptionsVC") as! SelectPolicyOptionsVC
            //vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            vc.fromPageName = "NewDashboardViewController"
            vc.policyDelegateObj = self
            vc.policyCount = policyDataArray.count
            UserDefaults.standard.set(true, forKey: "isPolicyChanged")
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        
    }
     
    func getAllQueries()
    {
        if(isConnectedToNetWithAlert())
        {
            
            
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            //if userArray.count > 0{
            //m_employeedict=userArray[0]
            var employeesrno = String()
            if let empNo = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String//m_employeedict?.empSrNo
            {
                employeesrno = String(empNo)
                print("employeesrno: ",employeesrno)
                employeesrno = try! AES256.encrypt(input: employeesrno, passphrase: m_passphrase_Portal)
            }
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getQueriesUrl(empSrNo:employeesrno.URLEncoded))
            
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
            
            //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
            authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
            print("authToken getAllQueries:",authToken)
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
            
            
            print("getAllQueries Url",urlreq)
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                DispatchQueue.main.async{
                    print("My Queries response",response)
                    //SSL Pinning
                    if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                        // Handle SSL connection failure
                        print("SSL connection error: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.alertForLogout(titleMsg: error.localizedDescription)
                        }
                    }
                    else if let error = error {
                        print("getAllQueries() error:", error)
                        self.hidePleaseWait()
                        return
                    }
                    else
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            print("getAllQueries httpResponse.statusCode: ",httpResponse.statusCode)
                            
                            if httpResponse.statusCode == 200
                            {
                                do {
                                    
                                    if let data = data, let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                                    {
                                        print("MyQuery jsonResult ",jsonResult)
                                        if(jsonResult.count>0)
                                        {
                                            DispatchQueue.main.async
                                            {
                                                
                                                if let message = jsonResult.value(forKey: "message")
                                                {
                                                    let dict : NSDictionary = (message as? NSDictionary)!
                                                    let status = dict.value(forKey: "Status") as! Bool
                                                    print("status for queries :",status)
                                                    if(status)
                                                    {
                                                        if let allQueries = jsonResult.value(forKey: "AllQueries")
                                                        {
                                                           // DatabaseManager.sharedInstance.deleteQueries()
                                                            
                                                            let queryArray : NSArray = (allQueries as? NSArray)!
                                                            
                                                            print("Count for queries ",queryArray.count)

                                                            let array = queryArray//DatabaseManager.sharedInstance.retrieveQueries()
                                                            let count = String(array.count)+" Queries"; self.m_queryCountLbl.text=count;
                                                        }
                                                      
                                                    }
                                                    else
                                                    {
                                                        self.m_queryCountLbl.text="0"+" Query"
                                                    }
                                                    
                                                }
                                                DispatchQueue.main.async{
                                                    self.moduleCollectionView.reloadData()
                                                }
                                                self.m_queryActivityIndicator.stopAnimating()
                                                self.queriesRefresh = true
                                                self.m_queryCountLbl.isHidden = false
                                                self.hideRefreshLoader()
                                                
                                            }
                                            print(jsonResult.allKeys)
                                        }
                                        else
                                        {
                                            let deadlineTime = DispatchTime.now() + .seconds(1)
                                            DispatchQueue.main.asyncAfter(deadline: deadlineTime)
                                            {
                                                self.m_queryActivityIndicator.stopAnimating()
                                                self.queriesRefresh = true
                                                self.hideRefreshLoader()
                                                
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                } catch let JSONError as NSError
                                {
                                    Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                    print(JSONError)
                                    
                                }
                            }else if httpResponse.statusCode == 401 || httpResponse.statusCode == 400{
                                self.getAllQueries()
                            }
                            else
                            {
                                let array = DatabaseManager.sharedInstance.retrieveQueries()
                                if array.count > 0{
                                    let count = String(array.count)+" Queries";
                                    self.m_queryCountLbl.text=count;
                                }else{
                                    self.m_queryCountLbl.text="0"+" Query"
                                }
                                self.m_queryActivityIndicator.stopAnimating()
                                self.queriesRefresh = true
                                self.m_queryCountLbl.isHidden = false
                                self.hideRefreshLoader()
                                
                                self.hidePleaseWait()
                                //self.displayActivityAlert(title: m_errorMsg)
                                print("else executed1 getAllQueries")
                                //                                self.queriesRefresh = true
                                //                                self.hideRefreshLoader()
                                
                            }
                            
                        }
                        else
                        {
                            print("Can't cast response to NSHTTPURLResponse")
                            self.queriesRefresh = true
                            self.hideRefreshLoader()
                            //self.displayActivityAlert(title: m_errorMsg)
                            print("m_errorMsg ",m_errorMsg)
                            self.hidePleaseWait()
                            
                        }
                        
                        DispatchQueue.main.async{
                            if self.m_productCode == "GMC"{
                                self.model[2].modelDetails = "\(self.claimCount) Claims"//self.m_claimCountLbl.text!
                                self.model[1].modelDetails = "\(self.hospCount) Hospitals"//self.m_hospitalsCountLbl.text!
                                if self.getGroupCode().uppercased() == "CNHI1"{
                                    self.model[3].modelDetails = ""
                                }else{
                                    self.model[3].modelDetails = self.m_queryCountLbl.text!
                                }
                            }else{
                                self.model[1].modelDetails = "\(self.claimCount) Claims"//self.m_claimCountLbl.text!
                                self.model[3].modelDetails = ""
                                if self.getGroupCode().uppercased() == "CNHI1"{
                                    self.model[2].modelDetails = ""
                                }else{
                                    self.model[2].modelDetails = self.m_queryCountLbl.text!
                                }
                            }
                            self.moduleCollectionView.reloadData()
                        }
                        
                    }
                }
            }
            task.resume()
//            }else{
//                self.queriesRefresh = true
//                self.hideRefreshLoader()
//                self.displayActivityAlert(title: m_errorMsg)
//                self.hidePleaseWait()
//            }
        }
        else
        {
//            self.hidePleaseWait()
//            self.hideRefreshLoader()
            let array = DatabaseManager.sharedInstance.retrieveQueries()
            if array.count > 0{
                let count = String(array.count)+" Queries";
                self.m_queryCountLbl.text=count;
            }else{
                self.m_queryCountLbl.text="0"+" Query"
            }
            self.m_queryActivityIndicator.stopAnimating()
            self.queriesRefresh = true
            self.m_queryCountLbl.isHidden = false
            self.hideRefreshLoader()

        }
    }
    
    func policyChangedDelegateMethod() {
        //self.getFamilyDefination()
        print("Called policyChangedDelegateMethod")
        
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        if policyDataArray.count > selectedIndexPosition{
            print("NewDashboardViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("NewDashboardViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        
        print("selectedIndexPosition is : ",selectedIndexPosition)
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        //getPolicyCoveragesDetails_Data()
    }
    
    //MARK:- Family Definition
    func getFamilyDefination()
    {
        getUpdatedFamilyDefinition()
    
    }
    
    func getUpdatedFamilyDefinition() {
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        
        print("Product code is: ",m_productCode," : ",selectedPolicyValue)
        
        let relationArray1 : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrievePersonDetails(productCode: m_productCode)
        
        let relationArray = relationArray1.sorted(by: { $0.relationID > $1.relationID })

            print(relationArray)
            var familyDefinationArray = [String]()
            familyDefinationArray.append("E")

            for i in 0..<relationArray.count
            {
                let dict = relationArray[i]
                let relation = dict.relationname
                
                switch relation
                {
                case "EMPLOYEE":
                    if !familyDefinationArray.contains("E") {
                        familyDefinationArray.append("E")
                    }
                    
                    if(dict.gender?.capitalizingFirstLetter()=="Male")  {
                        m_spouse="WIFE"
                    }
                    else  {
                        m_spouse="HUSBAND"
                    }
                    break
                    
                case "WIFE","wife","Wife":
                    if !familyDefinationArray.contains("Sp") {
                    familyDefinationArray.append("Sp") //wife as spouse
                    }
                    //familyDefinationArray.append("W")
                    break
                    
                 case "HUSBAND","Husband","husband":
                    familyDefinationArray.append("H")
                    break
                    
                case "PARTNER":
                    familyDefinationArray.append("P")
                    break
                    
                case "SON":
                    if  familyDefinationArray.contains("Sn1") &&
                        familyDefinationArray.contains("Sn2") &&
                        familyDefinationArray.contains("Sn3") {
                        
                        familyDefinationArray.append("Sn4")
                    }
                    else if familyDefinationArray.contains("Sn1") && familyDefinationArray.contains("Sn2") {
                        familyDefinationArray.append("Sn3")
                    }
                    else if familyDefinationArray.contains("Sn1") {
                        familyDefinationArray.append("Sn2")
                    }
                    else {
                        familyDefinationArray.append("Sn1")
                    }
                    break
                case "DAUGHTER":

                    if familyDefinationArray.contains("D1") && familyDefinationArray.contains("D2") && familyDefinationArray.contains("D3") {
                        familyDefinationArray.append("D4")
                    }
                    else if familyDefinationArray.contains("D1") && familyDefinationArray.contains("D2") {
                        familyDefinationArray.append("D3")
                    }
                    else if familyDefinationArray.contains("D1") {
                        familyDefinationArray.append("D2")
                    }
                    else {
                        familyDefinationArray.append("D1")
                    }
                    //break
                    
                case "FATHER":
                    familyDefinationArray.append("F")
                    break
                case "MOTHER":
                    familyDefinationArray.append("M")
                    break
                case "FATHERINLAW","FATHER-IN-LAW":
                    familyDefinationArray.append("FIL")
                    break
                case "MOTHERINLAW","MOTHER-IN-LAW":
                    familyDefinationArray.append("MIL")
                    break
                    
                default:
                    break
                }
            }
            var newArray : Array<String> = []
            newArray = familyDefinationArray
            for i in 0..<familyDefinationArray.count
            {
                let itemToRemove = ""
                if let index = newArray.index(of: itemToRemove)
                {
                    newArray.remove(at: index)
                }
            }
            familyDefinationArray=newArray
            if(familyDefinationArray.count==1)
            {
                familyDefinationArray[0]="Employee"
            }
            m_familyDefinationLbl.text = familyDefinationArray.joined(separator: "+")
            UserDefaults.standard.setValue(m_familyDefinationLbl.text!, forKey: "familyDefinition")
            
        }
    
    
    func getLeftBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:UIImage(named: "menu"), style: .plain, target: self, action: #selector(leftButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func leftButtonClicked()
    {
        
        //        overLappingView.isHidden=true
        
    }
    
    func addTarget()
    {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.enrollmentProcessNew (_:)))
        /*
         00 nothing
         01 window open add dependant
         11 window open continue enrollment
         10 download summary
         */
        print("addTarget: self.IsEnrollmentSavedStatus: ",self.IsEnrollmentSavedStatus," self.IsWindowPeriodOpenStatus :",self.IsWindowPeriodOpenStatus)
        
        if (self.IsEnrollmentSavedStatus == 0 && self.IsWindowPeriodOpenStatus == 1)
            || (self.IsEnrollmentSavedStatus == 1 && self.IsWindowPeriodOpenStatus == 1)
            || (self.IsEnrollmentSavedStatus == 1 && self.IsWindowPeriodOpenStatus == 0)
        {
            if enrollmentStatusData.lowercased() == "add dependant" || enrollmentStatusData.lowercased() == "continue enrollment" || enrollmentStatusData.lowercased() == "download summary"{
                self.m_enrollmentView.addGestureRecognizer(gesture)
            }
        }
        
        let gesture0 = UITapGestureRecognizer(target: self, action:  #selector (self.myCoverages (_:)))
        self.m_myCoveragesView.addGestureRecognizer(gesture0)
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.hospitalNetworks (_:)))
        self.m_MyHospitalsView.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.myClaims (_:)))
        self.m_mycliamsView.addGestureRecognizer(gesture2)
        
        //let gesture3 = UITapGestureRecognizer(target: self, action:  #selector (self.myQueries (_:)))
        //self.m_queriesView.addGestureRecognizer(gesture3)
        
        let gesture4 = UITapGestureRecognizer(target: self, action:  #selector (self.claimProcedures (_:)))
        self.m_claimProcedureView.addGestureRecognizer(gesture4)
        
        let gesture5 = UITapGestureRecognizer(target: self, action:  #selector (self.intimateClaim (_:)))
        self.m_intimateClaimsView.addGestureRecognizer(gesture5)
        
        let gesture6 = UITapGestureRecognizer(target: self, action:  #selector (self.policyFeatures (_:)))
        self.m_policyFeaturesView.addGestureRecognizer(gesture6)
        
        let gesture7 = UITapGestureRecognizer(target: self, action:  #selector (self.faqs(_:)))
        self.m_faqView.addGestureRecognizer(gesture7)
        
        let gesturePolicy = UITapGestureRecognizer(target: self, action:  #selector (self.selectPolicyName (_:)))
        self.PolicylblView.addGestureRecognizer(gesturePolicy)
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
    
    @objc func myCoverages(_ sender:UITapGestureRecognizer)
    {
        let myCoverages : MyCoveragesViewController = MyCoveragesViewController()
        myCoverages.m_employeedict=m_userDict
        navigationController?.pushViewController(myCoverages, animated: true)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        
    }
    @objc func hospitalNetworks(_ sender:UITapGestureRecognizer)
    {
        let networkHospitals : NetworkHospitalsViewController = NetworkHospitalsViewController()
        print("addressString\(m_addressString)")
        networkHospitals.m_addressString=m_addressString
        networkHospitals.apiFlag = true
        navigationController?.pushViewController(networkHospitals, animated: true)
        
    }
    @objc func myClaims(_ sender:UITapGestureRecognizer)
    {
        let myClaims:MyClaimsViewController = MyClaimsViewController()
        navigationController?.pushViewController(myClaims, animated: true)
        //        menuButton.isHidden=true
    }
    @objc func myQueries(_ sender:UITapGestureRecognizer)
    {
        print("Queries tapped",UserDefaults.standard.value(forKey: "groupCodeString"))
        if let groupCode = UserDefaults.standard.value(forKey: "groupCodeString") as? String,groupCode != "" {
            if groupCode.uppercased() == "TCL" {
                showAlert(message: "Employee Queries not activated for your policy ")
            }
            else {
                let myQueries : MyQueriesViewController = MyQueriesViewController()
                //navigationController?.pushViewController(myQueries, animated: true)
            }
        }
        
        
    }
    @objc func claimProcedures(_ sender:UITapGestureRecognizer)
    {
        //let claimProcedure : ClaimProcedureViewController = ClaimProcedureViewController()
        let claimProcedure : ClaimProcedureVC_New = ClaimProcedureVC_New()
        
        //let claimProcedure : ClaimProcedureVC = ClaimProcedureVC()
        
        navigationController?.pushViewController(claimProcedure, animated: true)
        //        menuButton.isHidden=true
        
        
    }
    @objc func intimateClaim(_ sender:UITapGestureRecognizer)
    {
        if let groupCode = UserDefaults.standard.value(forKey: "groupCodeString") as? String,groupCode != "" {
            if groupCode.uppercased() == "TCL" {
                showAlert(message: "Claim intimation clause not applicable for your policy")
            }
            else {
                let intimation : MyIntimationViewController = MyIntimationViewController()
                navigationController?.pushViewController(intimation, animated: true)
            }
        }
    }
    
    
    @objc func policyFeatures(_ sender:UITapGestureRecognizer)
    {
        let policyFeatures : PolicyFeaturesViewController = PolicyFeaturesViewController()
        navigationController?.pushViewController(policyFeatures, animated: true)
        //        menuButton.isHidden=true
    }
    
    
    @objc func faqs(_ sender:UITapGestureRecognizer)
    {
        let faq : FAQViewController = FAQViewController()
        navigationController?.pushViewController(faq, animated: true)
        //        menuButton.isHidden=true
    }
    
    func setupMiddleButton()
    {
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        
        var menuButtonFrame = menuButton.frame
        var yValue = CGFloat()
        var xValue = CGFloat()
        
        if(Device.IS_IPAD)
        {
            yValue=(tabBarController?.view.bounds.height)!+10
            xValue=(tabBarController?.view.bounds.width)!/2 - (menuButtonFrame.size.width/2)
        }
        else if(Device.IS_IPHONE_6)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+10)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
        }
        else if(Device.IS_IPHONE_6P)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+10)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
        }
        else if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+10)
            xValue=(tabBarController?.view.bounds.width)!/2 - (menuButtonFrame.size.width/2)
        }
        else if(Device.IS_IPHONE_X)
        {
            print("Height ",tabBarController?.view.bounds.height," : Width ",tabBarController?.view.bounds.width)
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+50)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
            
            //            m_bottomViewHeightConstraint.constant=70
        }
        else if(Device.IS_IPHONE_XsMax)
        {
            print("Height ",tabBarController?.view.bounds.height," : Width ",tabBarController?.view.bounds.width)
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+50)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
        }
        else
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+10)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
        }
        
        menuButtonFrame.origin.y = yValue
        menuButtonFrame.origin.x = xValue
        menuButton.frame = menuButtonFrame
        menuButton.ShadowForView()
        menuButton.layer.masksToBounds=true
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        menuButton.backgroundColor = hexStringToUIColor(hex: hightlightColor)
        menuButton.setImage(UIImage(named:"Home-2"), for: .normal)
        menuButton.setBackgroundImage(UIImage(named: "blueEsclip"), for: .normal)
        menuButton.contentMode = .scaleAspectFill
        //        menuButton.setGradientBackground(colorTop: hexStringToUIColor(hex: "819ff6"), colorBottom: hexStringToUIColor(hex: "4b66ea"))
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        
        
        tabBarController?.view.addSubview(menuButton)
        //        view.layoutIfNeeded()
        
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        tabBarController!.selectedIndex = 2
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Enrollment Tapped
//    @objc func enrollmentProcess(_ sender:UITapGestureRecognizer)
//    {
//
//        //MyBenefits360 -Download Summary
//
//        if let isEnrollmentThroughtMB = UserDefaults.standard.value(forKey: "isEnrollmentThroughtMB") as? Bool {
//            if isEnrollmentThroughtMB {
//
//             if(!m_windowPeriodStatus)
//             {
//                     if(m_enrollmentStatus)
//                     {
//                         m_enrollmentStatusLbl.text="Download Summary"
//                         m_enrollmentStatusImgview.image=UIImage(named: "download-2")
//                         downloadEnrollmentSummery()
//                     }
//                     else
//                     {
//                        // showAlert(message: "You have still not completed your enrollment. Please login to FlexiBen Enrollment on web to complete your enrollment.")
//
//
//                        //Added by Geeta
//                        var groupChildSrNo = String()
//                        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
//                          if(userArray.count>0){
//                              m_employeeDict=userArray[0]
//                          }
//                              if(userArray.count>0){
//                                  if let groupChlNo = m_employeeDict?.groupChildSrNo{
//                                      groupChildSrNo=String(groupChlNo)
//                                      print("groupChildSrNo : \(groupChildSrNo)")
//                                  }
//                             }
//                        if groupChildSrNo == "1221" {
//                            moveToEnrollment()
//                        }else{
//                           //showAlertwithOk(message: "Please continue your enrollment on MyBenefits360 Web portal.")
//                            moveToEnrollment()
//                        }
//                     }
//             }
//             else {
//                 m_enrollmentStatusLbl.text="Download Summary"
//                 m_enrollmentStatusImgview.image=UIImage(named: "download-2")
//                 downloadEnrollmentSummery()
//            }
//
//
//            }
//    }
//    }
    
    
    
    //MARK:- Enrollment Tapped
    @objc func enrollmentProcessNew(_ sender:UITapGestureRecognizer)
    {
        print("Enrollment Window  called enrollmentProcessNew")
        if(isConnectedToNet()){
            print("m_windowPeriodStatus: ",m_windowPeriodStatus," getAdminStatus: ",getAdminStatus)
            if IsWindowPeriodOpenStatus == 1{
                let enrollWeb = UIStoryboard.init(name: "EnrollmentWebView", bundle: nil).instantiateViewController(withIdentifier:"EnrollmentWebView") as! EnrollmentWebView
                
                self.navigationController?.pushViewController(enrollWeb, animated: true)
                
            }else{
                if getAdminStatus{ //if admin setting not working
                    downloadEnrollmentSummery()
                    
                }
                else{
                    print("getAdminStatus: ",getAdminStatus)
                }
            }
        }
        else{
            self.displayActivityAlert(title: "No internet")
        }
        //New added on 21April2023
        /*
        let webView = true //Done for webview which is not yet started 08/03/23
        m_windowPeriodStatus = true
        if(m_windowPeriodStatus)
        {
            if(!m_enrollmentStatus)
            {
                if webView{
                    let enrollWeb = UIStoryboard.init(name: "EnrollmentWebView", bundle: nil).instantiateViewController(withIdentifier:"EnrollmentWebView") as! EnrollmentWebView
                    
                    self.navigationController?.pushViewController(enrollWeb, animated: true)
                }else{
                    m_enrollmentStatusLbl.text="Download Summary"
                    m_enrollmentStatusImgview.image=UIImage(named: "download-2")
                    //enrollmentSummaryFileLink()
                }
            }
            else
            {
                showAlert(message: "You have still not completed your enrollment. Please login to Benefits You India Enrollment on web to complete your enrollment.")
            }
        }
        else
        {
            m_enrollmentStatusLbl.text="Download Summary"
            m_enrollmentStatusImgview.image=UIImage(named: "download-2")
            //enrollmentSummaryFileLink()
            
        }
        */
        
    }
    
     func moveToEnrollment() {
        
        
        //let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"MainCollectionViewVC") as! MainCollectionViewVC
        //flexIntroVC.m_isEnrollmentConfirmed=m_enrollmentStatus
        //flexIntroVC.m_windowPeriodEndDate=m_windowPeriodEndDate
        //navigationController?.pushViewController(flexIntroVC, animated: true)
        
        //Commented on 14th March
        
        let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"EnrollmentNavigationController") as! EnrollmentNavigationController
        flexIntroVC.m_isEnrollmentConfirmed = m_enrollmentStatus
        flexIntroVC.m_windowPeriodEndDate = m_windowPeriodEndDate
        flexIntroVC.modalPresentationStyle = .fullScreen
        
 
        UserDefaults.standard.set(false, forKey: "isFromLogin")

        selectedGHI.isEmptyData = true
        selectedGPA.isEmptyData = true
        selectedGTL.isEmptyData = true
              
        self.navigationController?.present(flexIntroVC, animated: false, completion: nil)
         
        
        
        
    }
    
    
    func downloadEnrollmentSummery()
    {
        if(isConnectedToNetWithAlert())
        {
            
            //let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            
            //m_employeedict=userArray[0]
            
            userEmployeeSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String ?? ""
            userEmployeeSrnoGPA = UserDefaults.standard.value(forKey: "userEmployeeSrnoValueGPA") as? String ?? ""
            userEmployeeSrnoGTL = UserDefaults.standard.value(forKey: "userEmployeeSrnoValueGTL") as? String ?? ""
            
            if m_productCode == "GMC"{
                clickedEmpSrNo = userEmployeeSrno
            }
            else if m_productCode == "GPA"{
                clickedEmpSrNo = userEmployeeSrnoGPA
            }
            else if m_productCode == "GTL"{
                clickedEmpSrNo = userEmployeeSrnoGTL
            }
            
            print("clickedEmpSrNo::::",clickedEmpSrNo)
            
            var employeesrno = String()
            if let empNo = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String
            {
                employeesrno = String(empNo)
                print("employeesrno: ",employeesrno)
            }
            
            
            
            userEmployeIdNo = UserDefaults.standard.value(forKey: "userEmployeIdNoValue") as! String
            
            if !clickedEmpSrNo.isEmpty{
                var url = NSURL(string: WebServiceManager.getSharedInstance().enrollmentSummaryFileURL(employeesrno: clickedEmpSrNo))
                //NSURL(string : WebServiceManager.getSharedInstance().getEnrollmentSummery(employeesrno: employeesrno, name: employeeName, empID: employeeID))
                let searchURL = url//NSURL(string: url)
                // if url != ""{
                showPleaseWait(msg: "Please wait...")
                print("downloadEnrollmentSummery url: ",searchURL)
                
                var request = URLRequest(url: searchURL! as URL)
                
                let authString = String(format: "%@:%@",m_authUserName_Portal,m_authPassword_Portal)
                print("m_authUserName_Portal ",m_authUserName_Portal)
                print("m_authPassword_Portal ",m_authPassword_Portal)
                
                let authData = authString.data(using: String.Encoding.utf8)!
                let base64AuthString = authData.base64EncodedString()
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
                
                let session = URLSession(configuration: URLSessionConfiguration.default)
                
                let task = session.dataTask(with: request, completionHandler:
                                                {(data, response, error) -> Void in
                    print("Inside downloadEnrollmentSummery()")
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        print("downloadEnrollmentSummery httpResponse.statusCode: ",httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            if let dataValue = data {
                                do {
                                    // Parse the JSON response
                                    if let json = try JSONSerialization.jsonObject(with: dataValue, options: []) as? [String: Any] {
                                        print("json::::",json)
                                        let Status = json["Status"] as? Bool
                                        let respData = json["ResponseData"] as? [String:Any]
                                        print(respData)
                                        var fileUrl = respData?["FILE_URL"] as? String
                                        print("Status::::",Status)
                                        
                                        if Status == true{
                                            var urlstr = WebServiceManager.sharedInstance.downloadBaseUrl+fileUrl!
                                            self.saveSummaryJson(obj: urlstr)
                                        }
                                        else{
                                            self.displayActivityAlert(title: "Summary not available.")
                                        }
                                    }
                                }
                                catch
                                {
                                    Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                    print(error)
                                    self.hidePleaseWait()
                                }
                            }
                        }
                        else{
                            self.displayActivityAlert(title: "Summary not available.")
                        }
                    }
                    self.hidePleaseWait()
                })
                task.resume()
            }
            else{
                print("clickedEmpSrNo isEmpty",clickedEmpSrNo,".")
            }
            
        }
    }
    
    
    
    //MARK:- setEnrollmentData
    func setEnrollmentData()
    {
        self.m_enrollmentDetailLoader.stopAnimating()

        if let groupAdminBasic = UserDefaults.standard.value(forKey: "EnrollmentGroupAdminBasicSettings")
        {
            m_groupAdminBasicSettingsDict = groupAdminBasic as! NSDictionary
        }
        
        if let enrollmentMiscInfo = UserDefaults.standard.value(forKey: "EnrollmentMiscInformation")
        {
            m_enrollmentMiscInformationDict = enrollmentMiscInfo as! NSDictionary
        }
        
        if let enrollmentLifeEvent = UserDefaults.standard.value(forKey: "EnrollmentLifeEventInfo")
        {
            m_enrollmentLifeEventInfoDict = enrollmentLifeEvent as! NSDictionary
        }
        
        if let serverDate = m_groupAdminBasicSettingsDict.value(forKey: "Server_Date")as? String
        {
            m_serverDate = convertStringToDate(dateString: serverDate)
        }
        else
        {
            m_serverDate = Date()
        }
        print(m_serverDate)
        
        let dict : NSDictionary = openEnrollmentDict as NSDictionary
        let newJoineeDict : NSDictionary = newJoineeEnrollmentDict as NSDictionary
        var isStartDateForNewJoinee = String()
        if let date = dict.value(forKey: "WINDOW_PERIOD_START_DATE")as? String
        {
            let startDate = convertStringToDate(dateString:date)
            print("m_employeedict: ",m_employeedict)
            employeeDOJ = UserDefaults.standard.value(forKey: "employeeDOJValue") as! String
            //let joiningDate = convertStringToDate(dateString: (?.dtaeOfJoining)!)
            var joiningDate = getCurrentDate()
            if !employeeDOJ.isEmpty{
                joiningDate = convertStringToDate(dateString: (employeeDOJ))
            }
            else{
                print("employeeDOJ is empty ")
            }
            print(joiningDate)
            if(joiningDate>startDate)
            {
                print("m_groupAdminBasicSettingsDict:::",m_groupAdminBasicSettingsDict)
                let enrollmentType = m_groupAdminBasicSettingsDict.value(forKey: "ENROLMENT_TYPE") as? String
                print("enrollmentType::::",enrollmentType)
                if(enrollmentType=="ONGOING")
                {
                    //calculateRemainingDays()
                    if let endDate = dict.value(forKey: "WINDOW_PERIOD_END_DATE")as? String
                    {
                        if let isStartDateNewJoinee = newJoineeDict.value(forKey: "STARTS_FROM_DATE_OF_DATAINSERT")
                        {
                            isStartDateForNewJoinee=isStartDateNewJoinee as! String
                        }
                        let duration = newJoineeDict.value(forKey: "DATE_DURATION")as! String
                        
                        //MARK:- WP
                        m_windowPeriodEndDate = convertStringToDate(dateString:endDate)
                        if(isStartDateForNewJoinee == "YES")
                        {
                            if let dataInsertDate = m_employeedict?.dateofDataInsert
                            {
                                let dateofDataInsert = convertStringToDate(dateString: dataInsertDate)
                                
                                if let extensionDays = Int(duration)
                                {
                                    if let tomorrow = Calendar.current.date(byAdding:.day, value: extensionDays, to: dateofDataInsert)
                                    {
                                        m_windowPeriodEndDate=tomorrow
                                    }
                                }
                            }
                            
                        }
                        else if let extensionDays = Int(duration)
                        {
                            if let tomorrow = Calendar.current.date(byAdding:.day, value: extensionDays, to: joiningDate)
                            {
                                m_windowPeriodEndDate=tomorrow
                            }
                        }
                        calculateRemainingDays()
                    }
                }
            }
            else
            {
                if let date = dict.value(forKey: "WINDOW_PERIOD_END_DATE")as? String
                {
                    m_windowPeriodEndDate = convertStringToDate(dateString:date)
                    calculateRemainingDays()
                    
                }
            }
            
            
        }
        
        
       
    }
    
    //MARK:- Calculate Window Period
    /*func calculateRemainingDays()
    {
        //SHUBHAM COMMECTED FOR ENROLLMENT DAYS CALCULATION
        /*let dateRangeStart = m_serverDate
        let dateRangeEnd = m_windowPeriodEndDate
        var components = Calendar.current.dateComponents([.day,.weekOfYear, .month], from: dateRangeStart, to: dateRangeEnd)
        var days : Int = Calendar.current.dateComponents([.day], from: dateRangeStart, to: dateRangeEnd).day ?? 0
        days = days+1
        print("dateRangeStart: ",dateRangeStart)
        print("dateRangeEnd: ",dateRangeEnd)
        print("days: ",days)
        */
        
        //NEW CODE FOR ENROLLMENT DAYS CALCULATION BY SHUBHAM
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let m_serverDateString = dateFormatter.string(from: m_serverDate)
        let m_windowPeriodEndDateString = dateFormatter.string(from: m_serverDate)//dateFormatter.string(from: m_windowPeriodEndDate)
        
        print("m_serverDateString: ",m_serverDateString)
        print("m_windowPeriodEndDateString: ",m_windowPeriodEndDateString)
        
        let serverDate : String = m_serverDateString
        let endDate : String = m_windowPeriodEndDateString
        var days = 0
        var secondsDays = -1
        let calendarEnd = Calendar.current
        let calendarStart = Calendar.current

        let sdf = DateFormatter()
        sdf.dateFormat = "dd/MM/yyyy HH:mm:ss"
        //sdf.locale = Locale(identifier: "en_US_POSIX")
        sdf.locale = Locale(identifier: "en_IN")
        
        /*
        if let dateEnd = sdf.date(from: endDate + " 23:59:59"), let dateStart = sdf.date(from: serverDate + " 00:00:00") {
            var calendarEndComponents = calendarEnd.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateEnd)
            calendarEndComponents.hour = 23
            calendarEndComponents.minute = 59
            calendarEndComponents.second = 59
            
            if let calendarEndDate = calendarEnd.date(from: calendarEndComponents) {
                let calendarStartComponents = calendarStart.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateStart)
                
                let diff = calendarEndDate.timeIntervalSince(calendarStart.date(from: calendarStartComponents)!)
                let seconds = Int(diff)
                let minutes = seconds / 60
                let hours = minutes / 60
                days = hours / 24
                secondsDays = seconds
                print("calculateRemainingDays days: \(days)"," seconds: ",seconds," minutes: ",minutes," hours: ",hours," currentDate",currentDate)
                let daysCount = String(days)
            }
        }else{
            print("Date not calculated",days)
        }
        */
        
        // Get the current date and time
        let currentDate = Date()
        print("calculateRemainingDays currentDate:",currentDate)
        if let dateEnd = sdf.date(from: endDate + " 23:59:59") {
            var calendarEndComponents = calendarEnd.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateEnd)
            calendarEndComponents.hour = 23
            calendarEndComponents.minute = 59
            calendarEndComponents.second = 59

            let calendarEndDate = calendarEnd.date(from: calendarEndComponents)!
            let calendarStartComponents = calendarStart.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)

            let diff = calendarEndDate.timeIntervalSince(calendarStart.date(from: calendarStartComponents)!)
            let seconds = Int(diff)
            let minutes = seconds / 60
            let hours = minutes / 60
            days = hours / 24
            secondsDays = seconds
            print("calculateRemainingDays days: \(days)"," seconds: ", seconds," minutes: ", minutes," hours: ", hours)
            let daysCount = String(days)
        } else {
            print("Date not calculated", days)
        }

        print("serverDate: ",serverDate," : endDate: ",endDate," : days: ",days)
        
        if(secondsDays<=0)
        {
            
            m_windowPeriodStatusLbl.text="CLOSED"
            m_windowPeriodStatus=false
            m_daysLbl.isHidden=true
            m_daysLeftTitleLbl.isHidden=true
            enrollMentImageView.isHidden=false
            m_enrollmentStatusLbl.text="Download Summary"
            m_enrollmentStatusImgview.image=UIImage(named: "download-2")
            //            m_enrollmentStatusLbl.text="Add Dependants"
            //            m_enrollmentStatusImgview.image=UIImage(named: "add")
            cancelLocalNotifications()
        }
        else
        {
            m_windowPeriodStatusLbl.text="OPEN"
            m_windowPeriodStatus=true
            m_daysLbl.text = String(days)
            m_daysLbl.isHidden=false
            if days > 1 {
                m_daysLeftTitleLbl.text = "Days Left"
            }
            else {
                m_daysLeftTitleLbl.text = "Day Left"
            }
            m_daysLeftTitleLbl.isHidden=false
            enrollMentImageView.isHidden=true
            if(m_enrollmentStatus)
            {
                m_enrollmentStatusLbl.text="Download Summary"
                m_enrollmentStatusImgview.image=UIImage(named: "download-2")
                cancelLocalNotifications()
            }
            else
            {
                m_enrollmentStatusLbl.text="Continue Enrollment"
                m_enrollmentStatusImgview.image=UIImage(named: "continue")
                setLocalNotifications(startDate: Date(), endDate: m_windowPeriodEndDate)
                
            }
            
            self.m_enrollmentDetailLoader.stopAnimating()
        }
        
        //print(dateRangeStart)
        //print("difference is \(components.month ?? 0) months and \(components.weekOfYear ?? 0) weeks")
        
        
    }
    */
    func calculateRemainingDays() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let m_serverDateString = dateFormatter.string(from: m_serverDate)
        let m_windowPeriodEndDateString = dateFormatter.string(from: m_windowPeriodEndDate)

        print("m_serverDateString: ", m_serverDateString)
        print("m_windowPeriodEndDateString: ", m_windowPeriodEndDateString)

        let serverDate: String = m_serverDateString
        let endDate: String = m_windowPeriodEndDateString
        var days = 0
        var secondsDays = -1

        // Set the time zone to India (IST)
        var calendarEnd = Calendar.current
        calendarEnd.timeZone = TimeZone(identifier: "Asia/Kolkata")!

        var calendarStart = Calendar.current
        calendarStart.timeZone = TimeZone(identifier: "Asia/Kolkata")!

        let sdf = DateFormatter()
        sdf.dateFormat = "dd/MM/yyyy HH:mm:ss"
        sdf.locale = Locale(identifier: "en_IN")
        sdf.timeZone = TimeZone(identifier: "Asia/Kolkata")!

        // Get the current date and time in India (IST)
        let currentDate = Date()
        print("calculateRemainingDays currentDate:", sdf.string(from: currentDate))

        if let dateEnd = sdf.date(from: endDate + " 23:59:59") {
            var calendarEndComponents = calendarEnd.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateEnd)
            calendarEndComponents.hour = 23
            calendarEndComponents.minute = 59
            calendarEndComponents.second = 59

            //For testing Window period days
//        if let dateEnd = sdf.date(from: endDate + " 14:40:00") {
//            var calendarEndComponents = calendarEnd.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateEnd)

            let calendarEndDate = calendarEnd.date(from: calendarEndComponents)!
            let calendarStartComponents = calendarStart.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)

            let diff = calendarEndDate.timeIntervalSince(calendarStart.date(from: calendarStartComponents)!)
            let seconds = Int(diff)
            let minutes = seconds / 60
            let hours = minutes / 60
            days = hours / 24
            secondsDays = seconds
            print("calculateRemainingDays days: \(days)"," secondsDays: ", secondsDays," minutes: ", minutes," hours: ", hours)
        } else {
            print("Date not calculated", days)
        }

        print("serverDate: ",serverDate," : endDate: ",endDate," : days: ",days," secondsDays: ",secondsDays)

        if(secondsDays<=0)
        {
            
            //m_windowPeriodStatusLbl.text="CLOSED"
            //m_windowPeriodStatus=false
            //m_daysLbl.isHidden=true
            //m_daysLeftTitleLbl.isHidden=true
            enrollMentImageView.image=UIImage(named: "enrollment-1")
            //enrollMentImageView.isHidden=false
            //m_enrollmentStatusLbl.text="Download Summary"
            //m_enrollmentStatusLbl.text=self.enrollmentStatusData
            //m_enrollmentStatusImgview.image=UIImage(named: "download-2")
            //            m_enrollmentStatusLbl.text="Add Dependants"
            //            m_enrollmentStatusImgview.image=UIImage(named: "add")
            cancelLocalNotifications()
        }
        else
        {
            //m_windowPeriodStatusLbl.text="OPEN"
            //m_windowPeriodStatus=true
            m_daysLbl.text = String(days)
            //m_daysLbl.isHidden=false
            if days > 1 {
                m_daysLeftTitleLbl.text = "Days Left"
            }
            else {
                m_daysLeftTitleLbl.text = "Day Left"
            }
            //m_daysLeftTitleLbl.isHidden=false
            //enrollMentImageView.isHidden=true
            if(m_enrollmentStatus)
            {
                //m_enrollmentStatusLbl.text="Download Summary"
                //m_enrollmentStatusLbl.text=self.enrollmentStatusData
                //m_enrollmentStatusImgview.image=UIImage(named: "download-2")
                cancelLocalNotifications()
            }
            else
            {
                //m_enrollmentStatusLbl.text="Continue Enrollment"
                //m_enrollmentStatusLbl.text=self.enrollmentStatusData
                //m_enrollmentStatusImgview.image=UIImage(named: "continue")
                setLocalNotifications(startDate: Date(), endDate: m_windowPeriodEndDate)
                
            }
            
            self.m_enrollmentDetailLoader.stopAnimating()
        }
        
        //print(dateRangeStart)
        //print("difference is \(components.month ?? 0) months and \(components.weekOfYear ?? 0) weeks")
        
      
    }

    
    //MARK:- Set Local Notifications
    let options: UNAuthorizationOptions = [.alert, .sound]

    func setLocalNotifications(startDate:Date,endDate:Date) {
        // Swift
        
        var dateRangeArray = self.datesRange(from: startDate, to: endDate)
         print("Date Array-")
        print(dateRangeArray)
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
        center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

        if dateRangeArray.count > 0 {
            dateRangeArray.removeLast()

            
            for dateObj in dateRangeArray {
        
        
        let date = m_windowPeriodEndDate.getDateStrdd_mmm_yy()

        let content = UNMutableNotificationContent()
        content.title = "Enrollment Window"
        content.body = "Your Enrollment Window closes on \(date). Update your dependant details and confirm your benefits selections before closure of window."
        content.sound = UNNotificationSound.default()

        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                let gregorian = Calendar(identifier: .gregorian)

                var dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: dateObj)
               // dateComponents.year = 2020
                dateComponents.hour = 11
                dateComponents.minute = 0
                dateComponents.second = 0
                
                let identifier = "EnrollmentLocalNotification"
print(dateComponents)
                
                
                let datepp = gregorian.date(from: dateComponents)!

                let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: datepp)

                let trigger =  UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                

       // let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
                // Something went wrong
            }
        })
            }//for
    }
    }
    
    
    func cancelLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
        center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        
        print("From = \(from)")
        print("To = \(to)")

        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
    
    
    func setLayout()
    {
        
        automaticallyAdjustsScrollViewInsets=false
        
        m_scrollView.contentInset=UIEdgeInsets.zero
        m_scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        m_scrollView.contentOffset = CGPoint(x:0.0,y:0.0)
        
        
        let attributedString = NSMutableAttributedString(string:m_cliamProcedureNameLbl.text!)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing=0.20 // Whatever line spacing you want in points
        paragraphStyle.alignment=NSTextAlignment.center
        
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        m_cliamProcedureNameLbl.attributedText = attributedString
        
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        if !isJailbrokenDevice{
            //dataCalling()
        }
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        if self.locationManager != nil {
        self.locationManager.stopUpdatingLocation()
        }
        errorHandlerVCCounter = 0
    }
    
    func getClaims() {
        if isConnectedToNetWithAlert(){
            
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
            let urlString = WebServiceManager.getSharedInstance().getClaimDetailsPostUrl() as String
            let url = URL(string: urlString)!
            
            // Create the request body
            let requestBody="<DataRequest><groupchildsrno>\(groupChildSrNo)</groupchildsrno><employeesrno>\(employeesrno)</employeesrno></DataRequest>"
           // let requestBody="<DataRequest><groupchildsrno>1090</groupchildsrno><employeesrno>109492</employeesrno></DataRequest>"
            print("getClaims url: ",url)
            print("requestBody: ",requestBody)
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
            request.httpBody = requestBody.data(using: .utf8)
            
            //SSL Pinning
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
            sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
            TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
            let session = URLSession(
                configuration: sessionConfig,
                delegate: URLSessionPinningDelegate(),
                delegateQueue: nil)
            
            // Perform the request
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                    // Handle SSL connection failure
                    print("SSL connection error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.alertForLogout(titleMsg: error.localizedDescription)
                    }
                }else{
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        print("getClaims httpResponse.statusCode: ",httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            if let data = data {
                                // Process the response data
                                let responseString = String(data: data, encoding: .utf8)
                                print("Response: \(responseString ?? "")")
                                
                                var resposeData = responseString as! String
                                let claimsCount = self.countClaimsOccurrences(in: resposeData)
                                print("Claims count: \(claimsCount)")
                                self.claimCount = claimsCount
                                
                                DispatchQueue.main.sync {
                                    self.moduleCollectionView.reloadData()
                                }
                            }
                        }else{
                            self.claimCount = 0
                            DispatchQueue.main.async{
                                self.moduleCollectionView.reloadData()
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func countClaimsOccurrences(in xmlString: String) -> Int {
        let pattern = "<claims>"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: xmlString.utf16.count)
        let matches = regex.matches(in: xmlString, range: range)
        
        return matches.count
    }
    
    //XML not in from 01June23
    func getHospitalsCount()
    {
        if(isConnectedToNet())
        {
            var groupchildsrno = String()
            var oegrpbasinfsrno = String()
            
            if let childNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String{//m_employeedict?.groupChildSrNo {
                groupchildsrno = String(childNo)
                
            }
            if let oeinfNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String{//m_employeedict?.oe_group_base_Info_Sr_No {
                oegrpbasinfsrno = String(oeinfNo)
                
            }
            
            
            let urlString = WebServiceManager.getSharedInstance().getHospitalsCountUrl(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno, searchString: "All")
            let url = URL(string: urlString)!
            print("url: ",url)
            
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
            
            
            //SSL Pinning
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
            sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
            TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
            let session = URLSession(
                configuration: sessionConfig,
                delegate: URLSessionPinningDelegate(),
                delegateQueue: nil)
            // Perform the request
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                    // Handle SSL connection failure
                    print("SSL connection error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.alertForLogout(titleMsg: error.localizedDescription)
                    }
                }else{
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                            if let data = data {
                                // Process the response data
                                let responseString = String(data: data, encoding: .utf8)
                                print("Response: \(responseString ?? "")")
                                //                                let xml1 = try! XML.parse(responseString!)
                                //                                var element1 = xml1["DocumentElement"]["Hospitals"]["V_COUNT"]
                                //                                print("element1",element1)
                                var resposeData = responseString as! String
                                print(resposeData)
                                if resposeData.contains("V_COUNT"){
                                    var arr = resposeData.components(separatedBy: "<V_COUNT>")
                                    print(arr[0],arr[1])
                                    var arr10 = arr[1].components(separatedBy: "</V_COUNT>")
                                    var count = arr10[0]
                                    self.hospCount = count.currencyInputFormatting()
                                }else{
                                    self.hospCount = "0"
                                }
                                
                                
                                DispatchQueue.main.sync {
                                    self.moduleCollectionView.reloadData()
                                }
                            }
                        }else{
                            self.hospCount = "0"
                            DispatchQueue.main.async{
                                self.moduleCollectionView.reloadData()
                            }
                        }
                    }
                }
                
                
            }
            task.resume()
            
        }
        }
    
    
    
    func getPostHospitalDetails()
    {
        if(isConnectedToNetWithAlert())
        {
            
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            m_employeedict=userArray[0]
            
            var oegrpbasinfsrno = String()
            var groupChildSrNo = String()
            
            if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
            {
                oegrpbasinfsrno = String(empNo)
            }
            if let groupChlNo = m_employeedict?.groupChildSrNo
            {
                groupChildSrNo=String(groupChlNo)
            }
            
            
            
            let string="<DataRequest><groupchildsrno>\(groupChildSrNo)</groupchildsrno><oegrpbasinfsrno>\(oegrpbasinfsrno)</oegrpbasinfsrno><hospitalsearchtext>\("All")</hospitalsearchtext></DataRequest>"
            
            let uploadData = string.data(using: .utf8)
            
            
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getHospitalDetailsPostUrl() as String)
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            
            request.httpBody=uploadData
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if error != nil {
                    print("error ",error!)
                    self.hidePleaseWait()
                    //self.displayActivityAlert(title: m_errorMsg)
                    print("m_errorMsg: ",m_errorMsg)
                    self.m_hospitalActivityIndicator.stopAnimating()
                    self.m_hospitalsCountLbl.text="0 Hospitals"
                    //                    self.m_hospitalActivityIndicator.hidesWhenStopped
                    self.m_hospitalActivityIndicator.isHidden=true
                }
                else
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                            
                            self.xmlKey = "HospitalInformation"
                            let parser = XMLParser(data: data!)
                            parser.delegate = self as? XMLParserDelegate
                            parser.parse()
                            
                            
                            
                            DispatchQueue.main.async
                                {
                                    
                                    
                                    let count:Int = (self.hospitalResultsDictArray.count)
                                    if(count>0)
                                    {
                                        
                                        let countString : NSNumber =  self.hospitalResultsDictArray.count as NSNumber
                                        self.m_hospitalsCountLbl.text=countString.stringValue+" Hospitals"
                                        
                                        
                                    }
                                    else
                                    {
                                        self.m_hospitalsCountLbl.text="0 Hospitals"
                                    }
                                    
                                    self.m_hospitalActivityIndicator.stopAnimating()
                                    
                            }
                            
                        }
                        else
                        {
                            print("Can't cast response to NSHTTPURLResponse")
                            //self.displayActivityAlert(title: m_errorMsg)
                            print("m_errorMsg: ",m_errorMsg)
                             
                        }
                        
                    }
                }
                
                
            }
            task.resume()
            
        }
        else
        {
            displayActivityAlert(title: "No Internet Connection")
        }
    }
    @IBAction func profileTabSelected(_ sender: Any)
    {
        _ = Bundle.main.loadNibNamed("ProfileViewController", owner: self, options: nil)?[0];
        //        m_dateView.frame=view.frame
        //        view.addSubview(m_dateView)
        
        //        let profile : ProfileViewController = ProfileViewController()
        //        navigationController?.pushViewController(profile, animated: true)
    }
    
    @IBAction func homeTabSelected(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    func getDataSettings()
    {
        if(isConnectedToNet())
        {
            
            
            if m_userDict != nil
            {
                getDataSettingsUrl()
                getAdminSettingsUrl()
            }
            else
            {
                var employeeDetailsArray : Array<EMPLOYEE_INFORMATION> = []
                
                DispatchQueue.main.async(execute:
                    {
                        employeeDetailsArray = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
                        if(employeeDetailsArray.count>0)
                        {
                            self.m_userDict = employeeDetailsArray[0]
                            self.getDataSettingsUrl()
                            self.getAdminSettingsUrl()
                            
                        }
                })
            }
        }
        
        
        
        
        
    }
    
    func getDataSettingsUrl()
    {
        //        self.m_nameLbl.text="Hello, "+(m_userDict?.empIDNo!)! as String+"!"
        var groupchildsrno = String()
        var oegrpbasinfsrno = String()
        var employeesrno = String()
        
        if let childNo = m_userDict?.groupChildSrNo
        {
            groupchildsrno = String(childNo)
        }
        if let oeinfNo = m_userDict?.oe_group_base_Info_Sr_No
        {
            oegrpbasinfsrno = String(oeinfNo)
        }
        
        if let empSrNo = m_userDict?.empSrNo
        {
            employeesrno = String(empSrNo)
        }
        
        
        let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getEnrollmentDataSettings(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno, employeesrno: employeesrno))
        
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
            parser.delegate = self as XMLParserDelegate
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
    
    func getAdminSettingsUrl()
    {
        //        self.m_nameLbl.text="Hello, "+(m_userDict?.empIDNo!)! as String+"!"
        var groupchildsrno = String()
        var oegrpbasinfsrno = String()
        
        if let childNo = m_userDict?.groupChildSrNo
        {
            groupchildsrno = String(childNo)
        }
        if let oeinfNo = m_userDict?.oe_group_base_Info_Sr_No
        {
            oegrpbasinfsrno = String(oeinfNo)
        }
        
        var employeesrno = String()
        if let empSrNo = m_userDict?.empSrNo
        {
            employeesrno = String(empSrNo)
        }
        let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getAdminSettingsUrl(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno, employeesrno: employeesrno))
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = urlreq as URL?// NSURL(string: urlreq)
        request.httpMethod = "GET"
        
        
        
        let task = URLSession.shared.dataTask(with: urlreq! as URL)
        {
            (data, response, error) in
            
            if data == nil
            {
                
                return
            }
            self.xmlKey = "Adminsettings"
            let parser = XMLParser(data: data!)
            parser.delegate = self
            parser.parse()
            
            
            for dict in self.resultsDictArray!
            {
                let userDict : NSDictionary = dict as NSDictionary
                UserDefaults.standard.set(userDict, forKey: "AdminSettingsDic")
            }
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "isAlreadylogin")
            self.hidePleaseWait()
            
            
            
        }
        task.resume()
    }
    
   
    
    //MARK:- UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if(tabBarController.selectedIndex==1)
        {
            if(m_isFirstTime) {
                menuButton.isHidden=true
                m_isFirstTime=false
            }
            

                let alert = UIAlertController.init(title: "Do you want to download the E-card?", message: "", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("Cancel")
                }
                
                let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.cancel) {
                    (result : UIAlertAction) -> Void in
                    
                    alert.dismiss(animated: true, completion:nil)
                    //self.downloadEcard()
                    //self.downloadEcardPortal()
                    self.downloadEcardPortalJson()
                }
                
                alert.addAction(yesAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            
        }
    }
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    
    func downloadEcard()
    {
        if(isConnectedToNetWithAlert())
        {
            
            showPleaseWait(msg: """
Please wait...
Fetching E-card
""")
            let groupInfoArray  =  DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "GMC")
            let groupDict = groupInfoArray[0]
            let groupMasterArray  =  DatabaseManager.sharedInstance.retrieveGroupChildMasterDetails(productCode:"")
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            
            let groupMasterDict = groupMasterArray[0]
            
            if(userArray.count>0)
            {
                m_employeedict=userArray[0]
            }
            
            var empNo = String()
            if let empSrNo = m_employeedict?.empIDNo
            {
                empNo = String(empSrNo)
            }
            
            var policyNo : String = (groupDict.policyNumber as? String)!
            policyNo = policyNo.replacingOccurrences(of: "/", with: "~")
            
            
            var policyComDate : String = (groupDict.policyComencmentDate as? String)!
            policyComDate = policyComDate.replacingOccurrences(of: "/", with: "~")
            var policyValidUpto : String = (groupDict.policyValidUpto as? String)!
            policyValidUpto = policyValidUpto.replacingOccurrences(of: "/", with: "~")
            
            let groupCode : String = groupMasterDict.groupCode as! String
            
            let string="<DataRequest><tpacode>\(groupDict.tpa_Code ?? "")</tpacode><employeeno>\(empNo)</employeeno><policynumber>\(policyNo)</policynumber><policycommencementdt>\(policyComDate)</policycommencementdt><policyvaliduptodt>\(policyValidUpto)</policyvaliduptodt><groupcode>\(groupCode)</groupcode></DataRequest>"
            print(string)
            let uploadData = string.data(using: .utf8)
            
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getEcardDetailsPostUrl() as String)
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody=uploadData
            let session = URLSession(configuration: .default)
            
            var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
            var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

            let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
            print("m_authUserName_Portal ",encryptedUserName)
            print("m_authPassword_Portal ",encryptedPassword)
            
            let authData = authString.data(using: String.Encoding.utf8)!
            let base64AuthString = authData.base64EncodedString()
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
            authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
            print("authToken downloadEcard:",authToken)
            
            request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            print("downloadEcard url: ",request)
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if error != nil
                {
                    print("error ",error!)
                    self.hidePleaseWait()
                    //self.displayActivityAlert(title: m_errorMsg)
                    print("m_errorMsg: ",m_errorMsg)
                }
                else
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                            do {
                                self.xmlKey = "DocumentElement"
                                let parser = XMLParser(data: data!)
                                parser.delegate = self as? XMLParserDelegate
                                parser.parse()
                                print(self.resultsDictArray ?? "")
                                for obj in self.resultsDictArray!
                                {
                                    let status = obj["EcardInformation"]
                                    
                                    DispatchQueue.main.async(execute:
                                        {
                                            
                                            self.tabBarController?.selectedIndex=2
                                            
                                            if(status=="E-card under process")
                                            {
                                                self.displayActivityAlert(title: status!)
                                                self.hidePleaseWait()
                                            }
                                            else
                                            {
                                                self.saveEcard(obj:obj)
                                                
                                            }
                                            
                                            
                                    })
                                }
                                
                            }
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                                Crashlytics.crashlytics().record(error: JSONError as! Error)
                                self.hidePleaseWait()
                            }
                        }
                        else
                        {
                            self.hidePleaseWait()
                            //self.displayActivityAlert(title: m_errorMsg)
                            print("m_errorMsg: ",m_errorMsg)
                            print("else executed5")
                        }
                        
                    }
                    else
                    {
                        print("Can't cast response to NSHTTPURLResponse")
                        //self.displayActivityAlert(title: m_errorMsg)
                        print("m_errorMsg: ",m_errorMsg)
                        self.hidePleaseWait()
                        
                    }
                    
                }
            }
            
            task.resume()
            
            
        }
        else
        {
            self.hidePleaseWait()
        }
        
    }
    
    func downloadEcardPortal()
    {
        if(isConnectedToNetWithAlert())
        {
            
            showPleaseWait(msg: """
Please wait...
Fetching E-card
""")
            let groupInfoArray  =  DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "GMC")
            let groupDict = groupInfoArray[0]
            let groupMasterArray  =  DatabaseManager.sharedInstance.retrieveGroupChildMasterDetails(productCode:"")
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            
            let groupMasterDict = groupMasterArray[0]
            
            if(userArray.count>0)
            {
                m_employeedict=userArray[0]
            }
            
            var empNo = String()
            if let empSrNo = m_employeedict?.empIDNo
            {
                empNo = String(empSrNo)
            }
            
            var policyNo : String = (groupDict.policyNumber as? String)!
            policyNo = policyNo.replacingOccurrences(of: "/", with: "/")
            
            
            var policyComDate : String = (groupDict.policyComencmentDate as? String)!
            policyComDate = policyComDate.replacingOccurrences(of: "/", with: "/")
            var policyValidUpto : String = (groupDict.policyValidUpto as? String)!
            policyValidUpto = policyValidUpto.replacingOccurrences(of: "/", with: "/")
            
            let groupCode : String = groupMasterDict.groupCode as! String
            
            
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getEcardDetailsPostUrl() as String)
            
            
            
            let string = "<DataRequest><tpacode>\(groupDict.tpa_Code ?? "")</tpacode><employeeno>\(empNo)</employeeno><policynumber>\(policyNo)</policynumber><policycommencementdt>\(policyComDate)</policycommencementdt><policyvaliduptodt>\(policyValidUpto)</policyvaliduptodt><groupcode>\(groupCode)</groupcode></DataRequest>"
            
            //let string="<DataRequest><tpacode>HITS</tpacode><employeeno>MCXL01139</employeeno><policynumber>33180034210400000010</policynumber><policycommencementdt>01-03-2022</policycommencementdt><policyvaliduptodt>28-02-2023</policyvaliduptodt><groupcode>MCX1</groupcode></DataRequest>"
            
            print(string)
            print("URL E card: ",urlreq)
            let uploadData = string.data(using: .utf8)
         
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody=uploadData
            
            var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
            var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)
            
            let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
            print("m_authUserName_Portal ",encryptedUserName)
            print("m_authPassword_Portal ",encryptedPassword)
            
            let authData = authString.data(using: String.Encoding.utf8)!
            let base64AuthString = authData.base64EncodedString()
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
            authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
            print("authToken downloadEcardPortal:",authToken)
            
            request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            print("downloadEcardPortal url: ",request)
            
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
                else if error != nil
                {
                    print("error ",error!)
                    self.hidePleaseWait()
                    //self.displayActivityAlert(title: m_errorMsg)
                    print("m_errorMsg: ",m_errorMsg)
                }
                else
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        print("downloadEcardPortal: ",httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            do {
                                self.xmlKey = "DocumentElement"
                                let parser = XMLParser(data: data!)
                                parser.delegate = self as? XMLParserDelegate
                                parser.parse()
                                print(self.resultsDictArray ?? "")
                                for obj in self.resultsDictArray!
                                {
                                    let status = obj["EcardInformation"]
                                    
                                    DispatchQueue.main.async(execute:
                                        {
                                            
                                            self.tabBarController?.selectedIndex=2
                                            
                                            if(status=="E-card under process")
                                            {
                                                self.displayActivityAlert(title: status!)
                                                self.hidePleaseWait()
                                            }
                                            else
                                            {
                                                self.saveEcard(obj:obj)
                                                
                                            }
                                            
                                            
                                    })
                                }
                                
                            }
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                self.hidePleaseWait()
                            }
                        }else if httpResponse.statusCode == 404{
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: "E-card Not Found.")
                        }
                        else
                        {
                            self.hidePleaseWait()
                            //self.displayActivityAlert(title: m_errorMsg)
                            print("m_errorMsg: ",m_errorMsg)
                            print("else executed5")
                        }
                        
                    }
                    else
                    {
                        print("Can't cast response to NSHTTPURLResponse")
                        //self.displayActivityAlert(title: m_errorMsg)
                        print("m_errorMsg: ",m_errorMsg)
                        self.hidePleaseWait()
                        
                    }
                    
                }
            }
            task.resume()
        }
        else
        {
            self.hidePleaseWait()
        }
        
    }
    
    func downloadEcardPortalJson(){
        
        if(isConnectedToNetWithAlert())
        {
            
            showPleaseWait(msg: """
Please wait...
Fetching E-card
""")
            
            //tpacode
            TPA_CODE_GMC_Base =  UserDefaults.standard.value(forKey: "TPA_CODE_GMC_BaseValue") as! String
            print("TPA_CODE_GMC_Base: ",TPA_CODE_GMC_Base)
            var TPA_CODE_GMC_BaseEncrypt = try! AES256.encrypt(input: TPA_CODE_GMC_Base, passphrase: m_passphrase_Portal)
            print("TPA_CODE_GMC_Base encrypted : ",TPA_CODE_GMC_BaseEncrypt)
            
            //employeeno
            userEmployeIdNo = UserDefaults.standard.value(forKey: "userEmployeIdNoValue") as! String
            print("userEmployeIdNo: ",userEmployeIdNo)
            var userEmployeIdNoEncrypt = try! AES256.encrypt(input: userEmployeIdNo, passphrase: m_passphrase_Portal)
            print("userEmployeIdNo encrypted : ",userEmployeIdNoEncrypt)
            
            
            //policynumber
            POLICY_NUMBER_GMC_Base = UserDefaults.standard.value(forKey: "POLICY_NUMBER_GMC_Base") as! String
            print("POLICY_NUMBER_GMC_Base: ",POLICY_NUMBER_GMC_Base)
            var POLICY_NUMBER_GMC_BaseEncrypt = try! AES256.encrypt(input: POLICY_NUMBER_GMC_Base, passphrase: m_passphrase_Portal)
            print("POLICY_NUMBER_GMC_Base encrypted : ",POLICY_NUMBER_GMC_BaseEncrypt)
            
            
            //policycommencementdt
            POLICY_COMMENCEMENT_DATE_GMC_Base = UserDefaults.standard.value(forKey: "POLICY_COMMENCEMENT_DATE_GMC_Base") as! String
            print("POLICY_COMMENCEMENT_DATE_GMC_Base: ",POLICY_COMMENCEMENT_DATE_GMC_Base)
            var POLICY_COMMENCEMENT_DATE_GMC_BaseEncrypt = try! AES256.encrypt(input: POLICY_COMMENCEMENT_DATE_GMC_Base, passphrase: m_passphrase_Portal)
            print("POLICY_COMMENCEMENT_DATE_GMC_Base encrypted : ",POLICY_COMMENCEMENT_DATE_GMC_Base)
            
            //policyvaliduptodt
            POLICY_VALID_UPTO_GMC_Base = UserDefaults.standard.value(forKey: "POLICY_VALID_UPTO_GMC_Base") as! String
            print("POLICY_VALID_UPTO_GMC_Base: ",POLICY_VALID_UPTO_GMC_Base)
            var POLICY_VALID_UPTO_GMC_BaseEncrypt = try! AES256.encrypt(input: POLICY_VALID_UPTO_GMC_Base, passphrase: m_passphrase_Portal)
            print("POLICY_VALID_UPTO_GMC_Base encrypted : ",POLICY_VALID_UPTO_GMC_BaseEncrypt)
            
            
            //groupcode
            GROUPCODE = UserDefaults.standard.value(forKey: "groupCodeString") as! String
            print("GROUPCODE: ",GROUPCODE)
            var GROUPCODEEncrypt = try! AES256.encrypt(input: GROUPCODE, passphrase: m_passphrase_Portal)
            print("GROUPCODE encrypted : ",GROUPCODEEncrypt)
            
            //oegrpno
             userOegrpNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String ?? ""
            var oegrpNo = try! AES256.encrypt(input: userOegrpNo, passphrase: m_passphrase_Portal)
            print("oegrpNo encrypted : ",oegrpNo)
            
           
            
            
            print("Userdefaults downloadEcardPortalJson TPA_CODE_GMC_Base: ",TPA_CODE_GMC_Base," userEmployeIdNo: ",userEmployeIdNo," POLICY_NUMBER_GMC_Base:",POLICY_NUMBER_GMC_Base," POLICY_COMMENCEMENT_DATE_GMC_Base: ",POLICY_COMMENCEMENT_DATE_GMC_Base," POLICY_VALID_UPTO_GMC_Base: ",POLICY_VALID_UPTO_GMC_Base," GROUPCODE: ",GROUPCODE," oegrpNo:",userOegrpNo)
            
            let urlString = WebServiceManager.sharedInstance.getEcardDetailsPostUrlJSON(tpacode: TPA_CODE_GMC_BaseEncrypt.URLEncoded, employeeno: userEmployeIdNoEncrypt.URLEncoded, policynumber: POLICY_NUMBER_GMC_BaseEncrypt.URLEncoded, policycommencementdt: POLICY_COMMENCEMENT_DATE_GMC_BaseEncrypt.URLEncoded, policyvaliduptodt: POLICY_VALID_UPTO_GMC_BaseEncrypt.URLEncoded, groupcode: GROUPCODEEncrypt.URLEncoded,oegrpno: oegrpNo.URLEncoded)
            
            let url = URL(string:urlString)!
            
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = url as URL?
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
            print("authToken downloadEcardPortalJson:",authToken)
            
            request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            print("authToken: ",authToken)

            
            //SSL Pinning
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
            sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
            TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
            let session = URLSession(
                configuration: sessionConfig,
                delegate: URLSessionPinningDelegate(),
                delegateQueue: nil)
            
            print("downloadEcardPortalJson: ",urlString)
            
            // Create a data task with the URL session
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if let error = error {
                    print("downloadEcardPortalJson() Error: \(error.localizedDescription)")
                    return
                }
                
                // Check if a response was received
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("No response received")
                    return
                }
                
                
                
                print("downloadEcardPortalJson httpResponse.statusCode: ",httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
                    
                    if let data = data {
                        do {
                            // Parse the JSON response
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                if let message = json["message"] as? [String: Any],
                                   let eCard = message["ECard"] as? String {
                                    // Access the eCard URL
                                    print("ECard URL: \(eCard)")
                                    DispatchQueue.main.async{
                                        if eCard.contains("http"){
                                            self.saveEcardJson(obj: eCard)
                                        }
                                        else{
                                            
                                            if m_windowPeriodStatus{
                                                
                                                let alert = UIAlertController.init(title: "During_Enrollment_Header_ErrorMsg".localized(), message: "ecard_During_Enrollment_Details".localized(), preferredStyle: .alert)
                                                //let alert = UIAlertController.init()
                                                let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default) {
                                                    (result : UIAlertAction) -> Void in
                                                    print("Cancel")
                                                }
                                                
                                                // Create attributed strings with custom fonts, colors, and sizes
                                                let titleAttributes: [NSAttributedString.Key: Any] = [
                                                    .font: UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: 16) ?? UIFont.systemFont(ofSize: 16),
                                                    .foregroundColor: UIColor.black
                                                ]
                                                let messageAttributes: [NSAttributedString.Key: Any] = [
                                                    .font: UIFont(name: FontsConstant.shared.OpenSansRegular, size: 12) ?? UIFont.systemFont(ofSize: 12),
                                                    .foregroundColor: UIColor.darkGray
                                                ]
                                                
                                                let attributedTitle = NSAttributedString(string: "During_Enrollment_Header_ErrorMsg".localized(), attributes: titleAttributes)
                                                let attributedMessage = NSAttributedString(string: "ecard_During_Enrollment_Details".localized(), attributes: messageAttributes)
                                                
                                                alert.setValue(attributedTitle, forKey: "attributedTitle")
                                                alert.setValue(attributedMessage, forKey: "attributedMessage")
                                                
                                                
                                                alert.addAction(cancelAction)
                                                self.present(alert, animated: true, completion: nil)
                                                //self.displayActivityAlert(title: "")
                                            }
                                            else{
                                                
                                                let alert = UIAlertController.init(title: "During_PostEnrollment_Header_ErrorMsg".localized(), message: "ecard_During_PostEnrollment_Details".localized(), preferredStyle: .alert)
                                                //let alert = UIAlertController.init()
                                                let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default) {
                                                    (result : UIAlertAction) -> Void in
                                                    print("Cancel")
                                                }
                                                
                                                // Create attributed strings with custom fonts, colors, and sizes
                                                       let titleAttributes: [NSAttributedString.Key: Any] = [
                                                        .font: UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: 16) ?? UIFont.systemFont(ofSize: 16),
                                                           .foregroundColor: UIColor.black
                                                       ]
                                                       let messageAttributes: [NSAttributedString.Key: Any] = [
                                                        .font: UIFont(name: FontsConstant.shared.OpenSansRegular, size: 12) ?? UIFont.systemFont(ofSize: 12),
                                                           .foregroundColor: UIColor.darkGray
                                                       ]
                                                       
                                                      let attributedTitle = NSAttributedString(string: "During_PostEnrollment_Header_ErrorMsg".localized(), attributes: titleAttributes)
                                                       let attributedMessage = NSAttributedString(string: "ecard_During_PostEnrollment_Details".localized(), attributes: messageAttributes)

                                                alert.setValue(attributedTitle, forKey: "attributedTitle")
                                                alert.setValue(attributedMessage, forKey: "attributedMessage")

                                                
                                                alert.addAction(cancelAction)
                                                self.present(alert, animated: true, completion: nil)
                                                //self.displayActivityAlert(title: "")
                                            }
                                        }
                                    }
                                    self.hidePleaseWait()
                                    
                                } else {
                                    print("Invalid JSON format")
                                }
                            } else {
                                print("Invalid JSON format")
                            }
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                    else {
                        print("No data received")
                    }
                    
                    
                }
                else
                {
                    print("httpResponse.statusCode: ",httpResponse.statusCode)
                    self.hidePleaseWait()
                    //self.displayActivityAlert(title: m_errorMsg)
                    print("m_errorMsg: ",m_errorMsg)
                    print("else executed5")
                }
            }
            // Start the data task
            task.resume()
        }
        else
        {
            self.hidePleaseWait()
        }
    }
    
    
    func saveEcard(obj:[String:String])
    {
        
        if let fileName = obj["EcardInformation"]
        {
            showPleaseWait(msg: "Please wait...")
            DispatchQueue.main.async
                {
                    let url : NSString = fileName as NSString
                    var urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                    
                    if var searchURL : NSURL = NSURL(string: urlStr as String)
                    {
                        let request = URLRequest(url: searchURL as URL)
                        let session = URLSession(configuration: URLSessionConfiguration.default)
                        
                        let task = session.dataTask(with: request, completionHandler:
                        {(data, response, error) -> Void in
                            
                            let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                            
                            
                            if let fileName = searchURL.lastPathComponent
                            {
                                
                                let destinationUrl = documentsUrl.appendingPathComponent(fileName)!.appendingPathExtension("pdf")
                                
                                
                                if let data = data
                                {
                                    do
                                    {
                                        print(destinationUrl)
                                        try data.write(to: destinationUrl, options: .atomic)
                                        try self.openSelectedDocumentFromURL(documentURLString: destinationUrl.path)
                                        
                                        self.hidePleaseWait()
                                        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                                        //let documentsDirectory = paths[0]
                                        //print(documentsDirectory)
                                        //self.displayActivityAlert(title: "E-card downloaded")
                                    }
                                    catch
                                    {
                                        print(error)
                                        self.hidePleaseWait();
                                        Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                    }
                                    
                                    //self.documentController = UIDocumentInteractionController(url: destinationUrl!)
                                }
                                else
                                {
                                    self.hidePleaseWait()
                                    //Crashlytics.sharedInstance().recordError(m_errorMsg as! Error)
                                }
                            }
                            else
                            {
                                self.displayActivityAlert(title: "Policy issuance is in progress. E-card will be available soon")
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
            hidePleaseWait()
            displayActivityAlert(title: "File not found")
        }
        
        
    }
    
    func saveSummaryJson(obj:String)
    {
        var fileName = obj
        if !fileName.isEmpty || fileName != "NA"
        {
            showPleaseWait(msg: "Please wait...")
            DispatchQueue.main.async
                {
                    let url : NSString = fileName as NSString
                    print("url for summary: ",url)
                    var urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                    print("urlStr for summary: ",urlStr)
                    if var searchURL : NSURL = NSURL(string: urlStr as String)
                    {
                        let request = URLRequest(url: searchURL as URL)
                        print("searchURL url for summary: ",searchURL)
                        let session = URLSession(configuration: URLSessionConfiguration.default)
                        
                        let task = session.dataTask(with: request, completionHandler:
                        {(data, response, error) -> Void in
                            
                            let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                            
                            
                            if let fileName = searchURL.lastPathComponent
                            {
                                
                                let destinationUrl = documentsUrl.appendingPathComponent(fileName)!.appendingPathExtension("pdf")
                                
                                
                                if let data = data
                                {
                                    do
                                    {
                                        print(destinationUrl)
                                        try data.write(to: destinationUrl, options: .atomic)
                                        try self.openSelectedDocumentFromURL(documentURLString: destinationUrl.path)
                                        
                                        self.hidePleaseWait()
                                        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                                        //let documentsDirectory = paths[0]
                                        //print(documentsDirectory)
                                        //self.displayActivityAlert(title: "E-card downloaded")
                                    }
                                    catch
                                    {
                                        print(error)
                                        self.hidePleaseWait();
                                        Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                    }
                                    
                                    //self.documentController = UIDocumentInteractionController(url: destinationUrl!)
                                }
                                else
                                {
                                    self.hidePleaseWait()
                                    //Crashlytics.sharedInstance().recordError(m_errorMsg as! Error)
                                }
                            }
                            else
                            {
                                self.displayActivityAlert(title: "Policy issuance is in progress. E-card will be available soon")
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
            hidePleaseWait()
            displayActivityAlert(title: "File not found")
        }
        
        
    }
    
    func saveEcardJson(obj:String)
    {
        var fileName = obj
        if !fileName.isEmpty || fileName != "NA"
        {
            showPleaseWait(msg: "Please wait...")
            DispatchQueue.main.async
                {
                    let url : NSString = fileName as NSString
                    print("url for ecard: ",url)
                    var urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                    print("urlStr for ecard: ",urlStr)
                    if var searchURL : NSURL = NSURL(string: urlStr as String)
                    {
                        let request = URLRequest(url: searchURL as URL)
                        print("searchURL url for ecard: ",searchURL)
                        let session = URLSession(configuration: URLSessionConfiguration.default)
                        
                        let task = session.dataTask(with: request, completionHandler:
                        {(data, response, error) -> Void in
                            
                            let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                            
                            
                            if let fileName = searchURL.lastPathComponent
                            {
                                
                                let destinationUrl = documentsUrl.appendingPathComponent(fileName)!.appendingPathExtension("pdf")
                                
                                
                                if let data = data
                                {
                                    do
                                    {
                                        print(destinationUrl)
                                        try data.write(to: destinationUrl, options: .atomic)
                                        try self.openSelectedDocumentFromURL(documentURLString: destinationUrl.path)
                                        
                                        self.hidePleaseWait()
                                        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                                        //let documentsDirectory = paths[0]
                                        //print(documentsDirectory)
                                        //self.displayActivityAlert(title: "E-card downloaded")
                                    }
                                    catch
                                    {
                                        print(error)
                                        self.hidePleaseWait();
                                        Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                    }
                                    
                                    //self.documentController = UIDocumentInteractionController(url: destinationUrl!)
                                }
                                else
                                {
                                    self.hidePleaseWait()
                                    //Crashlytics.sharedInstance().recordError(m_errorMsg as! Error)
                                }
                            }
                            else
                            {
                                self.displayActivityAlert(title: "Policy issuance is in progress. E-card will be available soon")
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
            hidePleaseWait()
            displayActivityAlert(title: "File not found")
        }
        
        
    }
    
    
    //MARK:- Get Load Session Values
    func getMyCoveragesPostUrl()
    {
        if(isConnectedToNetWithAlert())
        {
            //            showPleaseWait()
            
            
            let uploadDic:NSDictionary=["mobileno":m_loginIDMobileNumber]
            
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getAppSessionValuesPostUrl() as String)
            
            
            let string="<DataRequest><mobileno>\(m_loginIDMobileNumber)</mobileno></DataRequest>"
            let uploadData = string.data(using: .utf8)
            
            
            
            
            
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
                    self.displayActivityAlert(title: "The request timed out")
                }
                else
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                            do {
                                
                                self.xmlKey = "GroupPoliciesEmployeesDependants"
                                let parser = XMLParser(data: data!)
                                parser.delegate = self as? XMLParserDelegate
                                parser.parse()
                                print(self.resultsDictArray ?? "")
                                
                                DispatchQueue.main.async(execute:
                                    {
                                        //                                let status = DatabaseManager.sharedInstance.deleteEmployeeDetails(productCode: self.m_productCode)
                                        if ((self.resultsDictArray?.count)!>0)
                                        {
                                            var userDict = NSDictionary()
                                            for i in 0..<self.resultsDictArray!.count
                                            {
                                                userDict = self.resultsDictArray![i] as NSDictionary
                                                
                                                
                                                
                                                let status = DatabaseManager.sharedInstance.deletePersonDetails(personSrNo: "")
                                                print(self.dependantsDictArray)
                                                if(status)
                                                {
                                                    for i in 0..<self.dependantsDictArray!.count
                                                    {
                                                        userDict = self.dependantsDictArray![i] as NSDictionary; DatabaseManager.sharedInstance.savePersonDetails(personDetailsDict: userDict)
                                                    }
                                                }
                                                
                                                print(userDict)
                                            }
                                            
                                            
                                        }
                                        else
                                        {
                                            //                                            self.displayActivityAlert(title: "Data not found")
                                        }
                                })
                                
                            }
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                self.hidePleaseWait()
                            }
                        }
                        else
                        {
                            self.hidePleaseWait()
                            Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                            print("else executed6")
                        }
                        
                    } else {
                        print("Can't cast response to NSHTTPURLResponse")
                        
                        self.hidePleaseWait()
                        
                    }
                    
                }
            }
            
            task.resume()
            
            
        }
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        hidePleaseWait()
        
        return self
    }
    private func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController
    {
        UINavigationBar.appearance().barTintColor = hexStringToUIColor(hex: hightlightColor)
        UINavigationBar.appearance().tintColor = hexStringToUIColor(hex: hightlightColor)
        UINavigationBar.appearance().backgroundColor = hexStringToUIColor(hex: hightlightColor)
        return self
    }
    private func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController)
    {
        //        controller.rele
        
    }
    func openSelectedDocumentFromURL(documentURLString: String) throws {
        DispatchQueue.main.async()
            {
                //code
                print("Inside openSelectedDocumentFromURL: ",documentURLString)
                if let documentURL: NSURL? = NSURL(fileURLWithPath: documentURLString)
                {
                    UINavigationBar.appearance().barTintColor = self.hexStringToUIColor(hex: hightlightColor)
                    UINavigationBar.appearance().tintColor = self.hexStringToUIColor(hex: hightlightColor)
                    UINavigationBar.appearance().backgroundColor = self.hexStringToUIColor(hex: hightlightColor)
                    UINavigationBar.appearance().titleTextAttributes = [
                        NSAttributedString.Key.foregroundColor: FontsConstant.shared.app_FontPrimaryColor
                    ]
                    documentController = UIDocumentInteractionController(url: documentURL as! URL)
                    documentController.delegate = self
                    documentController.presentPreview(animated: true)
                    self.hidePleaseWait()
                }
                
        }
        
    }
    
    
    // MARK: - UIDocumentInteractionViewController delegate methods
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        
        
        DispatchQueue.global(qos: .background).async{
            
            if let location:CLLocation = locations.last
            {
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                
                
                var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
                let ceo: CLGeocoder = CLGeocoder()
                center.latitude = self.latitude
                center.longitude = self.longitude
                
                let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
                
                
                ceo.reverseGeocodeLocation(loc, completionHandler:
                    {(placemarks, error) in
                        if (error != nil)
                        {
                            print("reverse geocode fail: \(error!.localizedDescription)")
                            self.hidePleaseWait()
                        }
                        else
                        {
                            do
                            {
                                if let pm = placemarks
                                {
                                    if pm.count > 0
                                    {
                                        if let pm = placemarks?[0]
                                        {
                                            if let subLocality = pm.postalCode
                                            {
                                                //print(pm)
                                                //                                                self.m_subLocality=subLocality
                                                var addressString : String = ""
                                                if pm.locality != nil
                                                {
                                                    addressString = addressString + pm.locality!
                                                }
                                                //print(addressString)
                                                self.m_addressString=addressString
                                                //                                    self.hidePleaseWait()
                                            }
                                            else
                                            {
                                                self.hidePleaseWait()
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                }
                                
                            }
                            catch
                            {
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                //                            self.displayActivityAlert(title: m_errorMsg)
                            }
                            
                        }
                })
            }
            
        }
        
        
        
        
    }
    
    
    
  
    func setupWellnessTabbar()
    {
        
//        let tabBarController = UITabBarController()
//
//        let tabViewController1 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
//        // tabViewController1.isAddMember = 1
//
//        let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
//
//
//        let tabViewController3 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"DashboardRootViewController") as! DashboardRootViewController
//        //let tabViewController3 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC // need to remove, added for testing
//        tabViewController3.fromInsurance = 1
//
//
//
//        let tabViewController4 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
//        let tabViewController5 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
//
//        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
//        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
//        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
//        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
//        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
//
//
//        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
//
//        tabBarController.viewControllers = controllers as? [UIViewController]
//
//        nav1.tabBarItem = UITabBarItem(
//            title: "Add Member",
//            image: UIImage(named: "adduser"),
//            tag: 1)
//
//        nav2.tabBarItem = UITabBarItem(
//            title: "History",
//            image:UIImage(named: "history") ,
//            tag:2)
//        nav3.tabBarItem = UITabBarItem(
//            title: "",
//            image: UIImage(named: ""),
//            tag: 1)
//        nav4.tabBarItem = UITabBarItem(
//            title: "Appointments",
//            image:UIImage(named: "appointment") ,
//            tag:2)
//        nav5.tabBarItem = UITabBarItem(
//            title: "Profile",
//            image:UIImage(named: "profile-1") ,
//            tag:2)
//        tabBarController.selectedIndex=2
//
//        //Set Bar tint color white
//        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
//
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
//
//        let colorSelected = Color.buttonBackgroundGreen.value
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
//
//        tabBarController.view.backgroundColor = UIColor.white
//
//        tabBarController.tabBar.tintColor = colorSelected
//        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
//
//        //Set Tab bar border color
//        //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
//        tabBarController.tabBar.layer.borderWidth = 0.5
//        tabBarController.tabBar.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
//        tabBarController.tabBar.clipsToBounds = true
//        tabBarController.tabBar.isHidden = false
//        tabBarController.tabBar.isUserInteractionEnabled = false
//
//        tabBarController.modalPresentationStyle = .fullScreen
//
//
//        self.present(tabBarController, animated: true)
//
        //...
    }
    
    //MARK:- Tabbar setup
    func setupFitnessTabbar()
    {
        
//        let tabBarController = UITabBarController()
//
//        let tabViewController1 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"CompeteChallengesVC") as! CompeteChallengesVC
//        // tabViewController1.isAddMember = 1
//
//        let tabViewController2 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"FitnessDashboardVC") as! FitnessDashboardVC
//
//        let tabViewController3 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"FitnessDashboardRootVC") as! FitnessDashboardRootVC
//        tabViewController3.isFromInsurance = 1
//
//        let tabViewController4 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"StatsFitnessVC") as! StatsFitnessVC
//
//        let tabViewController5 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"ProfileFitnessTVC") as! ProfileFitnessTVC
//
//        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
//        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
//        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
//        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
//        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
//
//        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
//
//        tabBarController.viewControllers = controllers as? [UIViewController]
//
//        nav1.tabBarItem = UITabBarItem(
//            title: "Compete",
//            image: UIImage(named: "star20x20"),
//            tag: 1)
//
//        nav2.tabBarItem = UITabBarItem(
//            title: "Rewards",
//            image:UIImage(named: "reward20x20") ,
//            tag:2)
//        nav3.tabBarItem = UITabBarItem(
//            title: "",
//            image: UIImage(named: ""),
//            tag: 1)
//        nav4.tabBarItem = UITabBarItem(
//            title: "Stats",
//            image:UIImage(named: "stat40x40") ,
//            tag:2)
//        nav5.tabBarItem = UITabBarItem(
//            title: "Profile",
//            image:UIImage(named: "profile-1") ,
//            tag:2)
//        tabBarController.selectedIndex=2
//
//
//        //Set Bar tint color white
//        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
//
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
//
//        let colorSelected = UIColor.orange
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
//
//        tabBarController.view.backgroundColor = UIColor.white
//
//        tabBarController.tabBar.tintColor = UIColor.orange
//        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
//
//        //Set Tab bar border color
//        //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
//        tabBarController.tabBar.layer.borderWidth = 0.5
//        tabBarController.tabBar.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
//        tabBarController.tabBar.clipsToBounds = true
//        tabBarController.tabBar.isHidden = false
//        tabBarController.tabBar.isUserInteractionEnabled = true
//
//        //tabBarController.modalTransitionStyle = .crossDissolve
//
//        tabBarController.modalPresentationStyle = .fullScreen
//        // self.present(tabBarController, animated: true)
//
//
//        //Present Home Vc
//
//        //Set Slide Menu Controller
//        // let homeVCObject = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "homeNavigationDrawer")
//
//        SlideMenuOptions.rightViewWidth = 280.0
//        SlideMenuOptions.contentViewScale = 1.0
//
//        let rightMenu = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier: "FitnessSlidemenuVC") as! FitnessSlidemenuVC
//
//        let slideMenuController = SlideMenuController(mainViewController: tabBarController, rightMenuViewController: rightMenu)
//
//        slideMenuController.modalPresentationStyle = .fullScreen
//        self.present(slideMenuController, animated: true)
        
        
    }
}


extension NewDashboardViewController :UICollectionViewDelegate,UICollectionViewDataSource {
    //MARK:- CollectionView Delegate
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if !isJailbrokenDevice{
                if collectionView == topCollectionView{
                    return self.servicesArray.count
                }
                else{
                    return self.model.count
                }
            }
            return 0
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !isJailbrokenDevice{
            if collectionView == moduleCollectionView{
                if indexPath.row < 4{
                    let noOfCellsInRow = 2   //number of column you want
                    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                    let totalSpace = flowLayout.sectionInset.left
                    + flowLayout.sectionInset.right
                    + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
                    
                    let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
                    return CGSize(width: size, height: 80)
                }
                else{
                    let noOfCellsInRow = 3   //number of column you want
                    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                    let totalSpace = flowLayout.sectionInset.left
                    + flowLayout.sectionInset.right
                    + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
                    
                    let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
                    return CGSize(width: size, height: 100)
                }
            }else{
                return CGSize(width: 158, height: 50)
            }
        }
        return CGSize(width: 0, height: 0)
         
    }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell : UICollectionViewCell = UICollectionViewCell()
            if !isJailbrokenDevice{
                if collectionView == topCollectionView{
                    let cell = UICollectionViewCell()
//                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForInsuranceTopView", for: indexPath) as! CellForInsuranceTopView
//
//                    let serviceName = servicesArray[indexPath.row]
//                    switch serviceName {
//                    case "Insurance":
//                        cell.lblname.text = "My Insurance"
//                        cell.imgView.image = UIImage(named: "insuranceg")
//                        cell.backgroundview.layer.cornerRadius = 6.0
//                        cell.backgroundview.setGradientBackground1(colorTop: hexStringToUIColor(hex: "0171d5"), colorBottom:hexStringToUIColor(hex: "5eb1fd"))
//                        cell.backgroundview.clipsToBounds = true
//
//                    case "Wellness":
//                        cell.lblname.text = "My Wellness"
//                        cell.imgView.image = UIImage(named: "wellnessg")
//                        cell.backgroundview.clipsToBounds = true
//                        cell.backgroundview.layer.cornerRadius = 6.0
//                        cell.backgroundview.setGradientBackground1(colorTop: Color.greenTop.value, colorBottom:Color.greenBottom.value)
//
//                    case "Fitness":
//                        cell.lblname.text = "My Fitness"
//                        cell.imgView.image = UIImage(named: "fitnessg")
//                        cell.backgroundview.clipsToBounds = true
//                        cell.backgroundview.layer.cornerRadius = 6.0
//                        cell.backgroundview.setGradientBackground1(colorTop: Color.redBottom.value, colorBottom:Color.redTop.value)
//
//                    default:
//                        break
//                    }
//
                    
                    return cell
                }else{
                    let cell : moduleCollectionViewCell = collectionView .dequeueReusableCell(withReuseIdentifier: "moduleCollectionViewCell", for: indexPath) as! moduleCollectionViewCell
                    setBottomShadow(view: cell.horizontalView)
                    setBottomShadow(view: cell.verticalView)
                    
                    if indexPath.row == 0{
                        cell.horizontalView.isHidden = false
                        cell.verticalView.isHidden = true
                        
                        cell.horizontalImg.image = UIImage(named: model[indexPath.row].modelImg)
                        cell.horizontalHeaderLbl.text = model[indexPath.row].modelName
                        var coveragesFamily = model[indexPath.row].modelDetails
                        print("indexPath.row 0",model[indexPath.row].modelDetails)
                        if coveragesFamily.isEmpty{
                            cell.horizontalDetailLbl.text = "-"
                        }
                        else{
                            cell.horizontalDetailLbl.text = model[indexPath.row].modelDetails
                        }
                    }
                    else if indexPath.row == 1{
                        cell.horizontalView.isHidden = false
                        cell.verticalView.isHidden = true
                        cell.horizontalImg.image = UIImage(named: model[indexPath.row].modelImg)
                        cell.horizontalHeaderLbl.text = model[indexPath.row].modelName
                        print("indexPath.row 1",model[indexPath.row].modelDetails)
                        if model[indexPath.row].modelName.lowercased() == "provider network" || model[indexPath.row].modelName.lowercased() == "my claims" ||
                            model[indexPath.row].modelName.lowercased() == "my queries"{
                            cell.horizontalDetailLbl.text = model[indexPath.row].modelDetails
                        }
                        else{
                            cell.horizontalDetailLbl.text = ""
                        }
                        
                    }
                    else if indexPath.row == 2 {
                        cell.horizontalView.isHidden = false
                        cell.verticalView.isHidden = true
                        cell.horizontalImg.image = UIImage(named: model[indexPath.row].modelImg)
                        cell.horizontalHeaderLbl.text = model[indexPath.row].modelName
                        print("indexPath.row 2",model[indexPath.row].modelDetails)
                        if model[indexPath.row].modelName.lowercased() == "provider network" || model[indexPath.row].modelName.lowercased() == "my claims" ||
                            model[indexPath.row].modelName.lowercased() == "my queries"{
                            cell.horizontalDetailLbl.text = model[indexPath.row].modelDetails
                        }
                        else{
                            cell.horizontalDetailLbl.text = ""
                        }
                        
                    }
                    else if indexPath.row == 3 {
                        cell.horizontalView.isHidden = false
                        cell.verticalView.isHidden = true
                        cell.horizontalImg.image = UIImage(named: model[indexPath.row].modelImg)
                        cell.horizontalHeaderLbl.text = model[indexPath.row].modelName
                        print("indexPath.row 3",model[indexPath.row].modelDetails)
                        if model[indexPath.row].modelName.lowercased() == "provider network" || model[indexPath.row].modelName.lowercased() == "my claims" ||
                            model[indexPath.row].modelName.lowercased() == "my queries"
                        {
                            cell.horizontalDetailLbl.text = model[indexPath.row].modelDetails
                        }
                        else{
                            cell.horizontalDetailLbl.text = ""
                        }
                    }
                    else{
                        print("model[indexPath.row].modelName: \(indexPath.row)",model[indexPath.row].modelName)
                        cell.horizontalView.isHidden = true
                        cell.verticalView.isHidden = false
                        
                        cell.verticalImg.image = UIImage(named: model[indexPath.row].modelImg)
                        cell.verticalHeaderLbl.text = model[indexPath.row].modelName
                    }
                    
                    
                    
                    return cell
                }
            }else{
                return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if !isJailbrokenDevice{
                if collectionView == topCollectionView{
                    if indexPath.row == 0 {
                        print("Insurance Tapped")
                    }
                    else if indexPath.row == 1 {
                        
                        print("Wellness Tapped")
                        //setupFitnessTabbar()
                        
                        setupWellnessTabbar()
                    }
                    else {
                        print("Fitness Tapped")
                        
                        if let isFirstTime = UserDefaults.standard.value(forKey: "isOnboardingFirstTime") as? Bool {
                            if isFirstTime {
                                //showProfilePage()
                                setupFitnessTabbar()
                                
                            }
                            else {
                                //Show Profile Page
                                setupFitnessTabbar()
                            }
                        }
                        else {
                            //Show Profile Page
                            //showProfilePage()
                            
                            setupFitnessTabbar()
                        }
                    }
                    
                    if dashboarCollectionViewdDelegate != nil {
                        dashboarCollectionViewdDelegate?.changeDashboardTapped(dashboard: indexPath.row)
                    }
                }else{
                    if model[indexPath.row].modelName.lowercased() == "my coverages"{
                        let myCoverages : MyCoveragesViewController = MyCoveragesViewController()
                        myCoverages.m_employeedict=m_userDict
                        navigationController?.pushViewController(myCoverages, animated: true)
                        let backItem = UIBarButtonItem()
                        backItem.title = ""
                        navigationItem.backBarButtonItem = backItem
                    }else if model[indexPath.row].modelName.lowercased() == "provider network"{
                        let networkHospitals : NetworkHospitalsViewController = NetworkHospitalsViewController()
                        print("addressString\(m_addressString)")
                        networkHospitals.m_addressString=m_addressString
                        networkHospitals.apiFlag = true
                        navigationController?.pushViewController(networkHospitals, animated: true)
                    }else if model[indexPath.row].modelName.lowercased() == "my claims"{
                        let myClaims:MyClaimsViewController = MyClaimsViewController()
                        navigationController?.pushViewController(myClaims, animated: true)
                    }
//                    else if model[indexPath.row].modelName.lowercased() == "my queries"{
//                        print("Queries tapped",UserDefaults.standard.value(forKey: "groupCodeString"))
//                        if let groupCode = UserDefaults.standard.value(forKey: "groupCodeString") as? String,groupCode != "" {
//                            if groupCode.uppercased() == "TCL" {
//                                showAlert(message: "Employee Queries not activated for your policy ")
//                            }
//                            else {
//                                let myQueries : MyQueriesViewController = MyQueriesViewController()
//                                navigationController?.pushViewController(myQueries, animated: true)
//                            }
//                        }
//                    }
                    else if model[indexPath.row].modelName.lowercased() == "claim\nprocedures"{
                        let claimProcedure : ClaimProcedureVC_New = ClaimProcedureVC_New()
                        
                        //let claimProcedure : ClaimProcedureVC = ClaimProcedureVC()
                        //let claimProcedure : ClaimProcedureViewController = ClaimProcedureViewController()
                        navigationController?.pushViewController(claimProcedure, animated: true)
                        
                    }
                    else if model[indexPath.row].modelName.lowercased() == "intimate\nnow"{
                        if let groupCode = UserDefaults.standard.value(forKey: "groupCodeString") as? String,groupCode != "" {
                            if groupCode.uppercased() == "TCL" {
                                showAlert(message: "Claim intimation clause not applicable for your policy")
                            }
                            else {
                                let intimation : MyIntimationViewController = MyIntimationViewController()
                                navigationController?.pushViewController(intimation, animated: true)
                            }
                        }
                        
                    }
                    else if model[indexPath.row].modelName.lowercased() == "policy\nfeatures"{
                        let policyFeatures : PolicyFeaturesViewController = PolicyFeaturesViewController()
                        navigationController?.pushViewController(policyFeatures, animated: true)
                    }
                    else if model[indexPath.row].modelName.lowercased() == "faqs"{
                        let faq : FAQViewController = FAQViewController()
                        navigationController?.pushViewController(faq, animated: true)
                    }
                    else if model[indexPath.row].modelName.lowercased() == "claim\nsubmission"{
                        
                        //let claimSubmission : ClaimDataUpload = ClaimDataUpload() //webview
                        
                        //let claimSubmission : ClaimContainerViewController = ClaimContainerViewController()
                        let claimSubmission : UploadedClaimsViewController = UploadedClaimsViewController()
                        navigationController?.pushViewController(claimSubmission, animated: true)
                        
//                        // Inside a button tap action handler or any relevant action where you want to start the multi-step process
//                        let dataUploadVC = ClaimDetailsFormViewController()
//                        let beneficiaryDetailsVC = ClaimBeneficiaryDetailsViewController()
//                        let fileUploadVC = ClaimFileUploadViewController()
//
//                        let customMultiStepVC = ClaimContainerViewController(viewControllers: [dataUploadVC, beneficiaryDetailsVC, fileUploadVC])
//
//                        // Customize the appearance and constraints of the progress bar, bottom navigation view, and buttons as needed
//
//                        // Present or push the custom multi-step view controller as needed
//                        self.navigationController?.pushViewController(customMultiStepVC, animated: true)

                    }
                }
            }
            
        }
}

extension NewDashboardViewController : XMLParserDelegate{
    //MARK:- Parse
    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
        relationsDictArray = []
        GTLTopupSumInsuredDictArray = []
        GPATopupSumInsuredDictArray = []
        GMCTopupSumInsuredDictArray = []
        GMCbaseSumInsuredDictArray = []
        GPAbaseSumInsuredDictArray = []
        GTLbaseSumInsuredDictArray = []
        
        
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
            self.currentValue = ""
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        self.currentValue? += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == xmlKey
        {
            resultsDictArray?.append(currentDictionary!)
            self.currentDictionary = [:]
            if(xmlKeysArray.contains(xmlKey))
            {
                indexNumber=indexNumber+1
                if(xmlKeysArray.count>indexNumber)
                {
                    xmlKey=xmlKeysArray[indexNumber]
                    print(xmlKey)
                }
            }
            
            
        }
        else if dictionaryKeys.contains(elementName)
        {
            
            if(elementName=="Relation")
            {
                relationsDictArray?.append(currentDictionary!)
            }
            else if(elementName=="OpenEnrollmentWindowPeriodInformation")
            {
                openEnrollmentDict=currentDictionary!
            }
            else if(elementName=="WindowPeriodForNewJoinee")
            {
                newJoineeEnrollmentDict=currentDictionary!
            }
            else if(elementName=="Dependant1"||elementName=="Dependant2"||elementName=="Dependant3"||elementName=="Dependant4"||elementName=="Dependant5"||elementName=="Dependant6"||elementName=="Dependant7"||elementName=="Dependant8")
            {
                dependantsDictArray?.append(currentDictionary!)
            }
            else if(elementName=="GMCTopupOptions")
            {
                print(m_productCode)
                GMCbaseSumInsuredDictArray?.append(currentDictionary!)
                if(m_productCode=="")
                {
                    GMCTopupSumInsuredDictArray?.append(currentDictionary!)
                }
                
                m_productCode="GMC"
                
            }
            else if(elementName=="GPATopupOptions")
            {
                print(m_productCode)
                GPAbaseSumInsuredDictArray?.append(currentDictionary!)
                if(m_productCode=="GMC")
                {
                    GPATopupSumInsuredDictArray?.append(currentDictionary!)
                }
                m_productCode="GPA"
                
            }
            else if(elementName=="GTLTopupOptions")
            {
                print(m_productCode)
                GTLbaseSumInsuredDictArray?.append(currentDictionary!)
                if(m_productCode=="")
                {
                    GTLTopupSumInsuredDictArray?.append(currentDictionary!)
                }
                m_productCode="GTL"
                
            }
            else if(elementName=="TopupSumInsuredVal")
            {
                
                if(m_productCode=="GMC")
                {
                    GMCTopupSumInsuredDictArray?.append(currentDictionary!)
                    
                }
                else if(m_productCode=="GPA")
                {
                    GPATopupSumInsuredDictArray?.append(currentDictionary!)
                }
                else if(m_productCode=="GTL")
                {
                    GTLTopupSumInsuredDictArray?.append(currentDictionary!)
                }
                
            }
            else if(elementName=="Hospitals")
            {
                if currentDictionary != nil { //Added By PSH 31st mar
                    print("hospitalResultsDictArray current : ",currentDictionary)
                hospitalResultsDictArray.append(currentDictionary!)
                }
            }
            else
            {
                if self.currentDictionary != nil
                {
                    self.currentDictionary![elementName] = currentValue
                    self.currentValue = ""
                    currentValue = nil
                }
            }
            
        }
        
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        currentValue = nil
                currentDictionary = nil
                resultsDictArray = nil
        
    }
}


extension NewDashboardViewController{
    func getPostHospitalDetailsJson(searchString:String){
        if(isConnectedToNetWithAlert())
        {
            if(searchString != "")
            {
//                self.hospitalActivityIndicator.startAnimating()
//                self.hospitalActivityIndicator.isHidden = false
                let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
                m_employeedict=userArray[0]
                
                var oegrpbasinfsrno = String()
                var groupChildSrNo = String()
                
                if let empNo = m_employeedict?.oe_group_base_Info_Sr_No{
                    oegrpbasinfsrno = String(empNo)
                }
                if let groupChlNo = m_employeedict?.groupChildSrNo{
                    groupChildSrNo=String(groupChlNo)
                }
                
                let requrl = "http://localhost:56803/api/Hospital/LoadProviders?groupchildsrno=1600&oegrpbasinfsrno=2180&hospitalsearchtext=ALL"
                
                EnrollmentServerRequestManager.serverInstance.getRequestDataFromServerPostNew(url: requrl, view: self) { (data, error) in
                    
                    if error == nil
                    {
                        do{
                            let d : Data = data!
                            let jsonData = try JSONDecoder().decode(HospitalInformation.self, from: d)
                            if jsonData.hospitalInformation.count > 0{
                                DatabaseManager.sharedInstance.deleteHospitalDetails(searchString: "")
                                var arrList = jsonData.hospitalInformation
                                
                                for i in 0..<arrList.count
                                {
                                    let dict : NSDictionary = arrList[i] as! NSDictionary
                                    
                                    DatabaseManager.sharedInstance.saveNetworkHospitalsDetails(contactDict: dict)
                                    
                                }
                                
                                
                                
                            }
                            
                            
                            
                            
                        }catch{
                            
                        }
                    }else{
                        
                    }
                    
                    
                    
                }
            }
        }
    }
    
    
    func dataCalling(){
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        
        print("Selected values ",selectedPolicyValue," : ",m_productCode)
        
        let status=UserDefaults.standard.object(forKey: "isAlreadylogin") as? Bool
        if(status==false||status==nil)
        {
            getDataSettings()
        }
        //        m_collectionView.frame.size.height=view.frame.size.height
        
        //old code
//        DispatchQueue.global().async {
//            DispatchQueue.main.async {
//                if CLLocationManager.locationServicesEnabled()
//                {
//                    self.locationManager = CLLocationManager()
//                    self.locationManager.delegate = self
//                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//
//                    self.locationManager.requestWhenInUseAuthorization()
//                    self.locationManager.startUpdatingLocation()
//                }
//            }
//        }
        
        if CLLocationManager.locationServicesEnabled() {
            let authorizationStatus = CLLocationManager.authorizationStatus()
            if authorizationStatus == .notDetermined {
                // Request authorization
                self.locationManager = CLLocationManager()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
            } else if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
                // Location services already authorized
                self.locationManager = CLLocationManager()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            } else {
//                let alertController = UIAlertController(title: "App does not have access to your location. To enable access, tap settings and turn on Location.", message: nil, preferredStyle: .alert)
//
//                        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
//                            if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
//                                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
//                            }
//                        }
//
//                        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//
//                        alertController.addAction(cancelAction)
//                        alertController.addAction(settingsAction)
//
//                        DispatchQueue.main.async {
//                            self.present(alertController, animated: true, completion: nil)
//                        }
                
                        // Handle denied or restricted authorization
            }
        }
        
        DispatchQueue.main.async {
            
            if self.m_productCode == "GMC"{
                self.model[2].modelDetails = "\(self.claimCount) Claims"
                self.model[1].modelDetails = "\(self.hospCount) Hospitals"
                if self.getGroupCode().uppercased() == "CNHI1"{
                    self.model[3].modelDetails = ""
                }else{
                   // self.model[3].modelDetails = self.m_queryCountLbl.text!
                }
            }else{
                self.model[1].modelDetails = "\(self.claimCount) Claims"
                self.model[3].modelDetails = ""
                if self.getGroupCode().uppercased() == "CNHI1"{
                    self.model[2].modelDetails = ""
                }else{
                   // self.model[2].modelDetails = self.m_queryCountLbl.text!
                }
            }
            self.moduleCollectionView.reloadData()
        }
    }
    
    func getPolicyCoveragesDetails_Data(){
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
            
            print("Userdefaults userGroupChildNo: ",userGroupChildNo," clickedOegrp: ",clickedOegrp," m_productCode:",m_productCode," clickedEmpSrNo: ",clickedEmpSrNo," employeeSrNoGMCValue: ",employeeSrNoGMCValue)
            
            
            if(!userGroupChildNo.isEmpty && !clickedOegrp.isEmpty && !clickedEmpSrNo.isEmpty)
            {
                
                    //showPleaseWait(msg: "Please wait...")
                    
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    var productType = String()
                    var employeesrno = String()
                    var employeesrnoGMC = String()
                    
                    if let childNo = userGroupChildNo as? String
                    {
                        groupchildsrno = String(childNo)
                        groupchildsrno = try! AES256.encrypt(input: groupchildsrno, passphrase: m_passphrase_Portal)
                        
                    }
                    
                    if selectedIndexPosition == 0{
                        if let oeinfNo = clickedOegrp as? String
                        {
                            print(oeinfNo)
                            oegrpbasinfsrno = String(oeinfNo)
                            oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                        }
                    }else{
                        oegrpbasinfsrno = selectedPolicyValue
                        oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                    
                    }
                    print("oegrpbasinfsrno Policy ",oegrpbasinfsrno)
                    
                    if let empNo = clickedEmpSrNo as? String
                    {
                        print(empNo)
                        employeesrno = String(empNo)
                        print(employeesrno)
                        employeesrno = try! AES256.encrypt(input: employeesrno, passphrase: m_passphrase_Portal)
                        
                    }
                    
                    if let empsrnoGMC = employeeSrNoGMCValue as? String
                    {
                        employeesrnoGMC = String(empsrnoGMC)
                        print("employeeSrNoGMCValue: ",employeesrnoGMC)
                        employeesrnoGMC = try! AES256.encrypt(input: employeesrnoGMC, passphrase: m_passphrase_Portal)
                    }
                    
                    let product = "GMC"
                    productType = m_productCode
                    
                    let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getPolicyCoveragesDetailsPortal(groupchildsrno: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded, productType: productType, employeeSrNo: employeesrno.URLEncoded, employeesrnoGMC: employeesrnoGMC.URLEncoded))
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?
                    request.httpMethod = "GET"
                    
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
                var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

                    let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
                    print("m_authUserName_Portal ",encryptedUserName)
                    print("m_authPassword_Portal ",encryptedPassword)
                    
                    let authData = authString.data(using: String.Encoding.utf8)!
                    let base64AuthString = authData.base64EncodedString()
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
                    authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                    print("authToken getPolicyCoveragesDetails_Data:",authToken)
                    
                    request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                    print("authToken: ",authToken)

                    print("getPolicyCoveragesDetails_Data url: ",urlreq)
                    
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
                            print("getPolicyCoveragesDetails_Data() error:", error)
                            return
                        }
                        else{
                            if let httpResponse = response as? HTTPURLResponse
                            {
                                print("getPolicyCoveragesDetails_Data httpResponse.statusCode: ",httpResponse.statusCode)
                                if httpResponse.statusCode == 200
                                {
                                    self.retryCountCoverages = 0
                                    do
                                    {
                                        guard let data = data else { return }
                                        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                                        
                                        print("JSON: ",json)
                                        
                                        if let data = json?["Coverages_Data"] as? [Any] {
                                            
                                            self.empolyeeDetailArray = json?["Coverages_Data"] as? [[String : Any]]
                                            self.relationDataArray.removeAll()
                                            //print("empolyeeDetailArray : ",self.empolyeeDetailArray)
                                            if self.empolyeeDetailArray?.count ?? 0 > 0
                                            {
                                                do{
                                                    //let status = try DatabaseManager.sharedInstance.deleteCoverageDetailsData(self.m_productCode)
                                                    for item in data {
                                                        if let object = item as? [String: Any] {
                                                            //                                                            if status{
                                                            //                                                                try DatabaseManager.sharedInstance.saveCoveragesDetails(contactDict: object as NSDictionary, productCode: self.m_productCode)
                                                            //                                                            }
                                                            // EMPLOYEE_IDENTIFICATION_NO
                                                            let EMPLOYEE_IDENTIFICATION_NO = object["EMPLOYEE_IDENTIFICATION_NO"] as? String ?? "0"
                                                            print("EMPLOYEE_IDENTIFICATION_NO: \(EMPLOYEE_IDENTIFICATION_NO)")
                                                            
                                                            // PERSON_NAME
                                                            let PERSON_NAME = object["PERSON_NAME"] as? String ?? ""
                                                            print("PERSON_NAME: \(PERSON_NAME)")
                                                            
                                                            // GENDER
                                                            let GENDER = object["GENDER"] as? String ?? ""
                                                            print("GENDER: \(GENDER)")
                                                            
                                                            // DATE_OF_BIRTH
                                                            let DATE_OF_BIRTH = object["DATE_OF_BIRTH"] as? String ?? "0"
                                                            print("DATE_OF_BIRTH: \(DATE_OF_BIRTH)")
                                                            
                                                            // AGE
                                                            let AGE = object["AGE"] as? String ?? "0"
                                                            print("AGE: \(AGE)")
                                                            
                                                            // SORT_ORDER
                                                            let SORT_ORDER = object["SORT_ORDER"] as? String ?? "0"
                                                            print("SORT_ORDER: \(SORT_ORDER)")
                                                            
                                                            // RELATION
                                                            let RELATION = object["RELATION"] as? String ?? "0"
                                                            print("RELATION: \(RELATION)")
                                                            
                                                            // BASE_SUM_INSURED
                                                            let BASE_SUM_INSURED = object["BASE_SUM_INSURED"] as? String ?? "0"
                                                            print("BASE_SUM_INSURED: \(BASE_SUM_INSURED)")
                                                            
                                                            // TOP_UP_FLAG
                                                            let TOP_UP_FLAG = object["TOP_UP_FLAG"]
                                                            print("TOP_UP_FLAG: \(TOP_UP_FLAG)")
                                                            
                                                            // TOP_UP_BASE_SUM_INSURED
                                                            let TOP_UP_BASE_SUM_INSURED = object["TOP_UP_BASE_SUM_INSURED"] as? String ?? "0"
                                                            
                                                            print("TOP_UP_BASE_SUM_INSURED: \(TOP_UP_BASE_SUM_INSURED)")
                                                            
                                                            self.relationDataArray.append(RELATION)
                                                        }
                                                    }
                                                    //self.policyDetailsArray = DatabaseManager.sharedInstance.retrieveCoveragesDetails(productCode: self.m_productCode)
                                                    print(self.policyDetailsArray)
                                                }catch{
                                                    print("Some error occured in Coverages_Data")
                                                }
                                            }
                                            else{
                                                self.displayActivityAlert(title: "No Data Found for Policy Coverages Details")
                                            }
                                        }
                                        else{
                                            self.errorState = 1
                                            print("Error Occured : errorstate ",self.errorState)
                                            
                                        }
                                        
                                        DispatchQueue.main.async
                                        {
                                            var msgData = "Error occured"
                                            print("empolyeeDetailArray Count : ",self.empolyeeDetailArray?.count)
                                            
                                            if let messageDict = json?["message"] as? [String: Any],
                                               let message = messageDict["Message"] as? String {
                                                print("Message: \(message)")
                                                msgData = message
                                                // Do something with the message value
                                            } else {
                                                print("Invalid JSON format or missing 'message' key")
                                            }
                                            
                                            
                                                print("Employee family data ",self.empolyeeDetailArray)
                                                print("relationArray family data ",self.relationDataArray)
                                            
                                            if self.errorState == 1{
                                                self.empolyeeDetailArray?.removeAll()
                                                self.relationDataArray.removeAll()
                                                self.sortFamilyData()
                                            }
                                            else{
                                                self.sortFamilyData()
                                            }
                                            self.getClaimsJson()
                                            self.getHospitalCountsJson()
                                            //self.getAllQueries()
                                            self.hidePleaseWait()
                                            
                                        }
                                    }catch let JSONError as NSError{
                                        print(JSONError)
                                        Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                        self.hidePleaseWait()
                                    }
                                }
                                else if httpResponse.statusCode == 401{
                                    self.retryCountCoverages+=1
                                    print("retryCountCoverages: ",self.retryCountCoverages)
                                    
                                    if self.retryCountCoverages <= self.maxRetryCoverage{
                                        print("Some error occured getPolicyCoveragesDetails_Data",httpResponse.statusCode)
//                                        self.getUserTokenGlobal(completion: { (data,error) in
//                                            self.getPolicyCoveragesDetails_Data()
//                                        })
                                        self.getPolicyCoveragesDetails_Data()
                                    }
                                    else{
                                        print("retryCountCoverages 401 else : ",self.retryCountCoverages)
                                        DispatchQueue.main.async
                                        {
                                            print("empolyeeDetailArray Count : ",self.empolyeeDetailArray?.count)
                                            self.empolyeeDetailArray?.removeAll()
                                            self.relationDataArray.removeAll()
                                            self.sortFamilyData()
                                            self.getClaimsJson()
                                            self.getHospitalCountsJson()
                                            self.hidePleaseWait()
                                        }
                                    }
                                }
                                else if httpResponse.statusCode == 400{
                                    DispatchQueue.main.sync(execute: {
                                        self.retryCountCoverages+=1
                                        print("retryCountCoverages: ",self.retryCountCoverages)
                                        
                                        if self.retryCountCoverages <= self.maxRetryCoverage{
                                            print("Some error occured getPolicyCoveragesDetails_Data",httpResponse.statusCode)
//                                            self.getUserTokenGlobal(completion: { (data,error) in
//                                                self.getPolicyCoveragesDetails_Data()
//                                            })
                                            self.getPolicyCoveragesDetails_Data()
                                        }
                                        else{
                                            print("retryCountCoverages 400 else : ",self.retryCountCoverages)
                                            DispatchQueue.main.async
                                            {
                                                print("empolyeeDetailArray Count : ",self.empolyeeDetailArray?.count)
                                                self.empolyeeDetailArray?.removeAll()
                                                self.relationDataArray.removeAll()
                                                self.sortFamilyData()
                                                self.getClaimsJson()
                                                self.getHospitalCountsJson()
                                                self.hidePleaseWait()
                                            }
                                        }
                                    })
                                }
                                else{
                                    self.policyDetailsArray = DatabaseManager.sharedInstance.retrieveCoveragesDetails(productCode: self.m_productCode)
                                    
                                    if self.policyDetailsArray.count != 0{
                                        for object in self.policyDetailsArray{
                                            // EMPLOYEE_IDENTIFICATION_NO
                                            let EMPLOYEE_IDENTIFICATION_NO = object.emp_id_no ?? ""//object["EMPLOYEE_IDENTIFICATION_NO"] as? String ?? "0"
                                            print("EMPLOYEE_IDENTIFICATION_NO: \(EMPLOYEE_IDENTIFICATION_NO)")
                                            
                                            // PERSON_NAME
                                            let PERSON_NAME = object.person_name ?? ""//object["PERSON_NAME"] as? String ?? ""
                                            print("PERSON_NAME: \(PERSON_NAME)")
                                            
                                            // GENDER
                                            let GENDER = object.gender ?? ""//object["GENDER"] as? String ?? ""
                                            print("GENDER: \(GENDER)")
                                            
                                            // DATE_OF_BIRTH
                                            let DATE_OF_BIRTH = object.dob ?? ""//object["DATE_OF_BIRTH"] as? String ?? "0"
                                            print("DATE_OF_BIRTH: \(DATE_OF_BIRTH)")
                                            
                                            // AGE
                                            let AGE = object.age ?? ""//object["AGE"] as? String ?? "0"
                                            print("AGE: \(AGE)")
                                            
                                            // SORT_ORDER
                                            let SORT_ORDER = object.sort_order ?? ""//object["SORT_ORDER"] as? String ?? "0"
                                            print("SORT_ORDER: \(SORT_ORDER)")
                                            
                                            // RELATION
                                            let RELATION = object.relation ?? ""//object["RELATION"] as? String ?? "0"
                                            print("RELATION: \(RELATION)")
                                            
                                            // BASE_SUM_INSURED
                                            let BASE_SUM_INSURED = object.base_sum_insured ?? ""//object["BASE_SUM_INSURED"] as? String ?? "0"
                                            print("BASE_SUM_INSURED: \(BASE_SUM_INSURED)")
                                            
                                            // TOP_UP_FLAG
                                            let TOP_UP_FLAG = object.top_up_flag ?? ""//object["TOP_UP_FLAG"]
                                            print("TOP_UP_FLAG: \(TOP_UP_FLAG)")
                                            
                                            // TOP_UP_BASE_SUM_INSURED
                                            let TOP_UP_BASE_SUM_INSURED = object.top_up_base_sum_insured ?? ""//object["TOP_UP_BASE_SUM_INSURED"] as? String ?? "0"
                                            
                                            print("TOP_UP_BASE_SUM_INSURED: \(TOP_UP_BASE_SUM_INSURED)")
                                            
                                            self.relationDataArray.append(RELATION)
                                        }
                                    }else{
                                        
                                    }
                                    DispatchQueue.main.async
                                    {
                                        print("empolyeeDetailArray Count : ",self.empolyeeDetailArray?.count)
                                        self.sortFamilyData()
                                        self.hidePleaseWait()
                                        
                                    }
                                }
                            }
                        }
                        
                        
                    }
                    apiRequestCoveragesData = task
                    apiRequestCoveragesData?.resume()
                
                
            }
            else{
                DispatchQueue.main.async
                {
                    self.empolyeeDetailArray?.removeAll()
                    self.relationDataArray.removeAll()
                    print("empolyeeDetailArray Count : ",self.empolyeeDetailArray?.count)
                    self.sortFamilyData()
                    self.getClaimsJson()
                    self.getHospitalCountsJson()
                    self.hidePleaseWait()
                }
            }
        }else{
            
            self.policyDetailsArray = DatabaseManager.sharedInstance.retrieveCoveragesDetails(productCode: self.m_productCode)
            
            if self.policyDetailsArray.count != 0{
                for object in self.policyDetailsArray{
                    // EMPLOYEE_IDENTIFICATION_NO
                    let EMPLOYEE_IDENTIFICATION_NO = object.emp_id_no ?? ""//object["EMPLOYEE_IDENTIFICATION_NO"] as? String ?? "0"
                    print("EMPLOYEE_IDENTIFICATION_NO: \(EMPLOYEE_IDENTIFICATION_NO)")
                    
                    // PERSON_NAME
                    let PERSON_NAME = object.person_name ?? ""//object["PERSON_NAME"] as? String ?? ""
                    print("PERSON_NAME: \(PERSON_NAME)")
                    
                    // GENDER
                    let GENDER = object.gender ?? ""//object["GENDER"] as? String ?? ""
                    print("GENDER: \(GENDER)")
                    
                    // DATE_OF_BIRTH
                    let DATE_OF_BIRTH = object.dob ?? ""//object["DATE_OF_BIRTH"] as? String ?? "0"
                    print("DATE_OF_BIRTH: \(DATE_OF_BIRTH)")
                    
                    // AGE
                    let AGE = object.age ?? ""//object["AGE"] as? String ?? "0"
                    print("AGE: \(AGE)")
                    
                    // SORT_ORDER
                    let SORT_ORDER = object.sort_order ?? ""//object["SORT_ORDER"] as? String ?? "0"
                    print("SORT_ORDER: \(SORT_ORDER)")
                    
                    // RELATION
                    let RELATION = object.relation ?? ""//object["RELATION"] as? String ?? "0"
                    print("RELATION: \(RELATION)")
                    
                    // BASE_SUM_INSURED
                    let BASE_SUM_INSURED = object.base_sum_insured ?? ""//object["BASE_SUM_INSURED"] as? String ?? "0"
                    print("BASE_SUM_INSURED: \(BASE_SUM_INSURED)")
                    
                    // TOP_UP_FLAG
                    let TOP_UP_FLAG = object.top_up_flag ?? ""//object["TOP_UP_FLAG"]
                    print("TOP_UP_FLAG: \(TOP_UP_FLAG)")
                    
                    // TOP_UP_BASE_SUM_INSURED
                    let TOP_UP_BASE_SUM_INSURED = object.top_up_base_sum_insured ?? ""//object["TOP_UP_BASE_SUM_INSURED"] as? String ?? "0"
                    
                    print("TOP_UP_BASE_SUM_INSURED: \(TOP_UP_BASE_SUM_INSURED)")
                    
                    self.relationDataArray.append(RELATION)
                }
            }else{
                
            }
            DispatchQueue.main.async
            {
                print("empolyeeDetailArray Count : ",self.empolyeeDetailArray?.count)
                self.sortFamilyData()
                self.hidePleaseWait()
                
            }
            
        }
    }
    
    
    
    func sortFamilyData(){
        print("Employee family data ",self.empolyeeDetailArray)
        print("relationArray family data ",self.relationDataArray)
        var familyDefinationArray = [String]()
        
        print("relationDataArray count: ",self.relationDataArray.count)
        if self.relationDataArray.count > 0{
            for i in 0..<self.relationDataArray.count
            {
                var relation = ""
                do{
                    relation = try self.relationDataArray[i].uppercased()
                }
                catch{
                    print("sortFamilyData() error:", error)
                }
                switch relation
                {
                case "EMPLOYEE":
                    if !familyDefinationArray.contains("E") {
                        familyDefinationArray.append("E")
                    }
                    break
                    
                case "SPOUSE":
                    familyDefinationArray.append("Sp")
                    break
                    
                case "HUSBAND":
                    familyDefinationArray.append("H")
                    break
                    
                case "PARTNER":
                    familyDefinationArray.append("P")
                    break
                    
                case "SON":
                    if  familyDefinationArray.contains("Sn1") &&
                        familyDefinationArray.contains("Sn2") &&
                        familyDefinationArray.contains("Sn3") {
                        
                        familyDefinationArray.append("Sn4")
                    }
                    else if familyDefinationArray.contains("Sn1") && familyDefinationArray.contains("Sn2") {
                        familyDefinationArray.append("Sn3")
                    }
                    else if familyDefinationArray.contains("Sn1") {
                        familyDefinationArray.append("Sn2")
                    }
                    else {
                        familyDefinationArray.append("Sn1")
                    }
                    break
    //                if  familyDefinationArray.contains("S1") &&
    //                        familyDefinationArray.contains("S2") &&
    //                        familyDefinationArray.contains("S3") {
    //
    //                    familyDefinationArray.append("S4")
    //                }
    //                else if familyDefinationArray.contains("S1") && familyDefinationArray.contains("S2") {
    //                    familyDefinationArray.append("S3")
    //                }
    //                else if familyDefinationArray.contains("S1") {
    //                    familyDefinationArray.append("S2")
    //                }
    //                else if familyDefinationArray.contains("S1"){
    //                    familyDefinationArray.append("S1")
    //                }
    //                break
                case "DAUGHTER":
                    
                    if familyDefinationArray.contains("D1") && familyDefinationArray.contains("D2") && familyDefinationArray.contains("D3") {
                        familyDefinationArray.append("D4")
                    }
                    else if familyDefinationArray.contains("D1") && familyDefinationArray.contains("D2") {
                        familyDefinationArray.append("D3")
                    }
                    else if familyDefinationArray.contains("D1") {
                        familyDefinationArray.append("D2")
                    }
                    else {
                        familyDefinationArray.append("D1")
                    }
                    //break
                    
                case "FATHER":
                    familyDefinationArray.append("F")
                    break
                case "MOTHER":
                    familyDefinationArray.append("M")
                    break
                case "FATHERINLAW","FATHER-IN-LAW":
                    familyDefinationArray.append("FIL")
                    break
                case "MOTHERINLAW","MOTHER-IN-LAW":
                    familyDefinationArray.append("MIL")
                    break
                    
                default:
                    break
                }
            }
        }
       
        
        
        var newArray : Array<String> = []
        newArray = familyDefinationArray
        for i in 0..<familyDefinationArray.count
        {
            let itemToRemove = ""
            if let index = newArray.index(of: itemToRemove)
            {
                newArray.remove(at: index)
            }
        }
        familyDefinationArray=newArray
        if(familyDefinationArray.count==1)
        {
            familyDefinationArray[0]="Employee"
        }
        print("familyDefinationArray family data ",familyDefinationArray)
        
        m_familyDefinationLbl.text = familyDefinationArray.joined(separator: "+")
        UserDefaults.standard.setValue(m_familyDefinationLbl.text!, forKey: "familyDefinition")
        model[0].modelDetails = m_familyDefinationLbl.text ?? "-"
        DispatchQueue.main.async{
            self.moduleCollectionView.reloadData()
        }
        
    }
    
    func addModules(){
        if model[1].modelName != "Provider Network"{
            var modelNetwork = modelMainArray(modelName: "Provider Network", modelDetails: "\(self.hospCount) Hospitals", modelImg: "NetworkHospital-1")
            model.insert(modelNetwork, at: 1)
            DispatchQueue.main.async{
                self.moduleCollectionView.reloadData()
            }
        }
        if model[2].modelName != "My Claims"{
            var modelNetwork = modelMainArray(modelName: "My Claims", modelDetails: "\(self.claimCount) Claims", modelImg: "MyClaims")
            model.insert(modelNetwork, at: 2)
            DispatchQueue.main.async{
                self.moduleCollectionView.reloadData()
            }
        }
        
        if model[4].modelName != "Intimate\nNow"{
            var modelNetwork = modelMainArray(modelName: "Intimate\nNow", modelDetails: "", modelImg: "IntimateClaim-1")
            model.insert(modelNetwork, at: 4)
            DispatchQueue.main.async{
                self.moduleCollectionView.reloadData()
            }
        }
    }
    
    
    func removeModules(){
        
        if model[1].modelName == "Provider Network"{
            model.remove(at: 1)
        }
        if model[1].modelName == "My Claims"{
            model.remove(at: 1)
        }
        if model[2].modelName == "Intimate\nNow"{
            model.remove(at: 2)
        }
    }
    
}

//Json API Call for Hospital and Claims
extension NewDashboardViewController{
    
    func getHospitalCountsJson(){
        if(isConnectedToNet())
        {
            
            var groupchildsrno = String()
            var oegrpbasinfsrno = String()
            var oegrpbasinfsrnoEncrypt = String()
            var groupchildsrnoEncrypt = String()
            
            if let childNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String{
                groupchildsrno = String(childNo)
                print("groupchildsrno: ",groupchildsrno)
                groupchildsrnoEncrypt = try! AES256.encrypt(input: groupchildsrno, passphrase: m_passphrase_Portal)
                print("groupchildsrno dycrypt: ",try! AES256.decrypt(input: groupchildsrnoEncrypt, passphrase: m_passphrase_Portal))
                
            }
            if let oeinfNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String{
                oegrpbasinfsrno = String(oeinfNo)
                print("oegrpbasinfsrno: ",oegrpbasinfsrno)
                oegrpbasinfsrnoEncrypt = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                print("oegrpbasinfsrno dycrypt: ",try! AES256.decrypt(input: oegrpbasinfsrnoEncrypt, passphrase: m_passphrase_Portal))
                
            }
            
            let urlString =  WebServiceManager.getSharedInstance().getHospitalsCountUrl(groupchildsrno: groupchildsrnoEncrypt.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrnoEncrypt.URLEncoded, searchString: "All")
            
            print("getHospitalCountsJson urlString : ",urlString)
            let url = URL(string: urlString)!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
            print("authToken getHospitalCountsJson:",authToken)
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
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if error == nil{
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        print("getHospitalCountsJson httpResponse.statusCode: ",httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            guard let data = data else {
                                print("No data received")
                                return
                            }
                            
                            do {
                                // Parse the JSON response
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    if let hospitalCount = json["HospitalCount"] as? Int {
                                        print("json for hospitalCount",json)
                                        print("HospitalCount: \(hospitalCount)")
                                        
                                        UserDefaults.standard.setValue(hospitalCount, forKey: "hospitalCountData")
                                        
                                        if hospitalCount > 0 && hospitalCount < 1000{
                                            self.hospCount = String(hospitalCount)
                                        }
                                        else{
                                            self.hospCount = String(hospitalCount).currencyInputFormatting()
                                        }
                                        DispatchQueue.main.async {
                                            self.m_hospitalsCountLbl.text="\(self.hospCount) Hospitals"
                                            
                                            self.m_hospitalActivityIndicator.stopAnimating()
                                            self.hospitalRefresh = true
                                            self.hideRefreshLoader()
                                            
                                        }
                                        
                                    } else {
                                        print("HospitalCount not found in the JSON response")
                                        DispatchQueue.main.async {
                                            self.m_hospitalsCountLbl.text="0 Hospitals"
                                            self.m_hospitalActivityIndicator.stopAnimating()
                                            self.hospitalRefresh = true
                                            self.hideRefreshLoader()
                                            
                                        }
                                    }
                                } else {
                                    print("Invalid JSON format")
                                    DispatchQueue.main.async {
                                        self.m_hospitalsCountLbl.text="0 Hospitals"
                                        self.m_hospitalActivityIndicator.stopAnimating()
                                        self.hospitalRefresh = true
                                        self.hideRefreshLoader()
                                        
                                    }
                                }
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            DispatchQueue.main.sync {
                                self.moduleCollectionView.reloadData()
                            }
                        }
                        else{
                            DispatchQueue.main.async{
                                self.m_hospitalsCountLbl.text="0 Hospitals"
                                self.m_hospitalActivityIndicator.stopAnimating()
                                self.hospCount = "0"
                                self.hospitalRefresh = true
                                self.moduleCollectionView.reloadData()
                                self.hideRefreshLoader()
                            }
                        }
                    }
                    self.dataCalling()
                }else{
                    DispatchQueue.main.sync{
                        //self.showAlertwithOk(message: "error")
                    }
                }
                
            }
            apiRequestHospitalCount = task
            apiRequestHospitalCount?.resume()
            
            hidePleaseWait()
            self.hospitalRefresh = true
            self.hideRefreshLoader()
        }
        else{
            displayActivityAlert(title: "No Internet Connection")
            self.m_hospitalsCountLbl.text="0 Hospitals"
            self.hideRefreshLoader()
        }
    }
    
    func getClaimsJson(){
        if(isConnectedToNet())
        {
            
            
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
            
            if (!userGroupChildNo.isEmpty && !clickedEmpSrNo.isEmpty){
            showPleaseWait1(msg: """
Please wait...
Fetching Claims
""")
                var userGroupChildNoData = userGroupChildNo
                               print("userGroupChildNoData decrypted: ",userGroupChildNoData)
                               userGroupChildNoData = try! AES256.encrypt(input: userGroupChildNoData, passphrase: m_passphrase_Portal)
                               print("userGroupChildNoData encrypted: ",userGroupChildNoData)
                               
                               var clickedEmpSrNoData = clickedEmpSrNo
                               print("clickedEmpSrNoData decrypted: ",clickedEmpSrNoData)
                               clickedEmpSrNoData = try! AES256.encrypt(input: clickedEmpSrNoData, passphrase: m_passphrase_Portal)
                               print("clickedEmpSrNoData encrypted: ",clickedEmpSrNoData)
                let urlString = WebServiceManager.sharedInstance.getClaimDetailsPostUrlJson(groupChildSrNo: userGroupChildNoData.URLEncoded, employeesrno: clickedEmpSrNoData.URLEncoded)
            //let urlString = WebServiceManager.sharedInstance.getClaimDetailsPostUrlJson(groupChildSrNo: "1529", employeesrno: "89181")
            
            let url = URL(string: urlString)!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
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
                    print("getClaimsJson() Error: \(error.localizedDescription)")
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
                    if let data = data {
                        do {
                            // Parse the JSON response
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                if let claimInformation = json["ClaimInformation"] as? [[String: Any]] {
                                    // Count the CLAIM_SR_NO occurrences
                                    let claimSrNoCount = claimInformation.reduce(0) { (count, claim) -> Int in
                                        if let claimSrNo = claim["CLAIM_SR_NO"] as? String {
                                            return count + 1
                                        }
                                        return count
                                    }
                                    
                                    print("CLAIM_SR_NO count: \(claimSrNoCount)")
                                    
                                    
                                    DispatchQueue.main.sync {
                                        self.claimCount = claimSrNoCount
                                        self.moduleCollectionView.reloadData()
                                    }
                                } else {
                                    print("Invalid JSON format")
                                    self.claimCount = 0
                                    
                                    DispatchQueue.main.sync {
                                        self.moduleCollectionView.reloadData()
                                    }
                                    
                                }
                            } else {
                                print("Invalid JSON format")
                                self.claimCount = 0
                                
                                DispatchQueue.main.sync {
                                    self.moduleCollectionView.reloadData()
                                }
                                
                            }
                            self.dataCalling()
                        }
                        catch {
                            print("Error parsing JSON: \(error)")
                        }
                    } else {
                        print("No data received")
                        self.claimCount = 0
                        
                        DispatchQueue.main.sync {
                            self.moduleCollectionView.reloadData()
                        }
                        
                    }
                }
                else if httpResponse.statusCode == 401{
                    self.retryCountClaims+=1
                    print("retryCountClaims: ",self.retryCountClaims)
                    
                    if self.retryCountClaims <= self.maxRetryClaims{
                        print("Some error occured getClaimsJson",httpResponse.statusCode)
                        self.getClaimsJson()
                    }
                    else{
                        print("retryCountClaims 401 else : ",self.retryCountClaims)
                        DispatchQueue.main.async
                        {
                            self.claimCount = 0
                            self.moduleCollectionView.reloadData()
                            self.hideRefreshLoader()
                            self.hidePleaseWait()
                            
                        }
                    }
                }
                else if httpResponse.statusCode == 400{
                    self.retryCountClaims+=1
                    print("retryCountClaims: ",self.retryCountClaims)
                    
                    if self.retryCountClaims <= self.maxRetryClaims{
                        print("Some error occured getClaimsJson",httpResponse.statusCode)
                        self.getClaimsJson()
                    }
                    else{
                        print("retryCountClaims 400 else : ",self.retryCountClaims)
                        DispatchQueue.main.async
                        {
                            self.hideRefreshLoader()
                            self.hidePleaseWait()
                            print("else executed1 getClaimsJson")
                            self.claimCount = 0
                            self.moduleCollectionView.reloadData()
                        }
                    }
                }
                else if httpResponse.statusCode == 404{
                    
                    DispatchQueue.main.sync{
                        self.hideRefreshLoader()
                        self.hidePleaseWait()
                        print("else executed1 getClaimsJson")
                        self.claimCount = 0
                        self.moduleCollectionView.reloadData()
                    }
                }
                else {
                    print("Request failed with status code: \(httpResponse.statusCode)")
                }
                
            }
            task.resume()
        }else{
            //DispatchQueue.main.sync{
                self.claimCount = 0
                self.moduleCollectionView.reloadData()
            //}
        }
        }
        else{
            self.displayActivityAlert(title: "No internet")
        }
    }
    
    
    func getEnrollStatus(){
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
            
            print("getEnrollStatus Userdefaults userGroupChildNo: ",userGroupChildNo," clickedOegrp: ",clickedOegrp," m_productCode:",m_productCode," clickedEmpSrNo: ",clickedEmpSrNo," employeeSrNoGMCValue: ",employeeSrNoGMCValue)
            
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
                    
                let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getEnrollStatusUrlPortal(employeesrno: employeesrno.URLEncoded, GroupChildSrNo: groupchildsrno.URLEncoded, OeGrpBasInfSrNo: oegrpbasinfsrno.URLEncoded))
                
                //let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getEnrollStatusUrlPortal(employeesrno: "91728", GroupChildSrNo: "1531", OeGrpBasInfSrNo: "1588"))
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?
                    request.httpMethod = "POST"
                    
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                    print("authToken getEnrollStatus:",authToken)
                 
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
                  
                    
                    print("getEnrollStatus url: ",urlreq)
                    
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
                        print("getEnrollStatus() error:", error)
                        return
                    }
                    else
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            print("getEnrollStatus httpResponse.statusCode: ",httpResponse.statusCode)
                            
                            if httpResponse.statusCode == 200
                            {
                                do {
                                    
                                    if let data = data, let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                                    {
                                        print("getEnrollStatus jsonResult ",jsonResult)
                                        if(jsonResult.count>0)
                                        {
                                            DispatchQueue.main.async
                                            {
                                                
                                                if let message = jsonResult.value(forKey: "message")
                                                {
                                                    let dict : NSDictionary = (message as? NSDictionary)!
                                                    let status = dict.value(forKey: "Status") as! Bool
                                                    print("status for getEnrollStatus :",status)
                                                    if(status)
                                                    {
                                                        self.IsEnrollmentSavedStatus = jsonResult.value(forKey: "IsEnrollmentSaved") as? Int ?? -1
                                                        self.IsWindowPeriodOpenStatus = jsonResult.value(forKey: "IsWindowPeriodOpen") as? Int ?? -1
                                                        print("IsEnrollmentSavedStatus: ",self.IsEnrollmentSavedStatus," IsWindowPeriodOpenStatus: ",self.IsWindowPeriodOpenStatus)
                                                        self.setEnrollmentWindowStatus()
                                                    }
                                                    else
                                                    {
                                                        print("Status false for getEnrollStatus()")
                                                    }
                                                }
                                                self.hideRefreshLoader()
                                            }
                                            print(jsonResult.allKeys)
                                        }
                                        else
                                        {
                                            let deadlineTime = DispatchTime.now() + .seconds(1)
                                            DispatchQueue.main.asyncAfter(deadline: deadlineTime)
                                            {
                                                self.hideRefreshLoader()
                                            }
                                        }
                                    }
                                } catch let JSONError as NSError
                                {
                                    Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                    print(JSONError)
                                    
                                }
                            }else if httpResponse.statusCode == 401 || httpResponse.statusCode == 400{
                                
                                    self.retryCountEnrollStatus+=1
                                    print("retryCountEnrollStatus: ",self.retryCountEnrollStatus)
                                    
                                    if self.retryCountEnrollStatus <= self.maxretryCountEnrollStatus{
                                        print("Some error occured getEnrollStatusJson",httpResponse.statusCode)
                                        self.getEnrollStatus()
                                    }
                                    else{
                                        print("retryCountEnrollStatus 401 else : ",self.retryCountEnrollStatus)
                                        DispatchQueue.main.async
                                        {
                                            self.IsEnrollmentSavedStatus = 0
                                            self.IsWindowPeriodOpenStatus = 0
                                            print("IsEnrollmentSavedStatus: ",self.IsEnrollmentSavedStatus," IsWindowPeriodOpenStatus: ",self.IsWindowPeriodOpenStatus)
                                            self.setEnrollmentWindowStatus()
                                        }
                                    }
                            }
                            else
                            {
                                self.hideRefreshLoader()
                                self.hidePleaseWait()
                                print("else executed newdashboard getEnrollStatus")
                                DispatchQueue.main.async
                                {
                                    self.IsEnrollmentSavedStatus = 0
                                    self.IsWindowPeriodOpenStatus = 0
                                    print("IsEnrollmentSavedStatus: ",self.IsEnrollmentSavedStatus," IsWindowPeriodOpenStatus: ",self.IsWindowPeriodOpenStatus)
                                    self.setEnrollmentWindowStatus()
                                }
                            }
                        }
                        else
                        {
                            print("Can't cast response to NSHTTPURLResponse")
                            self.hideRefreshLoader()
                            print("m_errorMsg ",m_errorMsg)
                            self.hidePleaseWait()
                        }
                        
                        DispatchQueue.main.async{
                            
                        }
                    }
                }
                    task.resume()
                
            }else{
                DispatchQueue.main.async
                {
                    
                }
            }
        }else{
            DispatchQueue.main.async
            {
              
            }
        }
    }
    

    func setEnrollmentWindowStatus(){
        /*          00 nothing
         01 window open add dependant
         11 window open continue enrollment
         10 download summary          */
        if self.IsEnrollmentSavedStatus == 0 && self.IsWindowPeriodOpenStatus == 0{
            m_windowPeriodStatus = false
            self.m_windowPeriodStatusLbl.text = "CLOSED"
            self.m_daysLbl.isHidden = true
            self.m_daysLeftTitleLbl.isHidden = true
            self.enrollmentStatusData = ""
            self.m_enrollmentStatusLbl.text = self.enrollmentStatusData
            self.m_enrollmentStatusImgview.image=UIImage(named: "")
            self.enrollMentImageView.isHidden = false
            self.m_daysLeftTitleLbl.isHidden = true
            self.m_daysLbl.isHidden = true
            }
        else if self.IsEnrollmentSavedStatus == 0 && self.IsWindowPeriodOpenStatus == 1{
            m_windowPeriodStatus = true
            self.m_windowPeriodStatusLbl.text = "OPEN"
            self.m_daysLbl.isHidden = false
            self.m_daysLeftTitleLbl.isHidden = false
            if m_productCode == "GMC"{
                self.enrollmentStatusData = "Add Dependant"
                self.m_enrollmentStatusImgview.image=UIImage(named: "add")
            }else{
                self.enrollmentStatusData = "Continue Enrollment"
                self.m_enrollmentStatusImgview.image=UIImage(named: "continue")
            }
            print("Add Dependant visible")
            self.m_enrollmentStatusLbl.text = self.enrollmentStatusData
            
            self.enrollMentImageView.isHidden = true
            self.m_daysLeftTitleLbl.isHidden = false
            self.m_daysLbl.isHidden = false
            
        }
        else if self.IsEnrollmentSavedStatus == 1 && self.IsWindowPeriodOpenStatus == 1{
            m_windowPeriodStatus = true
            self.m_windowPeriodStatusLbl.text = "OPEN"
            self.m_daysLbl.isHidden = false
            self.m_daysLeftTitleLbl.isHidden = false
            self.enrollmentStatusData = "Continue Enrollment"
            self.m_enrollmentStatusLbl.text = self.enrollmentStatusData
            self.m_enrollmentStatusImgview.image=UIImage(named: "continue")
            self.enrollMentImageView.isHidden = true
            self.m_daysLeftTitleLbl.isHidden = false
            self.m_daysLbl.isHidden = false
            }
        else if self.IsEnrollmentSavedStatus == 1 && self.IsWindowPeriodOpenStatus == 0{
            m_windowPeriodStatus = false
            self.m_windowPeriodStatusLbl.text = "CLOSED"
            self.m_daysLbl.isHidden = true
            self.m_daysLeftTitleLbl.isHidden = true
            if m_productCode == "GMC"{
                self.enrollmentStatusData = "Download Summary"
                self.m_enrollmentStatusImgview.image=UIImage(named: "download-2")
            }else{
                self.enrollmentStatusData = ""
                self.m_enrollmentStatusImgview.image=UIImage(named: "")
            }
            
            self.m_enrollmentStatusLbl.text = self.enrollmentStatusData
            
            self.enrollMentImageView.isHidden = false
            self.m_daysLeftTitleLbl.isHidden = true
            self.m_daysLbl.isHidden = true
            
        }else
        {
            m_windowPeriodStatus = false
        self.m_windowPeriodStatusLbl.text = "CLOSED"
            self.m_daysLbl.isHidden = true
            self.m_daysLeftTitleLbl.isHidden = true
            self.enrollmentStatusData = ""
            self.m_enrollmentStatusLbl.text = self.enrollmentStatusData
            self.m_enrollmentStatusImgview.image=UIImage(named: "")
            print("Else for setEnrollmentWindowStatus")
            self.enrollMentImageView.isHidden = false
            self.m_daysLeftTitleLbl.isHidden = true
            self.m_daysLbl.isHidden = true
            
            
        }
        addTarget()
        
    }
    
}
