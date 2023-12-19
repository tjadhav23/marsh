//
//  ParentalPremiumVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 23/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit





class ParentalPremiumVC: UIViewController,refreshAfterDismiss {
  
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var isEditIndex = -1
    
    var nameArray = ["Abcd","John Doe"]
    
    var allowedParents = ["father","mother"]
    
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    
    var lastContentOffset: CGFloat = 0 //ScrollViewDelegate
    var hideCollectionViewDelegate : HideCollectionViewProtocol? = nil
    
    var m_employeedict : EMPLOYEE_INFORMATION?

    var m_productCode = String()
    var addedPersonDetailsArray = Array<PERSON_INFORMATION>()
    var structDataSource = [ParentalRecords]()
    var tempDataSource = [ParentalRecords]()

    var indexNumber = Int()
    //var structObject = ParentalRecords()
    var structObject : ParentalRecords?
    
    var firstSectionArray = [ParentalRecords]()
    var secondSectionArray = [ParentalRecords]()

    var tempArray = [ParentalRecords]()
    var isHeaderLoaded = 0
    var refreshControl: UIRefreshControl!
    
    var m_parentsNameArray = Array<String>()
    var countDownTime = ""
    var endDate : Date?
    var alertController: UIAlertController?
    var timer1 : Timer?
    var isDisabled : Bool = false
    var animationsQueue = ChainedAnimationsQueue()
    
    var isLoaded = 0
    
    
    //New Api Call
    var parentalRelationStructJSONArray = [ParentalRelation]()
    var parentalRecordsStructJSONArray = [ParentalRecords]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ParentalRecords(premium: "", personSrNo: "", name: "", age: "", dateOfBirthToShow: "", dateOfBirth: "", relation: "", relationID: "", covered: false, canAdd: false, canUpdate: false, canDelete: false, canInclude: false, reason: "", coveredInPolicyType: 0, parentsBaseSumInsured: "", sortNo: "")
        print("#VDL - ParentalPremium")
        //self.view.setBackgroundGradientColor(index: 0)
        
        let startPoint = CGPoint(x:0.5, y:0.0)
        let endPoint = CGPoint(x:0.5, y:1.0)
        
        //self.view.setGradientBackgroundColor(colorTop: EnrollmentColor.gpaTop.value, colorBottom: EnrollmentColor.gpaBottom.value, startPoint: startPoint, endPoint: endPoint)
        
        setColorNew(view: self.view, colorTop: EnrollmentColor.parentalListTop.value, colorBottom: EnrollmentColor.parentalListBottom.value,gradientLayer:gradientLayer)

        
        navigationController?.isNavigationBarHidden=false
        self.navigationItem.leftBarButtonItem = getBackButtonHideTabBar()
        self.title = ""
        
        tableView.register(CellForInstructionHeaderCell.self, forCellReuseIdentifier: "CellForInstructionHeaderCell")
        tableView.register(UINib(nibName: "CellForInstructionHeaderCell", bundle: nil), forCellReuseIdentifier: "CellForInstructionHeaderCell")
        
        tableView.register(CellForExistingDependants.self, forCellReuseIdentifier: "CellForExistingDependants")
        tableView.register(UINib(nibName: "CellForExistingDependants", bundle: nil), forCellReuseIdentifier: "CellForExistingDependants")

        tableView.register(ParentalSectionHeaderCell.self, forCellReuseIdentifier: "ParentalSectionHeaderCell")
        tableView.register(UINib(nibName: "ParentalSectionHeaderCell", bundle: nil), forCellReuseIdentifier: "ParentalSectionHeaderCell")

        
        //Add New Dependants Cell
        tableView.register(CellForNewDependants.self, forCellReuseIdentifier: "CellForNewDependants")
        tableView.register(UINib(nibName: "CellForNewDependants", bundle: nil), forCellReuseIdentifier: "CellForNewDependants")
        
        let currentDate = getCurrentDate()
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        endDate = dateFormatter.date(from: GlobalendDate)
        
        if currentDate.compare(endDate!) == .orderedAscending {
        print("current date is small")
            isDisabled = false
            timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            //getFamilyMemberDetails()
        }else{
            print("current date is big")
            isDisabled = true
        }
        
        //getPersonDetails()
        
        
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: UIControlEvents.valueChanged)
            self.tableView.addSubview(refreshControl)

          
        }
    
        @objc func didPullToRefresh() {
            let anotherQueue = DispatchQueue(label: "com.appcoda.parentQueue", qos: .default)
            anotherQueue.async {
                if(!self.isConnectedToNet()) {
                    DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    }
                }
                //self.getDependantsFromServer()
                self.getDataForParentalDependentFromServer()
            }
            
            anotherQueue.async {
                DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                }
            }
        }
    
    //TableView Animation
       override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getDependantsFromServer()
           //getDataForParentalRelationFromServer()
           getDataForParentalDependentFromServer()
           getWindowPeriodDetails()

           
       }
    
    override func viewDidAppear(_ animated: Bool) {
        if let val = UserDefaults.standard.value(forKey: "parentalOverlay") as? Bool {
            if val == false {
                showParentalOverlay()
                
            }
        }
        else {
            showParentalOverlay()
            
        }
        getDataForParentalDependentFromServer()
    }
    @objc func updateCounter() {
        if !isDisabled{
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: endDate!)
            countDown(dateString)
        }
    }
    
    func countDown(_ endDate : String){
        
        if endDate != "" && timer1 != nil{
            var dateFormatter = DateFormatter()
            //var endDate = "31/12/2022"
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let EndDate = dateFormatter.date(from:endDate)!
            let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: EndDate)!
            let endDateComp = Calendar.current.dateComponents([.year, .month, .day], from: modifiedDate)
            //        let nextTriggerDate = Calendar.current.date(byAdding: .day, value: 1, to: EndDate)!
            //        let comps = Calendar.current.dateComponents([.year, .month, .day], from: nextTriggerDate)
            let nextBirthDate = Calendar.current.nextDate(after: Date(), matching: endDateComp, matchingPolicy: .nextTime)!
            
            let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: nextBirthDate)
            
        
            countDownTime = String(format: "%02d:%02d:%02d:%02d", difference.day!, difference.hour!,difference.minute!,difference.second!)//"\(difference.day!.description):\(difference.hour!.description):\(difference.minute!.description):\(difference.second!.description)"
            print("count time:\(countDownTime)")
            let index = IndexPath(row: 0, section: 0)
            
            if let cell = tableView.cellForRow(at: index) as? CellForInstructionHeaderCell{
                    cell.lblTimer.text = countDownTime
            }
            alertController?.message = countDownTime ?? ""//String(format: "%02d:%02d", minutes, seconds)
            
        }
    }
    
    func getWindowPeriodDetails(){
        let appendUrl = "getWindowPeriodDetails"
        
        webServices().getDataForEnrollment(appendUrl, completion: {(data,error) in
            if error == ""{
                do{
                    let json = try JSONDecoder().decode(WindowPeriodDetails.self, from: data)
                    print(json)
                    var endD = json.windowPeriod.windowEndDate_gmc
                   // self.endDate = endD
                    
                }catch{

                }
            }else{
                DispatchQueue.main.sync{
                    self.showAlertwithOk(message: error)
                }
            }
            
        })
    }
    
    func showAlert(){
        alertController = UIAlertController(title: "Timer ", message: "", preferredStyle: .alert)
        present(alertController!, animated: true){
            self.timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
            //self.timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
        let cancelAction = UIAlertAction(title: "DISMISS", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
//            self.timer!.invalidate()
//            self.timer = nil
            self.timer1!.invalidate()
            self.timer1 = nil
        }
        alertController!.addAction(cancelAction)
    }
    
    
    @objc func TimerAct(sender: UIButton){
        let indexpath2 = IndexPath(row: sender.tag, section: 0)
        if !isDisabled{
            showAlert()
        }else{
            self.showAlert(message: "Window Period is expired.")
        }
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLayoutSubviews() {
         CATransaction.begin()
         CATransaction.setDisableActions(true)
         gradientLayer.frame = self.view.bounds
         CATransaction.commit()
       }
    
  
    
   
    
    
    private func addHeader(percentage:Int,headerNumber:Int,sortId:Int) -> ParentalRecords  {
       
        let obj = ParentalRecords.init(premium: "", premiumType: "", sumInsured: "", siType: "", personSrNo: "", name: "", age: "", dateOfBirthToShow: "", dateOfBirth: "", relation: "", relationID: "", covered: true, canAdd: true, canUpdate: true, canDelete: true, canInclude: true, reason: "", coveredInPolicyType: 0, employerContri: "", employeeContri: "", parentsBaseSumInsured: "", sortNo: "")
       
        //let obj = ParentalRecords.init(sortNo: 0, Name: "", Relation: "", Gender: "", RelationID: "", Age: "", DateOfBirth: "", PersonsortNo: "", ReasonForNotAbleToDelete: "", IsTwins: "", ReasonForNotAbleToUpdate: "", PairNo: "", ExtraChildPremium: "", Premium: "", document: "", enrollment_Reason: "", parentPercentage: 0, IsSelected: false, IsApplicable: false, CanDelete: false, CanUpdate: false, IsDisabled: false, canAdd: false)
        
        return obj
    }
    
   
    func getPercentage() -> Int {
        let filteredItems = structDataSource.filter { $0.canAdd == false }
        if filteredItems.count < 2 {
        return 50
        }
        return 100
    }
    
    //MARK:- Sort and refresh tableView
    func refreshSortedTableView() {
        // var tempDataSource = structDataSource.sorted(by: { $0.sortId < $1.sortId })
        
        //      tempDataSource =  tempDataSource.sorted{ Int.init($0.isEmpty ?? true) < Int.init(!($1.isEmpty ?? true)) }
        // tempDataSource = tempDataSource.sorted(by: { $0.isEmpty?.description < $1.isEmpty?.description })
        
        //commented 24th march
        //structDataSource = structDataSource.sorted(by:{ !$0.isEmpty! && $1.isEmpty!})
        
        if structDataSource.count == 4 {
            self.firstSectionArray.removeAll()
            self.secondSectionArray.removeAll()
            
            self.firstSectionArray.append(structDataSource[0])
            self.firstSectionArray.append(structDataSource[1])
            
            self.secondSectionArray.append(structDataSource[2])
            self.secondSectionArray.append(structDataSource[3])
        }
        else if structDataSource.count == 2{
            
            self.firstSectionArray.removeAll()
            self.secondSectionArray.removeAll()
            
            if structDataSource[0].sortNo == "0" && structDataSource[1].sortNo == "1" {
                self.firstSectionArray.append(structDataSource[0])
                self.firstSectionArray.append(structDataSource[1])
            }
            else if structDataSource[0].sortNo == "2" && structDataSource[1].sortNo == "3"{
                self.secondSectionArray.append(structDataSource[0])
                self.secondSectionArray.append(structDataSource[1])
            }
            else{
                self.firstSectionArray.append(structDataSource[0])
            }
        }
        
        self.tableView?.reloadData() {
            self.isLoaded = 1
        }
        
        //For Summary data
        parentsModelArray1 = self.firstSectionArray.filter({$0.canAdd == false})
        parentsModelArray2 = self.secondSectionArray.filter({$0.canAdd == false})
        
    }
    
    
    
    
    private func checkDataSource() {
         //let index = IndexPath(row: position , section: 1)
        // tableView.deleteRows(at: [index], with: UITableView.RowAnimation.right)
         
         var filteredItems = structDataSource.filter { $0.canAdd == false }
         if filteredItems.count == 2 {
             self.structDataSource = filteredItems
         }
         else if filteredItems.count < 2 {
             let fatherArray = structDataSource.filter{ $0.relation.capitalizingFirstLetter() == "Father"}
             if fatherArray.count == 0 {
                 structObject?.canAdd = false
                 structObject?.relation = "Father".uppercased()
                 self.structDataSource.append(structObject!)
             }
             
             let motherArray = structDataSource.filter{ $0.relation.capitalizingFirstLetter() == "Mother"}
             if motherArray.count == 0 {
                 structObject?.canAdd = false
                 structObject?.relation = "Mother".uppercased()
                 self.structDataSource.append(structObject!)
             }
             
             let fatherInLawArray = structDataSource.filter{ $0.relation.uppercased() == "FATHER-IN-LAW"}
             if fatherInLawArray.count == 0 {
                 structObject?.canAdd = false
                 structObject?.relation = "FATHER-IN-LAW".uppercased()
                 self.structDataSource.append(structObject!)
             }
             
             let motherInLawArray = structDataSource.filter{ $0.relation.uppercased() == "MOTHER-IN-LAW"}
             if motherInLawArray.count == 0 {
                 structObject?.canAdd = false
                 structObject?.relation = "MOTHER-IN-LAW".uppercased()
                 self.structDataSource.append(structObject!)
             }
             
         }
         else {
             print("No Modifications...")
         }
         
         
         
         tableView.reloadData()

    }
    
    func refreshData(_ type: String) {
        if type == "dismiss"{
            didPullToRefresh()
        }
    }
    
   
}


extension ParentalPremiumVC:UITableViewDelegate,UITableViewDataSource {
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoaded == 0 {
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
                
                    cell.alpha = 0.0
                    animationsQueue.queue(withDuration: 0.4, initializations: {
                        cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -cell.frame.size.width, 0, 0)
                    }, animations: {
                        cell.alpha = 1.0
                        cell.layer.transform = CATransform3DIdentity
                    })
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("parentalRecordsStructJSONArray count ",parentalRecordsStructJSONArray.count)
       print("structDataSource count: ",structDataSource.count)
        print("firstSectionArray count: ",firstSectionArray.count)
        print("secondSectionArray count: ",secondSectionArray.count)
        if section == 0 {
            if structDataSource.count > 0 {
            return 1
            }
            return 0
        }
        else if section == 1 {
            if self.firstSectionArray.count > 0 {
            return self.firstSectionArray.count + 1 //GHI
            }
            return 0
        }
        else {
            if self.secondSectionArray.count > 0 {
            return self.secondSectionArray.count + 1  //GHI
            }
            return 0
        }
        
        
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { //Info Cell
            //return 100
            // return 135
            return 240//UITableViewAutomaticDimension
        }
            
        else { //GPA
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    return UITableViewAutomaticDimension
                }
                else {
                    if firstSectionArray[indexPath.row - 1].canAdd == true {
                        return UITableViewAutomaticDimension
                    }
                    else {
                        return 130
                    }
                }
            }
            else {
             if indexPath.row == 0 {
                    return UITableViewAutomaticDimension
                }
                else {
                    if secondSectionArray[indexPath.row - 1].canAdd == true {
                        return UITableViewAutomaticDimension
                    }
                    else {
                        return 130
                    }
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt..")
        //Sodexo Plans
        
        if indexPath.section == 0 {
    
           // if indexPath.row == 0 {
            let cell : CellForInstructionHeaderCell = tableView.dequeueReusableCell(withIdentifier: "CellForInstructionHeaderCell", for: indexPath) as! CellForInstructionHeaderCell
            cell.btnInfo.isHidden = false
            cell.btnInfo.tag=indexPath.row
            cell.btnInfo.addTarget(self, action: #selector(showInfoClicked(_:)), for: .touchUpInside)
            cell.btnTimer.tag = indexPath.row
            cell.btnTimer.addTarget(self, action: #selector(TimerAct), for: .touchUpInside)
            if !isDisabled{
                cell.lblTimer.text = countDownTime
            }else{
                cell.lblTimer.text = "Window Period is expired."
            }
            cell.imgView.image = UIImage(named:"Asset 10")
            cell.lblHeaderName.text = "Parental Details"
            cell.lblDescription.text = "you can nominate all four parents - Father, Mother, Father-in-law or Mother-in-law for insurance coverage"
            return cell
           // }
            //else {
              //  let cell : ParentalSectionHeaderCell = tableView.dequeueReusableCell(withIdentifier: "ParentalSectionHeaderCell", for: indexPath) as! ParentalSectionHeaderCell
                //cell.lblHeaderName.text = "Parental Details"
                //cell.lblDescription.text = "you can nominate any two parents -\n Father, Mother, Father-in-law or Mother-in-law (cross selection is allowed)"
             //   return cell
            //}
        }
        else {
            
            if indexPath.row == 0  {
                let cell : ParentalSectionHeaderCell = tableView.dequeueReusableCell(withIdentifier: "ParentalSectionHeaderCell", for: indexPath) as! ParentalSectionHeaderCell
                if indexPath.section == 1 {
                    //cell.lblPercentage.text = "(50% of Premium borne by Employee)"
                    cell.lblSetOfParents.text = "Set 1 of Parents - SI"
                
                }
                else {
                   // cell.lblPercentage.text = "(100% of Premium borne by Employee)"
                    cell.lblSetOfParents.text = "Set 2 of Parents - SI"
                }
                
                if let basegmc = UserDefaults.standard.value(forKey: "baseGmc") as? String {
                    //cell.lblSumInsured.text = getFormattedCurrency(amount: basegmc)
                    cell.lblSumInsured.text = basegmc //getFormattedCurrency(amount: basegmc)
                }

                return cell
            }
            else {

                //var finalObj = ParentalRecord()
                var finalObj : ParentalRecords?
                if indexPath.section == 1 {
                    finalObj = firstSectionArray[indexPath.row - 1]
                }
                else {
                    finalObj = secondSectionArray[indexPath.row - 1]
                }
                print("Data: finalObj ",finalObj)
                print("Data: finalObj.sortNo ",finalObj?.sortNo)
                
            //if finalObj.sortNo != -1 {
                if finalObj?.name != ""{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForExistingDependants", for: indexPath) as! CellForExistingDependants
                //shadowForCell(view: cell.backView)
                
                cell.m_nameTextField.text = finalObj?.name
                
                cell.m_deleteButton.tag = indexPath.row
                cell.m_deleteButton.addTarget(self, action: #selector(deleteParentTapped(_:)), for: .touchUpInside)
                
                cell.m_editButton.tag=indexPath.row
                cell.m_editButton.addTarget(self, action: #selector(editButtonClicked(_:)), for: .touchUpInside)
                
                cell.btnInfo.tag=indexPath.row
                cell.btnInfo.addTarget(self, action: #selector(infoButtonClicked(_:)), for: .touchUpInside)

                
                cell.m_deleteButton.isHidden = true
                cell.m_editButton.isHidden = false
                cell.lblDelete.isHidden = true
                
                cell.imgTwins.isHidden = true
                // if m_isEnrollmentConfirmed {
                // cell.m_editButton.isHidden = true
                //cell.m_deleteButton.isHidden = true
                //}
                // else {
                // cell.m_editButton.isHidden = false
                // cell.m_deleteButton.isHidden = false
                // }
                
                let dict = finalObj
                    cell.m_titleLbl.text=dict?.relation.capitalizingFirstLetter()
                cell.m_nameTextField.text=dict?.name
                
                /*
                 //Date conversion
                let dateStr = dict.dateofBirth?.getStrDateEnrollment()
                if dateStr != "" {
                    cell.m_dobTextField.text = dateStr
                }
                else {
                    cell.m_dobTextField.text = dict.dateofBirth
                }
                */
                cell.m_dobTextField.text = dict?.dateOfBirthToShow
                
                    if let age = Int(dict?.age ?? "0") {
                    if age > 1 {
                        cell.m_ageTextField.text = String(format: "%@ (years)", String(age))
                    }
                    else {
                        cell.m_ageTextField.text = String(format: "%@ (year)", String(age))
                    }
                }
                //        cell.m_dateOfMarrigeTxtField.tag=indexPath.row
                
                
                    cell.imgView.image = getRelationWiseImage(relation: cell.m_titleLbl.text?.lowercased() ?? "", m_gender: dict?.relation.lowercased() ?? "")
                
                //Add Swipe Gesture
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
                cell.m_backGroundView.addGestureRecognizer(tapRecognizer)
                
                
                cell.m_backGroundView.tag = indexPath.row
                
                if dict?.canDelete == true {
                    
                    
                }
                else {
                }
                    
             
                //Added by Pranit to hide 01-Jan-1900
                if dict?.dateOfBirthToShow == "01-Jan-1900" {
                    cell.m_dobTextField.text = "-"
                }
                
               /* if indexPath.section == 1 {
                   // cell.lblGst.text = "(Employee share- \(firstSectionArray[indexPath.row - 1].parentPercentage)%)"
                    cell.lblAmount.text = "₹" + (dict.premium ?? "")
                        
                        //self.getNewFormattedCurrency(amount: firstSectionArray[indexPath.row - 1].premium!)
                }
                else {
                   // cell.lblGst.text = "(Employee share- \(secondSectionArray[indexPath.row - 1].parentPercentage)%)"
                    cell.lblAmount.text = "₹" + (secondSectionArray[indexPath.row - 1].premium ?? "")
                        //self.getNewFormattedCurrency(amount: secondSectionArray[indexPath.row - 1].premium!)
                }*/
                
                cell.lblAmount.text = "₹" + (dict?.premium ?? "")
               // cell.lblAmount.text = "₹ 54,21,5445"

                    if dict?.sortNo == "1" || dict?.sortNo == "2" {
                    //cell.lblGst.text = "(Employee share- 100%)"
                      cell.lblGst.text = "(includes GST)        "
                }
                else {
                    //cell.lblGst.text = "(Employee share- 100%)"
                      cell.lblGst.text = "(includes GST)        "
                }
                //cell.lblGst.text = "(includes GST)"
                cell.imgDisabled1.isHidden = true
                cell.imgDisabled.isHidden = true
                cell.m_docButton.isHidden = true
                cell.m_docButton1.isHidden = true
                hidePDeleteView(cell: cell)

                if dict?.canUpdate == true {
                    cell.m_editButton.isHidden = false
                    cell.btnInfo.isHidden = true
                    let leftRecognizer = UISwipeGestureRecognizer(target: self, action:
                            #selector(swipeMade(_:)))
                        leftRecognizer.direction = .left
                        let rightRecognizer = UISwipeGestureRecognizer(target: self, action:
                            #selector(swipeMade(_:)))
                        rightRecognizer.direction = .right
                    //cell.m_backGroundView.isUserInteractionEnabled = true

                    cell.m_backGroundView.addGestureRecognizer(leftRecognizer)
                    cell.m_backGroundView.addGestureRecognizer(rightRecognizer)
                }
                else {
                    cell.m_editButton.isHidden = true
                    cell.btnInfo.isHidden = false
                    cell.m_backGroundView.gestureRecognizers = nil
                    //cell.m_backGroundView.isUserInteractionEnabled = false
                }
                
                return cell
            }//isEmpty == false
            else {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForNewDependants", for: indexPath) as! CellForNewDependants
                cell.dashBackView.tag = indexPath.row
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                
                //cell.lblAmount.isHidden = true
                cell.lblGst.isHidden = true
                let dict = finalObj
                if let IsWindowPeriodOpen = UserDefaults.standard.value(forKey: "IsWindowPeriodOpen") as? String  {
                    if let IsEnrollmentSaved = UserDefaults.standard.value(forKey: "IsEnrollmentSaved") as? String  {
                        if IsWindowPeriodOpen == "1" && IsEnrollmentSaved == "0" {
                       // if IsWindowPeriodOpen == "0" && IsEnrollmentSaved == "0" {
                            cell.dashBackView.addGestureRecognizer(tapGesture)
                            
                        }
                        else {
                        }
                    }
                    else {
                    }
                }
                else {}
                cell.lblName.text=dict?.relation.capitalizingFirstLetter()
                return cell
            }
            //...,,,,
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
        if section == 2 {
            return 60
        }
        return 0
    }
 
    
   
    //MARK:- Currency Converter
    private func getFormattedCurrency(amount:String) -> String {
        
        if amount == "" {
            return ""
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
        
        let formatedString =  String(format: "₹ %@",priceString)
        
        //  let str = "₹ 3700"
        
        return formatedString.removeWhitespace()
    }

    
    
    
    @objc func handleTap(_ sender: UISwipeGestureRecognizer) {
        if !isDisabled{
            var tapLocation = sender.location(in: self.tableView)
            var indexPath:IndexPath = self.tableView.indexPathForRow(at: tapLocation) as! IndexPath
            var firstSectionArraysortNo = Int(firstSectionArray[indexPath.row - 1].sortNo) ?? 0
            var secondSectionArraysortNo = Int(secondSectionArray[indexPath.row - 1].sortNo) ?? 0
            if indexPath.section == 1 {
                
                addNewParent(relation: firstSectionArray[indexPath.row - 1].relation, index: firstSectionArraysortNo,obj:firstSectionArray[indexPath.row - 1])
            }
            else {
                addNewParent(relation: secondSectionArray[indexPath.row - 1].relation, index: secondSectionArraysortNo,obj: secondSectionArray[indexPath.row - 1])
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc private func addNewParentTapped(_ sender : UIButton) {
        //addNewParent()
    }
    
    //MARK:- Add New
    private func addNewParent(relation:String,index:Int,obj:ParentalRecords) {
    
        guard let IsWindowPeriodOpen = UserDefaults.standard.value(forKey: "IsWindowPeriodOpen") as? String else {
                              return
                          }
                          
        if IsWindowPeriodOpen == "1" {
        //if IsWindowPeriodOpen == "0" {
        let addParent  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"AddEditParentVC") as! AddEditParentVC
        addParent.modalPresentationStyle = .custom
        addParent.relationStr = relation
        addParent.newDependantDelegate = self
        addParent.position = index
        addParent.isEdit = false
        addParent.selectedObj = obj
        addParent.m_parentsNameArraySD = m_parentsNameArray
        addParent.premiumAmount = ""
        addParent.refreshDelegate = self
        self.navigationController?.present(addParent, animated: true, completion: nil)
        }
    }
    
    //    @objc private func addParentTapped(_ sender : UIButton) {
    //
    //    }
    
    @objc private func saveParentTapped(_ sender : UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 1)
        let cell = tableView.cellForRow(at: indexPath) as! CellForParentalInfoCell
        
        print(cell.m_nameTextfield.text)
        
    }
    
   @objc private func  deleteParentTapped(_ sender : UIButton) {
              //  let indexPath = IndexPath(row: sender.tag, section: 1)
    
    
    guard let cell = sender.superview?.superview?.superview as? CellForExistingDependants else {
               return // or fatalError() or whatever
           }

           let indexPath = tableView.indexPath(for: cell)
    
    //deleteDependant(indexPath: indexPath!)
       var srNo = parentalRecordsStructJSONArray[indexPath!.row].personSrNo
       print("Delete srNo : ",srNo)
       self.deleteDependant(msg:"Would you like to remove this dependant?", SrNo: srNo,indexpath: indexPath?.row ?? 0)
    
        //        let cell = tableView.cellForRow(at: indexPath) as! CellForParentalInfoCell
        //
        //        //access the label inside the cell
        //        print(cell.m_nameTextfield.text)
        //
        //        isEditIndex = indexPath.row
        //       // self.tableView.reloadRows(at: [indexPath], with: .none)
        //        self.tableView.reloadData()
        
       // self.structDataSource.remove(at: sender.tag)
        //self.tableView.reloadData()
       // checkDataSource()
       // self.tableView.reloadSections([1], with: .fade)

    }
    
    private func deleteDependant(indexPath:IndexPath) {

        let alert = UIAlertController(title: "", message: "Would you like to remove this parent?", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler: { (UIAlertAction)in
            print("User clecked Delete Button")
            
        }))
        /*
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
            
            
        //var obj = ParentalRecords()
            var obj : ParentalRecords?
            if indexPath.section == 1 {
                obj = self.firstSectionArray[indexPath.row - 1]
                     }
                     else {
                obj = self.secondSectionArray[indexPath.row - 1]
                     }
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
                       if(userArray.count>0)
                       {
                           var m_employeedict : EMPLOYEE_INFORMATION?

                           m_employeedict=userArray[0]
                           var oe_group_base_Info_Sr_No = String()
                           var groupChildsortNo = String()
                           var empsortNo = String()
                           
                           if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
                           {
                               oe_group_base_Info_Sr_No = String(empNo)
                           }
                           if let groupChlNo = m_employeedict?.groupChildSrNo
                           {
                               groupChildsortNo=String(groupChlNo)
                           }
                           if let empSr = m_employeedict?.empSrNo
                           {
                               empsortNo = String(empSr)
                           }
                       
                           let url = APIEngine.shared.deleteParent(GroupChildSrNo: groupChildsortNo, EmpSrNo: empsortNo, PersonSrNo:obj?.personSrNo!, OeGrpBasInfSrNo: oe_group_base_Info_Sr_No, RelationID: obj.RelationID!,parentalPremium: obj?.premium!)
            self.deleteDependantToServer(url: url)
            }
           

        }))
        */
         
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @objc private func showInfoClicked(_ sender : UIButton) {
        showParentalOverlay()
    }
    
    private func showParentalOverlay() {
        let vc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "ParentalOverlayVC") as! ParentalOverlayVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
       UserDefaults.standard.setValue(true, forKey: "parentalOverlay")

        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func checkOrder(sortId:Int,relationName:String) {
        /*
        for i in 0..<tempArray.count {
            //if temp.sortId == sortId && temp.relationname == relationName {
                
           // }
            if tempArray[i].parentPercentage == 100 && tempArray[i].canAdd == false && tempArray[i].sortNo != sortId && tempArray[i].Relation != relationName {
                tempArray[i].parentPercentage = 50
                
               // let index = structDataSource.contains(where: {$0.sortId == sortId && $0.relationname == relationName})
                if let index = structDataSource.index(where: {$0.relation.lowercased() == tempArray[i].relation.lowercased() && $0.sortNo == tempArray[i].sortNo}) {
                    structDataSource[index].parentPercentage = 50
                    self.refreshSortedTableView()
                    break
                }
            }
        }
        */
        self.refreshSortedTableView()
    }
    
    @objc private func infoButtonClicked(_ sender : UIButton) {
        guard let cell = sender.superview?.superview?.superview as? CellForExistingDependants else {
                   return // or fatalError() or whatever
               }

               let indexPath = tableView.indexPath(for: cell)

               var premiumAmount = ""
               //var obj = ParentalRecords()
                var obj : ParentalRecords?
               if indexPath!.section == 1 {
                   obj = firstSectionArray[indexPath!.row - 1]
                      }
                      else {
                   obj = secondSectionArray[indexPath!.row - 1]
                      }
    
        //self.showAlert(message: obj.enrollment_Reason ?? "")
        self.showAlert(message:"Alerttt")
    }
    
    //MARK:- Edit Tapped...
    @objc private func editButtonClicked(_ sender : UIButton) {
        //        print("Delete Dependant...\(sender.tag)")
        //        self.structDataSource[sender.tag].isEmpty = true
        //        let index = IndexPath(row: sender.tag , section: 1)
        //        tableView.reloadRows(at: [index], with: .fade)
        
    
        if !isDisabled{
            guard let cell = sender.superview?.superview?.superview as? CellForExistingDependants else {
                return // or fatalError() or whatever
            }
            
            let indexPath = tableView.indexPath(for: cell)
            
            var premiumAmount = ""
            //var obj = ParentalRecords()
            var obj : ParentalRecords?
            if indexPath!.section == 1 {
                obj = firstSectionArray[indexPath!.row - 1]
            }
            else {
                obj = secondSectionArray[indexPath!.row - 1]
            }
            
            if obj?.canUpdate == true {
                let addParent  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"AddEditParentVC") as! AddEditParentVC
                addParent.modalPresentationStyle = .custom
                addParent.relationStr = obj?.relation ?? ""
                addParent.newDependantDelegate = self
                addParent.refreshDelegate = self
                do{
                    var value : Int? = try Int(obj?.sortNo ?? "0")
                    addParent.position = value ?? 0
                }
                catch{
                    print(error)
                }
                    
                addParent.selectedObj = obj
                
                addParent.m_parentsNameArraySD = m_parentsNameArray
                //        if m_parentsNameArray.count > 0  {
                //            addParent.m_parentsNameArraySD.remove(at: sender.tag)
                //        }
                
                if m_parentsNameArray.count > 0  {
                    if addParent.m_parentsNameArraySD.contains(obj!.name){
                        if let index = addParent.m_parentsNameArraySD.index(of: obj!.name){
                            addParent.m_parentsNameArraySD.remove(at: index)
                        }
                    }
                    //addParent.m_parentsNameArraySD.remove(at: sender.tag)
                }
                
                addParent.isEdit = true
                addParent.premiumAmount = obj?.premium ?? ""
                self.navigationController?.present(addParent, animated: true, completion: nil)
            }
        }
    }
    
    private func getRelationWiseImage(relation:String,m_gender:String) -> UIImage {
        
        switch relation
        {
        case "EMPLOYEE".lowercased() :
            
            if(m_gender.lowercased() == "male")
            {
                return UIImage(named: "Asset 36")!
            }
            else
            {
                return UIImage(named: "Female Employee")!
            }
            
        case "SPOUSE".lowercased() :
            
            
            if(m_gender.lowercased() == "male")
            {
                return UIImage(named: "Husband")!
            }
            else
            {
                return UIImage(named: "Asset 57")!
            }
            
        case "wife" :
            return UIImage(named: "Asset 57")!
            
        case "husband" :
            return UIImage(named: "Husband")!
            
            
            
        case "SON".lowercased() :
            
            return UIImage(named: "son")!
            
            
        case "DAUGHTER".lowercased() :
            
            return UIImage(named: "Asset 56")!
            
            
        case "FATHER".lowercased() :
            
            return UIImage(named: "grandfather")!
            
            
        case "MOTHER".lowercased() :
            
            return UIImage(named: "grandmother")!
            
            
        case "FATHER-IN-LAW".lowercased():
            
            return UIImage(named: "grandfather")!
            
            
        case "MOTHER-IN-LAW".lowercased() :
            
            return UIImage(named: "grandmother")!
            
            
        default :
            return UIImage(named: "son")!
            
            
            
        }
    }
    
    @objc private func moveToNext(_ sender : UIButton) {
        
        if m_isEnrollmentConfirmed {
//            let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"HealthPackagesVC") as! HealthPackagesVC
//            self.navigationController?.pushViewController(flexIntroVC, animated: true)
            
        }
        else {
            //                    let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
            //                    enrollmentVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            //                    enrollmentVC.m_windowPeriodEndDate=m_windowPeriodEndDate
            //                    enrollmentVC.progressBar.currentIndex = 2
            //                    enrollmentVC.selectedIndexForView = 2
            //                    navigationController?.pushViewController(enrollmentVC, animated: true)
            
            let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"GHITopUpVC") as! GHITopUpVC
            flexIntroVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            flexIntroVC.m_windowPeriodEndDate=m_windowPeriodEndDate
            
            self.navigationController?.pushViewController(flexIntroVC, animated: true)
            
        }
    }
    
    
    @objc private func doNotTopUp(_ sender : UIButton) {
        
        let refreshAlert = UIAlertController(title: "Are you sure, you do not wish to opt this top-up?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Yes logic here")
            if sender.tag == 2 {
                // self.selectedGPAPremium = -1
            }
            else {
                // self.selectedGTLPremium = -1
            }
            // self.tableView.reloadData()
        }))
        
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    private func designCard(view:UIView) { //Sum insured blue card
        //view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 6.0
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.layer.borderWidth = 1.0
        // view.setGradientBackground1(colorTop: hexStringToUIColor(hex: "0171d5"), colorBottom:hexStringToUIColor(hex: "5eb1fd"))
        
    }
    
    private func designCardBox(view:UIView) {
        //view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 2.0
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.layer.borderWidth = 1.0
    }
    
    
    func animateTable() {
        
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        for i in cells {
            
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
         var index = 0
       for a in cells {
            
            if a.isKind(of: CellForNewDependants.self) {
                let cell: CellForNewDependants = a as! CellForNewDependants
                UIView.animate(withDuration: 2, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
                
                index += 1
            }
            else if a.isKind(of: CellForParentalInfoCell.self) {
                let cell: CellForParentalInfoCell = a as! CellForParentalInfoCell
                UIView.animate(withDuration: 2, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
                index += 1
            }
            else {
                //CellForParentalPremium
                let cell: CellForParentalPremium = a as! CellForParentalPremium
                
                UIView.animate(withDuration: 2, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
                index += 1
            }
        }//for
    }
    
}


extension ParentalPremiumVC:UIScrollViewDelegate {
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
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if self.hideCollectionViewDelegate != nil {
//            hideCollectionViewDelegate?.show(index: 1)
//        }
//    }
//
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//          if self.hideCollectionViewDelegate != nil {
//              hideCollectionViewDelegate?.show(index: 1)
//          }
//      }
    
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

extension ParentalPremiumVC {
    
    //SWIPE To DELETE
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section != 0 {
    if structDataSource.count > indexPath.row {
    if structDataSource[indexPath.row].canAdd == false {
    return true
    }
    return false
    }
    return false
    }
    return false
    
    }

    
    func hidePDeleteView(cell:CellForExistingDependants) {
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
       /* let index = IndexPath(row: sender.view!.tag, section: 1)
        
        guard let cell = tableView.cellForRow(at: index) as? CellForExistingDependants else {
            return
        }
        */
        if !isDisabled{
            guard let cell = sender.view?.superview?.superview as? CellForExistingDependants else {
                return // or fatalError() or whatever
            }
            
            
            hidePDeleteView(cell: cell)
        }

    }
    //MARK:- Gesture Control - Add
    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
        print("Swipe made..")
        if !isDisabled{
            
            if sender.direction == .left {
                print("left.. For Delete")
                //self.tableView.reloadData()
                
                //  let index = IndexPath(row: sender.view!.tag, section: 1)
                
                guard let cell = sender.view?.superview?.superview as? CellForExistingDependants else {
                    return // or fatalError() or whatever
                }
                
                //  let indexPath = tableView.indexPath(for: cell)
                
                
                
                //            guard let cell = tableView.cellForRow(at: index) as? CellForExistingDependants else {
                //                return
                //            }
                
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
                print("Right.. cancel Delete")
                
                //            let index = IndexPath(row: sender.view!.tag, section: 1)
                //            guard let cell = tableView.cellForRow(at: index) as? CellForExistingDependants else {
                //                return
                //            }
                
                guard let cell = sender.view?.superview?.superview as? CellForExistingDependants else {
                    return // or fatalError() or whatever
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
    
}


extension ParentalPremiumVC :NewParentDependentAddedProtocol {
    //MARK:- Custom Delegate Methods
    //MARK:- Insert Parent
    func newDependantAdded(position:Int,data:ParentalRecords) {
       
        
        getDependantsFromServer()
    }
    
}


extension ParentalPremiumVC {
    func getDependantsFromServer() {
        print("@@ getDependantsFromServer...")
        /*
        if(isConnectedToNetWithAlert())
        {
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                m_employeedict=userArray[0]
                
                var oe_group_base_Info_Sr_No = String()
                var groupChildsortNo = String()
                var empsortNo = String()
                var empIDNo = String()
                
                if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
                {
                    oe_group_base_Info_Sr_No = String(empNo)
                }
                if let groupChlNo = m_employeedict?.groupChildsortNo
                {
                    groupChildsortNo=String(groupChlNo)
                }
                if let empsortNo = m_employeedict?.empsortNo
                {
                    empsortNo=String(empsortNo)
                }
                if let empidno = m_employeedict?.empIDNo
                {
                    empIDNo=String(empidno)
                }
                
//                guard let groupsortNo = UserDefaults.standard.value(forKey: "ExtGroupsortNo") else {
//                    return
//                }
                
                let url = APIEngine.shared.getParentalListJSONURL(Windowperiodactive: "1", GroupChildsortNo: groupChildsortNo, OeGrpBasInfsortNo: oe_group_base_Info_Sr_No, EmpsortNo: empsortNo,parentalPremium:"0")
                
                
                let urlreq = NSURL(string : url)
                
                //self.showPleaseWait(msg: "")
                print(url)
                EnrollmentServerRequestManager.serverInstance.getArrayRequestDataFromServer(url: url, view: self) { (data, error) in
                    
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
                            print("getDependantsFromServer")
                            print(data)
                            
                            print("Value edited ",data?["Parental"].array)
                            
                            if let jsonResultArray = data?["Parental"].array
                            {
                                self.structDataSource.removeAll()
                                self.tempDataSource.removeAll()
                                self.m_parentsNameArray.removeAll()
                                
                                print(jsonResultArray.count)
                                for obj in jsonResultArray {
                                    
                                    
                                    print("Data in obj[SortNo] ",obj["sortNo"].stringValue)
                                    print("Data in obj[sortNo] ",obj["sortNo"])
                                    print("Data in obj ",obj)
                                    
                                    self.m_parentsNameArray.append(obj["Name"].string ?? "")

                                    
                                    var sortId = 10
                                    let relationName = obj["Relation"].string
                                    
                                    let gender = "Male"
                                    let ageStr = obj["Age"].string
                                    var ageInt = 0
                                    if ageStr != "" {
                                        ageInt = Int(ageStr ?? "0")!
                                    }

                                    var isEmptyData = true
                                    if obj["sortNo"].stringValue != "" {
                                        isEmptyData = false
                                    }else{
                                        print("Obj value is ",obj["sortNo"].string)
                                    }
                                    

                                      
                                    let objXX = ParentalRecords.init(sortNo: obj["sortNo"].int, Name: obj["Name"].string, Relation: obj["Relation"].string, Gender: gender, RelationID: obj["RelationID"].string, Age: String(ageInt), DateOfBirth: obj["DateOfBirthToShow"].string, PersonsortNo: obj["PersonsortNo"].string, ReasonForNotAbleToDelete: "", IsTwins: "", ReasonForNotAbleToUpdate: "", PairNo: "", ExtraChildPremium: "", Premium: obj["Premium"].string, document: "", enrollment_Reason: obj["Reason"].string, parentPercentage: 50, IsSelected: false, IsApplicable: false, CanDelete: false, CanUpdate: obj["CanUpdate"].bool, IsDisabled: false, canAdd: isEmptyData)
                                    
                                    self.structDataSource.append(objXX)
                                }
                                // self.tableView.reloadData()
                                
                                self.refreshSortedTableView()
                                print("All Parents Name : \(self.m_parentsNameArray)")

                                
                            }//jsonResult
                        }//do
                            
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
            }//userArray
        }
        else {
            self.refreshControl.endRefreshing()
        }
         */
    }
    
    
    func deleteDependantToServer(url:String) {
        if(isConnectedToNetWithAlert())
        {
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
            
                let urlreq = NSURL(string : url)
                
                //self.showPleaseWait(msg: "")
                print(url)
                let dict = ["":""]
                
                EnrollmentServerRequestManager.serverInstance.deleteDataToServer(url: url, dictionary: dict as NSDictionary, view: self) { (data, error) in
                    
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
                            print(data)
                            
                           
                                print("deletDependantsFromServer Data Found")
                            if let statusDict = data?["message"].dictionary
                                {
                                    if let status = statusDict["Status"]?.bool {
        
                                        if status == true
                                        {
                                            //let msg = statusDict["Message"]?.string
                                            //self.displayActivityAlert(title: msg ?? "")
                                            self.getDependantsFromServer()
                                        }
                                        else {
                                            //No Data found
                                            let msg = statusDict["Message"]?.string
                                            self.displayActivityAlert(title: msg ?? "Failed to delete Dependant")
                                        }
                                    }//status
                                    
                                
                            }//jsonResult
                        }//do
                            
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
            }//userArray
        }
    }
    
}

//API Call
extension ParentalPremiumVC {
    //GetParentsRelations API
    
    func getDataForParentalRelationFromServer(){
        if(isConnectedToNetWithAlert()){
            
            let appendUrl = "/EmployeeEnrollement/GetParentsRelations?EmpSrNo=46655&GroupChildSrNo=1561&OeGrpBasInfSrNo=2074&IsWindowPeriodActive=1"
            
            webServices().getDataForEnrollment(appendUrl, completion: { (data,error) in
                print(data)
                if error == ""{
                    do{
                        let json = try JSONDecoder().decode(ParentalRelation.self, from: data)
                        print("The json is ",json)
                        let dataArray = json
                        
                        print("Data Array : ",dataArray)
                        
                        self.parentalRelationStructJSONArray = []
                        
                        
                        DispatchQueue.main.sync {
                            self.parentalRelationStructJSONArray.append(dataArray)
                            print(" self.parentalRelationStructJSONArray:  ", self.parentalRelationStructJSONArray)
                            self.getDataForParentalDependentFromServer()
                            self.tableView.reloadData()
                        }
                    }
                    catch let parsingError{
                        print("Error", parsingError)
                    }
                }
                
            })
        }
    }
    
    
    func getDataForParentalDependentFromServer(){
        if(isConnectedToNetWithAlert()){
            
            let appendUrl = "GetParentalDependants?IsWindowPeriodActive=1&GroupChildSrNo=1024&OeGrpBasInfSrNo=1047&EmpSrNo=61787&parentalPremium=0"
            
            webServices().getDataForEnrollment(appendUrl, completion: { (data,error) in
                print(data)
                if error == ""{
                    do{
                        let json = try JSONDecoder().decode([ParentalRecords].self, from: data)
                        print("The json is ",json)
                        let dataArray = json
                        
                        print("Data Array : ",dataArray)
                        
                        self.parentalRelationStructJSONArray = []
                        self.parentalRecordsStructJSONArray.removeAll()
                        self.structDataSource.removeAll()
                        self.tempDataSource.removeAll()
                        self.m_parentsNameArray.removeAll()
                        
                        for obj in dataArray {
                            self.m_parentsNameArray.append(obj.name ?? "")
                            self.structDataSource.append(obj)
                        }
                        
                        DispatchQueue.main.sync {
                            self.parentalRecordsStructJSONArray.append(contentsOf: dataArray)
                           // self.structDataSource.append(contentsOf: dataArray)
                            print(" self.parentalRelationStructJSONArray:  ", self.parentalRecordsStructJSONArray)
                            print(" self.parentalRelationStructJSONArray count:  ", self.parentalRecordsStructJSONArray.count)
                            self.refreshSortedTableView()
                        }
                    }
                    catch let parsingError{
                        print("Error", parsingError)
                    }
                }
                
            })
        }
    }
    
    //MARK:- Actionsheet Delete
    private func deleteDependant(msg:String,SrNo:String,indexpath:Int) {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .actionSheet)
 
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
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
            var personSrNo = SrNo
            
            var obj = self.parentalRecordsStructJSONArray[indexpath]
            //var appendUrl = "DeleteDependant?EmployeeSrNo=61787&GrpChildSrNo=1024&PersonSrNo=\(personSrNo)"
            //var appendUrl = "DeleteParentalDependant?EmployeeSrNo=61787&GrpChildSrNo=1024&PersonSrNo=\(personSrNo)&OeGrpBasInfSrNo=\(oe_group_base_Info_Sr_No)&RelationID=\(obj.relationID)&parentalPremium=0"//\(obj.premium)"
            var appendUrl = "DeleteParentalDependant?PersonSrNo=\(personSrNo)&OeGrpBasInfSrNo=1047&GrpChildSrNo=1024&EmployeeSrNo=61787&RelationID=6&parentalPremium=0"
            var dict : [String:Any] = [:]
            
            webServices().postDataForEnrollment(appendUrl, dict, completion: { (data,error) in
                if error == ""{
                    print(data)
//                    var jsonData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                    var msg : AnyObject = jsonData["message"] as? AnyObject!
//                    var msgStr = msg["Message"] as? String
                    DispatchQueue.main.async{
                        self.showAlert(message:"DEPENDANT DELETED SUCCESSFULLY")
                        self.getDataForParentalDependentFromServer()
                    }
                }else{
                    self.showAlert(message: error)
                }
                
            })
            
            
            print("After delete updated data",self.parentalRecordsStructJSONArray)
            self.tableView.reloadData()
        }))
 
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
 
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
}
