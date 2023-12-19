//
//  AddDisabledTwinsVC.swift
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

class AddDisabledTwinsVC: UIViewController {
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
    
    //DA outlets
    @IBOutlet weak var backViewNew: UIView!
    @IBOutlet weak var btnDaSelected: UIButton!
    //Twin1
    @IBOutlet weak var btnUpload1: UIButton!
    @IBOutlet weak var btnDelete1: UIButton!
    @IBOutlet weak var lblAttach1: UILabel!
    @IBOutlet weak var switchView1: UIView!
    @IBOutlet weak var viewChecked1: UIView!
    @IBOutlet weak var viewUnChecked1: UIView!
    @IBOutlet weak var imgDelete1: UIImageView!

    var isDiffAbled1 = false
    var certificateImgFormat1 = ".jpg"
    var uploadedUrl1 : URL!
    var uploadedImage1 : UIImage!
    var prescriptionFileName1 = ""
    var personSrNo1 = ""
    
    //Twin2
    @IBOutlet weak var btnUpload2: UIButton!
    @IBOutlet weak var btnDelete2: UIButton!
    @IBOutlet weak var lblAttach2: UILabel!
    @IBOutlet weak var switchView2: UIView!
    @IBOutlet weak var viewChecked2: UIView!
    @IBOutlet weak var viewUnChecked2: UIView!
    @IBOutlet weak var imgDelete2: UIImageView!
    var isDiffAbled2 = false
    var certificateImgFormat2 = ".jpg"
    var uploadedUrl2 : URL!
    var uploadedImage2 : UIImage!
    var prescriptionFileName2 = ""
    var personSrNo2 = ""
    
    
    var relationStr = ""
    var position = 0
    var pairNumber = 1 // 1st 2nd
    var selectedObjFirst = DependantDBRecords()
    var selectedObjSecond = DependantDBRecords()
    //var selectedObjnew1 = DifferentlyDBRecords()
    //var selectedObjnew2 = DifferentlyDBRecords()
    
    var isEdit = false
    var isChange1 = false
    var isChange2 = false
    var isFile1 = "IMG"
    var isFile2 = "IMG"
    var uploadSelected = 0
    
    var selectedGenderFirst = 0 //0-male, 1-Female, 2-Other
    var selectedGenderSecond = 0 //0-male, 1-Female, 2-Other
    
    var isKeyboardAppear = false
    let datePicker1: UIDatePicker = UIDatePicker()
    let datePicker2: UIDatePicker = UIDatePicker()
    
    var firstChildAge = 0
    var secondChildAge = 0
    var childCountIn = 0
    var premiunAmount = String()
    var m_membersNameArrayST = Array<String>()
    let shapeLayer = CAShapeLayer()
    
    //var documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
    var documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
    
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
        btnUpload1.makeRound()
        btnUpload2.makeRound()
        
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
        
    
        
        if isEdit == true {
            self.lblHeading.text = "edit twins"
            
            isDiffAbled1 = selectedObjFirst.isDisabled ?? false   // selectedObj new.IsDiffAbled  need to check
            isDiffAbled2 = selectedObjSecond.isDisabled ?? false
            setData()
                if selectedObjFirst.selectedFilename != "" {
                let assetPath = selectedObjFirst.selectedFilename.components(separatedBy: "/")
                    lblAttach1.isHidden = false
                    btnDelete1.isHidden = false
                    imgDelete1.isHidden = false
                    lblAttach1.text = assetPath.last
                    prescriptionFileName1 = assetPath.last ?? ""
                }else{
                    lblAttach1.text = ""
                    prescriptionFileName1 = ""
                    lblAttach1.isHidden = true
                    btnDelete1.isHidden = true
                    imgDelete1.isHidden = true
                }
            
                if selectedObjSecond.selectedFilename != "" {
                    let assetPath = selectedObjSecond.selectedFilename.components(separatedBy: "/")
                    lblAttach2.isHidden = false
                    btnDelete2.isHidden = false
                    imgDelete2.isHidden = false
                    lblAttach2.text = assetPath.last
                    prescriptionFileName2 = assetPath.last ?? ""
                }else{
                    lblAttach2.text = ""
                    prescriptionFileName2 = ""
                    lblAttach2.isHidden = true
                    btnDelete2.isHidden = true
                    imgDelete2.isHidden = true
                }
            
                if selectedObjFirst.isPremiumShow ?? false {
                   
                    lblPrimium1.text = "Premium: \(getFormattedCurrency(amount: premiunAmount))"
                    lblPrimium1.isHidden = false
                    
                }else {
                    lblPrimium1.isHidden = true
                }
                
                if selectedObjSecond.isPremiumShow ?? false{
                   
                    lblPrimium2.text = "Premium: \(getFormattedCurrency(amount: premiunAmount))"
                    lblPrimium2.isHidden = false
                    
                }else {
                    lblPrimium2.isHidden = true
                }
            
        }
        else {
            self.lblHeading.text = "add twins"
            self.txtDob.text = ""
            self.txtName.text = ""
            self.txtAge.text = ""
            
            self.txtDob2.text = ""
            self.txtName2.text = ""
            self.txtAge2.text = ""
            
            isDiffAbled1 = false
            btnUpload1.isUserInteractionEnabled = false
            btnUpload1.backgroundColor = UIColor.lightGray
            
            isDiffAbled2 = false
            btnUpload2.isUserInteractionEnabled = false
            btnUpload2.backgroundColor = UIColor.lightGray
            
             if isDiffAbled1 == false {
                   self.setupGenderView(gender: "isDiffAbledNot")
               }
               else {
                   self.setupGenderView(gender: "isDiffAbled")
               }
            
            if isDiffAbled2 == false {
                self.setupGenderView1(gender: "isDiffAbledNot")
            }
            else {
                self.setupGenderView1(gender: "isDiffAbled")
            }
            
        }
               setupSwitchView()
               setDateToolBar()
        
        
        
          
        
    }
    
    //MARK:- Switch View DifferentlyAbled
       private func setupSwitchView() {
           //twin1
           self.switchView1.layer.cornerRadius = switchView1.frame.height / 2
           self.viewUnChecked1.layer.cornerRadius = self.viewUnChecked1.frame.size.width/2
           self.viewChecked1.layer.cornerRadius = self.viewChecked1.frame.size.width/2
           viewChecked1.clipsToBounds = true
           viewUnChecked1.clipsToBounds = true
          
//           viewChecked1.isHidden = false
//           viewUnChecked1.isHidden = true
           
           let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
           swipeRight.direction = UISwipeGestureRecognizerDirection.right
           self.switchView1.addGestureRecognizer(swipeRight)
           
           let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
           swipeLeft.direction = UISwipeGestureRecognizerDirection.left
           self.switchView1.addGestureRecognizer(swipeLeft)
        
         //Twin2
          self.switchView2.layer.cornerRadius = switchView2.frame.height / 2
           self.viewUnChecked2.layer.cornerRadius = self.viewUnChecked2.frame.size.width/2
           self.viewChecked2.layer.cornerRadius = self.viewChecked2.frame.size.width/2
           viewChecked2.clipsToBounds = true
           viewUnChecked2.clipsToBounds = true
          
//           viewChecked2.isHidden = false
//           viewUnChecked2.isHidden = true
           
           let swipeRight2 = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture1))
           swipeRight2.direction = UISwipeGestureRecognizerDirection.right
           self.switchView2.addGestureRecognizer(swipeRight2)
           
           let swipeLeft2 = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture1))
           swipeLeft2.direction = UISwipeGestureRecognizerDirection.left
           self.switchView2.addGestureRecognizer(swipeLeft2)
        
       }
       
       @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
           if let swipeGesture = gesture as? UISwipeGestureRecognizer {
               
               switch swipeGesture.direction {
               case UISwipeGestureRecognizerDirection.right:
                   
                       print("Swiped right")
                   if let age = Int(selectedObjFirst.age!) {
                           if age > 25 {
                               btnUpload1.isUserInteractionEnabled = true
                               btnUpload1.backgroundColor = UIColor.init(displayP3Red: 84.0/255.0, green: 135.0/255.0, blue: 217.0/255.0, alpha: 1)
                           }else {
                               btnUpload1.isUserInteractionEnabled = false
                               btnUpload1.backgroundColor = UIColor.lightGray
                           }
                       }
                       //need to check
                       self.viewUnChecked1.isHidden = true
                       self.viewChecked1.isHidden = false
                       isDiffAbled1 = true
                       
                   
               case UISwipeGestureRecognizerDirection.left:
                   print("Swiped left")
                   self.viewUnChecked1.isHidden = false
                   self.viewChecked1.isHidden = true
                   isDiffAbled1 = false
                   btnUpload1.isUserInteractionEnabled = false
                   btnUpload1.backgroundColor = UIColor.lightGray
                   
               default:
                   break
               }
               isChange1 = true
               setDateToolBar()
            
            lblAttach1.text = ""
            lblAttach1.isHidden = true
            btnDelete1.isHidden = true
            imgDelete1.isHidden = true
            prescriptionFileName1 = ""
            txtDob.text = ""
            txtAge.text = ""
           }
       }
    

    @objc func respondToSwipeGesture1(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                
                    print("Swiped right")
                    if let age = Int(selectedObjSecond.age!) {
                        if age > 25 {
                            btnUpload2.isUserInteractionEnabled = true
                            btnUpload2.backgroundColor = UIColor.init(displayP3Red: 84.0/255.0, green: 135.0/255.0, blue: 217.0/255.0, alpha: 1)
                        }else {
                            btnUpload2.isUserInteractionEnabled = false
                            btnUpload2.backgroundColor = UIColor.lightGray
                        }
                    }
                    //need to check
                    self.viewUnChecked2.isHidden = true
                    self.viewChecked2.isHidden = false
                    isDiffAbled2 = true
                    
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                self.viewUnChecked2.isHidden = false
                self.viewChecked2.isHidden = true
                isDiffAbled2 = false
                btnUpload2.isUserInteractionEnabled = false
                btnUpload2.backgroundColor = UIColor.lightGray
                
            default:
                break
            }
            isChange2 = true
            setDateToolBar()
            lblAttach2.text = ""
            lblAttach2.isHidden = true
            btnDelete2.isHidden = true
            imgDelete2.isHidden = true
            prescriptionFileName2 = ""
            txtDob2.text = ""
            txtAge2.text = ""
        }
    }
       
       private func setupGenderView(gender:String) {
              if gender == "isDiffAbledNot" {
                  self.viewUnChecked1.isHidden = false
                  self.viewChecked1.isHidden = true
                  isDiffAbled1 = false
              }
              else {
                  self.viewUnChecked1.isHidden = true
                  self.viewChecked1.isHidden = false
                  isDiffAbled1 = true
              }
              
          }
      private func setupGenderView1(gender:String) {
                 if gender == "isDiffAbledNot" {
                     self.viewUnChecked2.isHidden = false
                     self.viewChecked2.isHidden = true
                     isDiffAbled2 = false
                 }
                 else {
                     self.viewUnChecked2.isHidden = true
                     self.viewChecked2.isHidden = false
                     isDiffAbled2 = true
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
           //selectedGender = sender.tag
           
       }
       
       @IBAction func deleteTapped1(_ sender: UIButton) {
             
              print("1st delete tap..")
        
        prescriptionFileName1 = ""
           
            lblAttach1.text = ""
            lblAttach1.isHidden = true
            btnDelete1.isHidden = true
            imgDelete1.isHidden = true
            btnUpload1.isUserInteractionEnabled = true
            btnUpload1.backgroundColor = UIColor.init(displayP3Red: 84.0/255.0, green: 135.0/255.0, blue: 217.0/255.0, alpha: 1)
            
          }
    
       @IBAction func deleteTapped2(_ sender: UIButton) {
          
           print("2nd delete tap..")
        prescriptionFileName2 = ""
        
         lblAttach2.text = ""
         lblAttach2.isHidden = true
         btnDelete2.isHidden = true
         imgDelete2.isHidden = true
         btnUpload2.isUserInteractionEnabled = true
         btnUpload2.backgroundColor = UIColor.init(displayP3Red: 84.0/255.0, green: 135.0/255.0, blue: 217.0/255.0, alpha: 1)
         
       }
    
       @IBAction func uploadTapped1(_ sender: UIButton) {
              
              print("upload tap..")
              uploadSelected = 1
              openGallary()
        }
       
       @IBAction func uploadTapped2(_ sender: UIButton) {
            
            print("upload tap..")
            uploadSelected = 2
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
    
    @objc func handleNameTapped(_ sender : UITextField!) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
        
        public func setData() {
            self.btnAdd.setTitle("save", for: .normal)

            
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
            
            
            self.txtDob.text = selectedObjFirst.dateofBirth
            self.txtName.text = selectedObjFirst.personName
            
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
            
            //DA change
            
            if isDiffAbled1 == false {
                //btnUpload1.alpha = 0.8

                btnUpload1.isUserInteractionEnabled = false
                btnUpload1.backgroundColor = UIColor.lightGray
                self.viewUnChecked1.isHidden = false
                self.viewChecked1.isHidden = true
            }
            else {
                if let age = Int(selectedObjFirst.age!) {
                    if age > 25 {
                        //btnUpload1.alpha = 1
                        btnUpload1.isUserInteractionEnabled = true
                        btnUpload1.backgroundColor = UIColor.init(displayP3Red: 84.0/255.0, green: 135.0/255.0, blue: 217.0/255.0, alpha: 1)
                    }else {
                        //btnUpload1.alpha = 0.8
                        btnUpload1.isUserInteractionEnabled = false
                        btnUpload1.backgroundColor = UIColor.lightGray
                    }
                }
                self.viewUnChecked1.isHidden = true
                self.viewChecked1.isHidden = false
            }
            
            if isDiffAbled2 == false {
                //btnUpload2.alpha = 0.8

                btnUpload2.isUserInteractionEnabled = false
                btnUpload2.backgroundColor = UIColor.lightGray
                self.viewUnChecked2.isHidden = false
                self.viewChecked2.isHidden = true
            }
            else {
                if let age = Int(selectedObjSecond.age!) {
                    if age > 25 {
                        //btnUpload2.alpha = 1
                        btnUpload2.isUserInteractionEnabled = true
                        btnUpload2.backgroundColor = UIColor.init(displayP3Red: 84.0/255.0, green: 135.0/255.0, blue: 217.0/255.0, alpha: 1)
                    }else {
                       // btnUpload2.alpha = 0.8
                        btnUpload2.isUserInteractionEnabled = false
                        btnUpload2.backgroundColor = UIColor.lightGray
                    }
                }
                self.viewUnChecked2.isHidden = true
                self.viewChecked2.isHidden = false
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
            var mainAge1 = 0
            if firstChildAge != 0 {
                mainAge1 = firstChildAge
            }else{
                mainAge1 = 0
            }
            
            var mainAge2 = 0
            if secondChildAge != 0 {
                mainAge2 = secondChildAge
            }else{
                mainAge2 = 0
            }
            
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
//            else if(txtName2.text != "")
//            {
//                for i in 0..<m_membersNameArrayST.count{
//                    if txtName2.text?.lowercased() == m_membersNameArrayST[i].lowercased() {
//                        self.displayActivityAlert(title: "Dependant name cannot be similar")
//                        return false
//                    }
//                }
//                return true
//            }
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
                else if isEdit {
        
                
                           if(isDiffAbled1 == true && mainAge1 > 25 && prescriptionFileName1 == ""){
                               displayActivityAlert(title: "Please upload disability certificate to proceed")
                               return false
                           }
                           else if(isDiffAbled2 == true && mainAge2 > 25 && prescriptionFileName2 == ""){
                               displayActivityAlert(title: "Please upload disability certificate to proceed")
                               return false
                           }
                           else {
                               
                               let firstDob = txtDob.text!.convertStringToDate()
                               let secondDob = txtDob2.text!.convertStringToDate()
                               let days = self.daysBetweenDates(startDate: firstDob, endDate: secondDob)
                               
                               if days > 1 || days < -1 {
                                   
                                  self.displayActivityAlertWithSeconds(title: "Date of birth difference can not be more than one day",seconds: 3)
                                   return false
                               }else {
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
                
                }//isEdit
                
                
            else if(isDiffAbled1 == true && mainAge1 > 25 && prescriptionFileName1 == ""){
                displayActivityAlert(title: "Please upload disability certificate to proceed")
                return false
            }
            else if(isDiffAbled2 == true && mainAge2 > 25 && prescriptionFileName2 == ""){
                displayActivityAlert(title: "Please upload disability certificate to proceed")
                return false
            }
            else {
                
                let firstDob = txtDob.text!.convertStringToDate()
                let secondDob = txtDob2.text!.convertStringToDate()
                let days = self.daysBetweenDates(startDate: firstDob, endDate: secondDob)
                
                if days > 1 || days < -1 {
                    
                   self.displayActivityAlertWithSeconds(title: "Date of birth difference can not be more than one day",seconds: 3)
                    return false
                }else {
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
    
   private func finalAgeValidation() -> Bool{
        let firstDob = txtDob.text!.convertStringToDate()
        let secondDob = txtDob2.text!.convertStringToDate()
        
        let days = self.daysBetweenDates(startDate: firstDob, endDate: secondDob)
        
        if days > 1 || days < -1 {
            
            self.displayActivityAlertWithSeconds(title: "Date of birth difference can not be more than one day",seconds: 3)
            
            return false
        }
        else {
            return true
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
extension AddDisabledTwinsVC {
    func addFirstDependantToServer(url1:String,url2:String,obj:DependantDBRecords) {
        if(isConnectedToNetWithAlert())
        {
            
            print(url1)
            let dict = ["":""]
            
            EnrollmentServerRequestManager.serverInstance.postDataToServer(url: url1, dictionary: dict as NSDictionary, view: self) { (data, error) in
                
                if error != nil
                {
                    print("error ",error!)
                    self.displayActivityAlert(title: m_errorMsg)
                }
                else
                {
                    print("found ....")
                    
                    do {
                        print("Started parsing ...")
                        print(data)

                        if let jsonResult = data?.dictionary
                        {
                            print(" Data Found")
                            
                            if let status = jsonResult["Status"]?.bool {
                                
                                if status == true
                                {
                                    var diff = 0
                                    if self.isDiffAbled1 == true{
                                        diff = 1
                                    }
                                    
                                    self.personSrNo1 = data?["ResponseData"].string as! String
                                    if self.personSrNo1 != "" {
                                        let dictionary = ["personSrNo":self.personSrNo1,
                                                          "isDiffAbled": String(diff)]
                                        print(dictionary)
                                        self.uploadCertificateDataToServer1(parameters: dictionary as NSDictionary, obj: obj, url2: url2)
                                    }else {
                                        print("Person Serial Number Not Found")
                                    }
                                    //self.addSecondDependantToServer(urlSec:url2,obj:DependantDBRecords())
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
            
            print(urlSec)
            let dict = ["":""]
            
            EnrollmentServerRequestManager.serverInstance.postDataToServer(url: urlSec, dictionary: dict as NSDictionary, view: self) { (data, error) in
                
                if error != nil
                {
                    print("error ",error!)
                    self.displayActivityAlert(title: m_errorMsg)
                }
                else
                {
                    print("found ...")
                    
                    do {
                        print("Started parsing ..")
                        print(data)
                        
                        if let jsonResult = data?.dictionary
                        {
                            print(" Data Found")
                            
                            if let status = jsonResult["Status"]?.bool {
                                
                                if status == true
                                {
                                    var diff = 0
                                    if self.isDiffAbled2 == true{
                                        diff = 1
                                    }
                                    self.personSrNo2 = data?["ResponseData"].string as! String
                                    if self.personSrNo2 != "" {
                                        let dictionary = ["personSrNo":self.personSrNo2,
                                                          "isDiffAbled": String(diff)]
                                        print(dictionary)
                                        self.uploadCertificateDataToServer2(parameters: dictionary as NSDictionary, obj: obj)
                                    }
                                    else {
                                        print("Person Serial Number Not Found")
                                    }
                                    
//                         var array = [DependantDBRecords]()
//                         self.newTwinsDelegate?. twinsUpdated(positionFirst: 1, positionSecond: 2, dataArray: array, pairId: 1)
//                                    self.dismiss(animated: true, completion: nil)
                                    
                                }
                                else {
                                    print("second dependant can not be added..")//No Data found
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
    
    
    
    //EDIT
    func editFirstDependantToServer(url1:String,url2:String,obj:DependantDBRecords) {
        if(isConnectedToNetWithAlert())
        {
            
            print(url1)
            let dict = ["":""]
            
            EnrollmentServerRequestManager.serverInstance.postDataToServer(url: url1, dictionary: dict as NSDictionary, view: self) { (data, error) in
                
                if error != nil
                {
                    print("error ",error!)
                    self.displayActivityAlert(title: m_errorMsg)
                }
                else
                {
                    print("found ...")
                    
                    do {
                        print("Started parsing ...")
                        print(data)
                        
                        if let jsonResult = data?.dictionary
                        {
                            print(" Data Found")
                            if let msgDict = jsonResult["message"]?.dictionary {
                                if let status = msgDict["Status"]?.bool {
                                    if status == true
                                    {
                                        if self.isChange1{
                                            //self.personSrNo1 = self.selectedObjnew1.personSrNo!
                                            if let no1 = self.selectedObjFirst.personSrNo {
                                                    self.personSrNo1 = String(no1)
                                            }
                                                var diff = 0
                                                if self.isDiffAbled1 == true{
                                                    diff = 1
                                                }
                                                if self.personSrNo1 != "" {
                                                    let dictionary = ["personSrNo":self.personSrNo1,
                                                                      "isDiffAbled": String(diff)]
                                                    print(dictionary)
                                                    self.uploadCertificateDataToServerEdit1(parameters: dictionary as NSDictionary, obj: obj, url2: url2)
                                                }
                                                else {
                                                    print("Person Serial Number Not Found")
                                                }
                                        }else{
                                            self.editSecondDependantToServer(urlSec: url2, obj: DependantDBRecords())
                                        }
                                        //self.editSecondDependantToServer(urlSec: url2, obj: DependantDBRecords())

                                    }
                                    else {
                                       print("First dependant can not be edited..") //No Data found
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
    
  
    
    func editSecondDependantToServer(urlSec:String,obj:DependantDBRecords) {
        
        print("SECOND CHILD...")
        if(isConnectedToNetWithAlert())
        {
            
            let urlreq = NSURL(string : urlSec)
            
            print(urlSec)
            let dict = ["":""]
            
            EnrollmentServerRequestManager.serverInstance.postDataToServer(url: urlSec, dictionary: dict as NSDictionary, view: self) { (data, error) in
                
                if error != nil
                {
                    print("error ",error!)
                    self.displayActivityAlert(title: m_errorMsg)
                }
                else
                {
                    print("found ....")
                    
                    do {
                        print("Started parsing ...")
                        print(data)
                                                
                        if let jsonResult = data?.dictionary
                        {
                            print(" Data Found")
                            if let msgDict = jsonResult["message"]?.dictionary {
                            if let status = msgDict["Status"]?.bool {
                                
                                if status == true
                                {
                                    if self.isChange2{
                                         //self.personSrNo2 = self.selectedObjnew2.personSrNo!
                                        if let no1 = self.selectedObjSecond.personSrNo {
                                                self.personSrNo2 = String(no1)
                                        }
                                        var diff = 0
                                        if self.isDiffAbled2 == true{
                                            diff = 1
                                        }
                                         if self.personSrNo2 != "" {
                                             let dictionary = ["personSrNo":self.personSrNo2,
                                                               "isDiffAbled": String(diff)]
                                             print(dictionary)
                                             self.uploadCertificateDataToServerEdit2(parameters: dictionary as NSDictionary, obj: obj)
                                         }
                                         else {
                                             print("Person Serial Number Not Found")
                                         }
                                     }else{
                                         let array = [DependantDBRecords]()
                                         self.dismiss(animated: true, completion: nil)
                                         self.newTwinsDelegate?.twinsUpdated(positionFirst: 1, positionSecond: 2, dataArray: array, pairId: 1)
                                     }
                                    
//                                    let msg = msgDict["Message"]?.string
//                                    self.displayActivityAlert(title: msg ?? "")
                                    
//                                    var array = [DependantDBRecords]()
//                                    self.dismiss(animated: true, completion: nil)
//                                    self.newTwinsDelegate?. twinsUpdated(positionFirst: 1, positionSecond: 2, dataArray: array, pairId: 1)
                                    
                                }
                                else {
                                    print("second dependant can not be edited..")//No Data found
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


extension AddDisabledTwinsVC {
    
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
        setDateToolBar()
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
extension UIAlertController {
    
    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }
    
}

//MARK:- Image Selection
extension AddDisabledTwinsVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate {
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
            
        } else
        {
            // Fallback on earlier versions
        }
        
        if uploadSelected == 1 {
            
            let assetPath = info[UIImagePickerControllerReferenceURL] as! NSURL
            if (assetPath.absoluteString?.hasSuffix("jpg"))! {
                    print("jpg")
                    certificateImgFormat1 = ".jpg"
            }
            else if (assetPath.absoluteString?.hasSuffix("png"))! {
                    print("png")
                    certificateImgFormat1 = ".png"
            }
            else {
                print("Unknown")
            }

                uploadedImage1 = image
                //lblAttach1.text = assetPath.lastPathComponent
                btnUpload1.isUserInteractionEnabled = false
                btnUpload1.backgroundColor = UIColor.lightGray
                lblAttach1.isHidden = false
                btnDelete1.isHidden = false
                imgDelete1.isHidden = false
                isChange1 = true
                if isEdit{
                    //btnAttach1.setTitle("Person_\(selectedObjFirst.personSrNo!).jpg", for: .normal)
                    lblAttach1.text = "Person_\(selectedObjFirst.personSrNo!).jpg"
                }else{
                    lblAttach1.text = assetPath.lastPathComponent
                }
                prescriptionFileName1 = "Person_\(personSrNo1)" + "\(certificateImgFormat1)"
             
            
        }else if uploadSelected == 2 {
            
            let assetPath = info[UIImagePickerControllerReferenceURL] as! NSURL
            if (assetPath.absoluteString?.hasSuffix("jpg"))! {
                    print("jpg")
                    certificateImgFormat2 = ".jpg"
            }
            else if (assetPath.absoluteString?.hasSuffix("png"))! {
                    print("png")
                    certificateImgFormat2 = ".png"
            }
            else {
                print("Unknown")
            }

                uploadedImage2 = image
                //lblAttach2.text = assetPath.lastPathComponent
                btnUpload2.isUserInteractionEnabled = false
                btnUpload2.backgroundColor = UIColor.lightGray
                lblAttach2.isHidden = false
                btnDelete2.isHidden = false
                imgDelete2.isHidden = false
                isChange2 = true
                if isEdit{
                    //btnAttach2.setTitle("Person_\(selectedObjSecond.personSrNo!).jpg", for: .normal)
                    lblAttach2.text = "Person_\(selectedObjSecond.personSrNo!).jpg"
                }else{
                    lblAttach2.text = assetPath.lastPathComponent
                }
                prescriptionFileName2 = "Person_\(personSrNo2)" + "\(certificateImgFormat2)"
             
        }
        
    }
    
    
     func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        if uploadSelected == 1 {
                do {
                    let imageData = try Data(contentsOf: url as URL)
                    let pdfData = try! Data(contentsOf: url.asURL())
                    uploadedUrl1 = url as URL
                    print(imageData.count)
                } catch {
                    print("Unable to load data: \(error)")
                }
               
                certificateImgFormat1 = url.pathExtension
                //lblAttach1.text = url.lastPathComponent
                
                btnUpload1.isUserInteractionEnabled = false
                btnUpload1.backgroundColor = UIColor.lightGray
                lblAttach1.isHidden = false
                btnDelete1.isHidden = false
                isChange1 = true
                isFile1 = "DOC"
                if isEdit{
                    //btnAttach1.setTitle("Person_\(selectedObjFirst.personSrNo!).\(certificateImgFormat1)", for: .normal)
                    lblAttach1.text = "Person_\(selectedObjFirst.personSrNo!).\(certificateImgFormat1)"
                }else{
                    lblAttach1.text = url.lastPathComponent
                }
                prescriptionFileName1 = "Person_\(personSrNo1)" + ".\(certificateImgFormat1)"
                    
        }else if uploadSelected == 2 {
                do {
                    let imageData = try Data(contentsOf: url as URL)
                    let pdfData = try! Data(contentsOf: url.asURL())
                    uploadedUrl2 = url as URL
                    print(imageData.count)
                } catch {
                    print("Unable to load data: \(error)")
                }
               
                certificateImgFormat2 = url.pathExtension
                //lblAttach2.text = url.lastPathComponent
                
                btnUpload2.isUserInteractionEnabled = false
                btnUpload2.backgroundColor = UIColor.lightGray
                lblAttach2.isHidden = false
                btnDelete2.isHidden = false
                isChange2 = true
                isFile2 = "DOC"
                if isEdit{
                   //btnAttach2.setTitle("Person_\(selectedObjFirst.personSrNo!).\(certificateImgFormat2)", for: .normal)
                   lblAttach2.text = "Person_\(selectedObjSecond.personSrNo!).\(certificateImgFormat2)"
                }else{
                   lblAttach2.text = url.lastPathComponent
                }
                prescriptionFileName2 = "Person_\(personSrNo2)" + ".\(certificateImgFormat2)"
                    
        }
        
     }
    
}


//MARK:- API CALL
extension AddDisabledTwinsVC {
    
    
    func uploadCertificateDataToServer1(parameters:NSDictionary,obj:DependantDBRecords,url2:String) {
        self.showPleaseWait(msg: "Please Wait")

        var paramStr = ""
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: parameters,
            options: .prettyPrinted
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {

            paramStr = theJSONText
            print("JSON string 1st= \n\(theJSONText)")
            print(paramStr.data(using: String.Encoding.utf8)!)
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in

            multipartFormData.append(paramStr.data(using: String.Encoding.utf8)!, withName: "ChildData")

            //set Prescription Image
            var mainAge = 0
            if self.firstChildAge != 0 {
                mainAge = self.firstChildAge
            }else{
                mainAge = 0
            }
            
            if self.isDiffAbled1 == true && mainAge > 25 {
                if self.isFile1 == "IMG" {
                    if let image = self.uploadedImage1 {
                        multipartFormData.append(UIImageJPEGRepresentation(self.uploadedImage1, 0.5)!, withName: "Certificate", fileName: self.prescriptionFileName1, mimeType: "image/jpg")
                    }
                }else if self.isFile1 == "DOC"{
                    if self.uploadedUrl1 != nil {
                            let pdfData = try! Data(contentsOf: self.uploadedUrl1.asURL())
                            var data : Data = pdfData
                            multipartFormData.append(pdfData, withName: "Certificate", fileName: self.prescriptionFileName1, mimeType:"application/pdf")
                    }
                }else{
                    if let image = self.uploadedImage1 {
                        multipartFormData.append(UIImageJPEGRepresentation(self.uploadedImage1, 0.5)!, withName: "Certificate", fileName: self.prescriptionFileName1, mimeType: "image/jpg")
                    }
                }
                
            }
            
        }, to:APIEngine.shared.updateDifferentlyAbledChildJSONURL())
        { (result) in
            switch result {
            case .success(let upload, _, _):

                //self.hidePleaseWait()
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })

                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print(response.request)  // original URL request
                    if let JSON = response.result.value {
                        print("JSON 1st: \(JSON)")
                       if let dictionaryRes = JSON as? NSDictionary
                       {
                            if let status = dictionaryRes["Status"] as? Bool {
                                if status == true {
                                    print("First twin updateDifferently api call")
                                        self.addSecondDependantToServer(urlSec:url2,obj:DependantDBRecords())
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
                //self.hidePleaseWait()
                print(encodingError)
            }

        }

    }
    
    
    func uploadCertificateDataToServer2(parameters:NSDictionary,obj:DependantDBRecords) {
        self.showPleaseWait(msg: "Please Wait")

        var paramStr = ""
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: parameters,
            options: .prettyPrinted
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {

            paramStr = theJSONText
            print("JSON string 2nd= \n\(theJSONText)")
            print(paramStr.data(using: String.Encoding.utf8)!)
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in

            multipartFormData.append(paramStr.data(using: String.Encoding.utf8)!, withName: "ChildData")

            //set Prescription Image
            var mainAge = 0
            if self.secondChildAge != 0 {
                mainAge = self.secondChildAge
            }else{
                mainAge = 0
            }
            if self.isDiffAbled2 == true && mainAge > 25 {
                
                  if self.isFile2 == "IMG" {
                       if let image = self.uploadedImage2 {
                           multipartFormData.append(UIImageJPEGRepresentation(self.uploadedImage2, 0.5)!, withName: "Certificate", fileName: self.prescriptionFileName2, mimeType: "image/jpg")
                       }
                   }else if self.isFile2 == "DOC"{
                       if self.uploadedUrl2 != nil {
                               let pdfData = try! Data(contentsOf: self.uploadedUrl2.asURL())
                               var data : Data = pdfData
                               multipartFormData.append(pdfData, withName: "Certificate", fileName: self.prescriptionFileName2, mimeType:"application/pdf")
                       }
                   }else{
                       if let image = self.uploadedImage2 {
                           multipartFormData.append(UIImageJPEGRepresentation(self.uploadedImage2, 0.5)!, withName: "Certificate", fileName: self.prescriptionFileName2, mimeType: "image/jpg")
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
                        print("JSON 2nd: \(JSON)")
                       if let dictionaryRes = JSON as? NSDictionary
                       {
                            if let status = dictionaryRes["Status"] as? Bool {
                                if status == true {
                                    print("second twin updateDifferently api call")
                                   let array = [DependantDBRecords]()
                                   self.newTwinsDelegate?.twinsUpdated(positionFirst: 1, positionSecond: 2, dataArray: array, pairId: 1)
                                   self.dismiss(animated: true, completion: nil)
                                                                    
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
    

        func uploadCertificateDataToServerEdit1(parameters:NSDictionary,obj:DependantDBRecords,url2:String) {
            self.showPleaseWait(msg: "Please Wait")

            var paramStr = ""
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: parameters,
                options: .prettyPrinted
                ),
                let theJSONText = String(data: theJSONData,
                                         encoding: String.Encoding.ascii) {

                paramStr = theJSONText
                print("JSON string 1st= \n\(theJSONText)")
                print(paramStr.data(using: String.Encoding.utf8)!)
            }

            Alamofire.upload(multipartFormData: { (multipartFormData) in

                multipartFormData.append(paramStr.data(using: String.Encoding.utf8)!, withName: "ChildData")

                //set Prescription Image
                var mainAge = 0
                if self.firstChildAge != 0 {
                    mainAge = self.firstChildAge
                }else{
                    mainAge = 0
                }
                
                if self.isDiffAbled1 == true && mainAge > 25 {
                    
                        if self.isFile1 == "IMG" {
                           if let image = self.uploadedImage1 {
                               multipartFormData.append(UIImageJPEGRepresentation(self.uploadedImage1, 0.5)!, withName: "Certificate", fileName: self.prescriptionFileName1, mimeType: "image/jpg")
                           }
                       }else if self.isFile1 == "DOC"{
                           if self.uploadedUrl1 != nil {
                                   let pdfData = try! Data(contentsOf: self.uploadedUrl1.asURL())
                                   var data : Data = pdfData
                                   multipartFormData.append(pdfData, withName: "Certificate", fileName: self.prescriptionFileName1, mimeType:"application/pdf")
                           }
                       }else{
                           if let image = self.uploadedImage1 {
                               multipartFormData.append(UIImageJPEGRepresentation(self.uploadedImage1, 0.5)!, withName: "Certificate", fileName: self.prescriptionFileName1, mimeType: "image/jpg")
                           }
                       }
                }
                
            }, to:APIEngine.shared.updateDifferentlyAbledChildJSONURL())
            { (result) in
                switch result {
                case .success(let upload, _, _):

                    //self.hidePleaseWait()
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })

                    upload.responseJSON { response in
                        //self.delegate?.showSuccessAlert()
                        print(response.request)  // original URL request
                        if let JSON = response.result.value {
                            print("JSON 1st: \(JSON)")
                           if let dictionaryRes = JSON as? NSDictionary
                           {
                                if let status = dictionaryRes["Status"] as? Bool {
                                    if status == true {
                                        print("First twin updateDifferently api call")
                                            self.editSecondDependantToServer(urlSec: url2, obj: DependantDBRecords())
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
                    //self.hidePleaseWait()
                    print(encodingError)
                }

            }

        }
    
    
    func uploadCertificateDataToServerEdit2(parameters:NSDictionary,obj:DependantDBRecords) {
        self.showPleaseWait(msg: "Please Wait")

        var paramStr = ""
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: parameters,
            options: .prettyPrinted
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {

            paramStr = theJSONText
            print("JSON string 2nd= \n\(theJSONText)")
            print(paramStr.data(using: String.Encoding.utf8)!)
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in

            multipartFormData.append(paramStr.data(using: String.Encoding.utf8)!, withName: "ChildData")

            //set Prescription Image
            var mainAge = 0
            if self.secondChildAge != 0 {
                mainAge = self.secondChildAge
            }else{
                mainAge = 0
            }
            if self.isDiffAbled2 == true && mainAge > 25 {
                if self.isFile2 == "IMG" {
                    if let image = self.uploadedImage2 {
                        multipartFormData.append(UIImageJPEGRepresentation(self.uploadedImage2, 0.5)!, withName: "Certificate", fileName: self.prescriptionFileName2, mimeType: "image/jpg")
                    }
                }else if self.isFile2 == "DOC"{
                    if self.uploadedUrl2 != nil {
                            let pdfData = try! Data(contentsOf: self.uploadedUrl2.asURL())
                            var data : Data = pdfData
                            multipartFormData.append(pdfData, withName: "Certificate", fileName: self.prescriptionFileName2, mimeType:"application/pdf")
                    }
                }else{
                    if let image = self.uploadedImage2 {
                        multipartFormData.append(UIImageJPEGRepresentation(self.uploadedImage2, 0.5)!, withName: "Certificate", fileName: self.prescriptionFileName2, mimeType: "image/jpg")
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
                        print("JSON 2nd: \(JSON)")
                       if let dictionaryRes = JSON as? NSDictionary
                       {
                            if let status = dictionaryRes["Status"] as? Bool {
                                if status == true {
                                    print("second twin updateDifferently api call")
                                   let array = [DependantDBRecords]()
                                   self.newTwinsDelegate?.twinsUpdated(positionFirst: 1, positionSecond: 2, dataArray: array, pairId: 1)
                                   self.dismiss(animated: true, completion: nil)
                                                                    
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

