//
//  AddNewDependantVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 06/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

protocol NewDependentAddedProtocol {
    func newDependantAdded(position:Int,data:DependantDBRecords)
}

protocol NewParentDependentAddedProtocol {
    func newDependantAdded(position:Int,data:ParentalRecords)
}

protocol TwinsAddedProtocol {
    func newTwinsAdded(position:Int,dataArray:[DependantDBRecords])
    func twinsUpdated(positionFirst:Int,positionSecond:Int,dataArray:[DependantDBRecords],pairId:Int)
}

class AddNewDependantVC: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblPrimium: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var swipeIndicator: UIView!
    
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var txtDob: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtAge: SkyFloatingLabelTextField!
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtRelation: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var heightOfGenderView: NSLayoutConstraint!
    
    @IBOutlet weak var bottomViewConstraints: NSLayoutConstraint!
    
    var newDependantDelegate:NewDependentAddedProtocol? = nil
    
    var relationStr = ""
    var position = 0
    var childCountIn = 0
    var premiunAmount = String()
    var selectedObj = DependantDBRecords()
    var isEdit = false
    var m_membersNameArraySD = Array<String>()
    var selectedGender = 0 //0-male, 1-Female, 2-Other
    
    let datePicker: UIDatePicker = UIDatePicker()

    var sortId = 0
    
    var finalAge = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        print("#VDL - Add new dependant")
        print("All Members Name : \(self.m_membersNameArraySD)")

            if relationStr.lowercased() == "partner" {
                self.heightOfGenderView.constant = 50
                self.bottomViewConstraints.constant = 390
                
                if m_spouse.lowercased() == "wife" {
                    selectedGender = 1
                }
                else {
                    selectedGender = 0
                }
                setGender(selectedGender: selectedGender)
                stackView.isHidden = false
                
            }
            else {
                self.heightOfGenderView.constant = 0
                stackView.isHidden = true
                self.bottomViewConstraints.constant = 350
            }
              
        
        txtRelation.text = relationStr.capitalizingFirstLetter()
        view.backgroundColor = .clear
        backView.backgroundColor = .clear
        swipeIndicator.layer.cornerRadius = 3.0
        txtName.delegate = self
        
        txtName.autocapitalizationType = UITextAutocapitalizationType.words
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 30
        if #available(iOS 11.0, *) {
            bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        } // Top right corner, Top left corner respectively
        
        
        btnAdd.makeCicular()
        btnAdd.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapGesture.delegate = self
        self.backView.addGestureRecognizer(tapGesture)
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipeGesture.direction = [.down]
        swipeGesture.delegate = self
        self.backView.addGestureRecognizer(swipeGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        //Add gesture on textfield
        //let textTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDOBTap(_:)))
        //self.txtDob.addGestureRecognizer(tapGesture)

        setDateToolBar()
        
        btnCancel.makeCicularWithMasks()
        btnCancel.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        btnCancel.layer.borderWidth = 2.0
        
        if isEdit == true {
            self.lblHeading.text = "edit dependant"
            setData()
        }
        else {
            self.lblHeading.text = "add new dependant"
            self.txtDob.text = ""
            self.txtName.text = ""
            self.txtAge.text = ""
        }
        
        if childCountIn > 1 {
            lblPrimium.text = "Premium: \(getFormattedCurrency(amount: premiunAmount))"
            lblPrimium.isHidden = true
        }else {
            lblPrimium.isHidden = true
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
    private func setData() {
        
        self.btnAdd.setTitle("save", for: .normal)
        self.txtRelation.text = selectedObj.relation?.capitalizingFirstLetter()
        //selectedObj.relation?.capitalizingFirstLetter()
        self.txtName.text = selectedObj.personName

        let dateStr = selectedObj.dateofBirth?.getStrDateEnrollment()
        if dateStr != "" {
            self.txtDob.text = dateStr
        }
        else {
            self.txtDob.text = selectedObj.dateofBirth
        }
        
        if let age = Int(selectedObj.age!)
        {
            if age > 1 {
                self.txtAge.text = String(age) + " yrs"
            }
            else {
                self.txtAge.text = String(age) + " yr"
            }
            self.finalAge = age
        }
        
        if selectedObj.gender?.lowercased() == "male" {
            selectedGender = 0
        }
        else if selectedObj.gender?.lowercased() == "female" {
            selectedGender = 1
        }
        else {
            selectedGender = 2
        }
        
        setGender(selectedGender: selectedGender)
        
        
    }
    

    
    @objc func myTargetFunction(textField: UITextField) {
        print("myTargetFunction")
        //addDatePicker()
    }

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if ((touch.view?.isDescendant(of: self.bottomView))!){
            return false
        }
        return true
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += 100
//            }
//        }
//    }
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
    
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDOBTap(_ sender: UITapGestureRecognizer) {
   
            self.view.endEditing(true)
            print("Select DOB")
        //addDatePicker()
        }
    
    //MARK:- Button Outlet Actions
    
    @IBAction func btnAddedTapped(_ sender: Any) {
        
        if validations(){
            
            //dismiss(animated: true, completion: nil)
            
            if self.newDependantDelegate != nil {
                
                var gender = selectedObj.gender?.capitalizingFirstLetter()
                
                if selectedObj.relation?.uppercased() == "partner".uppercased() {
                if selectedGender == 0 {
                    gender = "Male"
                }
                else if selectedGender == 1 {
                    gender = "Female"
                }
                else {
                    gender = "Other"
                }
                }
                
               // let obj = DependantDBRecords.init(age: finalAge, cellPhoneNUmber: "", dateofBirth: self.txtDob.text, emailIDStr: "", empSrNo: nil, gender: gender, isValid: nil, personName: txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines), personSrNo: nil, productCode: nil, relationID: nil, relationname: txtRelation.text!, isEmpty: false,sortId: sortId)
                
                let obj = DependantDBRecords.init(srNo: sortId, personName: txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines), relation: txtRelation.text!, gender: gender, relationID: nil, age: String(finalAge), dateofBirth: self.txtDob.text, personSrNo: nil,  productCode: nil,  isAdded: false, cellPhoneNUmber: "", emailIDStr: "", empSrNo: nil, isValid: nil)
                
                /*{
                "age" :"28",
                "dateofbirth" :"04/04/2000",
                "employeesrno" :"34080",
                "relationid" :"3",
                "personname" :"Rajeev",
                "dateofmarriage" :"",
                "windowperiodactive" :"1",
                "grpchildsrno" :"1201",
                "oegrpbasinfosrno" :"638"
                }*/
                
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
                    
                    if isEdit == false {
                        if (Int(selectedObj.relationID!) != 0 && Int(selectedObj.relationID!) != 17 ){
                            let url = APIEngine.shared.getAddNewDependantJsonURL(Employeesrno: empSrNo, Relationid: self.selectedObj.relationID!.description, Personname: txtName.text!, Dateofmarriage: "", Windowperiodactive: "1", Grpchildsrno: groupChildSrNo, Oegrpbasinfosrno: oe_group_base_Info_Sr_No, Gender: gender ?? "Male", IsTwins: "0", ParentalPremium: "0", Age: finalAge.description, Dateofbirth: txtDob.text!)
                            print(url)
                    
                            addNewDependantToServer(url:url, obj: obj)
                        }
                        else {
                            self.showAlert(message: "AddNewDep=17")
                        }
                    }
                    else {
                        if (Int(selectedObj.relationID!) != 0 && Int(selectedObj.relationID!) != 17 ){

                            let url = APIEngine.shared.getEditNewDependantJsonURL(Employeesrno: empSrNo, Relationid: self.selectedObj.relationID!.description, Personname: txtName.text!, Dateofmarriage: "", Windowperiodactive: "1", Grpchildsrno: groupChildSrNo, Oegrpbasinfosrno: oe_group_base_Info_Sr_No, Gender: gender ?? "Male", IsTwins: "0", ParentalPremium: "0", Age: finalAge.description, Dateofbirth: txtDob.text!,personSRNo: self.selectedObj.personSrNo?.description ?? "")
                            print(url)
                        
                            addNewDependantToServer(url:url, obj: obj)
                        }
                        else {
                            self.showAlert(message: "AddNewDep=17")
                        }
                        
                    }
                }
                
            }
        }
    }
    
    
    private func validations() -> Bool {
        if(txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            txtName.errorMessage="Enter Name"
            return false
        }
//        else if(txtName.text != "")
//           {
//               for i in 0..<m_membersNameArraySD.count{
//                   if txtName.text?.lowercased() == m_membersNameArraySD[i].lowercased() {
//                       self.displayActivityAlert(title: "Dependant name cannot be similar")
//                       return false
//                   }
//               }
//               return true
//           }
        else if(txtDob.text=="")
        {
            txtDob.errorMessage="Select Date of Birth"
            return false
        }
        else {
            if(txtName.text != "")
            {
                for i in 0..<m_membersNameArraySD.count{
                    if txtName.text?.lowercased() == m_membersNameArraySD[i].lowercased() {
                        self.displayActivityAlert(title: "Dependant name cannot be similar")
                        return false
                    }
                }
                return true
            }
            return true
        }
        
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
//        if self.newDependantDelegate != nil {
//            self.newDependantDelegate?.newDependantAdded(position: position)
//        }
    }
    

    
    //MARK:- Gender Changed
    @IBAction func genderChanged(_ sender: UIButton) {
        selectedGender = sender.tag
        setGender(selectedGender: selectedGender)
    }
    
    private func setGender(selectedGender : Int) {
        if selectedGender == 0 {
            btnMale.setImage(UIImage(named:"blue radio checked"), for: .normal)
            btnFemale.setImage(UIImage(named: "blue radio"), for: .normal)
            btnOther.setImage(UIImage(named: "blue radio"), for: .normal)
        }
        else if selectedGender == 1 {
            btnFemale.setImage(UIImage(named:"blue radio checked"), for: .normal)
            btnMale.setImage(UIImage(named: "blue radio"), for: .normal)
            btnOther.setImage(UIImage(named: "blue radio"), for: .normal)
        }
        else {
            btnOther.setImage(UIImage(named:"blue radio checked"), for: .normal)
            btnFemale.setImage(UIImage(named: "blue radio"), for: .normal)
            btnMale.setImage(UIImage(named: "blue radio"), for: .normal)
        }

    }
   
    
}




//MARK:- Server Call
extension AddNewDependantVC {
    private func addNewDependantToServer(url:String,obj:DependantDBRecords) {
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
                       // self.newDependantDelegate?.newDependantAdded(position: self.position, data: obj)

                        do {
                            print(data)
                            
                           // if let jsonResult = data?.dictionary
                           // {
                                print("addNewDependantToServer Data Found")
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
                                    let status = errorDict["Status"]?.bool
                                        if status == true
                                        {
                                             self.newDependantDelegate?.newDependantAdded(position: self.position, data: obj)
                                            self.dismiss(animated: true, completion: nil)

                                        }
                                        else {
                                    
                                                if let msg = errorDict["Message"]?.string {
                                                self.displayActivityAlert(title: msg)
                                                }
                                    }
                                }
                            }
                        }
                            
                        /*do {
                            print(data)
                            
                            if let jsonResult = data as? NSDictionary
                            {

                                    if let status = jsonResult.value(forKey: "Status") as? Bool {
                                    
                                        if status == true
                                        {
                                            if let msg = jsonResult.value(forKey: "Message") as? String {
                                                self.displayActivityAlert(title: msg)
                                            }
                                            
                                            self.newDependantDelegate?.newDependantAdded(position: self.position, data: obj)
                                            self.dismiss(animated: true, completion: nil)

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
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
        }
    }
    
    
    
    


}


//Date Picker
extension AddNewDependantVC {
    private func addDatePicker() {
        // Create a DatePicker
        
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        
        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        self.view.addSubview(datePicker)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
    }

}


//Date Picker
extension AddNewDependantVC {
    private func setDateToolBar()
    {
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = self.hexStringToUIColor(hex: hightlightColor)
        toolBar.sizeToFit()
        toolBar.backgroundColor = UIColor.white

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtDob.inputAccessoryView = toolBar
        
        datePicker.datePickerMode = UIDatePickerMode.date
        
        if txtRelation.text?.lowercased() == "wife" || txtRelation.text?.lowercased() == "husband" || txtRelation.text?.lowercased() == "partner" || txtRelation.text?.lowercased() == "spouse" {
            
            let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
            datePicker.maximumDate = date
            
            let datemin = Calendar.current.date(byAdding: .year, value: -100, to: Date())
            datePicker.minimumDate = datemin
            /*
            let array:Array<EnrollmentGroupRelations> = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: "SPOUSE")
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
        }
            
        else {
            datePicker.maximumDate = Date()
            let datemin = Calendar.current.date(byAdding: .year, value: -24, to: Date())
            datePicker.minimumDate = datemin
            /*
            let array:Array<EnrollmentGroupRelations> = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: (txtRelation.text?.uppercased())!)
                      var minAge = "0"
                      var maxAge = "0"
                      if array.count > 0 {
                          maxAge = array[0].maxAge!
                          minAge = array[0].minAge!
                        
                        if minAge != "" {
                        let date = Calendar.current.date(byAdding: .year, value: -(Int(minAge)!), to: Date())
                        datePicker.maximumDate = date
                        }
                         
                        if maxAge != "" {
                        let datemin = Calendar.current.date(byAdding: .year, value: -(Int(maxAge)!), to: Date())
                        datePicker.minimumDate = datemin
                        }
                      }
                      else {
                        let date = Calendar.current.date(byAdding: .year, value: -0, to: Date())
                        datePicker.maximumDate = date
                        
                        let datemin = Calendar.current.date(byAdding: .year, value: -25, to: Date())
                        datePicker.minimumDate = datemin

            }

            */
            
        }
        
        //Set Previous Date
        if isEdit == true {
            let oldDate = selectedObj.dateofBirth?.getSimpleDate() ?? Date()
            self.datePicker.setDate(oldDate, animated: false)
        }
        
        self.txtDob.inputView = datePicker
        self.txtDob.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)

    }
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        
        
        
        txtDob.text = formatter.string(from: datePicker.date)

        let m_selectedDate = datePicker.date
        let dateString = dateFormatter1.string(from: datePicker.date)
        print(dateString)
        
        let serverDt = Date()

       finalAge = serverDt.years(from: datePicker.date)
        
        if finalAge > 1 {
            self.txtAge.text = String(finalAge) + " yrs"
        }
        else {
            self.txtAge.text = String(finalAge) + " yr"
        }
        
        
        txtDob.resignFirstResponder()
        
        
    }
    @objc func cancelClick() {
        txtDob.resignFirstResponder()
    }

}
