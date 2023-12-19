//
//  AddEditParentVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 25/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class AddEditParentVC: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate {

    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var m_relationTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var m_nameTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var m_dobTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var m_ageTextfield: SkyFloatingLabelTextField!

    
    @IBOutlet weak var m_premiumStatementLbl: UILabel!
    @IBOutlet weak var m_premiumCheckImageView: UIImageView!
    @IBOutlet weak var m_dobCheckImageView: UIImageView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var swipeIndicator: UIView!

    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    var textFields: [SkyFloatingLabelTextField]!

    
    let relationDropDown=DropDown()
    var m_gender = String()
    var m_membersArray = Array<String>()

    var m_membersRelationIdArray = Array<String>()
    var m_relationID = String()

    var m_dobNotAvailable = Bool()
    var m_isPremiumAccepted = Bool()
    
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    
    //For Already Added Emp
    var addedPersonDetailsArray = Array<PERSON_INFORMATION>()

    var relationStr = ""
    
    let datePicker: UIDatePicker = UIDatePicker()
    let agePicker = UIPickerView()

    let pickerView = ToolbarPickerView()
    //let ageArray = ["0", "1", "2", "3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20+"]

    let ageArray = Array(18..<100)
    var m_isUpdated = Bool()
    var m_arrayofParents = ["MOTHER","FATHER","MOTHER-IN-LAW","FATHER-IN-LAW"]

    //Send data back
    var newDependantDelegate:NewParentDependentAddedProtocol? = nil
    var position = 0
    
    //var selectedObj = ParentalRecords()
    var selectedObj : ParentalRecords?
    var isEdit = false

    var parentAge = 18
    
    var premiumAmount = ""
    var m_parentsNameArraySD = Array<String>()
    var refreshDelegate : refreshAfterDismiss? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        m_isPremiumAccepted = true
        print("#VDL - AddEditParents")
        print("All Members Name : \(self.m_parentsNameArraySD)")
        self.m_relationTextfield.text = relationStr
        m_nameTextfield.autocapitalizationType = UITextAutocapitalizationType.words

        self.m_nameTextfield.delegate = self

        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.clickedDOBCheckBox(_:)))
        m_dobCheckImageView.isUserInteractionEnabled=true
        m_dobCheckImageView.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.clickedPremiumCheckBox(_:)))
        m_premiumCheckImageView.isUserInteractionEnabled=true
        m_premiumCheckImageView.addGestureRecognizer(gesture1)

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        //shadowForCell(view: innerView)
        swipeIndicator.layer.cornerRadius = 3.0

        innerView.clipsToBounds = true
        innerView.layer.cornerRadius = 30
        if #available(iOS 11.0, *) {
            innerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        } // Top right corner, Top left corner respectively
        
        
        btnAdd.makeCicularWithMasks()
        btnAdd.layer.masksToBounds = true
        
        btnCancel.makeCicularWithMasks()
        btnCancel.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        btnCancel.layer.borderWidth = 2.0
        
        
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
                swipeGesture.direction = [.down]
        swipeGesture.delegate = self
        self.view.addGestureRecognizer(swipeGesture)

        
        self.m_ageTextfield.inputView = agePicker
        self.m_ageTextfield.inputView = self.pickerView
        self.m_ageTextfield.inputAccessoryView = self.pickerView.toolbar
        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.maximumDate = date

        let dateOld = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker.minimumDate = dateOld

        setDateToolBar()

        self.pickerView.dataSource = self as UIPickerViewDataSource
        self.pickerView.delegate = self as UIPickerViewDelegate
        self.pickerView.toolbarDelegate = self as ToolbarPickerViewDelegate
        self.pickerView.reloadAllComponents()

    if isEdit == true {
        self.lblHeading.text = "edit parent"

                setData()
            }
            else {
        self.lblHeading.text = "add parent"

                self.m_dobTextField.text = ""
                self.m_nameTextfield.text = ""
                self.m_ageTextfield.text = ""
                parentAge = 0
            }
        
        //let sleepStr = attributedText(withString: tempStr, boldString: "Tap here to check your weekly average.", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
        //self.lblSleep.attributedText = sleepStr
        
      // let completeStr = "₹ 4500/- will be deducted from your salary towards parental premium"
       // let attrStr = attributedText(withString: "₹ 4500/-", boldString: completeStr, font: UIFont.boldSystemFont(ofSize: 14.0))
        
       // m_premiumStatementLbl.attributedText = attrStr
        
        let priceStr = String(format: "₹ %@/-", premiumAmount)
        
        //"₹ 4500/-"
        let stringSteps = attributedText(withString: "\(priceStr) will be deducted from your salary towards parental premium", boldString: "\(priceStr)", font: UIFont(name: "Montserrat-Regular", size: 14.0)!)
        self.m_premiumStatementLbl.attributedText = stringSteps

        
        }
        
        private func setData() {
            self.btnAdd.setTitle("save", for: .normal)

            self.m_relationTextfield.text = selectedObj?.relation.capitalizingFirstLetter()
            self.m_nameTextfield.text = selectedObj?.name
            
            let dateStr = selectedObj?.dateOfBirth.getStrDateEnrollment()
            if dateStr != "" {
                self.m_dobTextField.text = dateStr
            }
            else {
                self.m_dobTextField.text = selectedObj?.dateOfBirth
            }

            
            
            if let age = selectedObj?.age
            {
            self.m_ageTextfield.text = String(age) + " yrs"
                parentAge = Int(age)!
                
              //  let dobDate = selectedObj.dateofBirth
            }
        }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
               self.view.endEditing(true)
                   dismiss(animated: true, completion: nil)
               }
    
    var isKeyboardAppear = false

      @objc func keyboardWillShow(notification: NSNotification) {
          print("Keyboard Show",self.view.frame.origin.y)
             if !isKeyboardAppear {
                 if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                     if self.view.frame.origin.y == 0{
                         self.view.frame.origin.y -= keyboardSize.height
                      print("After Show",self.view.frame.origin.y)

                     }
                 }
                 isKeyboardAppear = true
             }
         }
         
         @objc func keyboardWillHide(notification: NSNotification) {
          print("Keyboard Hide",self.view.frame.origin.y)

             if isKeyboardAppear {
                 if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                     if self.view.frame.origin.y < 0{
                         self.view.frame.origin.y = 0
                      print("After Hide",self.view.frame.origin.y)

                     }
                 }
                 isKeyboardAppear = false
             }
         }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if ((touch.view?.isDescendant(of: self.innerView))!){
            return false
        }
        return true
    }

    
    //MARK:- DOB Checkbox Tapped
    @objc func clickedDOBCheckBox(_ sender:UITapGestureRecognizer)
    {
        if(m_dobCheckImageView.image==UIImage(named: "blue checked box"))
        {
            m_dobCheckImageView.image=UIImage(named: "blue checkbox")
            m_dobTextField.isUserInteractionEnabled=true
            m_dobNotAvailable=false
            m_ageTextfield.isUserInteractionEnabled=false
            m_dobTextField.text=""
            self.m_ageTextfield.errorMessage = ""

            
        }
        else
        {
            m_dobTextField.isUserInteractionEnabled=false
            m_dobCheckImageView.image=UIImage(named: "blue checked box")
            m_dobNotAvailable=true
            m_ageTextfield.isUserInteractionEnabled=true
            m_dobTextField.text="-"
            self.m_dobTextField.errorMessage = ""
            
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- CheckBox Premium
    @objc func clickedPremiumCheckBox(_ sender:UITapGestureRecognizer)
    {
        self.m_premiumStatementLbl.textColor = UIColor.darkGray
        //uncommented by Pranit
        if(m_premiumCheckImageView.image==UIImage(named: "blue checked box"))
        {
            m_premiumCheckImageView.image=UIImage(named: "blue checkbox")
            m_isPremiumAccepted=false
        }
        else
        {
            m_isPremiumAccepted=true
            m_premiumCheckImageView.image=UIImage(named: "blue checked box")
        }
    }
    
    
    @IBAction func selectRelationButtonClicked(_ sender: Any)
       {
           view.endEditing(true)
           setupArrowDropDown(sender as! UIButton, at: 0)
           relationDropDown.show()
       }
    
    func setupArrowDropDown(_ selectButon: UIButton, at index: Int)
    {
        relationDropDown.anchorView = m_relationTextfield
        relationDropDown.bottomOffset = CGPoint(x: 0, y: 25)
        relationDropDown.width = m_relationTextfield.frame.size.width
        displayDropDownat(index: index)
        
    }
    
    //MARK:- Show DropDown
    func displayDropDownat(index:Int)
    {
        relationDropDown.dataSource = m_membersArray
        
        // Action triggered on selection
        relationDropDown.selectionAction =
            {
                [unowned self] (index, item) in
                if(self.m_membersRelationIdArray.count > index)
                {
                    self.m_relationID = self.m_membersRelationIdArray[index]
                    self.textFields[0].text=item
                    self.m_relationTextfield.text=item
                    self.m_relationTextfield.errorMessage=""
                    self.m_relationTextfield.textColor=UIColor.black
                    self.m_dobTextField.text=""
                    self.m_ageTextfield.text=""
                    self.m_nameTextfield.text=""
                    
                    
                    switch item
                    {
                   
                    case "FATHER" :
                        self.m_gender="MALE"
                        let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "FatherSumInsured")
                        if(dict.count>0)
                        {
                            if let fatherPremium = dict[0].value(forKey: "Premium")
                            {
                                if(fatherPremium as! String != "")
                                {
                                    let premium:String = (fatherPremium as? String)!
                                    self.m_premiumStatementLbl.text = "₹ " + premium + "/- will be deducted from your salary towards parental premium"
                                    //Added By Pranit
                                    self.m_premiumCheckImageView.isHidden = false
                                }
                            }
                        }
                        
                        
                        break
                    case "MOTHER" :
                        self.m_gender="FEMALE"
                        let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "MotherSumInsured")
                        if(dict.count>0)
                        {
                            if let fatherPremium = dict[0].value(forKey: "Premium")
                            {
                                if(fatherPremium as! String != "")
                                {
                                    let premium:String = (fatherPremium as? String)!
                                    self.m_premiumStatementLbl.text = "₹ " + premium + "/- will be deducted from your salary towards parental premium"
                                    //Added By Pranit
                                    self.m_premiumCheckImageView.isHidden = false
                                }
                            }
                        }
                        
                        break
                    case "FATHER-IN-LAW" :
                        self.m_gender="MALE"
                        let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "FatherInLawSumInsured")
                        if(dict.count>0)
                        {
                            if let fatherPremium = dict[0].value(forKey: "Premium")
                            {
                                if(fatherPremium as! String != "")
                                {
                                    let premium:String = (fatherPremium as? String)!
                                    self.m_premiumStatementLbl.text = "₹ " + premium + "/- will be deducted from your salary towards parental premium"
                                    //Added By Pranit
                                    self.m_premiumCheckImageView.isHidden = false
                                }
                            }
                        }
                        
                        break
                    case "MOTHER-IN-LAW" :
                        self.m_gender="FEMALE"
                        let dict = DatabaseManager.sharedInstance.retrieveParentalPremiumDetails(relation: "MotherInLawSumInsured")
                        if(dict.count>0)
                        {
                            if let fatherPremium = dict[0].value(forKey: "Premium")
                            {
                                if(fatherPremium as! String != "")
                                {
                                    let premium:String = (fatherPremium as? String)!
                                    self.m_premiumStatementLbl.text = "₹ " + premium + "/- will be deducted from your salary towards parental premium"
                                    //Added By Pranit
                                    self.m_premiumCheckImageView.isHidden = false
                                }
                            }
                        }
                        
                        break
                        
                    default :
                        break
                    }
                   // self.setAddDependantViewLayout()
                }
                else
                {
                    
                   // self.getRelationsfromServer()
                    
                }
                
        }
    }

//    private func validations() -> Bool {
//
//        else {
//            checkValidations()
//        }
//
//    }
    
    private func getEmployeeAge() -> Int {
        
        let array : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
        let personArray : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "EMPLOYEE")
        if(array.count>0)
        {
            
            let dict = array[0]
            let personDict = personArray[0]
            let age = personDict.age
            
            return Int(age)
        }
        
        return 18
        
    }
    
    private func checkValidations()
    {
           if(m_nameTextfield.text=="")
             {
                 m_nameTextfield.errorMessage="Enter Name"
             }

            else {
                    m_nameTextfield.errorMessage = ""
                    if(m_isUpdated) //edit
                    {
                        
                            if(m_dobNotAvailable)
                            {
                                let age = String(parentAge.description)
                                    if age != "" {
                                        let ageInt = Int(age)
                                        
                                        if ageInt! < getEmployeeAge() {
                                            displayActivityAlert(title: "Parent age cannot be less than employee")
                                        }
                                        else if(m_isPremiumAccepted)
                                        {
                                            //updateDependantDetails(indexpath: IndexPath(row: sender.tag, section: 0))
                                        }
                                        else
                                        {
                                            //displayActivityAlert(title: "Please check all disclaimers!!!")
                                            self.m_premiumStatementLbl.textColor = UIColor.red
                                        }
                                    }
                                    else {
                                        //please enter age
                                        print("Enter Age")
                                        m_ageTextfield.errorMessage = "Select Age"
                                        m_dobTextField.errorMessage = ""
                                    }
                            }
                            else {
                                print("Edit Dependant")
                                if(m_isPremiumAccepted){
                                    //updateDependantDetails(indexpath: IndexPath(row: sender.tag, section: 0))
                                }
                                else{
                                    //displayActivityAlert(title: "Please check all disclaimers!!!")
                                    self.m_premiumStatementLbl.textColor = UIColor.red
                                }
                            }
                            
                        }
                    //End
                    
            else
            { //Add
                let maxAge = calculateMaxAge()
                if(maxAge != "")
                {
                    print("maxAge is NOT Empty\(maxAge)")
                   
                        //Added By Pranit
                        m_isPremiumAccepted = true
                        if(m_dobNotAvailable)
                        {
                            let age = String(parentAge)
                                if age != "" {
                                    let ageInt = Int(age)
                                    if ageInt! < getEmployeeAge() {
                                        
                                        displayActivityAlert(title: "Parent age cannot be less than employee")
                                    }
                                    else if(m_isPremiumAccepted)
                                    {
                                        var flag = 0
                                       // if !isEdit{
                                            var ischeck = 0
                                            if(m_nameTextfield.text != "")
                                            {
                                                for i in 0..<m_parentsNameArraySD.count{
                                                    if m_nameTextfield.text?.lowercased() == m_parentsNameArraySD[i].lowercased() {
                                                        self.displayActivityAlert(title: "Parent name cannot be similar")
                                                        ischeck = ischeck + 1
                                                        break
                                                    }
                                                    
                                                }
                                                if ischeck == 0 {
                                                    addDependant()
                                                }
                                             }
//                                        }else{
//                                            var ischeck = 0
//                                            if(m_nameTextfield.text != "")
//                                            {
//                                                for i in 0..<m_parentsNameArraySD.count{
//                                                    if m_nameTextfield.text?.lowercased() == m_parentsNameArraySD[i].lowercased() {
//                                                        self.displayActivityAlert(title: "Parent name cannot be similar")
//                                                        ischeck = ischeck + 1
//                                                        break
//                                                    }
//
//                                                }
//                                                if ischeck > 1 {
//                                                    addDependant()
//                                                }
//                                             }
//                                        }
                                        
                                        //addDependant()
                                    }
                                    else
                                    {
                                        //displayActivityAlert(title: "Please check all disclaimers!!!")
                                        self.m_premiumStatementLbl.textColor = UIColor.red
                                    }
                                }
                                else {
                                    //please enter age
                                    print("Enter Age")
                                    m_ageTextfield.errorMessage = "Select Age"
                                    m_dobTextField.errorMessage = ""

                                }
                            
                        }
                        else {
                            print("Know Dob\(m_dobTextField.text)")
                            
                            if m_dobTextField.text == "" {
                                m_dobTextField.errorMessage = "Select Date of Birth"
                            }
                            else {
                                
                            let selectedDOBDate = convertMMMStringToDate(dateString: m_dobTextField.text!)
                                           let calculatedAge = calculateAge(selectedDate: selectedDOBDate)
                                           if(calculatedAge<0)
                                           {
                                               displayActivityAlert(title: "Age should be Zero or greater than Zero")
                                           }
                                            
                                            
                                
                                           else if(calculatedAge > maxAge.intValue)
                                           {
                                               displayActivityAlert(title: "Age should be below \(maxAge)")
                                           }
                                            
                                            else if calculatedAge < getEmployeeAge()
                                            {
                                                 displayActivityAlert(title: "Parent age cannot be less than employee")

                                            }
                                            
                                           else {
                            print("Add Dependant")
                                            m_isPremiumAccepted = true
                            if(m_isPremiumAccepted)
                            {
                                //addDependant()
                                var ischeck = 0
                                   if(m_nameTextfield.text != "")
                                   {
                                       for i in 0..<m_parentsNameArraySD.count{
                                           if m_nameTextfield.text?.lowercased() == m_parentsNameArraySD[i].lowercased() {
                                               self.displayActivityAlert(title: "Parent name cannot be similar")
                                               ischeck = ischeck + 1
                                               break
                                           }
                                           
                                       }
                                       if ischeck == 0 {
                                           addDependant()
                                       }
                                    }
                            }
                            else
                            {
                                //displayActivityAlert(title: "Please check all disclaimers!!!")
                                self.m_premiumStatementLbl.textColor = UIColor.red
                            }
                                }
                        }
                        
                    }
                        //End
                      
                }
                else
                { //maxAge == ""
                   print("maxAge is EMPTY")
                        if(m_dobNotAvailable)
                        {
                            print("don't know DOB")
                             let age = String(parentAge)
                                if age != "" {
                                    let ageInt = Int(age)
                                    if ageInt! < getEmployeeAge() {
                                        displayActivityAlert(title: "Age should be greater than 18")
                                        //m_ageTextfield.errorMessage = "Age should be greater than 18"
                                        
                                    }
                                    else if(m_isPremiumAccepted)
                                    {
                                        //addDependant()
                                        var ischeck = 0
                                           if(m_nameTextfield.text != "")
                                           {
                                               for i in 0..<m_parentsNameArraySD.count{
                                                   if m_nameTextfield.text?.lowercased() == m_parentsNameArraySD[i].lowercased() {
                                                       self.displayActivityAlert(title: "Parent name cannot be similar")
                                                       ischeck = ischeck + 1
                                                       break
                                                   }
                                                   
                                               }
                                               if ischeck == 0 {
                                                   addDependant()
                                               }
                                            }
                                    }
                                    else
                                    {
                                        //displayActivityAlert(title: "Please check all disclaimers!!!")
                                        self.m_premiumStatementLbl.textColor = UIColor.red
                                    }
                                }
                                else {
                                    //please enter age
                                    print("Enter Age")
                                    m_ageTextfield.errorMessage = "Select Age"
                                    m_dobTextField.errorMessage = ""
                                }
                            
                            
                        }
                        else {
                            print("know DOB")

                            if m_dobTextField.text == "" {
                                m_dobTextField.errorMessage = "Select Date of Birth"
                            }
                            else {
                            print("Add Dependant")
                                //added for to disable validations
                                m_isPremiumAccepted = true
                            if(m_isPremiumAccepted)
                            {
                               // addDependant()
                                var ischeck = 0
                                   if(m_nameTextfield.text != "")
                                   {
                                       for i in 0..<m_parentsNameArraySD.count{
                                           if m_nameTextfield.text?.lowercased() == m_parentsNameArraySD[i].lowercased() {
                                               self.displayActivityAlert(title: "Parent name cannot be similar")
                                               ischeck = ischeck + 1
                                               break
                                           }
                                           
                                       }
                                       if ischeck == 0 {
                                           addDependant()
                                       }
                                    }
                            }
                            else
                            {
                                
                                //displayActivityAlert(title: "Please check all disclaimers!!!")
                                self.m_premiumStatementLbl.textColor = UIColor.red
                            }
                            }
                        }
                        
                }
                
            }
            
        }
    }
    
    
    private func addDependant() {
        /*
        if newDependantDelegate != nil {
            self.dismiss(animated: true, completion: nil)

        let obj = ParentalRecords.init(age: parentAge, cellPhoneNUmber: "", dateofBirth: self.m_dobTextField.text, emailIDStr: "", empSrNo: nil, gender: "", isValid: nil, personName: m_nameTextfield.text, personSrNo: nil, productCode: nil, relationID: nil, relationname: m_relationTextfield.text!, isEmpty: false,premiumAmount: 1575)
        //self.newDependantDelegate?.newDependantAdded(position: position, data: obj)
        }
        */
        
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
            
           // let parameterDic = ["age":finalAge.description,"dateofbirth":txtDob.text!, "employeesrno":empSrNo, "relationid":self.selectedObj.relationID!,"personname":txtName.text!, "dateofmarriage":"","windowperiodactive" :"1", "grpchildsrno" :groupChildSrNo,"oegrpbasinfosrno" :oe_group_base_Info_Sr_No] as [String : Any]
           // self.addNewDependantToServer(parameter: parameterDic as NSDictionary)
            
            var gender = "Male"
            
            if (self.selectedObj?.relation.lowercased().contains("father"))! {
                gender = "Male"
            }
            else {
                gender = "Female"
            }
            
            if isEdit == false {
                let url = APIEngine.shared.getAddNewDependantJsonURL(Employeesrno: empSrNo, Relationid: (self.selectedObj?.relationID.description)!, Personname: m_nameTextfield.text!, Dateofmarriage: "", Windowperiodactive: "1", Grpchildsrno: groupChildSrNo, Oegrpbasinfosrno: oe_group_base_Info_Sr_No, Gender: gender , IsTwins: "0", ParentalPremium: "0", Age: parentAge.description, Dateofbirth: m_dobTextField.text!)
            print(url)
            self.addDepedant()
            //addNewDependantToServer(url:url, obj: ParentalRecords())
            }
            else {
                let url = APIEngine.shared.getEditNewDependantJsonURL(Employeesrno: empSrNo, Relationid: (self.selectedObj?.relationID.description)!, Personname: m_nameTextfield.text!, Dateofmarriage: "", Windowperiodactive: "1", Grpchildsrno: groupChildSrNo, Oegrpbasinfosrno: oe_group_base_Info_Sr_No, Gender: gender , IsTwins: "0", ParentalPremium: "0", Age: parentAge.description, Dateofbirth: m_dobTextField.text!,personSRNo: self.selectedObj?.personSrNo.description ?? "")
                print(url)
                self.updateDepedant()
              //  editNewDependantToServer(url:url, obj: ParentalRecords())
            }
        }
    }
    
    func updateDepedant(){
        if isConnectedToNetWithAlert(){
            m_gender = "MALE"
            if isEdit == true{
                let appendUrl = "UpdateDependant?Personsrno=\(selectedObj!.personSrNo)&Age=\(parentAge)&Dependantname=\(m_nameTextfield.text!)&Dateofbirth=\(m_dobTextField.text!)&RelationId=\(selectedObj!.relationID)&Gender=\(m_gender)"
                var dict : [String:Any] = [:]
                DispatchQueue.main.async{
                    webServices().postDataForEnrollment(appendUrl, dict, completion: { (data,error) in
                        if error == ""{
                            DispatchQueue.main.async{
                                self.dismiss(animated: true, completion: {
                                
                                    self.refreshDelegate?.refreshData("dismiss")
                                        
                                })
                                
                                
                            }
                            
                        }else{
                            self.showAlert(message: error)
                        }
                        
                    })
                }
                
            }
            else{
                print("False::")
            }
            /*else{
                
                let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
                
                m_employeedict=userArray[0]
                
                var oe_group_base_Info_Sr_No = String()
                var groupChildSrNo = String()
                var empSrNo = String()
                
                if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
                {
                    oe_group_base_Info_Sr_No = "1047"//String(empNo)
                }
                if let groupChlNo = m_employeedict?.groupChildSrNo
                {
                    groupChildSrNo = "1024"//String(groupChlNo)
                }
                if let empsrno = m_employeedict?.empSrNo
                {
                    empSrNo = "61787"//String(empsrno)
                }
                let appendUrl = "AddDependant?Employeesrno=\(empSrNo)&Relationid=21&Personname=\(txtName.text!)&Dateofmarriage=&Windowperiodactive=1&Grpchildsrno=\(groupChildSrNo)&Oegrpbasinfosrno=\(oe_group_base_Info_Sr_No)&Gender=\(globalGender)&IsTwins=0&ParentalPremium=0&Age=\(txtAge.text!)&Dateofbirth=\(txtDOB.text!)"
                var dict : [String:Any] = [:]
                DispatchQueue.main.async{
                    webServices().postDataForEnrollment(appendUrl, dict, completion: { (data,error) in
                        if error == ""{
                            DispatchQueue.main.async{
                                self.formViewForDependent.isHidden = true
                            }
                            self.getStructureDataForDependentDetails()
                        }else{
                            self.showAlert(message: error)
                        }
                        
                    })
                }
            }*/
        }
        
    }
  
    func addDepedant(){
        if isConnectedToNetWithAlert(){
            m_gender = "MALE"
            if isEdit == false{
                let appendUrl = "AddDependant?Employeesrno=61787&Relationid=\(selectedObj!.relationID)&Personname=\(m_nameTextfield.text!)&Dateofmarriage=&Windowperiodactive=1&Grpchildsrno=1024&Oegrpbasinfosrno=1047&Gender=Male&IsTwins=0&ParentalPremium=0&Age=80&Dateofbirth=\(m_dobTextField.text!)"
                //"UpdateDependant?Personsrno=\(selectedObj!.personSrNo)&Age=\(parentAge)&Dependantname=\(m_nameTextfield.text!)&Dateofbirth=\(m_dobTextField.text!)&RelationId=\(selectedObj!.relationID)&Gender=\(m_gender)"
                var dict : [String:Any] = [:]
                DispatchQueue.main.async{
                    webServices().postDataForEnrollment(appendUrl, dict, completion: { (data,error) in
                        if error == ""{
                            DispatchQueue.main.async{
                                self.dismiss(animated: true, completion: {
                                    self.refreshDelegate?.refreshData("dismiss")
                                })
                            }
                        }else{
                            self.showAlert(message: error)
                        }
                        
                    })
                }
                
            }
            else{
                print("False::")
            }
        }
        
    }
  
    func calculateAge(selectedDate:Date)->Int
    {
        let gregorian = Calendar(identifier: .gregorian)
        let ageComponents = gregorian.dateComponents([.year], from: selectedDate, to: m_serverDate)
        let age = ageComponents.year!
        print(age)
        return age
    }
    
    func calculateMaxAge()->NSString
    {
        /*
        if(m_relationTextfield.text=="SON")
        {
            let array : [EnrollmentGroupRelations] = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation:"SON")
            if((array.count)>0)
            {
                
                let maxAge : NSString = array[0].maxAge! as NSString
                
                return maxAge
            }
            
        }
        else if(m_relationTextfield.text=="DAUGHTER")
        {
            let array : [EnrollmentGroupRelations] = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation:"DAUGHTER")
            if((array.count)>0)
            {
                
                let maxAge : NSString = array[0].maxAge! as NSString
                return maxAge
                
            }
        }
        else if(m_relationTextfield.text=="FATHER")
        {
            let array : [EnrollmentGroupRelations] = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation:"FATHER")
            if((array.count)>0)
            {
                
                let maxAge : NSString = array[0].maxAge! as NSString
                return maxAge
                
            }
        }
        else if(m_relationTextfield.text=="MOTHER")
        {
            let array : [EnrollmentGroupRelations] = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation:"MOTHER")
            if((array.count)>0)
            {
                
                let maxAge : NSString = array[0].maxAge! as NSString
                return maxAge
                
            }
        }
        else if(m_relationTextfield.text=="WIFE"||m_relationTextfield.text=="HUSBAND")
        {
            
            let maxAge : NSString = "100" as NSString
            return maxAge
            
        }
 */
        return ""
    }
    
    var m_productCode = String()

    //API -/ Get Data
    func getPersonDetails()
    {
        addedPersonDetailsArray=[]
        m_membersRelationIdArray=[]
        m_membersArray=[]
        m_productCode="GMC"
        
       
        
        
        let fatherarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "FATHER")
        if(fatherarray.count>0)
        {
            addedPersonDetailsArray.append(fatherarray[0])
        }
        let motherarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "MOTHER")
        if(motherarray.count>0)
        {
            addedPersonDetailsArray.append(motherarray[0])
        }
        let fatherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "FATHER-IN-LAW")
        if(fatherInLawarray.count>0)
        {
            addedPersonDetailsArray.append(fatherInLawarray[0])
        }
        let motherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "MOTHER-IN-LAW")
        if(motherInLawarray.count>0)
        {
            addedPersonDetailsArray.append(motherInLawarray[0])
        }
        
        print(addedPersonDetailsArray)
       // getRelationsfromServer()
        
        
        print(m_membersArray,m_membersRelationIdArray,addedPersonDetailsArray)
        
        
        
        }
    
    @IBAction func addTapped(_ sender: Any) {
          checkValidations()
      }
      
      func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
             let attributedString = NSMutableAttributedString(string: string,
                                                              attributes: [NSAttributedString.Key.font: font])
             let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
             let range = (string as NSString).range(of: boldString)
             attributedString.addAttributes(boldFontAttribute, range: range)
        
             return attributedString
         }
    
    }
    
  



extension AddEditParentVC {
    private func setDateToolBar()
    {
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = self.hexStringToUIColor(hex: hightlightColor)
        toolBar.backgroundColor = UIColor.white

        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        m_dobTextField.inputAccessoryView = toolBar
        
        datePicker.datePickerMode = UIDatePickerMode.date
        
//        if m_relationTextfield.text?.lowercased() == "wife" || m_relationTextfield.text?.lowercased() == "husband" {
//            let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
//            datePicker.maximumDate = date
//
//        }
//
//        else {
//            datePicker.maximumDate = Date()
//
//        }
        
        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.maximumDate = date
        
        let datemin = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker.minimumDate = datemin

        /*
        let array:Array<EnrollmentGroupRelations> = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: (m_relationTextfield.text?.uppercased())!)
                            var minAge = "0"
                            var maxAge = "0"
                            if array.count > 0 {
                                if array[0].minAge! != "" {
                                    minAge = array[0].minAge!
                                    let date = Calendar.current.date(byAdding: .year, value: -(Int(minAge)!), to: Date())
                                    datePicker.maximumDate = date
                                }
                                 if array[0].maxAge! != "" {
                                    maxAge = array[0].maxAge!
                                    let datemin = Calendar.current.date(byAdding: .year, value: -(Int(maxAge)!), to: Date())
                                    datePicker.minimumDate = datemin

                                }
                              
                            }
                            else {
        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.maximumDate = date
        
        let datemin = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        datePicker.minimumDate = datemin
        }
        */
        
        //Set Previous Date
               if isEdit == true {
                   let oldDate = selectedObj?.dateOfBirth.getSimpleDate() ?? Date()
                   self.datePicker.setDate(oldDate, animated: false)
               }
        
        self.m_dobTextField.inputView = datePicker
        //self.m_dobTextField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)

    }
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        
        let formatter = DateFormatter()
              formatter.dateFormat = "dd-MMM-yyyy"
              
              
              
              m_dobTextField.text = formatter.string(from: datePicker.date)
        
       // m_dobTextField.text = dateFormatter1.string(from: datePicker.date)
        
       // let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
      //  let m_selectedDate = datePicker.date
      //  let dateString = dateFormatter1.string(from: datePicker.date)
      //  print(dateString)
        
        let serverDt = Date()

        self.m_ageTextfield.text = String(serverDt.years(from: datePicker.date)) + " yrs"
        parentAge = serverDt.years(from: datePicker.date)
        m_dobTextField.resignFirstResponder()
        
        
    }
    @objc func cancelClick() {
        m_dobTextField.resignFirstResponder()
    }

}


//AGE PICKER VIEW
extension AddEditParentVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.ageArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(self.ageArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // self.txtCigarette.text = self.cigratteArray[row]
    }
}

extension AddEditParentVC: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        
        
        if m_ageTextfield.isFirstResponder == true {
                self.m_ageTextfield.text = String(format: "%@", String(self.ageArray[row])) + " yrs"
                parentAge = self.ageArray[row]
                    
            self.m_ageTextfield.resignFirstResponder()
        }
        
        
        
    }
    
    func didTapCancel() {
        //self.txtCigarette.text = nil
        self.m_ageTextfield.resignFirstResponder()
    }
}


//MARK:- Server Call
extension AddEditParentVC {
    
    /*
     {
       "Update_Dependant_Data" : "1",
       "message" : {
         "Status" : true,
         "Message" : "DEPENDANT UPDATED SUCCESSFULLY"
       }
     }
     */
    private func addNewDependantToServer(url:String,obj:ParentalRecords) {
        if(isConnectedToNetWithAlert())
        {
                 let urlreq = NSURL(string : url)
                
                //self.showPleaseWait(msg: "")
                print(url)
                let dict = ["":""]
                
                EnrollmentServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: dict as NSDictionary, view: self) { (data, error) in
                    
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
                            
                           // if let jsonResult = data?.dictionary
                           // {
                                print("addDependantsToServer Data Found")
                           // if let msgDict = data?["message"].dictionary
                          //  {
                            if let status = data?["Status"].bool {
                                    
                                        if status == true
                                        {
                                             self.newDependantDelegate?.newDependantAdded(position: self.position, data: obj)
                                            self.dismiss(animated: true, completion: nil)

                                        }
                                        else {
                                            if let msg = data?["Message"].string {
                                            self.displayActivityAlert(title: msg)
                                            }
                                            //No Data found
                                      //  }
                                    }//status
                           // }//jsonResult
                        }//do
                            else {
                                if let errorDict = data?["message"].dictionary {
                                    if let msg = errorDict["Message"]?.string {
                                    self.displayActivityAlert(title: msg)
                                    }
                                }
                            }
                        }
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
        }
    }
    
    
    private func editNewDependantToServer(url:String,obj:ParentalRecords) {
        if(isConnectedToNetWithAlert())
        {
                 let urlreq = NSURL(string : url)
                
                //self.showPleaseWait(msg: "")
                print(url)
                let dict = ["":""]
                
                EnrollmentServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: dict as NSDictionary, view: self) { (data, error) in
                    
                    if error != nil
                    {
                        print("error ",error!)
                        //self.hidePleaseWait()
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        // self.hidePleaseWait()
                        print("found editNewDependantsToServer....")

                        /*
                        do {
                            print(data)
                            
                            if let jsonResult = data as? NSDictionary
                            {

                                    if let status = jsonResult.value(forKey: "Update_Dependant_Data") as? String {
                                    
                                        if status == "1"
                                        {
                                            self.newDependantDelegate?.newDependantAdded(position: self.position, data: obj)

                                        }
                                        else {
                                            if let msg = jsonResult.value(forKey: "Message") as? String {
                                            self.displayActivityAlert(title: msg)
                                            }
                                            //No Data found
                                        }
                                    }//status
                            }//jsonResult
                        }//do
                            */
                        do {
                            print(data)
                            
                           // if let jsonResult = data?.dictionary
                           // {
                                print("editDependantsToServer Data Found")
                            if let msgDict = data?["message"].dictionary
                            {
                                if let status = msgDict["Status"]?.bool {
                                    
                                        if status == true
                                        {
                                            self.newDependantDelegate?.newDependantAdded(position: self.position, data: obj)
                                            self.dismiss(animated: true, completion: nil)

                                        }
                                        else {
                                            if let msg = msgDict["Message"]?.string {
                                            self.displayActivityAlert(title: msg)
                                            }
                                            //No Data found
                                      //  }
                                    }//status
                            }//jsonResult
                        }//do
                        }
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
        }
    }
    


}
