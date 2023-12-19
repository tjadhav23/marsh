//
//  AddTwinsVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 11/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class AddTwinsVC: UIViewController {
    
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var swipeIndicator: UIView!
    
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var txtDob: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAge: SkyFloatingLabelTextField!
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtRelation: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtDob2: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAge2: SkyFloatingLabelTextField!
    @IBOutlet weak var txtName2: SkyFloatingLabelTextField!
    @IBOutlet weak var txtRelation2: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    
    @IBOutlet weak var btnMale2: UIButton!
    @IBOutlet weak var btnFemale2: UIButton!
    @IBOutlet weak var btnOther2: UIButton!
    
    @IBOutlet weak var lblPrimium1: UILabel!
    @IBOutlet weak var lblPrimium2: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var heightOfGenderView: NSLayoutConstraint!
    
    @IBOutlet weak var lblSeparator: UILabel!
    @IBOutlet weak var bottomViewConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var middleSeparatorView: NSLayoutConstraint!
    var newTwinsDelegate:TwinsAddedProtocol? = nil
    
    var relationStr = ""
    var position = 0
    var pairNumber = 1 // 1st 2nd
    var selectedObjFirst = DependantDBRecords()
    var selectedObjSecond = DependantDBRecords()
    
    var isEdit = false
    
    var selectedGenderFirst = 0 //0-male, 1-Female, 2-Other
    var selectedGenderSecond = 0 //0-male, 1-Female, 2-Other
    
    var isKeyboardAppear = false
    let datePicker: UIDatePicker = UIDatePicker()
    
    var firstChildAge = 0
    var secondChildAge = 0
    var childCountIn = 0
    var premiunAmount = String()
    var m_membersNameArrayST = Array<String>()
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("All Members Name : \(self.m_membersNameArrayST)")

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        //  self.separatorView.addDashedBorder(shapeLayer: shapeLayer)
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 30
        if #available(iOS 11.0, *) {
            bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        } // Top right corner, Top left corner respectively
        
        
        lblSeparator.lineBreakMode = .byClipping
        
        
        btnAdd.makeCicularWithMasks()
        swipeIndicator.layer.cornerRadius = 3.0
        
        btnCancel.makeCicularWithMasks()
        btnCancel.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        btnCancel.layer.borderWidth = 2.0
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapGesture.delegate = self
        self.backView.addGestureRecognizer(tapGesture)
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipeGesture.direction = [.down]
        swipeGesture.delegate = self
        self.backView.addGestureRecognizer(swipeGesture)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        //Add gesture on textfield
        //let textTap = UITapGestureRecognizer(target: self, action: #selector(self.handleNameTapped(_:)))
        // self.txtName2.addGestureRecognizer(textTap)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleNameTapped(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        
        self.txtDob2.delegate = self
        self.txtName2.delegate = self
        
        txtName2.returnKeyType = UIReturnKeyType.done
        txtName.returnKeyType = UIReturnKeyType.done
        
        
        setDateToolBar()
        
        
        
        if isEdit == true {
            self.lblHeading.text = "edit twins"
            setData()
        }
        else {
            self.lblHeading.text = "add twins"
            self.txtDob.text = ""
            self.txtName.text = ""
            self.txtAge.text = ""
            
            self.txtDob2.text = ""
            self.txtName2.text = ""
            self.txtAge2.text = ""
            
        }
        
        if childCountIn > 1 {
           
            lblPrimium2.text = "Premium: \(getFormattedCurrency(amount: premiunAmount))"
            lblPrimium2.isHidden = true
            
          
            lblPrimium1.text = "Premium: \(getFormattedCurrency(amount: premiunAmount))"
            lblPrimium1.isHidden = true
            
        }else {
            lblPrimium1.isHidden = true
            lblPrimium2.isHidden = true
        }
        
        
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
    /*override func viewDidLayoutSubviews() {
     CATransaction.begin()
     CATransaction.setDisableActions(true)
     shapeLayer.frame = self.view.bounds
     CATransaction.commit()
     }*/
    
    @objc func handleNameTapped(_ sender : UITextField!) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    public func setData() {
        self.btnAdd.setTitle("save", for: .normal)

        // self.txtRelation.text = selectedObjFirst.relationname?.capitalizingFirstLetter()
        self.txtDob.text = selectedObjFirst.dateofBirth
        self.txtName.text = selectedObjFirst.personName
        
        self.btnMale.isUserInteractionEnabled = false
        self.btnFemale.isUserInteractionEnabled = false
        self.btnMale2.isUserInteractionEnabled = false
        self.btnFemale2.isUserInteractionEnabled = false

        
        if selectedObjFirst.gender?.lowercased() == "male" {
            selectedGenderFirst = 0
        }
        else {
            selectedGenderFirst = 1
        }
        
        if selectedObjSecond.gender?.lowercased() == "male" {
            selectedGenderSecond = 0
        }
        else {
            selectedGenderSecond = 1
        }
        
        self.setGender(selectedGender: selectedGenderFirst)
        self.setGenderSecond(selectedGender: selectedGenderSecond)
        
        
        if let age = Int(selectedObjFirst.age!)
        {
            firstChildAge = age
            
            if age > 1 {
                self.txtAge.text = String(age) + " yrs"
            }
            else {
                self.txtAge.text = String(age) + " yr"
            }
        }
        
        //self.txtRelation2.text = selectedObjSecond.relationname?.capitalizingFirstLetter()
        self.txtDob2.text = selectedObjSecond.dateofBirth
        self.txtName2.text = selectedObjSecond.personName
        
        if let age = Int(selectedObjSecond.age!)
        {
            secondChildAge = age
            
            if age > 1 {
                self.txtAge2.text = String(age) + " yrs"
            }
            else {
                self.txtAge2.text = String(age) + " yr"
            }
            
        }
        
        //Set First Date
        let dateStrch1 = selectedObjFirst.dateofBirth?.getStrDateEnrollment()
        if dateStrch1 != "" {
            self.txtDob.text = dateStrch1
        }
        else {
            self.txtDob.text = selectedObjFirst.dateofBirth
        }
        
        //Set Second Date
        let dateStrch2 = selectedObjSecond.dateofBirth?.getStrDateEnrollment()
        if dateStrch2 != "" {
            self.txtDob2.text = dateStrch2
        }
        else {
            self.txtDob2.text = selectedObjSecond.dateofBirth
        }
        
        
    }
    
    @IBAction func btnAddedTapped(_ sender: Any) {
        
        if validations(){
            
            //dismiss(animated: true, completion: nil)
            
           // if self.newTwinsDelegate != nil {
                
                var genderFirst = "Male"
                var relationFirst = "SON"
                if selectedGenderFirst == 0 {
                    genderFirst = "Male"
                    relationFirst = "SON"
                }
                else  {
                    genderFirst = "Female"
                    relationFirst = "DAUGHTER"

                }
               
                
                var genderSecond = "Male"
                var relationSecond = ""

                if selectedGenderSecond == 0 {
                    genderSecond = "Male"
                    relationSecond = "SON"
                }
                else {
                    genderSecond = "Female"
                    relationSecond = "DAUGHTER"
                }
               
                
                //let obj = DependantDBRecords.init(age: firstChildAge, cellPhoneNUmber: "", dateofBirth: self.txtDob.text, emailIDStr: "", empSrNo: nil, gender: genderFirst, isValid: nil, personName: txtName.text, personSrNo: nil, productCode: nil, relationID: nil, relationname: "twins", isEmpty: false,sortId: 5,twinPair:pairNumber)
                
                //let obj2 = DependantDBRecords.init(age: secondChildAge, cellPhoneNUmber: "", dateofBirth: self.txtDob2.text, emailIDStr: "", empSrNo: nil, gender: genderSecond, isValid: nil, personName: txtName2.text, personSrNo: nil, productCode: nil, relationID: nil, relationname: "twins", isEmpty: false,sortId: 5,twinPair:pairNumber)
                
                //let array = [obj,obj2]
                
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
                    
                    
                   

                
                    
                    if isEdit == true {
                        let child1RelationId = getRelationId(relation: relationFirst)
                        let child2RelationId = getRelationId(relation: relationSecond)
                        if child1RelationId != "0" && child1RelationId != "17" && child2RelationId != "0" && child2RelationId != "17" {
                            
                            let url1 = APIEngine.shared.getEditNewDependantJsonURL(Employeesrno: empSrNo, Relationid: child1RelationId, Personname: txtName.text!, Dateofmarriage: "", Windowperiodactive: "1", Grpchildsrno: groupChildSrNo, Oegrpbasinfosrno: oe_group_base_Info_Sr_No, Gender: genderFirst , IsTwins: "1", ParentalPremium: "0", Age: firstChildAge.description, Dateofbirth: txtDob.text!,personSRNo: selectedObjFirst.personSrNo!.description)
                            print(url1)
                            
                            
                            let url2 = APIEngine.shared.getEditNewDependantJsonURL(Employeesrno: empSrNo, Relationid: child2RelationId, Personname: txtName2.text!, Dateofmarriage: "", Windowperiodactive: "1", Grpchildsrno: groupChildSrNo, Oegrpbasinfosrno: oe_group_base_Info_Sr_No, Gender: genderSecond , IsTwins: "1", ParentalPremium: "0", Age: secondChildAge.description, Dateofbirth: txtDob.text!,personSRNo: selectedObjSecond.personSrNo!.description)
                            print(url2)
                            
                            editFirstDependantToServer(url1: url1, url2: url2, obj: DependantDBRecords())
                        }
                        else {
                            self.showAlert(message: "EMP ID Found")
                        }
                    }
                    else {
                        let child1RelationId = getRelationId(relation: relationFirst)
                        let child2RelationId = getRelationId(relation: relationSecond)
                        
                        if child1RelationId != "0" && child1RelationId != "17" && child2RelationId != "0" && child2RelationId != "17" {
                            let url1 = APIEngine.shared.getAddNewDependantJsonURL(Employeesrno: empSrNo, Relationid: child1RelationId, Personname: txtName.text!, Dateofmarriage: "", Windowperiodactive: "1", Grpchildsrno: groupChildSrNo, Oegrpbasinfosrno: oe_group_base_Info_Sr_No, Gender: genderFirst , IsTwins: "1", ParentalPremium: "0", Age: firstChildAge.description, Dateofbirth: txtDob.text!)
                            
                            
                            let url2 = APIEngine.shared.getAddNewDependantJsonURL(Employeesrno: empSrNo, Relationid: child2RelationId, Personname: txtName2.text!, Dateofmarriage: "", Windowperiodactive: "1", Grpchildsrno: groupChildSrNo, Oegrpbasinfosrno: oe_group_base_Info_Sr_No, Gender: genderSecond , IsTwins: "1", ParentalPremium: "0", Age: secondChildAge.description, Dateofbirth: txtDob2.text!)
                            
                            
                            addFirstDependantToServer(url1: url1, url2: url2, obj: DependantDBRecords())
                        }
                        else {
                            self.showAlert(message: "EMP ID Found")
                        }
                        
                    }
                }
           // }
        }
    }
    
    func getRelationId(relation:String) -> String {
       // if relation != "" {
           let array:Array<EnrollmentGroupRelations> = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: relation.uppercased())
           var relationId = "0"
           if array.count == 1 {
               relationId = array[0].relationID!
           }
           return relationId
       // }
       }
    
    private func validations() -> Bool {
        var empAge = 0
        let personArray : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: "GMC", relationName: "EMPLOYEE")
        if personArray.count>0{
            let personDict = personArray[0]
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .medium
            dateFormatter1.timeStyle = .none
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            let m_selectedDate = formatter.date(from: personDict.dateofBirth!)

            let serverDt = Date()
            let age = String(serverDt.years(from: m_selectedDate ?? Date()))
            empAge = Int(age)!
        }
        
        if(txtName.text=="")
        {
            txtName.errorMessage="Enter Name"
            return false
        }
//        else if(txtName.text != "")
//           {
//               for i in 0..<m_membersNameArrayST.count{
//                   if txtName.text?.lowercased() == m_membersNameArrayST[i].lowercased() {
//                       self.displayActivityAlert(title: "Dependant name cannot be similar")
//                       return false
//                   }
//               }
//               return true
//           }
        else if(txtDob.text=="")
        {
            txtName.errorMessage = ""
            txtDob.errorMessage="Select Date of Birth"
            return false
        }
        else if firstChildAge > empAge {
            displayActivityAlert(title: "Child age can not be greater than Employee")
            return false
        }
        else if(txtName2.text=="")
        {
            txtName.errorMessage = ""
            txtDob.errorMessage=""
            
            txtName2.errorMessage="Enter Name"
            return false
        }
        else if(txtName.text == txtName2.text)
        {
                    self.displayActivityAlert(title: "Dependant name cannot be similar")
                    return false
        }
//        else if(txtName2.text != "")
//           {
//               for i in 0..<m_membersNameArrayST.count{
//                   if txtName2.text?.lowercased() == m_membersNameArrayST[i].lowercased() {
//                       self.displayActivityAlert(title: "Dependant name cannot be similar")
//                       return false
//                   }
//               }
//               return true
//           }
        else if(txtDob2.text=="")
        {
            txtName.errorMessage = ""
            txtDob.errorMessage = ""
            txtName2.errorMessage = ""
            txtDob2.errorMessage="Select Date of Birth"
            return false
        }
        else if secondChildAge > empAge {
                displayActivityAlert(title: "Child age can not be greater than Employee")
                return false
        }
            
            
        else {
            
            let firstDob = txtDob.text!.convertStringToDate()
            let secondDob = txtDob2.text!.convertStringToDate()
            
            let days = self.daysBetweenDates(startDate: firstDob, endDate: secondDob)
            
            if days > 1 || days < -1 {
                
                
                self.displayActivityAlertWithSeconds(title: "Date of birth difference can not be more than one day",seconds: 3)
                
                return false
            }
            else {
                if(txtName.text != "" || txtName2.text != "")
                {
                    for i in 0..<m_membersNameArrayST.count{
                        if txtName.text?.lowercased() == m_membersNameArrayST[i].lowercased() || txtName2.text?.lowercased() == m_membersNameArrayST[i].lowercased(){
                            self.displayActivityAlert(title: "Dependant name cannot be similar")
                            return false
                        }
                    }
                    return true
                }
                return true
            }
        }
        
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int
    {
        
        // let components = calendar.current.dateComponents([.day], from: startDate, to: endDate, options: [])
        
        let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day
        
        
        return days!
    }
    
    
    
    
    
}

//MARK:- Server Call
extension AddTwinsVC {
    func addFirstDependantToServer(url1:String,url2:String,obj:DependantDBRecords) {
        if(isConnectedToNetWithAlert())
        {
            
            //self.showPleaseWait(msg: "")
            print(url1)
            let dict = ["":""]
            
            EnrollmentServerRequestManager.serverInstance.postDataToServer(url: url1, dictionary: dict as NSDictionary, view: self) { (data, error) in
                
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

                        if let jsonResult = data?.dictionary
                        {
                            print("addFirstDependantToServer Data Found")
                            
                            if let status = jsonResult["Status"]?.bool {
                                
                                if status == true
                                {
                                    self.addSecondDependantToServer(urlSec:url2,obj:DependantDBRecords())

                                }
                                else {
                                   print("First dependant can not be added..") //No Data found
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
        }
    }
    
    
    func addSecondDependantToServer(urlSec:String,obj:DependantDBRecords) {
        
        print("SECOND CHILD...")
        if(isConnectedToNetWithAlert())
        {
            
            let urlreq = NSURL(string : urlSec)
            
            //self.showPleaseWait(msg: "")
            print(urlSec)
            let dict = ["":""]
            
            EnrollmentServerRequestManager.serverInstance.postDataToServer(url: urlSec, dictionary: dict as NSDictionary, view: self) { (data, error) in
                
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
                        
                    
                        
                        if let jsonResult = data?.dictionary
                        {
                            print("add2ndDependantToServer Data Found")
                            
                            if let status = jsonResult["Status"]?.bool {
                                
                                if status == true
                                {
                                   // self.newDependantDelegate.newDependantAdded(position: self.position, data: obj)
                                    
                                    var array = [DependantDBRecords]()
                                    self.newTwinsDelegate?.twinsUpdated(positionFirst: 1, positionSecond: 2, dataArray: array, pairId: 1)
                                    self.dismiss(animated: true, completion: nil)
                                    
                                }
                                else {
                                    print("2nd dependant can not be added..")//No Data found
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
        }
        
        /*
         
         Optional({
           "Message" : "Dependant added successfully",
           "Status" : true
         })
         
         */
        
    }
    
    
    
    //EDIT
    func editFirstDependantToServer(url1:String,url2:String,obj:DependantDBRecords) {
        if(isConnectedToNetWithAlert())
        {
            
            //self.showPleaseWait(msg: "")
            print(url1)
            let dict = ["":""]
            
            EnrollmentServerRequestManager.serverInstance.postDataToServer(url: url1, dictionary: dict as NSDictionary, view: self) { (data, error) in
                
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
                        
                        if let jsonResult = data?.dictionary
                        {
                            print("editFirstDependantToServer Data Found")
                            if let msgDict = jsonResult["message"]?.dictionary {
                                if let status = msgDict["Status"]?.bool {
                                    
                                    if status == true
                                    {
                                        
                                        self.editSecondDependantToServer(urlSec: url2, obj: DependantDBRecords())
                                    }
                                    else {
                                        print("First dependant can not be edited..")//No Data found
                                    }
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
        }
    }
    
    /*
     Optional({
       "Update_Dependant_Data" : "1",
       "message" : {
         "Status" : true,
         "Message" : "DEPENDANT UPDATED SUCCESSFULLY"
       }
     })
     
     */
    
    func editSecondDependantToServer(urlSec:String,obj:DependantDBRecords) {
        
        print("SECOND CHILD...")
        if(isConnectedToNetWithAlert())
        {
            
            let urlreq = NSURL(string : urlSec)
            
            //self.showPleaseWait(msg: "")
            print(urlSec)
            let dict = ["":""]
            
            EnrollmentServerRequestManager.serverInstance.postDataToServer(url: urlSec, dictionary: dict as NSDictionary, view: self) { (data, error) in
                
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
                                                
                        if let jsonResult = data?.dictionary
                        {
                            print("edit2ndDependantToServ Data Found")
                            if let msgDict = jsonResult["message"]?.dictionary {
                            if let status = msgDict["Status"]?.bool {
                                
                                if status == true
                                {
                                   // self.newDependantDelegate.newDependantAdded(position: self.position, data: obj)
                                    let msg = msgDict["Message"]?.string
                                    self.displayActivityAlert(title: msg ?? "")
                                    var array = [DependantDBRecords]()
                                    
                                    self.dismiss(animated: true, completion: nil)
                                    self.newTwinsDelegate?.twinsUpdated(positionFirst: 1, positionSecond: 2, dataArray: array, pairId: 1)
                                    
                                }
                                else {
                                    print("2nd dependant can not be edited..")//No Data found
                                }
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
        }
        
        
        
    }
}


extension AddTwinsVC {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != txtName {
        if self.view.frame.origin.y == 0 {
            //moveTextField(textField, moveDistance: -150, up: true)
            self.view.frame.origin.y = -150
            }
        }
        else {
            self.view.frame.origin.y = 0

        }
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        // moveTextField(textField, moveDistance: 250, up: false)
        self.view.frame.origin.y = 0
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y = 0
        textField.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        //        if self.view.frame.origin.y == 0{
        //            self.view.frame.origin.y -= 200
        //         print("After Show",self.view.frame.origin.y)
        //        }
        
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        //        textField.setBorderToView(color: UIColor.white)
        if(textField.placeholder=="First Name + Last Name")
        {
            
            //if(txtName.text?.count==1)
            // {
            //m_nameTextfield.text = m_nameTextfield.text!.firstCharacterUpperCase()
            // txtName.autocapitalizationType = UITextAutocapitalizationType.sentences
            // txtName.textColor=UIColor.black
            // }
            
            
            let MAX_LENGTH_PHONENUMBER = 100
            let ACCEPTABLE_NUMBERS     = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        else if(textField.placeholder=="Age")
        {
            let MAX_LENGTH_PHONENUMBER = 2
            let ACCEPTABLE_NUMBERS     = "0123456789"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        
        return true
    }
}

//extension UIAlertController {
//
//    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
//        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//        alertWindow.rootViewController = UIViewController()
//        alertWindow.windowLevel = UIWindowLevelAlert + 1;
//        alertWindow.makeKeyAndVisible()
//        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
//    }
//
//}
