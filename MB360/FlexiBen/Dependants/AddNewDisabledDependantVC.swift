//
//  AddNewDisabledDependantVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 22/03/21.
//  Copyright © 2021 Semantic. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import FirebaseCrashlytics
import Photos
import AssetsLibrary


class AddNewDisabledDependantVC: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblPrimium: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var swipeIndicator: UIView!
    
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    //DA outlets
    @IBOutlet weak var backViewNew: UIView!
    @IBOutlet weak var btnDaSelected: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnAttach: UIButton!
    @IBOutlet weak var lblAttach: UILabel!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var viewChecked: UIView!
    @IBOutlet weak var viewUnChecked: UIView!
    var isDiffAbled = 0
    var certificateImgFormat = ".jpg"
    var uploadedImage : UIImage!
    var uploadedUrl : URL!
    var prescriptionFileName = ""
    var personSrNo = ""
    var m_membersNameArraySD = Array<String>()
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
    var selectedObjnew = DifferentlyDBRecords()
    
    var isEdit = false
    var isChange = false
    var isFile = "IMG"
    var imageURL : URL!
    var selectedGender = 0 //0-male, 1-Female, 2-Other
    
    let datePicker: UIDatePicker = UIDatePicker()

    var sortId = 0
    var finalAge = 0
    
    //var documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
    var documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("#VDL - Add new dependant")
        print("All Members Name : \(self.m_membersNameArraySD)")

       
        if relationStr.lowercased() == "partner" {
            self.heightOfGenderView.constant = 50
            self.bottomViewConstraints.constant = 490

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
            self.bottomViewConstraints.constant = 450
        }

        
        txtRelation.text = relationStr.capitalizingFirstLetter()
        view.backgroundColor = .clear
        backViewNew.backgroundColor = .clear
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
        
        btnUpload.makeRound()
        
        btnDaSelected.layer.borderColor = UIColor.lightGray.cgColor
        btnDaSelected.layer.borderWidth = 1
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapGesture1.delegate = self
        self.backViewNew.addGestureRecognizer(tapGesture1)
        
    
        let swipeGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipeGesture1.direction = [.down]
        swipeGesture1.delegate = self
        self.backViewNew.addGestureRecognizer(swipeGesture1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        //Add gesture on textfield
        //let textTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDOBTap(_:)))
        //self.txtDob.addGestureRecognizer(tapGesture)

        
        
        btnCancel.makeCicularWithMasks()
        btnCancel.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        btnCancel.layer.borderWidth = 2.0
        
        if isEdit == true {
            self.lblHeading.text = "edit dependant"
            //isDiffAbled = selectedObjnew.IsDiffAbled ?? 0
            isDiffAbled = selectedObjnew.IsDisabled! ? 1 : 0
            setData()
            if let filename = selectedObjnew.CertificateFile{
                if filename != "" {
                    let assetPath = filename.components(separatedBy: "/")
                    lblAttach.isHidden = false
                    btnAttach.isHidden = false
                    btnDelete.isHidden = false
                    btnAttach.setTitle(assetPath.last, for: .normal)
                    lblAttach.text = assetPath.last
                    prescriptionFileName = assetPath.last ?? ""
                }
            }else{
                lblAttach.text = ""
                btnAttach.setTitle("", for: .normal)
                prescriptionFileName = ""
                lblAttach.isHidden = true
                btnAttach.isHidden = true
                btnDelete.isHidden = true
            }
             
            if selectedObj.isPremiumShow! {

                lblPrimium.text = "Premium: \(getFormattedCurrency(amount: premiunAmount))"
                lblPrimium.isHidden = false
            }else {
                lblPrimium.isHidden = true
            }
            
        }
        else {
            self.lblHeading.text = "add new dependant"
            self.txtDob.text = ""
            self.txtName.text = ""
            self.txtAge.text = ""
            isDiffAbled = 0
            prescriptionFileName = ""
            btnUpload.isUserInteractionEnabled = false
            btnUpload.backgroundColor = UIColor.lightGray
            
            
                   if isDiffAbled == 0 {
                       self.setupGenderView(gender: "isDiffAbledNot")
                   }
                   else {
                       self.setupGenderView(gender: "isDiffAbled")
                   }
            
                   if childCountIn > 1 {

                       lblPrimium.text = "Premium: \(getFormattedCurrency(amount: premiunAmount))"
                       lblPrimium.isHidden = false
                   }else {
                       lblPrimium.isHidden = true
                   }
        }
        
        setupSwitchView()
        setDateToolBar()
        
    }
    
    
    //MARK:- Switch View DifferentlyAbled
    private func setupSwitchView() {
        //gender View
        self.switchView.layer.cornerRadius = switchView.frame.height / 2
        self.viewUnChecked.layer.cornerRadius = self.viewUnChecked.frame.size.width/2
        self.viewChecked.layer.cornerRadius = self.viewChecked.frame.size.width/2
        viewChecked.clipsToBounds = true
        viewUnChecked.clipsToBounds = true
       
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.switchView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.switchView.addGestureRecognizer(swipeLeft)
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                //if txtDob.text != "" {
                    print("Swiped right")
                    if let age = Int(selectedObj.age!) {
                        if age > 25 {
                            btnUpload.isUserInteractionEnabled = true
                            btnUpload.backgroundColor = UIColor.init(displayP3Red: 84.0/255.0, green: 135.0/255.0, blue: 217.0/255.0, alpha: 1)
                        }else {
                            btnUpload.isUserInteractionEnabled = false
                            btnUpload.backgroundColor = UIColor.lightGray
                        }
                    }
                    
                    self.viewUnChecked.isHidden = true
                    self.viewChecked.isHidden = false
                    isDiffAbled = 1
                    
//                }else {
//                    displayActivityAlert(title: "Select date of birth")
//                }
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                self.viewUnChecked.isHidden = false
                self.viewChecked.isHidden = true
                isDiffAbled = 0
                btnUpload.isUserInteractionEnabled = false
                btnUpload.backgroundColor = UIColor.lightGray
                
            default:
                break
            }
            
            lblAttach.text = ""
            lblAttach.isHidden = true
            btnAttach.setTitle("", for: .normal)
            btnAttach.isHidden = true
            btnDelete.isHidden = true
            prescriptionFileName = ""
            txtDob.text = ""
            txtAge.text = ""
            
            isChange = true
            setDateToolBar()
        }
    }
    
    private func setupGenderView(gender:String) {
           if gender == "isDiffAbledNot" {
               self.viewUnChecked.isHidden = false
               self.viewChecked.isHidden = true
               isDiffAbled = 0
           }
           else {
               self.viewUnChecked.isHidden = true
               self.viewChecked.isHidden = false
               isDiffAbled = 1
           }
           
       }
    
    //MARK:- Differently Abled Changed
    @IBAction func daTapped(_ sender: UIButton) {
        
        if btnDaSelected.isSelected{
            btnDaSelected.setImage(UIImage(named: "unchecked"), for: .normal)//
            btnDaSelected.isSelected  = false
        }else{
            btnDaSelected.setImage(UIImage(named: "checked"), for: .normal)//
            btnDaSelected.isSelected  = true
        }
        
    }
    
    @IBAction func attachmentTapped(_ sender: UIButton) {
        print("attachment tapped..")
        if isEdit && !isChange {
            print("Url : \(selectedObjnew.CertificateFile ?? "")")
            if let url = URL(string: selectedObjnew.CertificateFile ?? "") {
               if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                        (success) in
                        print("Open  \(success)")
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }else{
            //img,doc
            print("Url : \(imageURL)")
            
            if let url = imageURL {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url.absoluteURL, options: [:], completionHandler: {
                        (success) in
                        print("Open  \(success)")
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
                
            }
        }
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
           print("delete tap..")
        
         lblAttach.text = ""
         lblAttach.isHidden = true
         btnAttach.setTitle("", for: .normal)
         btnAttach.isHidden = true
         btnDelete.isHidden = true
         prescriptionFileName = ""
         btnUpload.isUserInteractionEnabled = true
         btnUpload.backgroundColor = UIColor.init(displayP3Red: 84.0/255.0, green: 135.0/255.0, blue: 217.0/255.0, alpha: 1)
         
       }
    
    @IBAction func uploadTapped(_ sender: UIButton) {
           print("upload tap..")
          openGallary()
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
        
           if isDiffAbled == 0 {

               btnUpload.isUserInteractionEnabled = false
               btnUpload.backgroundColor = UIColor.lightGray
               self.viewUnChecked.isHidden = false
               self.viewChecked.isHidden = true
           }
           else {
               if let age = Int(selectedObj.age!) {
                   if age > 25 {

                       btnUpload.isUserInteractionEnabled = true
                       btnUpload.backgroundColor = UIColor.init(displayP3Red: 84.0/255.0, green: 135.0/255.0, blue: 217.0/255.0, alpha: 1)
                   }else {

                       btnUpload.isUserInteractionEnabled = false
                       btnUpload.backgroundColor = UIColor.lightGray
                   }
               }
               
               self.viewUnChecked.isHidden = true
               self.viewChecked.isHidden = false
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
                    var iff = false
                    if isDiffAbled == 1 {
                        iff = true
                    }

                    //let obj = DependantDBRecords.init(age: String(finalAge), cellPhoneNUmber: "", dateofBirth: self.txtDob.text, emailIDStr: "", empSrNo: nil, gender: gender, isValid: nil, personName: txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines), personSrNo: nil, productCode: nil, relationID: nil, relationname: txtRelation.text!, isEmpty: false,sortId: sortId,selectedFilename: "",isDisabled: iff,isPremiumShow: false)

                    let obj =  DependantDBRecords.init(srNo: sortId, personName: txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines), relation: txtRelation.text!, gender: gender, relationID: nil, age: String(finalAge), dateofBirth: self.txtDob.text, personSrNo: nil, isPremiumShow: false, isDisabled: iff, isAdded: false, cellPhoneNUmber: "", emailIDStr: "", empSrNo: nil, isValid: nil, selectedFilename: "")
                    
                    

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

                        var relationId = Int(selectedObj.relationID!)

                        if isEdit == false {
                            //if selectedObj.relationID != 0 && selectedObj.relationID != 17 {
                            if relationId != 0 && relationId != 17 {
                                let url = APIEngine.shared.getAddNewDependantJsonURL(Employeesrno: empSrNo, Relationid: self.selectedObj.relationID!.description, Personname: txtName.text!, Dateofmarriage: "", Windowperiodactive: "1", Grpchildsrno: groupChildSrNo, Oegrpbasinfosrno: oe_group_base_Info_Sr_No, Gender: gender ?? "Male", IsTwins: "0", ParentalPremium: "0", Age: finalAge.description, Dateofbirth: txtDob.text!)
                                print(url)

                                addNewDependantToServer(url:url, obj: obj)
                            }
                            else {
                                self.showAlert(message: "AddNewDep=17")
                            }
                        }//isEdit
                        else {
                            if relationId != 0 && relationId != 17 {

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
            var mainAge = 0
            var empAge = 0
            if finalAge != 0 {
                mainAge = finalAge
            }else{
                mainAge = 0
            }
            
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
                           
            
            if(txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
            {
                txtName.errorMessage="Enter Name"
                return false
            }
//            else if(txtName.text != "")
//               {
//                   for i in 0..<m_membersNameArraySD.count{
//                    if txtName.text?.lowercased() == m_membersNameArraySD[i].lowercased() {
//                           self.displayActivityAlert(title: "Dependant name cannot be similar")
//                           return false
//                       }
//                   }
//                   return true
//               }
            else if(txtDob.text=="")
            {
                txtDob.errorMessage="Select Date of Birth"
                return false
            }
            else if finalAge > empAge {
                displayActivityAlert(title: "Child age can not be greater than Employee")
                return false
            }
            else if isEdit  {

                if(isDiffAbled == 1 && mainAge > 25 && prescriptionFileName == ""){
                    displayActivityAlert(title: "Please upload disability certificate to proceed")
                    return false
                }
                else{
                    
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
            else if(isDiffAbled == 1 && mainAge > 25 && prescriptionFileName == ""){
                displayActivityAlert(title: "Please upload disability certificate to proceed")
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
            
        }
    
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
extension AddNewDisabledDependantVC {
    
    private func addNewDependantToServer(url:String,obj:DependantDBRecords) {
        if(isConnectedToNetWithAlert())
        {
            
            
                let urlreq = NSURL(string : url)
                
                print(url)
                let dict = ["":""]
                
                EnrollmentServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: dict as NSDictionary, view: self) { (data, error) in
                    
                    if error != nil
                    {
                        print("error ",error!)
                        
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                       
                        do {
                            print(data)
                            
                           // if let jsonResult = data?.dictionary
                           // {
                                print("addNewDependantToServer Data Found")
                           // if let msgDict = data?["message"].dictionary
                          //  {
                            
                if self.isEdit {
                 //............................................................................................................
                    
                     //if let status = data?["Status"].bool {
                    if let msgDict = data?["message"].dictionary {
                        if let status = msgDict["Status"]?.bool {
                                    if status == true
                                    {
                                            if self.isChange{
                                                self.personSrNo = self.selectedObjnew.personSrNo!
                                                if self.personSrNo != "" {
                                                    let dictionary = ["personSrNo":self.personSrNo,
                                                                      "isDiffAbled": String(self.isDiffAbled)]
                                                    print(dictionary)
                                                    self.uploadCertificateDataToServer(parameters: dictionary as NSDictionary, obj: obj)
                                                }
                                                else {
                                                    print("Person Serial Number Not Found")
                                                }
                                            }else{
                                             self.newDependantDelegate?.newDependantAdded(position: self.position, data: obj)
                                             self.dismiss(animated: true, completion: nil)
                                           }

                                    }
                                    else {
                                        if let msg = data?["Message"].string {
                                        self.displayActivityAlert(title: msg)
                                        }
                                }//status
                       }
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
                    
                //............................................................................................................

                }else{
                //............................................................................................................
                      
                     if let status = data?["Status"].bool {
                                        if status == true {
                                                self.personSrNo = data?["ResponseData"].string as! String
                                                if self.personSrNo != "" {
                                                    let dictionary = ["personSrNo":self.personSrNo,
                                                                      "isDiffAbled": String(self.isDiffAbled)]
                                                    print(dictionary)
                                                    self.uploadCertificateDataToServer(parameters: dictionary as NSDictionary, obj: obj)
                                                }
                                                else {
                                                    print("Person Serial Number Not Found")
                                                }
//                                             self.newDependantDelegate ?.newDependantAdded(position: self.position, data: obj)
//                                             self.dismiss(animated: true, completion: nil)
                                        }
                                        else {
                                            if let msg = data?["Message"].string {
                                            self.displayActivityAlert(title: msg)
                                            }
                                    }//status
                           // }//jsonResult
                        }//do
                            else {
                                if let errorDict = data?["message"].dictionary {
                                    let status = errorDict["Status"]?.bool
                                        if status == true {
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
                    
                //............................................................................................................
   
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
                                            
                                            self.newDependantDelegate ?.newDependantAdded(position: self.position, data: obj)
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
extension AddNewDisabledDependantVC {
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
extension AddNewDisabledDependantVC {
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
            
            let datemin1 = Calendar.current.date(byAdding: .year, value: -100, to: Date())
            datePicker.minimumDate = datemin1
            
            if isDiffAbled == 0 {
                datePicker.minimumDate = datemin
            }else if isDiffAbled == 1{
                datePicker.minimumDate = datemin1
            }
            
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
        
        
        // added by geeta
        if finalAge < 26 {
//            self.viewUnChecked.isHidden = false
//            self.viewChecked.isHidden = true
//            isDiffAbled = 0
            //btnUpload.alpha = 0.8

            btnUpload.isUserInteractionEnabled = false
            btnUpload.backgroundColor = UIColor.lightGray
        }else{
//            self.viewUnChecked.isHidden = true
//            self.viewChecked.isHidden = false
//            isDiffAbled = 1
           // btnUpload.alpha = 1

            btnUpload.isUserInteractionEnabled = true
            btnUpload.backgroundColor = UIColor.init(displayP3Red: 84.0/255.0, green: 135.0/255.0, blue: 217.0/255.0, alpha: 1)
        }
    }
    @objc func cancelClick() {
        txtDob.resignFirstResponder()
    }

}


//MARK:- Image Selection
extension AddNewDisabledDependantVC :UIDocumentPickerDelegate {
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    func openGallary()
    {
//        DispatchQueue.main.async {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.allowsEditing = true
//            imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
//            imagePicker.allowsEditing = true
//
//            self.getTopMostViewController()?.present(imagePicker, animated: true, completion: nil)
//        }
       DispatchQueue.main.async {
            

        let alert = UIAlertController(title: "Please select option", message: "", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
                
                if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
                {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    imagePicker.allowsEditing = true
                    self.getTopMostViewController()?.present(imagePicker, animated: true, completion: nil)
                }
                else
                {
                    let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }))

            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.getTopMostViewController()?.present(imagePicker, animated: true, completion: nil)
            }))

            alert.addAction(UIAlertAction(title: "File", style: .default, handler: { action in
                self.documentPicker.delegate = self
                if #available(iOS 11.0, *) {
                    self.documentPicker.allowsMultipleSelection = false
                } else {
                    // Fallback on earlier versions
                }
                self.getTopMostViewController()?.present(self.documentPicker, animated: true, completion: nil)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var fileURL: URL!
        
        if #available(iOS 11.0, *) {
            fileURL = info[UIImagePickerControllerImageURL] as? URL
            imageURL = info[UIImagePickerControllerImageURL] as? URL
        } else
        {
            // Fallback on earlier versions
        }
        
        let assetPath = info[UIImagePickerControllerReferenceURL] as! NSURL
        if (assetPath.absoluteString?.hasSuffix("jpg"))! {
                print("jpg")
                certificateImgFormat = ".jpg"
        }
        else if (assetPath.absoluteString?.hasSuffix("png"))! {
                print("png")
                certificateImgFormat = ".png"
        }
        else {
            print("Unknown")
        }

            uploadedImage = image
            

            btnUpload.isUserInteractionEnabled = false
            btnUpload.backgroundColor = UIColor.lightGray
            lblAttach.isHidden = false
            btnAttach.isHidden = false
            btnDelete.isHidden = false
            isChange = true
            isFile = "IMG"
            if isEdit{
                btnAttach.setTitle("Person_\(selectedObj.personSrNo!).jpg", for: .normal)
                lblAttach.text = "Person_\(selectedObj.personSrNo!).jpg"
            }else{
                lblAttach.text = assetPath.lastPathComponent
            }
            
            prescriptionFileName = "Person_\(personSrNo)" + "\(certificateImgFormat)"

         
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do {
            let imageData = try Data(contentsOf: url as URL)
            let pdfData = try! Data(contentsOf: url.asURL())
            uploadedUrl = url as URL
            imageURL = url
            print(imageData.count)
        } catch {
            print("Unable to load data: \(error)")
        }
        certificateImgFormat = url.pathExtension
        
        //lblAttach.text = url.lastPathComponent
        
        btnUpload.isUserInteractionEnabled = false
        btnUpload.backgroundColor = UIColor.lightGray
        lblAttach.isHidden = false
        btnAttach.setTitle(url.lastPathComponent, for: .normal)
        btnAttach.isHidden = false
        btnDelete.isHidden = false
        isChange = true
        isFile = "DOC"
        if isEdit{
           btnAttach.setTitle("Person_\(selectedObj.personSrNo!).\(certificateImgFormat)", for: .normal)
           lblAttach.text = "Person_\(selectedObj.personSrNo!).\(certificateImgFormat)"
        }else{
           lblAttach.text = url.lastPathComponent
        }
        prescriptionFileName = "Person_\(personSrNo)" + ".\(certificateImgFormat)"
        
    }
    
    
}




//MARK:- API CALL
extension AddNewDisabledDependantVC {
    func uploadCertificateDataToServer(parameters:NSDictionary,obj:DependantDBRecords) {
        self.showPleaseWait(msg: "Please Wait")

        var paramStr = ""
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: parameters,
            options: .prettyPrinted
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {

            paramStr = theJSONText
            print("JSON string = \n\(theJSONText)")
            print(paramStr.data(using: String.Encoding.utf8)!)
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in

            multipartFormData.append(paramStr.data(using: String.Encoding.utf8)!, withName: "ChildData")

            //set Prescription Image
            var mainAge = 0
            if self.finalAge != 0 {
                mainAge = self.finalAge
            }else{
                mainAge = 0
            }
            if self.isDiffAbled == 1 && mainAge > 25 {
                if self.isFile == "IMG" {
                    
                    if let image = self.uploadedImage {
                        multipartFormData.append(UIImageJPEGRepresentation(self.uploadedImage, 0.5)!, withName: "Certificate", fileName: self.prescriptionFileName, mimeType: "image/jpg")
                    }
                }else if self.isFile == "DOC"{
                    if self.uploadedUrl != nil {
                            let pdfData = try! Data(contentsOf: self.uploadedUrl.asURL())
                            var data : Data = pdfData
                            multipartFormData.append(pdfData, withName: "Certificate", fileName: self.prescriptionFileName, mimeType:"application/pdf")
                    }
                }else{
                    if let image = self.uploadedImage {
                        multipartFormData.append(UIImageJPEGRepresentation(self.uploadedImage, 0.5)!, withName: "Certificate", fileName: self.prescriptionFileName, mimeType: "image/jpg")
                    }
                }
                
            }
            
        }, to:APIEngine.shared.updateDifferentlyAbledChildJSONURL())
        { (result) in
            switch result {
            case .success(let upload, _, _):

                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })

                upload.responseJSON { response in
                    
                    print(response.request)  // original URL request
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                       if let dictionaryRes = JSON as? NSDictionary
                       {
                        if let status = dictionaryRes["Status"] as? Bool {
                            if status == true {
                                self.newDependantDelegate?.newDependantAdded(position: self.position, data: obj)
                                self.dismiss(animated: true, completion: nil)
                                
                                //self.displayActivityAlert(title: "Dependant added successfully")
                            }
                            else {
                                self.displayActivityAlert(title: m_errorMsg)
                            }
                        }
                        else {
                        self.displayActivityAlert(title: m_errorMsg)

                        }
                        }
                        else {
                        self.displayActivityAlert(title: m_errorMsg)

                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.dismiss(animated: true, completion: nil)
                        }

                    }
                }

            case .failure(let encodingError):
               
                print(encodingError)
            }

        }

    }
    
}
