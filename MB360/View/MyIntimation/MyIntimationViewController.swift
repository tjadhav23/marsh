//
//  MyIntimationViewController.swift
//  MyBenefits
//
//  Created by Semantic on 16/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import AEXML
import FirebaseCrashlytics
import TrustKit
import AesEverywhere

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String
    {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_IN")
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9-]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        //        number = NSNumber(value: (double / 100))
        number = NSNumber(value: double)
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return "0"
        }
        
        return formatter.string(from: number)!
    }
}
class MyIntimationViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate,UITextFieldDelegate,UITextViewDelegate{
    @IBOutlet weak var m_intimateClaimShadowView: UIView!
    
    @IBOutlet weak var m_intimateNowShadowView: UIView!
    @IBOutlet weak var m_intimateNowView: UIView!
    @IBOutlet weak var m_intimateNowTableView: UITableView!
    @IBOutlet weak var m_GTLTab: UIButton!
    @IBOutlet weak var m_GPATab: UIButton!
    @IBOutlet weak var m_GMCTab: UIButton!
    @IBOutlet weak var m_tabbarView: UIView!
    @IBOutlet weak var m_topBarverticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_tableview: UITableView!
    
    
    @IBOutlet weak var vewIntimateNoew: UIView!
    
    
    @IBOutlet weak var lblDropdown: UILabel!
    
    
    @IBOutlet weak var lblErrorDignosis: UILabel!
    
    @IBOutlet weak var lblErrorAmt: UILabel!
    
    @IBOutlet weak var lblErrorDoa: UILabel!
    
    
    @IBOutlet weak var lblErrorHosName: UILabel!
    
    @IBOutlet weak var lblErrorHosLoc: UILabel!
    
    
    @IBOutlet weak var vew1: UIView!
    
    @IBOutlet weak var vew2: UIView!
    
    @IBOutlet weak var vew3: UIView!
    
    @IBOutlet weak var vew4: UIView!
    @IBOutlet weak var vew5: UIView!
    @IBOutlet weak var vew6: UIView!
    
    
    @IBOutlet weak var scrollViewForIntimateNow: UIScrollView!
    
    @IBOutlet weak var formMainView: UIView!
    var maxAmountLimit = 10000000
    var convertedAmount = -1
    
    var reuseIdentifier = "cell"
    var xmlKey = String()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var responseJSonArray : [String : Any]?
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    var recordKey = "Intimations"
    var dictionaryKeys = ["Claimant","IntimationNumber","IntimationDate","HospitalName","DateOfAdmission","ClaimAmount","DiagnosisAilment","Intimation","Intimate","IntimateError","IntimateClaimInformation"]
    var m_intimationsArray = Array<Intimations>()
    var m_employeedict : EMPLOYEE_INFORMATION?
    var m_claimArray : [[String:String]]?
    
    var datasource = [ExpandedTableviewCellContent]()
    var selectedRowIndex = -1
    var viewPadding = UIView()
    var isFromSideBar = Bool()
    @IBOutlet var m_dateView: UIView!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var m_intimateNowButton: UIButton!
    
    @IBOutlet weak var m_errorImage: UIImageView!
    
    @IBOutlet weak var m_errorDetailLbl: UILabel!
    @IBOutlet weak var m_errorTitle: UILabel!
    @IBOutlet weak var m_noInternetView: UIView!
    @IBOutlet weak var m_datePickerSubview: UIView!
    
    @IBOutlet weak var m_datePicker: UIDatePicker!
    
    
    @IBOutlet weak var txtDiagnosis: UITextField!
    
    @IBOutlet weak var txtEstimatedAmt: UITextField!
    
    @IBOutlet weak var txtDoa: UITextField!
    
    @IBOutlet weak var txtHosName: UITextField!
    
    @IBOutlet weak var txtHosLoc: UITextField!
    var m_selectedDate = String()
    var m_errorMessageArray = ["", "","","","",""]
    var m_membersArray = Array<String>()
    let dateDropDown=DropDown()
    var check = Int()
    var textFields = [UITextField]()
    var m_personSrNo = Int32()
    
    var m_claimDetailsArray = ["","        Diagnosis/Ailment","","","",""]
    var m_titleArray = ["intimateFor".localized(),"diagnosis".localized(),"estimatedAmount".localized(),"DOA".localized(),"hospitalName".localized(),"hospitalLoction".localized()]
    
    var m_personDict = NSDictionary()
    var readMoreIndex = -1
    var m_Message : [[String:String]]?
    
    var POLICY_COMMENCEMENT_DATE = ""
    var POLICY_VALID_UPTO = ""
    var maxCharacterCount = 4000
    var m_membersPersonSrnoArray = Array<Int32>()
    
    var retryCountIntimationDetails = 0
    var maxRetryIntimationDetails = 1
    
    var retryCountPersonInfo = 0
    var maxRetryPersonInfo = 1
    
    var retryCountClaimNow = 0
    var maxRetryClaimNow = 1
    
    @IBOutlet weak var typeOfClaimsView: UIView!
    @IBOutlet weak var typeOfClaims_Lbl: UILabel!
    
    @IBOutlet weak var typeOfCliamView1: UIView!
    @IBOutlet weak var radioCashless: UIImageView!
    
    @IBOutlet weak var typeOfCliamView2: UIView!
    @IBOutlet weak var radioReimbursement: UIImageView!
    
    @IBOutlet weak var lblErrorRadio: UILabel!
    
    var isCashlessSelected = false
    var isReimbursementSelected = false
    var typeofclaim = ""
    var personName = ""
    var policyDataArray = [OE_GROUP_BASIC_INFORMATION]()
    var m_productCode = "GMC"
    var selectedIndex = -1
    var selectedPolicyValue = ""
    var selectedIndexPosition = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFontUI()
        userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
        userOegrpNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String ?? ""
        userEmployeeSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String ?? ""
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        
        print("MyIntimationVC Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
        
        
        print(userOegrpNoGMC)
        getEnrollStatus("GMC", 0, userOegrpNoGMC)
        m_tableview.register(ClaimsTitleViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        m_tableview.register(UINib(nibName: "ClaimsTitleViewCell", bundle: nil), forCellReuseIdentifier: "ClaimsTitleViewCell")
        
        m_tableview.register(MyIntimationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        m_tableview.register(UINib (nibName: "MyIntimationTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        m_tableview.separatorStyle=UITableViewCellSeparatorStyle.none
        
        //        m_intimateNowTableView.register(IntimateClaimTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        //
        //        m_intimateNowTableView.register(UINib(nibName: "IntimateClaimTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        //
        //        m_intimateNowTableView.tableFooterView=UIView()
        //        m_intimateNowTableView.separatorStyle=UITableViewCellSeparatorStyle.none
        
        m_intimateNowButton.dropShadow()
        m_intimateNowButton.layer.cornerRadius=cornerRadiusForView//m_intimateNowButton.frame.height/2
        m_intimateNowButton.setTitle("intimateNowCaps".localized(), for: .normal)
        resetButton.dropShadow()
        resetButton.layer.cornerRadius=cornerRadiusForView//resetButton.frame.height/2
        resetButton.setTitle("reset".localized(), for: .normal)
        
        //        self.tabBarController?.tabBar.isHidden=true
        
        viewPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5 , height: 20))
        self.m_tableview.estimatedRowHeight = 320.0;
        self.m_tableview.rowHeight = UITableViewAutomaticDimension;
        
        self.m_tableview.setNeedsLayout()
        self.m_tableview.layoutIfNeeded()
        m_intimateNowView.isHidden = true
        lblErrorRadio.isHidden = true
        lblErrorDignosis.isHidden = true
        lblErrorAmt.isHidden = true
        lblErrorDoa.isHidden = true
        lblErrorHosLoc.isHidden = true
        lblErrorHosName.isHidden = true
        //getIntimationDetails()
        //getIntimationDetailsPortal()
        
        self.getPolicyDataFromDatabase()
        txtEstimatedAmt.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        if let gmcPoliciesArray = UserDefaults.standard.array(forKey: "GroupGMCPoliciesData_Loadsession") as? [[String: Any]] {
            // Use the 'gmcPoliciesArray' variable as needed
            print("Retrieved data from UserDefaults: \(gmcPoliciesArray)")
        } else {
            // Handle the case when the data is not found in UserDefaults
            print("No data found in UserDefaults for key 'GroupGMCPoliciesDataKey'")
        }
        
    }
    
    func setupFontUI(){
        
        m_GMCTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GMCTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_GPATab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GPATab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_errorTitle.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        m_errorTitle.textColor = FontsConstant.shared.app_errorTitleColor
        
        
        m_errorDetailLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_errorDetailLbl.textColor = FontsConstant.shared.app_errorTitleColor
        
        
        m_intimateNowButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h15))
        m_intimateNowButton.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        resetButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h14))
        resetButton.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        
        //Form
        lblDropdown.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        lblDropdown.textColor = FontsConstant.shared.app_FontBlackColor
        
        typeOfClaims_Lbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h17))
        typeOfClaims_Lbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        lblErrorRadio.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        lblErrorRadio.textColor = FontsConstant.shared.app_ErrorColor
        
        txtDiagnosis.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h15))
        txtDiagnosis.textColor = FontsConstant.shared.app_FontSecondryColor
        
        lblErrorDignosis.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        lblErrorDignosis.textColor = FontsConstant.shared.app_ErrorColor
        
        txtEstimatedAmt.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h15))
        txtEstimatedAmt.textColor = FontsConstant.shared.app_FontSecondryColor
        
        lblErrorAmt.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        lblErrorAmt.textColor = FontsConstant.shared.app_ErrorColor
      
        txtDoa.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h15))
        txtDoa.textColor = FontsConstant.shared.app_FontSecondryColor
        
        lblErrorDoa.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        lblErrorDoa.textColor = FontsConstant.shared.app_ErrorColor
      
        txtHosName.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h15))
        txtHosName.textColor = FontsConstant.shared.app_FontSecondryColor
        
        lblErrorHosName.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        lblErrorHosName.textColor = FontsConstant.shared.app_ErrorColor
      
        txtHosLoc.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h15))
        txtHosLoc.textColor = FontsConstant.shared.app_FontSecondryColor
        
        lblErrorHosLoc.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        lblErrorHosLoc.textColor = FontsConstant.shared.app_ErrorColor
      
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        //getIntimationDetails()
        //getIntimationDetailsPortal()
        txtDoa.delegate = self
        txtDiagnosis.delegate = self
        txtHosLoc.delegate = self
        txtHosName.delegate = self
        txtEstimatedAmt.delegate = self
        navigationController?.navigationBar.isHidden=false
        navigationItem.title="link4Name".localized()
        navigationItem.leftBarButtonItem=getBackButton()
        //navigationItem.rightBarButtonItem=getRightBarButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        if (Device.IS_IPHONE_X)
        {
            //            m_topBarverticalConstraint.constant=84
        }
        m_tabbarView.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
        m_tabbarView.layer.cornerRadius=cornerRadiusForView//m_tabbarView.frame.size.height/2
        viewTappedForRadioBtn()
        GMCTabSeleted()
        
        
        
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        //        menuButton.backgroundColor = UIColor.white
        //        menuButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        //        menuButton.setImage(UIImage(named:"Home"), for: .normal)
    }
    
    
    func viewTappedForRadioBtn() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        typeOfCliamView1.addGestureRecognizer(tapGesture1)
        typeOfCliamView1.isUserInteractionEnabled = true
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        typeOfCliamView2.addGestureRecognizer(tapGesture2)
        typeOfCliamView2.isUserInteractionEnabled = true
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        if let tappedView = sender.view {
            let tappedViewTag = tappedView.tag
            print("View with tag \(tappedViewTag) tapped!")
            
            switch tappedViewTag {
            case 1:
                isCashlessSelected = true
                radioCashless.image = UIImage(named: "greyRadioClose")
                radioReimbursement.image = UIImage(named: "greyRadioOpen")
                lblErrorRadio.isHidden = true
                lblErrorRadio.text = ""
                self.typeOfCliamView1.layer.borderColor = hexStringToUIColor(hex: "E5E5E5").cgColor
                self.typeOfCliamView2.layer.borderColor = hexStringToUIColor(hex: "E5E5E5").cgColor
                print("isCashlessSelected")
            case 2:
                isReimbursementSelected = true
                radioCashless.image = UIImage(named: "greyRadioOpen")
                radioReimbursement.image = UIImage(named: "greyRadioClose")
                lblErrorRadio.isHidden = true
                lblErrorRadio.text = ""
                self.typeOfCliamView1.layer.borderColor = hexStringToUIColor(hex: "E5E5E5").cgColor
                self.typeOfCliamView2.layer.borderColor = hexStringToUIColor(hex: "E5E5E5").cgColor
                print("isReimbursementSelected  ")
            default:
                break
            }
        }
        
    }
    
    
    @IBAction func btnDropDownAct(_ sender: UIButton) {
        selectDropDown(sender: sender)
        
    }
    func getLeftBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:UIImage(named: "menu"), style: .plain, target: self, action: #selector(leftButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func leftButtonClicked()
    {
        //let appdelegate = UIApplication.shared.delegate as! AppDelegate
        //appdelegate.drawerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        //        tabBarController!.selectedIndex = 2
    }
    //    func getRightbarButton()->UIBarButtonItem
    //    {
    //
    //            let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "Button"), style: .plain, target: self, action: #selector(rightBarButtonClicked(sender:)))
    //            return button1
    //    }
    //    @objc func rightBarButtonClicked(sender:UIBarButtonItem)
    //    {
    //        let intimateVC :IntimateClaimViewController = IntimateClaimViewController()
    //        navigationController?.pushViewController(intimateVC, animated: true)
    //    }
    func GMCTabSeleted()
    {
        self.scrollViewForIntimateNow.isHidden = true
        m_intimateClaimShadowView.dropShadow()
        m_intimateNowShadowView.layer.masksToBounds=true
        m_intimateNowView.isHidden=true
        m_tableview.isHidden=false
        
        m_GMCTab.setTitle("intimatedClaim".localized(), for: .normal)
        m_GMCTab.layer.masksToBounds=true
        m_GMCTab.layer.cornerRadius=cornerRadiusForView//m_GMCTab.frame.size.height/2
        //        m_GMCTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GMCTab.layer.borderWidth=0
        m_GMCTab.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        m_GMCTab.setTitleColor(UIColor.white, for: .normal)
        
        m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        
        m_GPATab.layer.borderColor=UIColor.white.cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        view.endEditing(true)
        getIntimationDetailsPortal()
        
    }
    @objc override func backButtonClicked()
    {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
    func getIntimationDetailsPortal()
    {
        if(isConnectedToNet())
        {
            userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
            userOegrpNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String ?? ""
            userEmployeeSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String ?? ""
            
            print("getIntimationDetailsPortal Userdefaults userGroupChildNo: ",userGroupChildNo," userOegrpNo:",userOegrpNo," userEmployeeSrno: ",userEmployeeSrno)
            
            if userOegrpNo != "" && userGroupChildNo != "" && userEmployeeSrno != ""
            {
                
                
                showPleaseWait(msg: "Please wait...Fetching Claims")
                var employeesrno = String()
                var groupchildsrno = String()
                var oegrpbasinfsrno = String()
                if let empSrNo = userEmployeeSrno as? String
                {
                    employeesrno = String(empSrNo)
                    employeesrno = try! AES256.encrypt(input: employeesrno, passphrase: m_passphrase_Portal)
                }
                if let grpChildSrNo = userGroupChildNo as? String
                {
                    groupchildsrno = String(grpChildSrNo)
                    groupchildsrno = try! AES256.encrypt(input: groupchildsrno, passphrase: m_passphrase_Portal)
                }
                if let oeGrpBaseInfo = userOegrpNo as? String
                {
                    oegrpbasinfsrno = String(oeGrpBaseInfo)
                    oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                }
                
                print("employeesrno: \(employeesrno), groupchildsrno: \(groupchildsrno), oegrpbasinfsrno: \(oegrpbasinfsrno)")
                
                let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getIntimatedClaimPostUrlPortal(EmpSrNo: employeesrno.URLEncoded, GroupChildSrNo: groupchildsrno.URLEncoded, oegrpbasinfsrno: oegrpbasinfsrno.URLEncoded))
                
                
                print("LoadIntimatedClaims URL: ",urlreq)
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?// NSURL(string: urlreq)
                request.httpMethod = "GET"
                
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
                print("authToken LoadIntimatedClaims:",authToken)
                
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
                        print("getIntimationDetailsPortal() error:", error)
                        DispatchQueue.main.async {
                            self.hidePleaseWait()
                            self.m_tableview.isHidden=true
                            self.m_noInternetView.isHidden=false
                            if m_windowPeriodStatus{
                                self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                                self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                                self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                            }
                            else{
                                self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                                self.m_errorTitle.text = "You have no intimation"
                                self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                            }
                            
                        }
                        return
                    }
                    else{
                        
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            if httpResponse.statusCode == 200
                            {
                                do
                                {
                                    guard let data = data else { return }
                                    
                                    let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                                    
                                    print(json)
                                    let status = DatabaseManager.sharedInstance.deleteIntimationDetails()
                                    if status{
                                        if let data = json?["Claimslist"] as? [Any]{
                                            
                                            self.m_claimArray = json?["Claimslist"] as! [[String : String]]
                                            
                                            print("Claimslist: ",self.m_claimArray)
                                            
                                            for dict in self.m_claimArray!
                                            {
                                                DatabaseManager.sharedInstance.saveIntimationDetails(intimationDict: dict as NSDictionary)
                                            }
                                        }
                                        self.m_intimationsArray =  DatabaseManager.sharedInstance.retrieveIntimationDetails()
                                        
                                        print("AFter Fetching m_intimationsArray: ",self.m_intimationsArray)
                                        
                                        self.m_intimationsArray.reverse()
                                        
                                        print(self.m_intimationsArray)
                                        for index in 0..<self.m_intimationsArray.count
                                        {
                                            let intimationDict:Intimations = self.m_intimationsArray[index]
                                            
                                            try! self.datasource.append(ExpandedTableviewCellContent(title:intimationDict.claimant ?? "-", otherInfo:intimationDict))
                                        }
                                    }
                                    
                                    
                                    
                                    DispatchQueue.main.async
                                    {
                                        self.hidePleaseWait()
                                        if(self.m_intimationsArray.count==0)
                                        {
                                            self.m_tableview.isHidden=true
                                            self.m_noInternetView.isHidden=false
                                            if m_windowPeriodStatus{
                                                self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                                                self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                                            }
                                            else{
                                                self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                                                self.m_errorTitle.text = "You have no intimation"
                                                self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                            }
                                        }
                                        else
                                        {
                                            self.m_noInternetView.isHidden=true
                                            self.m_tableview.isHidden=false
                                        }
                                        
                                        DispatchQueue.main.async {
                                            self.m_tableview.reloadData()
                                        }
                                        
                                    }
                                }
                                catch{
                                    print("Error ,")
                                }
                            }else if httpResponse.statusCode == 401{
                                self.retryCountIntimationDetails+=1
                                print("retryCountIntimationDetails: ",self.retryCountIntimationDetails)
                                
                                if self.retryCountIntimationDetails <= self.maxRetryIntimationDetails{
                                    print("Some error occured getIntimationDetailsPortal",httpResponse.statusCode)
                                    self.getUserTokenGlobal(completion: { (data,error) in
                                        self.getIntimationDetailsPortal()
                                    })
                                }
                                else{
                                    print("retryCountIntimationDetails 401 else : ",self.retryCountIntimationDetails)
                                    DispatchQueue.main.async {
                                        self.hidePleaseWait()
                                        self.m_tableview.isHidden=true
                                        self.m_noInternetView.isHidden=false
                                        if m_windowPeriodStatus{
                                            self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                                            self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                                            self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                                        }
                                        else{
                                            self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                                            self.m_errorTitle.text = "You have no intimation"
                                            self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                        }
                                    }
                                }
                            }
                            else if httpResponse.statusCode == 400{
                                self.retryCountIntimationDetails+=1
                                print("retryCountIntimationDetails: ",self.retryCountIntimationDetails)
                                
                                if self.retryCountIntimationDetails <= self.maxRetryIntimationDetails{
                                    print("Some error occured getIntimationDetailsPortal",httpResponse.statusCode)
                                    self.getUserTokenGlobal(completion: { (data,error) in
                                        self.getIntimationDetailsPortal()
                                    })
                                }
                                else{
                                    print("retryCountIntimationDetails 401 else : ",self.retryCountIntimationDetails)
                                    DispatchQueue.main.async {
                                        self.hidePleaseWait()
                                        self.m_tableview.isHidden=true
                                        self.m_noInternetView.isHidden=false
                                        if m_windowPeriodStatus{
                                            self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                                            self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                                            self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                                        }
                                        else{
                                            self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                                            self.m_errorTitle.text = "You have no intimation"
                                            self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                        }
                                    }
                                }
                            }
                            else{
                                DispatchQueue.main.async {
                                    self.hidePleaseWait()
                                    self.m_tableview.isHidden=true
                                    self.m_noInternetView.isHidden=false
                                    if m_windowPeriodStatus{
                                        self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                                        self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                                        self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                                    }
                                    else{
                                        self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                                        self.m_errorTitle.text = "You have no intimation"
                                        self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                    }
                                    self.m_errorDetailLbl.text=""
                                }
                            }
                        }
                    }
                }
                task.resume()
                
            }else{
                DispatchQueue.main.async {
                    self.hidePleaseWait()
                    self.m_tableview.isHidden=true
                    self.m_noInternetView.isHidden=false
                    if m_windowPeriodStatus{
                        self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                        self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                        self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                    }
                    else{
                        self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                        self.m_errorTitle.text = "You have no intimation"
                        self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                    }
                }
            }
        }
        else
        {
            DispatchQueue.main.async
            {
                self.hidePleaseWait()
                self.m_noInternetView.isHidden=false
                self.m_errorImage.isHidden = false
                self.m_errorTitle.isHidden = false
                self.m_tableview.isHidden=true
                self.m_intimateNowView.isHidden = true
                self.m_noInternetView.isHidden=false
                self.m_errorImage.image=UIImage(named: "nointernet")
                self.m_errorTitle.text=error_NoInternet
                self.m_errorDetailLbl.text=""
            }
        }
    }
    
    
    
    //MARK:- TableView Delegate & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView==m_tableview)
        {
            if(m_claimArray?.count ?? 0>0)
            {
                return m_claimArray?.count ?? 0
            }
            return 0
        }
        else
        {
            if(textFields.count>0)
            {
                print(textFields[0].text)
                if(m_claimDetailsArray[0]=="")
                {
                    return 1
                }
                else
                {
                    return m_titleArray.count
                }
                
            }
            else
            {
                return 1
            }
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView==m_tableview)
        {
            
            
            print("**********")
            
            
            if indexPath.row != selectedRowIndex {
                let cell :ClaimsTitleViewCell = tableView.dequeueReusableCell(withIdentifier: "ClaimsTitleViewCell", for: indexPath) as! ClaimsTitleViewCell
                if(m_intimationsArray.count>0 && datasource.count>0)
                {
                    let intimationDict:Intimations = m_intimationsArray[indexPath.row]
                    
                    cell.m_claimNumber.text=intimationDict.claimNumber
                    cell.m_nameLbl.text=intimationDict.claimant
                    cell.m_claimDateLbl.text=intimationDict.claimIntimationDate?.uppercased()
                    cell.lblIntimationNo.text = intimationDict.claimNumber
                }
                shadowForCell(view: cell.backDetailsView)
                cell.m_expandButton.tag=indexPath.row
                cell.m_expandButton.addTarget(self, action: #selector(expandButtonClicked), for: .touchUpInside)
                
                return cell
                
            }
            else {
                
                let cell:MyIntimationTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyIntimationTableViewCell
                
                if(m_intimationsArray.count>0 && datasource.count>0)
                {
                    shadowForCell(view: cell.m_backgrounView)
                    customShadowPath(view: cell.m_titleView)
                    cell.m_detailView.layer.cornerRadius=cornerRadiusForView//8
                    if #available(iOS 11.0, *) {
                        cell.m_detailView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                    }
                    else
                    {
                        // Fallback on earlier versions
                    }
                    
                    //                shadowForCell(view: cell.m_titleView)
                    
                    
                    cell.accessoryType=UITableViewCellAccessoryType.none
                    if(datasource.count>0)
                    {
                        cell.setContent(data: datasource[indexPath.row])
                    }
                    
                    
                    let intimationDict:Intimations = m_intimationsArray[indexPath.row]
                    var hospitalName = intimationDict.claimHospital?.removingPercentEncoding
                    let diagnosis = intimationDict.claimDiagnosis?.removingPercentEncoding
                    
                    hospitalName = hospitalName?.replacingOccurrences(of: "+", with: "")
                    cell.m_claimNumber.text=intimationDict.claimNumber
                    cell.m_nameLbl.text=intimationDict.claimant
                    cell.m_claimDateLbl.text=intimationDict.claimIntimationDate?.uppercased()
                    cell.m_hospitalNameLbl.text=hospitalName
                    cell.lblEmployee.text = "\(intimationDict.employee_No!)-\(intimationDict.employee_Name!)"
                    print("COUNT =\(diagnosis?.count)")
                    
                    if diagnosis?.count ?? 0 > 250 {
                        if readMoreIndex == indexPath.row {
                            cell.m_ailmentLbl.numberOfLines = 0
                            cell.btnReadMore.setTitle("Read Less", for: .normal)
                            cell.btnReadMore.frame.size.height = 16
                            
                        }
                        else {
                            cell.m_ailmentLbl.numberOfLines = 3
                            cell.btnReadMore.setTitle("Read More", for: .normal)
                            cell.btnReadMore.frame.size.height = 16
                            
                        }
                        cell.m_ailmentLbl.text=diagnosis
                        cell.btnReadMore.isHidden = false
                        
                    }
                    else {
                        cell.m_ailmentLbl.text=diagnosis
                        cell.btnReadMore.isHidden = true
                        cell.btnReadMore.setTitle("", for: .normal)
                        cell.btnReadMore.frame.size.height = 0
                        
                        //cell.btnReadMore.removeFromSuperview()
                    }
                    cell.m_dateofAdmissionLbl.text=intimationDict.dateOfAdmission
                    var claimAmount = intimationDict.claimAmount
                    claimAmount=claimAmount?.replacingOccurrences(of: "Rs.", with: "")
                    do{
                        //cell.m_claimAmountLbl.text="₹ "+(claimAmount?.currencyInputFormatting())!
                        cell.m_claimAmountLbl.text="₹ "+(claimAmount ?? "-")
                    }catch{
                        print("Error: ",error)
                        print("claimAmount: ",claimAmount)
                    }
                    cell.m_expandButton.tag=indexPath.row
                    cell.m_expandButton.addTarget(self, action: #selector(expandButtonClicked), for: .touchUpInside)
                    
                    //                cell.m_dataNotFoundView.isHidden=true
                    cell.m_backgrounView.isHidden=false
                    
                    
                    //Added By Pranit
                    cell.btnReadMore.tag = indexPath.row
                    cell.btnReadMore.addTarget(self, action: #selector(readMoreTapped(_:)), for: .touchUpInside)
                    return cell
                }
                else
                {
                    shadowForCell(view: cell.m_dataNotFoundView)
                    //                cell.m_dataNotFoundView.isHidden=false
                    cell.m_backgrounView.isHidden=true
                    
                    //Added By Pranit
                    cell.btnReadMore.tag = indexPath.row
                    cell.btnReadMore.addTarget(self, action: #selector(readMoreTapped(_:)), for: .touchUpInside)
                    return cell
                }
            }
        }
        else
        {
            let cell :IntimateClaimTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! IntimateClaimTableViewCell
            
            if(indexPath.row==1)
            {
                cell.m_diagnosisTextview.isHidden=false
                cell.m_diagnosisTextview.tag=indexPath.row
                cell.m_diagnosisTextview.layer.masksToBounds=true
                cell.m_diagnosisTextview.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
                cell.m_diagnosisTextview.layer.borderWidth=1
                cell.m_diagnosisTextview.layer.cornerRadius=cell.m_diagnosisTextview.frame.height/2
                cell.m_diagnosisTextview.delegate=self
                cell.m_diagnosisTextview.text=m_claimDetailsArray[1]
                if(cell.m_diagnosisTextview.text=="        Diagnosis/Ailment")
                {
                    cell.m_diagnosisTextview.textColor=hexStringToUIColor(hex: "C4C4C4")
                }
                
                if cell.m_diagnosisTextview.text == "" {
                    cell.m_diagnosisTextview.text = "        Diagnosis/Ailment"
                    cell.m_diagnosisTextview.textColor=hexStringToUIColor(hex: "C4C4C4")
                    
                }
            }
            else
            {
                cell.m_diagnosisTextview.isHidden=true
            }
            
            
            cell.m_titleTextField.layer.masksToBounds=true
            cell.m_titleTextField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
            cell.m_titleTextField.layer.borderWidth=1
            cell.m_titleTextField.layer.cornerRadius=cell.m_titleTextField.frame.height/2
            
            
            textFields=[cell.m_titleTextField]
            cell.m_titleTextField.tag = indexPath.row
            cell.m_errorMsglbl.tag = indexPath.row
            
            setupField(textField: cell.m_titleTextField, with: m_titleArray[indexPath.row])
            var button = UIButton(type: .custom)
            
            switch indexPath.row
            {
                
            case 0:
                cell.m_titleTextField.isUserInteractionEnabled=true
                cell.m_selectButton.isHidden=true
                cell.m_selectButton.tag = 0
                button.tag = 0
                let image = #imageLiteral(resourceName: "arrow")
                button = UIButton(type: .custom)
                button.setImage(image, for: .normal)
                
                button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
                button.contentMode=UIViewContentMode.scaleAspectFit
                button.frame = CGRect(x: CGFloat(-10), y: CGFloat(2), width: CGFloat(30), height: CGFloat(20))
                
                
                button.addTarget(self, action: #selector(selectDropDown), for: .touchUpInside)
                
                cell.m_titleTextField.rightView =  button
                cell.m_titleTextField.rightViewMode = .always
                setLeftSideImageView(image: UIImage.init(), textField: cell.m_titleTextField)
                
                break
            case 1:
                cell.m_titleTextField.isUserInteractionEnabled=true
                button.isHidden=true
                setLeftSideImageView(image: UIImage.init(), textField: cell.m_titleTextField)
                
                break
                
            case 2:
                cell.m_titleTextField.isUserInteractionEnabled=true
                cell.m_titleTextField.keyboardType=UIKeyboardType.numbersAndPunctuation
                button.isHidden=true
                setLeftSideImageView(image: #imageLiteral(resourceName: "Rupee"), textField: cell.m_titleTextField)
                cell.m_titleTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
                
                break
            case 3:
                
                cell.m_titleTextField.isUserInteractionEnabled=true
                button.isHidden=true
                let image = #imageLiteral(resourceName: "Date")
                setLeftSideImageView(image: #imageLiteral(resourceName: "Date"), textField: cell.m_titleTextField)
                
                
                break
                
            case 4:
                cell.m_titleTextField.isUserInteractionEnabled=true
                button.isHidden=true
                setLeftSideImageView(image: #imageLiteral(resourceName: "HospitalName"), textField: cell.m_titleTextField)
                
                break
            case 5:
                cell.m_titleTextField.isUserInteractionEnabled=true
                setLeftSideImageView(image: #imageLiteral(resourceName: "placeholder"), textField: cell.m_titleTextField)
                button.isHidden=true
                
                
                //button.frame = CGRect(x: CGFloat(-10), y: CGFloat(2), width: CGFloat(0), height: CGFloat(0))
                break
                
                
            default:
                break
            }
            
            cell.m_titleTextField.text=m_claimDetailsArray[indexPath.row]
            
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            
            return cell
            
        }
        
    }
    
    @objc func readMoreTapped(_ sender:UIButton) {
        if sender.titleLabel?.text == "ReadLess" {
            self.readMoreIndex = -1
            self.m_tableview.reloadData()
            
        }
        else {
            self.readMoreIndex = sender.tag
            self.m_tableview.reloadData()
            
        }
        
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField)
    {
        
        if let amountString = textField.text?.currencyInputFormatting()
        {
            textField.text = amountString
        }
    }
    @objc func selectDropDown(sender:UIButton)
    {
        setupArrowDropDown(sender, at: 0)
        dateDropDown.show()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if(tableView==m_tableview)
        {
            if(m_intimationsArray.count>0 && datasource.count>0)
            {
                if selectedRowIndex == indexPath.row
                {
                    selectedRowIndex = -1
                    let content = datasource[indexPath.row]
                    content.expanded = !content.expanded
                }
                else
                {
                    if self.selectedRowIndex != -1
                    {
                        let content = datasource[selectedRowIndex]
                        content.expanded = !content.expanded
                        tableView.reloadData()
                        
                        
                    }
                    selectedRowIndex = indexPath.row
                    let content = datasource[indexPath.row]
                    content.expanded = !content.expanded
                    
                }
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
                m_tableview.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
        }
    }
    
    @objc func expandButtonClicked(sender : UIButton)
    {
        
        let indexPath = IndexPath(row:sender.tag, section:0)
        tableView(m_tableview, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(tableView==m_tableview)
        {
            if indexPath.row == selectedRowIndex
            {
                return UITableViewAutomaticDimension
                
            }
            return 130
        }
        else
        {
            return 70
            
            
        }
        
        
    }
    
    
    
    @IBAction func GMCTabSelected(_ sender: Any)
    {
        
        GMCTabSeleted()
        
        //        getIntimationDetails()
    }
    
    //MARK:- Intimate Now Tapped
    @IBAction func GPATabSelected(_ sender: Any)
    {
        self.scrollViewForIntimateNow.isHidden = false
        self.resetButtonClicked(self)
        self.formMainView.isHidden = true
        m_membersArray=[]
        m_membersPersonSrnoArray=[]
        
        isCashlessSelected = false
        isReimbursementSelected = false
        
        m_intimateNowShadowView.dropShadow()
        m_intimateClaimShadowView.layer.masksToBounds=true
        m_GPATab.setTitle("intimateNow".localized(), for: .normal)
        m_GPATab.layer.masksToBounds=true
        m_GPATab.layer.cornerRadius=cornerRadiusForView//m_GPATab.frame.size.height/2
        //        m_GPATab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GPATab.layer.borderWidth=0
        m_GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        m_GPATab.setTitleColor(UIColor.white, for: .normal)
        
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        
        m_intimateNowView.isHidden=true
        m_intimateNowView.isHidden = false
        m_tableview.isHidden=true
        self.m_noInternetView.isHidden=true
        //        m_intimateNowTableView.reloadData()
        
        for val in [typeOfCliamView1,typeOfCliamView2,vew1,vew2,vew3,vew4,vew5,vew6]{
            val?.layer.masksToBounds=true
            val?.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
            val?.layer.borderWidth=1
            //val?.layer.cornerRadius=(val?.frame.height)!/2
            val?.layer.cornerRadius=cornerRadiusForView//8
        }
        
        
        //getPersonInfoForIntimation()
        print("m_windowPeriodStatus: ",m_windowPeriodStatus)
        if !m_windowPeriodStatus{
            print("m_windowPeriodStatus in if block")
            getPersonInfoForIntimationPortal()
        }
        else{
            print("m_windowPeriodStatus in else block")
            m_noInternetView.isHidden = false
            scrollViewForIntimateNow.isHidden = true
            m_errorImage.isHidden = false
            m_errorTitle.isHidden = false
            m_errorDetailLbl.isHidden = false
            if m_windowPeriodStatus{
                self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
            }
            else{
                self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                self.m_errorTitle.text = "You have no intimation"
                self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
            }
        }
    }
    /*//Not in use
     @IBAction func GTLTabSelected(_ sender: Any)
     {
     
     
     m_GTLTab.layer.masksToBounds=true
     m_GTLTab.layer.cornerRadius=m_GTLTab.frame.size.height/2
     //        m_GTLTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
     m_GTLTab.layer.borderWidth=1
     m_GTLTab.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
     m_GTLTab.setTitleColor(UIColor.white, for: .normal)
     
     m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
     m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
     
     m_GMCTab.layer.borderColor=UIColor.white.cgColor
     m_GMCTab.setBackgroundImage(nil, for: .normal)
     m_GPATab.layer.borderColor=UIColor.white.cgColor
     m_GPATab.setBackgroundImage(nil, for: .normal)
     
     getIntimationDetails()
     }
     */
    
    /*//NOT IN USE
     func getPersonInfoForIntimation()
     {
     if(isConnectedToNetWithAlert())
     {
     m_membersArray.removeAll()
     m_membersPersonSrnoArray.removeAll()
     print(m_membersArray)
     
     
     let array = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
     if array.count > 0{
     let empSrNo = array[0].empSrNo
     
     let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getPersonInfoForIntimation(employeesrno: String(empSrNo)))
     
     let request : NSMutableURLRequest = NSMutableURLRequest()
     request.url = urlreq as URL?// NSURL(string: urlreq)
     request.httpMethod = "GET"
     
     let task = URLSession.shared.dataTask(with: urlreq! as URL)
     { (data, response, error) in
     
     if data == nil
     {
     
     return
     }
     self.xmlKey = "IntimationPerson"
     let parser = XMLParser(data: data!)
     parser.delegate = self
     parser.parse()
     
     DispatchQueue.main.async
     {
     
     for dict in self.resultsDictArray!
     {
     self.m_personDict  = dict as NSDictionary
     //                            self.m_membersArray.append(self.m_personDict.value(forKey: "PERSON_NAME") as! String)
     }
     print(self.m_membersArray)
     }
     
     
     
     }
     task.resume()
     }else{
     self.displayActivityAlert(title: err_no_1001)
     self.hidePleaseWait()
     }
     }
     else{
     DispatchQueue.main.async {
     self.m_tableview.isHidden=true
     self.m_noInternetView.isHidden=false
     self.m_errorImage.image=UIImage(named: "nointernet")
     self.m_errorTitle.text=error_NoInternet
     self.m_errorDetailLbl.text=""
     }
     }
     
     }
     */
    func getPersonInfoForIntimationPortal(){
        if(isConnectedToNetWithAlert())
        {
            m_membersArray.removeAll()
            m_membersPersonSrnoArray.removeAll()
            print(m_membersArray)
            
            
            if userOegrpNo != "" && userGroupChildNo != "" && userEmployeeSrno != ""{
                var groupchildsrno = userGroupChildNo as! String
                var oegrpbasinfsrno = userOegrpNo as! String
                var empSrNo = userEmployeeSrno as! String
                
                groupchildsrno = try! AES256.encrypt(input: groupchildsrno, passphrase: m_passphrase_Portal)
                
                oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                
                empSrNo = try! AES256.encrypt(input: empSrNo, passphrase: m_passphrase_Portal)
                
                let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getPersonInfoForIntimationPortal(groupchildsrno: String(groupchildsrno).URLEncoded, oegrpbasinfsrno: String(oegrpbasinfsrno).URLEncoded, empSrNo: String(empSrNo).URLEncoded))
                
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
                //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
                authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                print("authToken LoadPersonsForIntimation:",authToken)
                
                request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                
                print("MyIntimateClaim LoadPersonsForIntimation url: ",urlreq)
                
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
                        print("error:", error)
                        return
                    }
                    else{
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            if httpResponse.statusCode == 200
                            {
                                
                                guard let data = data else { return }
                                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                                if let data = json?["ClaimBeneficiary"] as? [Any] {
                                    
                                    self.resultsDictArray = json?["ClaimBeneficiary"] as! [[String : String]]
                                    
                                    
                                    print("resultsDictArray : ",self.resultsDictArray)
                                    
                                    for item in data {
                                        if let object = item as? [String: Any] {
                                            
                                            // PERSON_NAME
                                            let PERSON_NAME = object["PERSON_NAME"] as? String ?? ""
                                            print("PERSON_NAME: \(PERSON_NAME)")
                                            
                                            // PERSON_SR_NO
                                            let PERSON_SR_NO = object["PERSON_SR_NO"] as? String ?? ""
                                            print("PERSON_SR_NO: \(PERSON_SR_NO)")
                                            
                                            if let intValue = Int32(PERSON_SR_NO) {
                                                // Conversion successful, use intValue of type Int32
                                                print("PERSON_SR_NO Int32: ",intValue)
                                                self.m_membersPersonSrnoArray.append(intValue)
                                            } else {
                                                // Conversion failed, handle the error case
                                                print("Invalid integer value")
                                            }
                                            
                                            
                                            self.m_membersArray.append(PERSON_NAME)
                                        }
                                    }
                                    print("Final Array: ",self.m_membersArray)
                                    
                                }
                            }
                            else if httpResponse.statusCode == 401{
                                self.retryCountPersonInfo+=1
                                print("retryCountPersonInfo: ",self.retryCountPersonInfo)
                                
                                if self.retryCountPersonInfo <= self.maxRetryPersonInfo{
                                    print("Some error occured getPersonInfoForIntimationPortal",httpResponse.statusCode)
                                    self.getUserTokenGlobal(completion: { (data,error) in
                                        self.getPersonInfoForIntimationPortal()
                                    })
                                }
                                else{
                                    print("retryCountPersonInfo 401 else : ",self.retryCountPersonInfo)
                                    DispatchQueue.main.async {
                                        self.m_tableview.isHidden=true
                                        self.m_noInternetView.isHidden=false
                                        if m_windowPeriodStatus{
                                            self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                                            self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                                            self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                                        }
                                        else{
                                            self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                                            self.m_errorTitle.text = "You have no intimation"
                                            self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                        }
                                    }
                                }
                            }
                            else if httpResponse.statusCode == 400{
                                DispatchQueue.main.sync(execute: {
                                    self.retryCountPersonInfo+=1
                                    print("retryCountPersonInfo: ",self.retryCountPersonInfo)
                                    
                                    if self.retryCountPersonInfo <= self.maxRetryPersonInfo{
                                        print("Some error occured getPersonInfoForIntimationPortal",httpResponse.statusCode)
                                        self.getUserTokenGlobal(completion: { (data,error) in
                                            self.getPersonInfoForIntimationPortal()
                                        })
                                    }
                                    else{
                                        print("retryCountPersonInfo 400 else : ",self.retryCountPersonInfo)
                                        DispatchQueue.main.async {
                                            self.m_tableview.isHidden=true
                                            self.m_noInternetView.isHidden=false
                                            if m_windowPeriodStatus{
                                                self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                                                self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                                            }
                                            else{
                                                self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                                                self.m_errorTitle.text = "You have no intimation"
                                                self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                            }
                                        }
                                    }
                                })
                            }
                            else{
                                DispatchQueue.main.async {
                                    self.m_tableview.isHidden=true
                                    self.m_noInternetView.isHidden=false
                                    if m_windowPeriodStatus{
                                        self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                                        self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                                        self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                                    }
                                    else{
                                        self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                                        self.m_errorTitle.text = "You have no intimation"
                                        self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                    }
                                }
                            }
                        }
                    }
                }
                task.resume()
            }else{
                DispatchQueue.main.async {
                    self.m_tableview.isHidden=true
                    self.m_noInternetView.isHidden=false
                    if m_windowPeriodStatus{
                        self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                        self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                        self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                    }
                    else{
                        self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                        self.m_errorTitle.text = "You have no intimation"
                        self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                    }
                }
            }
        }
        else{
            DispatchQueue.main.async {
                self.m_tableview.isHidden=true
                self.m_noInternetView.isHidden=false
                self.m_errorImage.image=UIImage(named: "nointernet")
                self.m_errorTitle.text=error_NoInternet
                self.m_errorDetailLbl.text=""
            }
        }
    }
    
    
    @objc func selectDateButtonClicked(sender:UIButton)
    {
        view.endEditing(true)
        _ = Bundle.main.loadNibNamed("ProfileDatePicker", owner: self, options: nil)?[0];
        m_dateView.frame=view.frame
        view.addSubview(m_dateView)
        addBordersToComponents()
        print("selectDateButtonClicked")
    }
    
    @IBAction func resetButtonClicked(_ sender: Any)
    {
        view.endEditing(true)
        //m_claimDetailsArray = ["","        Diagnosis/Ailment","","","",""]
        //m_intimateNowTableView.reloadData()
        isCashlessSelected = false
        isReimbursementSelected = false
        m_claimDetailsArray = ["","","","","",""]
        self.lblDropdown.text = "Intimate for"
        self.radioCashless.image = UIImage(named: "greyRadioOpen")
        self.radioReimbursement.image = UIImage(named: "greyRadioOpen")
        self.lblErrorRadio.text = ""
        self.txtDiagnosis.text = ""
        self.txtDiagnosis.placeholder = "Diagnosis/Ailmment"
        self.lblErrorDignosis.text = ""
        self.txtEstimatedAmt.text = ""
        self.txtEstimatedAmt.placeholder = "Estimated/Reported Amount"
        self.lblErrorAmt.text = ""
        self.txtDoa.text = ""
        self.txtDoa.placeholder = "DOA/Likely DOA"
        self.lblErrorDoa.text = ""
        self.txtHosName.text = ""
        self.txtHosName.placeholder = "Hospital Name"
        self.lblErrorHosName.text = ""
        self.txtHosLoc.text = ""
        self.txtHosLoc.placeholder = "Hospital location"
        self.lblErrorHosLoc.text = ""
        
        self.typeOfCliamView1.layer.borderColor = hexStringToUIColor(hex: "E5E5E5").cgColor
        self.typeOfCliamView2.layer.borderColor = hexStringToUIColor(hex: "E5E5E5").cgColor
        
        
        self.scrollViewForIntimateNow.setContentOffset(CGPoint(x: self.scrollViewForIntimateNow.contentOffset.x, y: 0), animated: true)
        
        
    }
    
    func addBordersToComponents()
    {
        m_datePickerSubview.layer.borderWidth = 1
        m_datePickerSubview.layer.borderColor = UIColor.darkGray.cgColor
        m_datePickerSubview.layer.cornerRadius = 5
        
        
        
    }
    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
        m_claimArray = []
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
            if(elementName=="Intimation")
            {
                m_claimArray?.append(currentDictionary!)
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
    
    
    func validateTextFields(textField:UITextField,errorLbl:UILabel)->Int
    {
        
        let whitespaceSet = CharacterSet.whitespaces
        if((textField.text?.isEmpty)! || (textField.text?.trimmingCharacters(in: whitespaceSet).isEmpty)!)
        {
            textField.textColor=UIColor.red
            if (errorLbl.tag == 0)
            {
                errorLbl.text = "Select person"
                return 1
            }
            else if(errorLbl.tag == 1)
            {
                errorLbl.text =  "Enter Diagnosis/Ailment"
                return 1
            }
            else if(errorLbl.tag == 2)
            {
                errorLbl.text =  "Enter Amount"
                return 1
            }
            else if(errorLbl.tag == 3)
            {
                errorLbl.text =  "Enter DOA"
                return 1
            }
            else if(errorLbl.tag == 4)
            {
                errorLbl.text =  "Enter Hospital Name"
                return 1
            }
            else if(errorLbl.tag == 5)
            {
                errorLbl.text =  "Enter Hospital Location"
                return 1
            }
            
            
        }
        else
        {
            errorLbl.text=""
        }
        
        if(textField.tag==2)
        {
            let status =  CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: textField.text!))
            if(!status)
            {
                //                textField.errorMessage =  "Enter valid amount"
                errorLbl.text=""
                return 1
            }
        }
        return 0
    }
    
    func displayDropDownat(index:Int)
    {
        dateDropDown.dataSource =
        m_membersArray
        
        dateDropDown.dataSource =
        m_membersArray
        
        self.m_intimateNowButton.isHidden=false
        self.resetButton.isHidden=false
        //self.formMainView.isHidden = false
        //self.txtDiagnosis.becomeFirstResponder()
        
        // Action triggered on selection
        dateDropDown.selectionAction =
        {
            [unowned self] (index, item) in
            
            print("self.m_membersPersonSrnoArray: : ",self.m_membersPersonSrnoArray)
            print("self.m_membersArray: : ",self.m_membersArray)
            
            self.m_personSrNo = self.m_membersPersonSrnoArray[index]
            self.m_claimDetailsArray[0]=item
            // self.textFields[0].text=item
            lblDropdown.text = item
            print("Selected dropdown: m_personSrNo",self.m_personSrNo)
            print("Selected dropdown: lblDropdown",self.lblDropdown.text)
            
            if(self.m_claimDetailsArray[0] != "")
            {
                self.m_intimateNowButton.isHidden=false
                self.resetButton.isHidden=false
                self.formMainView.isHidden = false
                // self.txtDiagnosis.becomeFirstResponder()
            }
            
            print("Selected dropdown after reload m_personSrNo",self.m_personSrNo)
            
        }
    }
    
    func setupDropDown(_ selectButon: UITextField, at index: Int)
    {
        dateDropDown.anchorView = selectButon
        dateDropDown.bottomOffset = CGPoint(x: 0, y: 10)
        dateDropDown.width = view.frame.size.width-40
        displayDropDownat(index: index)
        
        
    }
    func setupArrowDropDown(_ selectButon: UIButton, at index: Int)
    {
        dateDropDown.anchorView = selectButon
        dateDropDown.bottomOffset = CGPoint(x: 0, y: 10)
        dateDropDown.width = view.frame.size.width-10
        displayDropDownat(index: index)
        
        
    }
    @IBAction func dateCancelButtonClicked(_ sender: Any)
    {
        m_dateView.removeFromSuperview()
    }
    
    @IBAction func DateDonebuttonClicked(_ sender: Any)
    {
        /*
         let formatter = DateFormatter()
         
         formatter.dateFormat = "dd~MM~yyyy"
         
         
         let selectedDate = formatter.string(from: m_datePicker.date)
         if(selectedDate=="")
         {
         m_selectedDate = "00/00/0000"
         
         }
         else
         {
         
         m_selectedDate = selectedDate
         }
         
         formatter.dateFormat = "dd/MM/yyyy"
         let dateString = formatter.string(from: m_datePicker.date)
         print(dateString)
         //print(textFields[0].text)
         m_claimDetailsArray[3] = dateString
         txtDoa.text = dateString
         // m_intimateNowTableView.reloadData()
         m_dateView.removeFromSuperview()
         */
        
        if let  datePicker = self.txtDoa.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            //dateFormatter.dateStyle = .medium
            self.txtDoa.text = dateFormatter.string(from: datePicker.date)
            /*selectedYear = datePicker.date.year
             currentYear = Calendar.current.component(.year, from: Date())
             print("selectedYear is: ",selectedYear)
             print("currentYear is: ",currentYear)
             currentAge = currentYear - selectedYear
             self.txtAge.text = String(currentAge)
             */
        }
        self.txtDoa.resignFirstResponder()
        
    }
    
    func setupField(textField:UITextField,with placeholder:String)
    {
        
        textField.delegate = self
        textField.textAlignment = .left
        
        
        textField.placeholder = NSLocalizedString(
            placeholder,
            tableName: "SkyFloatingLabelTextField",
            comment: ""
        )
        
        
        
        
    }
    func applySkyscannerTheme(textField: UITextField) {
        
        /* textField.tintColor = overcastBlueColor
         
         textField.textColor = darkGreyColor
         textField.lineColor = lightGreyColor
         textField.lineView .isHidden = true
         textField.selectedTitleColor = overcastBlueColor
         textField.selectedLineColor = overcastBlueColor
         //        SanFranciscoText-Regular 19.0
         // Set custom fonts for the title, placeholder and textfield labels*/
        //        textField.titleLabel.font = UIFont(name: "OpenSans Regular", size: 18)
        //        textField.placeholderFont = UIFont(name: "OpenSans Light", size: 18)
        textField.font = UIFont(name: "OpenSans Regular", size: 18)
    }
    
    
    func showingTitleInAnimationComplete(_ completed: Bool) {
        // If a field is not filled out, display the highlighted title for 0.3 seco
        /*  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
         self.showingTitleInProgress = false
         if !self.isSubmitButtonPressed {
         self.hideTitleVisibleFromFields()
         }
         }*/
    }
    func hideTitleVisibleFromFields() {
        
        for textField in textFields {
            //            textField.setTitleVisible(false, animated: true)
            textField.isHighlighted = false
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
        // m_intimateNowTableView.endEditing(true)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        //        textField.text=""
        if(textField.tag==0)
        {
            view.endEditing(true)
            setupDropDown(textField,at: textField.tag)
            dateDropDown.show()
            return false
        }
        else if(textField.tag==3)
        {
            //Old Date pIcker
            /*
             view.endEditing(true)
             _ = Bundle.main.loadNibNamed("ProfileDatePicker", owner: self, options: nil)?[0];
             m_dateView.frame=view.frame
             view.addSubview(m_dateView)
             print(m_selectedDate)
             if(m_selectedDate != "")
             {
             m_datePicker.date=convertSelectedStringToDate(dateString: m_selectedDate) as Date
             }
             else
             {
             m_datePicker.date=NSDate() as Date
             }
             
             addBordersToComponents()
             print("selectDateButtonClicked")
             return false
             */
            
            //New DatePicker Logic
            if #available(iOS 13.4, *) {
                //txtDoa.datePickerBtwDates(target: self, selector: #selector(DateDonebuttonClicked(_:)))
                print("POLICY_COMMENCEMENT_DATE: ",POLICY_COMMENCEMENT_DATE," : POLICY_VALID_UPTO: ",POLICY_VALID_UPTO)
                txtDoa.datePickerBtwDates(target: self, selector: #selector(DateDonebuttonClicked(_:)), value1: POLICY_COMMENCEMENT_DATE, value2: POLICY_VALID_UPTO)
            } else {
                // Fallback on earlier versions
                txtDoa.datePickerBtwDates(target: self, selector: #selector(DateDonebuttonClicked(_:)), value1: POLICY_COMMENCEMENT_DATE, value2: POLICY_VALID_UPTO)
            }
            
        }
        else if(textField.tag==1)
        {
            let erroeMsg : String = textField.text!
            if(erroeMsg=="Enter Diagnosis/Ailment")
            {
                textField.text=""
            }
            
        }
        else if(textField.tag==2)
        {
            let erroeMsg : String = textField.text!
            if(erroeMsg=="Enter Amount")
            {
                textField.text=""
            }
            
        }
        else if(textField.tag==4)
        {
            let erroeMsg : String = textField.text!
            if(erroeMsg=="Enter Hospital Name")
            {
                textField.text=""
            }
            
        }
        else if(textField.tag==5)
        {
            let erroeMsg : String = textField.text!
            if(erroeMsg=="Enter Hospital Location")
            {
                textField.text=""
            }
            
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtDiagnosis{
            let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
            return (newLength <= maxCharacterCount)
        }
        if(textField.tag == 0)
        {
            
            let newtf = textField
            //            if( ((textField.text?.length)!-1)==0)
            //            {
            //                newtf.errorMessage = nil
            //            }
            
        }
        else if(textField.tag==2)
        {
            let MAX_LENGTH_PHONENUMBER = 11
            let ACCEPTABLE_NUMBERS     = "0123456789,"
            let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        else if(textField.tag==1)
        {
            let MAX_LENGTH_PHONENUMBER = 4000
            
            let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
            
            
            return (newLength <= MAX_LENGTH_PHONENUMBER)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if(textField.tag==0)
        {
            
            
        }
        else
        {
            
            //        newtf.errorMessage = nil
            textField.textColor=UIColor.black
            
            if(textField.text==m_errorMessageArray[textField.tag])
            {
                textField.text=""
            }
            
        }
        //animateTextField(textField, with: true)
        
        
        //        changePlaceholderColor(textField: textField, color: .black)
    }
    func textFieldDidChange(_ textField: UITextField)
    {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //animateTextField(textField, with: false)
        let tag = textField.tag
        let text = textField.text
        m_claimDetailsArray[tag] = text!
        print(m_claimDetailsArray)
        
        let indexPath = IndexPath(row: tag, section: 0)
        //        let cell = m_intimateNowTableView.cellForRow(at: indexPath) as! IntimateClaimTableViewCell
        //        if(tag==0)
        //        {
        //            cell.m_titleTextField.resignFirstResponder()
        //        }
        //        else if(tag==1)
        //        {
        //
        //            cell.m_titleTextField.resignFirstResponder()
        //            cell.m_diagnosisTextview.resignFirstResponder()
        //        }
        //        else if(tag==2)
        //        {
        //            cell.m_titleTextField.resignFirstResponder()
        //        }
        //        else if(tag==3)
        //        {
        //            cell.m_titleTextField.resignFirstResponder()
        //        }
        
        //      check = validateTextFields(textField: textField,errorLbl:cell.m_errorMsglbl )
        print("tag: ",tag," : text: ",text)
        
        if tag == 2{
            var amountValue = text?.replace(string: ",", replacement: "") ?? ""
            print("amountValue: ",amountValue)
            convertedAmount = Int(amountValue) ?? 0
            print("convertedAmount: ",convertedAmount)
            if convertedAmount > maxAmountLimit{
                lblErrorAmt.text = "Max amount can be claimed is ₹1,00,00,000"
                lblErrorAmt.isHidden = false
                
            }
            else if convertedAmount < 1{
                lblErrorAmt.text = "Enter valid Estimated/Reported Amount"
                lblErrorAmt.isHidden = false
                
            }
            else{
                lblErrorAmt.text = ""
                lblErrorAmt.isHidden = true
            }
        }
    }
    
    func animateTextField(_ textField:UITextField, with up: Bool)
    {
        var movementDistance=0
        let movementDuration=0.3
        if(textField.tag==0)
        {
            movementDistance=0;
        }
        else if(textField.tag==1)
        {
            //            movementDistance=0;
        }
        else if(textField.tag==2)
        {
            //            movementDistance=60;
        }
        else if(textField.tag==3)
        {
            movementDistance=100;
        }
        else if(textField.tag==4)
        {
            movementDistance=140;
        }
        else if(textField.tag==5)
        {
            movementDistance=140;
        }
        else
        {
            movementDistance=0;
        }
        
        
        let movement = (up ? -movementDistance : movementDistance);
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame=self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if(textView.text=="        Diagnosis/Ailment")
        {
            textView.text=""
            
        }
        textView.textColor=UIColor.black
        textView.textContainerInset.left=25
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        view.endEditing(true)
        let indexPath = IndexPath(row: 1, section: 0)
        //        let cell = m_intimateNowTableView.cellForRow(at: indexPath) as! IntimateClaimTableViewCell
        //        let whitespaceSet = CharacterSet.whitespaces
        //        if((textView.text?.isEmpty)! || (textView.text?.trimmingCharacters(in: whitespaceSet).isEmpty)!)
        //        {
        //            cell.m_errorMsglbl.text="Enter Diagnosis/Ailment"
        //
        //            //Added By Pranit
        //            cell.m_diagnosisTextview.text = "        Diagnosis/Ailment"
        //            cell.m_diagnosisTextview.textColor=hexStringToUIColor(hex: "C4C4C4")
        //            //end
        //
        //        }
        //        else
        //        {
        //            cell.m_errorMsglbl.text=""
        //        }
        m_claimDetailsArray[1]=textView.text
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text=="\n")
        {
            //            view.endEditing(true)
        }
        if(text=="")
        {
            
        }
        else
        {
            m_claimDetailsArray[1]=text
        }
        return true
    }
    
    //MARK:- Submit claim
    @IBAction func intimateNowButtonClicked(_ sender: Any)
    {
        
        for textField in textFields
        {
            textField.resignFirstResponder()
            //            textField.errorMessage=m_errorMessageArray[textField.tag]
            //            textFieldDidEndEditing(textField)
            print("resign")
        }
        self.view.endEditing(true)
        
        
        var status =  CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: m_claimDetailsArray[2]))
        status=true
        
        
        self.scrollViewForIntimateNow.setContentOffset(CGPoint(x: self.scrollViewForIntimateNow.contentOffset.x, y: 0), animated: true)
        
        if(m_claimDetailsArray[0]=="")
        {
            
            displayActivityAlert(title: "Select person")
            //let textfield = textFields[0].tag
            //print(textfield)
        }
        else if isCashlessSelected == false && isReimbursementSelected == false{
            print("Type of claim is not selected")
            self.lblErrorRadio.text = "Please select Cashless / Reimbursement"
            
            self.typeOfCliamView1.layer.borderColor = hexStringToUIColor(hex: "e7505a").cgColor
            self.typeOfCliamView2.layer.borderColor = hexStringToUIColor(hex: "e7505a").cgColor
            self.lblErrorRadio.isHidden = false
            lblErrorDignosis.isHidden = true
            lblErrorAmt.isHidden = true
            lblErrorDoa.isHidden = true
            lblErrorHosName.isHidden = true
            lblErrorHosLoc.isHidden = true
        }
        else if(m_claimDetailsArray[1]=="        Diagnosis/Ailment" || m_claimDetailsArray[1]=="")
        {
            //displayActivityAlert(title: "Enter Diagnosis/Ailment")
            lblErrorDignosis.text = "Enter Diagnosis/Ailment"
            lblErrorRadio.isHidden = true
            lblErrorDignosis.isHidden = false
            lblErrorAmt.isHidden = true
            lblErrorDoa.isHidden = true
            lblErrorHosName.isHidden = true
            lblErrorHosLoc.isHidden = true
        }
        else if(m_claimDetailsArray[2]=="")
        {
            //displayActivityAlert(title: "Enter Estimated/Reported Amount")
            lblErrorAmt.text = "Enter Estimated/Reported Amount"
            lblErrorRadio.isHidden = true
            lblErrorDignosis.isHidden = true
            lblErrorAmt.isHidden = false
            lblErrorDoa.isHidden = true
            lblErrorHosName.isHidden = true
            lblErrorHosLoc.isHidden = true
        }
        else if(convertedAmount > maxAmountLimit){
            //displayActivityAlert(title: "Max amount can be claimed is ₹1,00,00,000")
            lblErrorAmt.text = "Max amount can be claimed is ₹1,00,00,000"
            lblErrorRadio.isHidden = true
            lblErrorDignosis.isHidden = true
            lblErrorAmt.isHidden = false
            lblErrorDoa.isHidden = true
            lblErrorHosName.isHidden = true
            lblErrorHosLoc.isHidden = true
        }
        else if(!status)
        {
            //displayActivityAlert(title:"Enter valid amount")
            lblErrorAmt.text = "Enter valid amount"
            lblErrorRadio.isHidden = true
            lblErrorDignosis.isHidden = true
            lblErrorAmt.isHidden = false
            lblErrorDoa.isHidden = true
            lblErrorHosName.isHidden = true
            lblErrorHosLoc.isHidden = true
        }
        else if(m_claimDetailsArray[3]=="")
        {
            //displayActivityAlert(title: "Enter DOA/Likely DOA")
            lblErrorDoa.text = "Enter DOA/Likely DOA"
            lblErrorRadio.isHidden = true
            lblErrorDignosis.isHidden = true
            lblErrorAmt.isHidden = true
            lblErrorDoa.isHidden = false
            lblErrorHosName.isHidden = true
            lblErrorHosLoc.isHidden = true
        }
        else if(m_claimDetailsArray[4]=="")
        {
            //displayActivityAlert(title: "Enter Hospital Name")
            lblErrorHosName.text = "Enter Hospital Name"
            lblErrorRadio.isHidden = true
            lblErrorDignosis.isHidden = true
            lblErrorAmt.isHidden = true
            lblErrorDoa.isHidden = true
            lblErrorHosName.isHidden = false
            lblErrorHosLoc.isHidden = true
        }
        else if(m_claimDetailsArray[5]=="")
        {
            //displayActivityAlert(title: "Enter Hospital Location")
            lblErrorHosLoc.text = "Enter Hospital Location"
            lblErrorRadio.isHidden = true
            lblErrorDignosis.isHidden = true
            lblErrorAmt.isHidden = true
            lblErrorDoa.isHidden = true
            lblErrorHosName.isHidden = true
            lblErrorHosLoc.isHidden = false
        }
        else
        {
            if(isConnectedToNetWithAlert())
            {
                showPleaseWait(msg: "Please wait...")
                //intimateClaim()
                intimateClaimPortal()
            }
            else{
                DispatchQueue.main.async {
                    self.m_tableview.isHidden=true
                    self.m_noInternetView.isHidden=false
                    self.m_errorImage.image=UIImage(named: "nointernet")
                    self.m_errorTitle.text=error_NoInternet
                    self.m_errorDetailLbl.text=""
                }
            }
            
        }
        
    }
    
    func intimateClaimPortal()
    {
        if(isConnectedToNetWithAlert())
        {
            userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
            userOegrpNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String ?? ""
            userEmployeeSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String ?? ""
            
            var personSrNoData = String(self.m_personSrNo)
            
            
            print("intimateClaimPortal Userdefaults userGroupChildNo: ",userGroupChildNo," userOegrpNo:",userOegrpNo," userEmployeeSrno: ",userEmployeeSrno," personSrNoData: ",personSrNoData)
            
            if userOegrpNo != "" && userGroupChildNo != "" && userEmployeeSrno != "" && personSrNoData != ""
            {
                
                var groupchildsrno = String()
                var oegrpbasinfsrno = String()
                var employeesrno = String()
                var personsrno = String()
                
                if let gchildsrno = userGroupChildNo as? String//m_employeedict?.groupChildSrNo
                {
                    groupchildsrno = String(gchildsrno)
                    
                }
                if let oegrpBaseInfo = userOegrpNo as? String
                {
                    oegrpbasinfsrno = String(oegrpBaseInfo)
                    
                }
                if let empSrNo = userEmployeeSrno as? String
                {
                    employeesrno = String(empSrNo)
                    
                }
                if isCashlessSelected{
                    typeofclaim = "cashless"
                }
                else if isReimbursementSelected{
                    typeofclaim = "reimbursement"
                }
                
                let SelectedpersonNumber = String(self.m_personSrNo)
                
                var escapedClaimAmountString = m_claimDetailsArray[2].replacingOccurrences(of: ",", with: "")
                escapedClaimAmountString = escapedClaimAmountString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let escapedhosptalNameString = m_claimDetailsArray[4].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let escapedHospitalLocationString = m_claimDetailsArray[5].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                let diagnosis = m_claimDetailsArray[1]
                let claimamount = escapedClaimAmountString
                let doalikelydoa = m_claimDetailsArray[3]//m_selectedDate
                let hospitalname = m_claimDetailsArray[4]//escapedhosptalNameString!
                let hospitallocation = m_claimDetailsArray[5]//escapedHospitalLocationString!
                TPA_CODE_GMC_Base =  UserDefaults.standard.value(forKey: "TPA_CODE_GMC_BaseValue") as! String
                POLICY_COMMENCEMENT_DATE_GMC_Base = UserDefaults.standard.value(forKey: "POLICY_COMMENCEMENT_DATE_GMC_Base") as! String
                let inputString = m_claimDetailsArray[0]//personname
                let components = inputString.components(separatedBy: " - ")
                print("components : ",components)
                let beneficiary_name = components[0]//personname
                
                
                self.m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
                
                self.policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "GMC")
                
                print("policyDataArray 11 : ",self.policyDataArray)
                
                if m_productCode != "GMC"{
                    selectedIndexPosition = 0
                }
                
                var policy_no = ""
                var tpacode = ""
                var POLICY_COMMENCEMENT_DATE = ""
                var POLICY_VALIDUPTO = ""
                
                policy_no =  self.policyDataArray[selectedIndexPosition].policyNumber ?? ""  //"GHI_P_A_1_STG_180523"//selectedpolicy
                 tpacode = self.policyDataArray[selectedIndexPosition].tpa_Code ?? ""
                 POLICY_COMMENCEMENT_DATE = self.policyDataArray[selectedIndexPosition].policyComencmentDate ?? ""
                 POLICY_VALIDUPTO = self.policyDataArray[selectedIndexPosition].policyValidUpto ?? ""
                let GROUP_CODE = "GMC"
                
                
                
                print("-------------")
                print("POLICY_COMMENCEMENT_DATE: ",POLICY_COMMENCEMENT_DATE)
                print("policy_no: ",policy_no)
                print("tpacode: ",tpacode)
                print("POLICY_VALIDUPTO: ",POLICY_VALIDUPTO)
                
                
                let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getintimateClaimPostUrlPortal() as String)
                
                print("Intimate New Claim url: ",urlreq)
                
                let jsonDict = ["groupchildsrno":"\(groupchildsrno)",
                                "oegrpbasinfsrno":"\(oegrpbasinfsrno)",
                                "employeesrno":"\(employeesrno)",
                                "personsrno":"\(SelectedpersonNumber)",
                                "diagnosis":"\(diagnosis)",
                                "claimamount":"\(claimamount)",
                                "doalikelydoa":"\(doalikelydoa)",
                                "hospitalname":"\(hospitalname)",
                                "hospitallocation":"\(String(describing: hospitallocation))",
                                "typeofclaim":"\(typeofclaim)",
                                "beneficiary_name":"\(beneficiary_name)",
                                "policy_no":"\(policy_no)",
                                "tpacode":"\(tpacode)",
                                "POLICY_COMMENCEMENT_DATE":"\(POLICY_COMMENCEMENT_DATE)",
                                "POLICY_VALIDUPTO":"\(POLICY_VALIDUPTO)",
                                "GROUP_CODE":"\(GROUP_CODE)"
                ]
                
                
                let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
                
                print("NewIntemation urlreq: ",urlreq)
                print("selectedIndexPosition : ",selectedIndexPosition )
                print("jsonDict: ",jsonDict)
                
                var request = URLRequest(url: urlreq! as URL)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                
                var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
                var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)
                
                
                let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
                print("m_authUserName_Portal ",encryptedUserName)
                print("m_authPassword_Portal ",encryptedPassword)
                
                let authData = authString.data(using: String.Encoding.utf8)!
                let base64AuthString = authData.base64EncodedString()
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                print("authToken intimateclaim:",authToken)
                
                request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
                
                //SSL Pinning
                let sessionConfig = URLSessionConfiguration.default
                sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
                sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
                TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
                let session = URLSession(
                    configuration: sessionConfig,
                    delegate: URLSessionPinningDelegate(),
                    delegateQueue: nil)
                
                let task = session.dataTask(with: request) { [self] (data, response, error) in
                    //SSL Pinning
                    if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                        // Handle SSL connection failure
                        print("SSL connection error: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            alertForLogout(titleMsg: error.localizedDescription)
                        }
                    }
                    else if let error = error {
                        print("error:", error)
                        return
                    }
                    else
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            print("httpresponse statuscode",httpResponse.statusCode)
                            if httpResponse.statusCode == 200
                            {
                                do {
                                    
                                    guard let data = data else { return }
                                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
                                    self.responseJSonArray = json
                                    
                                    print("responseJSonArray: ",self.responseJSonArray)
                                    
                                    DispatchQueue.main.async
                                    {
                                        if(self.responseJSonArray!.count > 0)
                                        {
                                            self.hidePleaseWait()
                                            let dict :NSDictionary = self.responseJSonArray! as NSDictionary
                                            print("Dict: ",dict)
                                            
                                            
                                            var message : String = dict.value(forKey: "Message") as? String ?? ""
                                            var status = dict.value(forKey: "Status")
                                            
                                            print("message: ",message," status:",status)
                                            
                                            var lowerCaseMsg = message.localizedLowercase
                                            var sentenceFormatMsg = lowerCaseMsg.firstCharacterUpperCase()
                                            print("converted sentenceFormatMsg: ",sentenceFormatMsg)
                                            //let alertController = UIAlertController(title: "Claim Intimated Successfully", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                            
                                            if !sentenceFormatMsg.isEmpty{
                                                let alertController = UIAlertController(title: "", message: sentenceFormatMsg, preferredStyle: UIAlertControllerStyle.alert)
                                                
                                                
                                                
                                                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                                                {
                                                    (result : UIAlertAction) -> Void in
                                                    print("Cancel")
                                                    self.m_claimDetailsArray = ["","","","","",""]
                                                    self.GMCTabSeleted()
                                                    //                                self.m_tableview.reloadData()
                                                    //self.getIntimationDetails()
                                                    self.getIntimationDetailsPortal()
                                                }
                                                alertController.addAction(cancelAction)
                                                
                                                
                                                self.present(alertController, animated: true, completion: nil)
                                            }
                                            else{
                                                let alertController = UIAlertController(title: "", message: "Something went wrong!!", preferredStyle: UIAlertControllerStyle.alert)
                                                
                                                let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel)
                                                {
                                                    (result : UIAlertAction) -> Void in
                                                    print("Cancel")
                                                    self.m_claimDetailsArray = ["","","","","",""]
                                                    self.GMCTabSeleted()
                                                    //                                self.m_tableview.reloadData()
                                                    //self.getIntimationDetails()
                                                    self.getIntimationDetailsPortal()
                                                }
                                                alertController.addAction(cancelAction)
                                                
                                                
                                                self.present(alertController, animated: true, completion: nil)
                                            }
                                        }
                                    }
                                    
                                }
                                catch let JSONError as NSError
                                {
                                    print(JSONError)
                                    // Crashlytics.sharedInstance().recordError(m_errorMsg as! Error)
                                    self.hidePleaseWait()
                                }
                            }
                            else if httpResponse.statusCode == 401{
                                self.retryCountClaimNow+=1
                                print("retryCountClaimNow: ",self.retryCountClaimNow)
                                
                                if self.retryCountClaimNow <= self.maxRetryClaimNow{
                                    print("Some error occured intimateClaimPortal",httpResponse.statusCode)
                                    self.getUserTokenGlobal(completion: { (data,error) in
                                        self.intimateClaimPortal()
                                    })
                                }
                                else{
                                    print("retryCountClaimNow 401 else : ",self.retryCountClaimNow)
                                    DispatchQueue.main.async {
                                        self.hidePleaseWait()
                                        self.m_tableview.isHidden=true
                                        self.m_intimateNowView.isHidden = true
                                        self.m_noInternetView.isHidden=false
                                        if m_windowPeriodStatus{
                                            self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                                            self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                                            self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                                        }
                                        else{
                                            self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                                            self.m_errorTitle.text = "You have no intimation"
                                            self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                        }
                                    }
                                }
                            }
                            else if httpResponse.statusCode == 400{
                                DispatchQueue.main.sync(execute: {
                                    self.retryCountClaimNow+=1
                                    print("retryCountClaimNow: ",self.retryCountClaimNow)
                                    
                                    if self.retryCountClaimNow <= self.maxRetryClaimNow{
                                        print("Some error occured intimateClaimPortal",httpResponse.statusCode)
                                        self.getUserTokenGlobal(completion: { (data,error) in
                                            self.intimateClaimPortal()
                                        })
                                    }
                                    else{
                                        print("retryCountClaimNow 400 else : ",self.retryCountClaimNow)
                                        DispatchQueue.main.async {
                                            self.hidePleaseWait()
                                            self.m_tableview.isHidden=true
                                            self.m_intimateNowView.isHidden = true
                                            self.m_noInternetView.isHidden=false
                                            if m_windowPeriodStatus{
                                                self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                                                self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                                            }
                                            else{
                                                self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                                                self.m_errorTitle.text = "You have no intimation"
                                                self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                            }
                                        }
                                    }
                                })
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    self.hidePleaseWait()
                                    self.m_tableview.isHidden=true
                                    self.m_intimateNowView.isHidden = true
                                    self.m_noInternetView.isHidden=false
                                    if m_windowPeriodStatus{
                                        self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                                        self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                                        self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                                    }
                                    else{
                                        self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                                        self.m_errorTitle.text = "You have no intimation"
                                        self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                                    }
                                }
                            }
                        }
                    }
                }
                
                task.resume()
                
            }
            else{
                DispatchQueue.main.async {
                    self.hidePleaseWait()
                    self.m_tableview.isHidden=true
                    self.m_intimateNowView.isHidden = true
                    self.m_noInternetView.isHidden=false
                    if m_windowPeriodStatus{
                        self.m_errorImage.image=UIImage(named: "duringEnrollDataNotFound")
                        self.m_errorTitle.text = "During_Enrollment_Header_ErrorMsg".localized()
                        self.m_errorDetailLbl.text="During_Enrollment_Header_IntimateErrorMsg".localized()
                    }
                    else{
                        self.m_errorImage.image=UIImage(named: "PEClaimsNotFound")
                        self.m_errorTitle.text = "You have no intimation"
                        self.m_errorDetailLbl.text = "During_PostEnrollment_Detail_CommonErrorMsg".localized()
                    }
                }
            }
        }
        else{
            DispatchQueue.main.async {
                self.hidePleaseWait()
                self.m_tableview.isHidden=true
                self.m_intimateNowView.isHidden = true
                self.m_noInternetView.isHidden=false
                self.m_errorImage.image=UIImage(named: "nointernet")
                self.m_errorTitle.text=error_NoInternet
                self.m_errorDetailLbl.text=""
            }
        }
    }
    
    private func getPolicyDataFromDatabase() {
        let policyData = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "GMC")
        if policyData.count > 0 {
            print("OE GROUP BASE = \(policyData[0].oE_GRP_BAS_INF_SR_NO)")
            print("policyData: ",policyData)
            
            POLICY_COMMENCEMENT_DATE = policyData[0].policyComencmentDate!
            POLICY_VALID_UPTO = policyData[0].policyValidUpto!
            
            print("POLICY_COMMENCEMENT_DATE: ",POLICY_COMMENCEMENT_DATE," : POLICY_VALID_UPTO: ",POLICY_VALID_UPTO)
            
        }
    }
    
}


extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}


extension UITextField {
    
    @available(iOS 13.4, *)
    func datePickerBtwDates(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }else{
            datePicker.preferredDatePickerStyle = .automatic
        }
        //datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        //datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    
    func datePickerBtwDates(target: Any, selector: Selector, value1: String, value2: String){
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }else{
            
        }
        //datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        //datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd/MMM/yyyy"
        dateFormatter.dateFormat = "dd/MM/yyyy"
        print("value1: ",value1," : value2 ",value1)
        
        var startDateConverted = dateFormatter.date(from: value1)
        var endDateConverted = dateFormatter.date(from: value2)
        
        print("startDateConverted: ",startDateConverted," : endDateConverted ",endDateConverted)
        
        datePicker.minimumDate = startDateConverted
        datePicker.maximumDate = endDateConverted
        
        //self.txtDoa.text = dateFormatter.string(from: datePicker.date)
        
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
}
