//
//  ClaimBeneficiaryDetailsViewController.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 07/09/23.
//  Copyright © 2023 Semantic. All rights reserved.
//



import UIKit
import FlexibleSteppedProgressBar
import TrustKit
import AesEverywhere


class ClaimBeneficiaryDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,FlexibleSteppedProgressBarDelegate, UITextFieldDelegate {
    
 
    private var isSelected : Int = -1
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnNext: UIButton!
    weak var delegate: ClaimDetailsFormDelegate?

    @IBOutlet weak var progressBarView: UIView!
    
    @IBOutlet weak var errorVew: UIView!
    
    @IBOutlet weak var imgError: UIImageView!
    
    @IBOutlet weak var lblErrorTitle: UILabel!
    
    @IBOutlet weak var lblErrorDetails: UILabel!
    private var progressBarWithDifferentDimensions: FlexibleSteppedProgressBar!
    var progressColor = FontsConstant.shared.app_FontPrimaryColor
    var textColorHere = FontsConstant.shared.app_FontPrimaryColor
    var backgroundColor = UIColor(hexString: "#C2C2C2") // LIGHT Grey
    
    var resultsDictArray: [[String: String]]?
    
    var claimIntimatedPalce = ""
    var arrList : [DetailGetClaimDetails] = []
    var arrBenefits : [GetIntimationNoDetail] = []
    var arrTpa : [DetailGetBeneficiaryDetails] = []
    var arrData : [ClaimInformation] = []
    var m_productCode = String()
    var memberInfo : MemberInformation? = nil
    var passdata : passData? = nil
    var editData : AaDatum? = nil
    var isFromEdit : Bool = false
    @IBOutlet weak var claimIntimationNoView: UIView!
    @IBOutlet weak var claimIntimationNo_lbl: UILabel!
    @IBOutlet weak var claimIntimationNo_TxtField: UITextField!
    @IBOutlet weak var claimIntimationNoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnBacktohome: UIButton!
    
    @IBOutlet weak var bottomVew: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        claimIntimationNo_TxtField.delegate = self
        print(passdata)
        isSelected = -1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ClaimBeneficiaryDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ClaimBeneficiaryDetailsTableViewCell")
        
      
        btnNext.layer.cornerRadius = cornerRadiusForView
        btnNext.isUserInteractionEnabled = false
        btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
        bottomVew.alpha = 0
        //setupProgressBarWithDifferentDimensions()
        
        print("viewDidLoad Selected Place values is ",claimIntimatedPalce)
        
        print(" viewWillAppear Selected Place values is ",claimIntimatedPalce)
        
//        if claimIntimatedPalce.lowercased() == "benefits you"{
//            claimIntimationNoView.isHidden = true
//            claimIntimationNoHeight.constant = 0
//            getIntimationNo()
//        }
//        else if claimIntimatedPalce.lowercased() == "third party administrator (tpa)"{
//            claimIntimationNoView.isHidden = false
//            claimIntimationNoHeight.constant = 90
//
//            loadBeneficiary()
////            // Load the data from UserDefaults
////             if let savedArray = UserDefaults.standard.array(forKey: "groupGMCPolicyEmpDependants_UserDefault") as? [[String: String]] {
////                 resultsDictArray = savedArray
////
////                 print("savedArray:::",savedArray)
////                 if resultsDictArray!.count>0{
////                     errorVew.isHidden = true
////                     tableView.isHidden = false
////                 }
////
////                 tableView.reloadData() // Reload the table view with the loaded data
////             }
//        }else{
//            claimIntimationNoView.isHidden = true
//            claimIntimationNoHeight.constant = 0
//            loadClaimNo()
//        }
//
////        getDetails()
////        loadBeneficiary()
//
//        self.btnNextStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor), hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        navigationItem.leftBarButtonItem = getBackButtonNew()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Claim Data upload"
        menuButton.isHidden = true
        DispatchQueue.main.async() {
            menuButton.isHidden = true
        }
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        isSelected = -1
        claimIntimationNo_TxtField.text = ""
        
//        if isFromEdit{
//            if editData?.claimIntimatedDest.lowercased() == "benefits you"{
//                claimIntimationNoView.isHidden = true
//                claimIntimationNoHeight.constant = 0
//                getIntimationNo()
//            }else if editData?.claimIntimatedDest.lowercased() == "third party administrator(tpa)"{
//                claimIntimationNoView.isHidden = false
//                claimIntimationNoHeight.constant = 90
//
//                loadBeneficiary()
//            }else{
//                claimIntimationNoView.isHidden = true
//                claimIntimationNoHeight.constant = 0
//                loadClaimNo()
//            }
//
//
//        }else{
            if claimIntimatedPalce.lowercased() == "benefits you"{
                claimIntimationNoView.isHidden = true
                claimIntimationNoHeight.constant = 0
                getIntimationNo()
            }
            else if claimIntimatedPalce.lowercased() == "third party administrator (tpa)"{
                claimIntimationNoView.isHidden = false
                claimIntimationNoHeight.constant = 90
                
                loadBeneficiary()
                //            // Load the data from UserDefaults
                //             if let savedArray = UserDefaults.standard.array(forKey: "groupGMCPolicyEmpDependants_UserDefault") as? [[String: String]] {
                //                 resultsDictArray = savedArray
                //
                //                 print("savedArray:::",savedArray)
                //                 if resultsDictArray!.count>0{
                //                     errorVew.isHidden = true
                //                     tableView.isHidden = false
                //                 }
                //
                //                 tableView.reloadData() // Reload the table view with the loaded data
                //             }
            }else{
                claimIntimationNoView.isHidden = true
                claimIntimationNoHeight.constant = 0
                loadClaimNo()
            }
            self.btnNextStatus()
       // }
        
//        getDetails()
//        loadBeneficiary()
        
      
 
    }
    
    func getBackButtonNew()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "back button"), style: .plain, target: self, action: #selector(backButtonClicked)) // action:#selector(Class.MethodName) for swift 3

        
        return button1
    }
    @objc override func backButtonClicked()
    {
        print ("backButtonClicked")
        if let secondViewController = navigationController?.viewControllers.first(where: { $0 is UploadedClaimsViewController }) as? UploadedClaimsViewController {
                 // Pop back to the second view controller
                 navigationController?.popToViewController(secondViewController, animated: true)
             }
    }
    
    func setupProgressBarWithDifferentDimensions() {
        progressBarWithDifferentDimensions = FlexibleSteppedProgressBar()
        progressBarWithDifferentDimensions.translatesAutoresizingMaskIntoConstraints = false
        progressBarView.addSubview(progressBarWithDifferentDimensions)

        // iOS9+ auto layout code
        let horizontalConstraint = progressBarWithDifferentDimensions.centerXAnchor.constraint(equalTo: progressBarView.centerXAnchor)
        let verticalConstraint = progressBarWithDifferentDimensions.topAnchor.constraint(
            equalTo: progressBarView.topAnchor,
            constant: 0 // position from top for bar
        )

        let widthConstraint = progressBarWithDifferentDimensions.widthAnchor.constraint(equalTo: progressBarView.widthAnchor, constant: -80)
        widthConstraint.isActive = true

        let heightConstraint = progressBarWithDifferentDimensions.heightAnchor.constraint(equalTo: progressBarView.heightAnchor)

        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])

        progressBarWithDifferentDimensions.numberOfPoints = 3
        progressBarWithDifferentDimensions.lineHeight = 3
        progressBarWithDifferentDimensions.radius = 6
        progressBarWithDifferentDimensions.progressRadius = 11
        progressBarWithDifferentDimensions.progressLineHeight = 3
        progressBarWithDifferentDimensions.delegate = self
        progressBarWithDifferentDimensions.useLastState = true
        progressBarWithDifferentDimensions.lastStateCenterColor = progressColor
        progressBarWithDifferentDimensions.selectedBackgoundColor = progressColor
        progressBarWithDifferentDimensions.selectedOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.lastStateOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.currentSelectedCenterColor = progressColor
        progressBarWithDifferentDimensions.stepTextColor = textColorHere
        progressBarWithDifferentDimensions.currentSelectedTextColor = progressColor
        progressBarWithDifferentDimensions.completedTillIndex = 1
       
        
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == progressBarWithDifferentDimensions {
            if position == FlexibleSteppedProgressBarTextLocation.bottom {
                switch index {

                case 0: return "Claims Details"
                case 1: return "Beneficiary Details"
                case 2: return "File Upload"
                default: return ""

                }
            }
        }
        return ""
    }
    
    
    @IBAction func btnBacktohomeAct(_ sender: UIButton) {
        if let secondViewController = navigationController?.viewControllers.first(where: { $0 is UploadedClaimsViewController }) as? UploadedClaimsViewController {
                 // Pop back to the second view controller
                 navigationController?.popToViewController(secondViewController, animated: true)
             }
        
    }
    
    func getClaimsJson(){
        if(isConnectedToNet())
        {
            showPleaseWait1(msg: """
Please wait...
Fetching Claims
""")
            var clickedOegrp = ""
            var clickedEmpSrNo = ""
            
            
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
                                self.tableView.isHidden=true
                                self.errorVew.isHidden=false
//                                    if m_windowPeriodStatus{
//                                    self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
//                                    self.m_errorMsgTitleLbl.text="During_Enrollment_Header_ErrorMsg".localized()
//                                    self.m_errorMsgDetailLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
//                                }else{
//                                    self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
//                                    self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
//                                    self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
//                                }
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
                                
                             
                            }
                            catch {
                                print("Error parsing JSON: \(error)")
                                
                            }
                        }
                        else {
                            print("Request failed with status code: \(httpResponse.statusCode)")
                            DispatchQueue.main.async{
                                print("ClaimInformation not found in the JSON response")
                                self.tableView.isHidden=true
                                self.errorVew.isHidden=false
//                                if m_windowPeriodStatus{
//                                    self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
//                                    self.m_errorMsgTitleLbl.text="During_Enrollment_Header_ErrorMsg".localized()
//                                    self.m_errorMsgDetailLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
//                                }else{
//                                    self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
//                                    self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
//                                    self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
//                                }
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
                        self.tableView.isHidden=true
                        self.errorVew.isHidden=false
//                        if m_windowPeriodStatus{
//                            self.m_errorImageView.image=UIImage(named: "duringEnrollDataNotFound")
//                            self.m_errorMsgTitleLbl.text="During_Enrollment_Header_ErrorMsg".localized()
//                            self.m_errorMsgDetailLbl.text="During_Enrollment_Detail_ErrorMsg".localized()
//                        }else{
//                            self.m_errorImageView.image=UIImage(named: "PEClaimsNotFound")
//                            self.m_errorMsgTitleLbl.text="During_PostEnrollment_Header_ClaimsErrorMsg".localized()
//                            self.m_errorMsgDetailLbl.text="During_PostEnrollment_Detail_CommonErrorMsg".localized()
//                        }
                        //self.m_tableView.reloadData()
                        self.hidePleaseWait1()
                    }
                }
            
        }
        else{
            //self.displayActivityAlert(title: "No internet")
            DispatchQueue.main.async{
                self.hidePleaseWait1()
                self.tableView.isHidden=true
                self.errorVew.isHidden=false
//                self.m_errorImageView.image=UIImage(named: "nointernet")
//                self.m_errorMsgTitleLbl.text = error_NoInternet
//                self.m_errorMsgDetailLbl.text = ""
            }
            
        }
    }
    
    func getIntimationNo(){
        if isConnectedToNet(){
            let appendUrl = "IntimateClaim/LoadIntimationNo?employeesrno=\(userEmployeeSrno)"
            
            webServices().getRequestForJsonCDU(appendUrl, completion: { (data,error,resp) in
                if error != ""{
                    DispatchQueue.main.async{
                        self.tableView.isHidden = true
                        self.errorVew.isHidden = false
                        self.imgError.image=UIImage(named: "claimnotfound")
                        self.lblErrorTitle.text = "No data found"
                        self.lblErrorDetails.text = "During_Enrollment_Detail_ErrorMsg".localized()
                    }
                    
                }else{
                    if let httpResponse = resp as? HTTPURLResponse//response as? HTTPURLResponse
                    {
                        print("getDetailsPortal: ",httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            do {
                                let json = try JSONDecoder().decode(GetIntimationNo.self, from: data!)
                                var arr = json.detail
                                print(arr)
                                print(self.editData)
                                self.arrBenefits = arr
                                
                                if self.isFromEdit{
                                    if self.arrBenefits.count > 0{
                                        for i in 0..<self.arrBenefits.count{
                                            if self.editData!.clmIntSrNo == self.arrBenefits[i].clmIntSrNo{
                                                self.isSelected = i
                                                self.passdata?.clm_intimation_no = self.arrBenefits[i].claimIntimationNo
                                                self.passdata?.clm_int_sr_no = self.arrBenefits[i].clmIntSrNo
                                                self.passdata?.doc_req_by = userEmployeeSrno
                                                self.passdata?.person_sr_no = self.arrBenefits[i].intimationDetails.detail[0].personSrNo
                                                DispatchQueue.main.async{
                                                    self.btnNextStatus()
                                                }
                                                break
                                            }
                                        }
                                    }
                                   
                                }
                                DispatchQueue.main.async{
                                    if self.arrBenefits.count > 0{
                                        self.tableView.isHidden = false
                                        self.errorVew.isHidden = true
                                    }else{
                                        
                                        DispatchQueue.main.async{
                                            self.tableView.isHidden = true
                                            self.errorVew.isHidden = false
                                            self.imgError.image=UIImage(named: "claimnotfound")
                                            self.lblErrorTitle.text = "No data found"
                                            self.lblErrorDetails.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                        }
                                    }
                                    self.tableView.reloadData()
                                }
                            }catch{
                                //                            DispatchQueue.main.async{
                                //                                self.tableView.isHidden = true
                                //                                self.errorVew.isHidden = false
                                //                                self.lblErrorTitle.text = "No data found"
                                //                                self.lblErrorDetails.text = ""
                                //                            }
                            }
                            
                        }else{
                            DispatchQueue.main.async{
                                self.tableView.isHidden = true
                                self.errorVew.isHidden = false
                                self.imgError.image=UIImage(named: "claimnotfound")
                                self.lblErrorTitle.text = "No data found"
                                self.lblErrorDetails.text = "During_Enrollment_Detail_ErrorMsg".localized()
                            }
                        }
                    }
                }
                
            })
        }else{
            DispatchQueue.main.async{
                self.tableView.isHidden = true
                self.errorVew.isHidden = false
                self.imgError.image=UIImage(named: "nointernet")
                self.lblErrorTitle.text = error_NoInternet
                self.lblErrorDetails.text = ""
            }
        }
    }
    
    func loadClaimNo(){
        if isConnectedToNet(){
            let appendUrl = "IntimateClaim/LoadEmpClaimsValues?employeesrno=\(userEmployeeSrno)&groupchildsrno=\(userGroupChildNo)"
            
            webServices().getRequestForJsonCDU(appendUrl, completion: {
                (data,error,resp) in
                if error == ""{
                    if let httpResponse = resp as? HTTPURLResponse//response as? HTTPURLResponse
                    {
                        print("getDetailsPortal: ",httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            do {
                                let json = try JSONDecoder().decode(GetClaimNo.self, from: data!)
                                self.arrData = json.claimInformation
                                if self.isFromEdit{
                                    if self.arrData.count > 0{
                                        for i in 0..<self.arrData.count{
                                            if self.editData!.clmIntSrNo == self.arrData[i].claimSrNo{
                                                self.isSelected = i
                                                self.passdata?.clm_intimation_no = self.arrData[i].claimNo.replacingOccurrences(of: " ", with: "")
                                                self.passdata?.clm_int_sr_no = self.arrData[i].claimSrNo
                                                self.passdata?.doc_req_by = userEmployeeSrno
                                                self.passdata?.person_sr_no = self.arrData[i].personSrNo
                                                DispatchQueue.main.async{
                                                    self.btnNextStatus()
                                                }
                                                break
                                            }
                                        }
                                    }
                                   
                                }
                                DispatchQueue.main.async{
                                    if self.arrData.count > 0{
                                        self.errorVew.isHidden = true
                                        self.tableView.isHidden = false
                                        self.tableView.reloadData()
                                    }else{
                                        
                                        self.tableView.isHidden = true
                                        self.errorVew.isHidden = false
                                        self.imgError.image=UIImage(named: "claimnotfound")
                                        self.lblErrorTitle.text = "No data found"
                                        self.lblErrorDetails.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                        
                                    }
                                }
                                
                            }catch{
                                
                            }
                        }else{
                            DispatchQueue.main.async{
                                self.tableView.isHidden = true
                                self.errorVew.isHidden = false
                                self.imgError.image=UIImage(named: "claimnotfound")
                                self.lblErrorTitle.text = "No data found"
                                self.lblErrorDetails.text = "During_Enrollment_Detail_ErrorMsg".localized()
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async{
                        self.tableView.isHidden = true
                        self.errorVew.isHidden = false
                        self.imgError.image=UIImage(named: "claimnotfound")
                        self.lblErrorTitle.text = "No data found"
                        self.lblErrorDetails.text = "During_Enrollment_Detail_ErrorMsg".localized()
                    }
                }
            })
        }else{
            DispatchQueue.main.async{
                self.tableView.isHidden = true
                self.errorVew.isHidden = false
                self.imgError.image=UIImage(named: "nointernet")
                self.lblErrorTitle.text = error_NoInternet
                self.lblErrorDetails.text = ""
            }
        }
        
    }
    
    func updateClaimDetails(){
        if isConnectedToNet(){
            var Doc_Req_By : String = passdata?.doc_req_by ?? ""
            var clm_pre_hosp : String = passdata?.clm_pre_hosp ?? ""
            var clm_main_hosp : String = passdata?.clm_main_hosp ?? ""
            var clm_post_hosp : String = passdata?.clm_post_hosp ?? ""
            var claim_intimated : String = passdata?.claim_intimated ?? ""
            var clm_int_sr_no : String = passdata?.clm_int_sr_no ?? ""
            var clm_intimation_no : String = passdata?.clm_intimation_no ?? ""
            var person_sr_no : String = passdata?.person_sr_no ?? ""
            var clm_dest : String = passdata?.clm_Dest ?? ""
            var doc_upload_req_sr_no = passdata?.clm_docs_upload_req_sr_no ?? ""
            let appendUrl = "IntimateClaim/updateCliamDetails?CLM_DOCS_UPLOAD_REQ_SR_NO=\(doc_upload_req_sr_no)&DOC_REQ_BY=\(Doc_Req_By)&IS_CLM_PRE_HOSP=\(clm_pre_hosp)&IS_CLM_MAIN_HOSP=\(clm_main_hosp)&IS_CLM_POST_HOSP=\(clm_post_hosp)&CLAIM_INTIMATED=\(claim_intimated)&CLAIM_INTIMATED_DEST=\(clm_dest)&CLM_INT_SR_NO=\(clm_int_sr_no)&CLAIM_INTIMATION_NO=\(clm_intimation_no)&PERSON_SR_NO=\(person_sr_no)"
            
            var dict : [String:Any] = [:]
            print(appendUrl)
            webServices().postRequestForJsonCDU(appendUrl, dict, completion: { (data,error) in
                if error == ""{
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        print(json)
                        // Process the JSON data
                        let responseDict = json as? [String: Any]
                       
                        let status = responseDict?["Status"] as? Bool
                        if status == true{
                            DispatchQueue.main.async{
                                let vc : ClaimFileUploadViewController = ClaimFileUploadViewController()
                                vc.editdata = self.editData
                                vc.passdata = self.passdata
                                vc.isFromEdit = true
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }catch{
                        
                    }
                    
                }else{
                    DispatchQueue.main.async{
                        self.tableView.isHidden = true
                        self.errorVew.isHidden = false
                        self.imgError.image=UIImage(named: "claimnotfound")
                        self.lblErrorTitle.text = "No data found"
                        self.lblErrorDetails.text = "During_Enrollment_Detail_ErrorMsg".localized()
                    }
                }
                
            })
        }else{
            DispatchQueue.main.async{
                self.tableView.isHidden = true
                self.errorVew.isHidden = false
                self.imgError.image=UIImage(named: "nointernet")
                self.lblErrorTitle.text = error_NoInternet
                self.lblErrorDetails.text = ""
            }
        }
            
        
    }
    
    func addClaimDetails(){
        if isConnectedToNet(){
            var Doc_Req_By : String = passdata?.doc_req_by ?? ""
            var clm_pre_hosp : String = passdata?.clm_pre_hosp ?? ""
            var clm_main_hosp : String = passdata?.clm_main_hosp ?? ""
            var clm_post_hosp : String = passdata?.clm_post_hosp ?? ""
            var claim_intimated : String = passdata?.claim_intimated ?? ""
            var clm_int_sr_no : String = passdata?.clm_int_sr_no ?? ""
            var clm_intimation_no : String = passdata?.clm_intimation_no ?? ""
            var person_sr_no : String = passdata?.person_sr_no ?? ""
            var clm_dest : String = passdata?.clm_Dest ?? ""
            let appendUrl = "IntimateClaim/addcliamdetailsDB?DOC_REQ_BY=\(Doc_Req_By)&IS_CLM_PRE_HOSP=\(clm_pre_hosp)&IS_CLM_MAIN_HOSP=\(clm_main_hosp)&IS_CLM_POST_HOSP=\(clm_post_hosp)&CLAIM_INTIMATED=\(claim_intimated)&CLAIM_INTIMATED_DEST=\(clm_dest)&CLM_INT_SR_NO=\(clm_int_sr_no)&CLAIM_INTIMATION_NO=\(clm_intimation_no)&PERSON_SR_NO=\(person_sr_no)"
            var dict : [String:Any] = [:]
            print(appendUrl)
            webServices().postRequestForJsonCDU(appendUrl, dict, completion: { (data,error) in
                if error == ""{
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        print(json)
                        // Process the JSON data
                        let responseDict = json as? [String: Any]
                        let res = responseDict?["Res"] as? [String:Any]
                        let msg = res?["Message"] as? String
                        let status = res?["Status"] as? Bool
                        print(msg)
                        if status == true{
                            DispatchQueue.main.async{
                                let vc : ClaimFileUploadViewController = ClaimFileUploadViewController()
                                print(self.passdata)
                                var srNo = responseDict?["CLM_DOCS_UPLOAD_REQ_SR_NO"] as! Int
                                print(srNo)
                                self.passdata?.clm_docs_upload_req_sr_no = String(srNo)
                                
                                print(self.passdata)
                                vc.passdata = self.passdata
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }catch{
                        
                    }
                    
                }else{
                    DispatchQueue.main.async{
                        self.tableView.isHidden = true
                        self.errorVew.isHidden = false
                        self.imgError.image=UIImage(named: "claimnotfound")
                        self.lblErrorTitle.text = "No data found"
                        self.lblErrorDetails.text = "During_Enrollment_Detail_ErrorMsg".localized()
                    }
                }
                
            })
        }else{
            DispatchQueue.main.async{
                self.tableView.isHidden = true
                self.errorVew.isHidden = false
                self.imgError.image=UIImage(named: "nointernet")
                self.lblErrorTitle.text = error_NoInternet
                self.lblErrorDetails.text = ""
            }
        }
    }
    
    func getDetails(_ ClaimIntSrNo : String, _ index:IndexPath){
        let appendUrl = "IntimateClaim/getIntimationDetailsFor?ClaimIntSrNo=\(ClaimIntSrNo)"
        webServices().getRequestForJsonCDU(appendUrl, completion: { (data,error,resp) in
            if error != ""{
                self.errorVew.isHidden = false
                self.tableView.isHidden = true
            }else{
                if let httpResponse = resp as? HTTPURLResponse//response as? HTTPURLResponse
                {
                    print("getDetailsPortal: ",httpResponse.statusCode)
                    if httpResponse.statusCode == 200
                    {
                        
                       // do {
                            let json = try! JSONDecoder().decode(GetClaimDetails.self, from: data!)
                            var arr = json.detail
                            self.arrList = arr ?? []
                            if self.arrList.count > 0{
//                                self.errorVew.isHidden = true
//                                self.tableView.isHidden = false
//                                self.arrBenefits[index.row].age = self.arrList[0].age
//                                self.arrBenefits[index.row].DOB = self.arrList[0].dateOfBirth
//                                self.arrBenefits[index.row].gender = self.arrList[0].gender
//                                self.arrBenefits[index.row].mobile = self.arrList[0].cellphoneNumber
                                
                            }else{
//                                self.errorVew.isHidden = false
//                                self.tableView.isHidden = true
                            }
                        print(self.arrBenefits)
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                        }
                            
//                        }catch{
//                         print("catch")
//                            DispatchQueue.main.async{
////                                self.errorVew.isHidden = false
////                                self.tableView.isHidden = true
//                                self.tableView.reloadData()
//                            }
//                        }
                    }else{
                        self.errorVew.isHidden = false
                        self.tableView.isHidden = true
                    }
                }
            }
            
        })
    }
    
    func getClaimDetailsJson(_ claimSrNo : String,_ index : IndexPath){
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: """
Please wait...
Fetching Claim details
""")
            
            m_productCode = "GMC"
            //let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            //m_employeedict=userArray[0]
            
            var claimsrno = String()
            var groupChildSrNo = String()
            var oeGroupBaseSrNo = String()
            
           
                claimsrno = String(claimSrNo)
                print("claimsrno: ",claimsrno)
                claimsrno = try! AES256.encrypt(input: claimsrno, passphrase: m_passphrase_Portal)
            
            if let groupChlNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String
            {
                groupChildSrNo=String(groupChlNo)
                print("groupChildSrNo: ",groupChildSrNo)
                groupChildSrNo = try! AES256.encrypt(input: groupChildSrNo, passphrase: m_passphrase_Portal)
                
            }
            if let oergNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String
            {
                oeGroupBaseSrNo=String(oergNo)
                print("oeGroupBaseSrNo: ",oeGroupBaseSrNo)
                oeGroupBaseSrNo = try! AES256.encrypt(input: oeGroupBaseSrNo, passphrase: m_passphrase_Portal)
            }
            
            let urlString = WebServiceManager.sharedInstance.getLoadDetailedClaimsValuesJson(groupChildSrNo: groupChildSrNo.URLEncoded, oegrpbasinfsrno: oeGroupBaseSrNo.URLEncoded, claimsrno: claimsrno.URLEncoded)
            
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

            
            print("getClaimDetailsJson: ",urlString)
           
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                // Check if a response was received
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("No response received")
                    return
                }
                
                print("getClaimDetailsJson httpResponse.statusCode: ",httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
                    // Check if data was returned
                    guard let data = data else {
                        print("No data received")
                        return
                    }
                    
                    // Parse the JSON response
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        // Process the JSON data
                        if let responseDict = json as? [String: Any],
                           let messageDict = responseDict["message"] as? [String: Any],
                           let errorMessage = messageDict["Message"] as? String {
                            print("Error message: \(errorMessage)")
                            
                            if errorMessage.elementsEqual("Error occured in Process"){
                                self.hidePleaseWait()
                            }
                            else if errorMessage.elementsEqual("Details found"){
                                print("Processed data..")
                                
                                //                                let m_statusDetailsDict = json as! NSDictionary
                                //                                self.resultsDictArray = json as? [[String: String]]
                                
                                // Access the m_statusDetailsDict as needed
                                DispatchQueue.main.async{
                                let jsonData = try! JSONDecoder().decode(ClaimDetails.self, from: data)
                                print("getClaimDetailsJson Data:: ",jsonData)
                                self.memberInfo = jsonData.memberInformation
//                                self.claimPaymentInfo = jsonData.claimPaymentInformation
//                                //self.claimFIRInfo = jsonData.claimFirInformation
//                                self.claimProcessInfo = jsonData.claimProcessInformation
//                                self.claimAilmentInfo = jsonData.claimAilmentInformation
//                                self.claimHospitalInfo = jsonData.claimHospitalInformation
//                                self.claimIncidentInfo = jsonData.claimIncidentInformation
//                                self.claimCashlessInfo = jsonData.claimCashlessInformation
//                                self.claimFileInfo = jsonData.claimFileDtInformation
//                                self.claimChargesInfo = jsonData.claimChargesInformation
                                 
                            }
                            }
                        }
                    } catch {
                        print("Failed to parse JSON: \(error.localizedDescription)")
                    }
                } else {
                    print("HTTP status code: \(httpResponse.statusCode)")
                }
            }
                        
            // Start the data task
            task.resume()
            
            
            //Old
            /*
            let requrl = "http://localhost:56803/api/EnrollmentDetails/LoadDetailedClaimsValues?groupchildsrno=1396&oegrpbasinfsrno=1606&claimsrno=335"
            
            EnrollmentServerRequestManager.serverInstance.getRequestDataFromServerPostNew(url: requrl, view: self) { (data, error) in
                
                if error == nil
                {
                    do{
                        let d : Data = data!
                        let jsonData = try JSONDecoder().decode(ClaimDetails.self, from: d)
                        self.memberInfo = jsonData.memberInformation
                        self.claimFIRInfo = jsonData.claimFirInformation
                        self.claimProcessInfo = jsonData.claimProcessInformation
                        self.claimAilmentInfo = jsonData.claimAilmentInformation
                        self.claimHospitalInfo = jsonData.claimHospitalInformation
                        self.claimIncidentInfo = jsonData.claimIncidentInformation
                        self.claimCashlessInfo = jsonData.claimCashlessInformation
                        self.setDataUsingJson()
                        self.hidePleaseWait()
                        self.m_loaderView.isHidden=true
                        
                    }catch{
                        
                    }
                }else{
                    
                }
            }
             */
        }else{
            print("No internet")
        }
    }
    
    func loadBeneficiary(){
        if isConnectedToNet(){
            let appendUrl = "IntimateClaim/LoadBeneficiary?employeesrno=\(employeeSrNoGMC)&groupchildsrno=\(userGroupChildNo)&oegrpbasinfsrno=\(userOegrpNo)"
            
            webServices().getRequestForJsonCDU(appendUrl, completion: { (data,error,resp) in
                if error != ""{
                    DispatchQueue.main.async{
                        self.tableView.isHidden = true
                        self.errorVew.isHidden = false
                        self.imgError.image=UIImage(named: "claimnotfound")
                        self.lblErrorTitle.text = "No data found"
                        self.lblErrorDetails.text = "During_Enrollment_Detail_ErrorMsg".localized()
                    }
                }else{
                    if let httpResponse = resp as? HTTPURLResponse//response as? HTTPURLResponse
                    {
                        print("getDetailsPortal: ",httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            do {
                                let json = try JSONDecoder().decode(GetBeneficiaryDetails.self, from: data!)
                                self.arrTpa = json.detail
                                print(self.arrTpa)
                                if self.isFromEdit{
                                    if self.arrTpa.count > 0{
                                        for i in 0..<self.arrTpa.count{
                                            if self.editData!.personSrNo == self.arrTpa[i].personSrNo{
                                                self.isSelected = i
                                                self.passdata?.clm_intimation_no = self.claimIntimationNo_TxtField.text!
                                                self.passdata?.clm_int_sr_no = "0"
                                               self.passdata?.doc_req_by = userEmployeeSrno
                                                self.passdata?.person_sr_no = self.arrTpa[i].personSrNo
                                                DispatchQueue.main.async{
                                                    self.btnNextStatus()
                                                }
                                                break
                                            }
                                        }
                                    }
                                   
                                }
                                DispatchQueue.main.async{
                                    if self.arrTpa.count>0{
                                        self.errorVew.isHidden = true
                                        self.tableView.isHidden = false
                                        self.tableView.reloadData()
                                    }else{
                                        self.tableView.isHidden = true
                                        self.errorVew.isHidden = false
                                        self.imgError.image=UIImage(named: "claimnotfound")
                                        self.lblErrorTitle.text = "No data found"
                                        self.lblErrorDetails.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                        
                                    }
                                }
                                
                            }catch{
                                print("catch")
                                //                            DispatchQueue.main.async{
                                //                                self.errorVew.isHidden = false
                                //                                self.tableView.isHidden = true
                                //                                self.tableView.reloadData()
                                //                            }
                            }
                            
                        }else{
                            DispatchQueue.main.async{
                                self.tableView.isHidden = true
                                self.errorVew.isHidden = false
                                self.imgError.image=UIImage(named: "claimnotfound")
                                self.lblErrorTitle.text = "No data found"
                                self.lblErrorDetails.text = "During_Enrollment_Detail_ErrorMsg".localized()
                            }
                        }
                    }
                }
                
            })
        }else{
            DispatchQueue.main.async{
                self.tableView.isHidden = true
                self.errorVew.isHidden = false
                self.imgError.image=UIImage(named: "nointernet")
                self.lblErrorTitle.text = error_NoInternet
                self.lblErrorDetails.text = ""
            }
        }
    }
   
    
    func getIdwiseRelationName(_ id : String) -> String{
      
      
        var relationName : String = ""
        switch id {
        case "4":
            relationName = "Daughter"
            break
        case "3":
            relationName = "Son"
        case "21":
            relationName = "Partner"
        case "1":
            relationName = "Father"
        case "5":
            relationName = "Father-In-Law"
        case "6":
            relationName = "Mother-In-Law"
        case "2":
            relationName = "Mother"
        case "11":
            relationName = "Spouse"
        case "17":
            relationName = "Employee"
        default:
            break
        }
        return relationName
        
    }
    @IBAction func btnBackAct(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnNextAct(_ sender: UIButton) {
        print(passdata)
        if isFromEdit{
            updateClaimDetails()
        }else{
            addClaimDetails()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if claimIntimatedPalce.lowercased() == "benefits you"{
            return arrBenefits.count
        }else if claimIntimatedPalce.lowercased() == "third party administrator (tpa)"{
            return arrTpa.count
        }else{
            return arrData.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ClaimBeneficiaryDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ClaimBeneficiaryDetailsTableViewCell") as! ClaimBeneficiaryDetailsTableViewCell
        
        
        // Check if resultsDictArray is not nil and the indexPath is within its bounds
        if claimIntimatedPalce.lowercased() == "benefits you"{
            print("arrBenefits",arrBenefits)
            if !arrBenefits.isEmpty{
              
                cell.name.text = "\(arrBenefits[indexPath.row].intimationDetails.detail[0].personName)"
                let mob = arrBenefits[indexPath.row].intimationDetails.detail[0].cellphoneNumber//arrBenefits[indexPath.row].mobile ?? ""
                let gender = arrBenefits[indexPath.row].intimationDetails.detail[0].gender
                let dob = arrBenefits[indexPath.row].intimationDetails.detail[0].dateOfBirth
                let age = arrBenefits[indexPath.row].intimationDetails.detail[0].age
                let relation = getIdwiseRelationName(arrBenefits[indexPath.row].intimationDetails.detail[0].relationID)
                let claimNo = arrBenefits[indexPath.row].clmIntSrNo
                cell.mobile.text = "Mobile : \(mob)"
                cell.gender.text = "Gender : \(gender)"
                cell.dobLbl.text = "DOB : \(dob)"
                cell.ageLbl.text = "Age : \(age)"
                cell.relation.text = "\(relation)"
                cell.lblClaimNo.text = claimNo
                cell.vewClaim.alpha = 1
                cell.heightVewClaim.constant = 30
                cell.heightFirstVew.constant = 120 //dont know use
                cell.heightFirstView.constant = 120
            }
            else{
                print("arrBenefits is empty")
            }
         
        }else if claimIntimatedPalce.lowercased() == "third party administrator (tpa)"{
            if isFromEdit{
                if editData!.personSrNo == arrTpa[indexPath.row].personSrNo{
                    isSelected = indexPath.row
                }
               
            }
            
            let name = arrTpa[indexPath.row].personName
            let mob = arrTpa[indexPath.row].cellphoneNumber
            let gender = arrTpa[indexPath.row].gender
            let dob = arrTpa[indexPath.row].dateOfBirth
            let age = arrTpa[indexPath.row].age
            let relation = getIdwiseRelationName(arrTpa[indexPath.row].relationID)
            
           // if let dict = arrTpa[indexPath.row] {
                // Access and set values from the dictionary
                cell.name.text = "\(name)"
                cell.relation.text = "\(relation)"
                cell.ageLbl.text = "Age: \(age) (yrs)"
                cell.dobLbl.text = "DOB: \(dob)"
                cell.gender.text = "Gender: \(gender)"
                cell.mobile.text = "Mobile: \(mob)"
            cell.vewClaim.alpha = 0
            cell.heightVewClaim.constant = 0
            cell.heightFirstVew.constant = 80 //dont know use
            cell.heightFirstView.constant = 60
           // }
        }else{
            if isFromEdit{
                if editData!.clmIntSrNo == arrData[indexPath.row].claimSrNo{
                    isSelected = indexPath.row
                }
               
            }
            let name = arrData[indexPath.row].beneficiary
            let mob = arrData[indexPath.row].cellphoneNumber
            let gender = arrData[indexPath.row].gender
            let dob = arrData[indexPath.row].dateOfBirth
            let age = arrData[indexPath.row].age
            let relation = arrData[indexPath.row].relationWithEmployee
            let claimNo = arrData[indexPath.row].claimSrNo
            cell.name.text = "\(name)"
            cell.relation.text = "\(relation)"
            cell.ageLbl.text = "Age: \(age) (yrs)"
            cell.dobLbl.text = "DOB: \(dob)"
            cell.gender.text = "Gender: \(gender)"
            cell.mobile.text = "Mobile: \(mob)"
            cell.lblClaimNo.text = claimNo
            cell.vewClaim.alpha = 1
            cell.heightVewClaim.constant = 30
            cell.heightFirstVew.constant = 120 //dont know use
            cell.heightFirstView.constant = 120
        }
        var relation = cell.relation.text
        var gender = cell.gender.text
        print(relation)
        print(gender)
        if relation?.lowercased() == "daughter"{
            cell.relationIcon.image = UIImage(named: "daughter")
        }else if relation?.lowercased() == "son"{
            cell.relationIcon.image = UIImage(named: "son")
        }else if relation?.lowercased() == "mother" || relation?.lowercased() == "mother in law"{
            cell.relationIcon.image = UIImage(named: "women")
        }else if relation?.lowercased() == "father" || relation?.lowercased() == "father in law"{
            cell.relationIcon.image = UIImage(named: "Male")
        }else{
          if relation?.lowercased() == "employee"{
                if gender!.lowercased().contains("female"){
                    cell.relationIcon.image = UIImage(named: "women")
                }else{
                    cell.relationIcon.image = UIImage(named: "Male")
                }
            }
        }
        
       
        
        if indexPath.row == isSelected{
           
            cell.secondView.alpha = 1
            cell.radioBtnImg.image = UIImage(named: "greyRadioClose")
        }
        else{
           
            cell.secondView.alpha = 0
            cell.radioBtnImg.image = UIImage(named: "greyRadioOpen")
        }
        shadowForCell(view: cell.mainView)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == isSelected{
            //return 230
            if claimIntimatedPalce.lowercased() == "benefits you"{
                return 230
            }else if claimIntimatedPalce.lowercased() == "third party administrator (tpa)"{
              return 170
            }else{
                return 230
            }
        }else {
            
            if claimIntimatedPalce.lowercased() == "benefits you"{
                return 150
            }else if claimIntimatedPalce.lowercased() == "third party administrator (tpa)"{
              return 100
            }else{
                return 150
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelected == indexPath.row {
            isSelected = -1
            btnNext.isUserInteractionEnabled = false
            btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
            bottomVew.alpha = 0
            
        }
        else {
            isSelected = indexPath.row
            
            if claimIntimatedPalce.lowercased() == "benefits you"{
                //getDetails(arrBenefits[indexPath.row].clmIntSrNo, indexPath)
                passdata?.clm_intimation_no = arrBenefits[indexPath.row].claimIntimationNo
                passdata?.clm_int_sr_no = arrBenefits[indexPath.row].clmIntSrNo
                passdata?.doc_req_by = userEmployeeSrno
                passdata?.person_sr_no = arrBenefits[indexPath.row].intimationDetails.detail[0].personSrNo
                
            }else if claimIntimatedPalce.lowercased() == "third party administrator (tpa)"{
                passdata?.clm_intimation_no = claimIntimationNo_TxtField.text!
                passdata?.clm_int_sr_no = "0"
                passdata?.doc_req_by = userEmployeeSrno
                passdata?.person_sr_no = arrTpa[indexPath.row].personSrNo
               // getClaimDetailsJson("", indexPath)
            }else{
                passdata?.clm_intimation_no = arrData[indexPath.row].claimNo.replacingOccurrences(of: " ", with: "")
                passdata?.clm_int_sr_no = arrData[indexPath.row].claimSrNo
                passdata?.doc_req_by = userEmployeeSrno
                passdata?.person_sr_no = arrData[indexPath.row].personSrNo
            }
            self.btnNextStatus()
        }
       // delegate?.selectionStatusDidChange(isSuccess: true)
        tableView.reloadData()
    }
    
    func btnNextStatus(){
//        if let text = claimIntimationNo_TxtField.text, text.isEmpty {
//            if claimIntimatedPalce.lowercased() == "benefits you"{
//
//            }
//            btnNext.isUserInteractionEnabled = false
//            btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
//        }
//        else{
       
       
            if isSelected <= -1{
                btnNext.isUserInteractionEnabled = false
                btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
                bottomVew.alpha = 0
            }
            else{
                if claimIntimatedPalce.lowercased() == "third party administrator (tpa)" && claimIntimationNo_TxtField.text == ""{
                    btnNext.isUserInteractionEnabled = false
                    btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
                    bottomVew.alpha = 0
                }else{
                    btnNext.isUserInteractionEnabled = true
                    btnNext.backgroundColor = FontsConstant.shared.app_FontAppColor
                    bottomVew.alpha = 1
                }
            
        }
        //}
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // This method is called whenever the user enters or deletes text.
        // You can examine the `string` parameter to determine the entered text.

        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        print(updatedText)
        if updatedText == ""{
            // The user deleted a character.
            print("replacementString character")
            claimIntimationNo_TxtField.text = ""
          
        } else {
            // The user entered text.
            print("Entered text: \(string)")
            let newLength = textField.text?.count ?? 0 + string.count - range.length
            print(newLength)
           // claimIntimationNo_TxtField.text = updatedText
        }
        self.btnNextStatus()
        
        let allowedCharacterSet = CharacterSet.alphanumerics
           let newCharacterSet = CharacterSet(charactersIn: string)

           return allowedCharacterSet.isSuperset(of: newCharacterSet)

       
        
        
       // return true // Return true to allow the text change, or false to reject it.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder() // Dismiss the keyboard
           return true
       }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.text)
    }
  
   
}
