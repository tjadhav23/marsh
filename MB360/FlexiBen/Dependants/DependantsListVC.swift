//
//  DependantsListVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 04/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import AEXML
import MobileCoreServices
import FirebaseCrashlytics
/*
struct DifferentlyDBRecords {
    
    var PersonDiffAbledSrNo  : String?
    var personSrNo  : String?
    var IsDiffAbled : Int?
    var CertificateFile : String?
    
}
struct DependantDBRecords {
    //Comment..
    
    var IsSelected : Bool?
    var IsApplicable: Bool?
    var CanDelete: Bool?
    var ReasonForNotAbleToDelete :String?
    var CanUpdate: Bool?
    var IsTwins :String?
    var ReasonForNotAbleToUpdate : String?
    var IsDisabled: Bool?
    var PairNo : String?
    
    var age : Int?
    var cellPhoneNUmber : String?
    var dateofBirth  : String?
    var emailIDStr  : String?
    var empSrNo  : Int?
    var gender  : String?
    var isValid : Int?
    var personName  : String?
    var personSrNo  : Int?
    var productCode  : String?
    var relationID   : Int?
    var relationname  : String?
    var isEmpty : Bool?
    var sortId : Int = 10
    
    var twinPair : Int = 111
    var isHeader = false
    var primiumAmountDep : String?
    var selectedFilename = ""
    var isDiffAbled = false
    var isPremiumShow = false
    //for parental
    var premiumAmount : Int = 0
    var parentPercentage : Int = 0
    
}
*/

struct DifferentlyDBRecords {
    
    var PersonDiffAbledSrNo  : String?
    var personSrNo  : String?
    var IsDisabled : Bool?
    var CertificateFile : String?
}

struct DependantDBRecords {
    //Comment..
    var srNo : Int = 10
    var personName  : String?
    var relation  : String?
    var gender  : String?
    var relationID   : String?
    var age : String?
    var dateofBirth  : String?
    var personSrNo  : String?
    var reasonForNotAbleToDelete :String?
    var isTwins :String?
    var reasonForNotAbleToUpdate : String?
    var twinpairNo : String?
    var extraChildPremium : String?
    var premiumAmount : String?
    //personDiffAbleSrNo && certificateFile IN DISABLE STRUCT
    var enrollment_Reason : String?
    var productCode  : String?
    var parentPercentage : Double = 0.0
    var isPremiumShow : Bool?
    var isSelected : Bool?
    var isApplicable: Bool?
    var canDelete: Bool?
    var canUpdate: Bool?
    var isDisabled: Bool?
    var isAdded: Bool?
  
    //Not from Json
    var cellPhoneNUmber : String?
    var emailIDStr  : String?
    var empSrNo  : Int?
    var isValid : Int?
    var twinPair : Int = 111
    var isHeader = false
    var selectedFilename = ""
    
    
}

class DependantsListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,NewDependentAddedProtocol,XMLParserDelegate,TwinsAddedProtocol {
 
    @IBOutlet weak var tableView: UITableView!
        
    let relationDropDown=DropDown()
    var m_gender = String()
    var m_membersArray = Array<String>()
    var m_extraMemberArray = Array<String>()
    var strArrayCoverMembers = Array<String>()
    var m_membersRelationIdArray = Array<String>()
    var m_membersNameArray = Array<String>()
    var m_relationID = String()
    
    var m_dobNotAvailable = Bool()
    var m_isPremiumAccepted = Bool()
    
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    
    //For Already Added Emp
    // var addedPersonDataArray = Array<PERSON_INFORMATION>()
    var addedPersonDataArray = [PERSON_INFORMATION]()
    var dataSourceArray = [PERSON_INFORMATION]()
    var m_productCode = String()
    
    var lastContentOffset: CGFloat = 0 //ScrollViewDelegate
    var hideCollectionViewDelegate : HideCollectionViewProtocol? = nil
    
    //Temp
    var m_isUpdated = Bool()
    var m_employeedict : EMPLOYEE_INFORMATION?
    
    var m_enrollmentMiscInformationDict = NSDictionary()
    
    var structDataSource = [DependantDBRecords]()
    var structDataSourceD = [DependantDBRecords]()
    var tempDataSource = [DependantDBRecords]()
    var tempDataSourceNew = [DependantDBRecords]()
    var differentDataSource = [DifferentlyDBRecords]()
    
    var indexNumber = Int()
    
    var allowedDependants = ["SON","DAUGHTER","SON"]
    
    var xmlKeysArray = ["GroupInformation","BrokerInformation","GroupProducts","GroupPolicies","GroupPoliciesEmployees","GroupPoliciesEmployeesDependants","EnrollmentParentalOptions"]
    var dictionaryKeys = ["WINDOW_PERIOD_ACTIVE","PARENTAL_PREMIUM", "CROSS_COMBINATION_ALLOWED", "PAR_POL_INCLD_IN_MAIN_POLICY", "LIFE_EVENT_DOM","LIFE_EVENT_CHILDDOB","SON_MAXAGE","DAUGHTER_MAXAGE","PARENTS_MAXAGE","LIFE_EVENT_DOM_VALDTN_MSG","LIFE_EVENT_CHILDDOB_VALDTN_MSG","SON_MAXAGE_VALDTN_MSG","DAUGHTER_MAXAGE_VALDTN_MSG","PARENTS_MAXAGE_VALDTN_MSG","IS_TOPUP_OPTION_AVAILABLE","TOPUP_OPTIONS","TOPUP_PREMIUMS","ENRL_CNRFM_ALLOWED_FREQ","ENRL_CNRFM_MESSAGE","WINDOW_PERIOD_END_DATE","WINDOW_PERIOD_ACTIVE_TILL_MESSAGE","TOTAL_POLICY_FAMILY_COUNT","RELATION_COVERED_IN_FAMILY","RELATION_ID_COVERED_IN_FAMILY","MAIN_POLICY_FAMILY_COUNT","PARENTAL_POLICY_FAMIL_COUNT","IS_ENROLLMENT_CONFIRMED","EMPLOYEE_EDITABLE_FIELDS","TOPUP_OPT_TOTAL_DAYS_LAPSED","INSTALLMENT_MESSAGE","DBOperationMessage","DB_OPERATION_MESSAGE","EMPLOYEE_RELATION", "EMPLOYEE_RELATION_ID", "EMPLOYEE_NAME", "EMPLOYEE_DOB","EMPLOYEE_AGE","EMPLOYEE_GENDER","PERSON_SR_NO","OFFICIAL_EMAIL_ID","PERSONAL_EMAIL_ID","CELLPHONE_NO","BASE_SUM_INSURED","TOPUP_SUM_INSURED","EMPLOYEE_IDENTIFICATION_NO","EMPLOYEE_GRADE","EMPLOYEE_DEPARTMENT","EMPLOYEE_DESIGNATION","EMPLOYEE_DOJ","EMP_TOPUP_OPTED","EMP_TOPUP_SI","EMP_TOPUP_PREMIUM","EMP_TOPUP_PREM_DEDTN_MESSAGE","EMP_TOPUP_OPTD_SR_NO","PERSON_SR_NO","DependantAddInformation","DependantDeleteInformation","person_sr_no","employee_sr_no","age","date_of_birth","cellphone_no","person_name","gender","relationname","relationid","Dependant1","Dependant2","Dependant3","Dependant4","Dependant5","Dependant6","Dependant7","Dependant8","GroupInformation","OTPValidatedInformation","GROUPCHILDSRNO","GROUPCODE","GROUPNAME","GroupInformation","GroupGMCPolicies","GMCEmployee","GPAEmployee","GTLEmployee","tpa_code","tpa_name","ins_co_code","ins_co_name", "oe_gr_bas_inf_sr_no" ,"policy_number","ins_co_name","policy_commencement_date","policy_validupto_date","PRODUCTCODE","active","employee_id","oe_grp_bas_inf_sr_no","EMPLOYEENAME","GENDER","employee_sr_no","groupchildsrno","BROKERNAME","date_of_joining","official_e_mail_id","department","grade","designation","person_sr_no","employee_sr_no","age","date_of_birth","cellphone_no","person_name","gender","relationname","relationid","policy1","policy2","policy3","policy4","policy5","policy6","policy7","policy8","policy9","policy10","ProductCode","GMC","GPA","GTL","Dependant1","Dependant2","Dependant3","Dependant4","Dependant5","Dependant6","Dependant7","Dependant8","BROKER_NAME","BROKER_CODE","base_suminsured","topup_suminsured","PendingRelations","Relation","Name","ID","status","DependantUpdateInformation","base_suminsured","topup_suminsured","date_of_datainsert","topup_si_pk","topup_si_opted_flag","topup_si_opted","status","TopupInformation","topup_si_premium","ParentsCoveredInBasePolicy","CrossCombinationOfParentsAllowed","ParentalInformation","parent","FatherSumInsured","Premium","MotherSumInsured","FatherInLawSumInsured","MotherInLawSumInsured"]
    
    
    var addedChildCount = 0
    var m_ChildCount = 0
    var isEmptyList = true
    var m_ExtraAmount = String()
    var refreshControl: UIRefreshControl!
    //var documentController: UIDocumentInteractionController = UIDocumentInteractionController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("#VDL - Dependant list")
        //self.view.setBackgroundGradientColor(index: 0)
        
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        
        navigationController?.isNavigationBarHidden=false
        self.navigationItem.title = "Enrollment"
        self.navigationItem.leftBarButtonItem=getBackButton()
        
        let startPoint = CGPoint(x:0.5, y:0.0)
        let endPoint = CGPoint(x:0.5, y:1.0)
        
        
        
        // self.view.setGradientBackgroundColor(colorTop: EnrollmentColor.ghiTop.value, colorBottom: EnrollmentColor.ghiBottom.value, startPoint: startPoint, endPoint: endPoint)
        setColorNew(view: self.view, colorTop: EnrollmentColor.empDetailsTop.value, colorBottom: EnrollmentColor.empDetailsBottom.value,gradientLayer:gradientLayer)
        
        
        if let enrollmentMiscInfo = UserDefaults.standard.value(forKey: "EnrollmentMiscInformation")
        {
            m_enrollmentMiscInformationDict = enrollmentMiscInfo as! NSDictionary
        }
        
        //Next Button Cell
        tableView.register(CellForExistingDependants.self, forCellReuseIdentifier: "CellForExistingDependants")
        tableView.register(UINib(nibName: "CellForExistingDependants", bundle: nil), forCellReuseIdentifier: "CellForExistingDependants")
        
        tableView.register(CellForInstructionHeaderCell.self, forCellReuseIdentifier: "CellForInstructionHeaderCell")
        tableView.register(UINib(nibName: "CellForInstructionHeaderCell", bundle: nil), forCellReuseIdentifier: "CellForInstructionHeaderCell")
        
        
        //Add New Dependants Cell
        tableView.register(CellForNewDependants.self, forCellReuseIdentifier: "CellForNewDependants")
        tableView.register(UINib(nibName: "CellForNewDependants", bundle: nil), forCellReuseIdentifier: "CellForNewDependants")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)

       
        
         

        
    }
    @objc func didPullToRefresh() {
        let anotherQueue = DispatchQueue(label: "com.appcoda.dependantQueue", qos: .default)
        anotherQueue.async {
            if(!self.isConnectedToNet()) {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    
                }            }
            // getDependantsFromServer()
            self.getDifferentlyAbledFromServer()
        }
        
        anotherQueue.async {
            DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            }
        }
    }

    
    
    private func displayOverlay() {
        let vc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "OverlayForDependantsVC") as! OverlayForDependantsVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        
        UserDefaults.standard.setValue(true, forKey: "dependantOverlay")
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    
    
    var isFetched = 0
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear...............")
       
        
     
        // getDependantsFromServer()
        getDifferentlyAbledFromServer()
                  
    }
    
    
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = self.view.bounds
        CATransaction.commit()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear...............")
        if let val = UserDefaults.standard.value(forKey: "dependantOverlay") as? Bool {
            if val == false {
                displayOverlay()
            }
        }
        else {
            displayOverlay()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear...............")
        
    }
    
    
    //MARK:- Custom Delegate Methods - ADD DEPENDANT *****
    //For Spouse/Partner
    //if user added partner then remove empty cell of spouse.
    //if user added spouce then remove empty cell of wife/husband.
    func newDependantAdded(position:Int,data:DependantDBRecords) {
        print("Dependant Added.....\(position)")
        
       // getDependantsFromServer()
        getDifferentlyAbledFromServer()
        /*
        self.structDataSource[position].isEmpty = false
        self.structDataSource[position].personName = data.personName
        self.structDataSource[position].relationname = data.relationname
        self.structDataSource[position].dateofBirth = data.dateofBirth
        self.structDataSource[position].age = data.age
        self.structDataSource[position].gender = data.gender
        self.structDataSource[position].sortId = data.sortId

        
        
        let index = IndexPath(row: position , section: 1)
        //tableView.deleteRows(at: [index], with: UITableView.RowAnimation.right)
        
        if structDataSource[position].relationname?.lowercased() == "wife" || structDataSource[position].relationname?.lowercased() == "husband" {
         //Remove Partner Cell
            if let index = structDataSource.index(where: {$0.relationname?.lowercased() == "partner"}) {
                structDataSource.remove(at: index)
            }
            refreshSortedTableView()
        }
        else if structDataSource[position].relationname?.lowercased() == "partner" {
            if let index = structDataSource.index(where: {$0.relationname?.lowercased() == m_spouse.lowercased()}) {
                if let index = structDataSource.index(where: {$0.relationname?.lowercased() == m_spouse.lowercased()}) {
                    structDataSource.remove(at: index)
                }
                refreshSortedTableView()
            }
            else { //to refresh cell when user add/edit partner data
            tableView.reloadRows(at: [index], with: .left)
            }

        }
        else {
            print("Child Added..",self.addedChildCount)
            self.addedChildCount += 1
            
            if addedChildCount >= 2 { //If Two Child Added Then remove all empty Cells
                if let indexFound = structDataSource.index(where: {$0.relationname?.lowercased() == "twins" && $0.isEmpty == true}) {
                    structDataSource.remove(at: indexFound)
                }

                if let sindexFound = structDataSource.index(where: {$0.relationname?.lowercased() == "son" && $0.isEmpty == true}) {
                                   structDataSource.remove(at: sindexFound)
                               }
                if let dindexFound = structDataSource.index(where: {$0.relationname?.lowercased() == "daughter" && $0.isEmpty == true}) {
                                   structDataSource.remove(at: dindexFound)
                               }
            }
            else {
             //Add empty cards
                self.addEmptyCards()
            }
            
            refreshSortedTableView()
           // tableView.reloadRows(at: [index], with: .left)

        }
        */
    }
    
    
    private func addEmptyCards() {
           let array = self.structDataSource.filter({$0.srNo == 5 && $0.isAdded == true})
           if array.count == 0 {
           self.EmptyObj.isAdded = true
           self.EmptyObj.relation = "Twins"
            self.EmptyObj.relationID = self.getRelationId(relation: self.EmptyObj.relation!)
           //self.EmptyObj.relationID = Int(self.getRelationId(relation: self.EmptyObj.relationname!))
           self.EmptyObj.srNo = 5
           self.structDataSource.append(self.EmptyObj)
           }
           
         //Add Son Empty Card
           let sonArray = self.structDataSource.filter({$0.srNo == 3 && $0.isAdded == true})
           if sonArray.count == 0 {
           self.EmptyObj.isAdded = true
           self.EmptyObj.relation = "SON"
            //self.EmptyObj.relationID = Int(self.getRelationId(relation: self.EmptyObj.relationname!))
            self.EmptyObj.relationID = self.getRelationId(relation: self.EmptyObj.relation!)

           self.EmptyObj.srNo = 3
           self.structDataSource.append(self.EmptyObj)
           }
           
           
        //Add Daughter Empty Card
           let daughterArray = self.structDataSource.filter({$0.srNo == 4 && $0.isAdded == true})
           if daughterArray.count == 0 {
           self.EmptyObj.isAdded = true
           self.EmptyObj.relation = "DAUGHTER"
            //self.EmptyObj.relationID = Int(self.getRelationId(relation: self.EmptyObj.relationname!))
               self.EmptyObj.relationID = self.getRelationId(relation: self.EmptyObj.relation!)
           self.EmptyObj.srNo = 4
           self.structDataSource.append(self.EmptyObj)
           }
        
        self.refreshSortedTableView()

    }
    
    //MARK:- Sort and refresh tableView
    private func refreshSortedTableView() {
        let tempDataSource = structDataSource.sorted(by: { $0.srNo < $1.srNo })
        
  //      tempDataSource =  tempDataSource.sorted{ Int.init($0.isEmpty ?? true) < Int.init(!($1.isEmpty ?? true)) }
       // tempDataSource = tempDataSource.sorted(by: { $0.isEmpty?.description < $1.isEmpty?.description })

        structDataSource = tempDataSource.sorted(by:{ !$0.isAdded! && $1.isAdded!})
        
        
        self.tableView.reloadData()
        
        //For Summary data
        dependantModelArray = self.structDataSource.filter({$0.isAdded == false})
        
    }
    
    //MARK:- TWINS ADDED **********
    //Already one Empty card is present append filled empty cards in array.
    //if two child added then remove empty cards.
    func newTwinsAdded(position: Int, dataArray: [DependantDBRecords]) {
        
        // getDependantsFromServer()
        getDifferentlyAbledFromServer()
        /*
        print("Twins Added =",addedChildCount)
        //Append both child1 child2 in array.
        self.structDataSource.append(dataArray[0])
        self.structDataSource.append(dataArray[1])
        
        //sort array on sortId
        structDataSource = structDataSource.sorted(by: { $0.sortId < $1.sortId })

        //increment count
        self.addedChildCount += 1
        print("Twins After +1 =",addedChildCount)

        //check condition and remove empty cards
        //NEW SOLUTION - we can directly remove all empty cards using filter i.e. if isEmpty == true then remove all cards
        if addedChildCount >= 2 {
            print("remove empty cells")
            if let indexFound = structDataSource.index(where: {$0.relationname?.lowercased() == "twins" && $0.isEmpty == true}) {
                if structDataSource[indexFound].isEmpty == true { //to remove empty card
                    print("Empty twins removed")

                structDataSource.remove(at: indexFound)
                }
            }
            
            if let indexFoundSon = structDataSource.index(where: {$0.relationname?.lowercased() == "son" && $0.isEmpty == true}) {
                if structDataSource[indexFoundSon].isEmpty == true {//to remove empty card
                    print("Empty son removed")
                structDataSource.remove(at: indexFoundSon)
                }
            }
            
            if let indexFoundDaughter = structDataSource.index(where: {$0.relationname?.lowercased() == "daughter" && $0.isEmpty == true}) {
                if structDataSource[indexFoundDaughter].isEmpty == true { //to remove empty card
                    print("Empty daughter removed")

                structDataSource.remove(at: indexFoundDaughter)
                }
            }
            
            refreshSortedTableView()

        }
        
        refreshSortedTableView()
        */
     }
    
    //MARK:- UPDATE TWINS
    //Removed old twins from array and append new twins.
    func twinsUpdated(positionFirst:Int,positionSecond:Int,dataArray:[DependantDBRecords],pairId:Int)
    {
        // getDependantsFromServer()
        getDifferentlyAbledFromServer()
        /*
        if dataArray.count == 2 {
        self.structDataSource = self.structDataSource.filter({$0.twinPair != pairId})

        self.structDataSource.append(dataArray[0])
        self.structDataSource.append(dataArray[1])
            
            self.refreshSortedTableView()
        }
        */
    }
    
    var notAddedArray = ["WIFE","SON","DAUGHTER"]
    
    var EmptyObj = DependantDBRecords.init()
    /*
    func getPersonDetailsFromDB()
    {
        print("GetPersons....\(m_spouse)")
        addedPersonDataArray.removeAll()
        m_membersRelationIdArray=[]
        m_membersArray=[]
        m_productCode="GMC"
        
        self.structDataSource.removeAll()
        
        let array = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: m_spouse)
        if(array.count>0)
        {
            addedPersonDataArray.append(array[0])
            let obj = DependantDBRecords.init(age: Int(array[0].age), cellPhoneNUmber:array[0].cellPhoneNUmber , dateofBirth: array[0].dateofBirth, emailIDStr: array[0].emailID, empSrNo: Int(array[0].empSrNo), gender: array[0].gender, isValid: Int(array[0].isValid), personName: array[0].personName, personSrNo: Int(array[0].personSrNo), productCode: array[0].productCode, relationID: Int(array[0].relationID), relationname: array[0].relationname,isEmpty: false,sortId: 1)
            
            self.structDataSource.append(obj)
        }
        else {
            print("Spouse Empty")
            EmptyObj.isEmpty = true
            EmptyObj.relationname = m_spouse
            EmptyObj.sortId = 1
            self.structDataSource.append(EmptyObj)
            
            EmptyObj.isEmpty = true
            EmptyObj.relationname = "PARTNER"
            EmptyObj.sortId = 2
            self.structDataSource.append(EmptyObj)
        }
        
        //SON
        let arrayofSon = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "SON")
        if(arrayofSon.count>0)
        {
            
            if(arrayofSon.count==2)
            {
                addedPersonDataArray.append(arrayofSon[0])
                addedPersonDataArray.append(arrayofSon[1])
                
                let obj = DependantDBRecords.init(age: Int(arrayofSon[0].age), cellPhoneNUmber:arrayofSon[0].cellPhoneNUmber , dateofBirth: arrayofSon[0].dateofBirth, emailIDStr: arrayofSon[0].emailID, empSrNo: Int(arrayofSon[0].empSrNo), gender: arrayofSon[0].gender, isValid: Int(arrayofSon[0].isValid), personName: arrayofSon[0].personName, personSrNo: Int(arrayofSon[0].personSrNo), productCode: arrayofSon[0].productCode, relationID: Int(arrayofSon[0].relationID), relationname: arrayofSon[0].relationname,isEmpty: false,sortId: 3)
                
                self.structDataSource.append(obj)
                
                
                let obj1 = DependantDBRecords.init(age: Int(arrayofSon[1].age), cellPhoneNUmber:arrayofSon[1].cellPhoneNUmber , dateofBirth: arrayofSon[1].dateofBirth, emailIDStr: arrayofSon[1].emailID, empSrNo: Int(arrayofSon[1].empSrNo), gender: arrayofSon[1].gender, isValid: Int(arrayofSon[1].isValid), personName: arrayofSon[1].personName, personSrNo: Int(arrayofSon[1].personSrNo), productCode: arrayofSon[1].productCode, relationID: Int(arrayofSon[1].relationID), relationname: arrayofSon[1].relationname,isEmpty: false,sortId: 3)
                
                self.structDataSource.append(obj1)
                
                self.addedChildCount += 2

            }
            else if(arrayofSon.count==3)
            {
                addedPersonDataArray.append(arrayofSon[0])
                addedPersonDataArray.append(arrayofSon[1])
                addedPersonDataArray.append(arrayofSon[2])
                
                let obj = DependantDBRecords.init(age: Int(arrayofSon[0].age), cellPhoneNUmber:arrayofSon[0].cellPhoneNUmber , dateofBirth: arrayofSon[0].dateofBirth, emailIDStr: arrayofSon[0].emailID, empSrNo: Int(arrayofSon[0].empSrNo), gender: arrayofSon[0].gender, isValid: Int(arrayofSon[0].isValid), personName: arrayofSon[0].personName, personSrNo: Int(arrayofSon[0].personSrNo), productCode: arrayofSon[0].productCode, relationID: Int(arrayofSon[0].relationID), relationname: arrayofSon[0].relationname,isEmpty: false,sortId: 3)
                self.structDataSource.append(obj)
                
                let obj1 = DependantDBRecords.init(age: Int(arrayofSon[1].age), cellPhoneNUmber:arrayofSon[1].cellPhoneNUmber , dateofBirth: arrayofSon[1].dateofBirth, emailIDStr: arrayofSon[1].emailID, empSrNo: Int(arrayofSon[1].empSrNo), gender: arrayofSon[1].gender, isValid: Int(arrayofSon[1].isValid), personName: arrayofSon[1].personName, personSrNo: Int(arrayofSon[1].personSrNo), productCode: arrayofSon[1].productCode, relationID: Int(arrayofSon[1].relationID), relationname: arrayofSon[1].relationname,isEmpty: false,sortId: 3)
                self.structDataSource.append(obj1)
                
                let obj2 = DependantDBRecords.init(age: Int(arrayofSon[2].age), cellPhoneNUmber:arrayofSon[2].cellPhoneNUmber , dateofBirth: arrayofSon[2].dateofBirth, emailIDStr: arrayofSon[2].emailID, empSrNo: Int(arrayofSon[2].empSrNo), gender: arrayofSon[2].gender, isValid: Int(arrayofSon[2].isValid), personName: arrayofSon[2].personName, personSrNo: Int(arrayofSon[2].personSrNo), productCode: arrayofSon[2].productCode, relationID: Int(arrayofSon[2].relationID), relationname: arrayofSon[2].relationname,isEmpty: false,sortId: 3)
                self.structDataSource.append(obj2)
                
                self.addedChildCount += 3

            }
            else
            {
                addedPersonDataArray.append(arrayofSon[0])
                let obj = DependantDBRecords.init(age: Int(arrayofSon[0].age), cellPhoneNUmber:arrayofSon[0].cellPhoneNUmber , dateofBirth: arrayofSon[0].dateofBirth, emailIDStr: arrayofSon[0].emailID, empSrNo: Int(arrayofSon[0].empSrNo), gender: arrayofSon[0].gender, isValid: Int(arrayofSon[0].isValid), personName: arrayofSon[0].personName, personSrNo: Int(arrayofSon[0].personSrNo), productCode: arrayofSon[0].productCode, relationID: Int(arrayofSon[0].relationID), relationname: arrayofSon[0].relationname,isEmpty: false,sortId: 3)
                self.structDataSource.append(obj)
                self.addedChildCount += 1

            }
        }
        else {
            print("Son Empty")
            let array:Array<EnrollmentGroupRelations> = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: "SON")
                      var minAge = "0"
                      var maxAge = "0"
                      var relationId = ""
                      if array.count > 0 {
                          relationId = array[0].relationID!
                          maxAge = array[0].minAge!
                          minAge = array[0].maxAge!
                      }
            
            EmptyObj.isEmpty = true
            EmptyObj.relationname = "SON"
            EmptyObj.sortId = 3
            if relationId != "" {
            EmptyObj.relationID = Int(relationId)
            }
            self.structDataSource.append(EmptyObj)
        }
        
        
        let arrayofDaughter = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "DAUGHTER")
        if(arrayofDaughter.count>0)
        {
            if(arrayofDaughter.count==2)
            {
                addedPersonDataArray.append(arrayofDaughter[0])
                addedPersonDataArray.append(arrayofDaughter[1])
                
                let obj = DependantDBRecords.init(age: Int(arrayofDaughter[0].age), cellPhoneNUmber:arrayofDaughter[0].cellPhoneNUmber , dateofBirth: arrayofDaughter[0].dateofBirth, emailIDStr: arrayofDaughter[0].emailID, empSrNo: Int(arrayofDaughter[0].empSrNo), gender: arrayofDaughter[0].gender, isValid: Int(arrayofDaughter[0].isValid), personName: arrayofDaughter[0].personName, personSrNo: Int(arrayofDaughter[0].personSrNo), productCode: arrayofDaughter[0].productCode, relationID: Int(arrayofDaughter[0].relationID), relationname: arrayofDaughter[0].relationname,isEmpty: false,sortId: 4)
                self.structDataSource.append(obj)
                
                let obj1 = DependantDBRecords.init(age: Int(arrayofDaughter[1].age), cellPhoneNUmber:arrayofDaughter[1].cellPhoneNUmber , dateofBirth: arrayofDaughter[1].dateofBirth, emailIDStr: arrayofDaughter[1].emailID, empSrNo: Int(arrayofDaughter[1].empSrNo), gender: arrayofDaughter[1].gender, isValid: Int(arrayofDaughter[1].isValid), personName: arrayofDaughter[1].personName, personSrNo: Int(arrayofDaughter[1].personSrNo), productCode: arrayofDaughter[1].productCode, relationID: Int(arrayofDaughter[1].relationID), relationname: arrayofDaughter[1].relationname,isEmpty: false,sortId: 4)
                self.structDataSource.append(obj1)
                
                self.addedChildCount += 2

                
            }
            else if(arrayofDaughter.count==3)
            {
                addedPersonDataArray.append(arrayofDaughter[0])
                addedPersonDataArray.append(arrayofDaughter[1])
                addedPersonDataArray.append(arrayofDaughter[2])
                
                let obj = DependantDBRecords.init(age: Int(arrayofDaughter[0].age), cellPhoneNUmber:arrayofDaughter[0].cellPhoneNUmber , dateofBirth: arrayofDaughter[0].dateofBirth, emailIDStr: arrayofDaughter[0].emailID, empSrNo: Int(arrayofDaughter[0].empSrNo), gender: arrayofDaughter[0].gender, isValid: Int(arrayofDaughter[0].isValid), personName: arrayofDaughter[0].personName, personSrNo: Int(arrayofDaughter[0].personSrNo), productCode: arrayofDaughter[0].productCode, relationID: Int(arrayofDaughter[0].relationID), relationname: arrayofDaughter[0].relationname,isEmpty: false,sortId: 4)
                self.structDataSource.append(obj)
                
                let obj1 = DependantDBRecords.init(age: Int(arrayofDaughter[1].age), cellPhoneNUmber:arrayofDaughter[1].cellPhoneNUmber , dateofBirth: arrayofDaughter[1].dateofBirth, emailIDStr: arrayofDaughter[1].emailID, empSrNo: Int(arrayofDaughter[1].empSrNo), gender: arrayofDaughter[1].gender, isValid: Int(arrayofDaughter[1].isValid), personName: arrayofDaughter[1].personName, personSrNo: Int(arrayofDaughter[1].personSrNo), productCode: arrayofDaughter[1].productCode, relationID: Int(arrayofDaughter[1].relationID), relationname: arrayofDaughter[1].relationname,isEmpty: false,sortId: 4)
                self.structDataSource.append(obj1)
                
                let obj2 = DependantDBRecords.init(age: Int(arrayofDaughter[2].age), cellPhoneNUmber:arrayofDaughter[2].cellPhoneNUmber , dateofBirth: arrayofDaughter[2].dateofBirth, emailIDStr: arrayofDaughter[2].emailID, empSrNo: Int(arrayofDaughter[2].empSrNo), gender: arrayofDaughter[2].gender, isValid: Int(arrayofDaughter[2].isValid), personName: arrayofDaughter[2].personName, personSrNo: Int(arrayofDaughter[2].personSrNo), productCode: arrayofDaughter[2].productCode, relationID: Int(arrayofDaughter[2].relationID), relationname: arrayofDaughter[2].relationname,isEmpty: false,sortId: 4)
                self.structDataSource.append(obj2)
                
                self.addedChildCount += 3

            }
            else
            {
                addedPersonDataArray.append(arrayofDaughter[0])
                let obj = DependantDBRecords.init(age: Int(arrayofDaughter[0].age), cellPhoneNUmber:arrayofDaughter[0].cellPhoneNUmber , dateofBirth: arrayofDaughter[0].dateofBirth, emailIDStr: arrayofDaughter[0].emailID, empSrNo: Int(arrayofDaughter[0].empSrNo), gender: arrayofDaughter[0].gender, isValid: Int(arrayofDaughter[0].isValid), personName: arrayofDaughter[0].personName, personSrNo: Int(arrayofDaughter[0].personSrNo), productCode: arrayofDaughter[0].productCode, relationID: Int(arrayofDaughter[0].relationID), relationname: arrayofDaughter[0].relationname,isEmpty: false,sortId: 4)
                self.structDataSource.append(obj)
                
                self.addedChildCount += 1
            }
        }
        else {
            print("DAUGHTER Empty")
            let array:Array<EnrollmentGroupRelations> = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: "DAUGHTER")
                                 var relationId = ""
                                 if array.count > 0 {
                                     relationId = array[0].relationID!
                                 }
            
            EmptyObj.isEmpty = true
            EmptyObj.relationname = "DAUGHTER"
            EmptyObj.sortId = 4
            if relationId != "" {
            EmptyObj.relationID = Int(relationId)
            }
            self.structDataSource.append(EmptyObj)
        }
        
        
        if addedChildCount < 2 {
        //Add Twins Card
        EmptyObj.isEmpty = true
        EmptyObj.relationname = "Twins"
        EmptyObj.sortId = 5
        self.structDataSource.append(EmptyObj)
        }
        else {
         //remove Empty Cards
            removeEmptyChildCards()
        }
        
        

        print(addedPersonDataArray)
        getRelationsfromServer()
        
        
        
        print(m_membersArray,m_membersRelationIdArray,addedPersonDataArray)
        
    
       // self.dataSourceArray = addedPersonDataArray

        structDataSource = structDataSource.sorted(by: { $0.sortId < $1.sortId })

        self.tableView.reloadData() {
            self.isLoaded = 1
        }
        //animateTable()
    }
    */
    var animationsQueue = ChainedAnimationsQueue()
    var isLoaded = 0
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoaded == 0 {
            //   isLoaded = 1
            if indexPath.section == 1 {
                cell.alpha = 0.0
                animationsQueue.queue(withDuration: 0.4, initializations: {
                    cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, cell.frame.size.width, 0, 0)
                }, animations: {
                    cell.alpha = 1.0
                    cell.layer.transform = CATransform3DIdentity
                })
                
            }
            else {
                //if isLoaded == 0 {
                
                cell.alpha = 0.0
                animationsQueue.queue(withDuration: 0.4, initializations: {
                    cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -cell.frame.size.width, 0, 0)
                }, animations: {
                    cell.alpha = 1.0
                    cell.layer.transform = CATransform3DIdentity
                })
                // isLoaded = 1
                //   }
                
            }
        }
    }
    
    var xmlKey = "Adminsettings"
    var m_dependantArray = Array<DependantDetails>()
    var addedPersonDetailsArray = Array<PERSON_INFORMATION>()
    var dependantsDictArray: [[String: String]]?
    var pendingRelationsDictArray: [[String: String]]?
    
    //MARK:- Get Relations
    func getRelationsfromServer()
    {
        
        print("#getRelationsfromServer().....")
        if(isConnectedToNetWithAlert())
        {
            
            showPleaseWait(msg: "Please wait updating details...")
            
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getRelationsPostUrl() as String)
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                m_employeedict=userArray[0]
                
                var oe_group_base_Info_Sr_No = String()
                var groupChildSrNo = String()
                var employeesrno = String()
                
                if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
                {
                    oe_group_base_Info_Sr_No = String(empNo)
                }
                if let groupChlNo = m_employeedict?.groupChildSrNo
                {
                    groupChildSrNo=String(groupChlNo)
                }
                if let employeeno = m_employeedict?.empSrNo
                {
                    employeesrno=String(employeeno)
                }
                
                let yourXML = AEXMLDocument()
                
                let dataRequest = yourXML.addChild(name: "DataRequest")
                dataRequest.addChild(name: "groupchildsrno", value: groupChildSrNo)
                dataRequest.addChild(name: "oegrpbasinfsrno", value: oe_group_base_Info_Sr_No)
                dataRequest.addChild(name: "employeesrno", value: employeesrno)
                
                print(yourXML.xml)
                let uploadData = yourXML.xml.data(using: .utf8)
                
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
                                    
                                    self.xmlKey = "PendingRelations"
                                    let parser = XMLParser(data: data!)
                                    parser.delegate = self as? XMLParserDelegate
                                    parser.parse()
                                    
                                    DispatchQueue.main.async(execute:
                                        {
                                            
                                            print("PENDING RELATIONS...")
                                            print(self.pendingRelationsDictArray)
                                            if((self.pendingRelationsDictArray?.count)!>0)
                                            {
                                                for dict in self.pendingRelationsDictArray!
                                                {
                                                    let infoDict : NSDictionary = dict as NSDictionary
                                                    
                                                    if let name = infoDict.value(forKey: "Name")
                                                    {
                                                        self.m_membersArray.append(name as! String)
                                                        if let ID = infoDict.value(forKey: "ID")
                                                        {
                                                            self.m_membersRelationIdArray.append(ID as! String)
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                            
                                            
                                            if(self.m_membersArray.count==0)
                                            {
                                                //Hide Add Dependant
                                            }
                                            else
                                            {
                                                if(self.checkConfirmedStatus())
                                                {
                                                    //Display Add Dependant
                                                    
                                                }
                                                else
                                                {
                                                    //Hide Add Dependant
                                                }
                                            }
                                            
                                            
                                            //Commented by Pranit - avoid UI hikup when user come to dependant details screen,
                                            //self.m_dependantDetailsTableview.reloadData()
                                            
                                            print(self.m_membersArray,self.pendingRelationsDictArray)
                                            self.hidePleaseWait()
                                    })
                                    
                                }
                                catch let JSONError as NSError
                                {
                                    print(JSONError)
                                    self.hidePleaseWait()
                                    //Crashlytics.sharedInstance().recordError(m_errorMsg as! Error)
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
    }
    
     func removeEmptyChildCards() {
        if addedChildCount >= 2 { //If Two Child Added Then remove all empty Cells
            if let indexFound = structDataSource.index(where: {$0.relation?.lowercased() == "twins" && $0.isAdded == true}) {
                structDataSource.remove(at: indexFound)
            }

            if let sindexFound = structDataSource.index(where: {$0.relation?.lowercased() == "son" && $0.isAdded == true}) {
                               structDataSource.remove(at: sindexFound)
                           }
            if let dindexFound = structDataSource.index(where: {$0.relation?.lowercased() == "daughter" && $0.isAdded == true}) {
                               structDataSource.remove(at: dindexFound)
                           }
        }
    }
    
    func checkConfirmedStatus() -> Bool
    {
        if let nTimesEnrollmentCanBeConfirmed = m_enrollmentMiscInformationDict.value(forKey: "NTimesEnrollmentCanBeConfirmed")as? String
        {
            if(nTimesEnrollmentCanBeConfirmed == "MULTIPLE")
            {
                return true
            }
            else
            {
                
                return !m_isEnrollmentConfirmed
                
            }
        }
        return true
    }
    
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    
    //MARK:- PARSER
    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
        dependantsDictArray = []
        pendingRelationsDictArray = []
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
            if(xmlKeysArray.contains(xmlKey))
            {
                print(indexNumber,xmlKeysArray)
                indexNumber=indexNumber+1
                if(xmlKeysArray.count>indexNumber)
                {
                    xmlKey=xmlKeysArray[indexNumber]
                }
            }
            
        }
            
        else if(elementName=="Relation")
        {
            if currentDictionary != nil
            {
                pendingRelationsDictArray?.append(currentDictionary!)
            }
            
        }
    }
    
}

//===============================================================================================
//MARK:- TableView Delegates
extension DependantsListVC {
    
    
    func hideEditButtons(cell:CellForExistingDependants)
    {
        cell.m_deleteButton.isHidden=true
        cell.m_editButton.isHidden=true
        cell.m_nameTextField.isUserInteractionEnabled=false
        cell.m_dobTextField.isUserInteractionEnabled=false
        cell.m_ageTextField.isUserInteractionEnabled=false
        
        //Added By Pranit - 30 Jan 20
        // cell.heightBtnConstant.constant = 0
    }
    func showEditButtons(cell:CellForExistingDependants)
    {
        cell.m_deleteButton.isHidden=false
        cell.m_editButton.isHidden=false
        cell.m_nameTextField.isUserInteractionEnabled=false
        cell.m_dobTextField.isUserInteractionEnabled=false
        cell.m_ageTextField.isUserInteractionEnabled=false
        
        //Added By Pranit - 30 Jan 20
        //cell.heightBtnConstant.constant = 32
        
        cell.m_editButton.makeCicular()
        cell.m_deleteButton.makeCicular()
        cell.m_deleteButton.layer.masksToBounds = true
        cell.m_editButton.layer.masksToBounds = true
        
    }
    
     //MARK:- TableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 { //Added Dependant + Top Cell
            print(structDataSource.count)
            return 1
        }
        else {
            print(structDataSource.count)
            return  structDataSource.count
        }
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell : CellForInstructionHeaderCell = tableView.dequeueReusableCell(withIdentifier: "CellForInstructionHeaderCell", for: indexPath) as! CellForInstructionHeaderCell
            cell.imgView.image = UIImage(named:"dependantList")
            cell.lblHeaderName.text = "Dependant Details"
            cell.lblDescription.text = "you can add upto 3 dependants \n Spouse or Partner + 2 children"
            //            cell.backView.layer.cornerRadius = 8.0
            //            cell.btnAdd.tag = indexPath.row
            //            cell.btnAdd.addTarget(self, action: #selector(addNewParentTapped(_:)), for: .touchUpInside)
            
            return cell
            
            
            
        }//If SECTION = 0
        else {
            //        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForNextButtonBottom", for: indexPath) as! CellForNextButtonBottom
            //        cell.btnNext.tag = indexPath.row
            //        cell.btnNext.addTarget(self, action: #selector(moveToNext(_:)), for: .touchUpInside)
            
            let obj  = structDataSource[indexPath.row]
            if obj.isAdded == false { //display data
                let cell : CellForExistingDependants = tableView.dequeueReusableCell(withIdentifier: "CellForExistingDependants", for: indexPath) as! CellForExistingDependants
                
                //cell.lblAmount.isHidden = true
                cell.lblGst.isHidden = true
                
                cell.selectionStyle=UITableViewCellSelectionStyle.default
                //shadowForCell(view: cell.m_backGroundView)
                //cell.m_relationTitleView.layer.cornerRadius=8
                //        shadowForCell(view: cell.m_relationTitleView)
                cell.m_backGroundView.layer.cornerRadius = cornerRadiusForView//8.0
                m_windowPeriodStatus = true
                if(m_windowPeriodStatus)
                {
                    if let nTimesEnrollmentCanBeConfirmed = m_enrollmentMiscInformationDict.value(forKey: "NTimesEnrollmentCanBeConfirmed")as? String
                    {
                        if(nTimesEnrollmentCanBeConfirmed == "MULTIPLE")
                        {
                            showEditButtons(cell:cell)
                        }
                        else
                        {
                            if(m_isEnrollmentConfirmed)
                            {
                                // hideEditButtons(cell:cell)
                            }
                            else
                            {
                                showEditButtons(cell:cell)
                            }
                            /*if let noOfTimesEnrollmentActuallyConfirmed = m_enrollmentMiscInformationDict.value(forKey: "NoOfTimesEnrollmentActuallyConfirmed")as? String
                             {
                             if(noOfTimesEnrollmentActuallyConfirmed=="ONE")
                             {
                             hideEditButtons(cell:cell)
                             }
                             else
                             {
                             showEditButtons(cell:cell)
                             }
                             }*/
                        }
                    }
                    
                    
                }
                else
                {
                    // hideEditButtons(cell:cell)
                    
                }
                
                cell.m_deleteButton.tag=indexPath.row
                cell.m_editButton.tag=indexPath.row
                cell.m_docButton.tag=indexPath.row
                cell.m_docButton1.tag=indexPath.row
                cell.m_deleteButton.addTarget(self, action: #selector(deleteButtonClicked(_:)), for: .touchUpInside)
                cell.m_editButton.addTarget(self, action: #selector(editButtonClicked(_:)), for: .touchUpInside)
                cell.m_docButton.addTarget(self, action: #selector(attachButtonClicked(_:)), for: .touchUpInside)
                cell.m_docButton1.addTarget(self, action: #selector(attachButtonClicked(_:)), for: .touchUpInside)
                
                cell.m_deleteButton.isHidden = true
                cell.m_editButton.isHidden = false
                cell.lblDelete.isHidden = true
                
                //Added by Pranit
                //cell.btnInfo.tag = indexPath.row
                //cell.btnInfo.addTarget(self, action: #selector(infoButtonClicked(sender:)), for: .touchUpInside)
                
                
                cell.m_nameTextField.tag=indexPath.row
                cell.m_dobTextField.tag=indexPath.row
                cell.m_ageTextField.tag=indexPath.row
                //        cell.m_dateOfMarrigeTxtField.tag=indexPath.row
                
                
                let dict = structDataSource[indexPath.row]
                
                if dict.relation?.lowercased() == "twins" || dict.isTwins?.uppercased() == "YES" {
                    if dict.gender?.lowercased() == "male" {
                        cell.m_titleLbl.text = "Son"
                    }
                    else {
                        cell.m_titleLbl.text = "Daughter"
                    }
                    cell.imgTwins.isHidden = false
                }
                else {
                    cell.imgTwins.isHidden = true
                    cell.m_titleLbl.text = dict.relation?.capitalizingFirstLetter()

                }
                
                
                if structDataSource[indexPath.row].isDisabled == true{
                    if dict.relation?.lowercased() == "twins" || dict.isTwins?.uppercased() == "YES" {
                        cell.imgDisabled.isHidden = false
                        cell.imgDisabled1.isHidden = true
                    }else{
                        cell.imgDisabled.isHidden = true
                        cell.imgDisabled1.isHidden = false
                    }
                }else{
                    cell.imgDisabled.isHidden = true
                    cell.imgDisabled1.isHidden = true
                }

                if structDataSource[indexPath.row].selectedFilename != ""{
                    if dict.relation?.lowercased() == "twins" || dict.isTwins?.uppercased() == "YES" {
                        cell.m_docButton.isHidden = false
                        cell.m_docButton1.isHidden = true
                    }else{
                        cell.m_docButton.isHidden = true
                        cell.m_docButton1.isHidden = false
                    }
                }else{
                    cell.m_docButton.isHidden = true
                    cell.m_docButton1.isHidden = true
                }
                
                
                
                
                cell.lblAmount.text = "₹ \(structDataSource[indexPath.row].premiumAmount ?? "")"
                if structDataSource[indexPath.row].isPremiumShow == true {
                    cell.lblAmount.isHidden = false
                }else{
                    cell.lblAmount.isHidden = true
                }
                
                // if structDataSource.count > indexPath.row {
                cell.m_nameTextField.text = structDataSource[indexPath.row].personName
                // }
                // else {
                //    cell.m_nameTextField.text = "FAILED"
                
                //  }
                
                //cell.m_dobTextField.text=dict.dateofBirth
                let dateStr = dict.dateofBirth?.getStrDateEnrollment()
                if dateStr != "" {
                    cell.m_dobTextField.text = dateStr
                }
                else {
                    cell.m_dobTextField.text = dict.dateofBirth
                }
                
                var dictAge = Int(dict.age!)
                
                //if dict.age ?? 2 > 1 {
                if dictAge ?? 2 > 1 {
                    cell.m_ageTextField.text = String(format: "%@ years", String(dictAge ?? 0))
                }
                else {
                    cell.m_ageTextField.text = String(format: "%@ year", String(dictAge ?? 0))
                }
                
                cell.imgView.image = getRelationWiseImage(relation: dict.relation?.lowercased() ?? "", m_gender: dict.gender?.lowercased() ?? "")
                
                
                //cell.m_premiumStatementLbl.isHidden=true
                //cell.m_premiumStatementLbl.text=""
                
                //Added by Pranit to hide 01-Jan-1900
                if dict.dateofBirth == "01-Jan-1900" {
                    cell.m_dobTextField.text = "-"
                }
                
                //Added By Pranit To disable delete button if user opted claim
                
                
                //Add Swipe Gesture
              
                let leftRecognizer = UISwipeGestureRecognizer(target: self, action:
                    #selector(swipeMade(_:)))
                leftRecognizer.direction = .left
                let rightRecognizer = UISwipeGestureRecognizer(target: self, action:
                    #selector(swipeMade(_:)))
                rightRecognizer.direction = .right
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
                
                cell.m_backGroundView.addGestureRecognizer(tapRecognizer)
                
                cell.m_backGroundView.tag = indexPath.row
                
                if dict.canDelete == true {
                cell.m_backGroundView.addGestureRecognizer(leftRecognizer)
                cell.m_backGroundView.addGestureRecognizer(rightRecognizer)
                }
                else {
                    cell.m_backGroundView.gestureRecognizers = nil
                }
                
                if dict.canUpdate == true {
                    cell.m_editButton.isHidden = false
                    cell.btnInfo.isHidden = true
                }
                else {
                    cell.m_editButton.isHidden = true
                    cell.btnInfo.isHidden = false
                }
                cell.btnInfo.tag=indexPath.row
                cell.btnInfo.addTarget(self, action: #selector(infoButtonClicked(_:)), for: .touchUpInside)

                
                hideDeleteView(cell: cell)
                
                return cell
                
                
            }//obj.isEmpty check
            else { //display empty state
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForNewDependants", for: indexPath) as! CellForNewDependants
                //cell.btnNext.tag = indexPath.row
                //cell.btnNext.addTarget(self, action: #selector(moveToNext(_:)), for: .touchUpInside)
                
                //cell.lblAmount.isHidden = true
                cell.lblGst.isHidden = true
                
                if let IsWindowPeriodOpen = UserDefaults.standard.value(forKey: "IsWindowPeriodOpen") as? String  {
                    
                    if let IsEnrollmentSaved = UserDefaults.standard.value(forKey: "IsEnrollmentSaved") as? String  {
                       // if IsWindowPeriodOpen == "1" && IsEnrollmentSaved == "0" {
                        if IsWindowPeriodOpen == "0" && IsEnrollmentSaved == "0" {
                            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                            cell.dashBackView.addGestureRecognizer(tapGesture)
                        }
                        else {
                        }
                    }
                    else {
                    }
                }
                else {}
                cell.lblName.text = structDataSource[indexPath.row].relation?.capitalizingFirstLetter()
                print("Data at: ",structDataSource[indexPath.row])
                return cell
                
            }
            
            
        }
    }
    

    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        //let titleLabel = UILabel(frame: CGRect(x:10,y: 5 ,width:350,height:150))
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did Select..")
        //hide delete view or animate
//        guard let cell = tableView.cellForRow(at: indexPath) as? CellForExistingDependants else {
//            return
//        }
//
//        hideDeleteView(cell: cell)
    }
    
    @objc private func infoButtonClicked(_ sender : UIButton) {
        //self.showAlert(message: structDataSource[sender.tag].ReasonForNotAbleToUpdate ?? "")
        self.showAlertDetails(message: structDataSource[sender.tag].reasonForNotAbleToUpdate ?? "", title1: "")
    }

    
    //MARK:- Delete Tapped...
    @objc func deleteButtonClicked(_ sender: UIButton) {
        print("Delete Dependant...\(sender.tag)")
        
        if structDataSource[sender.tag].twinpairNo != "0" {
            let indexPath = IndexPath(row: sender.tag, section: 1)
            //self.deleteDependant(indexPath: indexPath,msg:"Would you like to remove both dependant?", perSrNo: "")
            
            var srNo = String()
            if let perSrNo = structDataSource[sender.tag].personSrNo {
                srNo = String(perSrNo)
                self.deleteDependant(indexPath: indexPath,msg:"Would you like to remove both dependant?", perSrNo: srNo)
            }else{
                self.deleteDependant(indexPath: indexPath,msg:"Would you like to remove both dependant?", perSrNo: "")
            }
            
            
        }
        else {
            let indexPath = IndexPath(row: sender.tag, section: 1)
            //self.deleteDependant(indexPath: indexPath,msg:"Would you like to remove this dependant?", perSrNo: "")
            
            var srNo = String()
            if let perSrNo = structDataSource[sender.tag].personSrNo {
                srNo = String(perSrNo)
                self.deleteDependant(indexPath: indexPath,msg:"Would you like to remove this dependant?", perSrNo: srNo)
            }else{
                self.deleteDependant(indexPath: indexPath,msg:"Would you like to remove this dependant?", perSrNo: "")
            }
        }
        
    }
    
    //MARK:- Actionsheet Delete
    private func deleteDependant(indexPath:IndexPath,msg:String,perSrNo:String) {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                var m_employeedict : EMPLOYEE_INFORMATION?

                m_employeedict=userArray[0]
                var oe_group_base_Info_Sr_No = String()
                var groupChildSrNo = String()
                var empSrNo = String()
                
                if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
                {
                    oe_group_base_Info_Sr_No = String(empNo)
                }
                if let groupChlNo = m_employeedict?.groupChildSrNo
                {
                    groupChildSrNo=String(groupChlNo)
                }
                if let empSr = m_employeedict?.empSrNo
                {
                    empSrNo = String(empSr)
                }
            
                if self.structDataSource[indexPath.row].twinpairNo == "0" {
                    let url = APIEngine.shared.deleteDependantJsonURL(GroupChildSrNo: groupChildSrNo, EmpSrNo: empSrNo, PersonSrNo: self.structDataSource[indexPath.row].personSrNo?.description ?? "")
                    self.deleteDependantToServer(url: url, personSrNo: perSrNo)
                }
                else {
                    
                    let twinArray = self.structDataSource.filter({$0.twinpairNo == self.structDataSource[indexPath.row].twinpairNo && $0.canDelete == true})
                    
                    if twinArray.count == 2 {
                        let url1 = APIEngine.shared.deleteDependantJsonURL(GroupChildSrNo: groupChildSrNo, EmpSrNo: empSrNo, PersonSrNo: twinArray[0].personSrNo?.description ?? "")
                        
                        let url2 = APIEngine.shared.deleteDependantJsonURL(GroupChildSrNo: groupChildSrNo, EmpSrNo: empSrNo, PersonSrNo: twinArray[1].personSrNo?.description ?? "")
                        
                        self.deleteCh1DependantToServer(url1: url1, url2: url2, personSrNo1: perSrNo, personSrNo2: twinArray[1].personSrNo?.description ?? "")
                        
                    }
                    
                }
            }
            /*
            if self.structDataSource[indexPath.row].relationname?.lowercased() == "wife" || self.structDataSource[indexPath.row].relationname?.lowercased() == "husband"
            {
                self.structDataSource[indexPath.row].isEmpty = true

                self.EmptyObj.isEmpty = true
                self.EmptyObj.relationname = "PARTNER"
               // self.structDataSource.append(self.EmptyObj)
                self.EmptyObj.sortId = 2
                 self.structDataSource.append(self.EmptyObj)

                //self.structDataSource.insert(self.EmptyObj, at: 1)
                self.structDataSource = self.structDataSource.sorted(by: { $0.sortId < $1.sortId })

                self.tableView.reloadData()
                
                
            }
            else if self.structDataSource[indexPath.row].relationname?.lowercased() == "partner" {
                //if user delete partner then add empty cell of partner and spouse
                self.structDataSource[indexPath.row].isEmpty = true

                //Add Spouse
                self.EmptyObj.isEmpty = true
                self.EmptyObj.relationname = m_spouse
                self.EmptyObj.relationID = Int(self.getRelationId(relation: self.EmptyObj.relationname!))
                self.EmptyObj.sortId = 1
                self.structDataSource.append(self.EmptyObj)
                self.structDataSource = self.structDataSource.sorted(by: { $0.sortId < $1.sortId })

                self.tableView.reloadData()

            }
            else {

                //Twins Delete
                if self.structDataSource[indexPath.row].sortId == 5 {
                    print("Twins Deleted")
                    self.structDataSource[indexPath.row].isEmpty = true
                    let pairNo = self.structDataSource[indexPath.row].twinPair
                    self.structDataSource = self.structDataSource.filter({$0.twinPair != pairNo})

                    //Add COMMON
                    self.addedChildCount -= 1 //minus count
                    if self.addedChildCount < 2 {
                    //Add Twins Empty Card
                        let array = self.structDataSource.filter({$0.sortId == 5 && $0.isEmpty == true})
                        
                        if array.count == 0 {
                        self.EmptyObj.isEmpty = true
                        self.EmptyObj.relationname = "Twins"
                        self.EmptyObj.sortId = 5
                        self.structDataSource.append(self.EmptyObj)
                        }
                        
                      //Add Son Empty Card
                        let sonArray = self.structDataSource.filter({$0.sortId == 3 && $0.isEmpty == true})
                        
                        if sonArray.count == 0 {
                        self.EmptyObj.isEmpty = true
                        self.EmptyObj.relationname = "SON"
                        self.EmptyObj.sortId = 3
                            self.EmptyObj.relationID = Int(self.getRelationId(relation: "SON"))
                        self.structDataSource.append(self.EmptyObj)
                        }
                        
                        
                     //Add Daughter Empty Card
                        let daughterArray = self.structDataSource.filter({$0.sortId == 4 && $0.isEmpty == true})
                        
                        if daughterArray.count == 0 {
                        self.EmptyObj.isEmpty = true
                        self.EmptyObj.relationname = "DAUGHTER"
                        self.EmptyObj.sortId = 4
                        self.EmptyObj.relationID = Int(self.getRelationId(relation: "DAUGHTER"))
                        self.structDataSource.append(self.EmptyObj)
                        }
                       
                        }
                    //ADD COMMON
                  //  self.tableView.reloadData()
                }
                //Child Delete
                else { //Son, Daughter deleted
                    
                print("Son/Daughter Deleted")

                    //To avoid multiple empty cards for single relation. If Empty card of son is already present then delete entry from datasource.
                    let relName = self.structDataSource[indexPath.row].relationname?.lowercased()
                    let tempArray = self.structDataSource.filter({$0.relationname?.lowercased() == relName  && $0.isEmpty == true})
                    if tempArray.count > 0 {
                        self.structDataSource.remove(at: indexPath.row)
                    }
                    else {
                        self.structDataSource[indexPath.row].isEmpty = true
                    }
                    


                self.addedChildCount -= 1 //minus count
                if self.addedChildCount < 2 {
                //Add Twins Empty Card
                    let array = self.structDataSource.filter({$0.sortId == 5 && $0.isEmpty == true})
                    
                    if array.count == 0 {
                    self.EmptyObj.isEmpty = true
                    self.EmptyObj.relationname = "Twins"
                    self.EmptyObj.sortId = 5
                        
                    self.structDataSource.append(self.EmptyObj)
                    }
                    
                  //Add Son Empty Card
                    let sonArray = self.structDataSource.filter({$0.sortId == 3 && $0.isEmpty == true})
                    
                    if sonArray.count == 0 {
                    self.EmptyObj.isEmpty = true
                    self.EmptyObj.relationname = "SON"
                    self.EmptyObj.sortId = 3
                    self.EmptyObj.relationID = Int(self.getRelationId(relation: "SON"))
                    self.structDataSource.append(self.EmptyObj)
                    }
                    
                    
                 //Add Daughter Empty Card
                    let daughterArray = self.structDataSource.filter({$0.sortId == 4 && $0.isEmpty == true})
                    
                    if daughterArray.count == 0 {
                    self.EmptyObj.isEmpty = true
                    self.EmptyObj.relationname = "DAUGHTER"
                    self.EmptyObj.sortId = 4
                    self.EmptyObj.relationID = Int(self.getRelationId(relation: "DAUGHTER"))
                    self.structDataSource.append(self.EmptyObj)
                    }
                   
                    }
                    else {
                            //Already 2 child added
                    print("TWO CHILD FOUND>>>REMOVE ALL EMPTY CARDS___")
                    }
                    
                } //Son/Daughter Deleted
                
                self.refreshSortedTableView()
 //           self.tableView.reloadRows(at: [indexPath], with: .left)
            }
            
            */
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    private func addEmptyChilders() {
        
    }
    
    func getRelationId(relation:String) -> String {
        let relarray:Array<EnrollmentGroupRelations> = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: relation.uppercased())
        var relationIdStr = "0"
        if relarray.count == 1 {
            relationIdStr = relarray[0].relationID!
        }
        
        return relationIdStr
    }
    
    
    //MARK:- EDIT & Attach
    
    @objc func attachButtonClicked(_ sender: UIButton) {
//        if let url = URL(string: structDataSource[sender.tag].selectedFilename) {
//           if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url, options: [:], completionHandler: {
//                    (success) in
//                    print("Open  \(success)")
//                })
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
        

           let vc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "DisabledAttachmentVC") as! DisabledAttachmentVC
           vc.modalTransitionStyle = .crossDissolve
           vc.modalPresentationStyle = .custom
           vc.attachmentUrl = structDataSource[sender.tag].selectedFilename
           self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func editButtonClicked(_ sender: UIButton) {
        //Delete Functionality
        print("Edit Dependant...\(sender.tag)")
        
        
        if structDataSource[sender.tag].relation?.lowercased() != "husband" && structDataSource[sender.tag].relation?.lowercased() != "wife" && structDataSource[sender.tag].relation?.lowercased() != "partner" {

            if structDataSource[sender.tag].isTwins?.lowercased() == "yes" {
                
                
                let addDependant  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"AddTwinsVC1") as! AddDisabledTwinsVC
                addDependant.newTwinsDelegate = self
                addDependant.modalPresentationStyle = .custom
                addDependant.isEdit = true
                addDependant.position = sender.tag
                let twinPairID = structDataSource[sender.tag].twinpairNo
                addDependant.pairNumber = Int(twinPairID!)!
                
                addDependant.childCountIn = m_ChildCount
                addDependant.premiunAmount = m_ExtraAmount
                

                let array = self.structDataSource.filter({$0.isAdded == false && $0.twinpairNo == twinPairID})
                if array.count == 2 {
                    addDependant.selectedObjFirst = array[0]
                    addDependant.selectedObjSecond = array[1]
                }
                
                addDependant.m_membersNameArrayST = m_membersNameArray
                if m_membersNameArray.count > 0  {
                    if addDependant.m_membersNameArrayST.contains(array[0].personName!) {
                        if let itemToRemoveIndex = addDependant.m_membersNameArrayST.index(of: array[0].personName!) {
                            addDependant.m_membersNameArrayST.remove(at: itemToRemoveIndex)
                        }
                    }
                    if addDependant.m_membersNameArrayST.contains(array[1].personName!) {
                        if let itemToRemoveIndex = addDependant.m_membersNameArrayST.index(of: array[1].personName!) {
                            addDependant.m_membersNameArrayST.remove(at: itemToRemoveIndex)
                        }
                    }
                    //addDependant.m_membersNameArrayST.remove(at: sender.tag)
                }
                
//                while array.contains(itemToRemove) {
//                    if let itemToRemoveIndex = array.index(of: itemToRemove) {
//                        array.remove(at: itemToRemoveIndex)
//                    }
//                }
                
                //addDependant.relationStr = structDataSource[sender.tag].relationname ?? ""
                self.navigationController?.present(addDependant, animated: true, completion: nil)

            }
            else {
                let addDependant  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"AddNewDependantVC1") as! AddNewDisabledDependantVC
                addDependant.newDependantDelegate = self
                addDependant.modalPresentationStyle = .custom
                addDependant.isEdit = true
                addDependant.position = sender.tag
                
                addDependant.m_membersNameArraySD = m_membersNameArray
//                if m_membersNameArray.count > 0  {
//                    addDependant.m_membersNameArraySD.remove(at: sender.tag)
//                }
                
                if m_membersNameArray.count > 0  {
                    if addDependant.m_membersNameArraySD.contains(structDataSource[sender.tag].personName!){
                       if let index = addDependant.m_membersNameArraySD.index(of: structDataSource[sender.tag].personName!){
                           addDependant.m_membersNameArraySD.remove(at: index)
                       }
                   }
               }
                
                addDependant.childCountIn = m_ChildCount
                addDependant.premiunAmount = m_ExtraAmount
                addDependant.selectedObj = structDataSource[sender.tag]
                
                if differentDataSource.count > 0{
                    if let mainPerSrNo = structDataSource[sender.tag].personSrNo {
                        for i in 0..<differentDataSource.count {
                            let dict = differentDataSource[i]
                            if let new = dict.personSrNo{
                               // if mainPerSrNo == Int(new) {
                                if mainPerSrNo == new {
                                    addDependant.selectedObjnew = differentDataSource[i]
                                    break
                                }
                            }
                        }
                    }
                }
                
                addDependant.sortId = structDataSource[sender.tag].srNo
                addDependant.relationStr = structDataSource[sender.tag].relation ?? ""
                
                self.navigationController?.present(addDependant, animated: true, completion: nil)

            }
            
        }else {
            
        
                if structDataSource[sender.tag].isTwins?.lowercased() == "yes" {
                    let addDependant  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"AddTwinsVC") as! AddTwinsVC
                    addDependant.newTwinsDelegate = self
                    addDependant.modalPresentationStyle = .custom
                    addDependant.isEdit = true
                    addDependant.position = sender.tag
                    
                    let twinPairID = structDataSource[sender.tag].twinpairNo
                    addDependant.pairNumber = Int(twinPairID!)!
                    
//                    addDependant.m_membersNameArrayST = m_membersNameArray
//                    if m_membersNameArray.count > 0  {
//                        addDependant.m_membersNameArrayST.remove(at: sender.tag)
//                    }
                    
                    addDependant.childCountIn = m_ChildCount
                    addDependant.premiunAmount = m_ExtraAmount
                    let array = self.structDataSource.filter({$0.isAdded == false && $0.twinpairNo == twinPairID})
                    if array.count == 2 {
                        addDependant.selectedObjFirst = array[0]
                        addDependant.selectedObjSecond = array[1]
                    }
                    
                    addDependant.m_membersNameArrayST = m_membersNameArray
                    if m_membersNameArray.count > 0  {
                        if addDependant.m_membersNameArrayST.contains(array[0].personName!) {
                            if let itemToRemoveIndex = addDependant.m_membersNameArrayST.index(of: array[0].personName!) {
                                addDependant.m_membersNameArrayST.remove(at: itemToRemoveIndex)
                            }
                        }
                        if addDependant.m_membersNameArrayST.contains(array[1].personName!) {
                            if let itemToRemoveIndex = addDependant.m_membersNameArrayST.index(of: array[1].personName!) {
                                addDependant.m_membersNameArrayST.remove(at: itemToRemoveIndex)
                            }
                        }
                        //addDependant.m_membersNameArrayST.remove(at: sender.tag)
                    }
                    
                    
                    //addDependant.relationStr = structDataSource[sender.tag].relationname ?? ""
                    self.navigationController?.present(addDependant, animated: true, completion: nil)

                }
                else {
                    let addDependant  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"AddNewDependantVC") as! AddNewDependantVC
                    addDependant.newDependantDelegate = self
                    addDependant.modalPresentationStyle = .custom
                    addDependant.isEdit = true
                    //let tapLocation = sender.location(in: self.tableView)
                    //let indexPath:IndexPath = self.tableView.indexPathForRow(at: tapLocation) as! IndexPath
                    addDependant.position = sender.tag
                    
                    addDependant.m_membersNameArraySD = m_membersNameArray
//                    if m_membersNameArray.count > 0  {
//                        addDependant.m_membersNameArraySD.remove(at: sender.tag)
//                    }
                    
                    if m_membersNameArray.count > 0  {
                         if addDependant.m_membersNameArraySD.contains(structDataSource[sender.tag].personName!){
                            if let index = addDependant.m_membersNameArraySD.index(of: structDataSource[sender.tag].personName!){
                                addDependant.m_membersNameArraySD.remove(at: index)
                            }
                        }
                    }
                    
                    addDependant.childCountIn = m_ChildCount
                    addDependant.premiunAmount = m_ExtraAmount
                    addDependant.selectedObj = structDataSource[sender.tag]
                    addDependant.sortId = structDataSource[sender.tag].srNo
                    addDependant.relationStr = structDataSource[sender.tag].relation ?? ""
                    
                    self.navigationController?.present(addDependant, animated: true, completion: nil)

                }
        
        }
        
    }
    
    //MARK:- Animate Cell
    func animateCell(cell:CellForExistingDependants,index:Int) {
        
        let viewTemp = cell.m_backGroundView
        UIView.transition(with: viewTemp!,
                          duration: 0.5,
                          options: [.transitionFlipFromRight],
                          animations: {
                            
                            viewTemp?.isHidden =  true
        },
                          completion: { _ in
                            
                            //self.view.bringSubview(toFront: bottomCard!)
                            viewTemp?.isHidden = false
        })
        
        let index = IndexPath(row: index , section: 1)
        tableView.reloadRows(at: [index], with: .left)
    }
    
    //MARK:- Gesture Control - Add
    @objc func handleTap(_ sender: UISwipeGestureRecognizer) {
        
        let tapLocation = sender.location(in: self.tableView)
        let indexPath:IndexPath = self.tableView.indexPathForRow(at: tapLocation) as! IndexPath

        
        if structDataSource[indexPath.row].relation?.lowercased() != "husband" && structDataSource[indexPath.row].relation?.lowercased() != "wife" && structDataSource[indexPath.row].relation?.lowercased() != "partner" {
            
            
            if structDataSource[indexPath.row].relation?.lowercased() == "twins" {
                let addDependant  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"AddTwinsVC1") as! AddDisabledTwinsVC
                addDependant.newTwinsDelegate = self
                addDependant.modalPresentationStyle = .custom
                addDependant.m_membersNameArrayST = m_membersNameArray
                addDependant.childCountIn = m_ChildCount
                addDependant.premiunAmount = m_ExtraAmount
                addDependant.position = indexPath.row
                addDependant.relationStr = structDataSource[indexPath.row].relation ?? ""

                let array = self.structDataSource.filter({$0.srNo == 5 && $0.isAdded == false})
                if array.count == 0 {
                    addDependant.pairNumber = 1
                }
                else {
                    if array[0].twinPair == 1 {
                        addDependant.pairNumber = 2
                    }
                    else {
                        addDependant.pairNumber = 1
                    }
                }

                self.navigationController?.present(addDependant, animated: true, completion: nil)
            }
            else {
                
                    guard let IsWindowPeriodOpen = UserDefaults.standard.value(forKey: "IsWindowPeriodOpen") as? String else {
                        return
                    }
                    
                    //if IsWindowPeriodOpen == "1" {
                    if IsWindowPeriodOpen == "0" {
                    let addDependant  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"AddNewDependantVC1") as! AddNewDisabledDependantVC
                    addDependant.newDependantDelegate = self
                    addDependant.modalPresentationStyle = .custom
                    addDependant.sortId = structDataSource[indexPath.row].srNo
                    addDependant.position = indexPath.row
                    addDependant.m_membersNameArraySD = m_membersNameArray
                    addDependant.childCountIn = m_ChildCount
                    addDependant.premiunAmount = m_ExtraAmount
                    addDependant.selectedObj = structDataSource[indexPath.row]
                    addDependant.relationStr = structDataSource[indexPath.row].relation ?? ""
                    self.navigationController?.present(addDependant, animated: true, completion: nil)
                    }
                    else {
                     print("Window Period Closed...")
                    }
            }
            
        }else{
            
            if structDataSource[indexPath.row].relation?.lowercased() == "twins" {
                let addDependant  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"AddTwinsVC") as! AddTwinsVC
                addDependant.newTwinsDelegate = self
                addDependant.modalPresentationStyle = .custom
                addDependant.m_membersNameArrayST = m_membersNameArray
                addDependant.childCountIn = m_ChildCount
                addDependant.premiunAmount = m_ExtraAmount
                addDependant.position = indexPath.row
                addDependant.relationStr = structDataSource[indexPath.row].relation ?? ""
                
                let array = self.structDataSource.filter({$0.srNo == 5 && $0.isAdded == false})
                if array.count == 0 {
                    addDependant.pairNumber = 1
                }
                else {
                    if array[0].twinPair == 1 {
                        addDependant.pairNumber = 2
                    }
                    else {
                        addDependant.pairNumber = 1
                    }
                }
                
                self.navigationController?.present(addDependant, animated: true, completion: nil)
            }
            else {
                
                    guard let IsWindowPeriodOpen = UserDefaults.standard.value(forKey: "IsWindowPeriodOpen") as? String else {
                        return
                    }
                    
                   // if IsWindowPeriodOpen == "1" {
                if IsWindowPeriodOpen == "0" {
                    let addDependant  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"AddNewDependantVC") as! AddNewDependantVC
                    addDependant.newDependantDelegate = self
                    addDependant.modalPresentationStyle = .custom
                    addDependant.sortId = structDataSource[indexPath.row].srNo
                    addDependant.position = indexPath.row
                    addDependant.m_membersNameArraySD = m_membersNameArray
                    addDependant.childCountIn = m_ChildCount
                    addDependant.premiunAmount = m_ExtraAmount
                    addDependant.selectedObj = structDataSource[indexPath.row]
                    addDependant.relationStr = structDataSource[indexPath.row].relation ?? ""
                    self.navigationController?.present(addDependant, animated: true, completion: nil)
                    }
                    else {
                     print("Window Period Closed...")
                    }
            }
        }
    }
    
    
    //Move To TopUp
    @objc private func moveToNext(_ sender : UIButton) {
        //Parental Premium
        let coreBenefitsVc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "ParentalPremiumVC") as! ParentalPremiumVC
        coreBenefitsVc.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
        coreBenefitsVc.m_windowPeriodEndDate=m_windowPeriodEndDate
        navigationController?.pushViewController(coreBenefitsVc, animated: true)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        else {
            // let totalRows = tableView.numberOfRows(inSection: indexPath.section)
            // if indexPath.row != totalRows - 1 {
            let dict = structDataSource[indexPath.row]
            
            if dict.isAdded == true {
                return 130
                
            }
            else {
                return UITableViewAutomaticDimension
                
            }
        }
    }
    //                if(m_windowPeriodStatus)
    //                {
    //
    //                    if(m_isEnrollmentConfirmed)
    //                    {
    //                        return 200 //hide
    //                    }
    //                    else
    //                    {
    //                        return 200
    //                    }
    //                }
    //                return 200 //hide
    //            }
    //
    //        }
    //
    //    }
    //
    //    else { //Add New depen cell
    //    return 180
    //    }
    //    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    //        UIView.animate(withDuration: 0.4) {
    //            cell.transform = CGAffineTransform.identity
    //        }
    //    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //           cell.alpha = 0
    //           cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
    //           UIView.animate(withDuration: 0.4) {
    //               cell.alpha = 1
    //               cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
    //           }
    //       }
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    func animateTable() {
        
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        
        let tableHeight: CGFloat = tableView.bounds.size.height
        
     
        var index = 0
               
        for a in cells {
            
            if a.isKind(of: CellForInstructionHeaderCell.self) {
                // let cell: CellForInstructionHeaderCell = a as! CellForInstructionHeaderCell
                
                //                       UIView.animate(withDuration: 2, delay: 0.4 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                //
                //                           cell.transform = CGAffineTransform(translationX: 0, y: 0)
                //
                //                           }, completion: nil)
                
                
                
                index += 1
            }
                
                
            else  if a.isKind(of: CellForExistingDependants.self) {
                let cell: CellForExistingDependants = a as! CellForExistingDependants
                
                UIView.animate(withDuration: 2, delay: 0.4 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    
                }, completion: nil)
                
                
                
                index += 1
            }
            else if a.isKind(of: CellForNewDependants.self) {
                let cell: CellForNewDependants = a as! CellForNewDependants
                
                UIView.animate(withDuration: 2, delay: 0.4 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    
                }, completion: nil)
                
                
                
                index += 1
            }
                
            else {
                //CellForParentalPremium
                
            }
            
        }//for
        
    }
}


//MARK:- Download Documents
//
//func openDocuments(url:String)
//{
//
//    //showPleaseWait(msg: "Please wait...")
//
//    let stringUrl = url.replacingOccurrences(of: "\\", with: "/")
//
//
//        let urlStr : String = stringUrl as String
//
//        if let searchURL : NSURL = NSURL(string: urlStr)
//        {
//            let request = URLRequest(url: searchURL as URL)
//            let session = URLSession(configuration: URLSessionConfiguration.default)
//
//            let task = session.dataTask(with: request, completionHandler:
//            {(data, response, error) -> Void in
//
//                do
//                {
//
//                    let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
//
//                    if let fileName = searchURL.lastPathComponent
//                    {
//
//                        let destinationUrl = documentsUrl.appendingPathComponent(fileName)
//                        let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
//                        if data != nil
//                        {
//
//                            if(destinationUrl != nil)
//                            {
//                                try self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
//
//                            }
//
//                        }
//                        else
//                        {
//                            //self.hidePleaseWait()
//                            self.isConnectedToNetWithAlert()
//                        }
//                    }
//                }
//                catch
//                {
//                    Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
//                    print(error)
//                    //self.hidePleaseWait()
//                }
//
//                //self.hidePleaseWait()
//            })
//            task.resume()
//
//        }
//        else
//        {
//            //self.hidePleaseWait()
//            displayActivityAlert(title: m_errorMsg)
//
//        }
//
//
//}
//
//
//func openSelectedDocumentFromURL(documentURLString: String) throws {
//    DispatchQueue.main.async()
//        {
//            //code
//
//            if let documentURL: NSURL = NSURL(fileURLWithPath: documentURLString)
//            {
//                UINavigationBar.appearance().barTintColor = self.hexStringToUIColor(hex: hightlightColor)
//                UINavigationBar.appearance().tintColor = self.hexStringToUIColor(hex: hightlightColor)
//                UINavigationBar.appearance().backgroundColor = self.hexStringToUIColor(hex: hightlightColor)
//                documentController.delegate = self
//
//                documentController = UIDocumentInteractionController(url: documentURL as URL)
//                documentController.delegate = self
//                documentController.presentPreview(animated: true)
//                self.hidePleaseWait()
//            }
//
//    }
//
//}


extension DependantsListVC:UIScrollViewDelegate {
    // we set a variable to hold the contentOffSet before scroll view scrolls
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            if self.hideCollectionViewDelegate != nil {
                hideCollectionViewDelegate?.scrolled(index: 1)
            }
            
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            if self.hideCollectionViewDelegate != nil {
                hideCollectionViewDelegate?.show(index: 1)
            }
        } else {
            // didn't move
            if self.hideCollectionViewDelegate != nil {
                hideCollectionViewDelegate?.show(index: 1)
            }
            
        }
    }
    
  
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           scrollingFinished(scrollView: scrollView)
       }

       func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
           if decelerate {
               //didEndDecelerating will be called for sure
               return
           }
           else {
               scrollingFinished(scrollView: scrollView)
           }
       }

       func scrollingFinished(scrollView: UIScrollView) {
          // Your code
           if self.hideCollectionViewDelegate != nil {
               hideCollectionViewDelegate?.show(index: 1)
           }
       }
}



//DELETE WORKING OLD EXTENSION SWIPE TO DELETE
/*
extension DependantsListVC { //Swipe To Delete
 
     //SWIPE To DELETE
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     if indexPath.section != 0 {
     if structDataSource.count > indexPath.row {
     if structDataSource[indexPath.row].isEmpty == false {
     return true
     }
     return false
     }
     return false
     }
     return false
     
     }
     
//     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//     if (editingStyle == .delete) {
//
//     self.structDataSource.remove(at: indexPath.row)
//     //self.tableView.reloadData()
//     self.tableView.reloadSections([1], with: .fade)
//     // tableView.reloadRows(at: [indexPath], with: .fade)
//     }
//     }
     
     //MARK:- Delete Button Code
     //Delete Start
     
     @available(iOS 11.0, *)
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
     let action =  UIContextualAction(style: .normal, title: "Delete", handler: { (action,view,completionHandler ) in
     //do stuff
     completionHandler(true)
     print("Delete...")
     //            if let personSrNo = self.familyDetailsArray[indexPath.row].PersonSRNo {
     //                self.deleteFamilyMember(personSRNo: personSrNo, indexPath: indexPath)
     //            }
     self.deleteDependant(indexPath: indexPath)
     
     })
     
     action.image = UIImage(named: "deletew")
     action.backgroundColor = .red
        
     if self.structDataSource[indexPath.row].isEmpty == false {
     let confrigation = UISwipeActionsConfiguration(actions: [action])
     return confrigation
     }
     else {
     let confrigation = UISwipeActionsConfiguration(actions: [])
     return confrigation
     }
     
     
     
     }
     
     
     
     
     
     func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
         self.tableView.subviews.forEach { subview in
             print("YourTableViewController: \(String(describing: type(of: subview)))")
             
             if (String(describing: type(of: subview)) == "UISwipeActionPullView") {
                 if (String(describing: type(of: subview.subviews[0])) == "UISwipeActionStandardButton") {
                     var deleteBtnFrame = subview.subviews[0].frame
                     deleteBtnFrame.origin.y = 0
                     deleteBtnFrame.size.height = 110
                     // deleteBtnFrame.size.width = 200
                     
                     subview.subviews[0].backgroundColor = UIColor.red
                     
                     // Subview in this case is the whole edit View
                     subview.frame.origin.y =  subview.frame.origin.y + 0
                     subview.frame.size.height = 110
                     subview.subviews[0].frame = deleteBtnFrame
                     subview.backgroundColor = UIColor.red
                 }
             }
         }
     }
     
    //Delete End
 
}
*/
extension UIView {
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    fileprivate func whitespaceString(font: UIFont = UIFont.systemFont(ofSize: 15), width: CGFloat) -> String {
        let kPadding: CGFloat = 20
        let mutable = NSMutableString(string: "")
        let attribute = [NSAttributedStringKey.font: font]
        while mutable.size(withAttributes: attribute).width < width - (2 * kPadding) {
            mutable.append(" ")
        }
        return mutable as String
    }
    
}
/*
extension DependantsListVC {
  
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
     return .delete
     }
     
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     let kCellActionWidth = CGFloat(70.0)// The width you want of delete button
     let kCellHeight = tableView.frame.size.height // The height you want of delete button
     let whitespace = whitespaceString(width: kCellActionWidth) // add the padding
     
     
     let deleteAction = UITableViewRowAction(style: .`default`, title: whitespace) {_,_ in
     // do whatever the action you want
     }
     
     // create a color from patter image and set the color as a background color of action
     let view = UIView(frame: CGRect(x: 0, y: 6, width: tableView.frame.size.width, height: tableView.frame.size.height - 6))
     //view.backgroundColor = UIColor(red: 219.0/255.0, green: 71.0/255.0, blue: 95.0/255.0, alpha: 1.0) // background color of view
     view.backgroundColor = UIColor.lightText
     view.layer.cornerRadius = 10.0
     let imageView = UIImageView(frame: CGRect(x: 15,
     y: 20,
     width: 40,
     height: 40))
     imageView.image = UIImage(named: "Asset 48")! // required image
     view.addSubview(imageView)
     view.layer.cornerRadius = 10.0
     let image = view.image()
     
     deleteAction.backgroundColor = UIColor.init(patternImage: image)
     
     
     return [deleteAction]
     
     }
     
     fileprivate func whitespaceString(font: UIFont = UIFont.systemFont(ofSize: 15), width: CGFloat) -> String {
     let kPadding: CGFloat = 20
     let mutable = NSMutableString(string: "")
     let attribute = [NSAttributedStringKey.font: font]
     while mutable.size(withAttributes: attribute).width < width - (2 * kPadding) {
     mutable.append(" ")
     }
     return mutable as String
     }
    
    
}
*/

//On Cread Deletion

extension DependantsListVC {
    
    //SWIPE To DELETE
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section != 0 {
    if structDataSource.count > indexPath.row {
    if structDataSource[indexPath.row].isAdded == false {
    return true
    }
    return false
    }
    return false
    }
    return false
    
    }

    //MARK:- Hide Delete
    func hideDeleteView(cell:CellForExistingDependants) {
        let transitionNew = CGAffineTransform(translationX: 0, y: 0 )
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            
            cell.m_backGroundView.transform = transitionNew
            cell.m_deleteButton.isHidden = true
            cell.lblDelete.isHidden = true

        }, completion: {
            (value: Bool) in

        })
        
    }
    
    @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
        let index = IndexPath(row: sender.view!.tag, section: 1)
        
        guard let cell = tableView.cellForRow(at: index) as? CellForExistingDependants else {
            return
        }
        
        hideDeleteView(cell: cell)

    }
    
    //MARK:- Gesture Control - Add
    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
        print("Swipe made..")
        
        
        if sender.direction == .left {
            self.tableView.reloadData()

            let index = IndexPath(row: sender.view!.tag, section: 1)
            
            guard let cell = tableView.cellForRow(at: index) as? CellForExistingDependants else {
                return
            }
            
            //cell.m_backGroundView.backgroundColor = UIColor.red
            
            let transitionNew = CGAffineTransform(translationX: -100, y: 0 )
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                
                cell.m_backGroundView.transform = transitionNew
                
            }, completion: {
                (value: Bool) in
                cell.m_deleteButton.isHidden = false
                cell.lblDelete.isHidden = false
            })
        }
        else { //Reset
            let index = IndexPath(row: sender.view!.tag, section: 1)
            guard let cell = tableView.cellForRow(at: index) as? CellForExistingDependants else {
                return
            }
            
            //cell.m_backGroundView.backgroundColor = UIColor.red
            
            let transitionNew = CGAffineTransform(translationX: 0, y: 0 )
            cell.m_backGroundView.transform = transitionNew
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                //Reset view
                //let reset = CGAffineTransform(translationX: 0, y: 0)
                //self.imgBox.transform = reset
                
            }, completion: {
                (value: Bool) in
                cell.m_deleteButton.isHidden = true
                cell.lblDelete.isHidden = true
                
            })
        }
        
    }
    
}

extension DependantsListVC {
   /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            //TODO: edit the row at indexPath here
        }
        editAction.backgroundColor = .magenta
        

        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
        }
        deleteAction.backgroundColor = .red

        return [deleteAction,editAction]
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .delete
    }
   */
}
