//
//  SummaryRightVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 14/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//



import UIKit
import Lottie


var dependantModelArray = [DependantDBRecords]()
var parentsModelArray1 = [ParentalRecords]()
var parentsModelArray2 = [ParentalRecords]()

var selectedGHI = summaryData()
var selectedGPA = summaryData()
var selectedGTL = summaryData()



struct summaryData {
    var isHeader = false
    var firstText = ""
    var secondText = ""
    var isMultiline = false
    var tempExtra = ""
    var isEmptyData = true
}

class SummaryRightVC: UIViewController{
    
    var summaryDataArray = [summaryData]()
    
    @IBOutlet weak var tableView: UITableView!
    let gradientLayer = CAGradientLayer()
    
    var isSwipe = true
    //Parent 1
    @IBOutlet weak var btnBack: UIButton!
    
    var summaryModelObj = SummaryDataModel()
    var m_employeedict : EMPLOYEE_INFORMATION?
    var persondict : PERSON_INFORMATION?
    
    var moveToPrevious : MoveToPreviousVCProtocol? = nil
    
    var isFromPush = false
    var m_groupAdminBasicSettingsDict = NSDictionary()
    var m_enrollmentMiscInformationDict = NSDictionary()
    var m_windowPeriodEndDate = Date()
    var newJoineeEnrollmentDict = [String: String]()
    var openEnrollmentDict = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        

      if let openEnrollDict =  UserDefaults.standard.value(forKey: "OpenEnroll_WP_Information_data") as? [String : String] {
            openEnrollmentDict = openEnrollDict
        }
        
        if let newJoineeDict = UserDefaults.standard.value(forKey: "WP_ForNewJoinee_data") as? [String : String] {
         newJoineeEnrollmentDict = newJoineeDict
        }
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if userArray.count > 0 {
            m_employeedict = userArray[0]
        }
        
        
        self.tableView.layer.cornerRadius = 12.0
        
        
        let startPoint = CGPoint(x:0.5, y:0.0)
        let endPoint = CGPoint(x:0.5, y:1.0)
        setColorNew(view: self.view, colorTop: EnrollmentColor.ghiTop.value, colorBottom: EnrollmentColor.ghiBottom.value,gradientLayer:gradientLayer)
        self.tableView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        self.tableView.layer.cornerRadius = 10.0
        self.tableView.tableFooterView = UIView()
        
        if isSwipe {
           // self.btnBack.isHidden = true
        }
        else {
            
          //  self.btnBack.isHidden = false
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getSummaryFromServer()
        self.setEnrollmentData()

    }
    
    let tickView = LottieAnimationView(name: "18074-tick-bounce")
    let animationView = LottieAnimationView(name: "10951-confetti-2")

    private func showAnimation() {
        
       
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 20)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 0.5
        
        tickView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        tickView.center = self.view.center
        tickView.contentMode = .scaleAspectFill
        tickView.animationSpeed = 0.5
        view.addSubview(tickView)
        
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        
        tickView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            self.view.addSubview(self.animationView)
            self.animationView.play()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) { // Change `2.0` to the desired number of seconds.
                   self.animationView.stop()
            self.animationView.removeFromSuperview()


        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6) { // Change `2.0` to the desired number of seconds.
            self.tickView.stop()

            self.tickView.removeFromSuperview()
            self.displayActivityAlert(title: "Redirecting you to the Dashboard")

        }
        
        /* start tick animation
         delay 2 sec
         start star animation
         delay 1 sec
         stop star animation
         delay 0.6 sec
         stop tick
         */
        
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
        center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])
        
        Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(self.callback), userInfo: nil, repeats: false)
        
        
    }
    
    //MARK:- Generate Array
    func generateArray() {
        //Add Parents
        //Group Sum Insured
        //Health Insurance - Header
        
        self.summaryDataArray.removeAll()
        
        let first = summaryData.init(isHeader: true, firstText: "Group Sum Insured", secondText: "", isMultiline: false, tempExtra: "", isEmptyData: false)
        self.summaryDataArray.append(first)
        
        //Health Insurance - SI
        if let gmcSI = summaryModelObj.gmc_base_si {
            if gmcSI != "" {
                let second = summaryData.init(isHeader: false, firstText: "Health Insurance", secondText: summaryModelObj.gmc_base_si ?? "", isMultiline: false, tempExtra: "", isEmptyData: false)
                self.summaryDataArray.append(second)
            }
        }
        //*************************************************************
        let finalStr = UserDefaults.standard.value(forKey: "CoveredDependantName") as? String
        let strArray = finalStr?.components(separatedBy: ",")
        print("finalStr: ",finalStr," : strArray: ",strArray)
        
        if finalStr != "" && finalStr != nil{
            for i in 0..<strArray!.count {
                
                    let extraChildPremium =  summaryData.init(isHeader: false, firstText: "\(strArray![i])", secondText: "-", isMultiline: false, tempExtra: "", isEmptyData: false)
                    self.summaryDataArray.append(extraChildPremium)

            }
        }
        
        
        //*********************************
        //HEADER - Health Insurance Parent Topup
        
        
        //PARENTAL- DATA SET 1,2 SI
        if let parent1Base = summaryModelObj.gmc_base_si_parent_set1 {
            if parent1Base != "" && parent1Base != "0" {
                let parent1SI = summaryData.init(isHeader: false, firstText: "Parents (1st Set)", secondText: parent1Base, isMultiline: false, tempExtra: "", isEmptyData: false)
                self.summaryDataArray.append(parent1SI)
            }
        }
        
        if let parent2Base = summaryModelObj.gmc_base_si_parent_set2 {
            if parent2Base != "" && parent2Base != "0" {
                let parent2SI = summaryData.init(isHeader: false, firstText: "Parents (2nd Set)", secondText: parent2Base, isMultiline: false, tempExtra: "", isEmptyData: false)
                self.summaryDataArray.append(parent2SI)
            }
        }
        
        //Health Insurance - Top-Up
        /* if selectedGHI.isEmptyData == false {
         self.summaryDataArray.append(selectedGHI)
         }
         */
        if let hcTopUp = summaryModelObj.gmc_topup_si {
            if hcTopUp != "" && hcTopUp != "0" && hcTopUp != "-1" {
                let gmcTopup =  summaryData.init(isHeader: false, firstText: "Health Insurance Top-up", secondText: hcTopUp, isMultiline: false, tempExtra: "", isEmptyData: false)
                self.summaryDataArray.append(gmcTopup)
            }
        }
        
        //HEALTH SEPARATOR
        let separator1 = summaryData.init(isHeader: true, firstText: "", secondText: "", isMultiline: true, tempExtra: "", isEmptyData: false)
        self.summaryDataArray.append(separator1)
        
        
        //Personal Accident - SI
        if let gpBase = summaryModelObj.gpa_base_si {
            if gpBase != "" && gpBase != "0" {
                let fourth = summaryData.init(isHeader: false, firstText: "Personal Accident", secondText: gpBase, isMultiline: false, tempExtra: "", isEmptyData: false)
                self.summaryDataArray.append(fourth)
            }
        }
        //append topup
        //        if selectedGPA.isEmptyData == false {
        //        self.summaryDataArray.append(selectedGPA)
        //        }
        
        if let gpaTop = summaryModelObj.gpa_topup_si {
            if gpaTop != "" && gpaTop != "0" && gpaTop != "-1"{
                let gpaTopup =  summaryData.init(isHeader: false, firstText: "Personal Accident Top-up", secondText: summaryModelObj.gpa_topup_si!, isMultiline: false, tempExtra: "", isEmptyData: false)
                self.summaryDataArray.append(gpaTopup)
            }
        }
        
        
        self.summaryDataArray.append(separator1)
        
        //Term Life
        if let gtBase = summaryModelObj.gtl_base_si {
            if gtBase != "" && gtBase != "0" {
                
                let fifth = summaryData.init(isHeader: false, firstText: "Term Life", secondText: summaryModelObj.gtl_base_si!, isMultiline: false, tempExtra: "", isEmptyData: false)
                self.summaryDataArray.append(fifth)
            }
        }
        //append topup
        //        if selectedGTL.isEmptyData == false {
        //        self.summaryDataArray.append(selectedGTL)
        //        }
        
        if let gtltop = summaryModelObj.gtl_topup_si {
            if gtltop != "" && gtltop != "0" && gtltop != "-1"{
                
                let gtlTopup =  summaryData.init(isHeader: false, firstText: "Term Life Top-up", secondText: summaryModelObj.gtl_topup_si!, isMultiline: false, tempExtra: "", isEmptyData: false)
                self.summaryDataArray.append(gtlTopup)
            }
        }
        
        //*************************************************************
         //HEADER - Extra Child Premium
        
        
        let new = summaryData.init(isHeader: true, firstText: "Additional Children Premium", secondText: "", isMultiline: false, tempExtra: "", isEmptyData: false)
              //self.summaryDataArray.append(new)

              if let count = UserDefaults.standard.value(forKey: "ExtraChildCount") {

                    if let extraAmt = UserDefaults.standard.value(forKey: "ExtraChildPremiumInt") as? Int , let cnt = UserDefaults.standard.value(forKey: "ExtraChildCountInt") as? Int {
                        
                        
                        let finalStr = UserDefaults.standard.value(forKey: "ExtraChildName") as? String
                        let strArray = finalStr?.components(separatedBy: ",")
                        
                        if strArray!.count>0 && finalStr != ""{
                            self.summaryDataArray.append(new)
                        }
                        
                        var singleAmt = 0
                        if cnt != 0{
                            singleAmt = extraAmt / Int(cnt)
                        }else{
                            singleAmt = extraAmt
                        }
                        
                        for i in 0..<strArray!.count {
                            
                        if let extraAmt = summaryModelObj.extra_premium {
                            if extraAmt != "" && extraAmt != "0" && finalStr != "" {
                                let extraChildPremium =  summaryData.init(isHeader: false, firstText: "\(strArray![i])", secondText: String(singleAmt), isMultiline: false, tempExtra: "", isEmptyData: false)
                                self.summaryDataArray.append(extraChildPremium)

                            }
                          }
                        }
                    }
               
                  
                  
              }else{
                  if let extraAmt = summaryModelObj.extra_premium {
                      if extraAmt != "" && extraAmt != "0" {
                          let extraChildPremium =  summaryData.init(isHeader: false, firstText: "Child 0", secondText: summaryModelObj.extra_premium!, isMultiline: false, tempExtra: "", isEmptyData: false)
                           self.summaryDataArray.append(new)
                          self.summaryDataArray.append(extraChildPremium)
                      }
                  }
              }
        
               
        //*************************************************************
        
        //*************************************************************
        //HEADER - Health Insurance Parent Premium
        let six = summaryData.init(isHeader: true, firstText: "Health Insurance Parent Premium", secondText: "", isMultiline: false, tempExtra: "", isEmptyData: false)
       
        
        if let parent1Premium = summaryModelObj.parent_1_premium {
            if parent1Premium != "" && parent1Premium != "0" {
                
                let parentalFirstPremium =  summaryData.init(isHeader: false, firstText: "Parents (1st Set)", secondText: summaryModelObj.parent_1_premium!, isMultiline: false, tempExtra: "", isEmptyData: false)
                self.summaryDataArray.append(six)
                self.summaryDataArray.append(parentalFirstPremium)
                
            }
        }
        if let parent2Premium = summaryModelObj.parent_2_premium {
            if parent2Premium != "" && parent2Premium != "0" {
                let parentalSecPremium =  summaryData.init(isHeader: false, firstText: "Parents (2nd Set)", secondText: summaryModelObj.parent_2_premium!, isMultiline: false, tempExtra: "", isEmptyData: false)
                
                if let parent1Premium = summaryModelObj.parent_1_premium {
                    if parent1Premium != "" && parent1Premium != "0" {
                    }
                    else {
                        self.summaryDataArray.append(six)
                    }
                }
                self.summaryDataArray.append(parentalSecPremium)
            }
        }
        
        
        //*************************************************************
        //Group Top-Up Premium - HEADER
        let groupHeader = summaryData.init(isHeader: true, firstText: "Group Top-Up Premium", secondText: "", isMultiline: false, tempExtra: "", isEmptyData: false)
        
        // if selectedGHI.isEmptyData == false || selectedGPA.isEmptyData == false || selectedGTL.isEmptyData == false
        //   {
        
        var isHeaderAdded = false
        if let gmcPremium = summaryModelObj.gmc_topup_premium {
            if gmcPremium != "" && gmcPremium != "0"  && gmcPremium != "-1"{
                
                let ghiPremium = summaryData.init(isHeader: false, firstText: "Health Insurance", secondText: summaryModelObj.gmc_topup_premium!, isMultiline: false, tempExtra: "", isEmptyData: false)
                self.summaryDataArray.append(groupHeader)
                isHeaderAdded = true
                self.summaryDataArray.append(ghiPremium)
            }
        }
        
        if let gpaPremium = summaryModelObj.gpa_topup_premium {
            if gpaPremium != "" && gpaPremium != "0"  && gpaPremium != "-1"{
                let gpaPremium = summaryData.init(isHeader: false, firstText: "Personal Accident", secondText: summaryModelObj.gpa_topup_premium!, isMultiline: false, tempExtra: "", isEmptyData: false)
                if !isHeaderAdded {
                    self.summaryDataArray.append(groupHeader)
                }
                
                self.summaryDataArray.append(gpaPremium)
            }
        }
        
        if let gtlPremium = summaryModelObj.gtl_topup_premium {
            if gtlPremium != "" && gtlPremium != "0"  && gtlPremium != "-1"{
                let gtlPremium = summaryData.init(isHeader: false, firstText: "Term Life", secondText: summaryModelObj.gtl_topup_premium!, isMultiline: false, tempExtra: "", isEmptyData: false)
                if !isHeaderAdded {
                    self.summaryDataArray.append(groupHeader)
                }
                self.summaryDataArray.append(gtlPremium)
            }
        }
        
        //*************************************************************
        //HELATH CHECKUP
        let hcHeaderHeader = summaryData.init(isHeader: true, firstText: "Wellness Benefits", secondText: "", isMultiline: false, tempExtra: "", isEmptyData: false)
        
        
        if let healthCheckup = summaryModelObj.wellness_benefit_amount_7 {
            if healthCheckup != "" && healthCheckup != "0"  && healthCheckup != "-1"{
                let hcobj = summaryData.init(isHeader: false, firstText: "Health Check-up", secondText: summaryModelObj.wellness_benefit_amount_7!, isMultiline: false, tempExtra: "", isEmptyData: false)
                //WELLNESS BENEFITS
                
                self.summaryDataArray.append(hcHeaderHeader)
                self.summaryDataArray.append(hcobj)
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    
    
    //MARK:- Currency Converter
    private func getFormattedCurrency(amount:String) -> String {
        
        if amount == "" {
            return ""
        }
        else if amount.contains(",") {
            return amount
        }
        let myDouble = Double(amount)!
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = ""
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        var priceString = currencyFormatter.string(from: NSNumber(value: myDouble))!
        print(priceString)
        priceString = priceString.replacingOccurrences(of: ".00", with: "")
        priceString = priceString.replacingOccurrences(of: " ", with: "")
        
        let formatedString =  String(format: "%@",priceString)
        
        //  let str = "₹ 3700"
        
        return formatedString.removeWhitespace()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonClicked1()
    {
        print ("backButtonClicked")

        if isFromPush == true {
            self.navigationController?.popViewController(animated: true)
        }
        else {
        if moveToPrevious != nil {
            moveToPrevious?.moveToPreviousVC()
        }
        }
    }
    
   
}


extension SummaryRightVC  {
    
    
    
    @objc private func confirmClicked(_ sender : UIButton) {
        let date = m_windowPeriodEndDate.getDateStrdd_mmm_yy()
        let alert = UIAlertController(title: title, message:"""
            Your Enrollment window closes on \(date). You can modify enrollment information before the window closes. After closure of the enrollment window, data submitted by you will be no editable and considered as final.
            Do you wish to confirm enrollment?
            """, preferredStyle: .alert)
        
        //Edited By Pranit
        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Close")
            
            
        }
        
        let acceptAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            print("OK")
            
            self.confirmEnrollmentTapped()
        }
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)    }
    
    @objc private func backBtnTapped(_ sender : UIButton) {
        if isFromPush == true {
            self.navigationController?.popViewController(animated: true)
        }
        else {
        if moveToPrevious != nil {
            moveToPrevious?.moveToPreviousVC()
        }
        }

    }
    
    func confirmEnrollmentTapped()
    {
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if(userArray.count>0)
        {
            m_employeedict=userArray[0]
            
            var oe_group_base_Info_Sr_No = String()
            var groupChildSrNo = String()
            var empSrNo = String()
            var empIDNo = String()
            var personSr = ""
            var personName = ""
            var mailadd = ""
            if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
            {
                oe_group_base_Info_Sr_No = String(empNo)
            }
            if let groupChlNo = m_employeedict?.groupChildSrNo
            {
                groupChildSrNo=String(groupChlNo)
            }
            if let empsrno = m_employeedict?.empSrNo
            {
                empSrNo=String(empsrno)
            }
            if let empidno = m_employeedict?.empIDNo
            {
                empIDNo=String(empidno)
            }
            if let mailID = m_employeedict?.officialEmailID
            {
                mailadd=String(mailID)
            }
            
            
            let personArray : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: "GMC", relationName: "EMPLOYEE")
            if(personArray.count>0)
            {
                
                persondict = personArray[0]
                
                if let personSrnumber = persondict?.personSrNo
                {
                    personSr=String(personSrnumber)
                }
                if let personName1 = persondict?.personName {
                    personName = personName1
                }
               
            }
            
            
            let dict = ["EmpSrNo":empSrNo,"PersonSrNo":personSr,"EmpID":empIDNo,"Name":personName,"OffEmailId":mailadd,"GroupChildSrNo":groupChildSrNo,"OeGrpBasInfSrNo":oe_group_base_Info_Sr_No]
            
            print(dict)
            confirmEnrollment(parameter: dict as NSDictionary)
           // self.showAnimation()
        }
    }
    

    
    
    /*{
     "EmpSrNo": 36473,
     "PersonSrNo": 4357734,
     "EmpID": 12354,
     "Name": "ABHIJIT AWATE",
     "OffEmailId": "TESTING@SEMANTICTECH.IN",
     "GroupChildSrNo": 1275,
     "OeGrpBasInfSrNo" : 757
     }*/
    private func confirmEnrollment(parameter:NSDictionary) {
        let url = APIEngine.shared.printSummaryAPI()
        
        
        print("ConfirmEnrollment :parameter: \(parameter) \nURL: \(url)")
        
        EnrollmentServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: parameter as NSDictionary, view: self) { (data, error) in
            
            if error != nil
            {
                print("error ",error!)
                //self.hidePleaseWait()
                self.displayActivityAlert(title: m_errorMsg)
            }
            else
            {
                // self.hidePleaseWait()
                
                do {
                    print("Started parsing ...")
                    
                    if let statusDict = data?["message"].dictionary
                    {
                        if let status = statusDict["Status"]?.bool {
                            if status == true {
                                
                                self.showAnimation()

                            }
                            else {
                                //let msg = statusDict["Message"]?.string
                                self.displayActivityAlert(title: m_errorMsg)
                            }
                        }
                    }
                    
                }//do
                    
                catch let JSONError as NSError
                {
                    print(JSONError)
                }
            }//else
        }//server call
        
    }
    
    @objc func callback() {
        animationView.stop()
        tickView.stop()
        self.setupInsurance()

    }
    
    
    //MARK:- Move To Insurance
    private func setupInsurance()
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
        let tabViewController5 = LeftSideViewController(
            nibName:"LeftSideViewController",
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
            title: "More",
            image:UIImage(named: "menu-1") ,
            tag:2)
        
        isRemoveFlag = 0
        tabBarController.modalPresentationStyle = .fullScreen
        
        navigationController?.present(tabBarController, animated: true, completion: nil)
        tabBarController.selectedIndex=2
        
        
    }
    
}


extension SummaryRightVC : UITableViewDelegate,UITableViewDataSource{
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if summaryDataArray.count > 0 {
            return summaryDataArray.count + 1
        }
        return 0
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        if numberOfRows - 1 != indexPath.row
        {
            
            if summaryDataArray[indexPath.row].isHeader == true {
                if summaryDataArray[indexPath.row].isMultiline == true {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorCell", for: indexPath) as! SeparatorCell
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CellForHeaderSummary", for: indexPath) as! CellForHeaderSummary
                    cell.lblFirst.text = summaryDataArray[indexPath.row].firstText
                    cell.lblFirst.textColor = #colorLiteral(red: 0.6745098039, green: 0.8980392157, blue: 0.1019607843, alpha: 1)
                    
                    if indexPath.row == 0 {
                        cell.lblSeparator.isHidden = true
                    }
                    else {
                        cell.lblSeparator.isHidden = false
                    }
                    
                    return cell
                    
                }
            }
                
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSummaryTableViewCell", for: indexPath) as! CellForSummaryTableViewCell
                
                cell.lblFirst.text = summaryDataArray[indexPath.row].firstText
                if summaryDataArray[indexPath.row].isEmptyData == false {
                    cell.lblFirst.textColor = UIColor.white
                    if summaryDataArray[indexPath.row].secondText == "-" {
                        cell.lblSecond.text = "-"
                    }else {
                        cell.lblSecond.text = self.getFormattedCurrency(amount: summaryDataArray[indexPath.row].secondText)
                    }
                    
                }
                else {
                    cell.lblSecond.text = ""
                }
                return cell
            }
        }
        else //You PayCell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForYouPayCell", for: indexPath) as! CellForYouPayCell
            
            cell.btnConfirm.tag=indexPath.row
            cell.btnConfirm.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
            
            cell.btnBack.tag=indexPath.row
            cell.btnBack.addTarget(self, action: #selector(backBtnTapped(_:)), for: .touchUpInside)
            
            
            if  let extraAmt = UserDefaults.standard.value(forKey: "ExtraChildPremiumInt") as? Int , let cnt = UserDefaults.standard.value(forKey: "ExtraChildCountInt") as? Int{
                
//                var str = self.summaryModelObj.payroll_amount_used
//                str = str?.replacingOccurrences(",", with: "")
//                let a = Int(str!)
//                let payroll = extraAmt + a!
                
                let finalStr = UserDefaults.standard.value(forKey: "ExtraChildName") as? String
                let strArray = finalStr?.components(separatedBy: ",")
                
                var singleAmt = 0
                if cnt != 0{
                    singleAmt = extraAmt / Int(cnt)
                }else{
                    singleAmt = extraAmt
                }
                var subPayAmt = 0
                if strArray!.count>0 && finalStr != "" {
                     subPayAmt = singleAmt * strArray!.count
                }
                
                var str = self.summaryModelObj.payroll_amount_used
                str = str?.replacingOccurrences(of: ",", with: "")
                let a = Int(str!)
                let payroll = subPayAmt + a!
                
                cell.lblAmount.text = self.getFormattedCurrency(amount: String(payroll)) //String(payroll)

                
//                var newStr = self.summaryModelObj.total_premium
//                newStr = newStr?.replacingOccurrences(",", with: "")
//                let b = Int(newStr!)
//                let total = extraAmt + b!
               
                var newStr = self.summaryModelObj.total_premium
                
                //Shubham commected as amout will be with comma and is string
               /* newStr = newStr?.replacingOccurrences(of: ",", with: "")
                let b = Int(newStr!)
                let total = subPayAmt + b!
                
                cell.lblTotalPremium.text = "Total Premium of ₹\(self.getFormattedCurrency(amount: String(total)) )/- will be deducted from your salary in \(self.summaryModelObj.no_of_installments ?? "") equal installments."
                */
                
                cell.lblTotalPremium.text = "Total Premium of ₹\(newStr!)/- will be deducted from your salary in \(self.summaryModelObj.no_of_installments ?? "") equal installments."
                  
                
            }else{
                cell.lblAmount.text = self.summaryModelObj.payroll_amount_used
                cell.lblTotalPremium.text = "Total Premium of ₹\(self.summaryModelObj.total_premium ?? "")/- will be deducted from your salary in \(self.summaryModelObj.no_of_installments ?? "") equal installments."
                           
            }
            
            
           
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        //let titleLabel = UILabel(frame: CGRect(x:10,y: 5 ,width:350,height:150))
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        if numberOfRows - 1 != indexPath.row
        {
            if summaryDataArray[indexPath.row].isEmptyData == true {
                return 0
            }
            return UITableViewAutomaticDimension
            
        }
        return UITableViewAutomaticDimension
    }
}
