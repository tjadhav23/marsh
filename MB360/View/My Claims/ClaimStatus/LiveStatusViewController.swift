//
//  LiveStatusViewController.swift
//  MyBenefits
//
//  Created by Semantic on 04/10/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
//import StepIndicator
import FirebaseCrashlytics
import TrustKit
import AesEverywhere

class LiveStatusViewController: UIViewController,XMLParserDelegate {

    @IBOutlet weak var m_dobValueLbl: UILabel!
    @IBOutlet weak var m_cashlessStatusViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nametitle: UILabel!
    @IBOutlet weak var m_tpaIDLbl: UILabel!
    
    @IBOutlet weak var m_notPaybleValueLbl: UILabel!
    @IBOutlet weak var tpaIDtitle: UILabel!
    @IBOutlet weak var ageTitle: UILabel!
    @IBOutlet weak var genderTitle: UILabel!
    @IBOutlet weak var relationtitle: UILabel!
    @IBOutlet weak var m_ageLbl: UILabel!
    @IBOutlet weak var m_genderLbl: UILabel!
    
    @IBOutlet weak var m_loaderView: UIView!
    
   
    @IBOutlet weak var m_firstViewProgressLine: UIView!
    @IBOutlet weak var m_relationLbl: UILabel!
    
   @IBOutlet weak var m_progressView: UIView!
    @IBOutlet weak var m_stepperHeight: NSLayoutConstraint!
    
    @IBOutlet weak var m_claimStatusLbl3: UILabel!
    
    @IBOutlet weak var m_secondViewSymbol: UIImageView!
    @IBOutlet weak var m_firstViewSymbol: UIImageView!
    @IBOutlet weak var m_thirdViewSymbol: UIImageView!
    

    //    @IBOutlet weak var m_StepindicatorView: StepIndicatorView!
    
    
    
    @IBOutlet weak var m_scrollView: UIScrollView!
    @IBOutlet weak var m_subView2: UIView!
    
    @IBOutlet weak var m_subView4: UIView!
    @IBOutlet weak var m_subView3: UIView!
    @IBOutlet weak var m_subview1: UIView!
    @IBOutlet weak var m_view1: UIView!
    
    
    @IBOutlet weak var m_cashlessStatusValue2: UILabel!
    @IBOutlet weak var m_cashlessStatusValue1: UILabel!
    @IBOutlet weak var m_cashlessStatusLbl2: UILabel!
    @IBOutlet weak var m_cashlessStatusLbl1: UILabel!
    @IBOutlet weak var m_cashlessStatusImageView: UIImageView!
    @IBOutlet weak var m_cashlessStatusTitleLbl: UILabel!
    @IBOutlet weak var m_cashlessStatusView: UIView!
    @IBOutlet weak var m_cashlessInformationView: UIView!
    @IBOutlet weak var m_claimPaidView: UIView!
    
    @IBOutlet weak var m_view4: UIView!
  
    // Reimbursment View
    @IBOutlet weak var m_reimbursmentClaimStatusView: UIView!
    @IBOutlet weak var m_reimbursmentStatuslbl1: UILabel!
    @IBOutlet weak var m_reimbursmentStatusValue1: UILabel!
    @IBOutlet weak var m_reimbursmentStatuslblSide1: UILabel!
    @IBOutlet weak var m_reimbursmentStatusValueSide1: UILabel!
    @IBOutlet weak var m_reimbursmentStatusLbl2: UILabel!
    @IBOutlet weak var m_reimbursmentStatusValue2: UILabel!
    @IBOutlet weak var m_deficienciesValueLbl: UILabel!
    @IBOutlet weak var m_deficiencyTitleLbl: UILabel!
    @IBOutlet weak var m_reimbursmentStatusLbl4: UILabel!
    @IBOutlet weak var m_reimbursmentStatusValue4: UILabel!
    @IBOutlet weak var m_reimbursmentStatusLbl5: UILabel!
    @IBOutlet weak var m_reimbursmentStatusValue5: UILabel!
    
    
    
    
    //Cashless Reported on view
    @IBOutlet weak var m_secondTitleLbl: UILabel!
    @IBOutlet weak var CashlessReportedOnIcon: UIImageView!
    @IBOutlet weak var CashlessReportedonDate: UILabel!
    @IBOutlet weak var ClaimNumberHeader: UILabel!
    @IBOutlet weak var m_claimNUmber: UILabel!
    @IBOutlet weak var EstimatedAmtHeader: UILabel!
    @IBOutlet weak var m_estimatedAmountLbl: UILabel!
    @IBOutlet weak var NameofProviderHeader: UILabel!
    @IBOutlet weak var m_hospitalNameLBL: UILabel!
    @IBOutlet weak var CashlessDenialDateHeader: UILabel!
    @IBOutlet weak var CashlessDenialDateLbl: UILabel!
    @IBOutlet weak var CashlessReported_Border1: UILabel!
    @IBOutlet weak var CashlessAmtHeader: UILabel!
    @IBOutlet weak var CashlessAmtLbl: UILabel!
    @IBOutlet weak var DateOfAdmissionHeader: UILabel!
    @IBOutlet weak var m_dateOfAdmission: UILabel!
    @IBOutlet weak var dischargeHeader: UILabel!
    @IBOutlet weak var m_dateOfDischarge: UILabel!
    @IBOutlet weak var AilmentHeader: UILabel!
    @IBOutlet weak var ailmentLBl: UILabel!
    
    
    
    var m_claimDetailsDict : MyClaimsDetails?
    var m_employeedict : EMPLOYEE_INFORMATION?
    var m_groupDict : OE_GROUP_BASIC_INFORMATION?
    var statusDict : [String: String]?
    var m_productCode = String()
    var xmlKey = String()
    var xmlKeysArray = ["BasicClaimInformation","ClaimMemberInformation","ClaimIncidentInformation","ClaimProcessInformation","ClaimCashlessInformation","ClaimHospitalInformation","ClaimAilmentInformation","ClaimChargesInformation","ClaimFileInformation","ClaimPaymentInformation"]
    let dictionaryKeys = ["ClaimSrNo", "ClaimNo", "UniqueClaimNo", "GroupCode", "EmployeeNo", "EmployeeSrNo", "BeneficiaryName", "EmployeeName","Age", "Relation", "DateOfBirth", "Gender", "SumInsured", "ClaimDate", "TypeOfClaim", "ClaimStatus", "ClaimOutstandingStatus", "ClaimReportedAmount", "ClaimAmount", "ClaimPaidAmount", "ClaimPaidDate", "ClaimRejectedDate", "ClaimClosedDate", "ClaimDenialReasons", "ClaimClosureReasons", "CashlessStatus", "CashlessRequestedOn","TPAId", "CashlessSentDate","CashlessAmount","HospitalName","Ailment","FinalDiagnosis","FinalBillAmount","NonPayableExpenses","CoPaymentDeductions","DeductionReasons","FileReceivedDate","Deficiencies","FirstDeficiencyLetterDate","SecondDeficiencyLetterDate","DeficiencyIntimationDate","DeficiencyRetrivalDate","DateOfSettlement","AmountPaidToHospital","BankOrChequeNo","AmountPaidToMember","ChequeNoToMember","DateOfPaymentToMember","DateOfPaymentToHospital","DateOfAdmission","DateOfDischarge"]
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    var indexNumber = Int()
    var m_statusDetailsDict = NSDictionary()
    var memberInfo : MemberInformation? = nil
    //var claimFIRInfo : ClaimFirInformation? = nil
    var claimProcessInfo : ClaimProcessInformation? = nil
    var claimAilmentInfo : ClaimAilmentInformation? = nil
    var claimHospitalInfo : ClaimHospitalInformation? = nil
    var claimIncidentInfo : ClaimIncidentInformation? = nil
    var claimCashlessInfo : ClaimCashlessInformation? = nil
    var claimPaymentInfo : ClaimPaymentInformation? = nil
    var claimFileInfo : ClaimFileDtInformation? = nil
    var claimChargesInfo : ClaimChargesInformation? = nil
//    var shimmer: FBShimmeringView!
    
    
    @IBOutlet weak var m_nameLbl: UILabel!
    
    
    @IBOutlet weak var m_BillAmountValueLbl: UILabel!
    @IBOutlet weak var m_BillDateValueLbl: UILabel!
    @IBOutlet weak var m_paidAmountValueLbl: UILabel!
    @IBOutlet weak var m_paidDateValueLbl: UILabel!
    @IBOutlet weak var m_chequeNumberValueLbl: UILabel!
    @IBOutlet weak var m_deductionValuelbl: UILabel!
    @IBOutlet weak var m_deductionReasonValueLbl: UILabel!
    
    
    @IBOutlet weak var m_claimStatusLbl4: UILabel!
  
    
    
    
    @IBOutlet weak var m_cliamDateLbl: UILabel!
    
    
    
    
    @IBOutlet weak var m_cashlessStatusValueLbl: UILabel!
    
    @IBOutlet weak var m_cashlessRequestedValueLBl: UILabel!
    
    @IBOutlet weak var m_cashlessAmountLbl: UILabel!
    @IBOutlet weak var m_cashlessAuthorisedOnValueLbl: UILabel!
    
    @IBOutlet weak var heightVerticalVew1: NSLayoutConstraint!
    
    @IBOutlet weak var heightCashlessDenialOn: NSLayoutConstraint!
    
    @IBOutlet weak var heightCashlessDenialOnVal: NSLayoutConstraint!
    
    @IBOutlet weak var heightCashlessAmt: NSLayoutConstraint!
    
    @IBOutlet weak var heightCashlessAmtVal: NSLayoutConstraint!
    
    @IBOutlet weak var lblClaimExtension: UILabel!
    
//    var timer = Timer()
//    let delay = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        
//        shimmer = FBShimmeringView(frame: self.m_scrollView.frame)
//        shimmer.contentView = m_scrollView
//        self.view.addSubview(shimmer)
//        shimmer.isShimmering = true
       
        
        let userArray : [OE_GROUP_BASIC_INFORMATION] = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "")
        if (userArray.count>0)
        {
            
            m_groupDict=userArray[0]
        }
        layoutViews()
        
        m_deductionReasonValueLbl.isUserInteractionEnabled=true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (viewMoreButtonTapped (_:)))
        m_deductionReasonValueLbl.addGestureRecognizer(gesture)
        
        
        
        
        
//        nametitle.backgroundColor=hexStringToUIColor(hex: "EAF1F1")
//        relationtitle.backgroundColor=hexStringToUIColor(hex: "EAF1F1")
//        genderTitle.backgroundColor=hexStringToUIColor(hex: "EAF1F1")
//        ageTitle.backgroundColor=hexStringToUIColor(hex: "EAF1F1")
//        tpaIDtitle.backgroundColor=hexStringToUIColor(hex: "EAF1F1")
//        m_nameLbl.text=""
//        m_relationLbl.text=""
//        m_genderLbl.text=""
//        m_ageLbl.text=""
//        m_tpaIDLbl.text=""
//        m_nameLbl.backgroundColor=hexStringToUIColor(hex: "EAF1F1")
//        m_relationLbl.backgroundColor=hexStringToUIColor(hex: "EAF1F1")
//        m_genderLbl.backgroundColor=hexStringToUIColor(hex: "EAF1F1")
//        m_ageLbl.backgroundColor=hexStringToUIColor(hex: "EAF1F1")
//        m_tpaIDLbl.backgroundColor=hexStringToUIColor(hex: "EAF1F1")
  
  
        
        
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
//        let newDashboardVC : NewDashboardViewController = NewDashboardViewController()
//        navigationController?.popToViewController(newDashboardVC, animated: true)
        navigationController?.popViewController(animated: true)
        tabBarController!.selectedIndex = 2
    }
    override func viewDidAppear(_ animated: Bool)
    {
        menuButton.isHidden=true
//        timer.invalidate()
//
//        // start the timer
//        timer = Timer.scheduledTimer(timeInterval: TimeInterval(delay), target: self, selector: #selector(delayedAction), userInfo: nil, repeats: true)
//        m_progressView.setProgress(1, animated: false)
//
//        m_StepindicatorView.currentStep=0
    }
    
    func layoutViews()
    {
//        let verticalProgressView = VerticalProgressView()
//        verticalProgressView.setProgress(0.7, animated: false)
//        verticalProgressView.trackTintColor=UIColor.darkGray
//        verticalProgressView.isAscending = false
//        view.addSubview(verticalProgressView)
        
        m_firstViewSymbol.layer.masksToBounds=true
        m_firstViewSymbol.layer.cornerRadius=m_firstViewSymbol.frame.height/2
        m_secondViewSymbol.layer.masksToBounds=true
        m_secondViewSymbol.layer.cornerRadius=m_firstViewSymbol.frame.height/2
        m_thirdViewSymbol.layer.masksToBounds=true
        m_thirdViewSymbol.layer.cornerRadius=m_firstViewSymbol.frame.height/2
        
        shadowForCell(view: m_view1)
       
        
        shadowForCell(view: m_view4)
        m_view1.layer.cornerRadius=10
        m_subview1.layer.cornerRadius=15
        m_subView2.layer.cornerRadius=15
        m_subView3.layer.cornerRadius=15
        m_view4.layer.cornerRadius=10
        m_claimPaidView.layer.cornerRadius=10
        m_cashlessStatusView.layer.cornerRadius=10
        m_cashlessInformationView.layer.cornerRadius=10
        m_reimbursmentClaimStatusView.layer.cornerRadius=10
        shadowForCell(view: m_claimPaidView)
        shadowForCell(view: m_cashlessStatusView)
        shadowForCell(view: m_cashlessInformationView)
        shadowForCell(view: m_reimbursmentClaimStatusView)
        shadowForCell(view: m_claimPaidView)

    }
    
    func getClaimDetailsJson(){
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
            
            if let empNo = m_claimDetailsDict?.claimSrNo
            {
                claimsrno = String(empNo)
                print("claimsrno: ",claimsrno)
                claimsrno = try! AES256.encrypt(input: claimsrno, passphrase: m_passphrase_Portal)
            }
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
                                self.claimPaymentInfo = jsonData.claimPaymentInformation
                                //self.claimFIRInfo = jsonData.claimFirInformation
                                self.claimProcessInfo = jsonData.claimProcessInformation
                                self.claimAilmentInfo = jsonData.claimAilmentInformation
                                self.claimHospitalInfo = jsonData.claimHospitalInformation
                                self.claimIncidentInfo = jsonData.claimIncidentInformation
                                self.claimCashlessInfo = jsonData.claimCashlessInformation
                                self.claimFileInfo = jsonData.claimFileDtInformation
                                self.claimChargesInfo = jsonData.claimChargesInformation
                                    
                                    print("self.claimChargesInfo:  ",self.claimChargesInfo)
                                self.setDataUsingJson()
                                self.hidePleaseWait()
                                self.m_loaderView.isHidden=true
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
    
    //Not in use
    /*
    func getClaimDetails()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: """
Please wait...
Fetching Claim details
""")
            
            m_productCode = "GMC"
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: m_productCode)
            m_employeedict=userArray[0]
            
            var claimsrno = String()
            var groupChildSrNo = String()
            var oeGroupBaseSrNo = String()
            
            if let empNo = m_claimDetailsDict?.claimSrNo
            {
                claimsrno = String(empNo)
            }
            if let groupChlNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String//m_employeedict?.groupChildSrNo
            {
                groupChildSrNo=String(groupChlNo)
            }
            if let oergNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String//m_employeedict?.oe_group_base_Info_Sr_No
            {
                oeGroupBaseSrNo=String(oergNo)
            }
          /*  let yourXML = AEXMLDocument()
            
            let dataRequest = yourXML.addChild(name: "DataRequest");
            dataRequest.addChild(name: "groupchildsrno", value:groupChildSrNo)
            dataRequest.addChild(name: "oegrpbasinfsrno", value:oeGroupBaseSrNo)
            dataRequest.addChild(name: "claimsrno", value:claimsrno)*/
            
            
          
            let string="<DataRequest><groupchildsrno>\(groupChildSrNo)</groupchildsrno><oegrpbasinfsrno>\(oeGroupBaseSrNo)</oegrpbasinfsrno><claimsrno>\(claimsrno)</claimsrno></DataRequest>"
            let uploadData = string.data(using: .utf8)
            
            //            var uploadData: Data = NSKeyedArchiver.archivedData(withRootObject: uploadDic)
            //            uploadData = try! JSONSerialization.data(withJSONObject: uploadDic, options: .prettyPrinted)
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getClaimStatusDetailsPostUrl() as String)
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody=uploadData
            print("My Claims LoadDetailedClaimsValues URL",request)
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
                                self.xmlKey = "ClaimInformation"
                                let parser = XMLParser(data: data!)
                                parser.delegate = self as? XMLParserDelegate
                                parser.parse()
                                
                                    for claimDict in self.resultsDictArray!
                                    {
                                        
                                        self.m_statusDetailsDict = claimDict as NSDictionary
                                    }
                                
                                DispatchQueue.main.async
                                    {
                                        
                                        if let count : Int = (self.resultsDictArray?.count)
                                        {
                                            self.setData()
                                        }
                                       
                                        self.hidePleaseWait()
                                        self.m_loaderView.isHidden=true
                                    }
                                
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
                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed")
                        }
                        
                    }
                    else
                    {
                        print("Can't cast response to NSHTTPURLResponse")
                        self.displayActivityAlert(title: m_errorMsg)
                        self.hidePleaseWait()
                        
                    }
                    
                }
            }
            
            task.resume()
            
            
        }
    }
    
    func setData()
    {
        
        m_nameLbl.text=m_statusDetailsDict.value(forKey: "BENEFICIARY_NAME") as? String
        let gender = m_statusDetailsDict.value(forKey: "GENDER") as? String
        m_genderLbl.text=gender
        var relation = m_statusDetailsDict.value(forKey: "Relation") as? String
        if(relation=="Spouse")
        {
            if(gender=="Male")
            {
                relation="Husband"
            }
            else
            {
                relation="Wife"
            }
        }
        
        
        m_relationLbl.text=relation
        let age = m_statusDetailsDict.value(forKey: "Age") as? String ?? ""
        m_ageLbl.text=m_statusDetailsDict.value(forKey: "DateOfBirth") as? String
        m_dobValueLbl.text=age
        
        m_cliamDateLbl.text = m_statusDetailsDict.value(forKey: "ClaimDate") as? String
        m_tpaIDLbl.text=m_statusDetailsDict.value(forKey: "TPAId") as? String
        let status = m_statusDetailsDict.value(forKey: "ClaimStatus")
        m_claimNUmber.text=m_statusDetailsDict.value(forKey: "ClaimNo") as? String
        CashlessReportedonDate.text = claimIncidentInfo?.claimDate
        m_estimatedAmountLbl.text = m_statusDetailsDict.value(forKey: "ClaimReportedAmount") as? String
        print(m_statusDetailsDict)
        m_estimatedAmountLbl.text="₹ "+m_estimatedAmountLbl.text!.currencyInputFormatting()
        let range = NSMakeRange(1, 1)
        m_estimatedAmountLbl.attributedText=attributedString(from: m_estimatedAmountLbl.text!, nonBoldRange: range)
        
        m_hospitalNameLBL.text = m_statusDetailsDict.value(forKey: "HospitalName") as? String
        
        CashlessDenialDateLbl.text = claimCashlessInfo?.cashlessSentDate
        CashlessAmtLbl.text = claimCashlessInfo?.cashlessAmount
        
        m_dateOfAdmission.text = m_statusDetailsDict.value(forKey: "DateOfAdmission") as? String
        ailmentLBl.text=m_statusDetailsDict.value(forKey: "Ailment") as? String
        m_dateOfDischarge.text=m_statusDetailsDict.value(forKey: "DateOfDischarge") as? String
        
       
       let type = m_statusDetailsDict.value(forKey: "TypeOfClaim")as?String
        if(type=="Cashless")
        {
            switch status as! String
            {
            case "Outstanding":
                m_cashlessInformationView.isHidden=false
//                m_cashlessStatusViewHeightConstraint.constant=0
                m_claimStatusLbl3.text="Cashless Information"
                m_thirdViewSymbol.image=UIImage(named: "outstanding")
//                m_thirdViewSymbol.backgroundColor=hexStringToUIColor(hex: "")
                getCashlessInformation()
                m_cashlessStatusView.isHidden=true
                m_claimPaidView.isHidden=true
                m_reimbursmentClaimStatusView.isHidden=true
                m_cashlessStatusTitleLbl.isHidden=true
                m_cashlessStatusImageView.isHidden=true
                m_firstViewProgressLine.isHidden=true
                m_progressView.isHidden=false
                
                break
                
            case "Paid":
               
                m_cashlessInformationView.isHidden=false
                
                m_claimStatusLbl3.text="Cashless Information"
                m_thirdViewSymbol.image=UIImage(named: "checkSymbol")
                getCashlessInformation()
                m_claimPaidView.isHidden=true
                m_reimbursmentClaimStatusView.isHidden=true
                m_cashlessStatusView.isHidden=true
                m_cashlessStatusTitleLbl.isHidden=true
                m_cashlessStatusImageView.isHidden=true
                
                break
                
            case "Rejected":
                m_cashlessInformationView.isHidden=false
                m_cashlessStatusView.isHidden=false
                
                getCashlessInformation()
                m_thirdViewSymbol.image=UIImage(named: "close")
                m_cashlessStatusTitleLbl.text="Cashless Rejection Information"
                m_cashlessStatusLbl1.text="Rejected On"
                m_cashlessStatusLbl2.text="Rejection Reason - Closure Reason"
                m_cashlessStatusValue1.text="-"
                m_cashlessStatusValue2.text="-"
                
                m_reimbursmentClaimStatusView.isHidden=true
                m_claimPaidView.isHidden=true
                break
                
            case "Closed":
                m_cashlessInformationView.isHidden=false
                m_cashlessStatusView.isHidden=false
                getCashlessInformation()
                m_thirdViewSymbol.image=UIImage(named: "close")
                m_cashlessStatusTitleLbl.text="Cashless Closure Information"
                m_cashlessStatusLbl1.text="Closed On"
                m_cashlessStatusLbl2.text="Closure Reason - Denial Reason"
                m_cashlessStatusValue1.text="-"
                m_cashlessStatusValue2.text="-"
                
                m_reimbursmentClaimStatusView.isHidden=true
                m_claimPaidView.isHidden=true
                break
                
            case "Denied":
                m_cashlessInformationView.isHidden=false
                m_cashlessStatusView.isHidden=false
                m_cashlessStatusTitleLbl.isHidden=false

                
                getCashlessInformation()
                m_thirdViewSymbol.image=UIImage(named: "close")
                m_cashlessStatusTitleLbl.text="Cashless Denial Information"
                m_cashlessStatusLbl1.text="Denied On"
                m_cashlessStatusLbl2.text="Denial Reasons"
                m_cashlessStatusValue1.text="-"
                m_cashlessStatusValue2.text="-"

                m_reimbursmentClaimStatusView.isHidden=true
                m_claimPaidView.isHidden=true
                break
            default:
                /*
                m_claimPaidView.isHidden=true
                m_cashlessInformationView.isHidden = true
                m_reimbursmentClaimStatusView.isHidden = true
                m_cashlessStatusView.isHidden = true
                m_thirdViewSymbol.isHidden = true
                m_claimStatusLbl3.isHidden = true
                m_cashlessStatusImageView.isHidden = true
                m_cashlessStatusTitleLbl.isHidden = true
                m_progressView.isHidden = true
                m_firstViewProgressLine.isHidden = false
                */
                break
            }
        }
        else if(type=="Reimbursement")
        {
                
                    switch status as? String
                    {
                    case "Outstanding":
                        if(m_statusDetailsDict.value(forKey: "ClaimOutstandingStatus")as? String=="Deficient")
                        {
                            m_claimStatusLbl3.text="Claim Deficiency Details"
                            m_statusDetailsDict.value(forKey: "ClaimOutstandingStatus")
                            m_thirdViewSymbol.image=UIImage(named: "outstanding")
                            m_reimbursmentStatuslbl1.text="Deficiency Details"
                            m_reimbursmentStatusLbl2.text="Deficiency Raised On"
                            m_reimbursmentStatusValue1.text=m_statusDetailsDict.value(forKey: "Deficiencies")as? String
                            m_reimbursmentStatusValue2.text=m_statusDetailsDict.value(forKey: "DeficiencyIntimationDate")as? String

                            m_cashlessInformationView.isHidden=true
                            m_cashlessStatusView.isHidden=true
                            m_cashlessStatusTitleLbl.isHidden=true
                            m_cashlessStatusImageView.isHidden=true
                            m_claimPaidView.isHidden=true
                            m_deficiencyTitleLbl.isHidden=true
                            m_deficienciesValueLbl.isHidden=true
//                            m_firstViewProgressLine.isHidden=false
//                            m_progressView.isHidden=true
                            
                            
                        }
                        else
                        {
                            m_claimStatusLbl3.text=""
                            m_thirdViewSymbol.isHidden=true
                            m_cashlessInformationView.isHidden=true
                            m_cashlessStatusView.isHidden=true
                            m_cashlessStatusTitleLbl.isHidden=true
                            m_cashlessStatusImageView.isHidden=true
                            m_claimPaidView.isHidden=true
                            m_reimbursmentClaimStatusView.isHidden=true
                            m_firstViewProgressLine.isHidden=false
                            m_progressView.isHidden=true
                        }
                        
                        
                        break
                    case "Paid":
                        m_claimStatusLbl3.text="Claim Payment Information"
                        m_thirdViewSymbol.image=UIImage(named: "checkSymbol")
                        m_claimPaidView.isHidden=false
                        m_paidAmountValueLbl.text=m_statusDetailsDict.value(forKey: "ClaimPaidAmount") as? String
                        
                        m_paidAmountValueLbl.text="₹ "+m_paidAmountValueLbl.text!.currencyInputFormatting()
                        let range = NSMakeRange(1, 1)
                        m_paidAmountValueLbl.attributedText=attributedString(from: m_paidAmountValueLbl.text!, nonBoldRange: range)
                        m_paidDateValueLbl.text=m_statusDetailsDict.value(forKey: "ClaimPaidDate")as? String
                        m_chequeNumberValueLbl.text=m_statusDetailsDict.value(forKey: "ChequeNoToMember")as? String
                        
                        /*var repottedAmiount:NSString = m_statusDetailsDict.value(forKey: "ClaimReportedAmount") as! NSString
                        repottedAmiount = repottedAmiount.replacingOccurrences(of: ",", with: "") as NSString
                        var paidAmount: NSString = (m_statusDetailsDict.value(forKey: "AmountPaidToMember") as? NSString)!
                        paidAmount = paidAmount.replacingOccurrences(of: ",", with: "") as NSString
                        let deduction = repottedAmiount.integerValue - paidAmount.integerValue*/
                        
                       let copayment = m_statusDetailsDict.value(forKey: "CoPaymentDeductions") as! NSString
                        let nonPayble = m_statusDetailsDict.value(forKey: "NonPayableExpenses") as! NSString
                        
                        
                        m_deductionValuelbl.text="₹ "+(nonPayble as String).currencyInputFormatting()
                        
                       
                        m_deductionValuelbl.attributedText=attributedString(from: m_deductionValuelbl.text!, nonBoldRange: range)
                        
                        if(copayment=="0")
                        {
                            m_notPaybleValueLbl.text="₹ "+(copayment as String)
                        }
                        else
                        {
                            m_notPaybleValueLbl.text="₹ "+(copayment as String).currencyInputFormatting()
                        }
                        m_notPaybleValueLbl.attributedText=attributedString(from: m_notPaybleValueLbl.text!, nonBoldRange: range)
                       
                        let reason = (m_statusDetailsDict.value(forKey: "DeductionReasons")as? String)!
                        
                       if(reason.count>100)
                       {
                        
                        let endIndex = reason.index(reason.startIndex, offsetBy: 100)
                        var truncated = reason.substring(to: endIndex)
                        truncated=truncated+"  Read more..."
                        let range = (truncated as NSString).range(of: "  Read more...")
                        let attributedString = NSMutableAttributedString(string:truncated)
                        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: hexStringToUIColor(hex: hightlightColor) , range: range)
                        m_deductionReasonValueLbl.attributedText=attributedString
                       }
                        else
                       {
                         m_deductionReasonValueLbl.text=reason
                        }
                        
                        
                        
                        
                        m_reimbursmentClaimStatusView.isHidden=true
                        m_cashlessInformationView.isHidden=true
                        m_cashlessStatusView.isHidden=true
                        m_cashlessStatusTitleLbl.isHidden=true
                        m_cashlessStatusImageView.isHidden=true
                        
                        break
                    case "Rejected":
                        m_reimbursmentClaimStatusView.isHidden=false
                        m_claimStatusLbl3.text="Claim Rejection Information"
                        m_thirdViewSymbol.image=UIImage(named: "close")
                        m_reimbursmentStatuslbl1.text="Deficiencies"
                        m_reimbursmentStatusLbl2.text="Rejected On"
                        m_deficiencyTitleLbl.text="Rejection Reasons"
                        m_deficienciesValueLbl.text=m_statusDetailsDict.value(forKey: "ClaimDenialReasons") as? String
                        m_reimbursmentStatusValue1.text=m_statusDetailsDict.value(forKey: "Deficiencies") as? String
                        m_reimbursmentStatusValue2.text=m_statusDetailsDict.value(forKey: "ClaimRejectedDate")as? String
                        
                        m_deficienciesValueLbl.isHidden=false
                        m_deficiencyTitleLbl.isHidden=false
                        m_claimPaidView.isHidden=true
                        m_cashlessInformationView.isHidden=true
                        m_cashlessStatusView.isHidden=true
                        m_cashlessStatusTitleLbl.isHidden=true
                        m_cashlessStatusImageView.isHidden=true
                        
                        break
                    case "Closed":
                        m_reimbursmentClaimStatusView.isHidden=false
                        m_claimStatusLbl3.text="Claim Closure Information"
                        m_thirdViewSymbol.image=UIImage(named: "close")
                        m_reimbursmentStatuslbl1.text="Closed On"
                        m_reimbursmentStatusLbl2.text="Closure Reasons"
                        m_reimbursmentStatusValue1.text=m_statusDetailsDict.value(forKey: "ClaimClosedDate")as? String
                        m_reimbursmentStatusValue2.text=m_statusDetailsDict.value(forKey: "ClaimClosureReasons") as? String
                        
                        m_deficienciesValueLbl.isHidden=true
                        m_deficiencyTitleLbl.isHidden=true
                        m_deficienciesValueLbl.text=""
                        m_deficiencyTitleLbl.text=""
                        
                        m_claimPaidView.isHidden=true
                        m_cashlessInformationView.isHidden=true
                        m_cashlessStatusView.isHidden=true
                        m_cashlessStatusTitleLbl.isHidden=true
                        m_cashlessStatusImageView.isHidden=true
                        
                        break
                    case "Outstanding-Deficient":
                        m_reimbursmentClaimStatusView.isHidden=false
                        m_thirdViewSymbol.image=UIImage(named: "outstanding")
//                        m_thirdViewSymbol.backgroundColor=hexStringToUIColor(hex: "9345a9")
                        m_claimStatusLbl3.text="Claim Deficiency Details"
                        m_reimbursmentStatuslbl1.text="Deficiency Details"
                        m_reimbursmentStatusLbl2.text="Deficiency Raised On"
                        m_reimbursmentStatusValue1.text=m_statusDetailsDict.value(forKey: "Deficiencies")as? String
                        m_reimbursmentStatusValue2.text=m_statusDetailsDict.value(forKey: "DeficiencyIntimationDate")as? String
                        
                        
                        m_deficienciesValueLbl.isHidden=true
                        m_deficiencyTitleLbl.isHidden=true
                        m_deficienciesValueLbl.text=""
                        m_deficiencyTitleLbl.text=""
                        m_cashlessInformationView.isHidden=true
                        m_cashlessStatusView.isHidden=true
                        m_cashlessStatusTitleLbl.isHidden=true
                        m_cashlessStatusImageView.isHidden=true
                        
                        break
                    default:
                        /*
                        m_claimPaidView.isHidden=true
                        m_cashlessInformationView.isHidden = true
                        m_reimbursmentClaimStatusView.isHidden = true
                        m_cashlessStatusView.isHidden = true
                        m_thirdViewSymbol.isHidden = true
                        m_claimStatusLbl3.isHidden = true
                        m_cashlessStatusImageView.isHidden = true
                        m_cashlessStatusTitleLbl.isHidden = true
                        m_progressView.isHidden = true
                        m_firstViewProgressLine.isHidden = false
                        */
                        break
                    }
                    
            }
        else
        {
            backButtonClicked()
        }
        delayedAction()
    }
    */
    func setDataUsingJson()
    {
        
        m_nameLbl.text=memberInfo?.beneficiaryName//m_statusDetailsDict.value(forKey: "BeneficiaryName") as? String
        lblClaimExtension.text = claimIncidentInfo?.claimExtension
        let gender = memberInfo?.gender//m_statusDetailsDict.value(forKey: "Gender") as? String
        m_genderLbl.text=gender
        var relation = memberInfo?.relation//m_statusDetailsDict.value(forKey: "Relation") as? String
        if(relation=="Spouse")
        {
            if(gender=="Male")
            {
                relation="Husband"
            }
            else
            {
                relation="Wife"
            }
        }
        
        print("claimProcessInfo: ",claimProcessInfo)
        m_relationLbl.text=relation
        let age = memberInfo?.age//m_statusDetailsDict.value(forKey: "Age") as? String ?? ""
        m_ageLbl.text=memberInfo?.dateOfBirth//m_statusDetailsDict.value(forKey: "DateOfBirth") as? String
        m_dobValueLbl.text=age
        
        m_cliamDateLbl.text = ""//claimFIRInfo?.firDate//m_statusDetailsDict.value(forKey: "ClaimDate") as? String
        //m_tpaIDLbl.text=claimProcessInfo?.tpaID//m_statusDetailsDict.value(forKey: "TPAId") as? String
        m_tpaIDLbl.text=memberInfo?.tpaID//m_statusDetailsDict.value(forKey: "TPAId") as? String
        let status = claimProcessInfo?.claimStatus//m_statusDetailsDict.value(forKey: "ClaimStatus")
        m_claimNUmber.text=claimIncidentInfo?.claimNo//m_statusDetailsDict.value(forKey: "ClaimNo") as? String
        CashlessReportedonDate.text = claimIncidentInfo?.claimDate
        m_estimatedAmountLbl.text = claimProcessInfo?.reportedAmount//m_statusDetailsDict.value(forKey: "ClaimReportedAmount") as? String
        print(m_statusDetailsDict)
        m_estimatedAmountLbl.text="₹ "+m_estimatedAmountLbl.text!.currencyInputFormatting()
        let range = NSMakeRange(1, 1)
        m_estimatedAmountLbl.attributedText=attributedString(from: m_estimatedAmountLbl.text!, nonBoldRange: range)
        
        m_hospitalNameLBL.text = claimHospitalInfo?.hospitalName//m_statusDetailsDict.value(forKey: "HospitalName") as? String
        
        CashlessDenialDateLbl.text = claimCashlessInfo?.cashlessSentDate
        CashlessAmtLbl.text = claimCashlessInfo?.cashlessAmount
        m_dateOfAdmission.text = claimHospitalInfo?.dateOfAdmission//m_statusDetailsDict.value(forKey: "DateOfAdmission") as? String
        ailmentLBl.text=claimAilmentInfo?.ailment//m_statusDetailsDict.value(forKey: "Ailment") as? String
        m_dateOfDischarge.text=claimHospitalInfo?.dateOfDischarge//m_statusDetailsDict.value(forKey: "DateOfDischarge") as? String
        
       
        let type = claimProcessInfo?.typeOfClaim//m_statusDetailsDict.value(forKey: "TypeOfClaim")as?String
        if(type=="Cashless")
        {
            switch status as! String
            {
            case "Outstanding":
                m_cashlessInformationView.isHidden=true
//                m_cashlessStatusViewHeightConstraint.constant=0
                m_claimStatusLbl3.text=""
                m_thirdViewSymbol.isHidden=true
                m_cashlessInformationView.isHidden=true
                m_progressView.isHidden = true
                
                getCashlessInformation()
                m_cashlessStatusView.isHidden=true
                m_claimPaidView.isHidden=true
                m_reimbursmentClaimStatusView.isHidden=true
                m_cashlessStatusTitleLbl.isHidden=true
                m_cashlessStatusImageView.isHidden=true
                m_firstViewProgressLine.isHidden=false
                
                
                break
                
            case "Paid":
                /*
                m_cashlessInformationView.isHidden=false
                
                m_claimStatusLbl3.text="Cashless Information"
                m_thirdViewSymbol.image=UIImage(named: "checkSymbol_App")
                getCashlessInformation()
                m_claimPaidView.isHidden=true
                m_reimbursmentClaimStatusView.isHidden=true
                m_cashlessStatusView.isHidden=true
                m_cashlessStatusTitleLbl.isHidden=true
                m_cashlessStatusImageView.isHidden=true
                
                break
                */
                
                    m_claimStatusLbl3.text="Claim Payment Information"
                    m_thirdViewSymbol.image=UIImage(named: "checkSymbol_App")
                    m_claimPaidView.isHidden=false
                    
                    m_BillAmountValueLbl.text = claimChargesInfo?.finalBillAmount ?? "0"
                    m_BillDateValueLbl.text = claimFileInfo?.fileReceivedDate
                m_paidAmountValueLbl.text = claimPaymentInfo?.amountPaidToMember
                //claimProcessInfo?.paidAmount//m_statusDetailsDict.value(forKey: "ClaimPaidAmount") as? String
                    
                    m_BillAmountValueLbl.text = "₹ "+m_BillAmountValueLbl.text!.currencyInputFormatting()
                    let range = NSMakeRange(1, 1)
                    m_BillAmountValueLbl.attributedText=attributedString(from: m_BillAmountValueLbl.text!, nonBoldRange: range)
                    
                    m_paidAmountValueLbl.text = "₹ "+m_paidAmountValueLbl.text!.currencyInputFormatting()
                    m_paidAmountValueLbl.attributedText=attributedString(from: m_paidAmountValueLbl.text!, nonBoldRange: range)
                    
                    m_paidDateValueLbl.text=claimProcessInfo?.claimPaidDate//m_statusDetailsDict.value(forKey: "ClaimPaidDate")as? String
                    m_chequeNumberValueLbl.text=claimPaymentInfo?.bankChequeNo//m_statusDetailsDict.value(forKey: "ChequeNoToMember")as? String
                    
                    /*var repottedAmiount:NSString = m_statusDetailsDict.value(forKey: "ClaimReportedAmount") as! NSString
                    repottedAmiount = repottedAmiount.replacingOccurrences(of: ",", with: "") as NSString
                    var paidAmount: NSString = (m_statusDetailsDict.value(forKey: "AmountPaidToMember") as? NSString)!
                    paidAmount = paidAmount.replacingOccurrences(of: ",", with: "") as NSString
                    let deduction = repottedAmiount.integerValue - paidAmount.integerValue*/
                    
                    print("claimChargesInfo::  ",claimChargesInfo)
                    
                    let copayment = claimChargesInfo!.coPaymentDeduction//m_statusDetailsDict.value(forKey: "CoPaymentDeductions") as! NSString
                    let nonPayble = claimChargesInfo!.nonPayableExpenses//m_statusDetailsDict.value(forKey: "NonPayableExpenses") as! NSString
                    
                    
                    m_deductionValuelbl.text="₹ "+(nonPayble as String)//.currencyInputFormatting()
                    
                   
                    m_deductionValuelbl.attributedText=attributedString(from: m_deductionValuelbl.text!, nonBoldRange: range)
                    
                    if(copayment=="0")
                    {
                        m_notPaybleValueLbl.text="₹ "+(copayment as String)
                    }
                    else
                    {
                        m_notPaybleValueLbl.text="₹ "+(copayment as String)//.currencyInputFormatting()
                    }
                    m_notPaybleValueLbl.attributedText=attributedString(from: m_notPaybleValueLbl.text!, nonBoldRange: range)
                   
                    let reason = claimChargesInfo!.deductionReasons//(m_statusDetailsDict.value(forKey: "DeductionReasons")as? String)!
                    
                   if(reason.count>100)
                   {
                    
                    let endIndex = reason.index(reason.startIndex, offsetBy: 100)
                    var truncated = reason.substring(to: endIndex)
                    truncated=truncated+"  Read more..."
                    let range = (truncated as NSString).range(of: "  Read more...")
                    let attributedString = NSMutableAttributedString(string:truncated)
                    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: hexStringToUIColor(hex: hightlightColor) , range: range)
                    m_deductionReasonValueLbl.attributedText=attributedString
                   }
                    else
                   {
                     m_deductionReasonValueLbl.text=reason
                    }
                    
                    
                    
                    
                    m_reimbursmentClaimStatusView.isHidden=true
                    m_cashlessInformationView.isHidden=true
                    m_cashlessStatusView.isHidden=true
                    m_cashlessStatusTitleLbl.isHidden=true
                    m_cashlessStatusImageView.isHidden=true
                    
                    break
                
            case "Rejected":
                m_cashlessInformationView.isHidden=false
                m_cashlessStatusView.isHidden=false
                
                getCashlessInformation()
                m_thirdViewSymbol.image=UIImage(named: "close")
                m_cashlessStatusTitleLbl.text="Cashless Rejection Information"
                m_cashlessStatusLbl1.text="Rejected On"
                m_cashlessStatusLbl2.text="Rejection Reason - Closure Reason"
                m_cashlessStatusValue1.text="-"
                m_cashlessStatusValue2.text="-"
                
                m_reimbursmentClaimStatusView.isHidden=true
                m_claimPaidView.isHidden=true
                break
                
            case "Closed":
                m_cashlessInformationView.isHidden=false
                m_cashlessStatusView.isHidden=false
                getCashlessInformation()
                m_thirdViewSymbol.image=UIImage(named: "close")
                m_cashlessStatusTitleLbl.text="Cashless Closure Information"
                m_cashlessStatusLbl1.text="Closed On"
                m_cashlessStatusLbl2.text="Closure Reason - Denial Reason"
                m_cashlessStatusValue1.text="-"
                m_cashlessStatusValue2.text="-"
                
                m_reimbursmentClaimStatusView.isHidden=true
                m_claimPaidView.isHidden=true
                break
                
            case "Denied":
                m_cashlessInformationView.isHidden=false
                m_cashlessStatusView.isHidden=false
                m_cashlessStatusTitleLbl.isHidden=false

                
                getCashlessInformation()
                m_thirdViewSymbol.image=UIImage(named: "close")
                m_cashlessStatusTitleLbl.text="Cashless Denial Information"
                m_cashlessStatusLbl1.text="Denied On"
                m_cashlessStatusLbl2.text="Denial Reasons"
                m_cashlessStatusValue1.text="-"
                m_cashlessStatusValue2.text="-"

                m_reimbursmentClaimStatusView.isHidden=true
                m_claimPaidView.isHidden=true
                break
            default:
                /*
                m_claimPaidView.isHidden=true
                m_cashlessInformationView.isHidden = true
                m_reimbursmentClaimStatusView.isHidden = true
                m_cashlessStatusView.isHidden = true
                m_thirdViewSymbol.isHidden = true
                m_claimStatusLbl3.isHidden = true
                m_cashlessStatusImageView.isHidden = true
                m_cashlessStatusTitleLbl.isHidden = true
                m_progressView.isHidden = true
                m_firstViewProgressLine.isHidden = false
                */
                break
            }
        }
        else if(type=="Reimbursement")
        {
//            CashlessDenialDateLbl.isHidden = true
//            CashlessDenialDateHeader.isHidden = true
//            CashlessAmtLbl.isHidden = true
//            CashlessAmtHeader.isHidden = true
//            CashlessReported_Border1.isHidden = true
            heightCashlessAmt.constant = 0
            heightCashlessAmtVal.constant = 0
            heightVerticalVew1.constant = 0
            heightCashlessDenialOn.constant = 0
            heightCashlessDenialOnVal.constant = 0
                
                    switch status as? String
                    {
                    case "Outstanding":
                        if claimProcessInfo?.outstandingClaimStatus == "Deficient"//(m_statusDetailsDict.value(forKey: "ClaimOutstandingStatus")as? String=="Deficient")
                        {
                            m_claimStatusLbl3.text="Claim Deficiency Details"
                            m_statusDetailsDict.value(forKey: "ClaimOutstandingStatus")
                            m_thirdViewSymbol.image=UIImage(named: "checkSymbol_App")
                            
                            m_cashlessInformationView.isHidden=true
                            m_cashlessStatusView.isHidden=true
                            m_cashlessStatusTitleLbl.isHidden=true
                            m_cashlessStatusImageView.isHidden=true
                            m_claimPaidView.isHidden=true
                            
                            m_reimbursmentStatuslbl1.text="Final Bill Amount"
                            m_reimbursmentStatuslblSide1.text = "Not Payable Expenses"
                            m_reimbursmentStatusLbl2.text="First Deficiency Letter Date"
                            m_deficiencyTitleLbl.text="Second Deficiency Letter Date"
                            m_reimbursmentStatusLbl4.text="Deficiency Retrieval Date"
                            m_reimbursmentStatusLbl5.text="Deficiencies"
                            
                            //m_paidAmountValueLbl.text = "₹ "+m_paidAmountValueLbl.text!.currencyInputFormatting()
                            
                            m_reimbursmentStatusValue1.text = claimChargesInfo?.finalBillAmount
                            m_reimbursmentStatusValue1.text = "₹ "+m_reimbursmentStatusValue1.text!.currencyInputFormatting()
                            let range = NSMakeRange(1, 1)
                            m_reimbursmentStatusValue1.attributedText=attributedString(from: m_reimbursmentStatusValue1.text!, nonBoldRange: range)
                            
                            
                            m_reimbursmentStatusValueSide1.text = claimChargesInfo?.nonPayableExpenses
                            m_reimbursmentStatusValueSide1.text = "₹ "+m_reimbursmentStatusValueSide1.text!.currencyInputFormatting()
                            m_reimbursmentStatusValueSide1.attributedText=attributedString(from: m_reimbursmentStatusValueSide1.text!, nonBoldRange: range)
                            
                            m_reimbursmentStatusValue2.text = claimFileInfo?.firstDeficiencyLetterDate
                            m_deficienciesValueLbl.text = claimFileInfo?.secondDeficiencyLetterDate
                            m_reimbursmentStatusValue4.text = claimFileInfo?.deficienciesRetrievalDate
                            m_reimbursmentStatusValue5.text=claimFileInfo?.deficiencies
                            
                            m_reimbursmentStatuslblSide1.isHidden = false
                            m_reimbursmentStatusValueSide1.isHidden = false
                            m_reimbursmentStatusLbl4.isHidden = false
                            m_reimbursmentStatusLbl5.isHidden = false
                            m_reimbursmentStatusValue4.isHidden = false
                            m_reimbursmentStatusValue5.isHidden = false
                            
                            
                            
                        }
                        else
                        {
                            m_claimStatusLbl3.text=""
                            m_thirdViewSymbol.isHidden=true
                            m_cashlessInformationView.isHidden=true
                            m_cashlessStatusView.isHidden=true
                            m_cashlessStatusTitleLbl.isHidden=true
                            m_cashlessStatusImageView.isHidden=true
                            m_claimPaidView.isHidden=true
                            m_reimbursmentClaimStatusView.isHidden=true
                            m_firstViewProgressLine.isHidden=false
                            m_progressView.isHidden=true
                        }
                        
                        
                        break
                    case "Paid":
                        m_claimStatusLbl3.text="Claim Payment Information"
                        m_thirdViewSymbol.image=UIImage(named: "checkSymbol_App")
                        m_claimPaidView.isHidden=false
                        
                        m_BillAmountValueLbl.text = claimChargesInfo?.finalBillAmount ?? "0"
                        m_BillDateValueLbl.text = claimFileInfo?.fileReceivedDate
                        m_paidAmountValueLbl.text=claimProcessInfo?.paidAmount//m_statusDetailsDict.value(forKey: "ClaimPaidAmount") as? String
                        
                        m_BillAmountValueLbl.text = "₹ "+m_BillAmountValueLbl.text!.currencyInputFormatting()
                        let range = NSMakeRange(1, 1)
                        m_BillAmountValueLbl.attributedText=attributedString(from: m_BillAmountValueLbl.text!, nonBoldRange: range)
                        
                        m_paidAmountValueLbl.text = "₹ "+m_paidAmountValueLbl.text!.currencyInputFormatting()
                        m_paidAmountValueLbl.attributedText=attributedString(from: m_paidAmountValueLbl.text!, nonBoldRange: range)
                        
                        m_paidDateValueLbl.text=claimProcessInfo?.claimPaidDate//m_statusDetailsDict.value(forKey: "ClaimPaidDate")as? String
                        m_chequeNumberValueLbl.text=claimPaymentInfo?.bankChequeNo//m_statusDetailsDict.value(forKey: "ChequeNoToMember")as? String
                        
                        /*var repottedAmiount:NSString = m_statusDetailsDict.value(forKey: "ClaimReportedAmount") as! NSString
                        repottedAmiount = repottedAmiount.replacingOccurrences(of: ",", with: "") as NSString
                        var paidAmount: NSString = (m_statusDetailsDict.value(forKey: "AmountPaidToMember") as? NSString)!
                        paidAmount = paidAmount.replacingOccurrences(of: ",", with: "") as NSString
                        let deduction = repottedAmiount.integerValue - paidAmount.integerValue*/
                        
                        print("claimChargesInfo::  ",claimChargesInfo)
                        
                        let copayment = claimChargesInfo!.coPaymentDeduction//m_statusDetailsDict.value(forKey: "CoPaymentDeductions") as! NSString
                        let nonPayble = claimChargesInfo!.nonPayableExpenses//m_statusDetailsDict.value(forKey: "NonPayableExpenses") as! NSString
                        
                        
                        m_deductionValuelbl.text="₹ "+(nonPayble as String)//.currencyInputFormatting()
                        
                       
                        m_deductionValuelbl.attributedText=attributedString(from: m_deductionValuelbl.text!, nonBoldRange: range)
                        
                        if(copayment=="0")
                        {
                            m_notPaybleValueLbl.text="₹ "+(copayment as String)
                        }
                        else
                        {
                            m_notPaybleValueLbl.text="₹ "+(copayment as String)//.currencyInputFormatting()
                        }
                        m_notPaybleValueLbl.attributedText=attributedString(from: m_notPaybleValueLbl.text!, nonBoldRange: range)
                       
                        let reason = claimChargesInfo!.deductionReasons//(m_statusDetailsDict.value(forKey: "DeductionReasons")as? String)!
                        
                       if(reason.count>100)
                       {
                        
                        let endIndex = reason.index(reason.startIndex, offsetBy: 100)
                        var truncated = reason.substring(to: endIndex)
                        truncated=truncated+"  Read more..."
                        let range = (truncated as NSString).range(of: "  Read more...")
                        let attributedString = NSMutableAttributedString(string:truncated)
                        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: hexStringToUIColor(hex: hightlightColor) , range: range)
                        m_deductionReasonValueLbl.attributedText=attributedString
                       }
                        else
                       {
                         m_deductionReasonValueLbl.text=reason
                        }
                        
                        
                        
                        
                        m_reimbursmentClaimStatusView.isHidden=true
                        m_cashlessInformationView.isHidden=true
                        m_cashlessStatusView.isHidden=true
                        m_cashlessStatusTitleLbl.isHidden=true
                        m_cashlessStatusImageView.isHidden=true
                        
                        break
                    case "Rejected":
                        m_reimbursmentClaimStatusView.isHidden=false
                        m_claimStatusLbl3.text="Claim Rejection Information"
                        m_thirdViewSymbol.image=UIImage(named: "close")
                        m_reimbursmentStatuslbl1.text="Rejected On"
                        m_reimbursmentStatusLbl2.text="Deficiencies"
                        m_deficiencyTitleLbl.text="Rejection Reasons"
                        m_deficienciesValueLbl.text=claimProcessInfo?.denialReasons//m_statusDetailsDict.value(forKey: "ClaimDenialReasons") as? String
                        m_reimbursmentStatusValue1.text=claimProcessInfo?.claimRejectedDate
                        m_reimbursmentStatusValue2.text=claimFileInfo?.deficiencies
                        
                        m_deficienciesValueLbl.isHidden=false
                        m_deficiencyTitleLbl.isHidden=false
                        m_reimbursmentStatuslblSide1.isHidden = true
                        m_reimbursmentStatusLbl4.isHidden = true
                        m_reimbursmentStatusLbl5.isHidden = true
                        m_reimbursmentStatusValueSide1.isHidden = true
                        m_reimbursmentStatusValue4.isHidden = true
                        m_reimbursmentStatusValue5.isHidden = true
                        m_reimbursmentStatusLbl4.text = ""
                        m_reimbursmentStatusLbl5.text = ""
                        m_reimbursmentStatusValue4.text = ""
                        m_reimbursmentStatusValue5.text = ""
                        
                        m_claimPaidView.isHidden=true
                        m_cashlessInformationView.isHidden=true
                        m_cashlessStatusView.isHidden=true
                        m_cashlessStatusTitleLbl.isHidden=true
                        m_cashlessStatusImageView.isHidden=true
                        
                        break
                    case "Closed":
                        m_reimbursmentClaimStatusView.isHidden=false
                        m_claimStatusLbl3.text="Claim Closure Information"
                        m_thirdViewSymbol.image=UIImage(named: "close")
                        m_reimbursmentStatuslbl1.text="Closed On"
                        m_reimbursmentStatusLbl2.text="Closure Reasons"
                        m_reimbursmentStatusValue1.text=claimProcessInfo?.claimClosedDate//m_statusDetailsDict.value(forKey: "ClaimClosedDate")as? String
                        m_reimbursmentStatusValue2.text=claimProcessInfo?.closeReasons//m_statusDetailsDict.value(forKey: "ClaimClosureReasons") as? String
                        
                        m_deficienciesValueLbl.isHidden=true
                        m_deficiencyTitleLbl.isHidden=true
                        m_deficienciesValueLbl.text=""
                        m_deficiencyTitleLbl.text=""
                        
                        m_claimPaidView.isHidden=true
                        m_cashlessInformationView.isHidden=true
                        m_cashlessStatusView.isHidden=true
                        m_cashlessStatusTitleLbl.isHidden=true
                        m_cashlessStatusImageView.isHidden=true
                        
                        break
                    case "Outstanding-Deficient":
                        m_reimbursmentClaimStatusView.isHidden=false
                        m_thirdViewSymbol.image=UIImage(named: "outstanding")
//                        m_thirdViewSymbol.backgroundColor=hexStringToUIColor(hex: "9345a9")
                        m_claimStatusLbl3.text="Claim Deficiency Details"
                        m_reimbursmentStatuslbl1.text="Deficiency Details"
                        m_reimbursmentStatusLbl2.text="Deficiency Raised On"
                        m_reimbursmentStatusValue1.text=claimFileInfo?.deficiencies//m_statusDetailsDict.value(forKey: "Deficiencies")as? String
                        m_reimbursmentStatusValue2.text=claimFileInfo?.deficiencyIntimationDate//m_statusDetailsDict.value(forKey: "DeficiencyIntimationDate")as? String
                        
                        
                        m_deficienciesValueLbl.isHidden=true
                        m_deficiencyTitleLbl.isHidden=true
                        m_deficienciesValueLbl.text=""
                        m_deficiencyTitleLbl.text=""
                        m_cashlessInformationView.isHidden=true
                        m_cashlessStatusView.isHidden=true
                        m_cashlessStatusTitleLbl.isHidden=true
                        m_cashlessStatusImageView.isHidden=true
                        
                        break
                    default:
                        /*
                        m_claimPaidView.isHidden=true
                        m_cashlessInformationView.isHidden = true
                        m_reimbursmentClaimStatusView.isHidden = true
                        m_cashlessStatusView.isHidden = true
                        m_thirdViewSymbol.isHidden = true
                        m_claimStatusLbl3.isHidden = true
                        m_cashlessStatusImageView.isHidden = true
                        m_cashlessStatusTitleLbl.isHidden = true
                        m_progressView.isHidden = true
                        m_firstViewProgressLine.isHidden = false
                         */
                        break
                    }
                    
            }
        else
        {
            backButtonClicked()
        }
        delayedAction()
    }
    
    func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString
    {
        let fontSize = 15.0
        let attrs = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        let nonBoldAttribute = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: CGFloat(fontSize)),
            ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange
        {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
    @objc func viewMoreButtonTapped(_ sender:UITapGestureRecognizer)
    {
        
        let reason = claimChargesInfo!.deductionReasons//(m_statusDetailsDict.value(forKey: "DeductionReasons")as? String)!
        print("reason.count:::",reason.count)
        if(reason.count>100){
            if((m_deductionReasonValueLbl.text?.contains("  Read less..."))!)
            {
                if(reason.count>100)
                {
                    
                    let endIndex = reason.index(reason.startIndex, offsetBy: 100)
                    var truncated = reason.substring(to: endIndex)
                    truncated=truncated+"  Read more..."
                    let range = (truncated as NSString).range(of: "  Read more...")
                    let attributedString = NSMutableAttributedString(string:truncated)
                    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: hexStringToUIColor(hex: hightlightColor) , range: range)
                    m_deductionReasonValueLbl.attributedText=attributedString
                }
                else
                {
                    m_deductionReasonValueLbl.text=reason
                }
                
            }
            else
            {
                let fullText = reason+"  Read less..."
                let range = (fullText as NSString).range(of: "  Read less...")
                let attributedString = NSMutableAttributedString(string:fullText)
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: hexStringToUIColor(hex: hightlightColor) , range: range)
                m_deductionReasonValueLbl.attributedText=attributedString
            }
            
        }
        else{
            print("reason count is less that 100")
        }
        
        
        
    }
    func getCashlessInformation()
    {
        m_cashlessStatusValueLbl.text=claimProcessInfo?.outstandingClaimStatus//m_statusDetailsDict.value(forKey: "ClaimOutstandingStatus") as? String
        m_cashlessRequestedValueLBl.text=claimCashlessInfo?.cashlessRequestedOn//m_statusDetailsDict.value(forKey: "CashlessRequestedOn") as? String
        m_cashlessAuthorisedOnValueLbl.text=claimProcessInfo?.claimPaidDate//m_statusDetailsDict.value(forKey: "ClaimPaidDate") as? String
        m_cashlessAmountLbl.text=claimCashlessInfo?.cashlessAmount//m_statusDetailsDict.value(forKey: "CashlessAmount") as? String
        
        m_cashlessAmountLbl.text="₹ "+m_cashlessAmountLbl.text!.currencyInputFormatting()
        let range = NSMakeRange(1, 1)
        m_cashlessAmountLbl.attributedText=attributedString(from: m_cashlessAmountLbl.text!, nonBoldRange: range)
    }
    func delayedAction()
    {
//        m_progressView.setProgress(m_progressView.progress+0.01, animated: false)
//        if(m_progressView.progress==0.5099998)
//        {
            //m_secondViewSymbol.backgroundColor=hexStringToUIColor(hex: gradiantWhiteColor)
            m_secondTitleLbl.textColor = UIColor.darkGray
        //CashlessReportedonDate.textColor = UIColor.darkGray
//            shimmer.isShimmering = false
            m_subview1.backgroundColor=UIColor.white
            m_view1.backgroundColor=UIColor.white
//            nametitle.isHidden=false
//            relationtitle.isHidden=false
//            genderTitle.isHidden=false
//            ageTitle.isHidden=false
//            tpaIDtitle.isHidden=false
//            m_nameLbl.isHidden=false
//            m_relationLbl.isHidden=false
//            m_genderLbl.isHidden=false
//            m_ageLbl.isHidden=false
//            m_tpaIDLbl.isHidden=false
            
//           getClaimDetails()
            
            
//        }
//        if(m_progressView.progress==1.0)
//        {
        
//            shimmer.isShimmering = false
           
        let status = claimProcessInfo?.claimStatus//m_statusDetailsDict.value(forKey: "ClaimStatus")as? String
            
        print("Status :: ",status)
                switch status
        {
                case "Outstanding":
                    m_thirdViewSymbol.backgroundColor=hexStringToUIColor(hex: "C7EDFF")
                    break
                case "Closed":
                    m_thirdViewSymbol.backgroundColor=UIColor.red
                    break
                case "Rejected":
                    m_thirdViewSymbol.backgroundColor=UIColor.red
                    break
                case "Paid":
                    m_thirdViewSymbol.backgroundColor=hexStringToUIColor(hex: "C7EDFF")
                    break
                default:
                    /*
                     m_thirdViewSymbol.isHidden = true
                     m_claimStatusLbl3.isHidden = true
                     m_cashlessStatusImageView.isHidden = true
                     m_cashlessStatusTitleLbl.isHidden = true
                     m_progressView.isHidden = true
                     m_firstViewProgressLine.isHidden = false
                     */
                    break
                }
            
             
            m_claimStatusLbl3.textColor=UIColor.darkGray
        
//            timer.invalidate()
//        }
        
      /*  print("Stepper start")
        StepIndicatorView.setAnimationBeginsFromCurrentState(true)
        
        m_StepindicatorView.currentStep=m_StepindicatorView.currentStep+1
       
        
        if(m_StepindicatorView.currentStep>m_StepindicatorView.numberOfSteps)
        {
            timer.invalidate()
        }*/
    }
   
    override func viewWillAppear(_ animated: Bool)
    {
        
        navigationController?.navigationBar.isHidden=false
        self.tabBarController?.tabBar.isHidden=true
        
        navigationItem.leftBarButtonItem=getBackButton()
        //navigationItem.rightBarButtonItem=getRightBarButton()
        navigationItem.title="Claim Status"
        
        menuButton.isHidden=true
        DispatchQueue.main.async()
            {
                menuButton.isHidden=true
                menuButton.accessibilityElementsHidden=true
        }
        
        delayedAction()
        //getClaimDetails()
        getClaimDetailsJson()
        
//        setData()
        
        
        
        
    }
    
    override func backButtonClicked()
    {
        self.tabBarController?.tabBar.isHidden=false
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            //            xmlKey="claims"
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
            if(xmlKeysArray.contains(xmlKey))
            {
                indexNumber=indexNumber+1
                if(xmlKeysArray.count>indexNumber)
                {
                    xmlKey=xmlKeysArray[indexNumber]
                }
            }
        }
        else if dictionaryKeys.contains(elementName)
        {
            self.currentDictionary![elementName] = currentValue
            self.currentValue = ""
            
        }
        
        
    }
    

}
