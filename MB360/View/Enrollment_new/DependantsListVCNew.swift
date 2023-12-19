//
//  DependantsListVCNew.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 07/09/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation
import UIKit
import AVFAudio
import AVFoundation
import Photos
import AssetsLibrary
import MobileCoreServices

class DependantsListVCNew: UIViewController, tableCellDelegate, UIDocumentPickerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
   
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var formViewForDependent: UIView!
    
    @IBOutlet weak var txtRelation: SkyFloatingLabelTextField!
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDOB: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAge: SkyFloatingLabelTextField!
    
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var switchBtn: UISwitch!
    
    @IBOutlet weak var btnSwitchTwin1: UISwitch!
    
    @IBOutlet weak var btnSwitchTwin2: UISwitch!
    @IBOutlet weak var disabilityView: UIView!
    @IBOutlet weak var uploadDisableCertiBtn: UIButton!
    
    @IBOutlet weak var uploadDisableBtnTwin1: UIButton!
    
    @IBOutlet weak var uploadDisaleBtnTwin2: UIButton!
    @IBOutlet weak var FilenameVewT1: UIView!
    
    @IBOutlet weak var FilenameVewT2: UIView!
    
    @IBOutlet weak var deleteDisableBtnT1: UIButton!
    @IBOutlet weak var lblSelectedFileT1: UILabel!
    
    @IBOutlet weak var lblSelectedFileT2: UILabel!
    
    @IBOutlet weak var deleteDisableBtnT2: UIButton!
    
    @IBOutlet weak var selectedFileNameView: UIView!
    @IBOutlet weak var selectedFileNameLbl: UILabel!
    @IBOutlet weak var deleteUploadDisableCertiBtn: UIButton!
    
    @IBOutlet weak var vewDisablitytwin1: UIView!
    
    @IBOutlet weak var vewDisablitytwin2: UIView!
    
    
    @IBOutlet weak var GenderView: UIStackView!
    
    @IBOutlet weak var radioBtnView: UIView!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var maleBtn: UIButton!
    
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var femaleBtn: UIButton!
    
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var otherBtn: UIButton!
    
    //Twins View
    
    @IBOutlet weak var viewBackTwins: UIView!
    @IBOutlet weak var viewFormTwins: UIView!
    
    @IBOutlet weak var txtNameTwin1: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtDobTwin1: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtAgeTwin1: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtNameTwin2: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtDobTwin2: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var txtAgeTwin2: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var btnFemaleTwin2: UIButton!
    @IBOutlet weak var btnMaleTwin2: UIButton!
    @IBOutlet weak var btnFemaleTwin1: UIButton!
    @IBOutlet weak var btnMaleTwin1: UIButton!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblAddNewDependent: UILabel!
    
    
    @IBOutlet weak var btnCancelTwins: UIButton!
    
    @IBOutlet weak var VewInnerDependent: UIView!
    
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    
    var lastContentOffset: CGFloat = 0 //ScrollViewDelegate
    var hideCollectionViewDelegate : HideCollectionViewProtocol? = nil
    
    
    var dependentDetailsStructJsonArray = [Dependent]()
    var copydependentDetailsStructJsonArray = [Dependent]()
    var m_employeedict : EMPLOYEE_INFORMATION?
    
    var animationsQueue = ChainedAnimationsQueue()
    var isLoaded = 0
    var position = -1
    var selectedYear: Int = 0
    var currentYear: Int = 0
    var currentAge:Int = 0
    var spouseGender = "FEMALE"
    var partnerGender = ""
    var countDownTime = ""
    var endDate : Date?
    var alertController: UIAlertController?
    var timer1 : Timer?
    var isDisabled : Bool = false
    var globalSrNo = ""
    var globalRelationId = ""
    var globalGender = ""
    var globalGenderT1 = ""
    var globalGenderT2 = ""
    var relationGrp : [String] = ["SPOUSE","PARTNER","SON","DAUGHTER","TWINS"]
    var relationIdDict  : [String : String] = ["SPOUSE":"18"]
    var arrRelation : [Relation] = []
    var documentPicker = UIDocumentPickerViewController(documentTypes: ["public.composite-content"], in: .import)
    fileprivate var currentVC: UIViewController?
    var newPic = false
    var fromEdit : Bool = false
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    var m_selectedFileName = String()
    var m_filesArray = Array<String>()
    var m_attachedDocumentsArray = Array<Any>()
    var m_fileUrl: URL?
    let m_typeArray = ["png","jpg","jpeg","doc","docx","xml","xls","xlsx","pdf"]
    var isDisabledT1 = false
    var isDisabledT2 = false
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Testing SHubham:
       // get_relationGroup()
        UserDefaults.standard.set("1", forKey: "IsWindowPeriodOpen")
        UserDefaults.standard.set("0", forKey: "IsEnrollmentSaved")
        
        print("Inside DependantsListVCNew")
        tableView.delegate = self
        tableView.dataSource = self
//        txtDobTwin1.delegate = self
//        txtNameTwin1.delegate = self
//        txtDobTwin1.becomeFirstResponder()
//        txtNameTwin1.becomeFirstResponder()
        vewDisablitytwin1.isHidden = true
        vewDisablitytwin2.isHidden = true
        formViewForDependent.isHidden = true
        uploadDisableCertiBtn.layer.cornerRadius = uploadDisableCertiBtn.frame.size.height / 2
        selectedFileNameView.layer.cornerRadius = selectedFileNameView.frame.size.height / 2
        btnCancel.layer.cornerRadius = btnCancel.frame.size.height / 2
        btnCancelTwins.layer.cornerRadius = btnCancelTwins.frame.size.height / 2
        formViewForDependent!.layer.cornerRadius = 15//formViewForDependent.frame.size.height / 2
        viewFormTwins!.layer.cornerRadius = 15
        VewInnerDependent!.layer.cornerRadius = 15
        //formViewForDependent.layer.masksToBounds = true
        deleteUploadDisableCertiBtn.layer.cornerRadius = 0.1
        
        uploadDisableBtnTwin1.layer.cornerRadius = uploadDisableBtnTwin1.frame.size.height / 2
        FilenameVewT1.layer.cornerRadius = FilenameVewT1.frame.size.height / 2
        deleteDisableBtnT1.layer.cornerRadius = 0.1
        
        uploadDisaleBtnTwin2.layer.cornerRadius = uploadDisaleBtnTwin2.frame.size.height / 2
        FilenameVewT2.layer.cornerRadius = FilenameVewT2.frame.size.height / 2
        deleteDisableBtnT2.layer.cornerRadius = 0.1
        btnCancel.layer.borderColor = UIColor.red.cgColor
        btnCancel.layer.borderWidth = 1.0
        btnCancelTwins.layer.borderColor = UIColor.red.cgColor
        btnCancelTwins.layer.borderWidth = 1.0
        radioBtnView.isHidden = true
        
        maleBtn.isSelected = false
        femaleBtn.isSelected = false
        otherBtn.isSelected = false
        maleBtn.setImage(UIImage(named: "blue radio checked"), for: .normal)
        femaleBtn.setImage(UIImage(named: "blue radio"), for: .normal)
        otherBtn.setImage(UIImage(named: "blue radio"), for: .normal)
        
        viewBackTwins.isHidden = true
        viewFormTwins.isHidden = true
        
       
        tableView.register(CellForExistingDependants.self, forCellReuseIdentifier: "CellForExistingDependants")
        tableView.register(UINib(nibName: "CellForExistingDependants", bundle: nil), forCellReuseIdentifier: "CellForExistingDependants")
        
        tableView.register(CellForInstructionHeaderCell.self, forCellReuseIdentifier: "CellForInstructionHeaderCell")
        tableView.register(UINib(nibName: "CellForInstructionHeaderCell", bundle: nil), forCellReuseIdentifier: "CellForInstructionHeaderCell")
        
        
        //Add New Dependants Cell
        tableView.register(CellForNewDependants.self, forCellReuseIdentifier: "CellForNewDependants")
        tableView.register(UINib(nibName: "CellForNewDependants", bundle: nil), forCellReuseIdentifier: "CellForNewDependants")
        currentYear = Calendar.current.component(.year, from: Date())
        getStructureDataForDependentDetails()
        let currentDate = getCurrentDate()
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        endDate = dateFormatter.date(from: GlobalendDate)
        
        if currentDate.compare(endDate!) == .orderedAscending {
        print("current date is small")
            isDisabled = false
            timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }else{
            print("current date is big")
            isDisabled = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // getWindowPeriodDetails()
       // getStructureDataForDependentDetails()
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
            
            print(difference.day)     // 105
            print(difference.hour)    // 2
            print(difference.minute)  // 5
            print(difference.second)  // 30
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
                    //self.endDate = endD
                    
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
    
    func get_relationGroup(){
        let appendUrl = "http://localhost:3000/get_relations"
        
        webServices().getDataForEnrollment(appendUrl, completion: { (data,error) in
            if error == ""{
                do{
                    let json = try JSONDecoder().decode(GetRelationGroup.self, from: data)
                    let dataArray = json.relations
                    self.arrRelation = json.relations
                    self.relationGrp = []
                    for val in dataArray{
                        self.relationGrp.append(val.relationName)
                    }
                    print("relation: \(self.relationGrp)")
                }catch{
                    
                }
            }else{
                DispatchQueue.main.async{
                    self.showAlert(message: error)
                }
            }
            
        })
    }
  
    func getStructureDataForDependentDetails(){
        if(isConnectedToNetWithAlert()){
        
            let appendUrl = "GetDependants?Windowperiodactive=1&Grpchildsrno=1024&Oegrpbasinfsrno=1047&EmpSrNo=61787"
           // self.dependentDetailsStructJsonArray.removeAll()
            webServices().getDataForEnrollment(appendUrl, completion: { (data,error) in
                print(data)
                if error == ""{
                    do{
                        let json = try JSONDecoder().decode([Dependent].self, from: data)
                        print("The json is ",json)
                        let dataArray = json
                        
                        print("Data Array : ",dataArray)
                        self.dependentDetailsStructJsonArray = []
                        var arr2 : [String] = []
                        var isPresentTwins : Bool = false
                       
                        DispatchQueue.main.sync {
                            //for existing filled tabs
                            for item in dataArray {
                                self.dependentDetailsStructJsonArray.append(item)
                                if item.isTwins?.uppercased() == "YES"{
                                  isPresentTwins = true
                                }
                                arr2.append(item.relation!.uppercased())
                            }
                            var arrFilter = self.relationGrp.filter{ !arr2.contains($0) }
                            print(arrFilter)
                            
            
                            
                            for i in 0..<arrFilter.count{
                                if isPresentTwins && arrFilter[i] == "TWINS"{
                                    arrFilter.remove(at: i)
                                    break
                                }
                            }
                            
                            //for add tabs
                            for val in arrFilter{
                                if (val.uppercased() == "PARTNER" && !arr2.contains("SPOUSE")) || (val.uppercased() == "SPOUSE" && !arr2.contains("PARTNER")) {
                                    var newDepedent: Dependent = Dependent.init()
                                    newDepedent.relation = val
                                    newDepedent.name = ""
                                    newDepedent.age = ""
                                    newDepedent.dateOfBirth = ""
                                    self.dependentDetailsStructJsonArray.append(newDepedent)
                                }else if val.uppercased() == "SON" || val.uppercased() == "DAUGHTER" || val.uppercased() == "TWINS"{
                                    var newDepedent: Dependent = Dependent.init()
                                    newDepedent.relation = val
                                    newDepedent.name = ""
                                    newDepedent.age = ""
                                    newDepedent.dateOfBirth = ""
                                    self.dependentDetailsStructJsonArray.append(newDepedent)
                                }
                                
                                
                                
                                
                               
                                
                            }
                            print(self.dependentDetailsStructJsonArray)
                           
                            if self.isLoaded == 0 {
                                self.animateTable()

                            }
                            else {
                                self.tableView.reloadData()
                            }
                        }
                    }catch let parsingError{
                        print("Error", parsingError)
                    }
                }
                
            })
        }
    }
  
    @IBAction func btnCancelAct(_ sender: Any) {
        viewFormTwins.isHidden = true
    }
    
    @IBAction func btnAddTwinAct(_ sender: Any) {
        if isConnectedToNetWithAlert(){
            if !isDisabled{
                if validationsTwins(){
                    let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
                    
                    m_employeedict=userArray[0]
                    
                    var oe_group_base_Info_Sr_No = String()
                    var groupChildSrNo = String()
                    var empSrNo = String()
                    var relationIdT1 = String()
                    var relationIdt2 = String()
                
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
                    
                    if globalGenderT1.uppercased() == "MALE"{
                        relationIdT1 = "3"
                    }else{
                        relationIdT1 = "4"
                    }
                    if globalGenderT2.uppercased() == "MALE"{
                        relationIdt2 = "3"
                    }else{
                        relationIdt2 = "4"
                    }
                    let appendUrl = "AddDependant?Employeesrno=\(empSrNo)&Relationid=\(relationIdT1)&Personname=\(txtNameTwin1.text!)&Dateofmarriage=&Windowperiodactive=1&Grpchildsrno=\(groupChildSrNo)&Oegrpbasinfosrno=\(oe_group_base_Info_Sr_No)&Gender=\(globalGenderT1)&IsTwins=1&ParentalPremium=0&Age=\(txtAgeTwin1.text!)&Dateofbirth=\(txtDobTwin1.text!)"
                    var dict : [String:Any] = [:]
                    DispatchQueue.main.async{
                        webServices().postDataForEnrollment(appendUrl, dict, completion: { (data,error) in
                            if error == ""{
                                print("add t1",data)

                               
                                
                                DispatchQueue.main.async {
                                    let appendUrl1 = "AddDependant?Employeesrno=\(empSrNo)&Relationid=\(relationIdt2)&Personname=\(self.txtNameTwin2.text!)&Dateofmarriage=&Windowperiodactive=1&Grpchildsrno=\(groupChildSrNo)&Oegrpbasinfosrno=\(oe_group_base_Info_Sr_No)&Gender=\(self.globalGenderT2)&IsTwins=1&ParentalPremium=0&Age=\(self.txtAgeTwin2.text!)&Dateofbirth=\(self.txtDobTwin2.text!)"
                                    
                                    webServices().postDataForEnrollment(appendUrl1, dict, completion: { (data,error) in
                                        if error == ""{
                                            print("add t2",data)
                                            DispatchQueue.main.async{
                                                self.viewFormTwins.isHidden = true
                                            }
                                            self.getStructureDataForDependentDetails()
                                        }else{
                                            self.showAlert(message: error)
                                        }
                                    })
                                }
                            }else{
                                self.showAlert(message: error)
                            }
                            
                        })
                    }
                    
                    
                }}}
    }
    
    
    @IBAction func btnSwitchT1Act(_ sender: UISwitch) {
        if sender.isOn {
            uploadDisableBtnTwin1.isEnabled = true
            uploadDisableBtnTwin1.backgroundColor =  UIColor(hexString: "#5487D9")
            FilenameVewT1.backgroundColor = UIColor(hexString: "#5487D9")
            lblSelectedFileT1.isHidden = false
            vewDisablitytwin1.isHidden = false
        }else{
            uploadDisableBtnTwin1.isEnabled = false
            uploadDisableBtnTwin1.backgroundColor = UIColor.lightGray
            FilenameVewT1.backgroundColor = UIColor.lightGray
            lblSelectedFileT1.isHidden = true
            vewDisablitytwin1.isHidden = true
        }
    }
    
    
    @IBAction func tnSwitchT2Act(_ sender: UISwitch) {
        if sender.isOn {
            uploadDisaleBtnTwin2.isEnabled = true
            uploadDisaleBtnTwin2.backgroundColor =  UIColor(hexString: "#5487D9")
            FilenameVewT2.backgroundColor = UIColor(hexString: "#5487D9")
            lblSelectedFileT2.isHidden = false
            vewDisablitytwin2.isHidden = false
        }else{
            uploadDisaleBtnTwin2.isEnabled = false
            uploadDisaleBtnTwin2.backgroundColor = UIColor.lightGray
            FilenameVewT2.backgroundColor = UIColor.lightGray
            lblSelectedFileT2.isHidden = true
            vewDisablitytwin2.isHidden = true
        }
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch){
        if sender.isOn {
            uploadDisableCertiBtn.isEnabled = true
            uploadDisableCertiBtn.backgroundColor =  UIColor(hexString: "#5487D9")
            selectedFileNameView.backgroundColor = UIColor(hexString: "#5487D9")
            selectedFileNameLbl.isHidden = false
        }else{
            uploadDisableCertiBtn.isEnabled = false
            uploadDisableCertiBtn.backgroundColor = UIColor.lightGray
            selectedFileNameView.backgroundColor = UIColor.lightGray
            selectedFileNameLbl.isHidden = true
        }
    }
    
    @IBAction func uploadTapped(_ sender: Any) {
        print("upload tap..")
        documentPicker.delegate = self
        //
        
        
        let AddQeryVC :DependantsListVCNew = (DependantsListVCNew() as? DependantsListVCNew)!
        showAttachmentActionSheet(vc: AddQeryVC)
        
    }
    
    func showAttachmentActionSheet(vc: UIViewController)
    {
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.file, style: .default, handler: { (action) -> Void in
            self.openDocumentPicker()
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        //        let topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        //        topWindow?.rootViewController = UIViewController()
        //        topWindow?.windowLevel = UIWindow.Level.init(2)
        //        topWindow?.makeKeyAndVisible()
        //        topWindow?.rootViewController?.present(actionSheet, animated: true, completion: nil)
        
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        //        DispatchQueue.main.async {
        //            self.getTopMostViewController()?.present(actionSheet, animated: true, completion: nil)
        //        }
    }
    
    
    @IBAction func uploadTappedT2(_ sender: Any) {
        documentPicker.delegate = self
        //
        isDisabledT2 = true
        isDisabledT1 = false
        let AddQeryVC :DependantsListVCNew = (DependantsListVCNew() as? DependantsListVCNew)!
        showAttachmentActionSheet(vc: AddQeryVC)
    }
    
    @IBAction func uploadTappedT1(_ sender: Any) {
        documentPicker.delegate = self
        //
        isDisabledT1 = true
        isDisabledT2 = false
        let AddQeryVC :DependantsListVCNew = (DependantsListVCNew() as? DependantsListVCNew)!
        showAttachmentActionSheet(vc: AddQeryVC)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {

                   let cico = url as URL
                   print(cico)
                   print(url)

                   print(url.lastPathComponent)

                   print(url.pathExtension)

                  }
      
    
    
    @IBAction func deleteTappedT1(_ sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        print(m_filesArray)
        print(indexpath.row)
        self.m_filesArray.remove(at: indexpath.row)
        self.m_attachedDocumentsArray.remove(at: indexpath.row)
        self.lblSelectedFileT1.text = "File name data"
    }
    
    
    @IBAction func deleteTappedT2(_ sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        print(m_filesArray)
        print(indexpath.row)
        self.m_filesArray.remove(at: indexpath.row)
        self.m_attachedDocumentsArray.remove(at: indexpath.row)
        self.lblSelectedFileT2.text = "File name data"
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        self.m_filesArray.remove(at: indexpath.row)
        self.m_attachedDocumentsArray.remove(at: indexpath.row)
        self.selectedFileNameLbl.text = "File name data"
    }
    
    
    @IBAction func maleBtnTapped(_ sender: Any) {
        maleBtn.setImage(UIImage(named: "blue radio checked"), for: .normal)
        femaleBtn.setImage(UIImage(named: "blue radio"), for: .normal)
        otherBtn.setImage(UIImage(named: "blue radio"), for: .normal)
        partnerGender = "MALE"
        globalGender = "MALE"
        
    }
    
    
    @IBAction func btnMaleTwin1Act(_ sender: Any) {
        btnMaleTwin1.setImage(UIImage(named: "blue radio checked"), for: .normal)
        btnFemaleTwin1.setImage(UIImage(named: "blue radio"), for: .normal)
        globalGenderT1 = "MALE"
        
       
    }
    
    
    @IBAction func btnFemaleTwin1Act(_ sender: Any) {
        btnFemaleTwin1.setImage(UIImage(named: "blue radio checked"), for: .normal)
        btnMaleTwin1.setImage(UIImage(named: "blue radio"), for: .normal)
        globalGenderT1 = "FEMALE"
    }
    
    
    @IBAction func btnMaleTwin2Act(_ sender: Any) {
        btnMaleTwin2.setImage(UIImage(named: "blue radio checked"), for: .normal)
        btnFemaleTwin2.setImage(UIImage(named: "blue radio"), for: .normal)
        globalGenderT2 = "MALE"
      
    }
    
    @IBAction func btnFemaleTwin2Act(_ sender: Any) {
        btnFemaleTwin2.setImage(UIImage(named: "blue radio checked"), for: .normal)
        btnMaleTwin2.setImage(UIImage(named: "blue radio"), for: .normal)
        globalGenderT2 = "FEMALE"
    }
    
    @objc func TimerAct(sender: UIButton){
        let indexpath2 = IndexPath(row: sender.tag, section: 0)
        if !isDisabled{
            showAlert()
        }else{
            self.showAlert(message: "Window Period is expired.")
        }
    }

   
    @IBAction func femaleBtnTapped(_ sender: Any) {
        maleBtn.setImage(UIImage(named: "blue radio"), for: .normal)
        femaleBtn.setImage(UIImage(named: "blue radio checked"), for: .normal)
        otherBtn.setImage(UIImage(named: "blue radio"), for: .normal)
        partnerGender = "FEMALE"
        globalGender = "FEMALE"
    }
    
    @IBAction func otherBtnTapped(_ sender: Any) {
        maleBtn.setImage(UIImage(named: "blue radio"), for: .normal)
        femaleBtn.setImage(UIImage(named: "blue radio"), for: .normal)
        otherBtn.setImage(UIImage(named: "blue radio checked"), for: .normal)
        partnerGender = "OTHER"
        globalGender = "OTHER"
    }
}

extension DependantsListVCNew: UITableViewDelegate,UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0 { //Added Dependant + Top Cell
            return 1
        }
        else {
            //return  structDataSource.count
            print("array count:",dependentDetailsStructJsonArray.count)
            return  dependentDetailsStructJsonArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if  indexPath.section == 0{
            let cell : CellForInstructionHeaderCell = tableView.dequeueReusableCell(withIdentifier: "CellForInstructionHeaderCell", for: indexPath) as! CellForInstructionHeaderCell
            cell.imgView.image = UIImage(named:"dependantList")
            cell.lblHeaderName.text = "Dependant Details"
            cell.lblDescription.text = "you can add upto 3 dependants \n Spouse or Partner + 2 children"
            print("Indexpath1: ",indexPath.row)
            cell.lblTimer.tag = indexPath.row
            if !isDisabled{
                cell.lblTimer.text = countDownTime
            }else{
                cell.lblTimer.text = "Window Period is expired."
            }
            return cell
        }else{
            //let cell = UITableViewCell()
           // if !isDisabled{
               // print("dependentDetailsStructJsonArray2 : ",dependentDetailsStructJsonArray[indexPath.row].relation ?? "empty")
                
                var data = dependentDetailsStructJsonArray[indexPath.row]
                
                print("dependentDetailsStructJsonArray2:",data)
                if data.name == ""{
                    let cell : CellForNewDependants = tableView.dequeueReusableCell(withIdentifier: "CellForNewDependants", for: indexPath) as! CellForNewDependants
                    cell.lblGst.isHidden = true
                    
                    if let IsWindowPeriodOpen = UserDefaults.standard.value(forKey: "IsWindowPeriodOpen") as? String  {
                        
                        if let IsEnrollmentSaved = UserDefaults.standard.value(forKey: "IsEnrollmentSaved") as? String  {
                            //Added on 30Aug2022
                            if IsWindowPeriodOpen == "1" && IsEnrollmentSaved == "0" {
                                //if IsWindowPeriodOpen == "0" && IsEnrollmentSaved == "0" {
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
                    cell.lblName.text = dependentDetailsStructJsonArray[indexPath.row].relation?.capitalizingFirstLetter()
                    //cell.lblName.text = structDataSource[indexPath.row].relationname?.capitalizingFirstLetter()
                    return cell
                    
                    
                }
                else{
                    
                    let cell : CellForExistingDependants = tableView.dequeueReusableCell(withIdentifier: "CellForExistingDependants", for: indexPath) as! CellForExistingDependants
                    
                    cell.m_nameTextField.text = data.name?.firstCharacterUpperCase()
                    cell.m_dobTextField.text = data.dateOfBirth
                    let age = "(\(String(describing: data.age!)) Years)"
                    cell.m_ageTextField.text = age
                    cell.m_titleLbl.text = data.relation
                    
                    if data.isTwins?.uppercased() == "YES"{
                        cell.imgTwins.isHidden = false
                    }else{
                        cell.imgTwins.isHidden = true
                    }
                    
                    if data.relation?.uppercased() == "PARTNER"{
                        if data.gender?.uppercased() == "MALE"{
                            cell.imgView.image = UIImage(named:"Husband") //Male
                        }
                        else if data.gender?.uppercased() == "FEMALE"{
                            cell.imgView.image = UIImage(named:"Asset 57")   //Female
                        }
                        else{
                            cell.imgView.image = UIImage(named:"partner_icon") //Other
                        }
                    }
                    else if data.relation?.uppercased() == "SPOUSE"{
                        /*
                         if data.Gender?.uppercased() == "MALE"{
                         cell.imgView.image = UIImage(named:"Husband") //Male
                         }
                         else if data.Gender?.uppercased() == "FEMALE"{
                         cell.imgView.image = UIImage(named:"Asset 57")   //Female
                         }
                         */
                        if spouseGender.uppercased() == "FEMALE"{
                            cell.imgView.image = UIImage(named:"Asset 57")   //Female
                        }else{
                            cell.imgView.image = UIImage(named:"Husband") //Male
                        }
                        
                    }
                    else if data.relation?.uppercased() == "SON"{
                        cell.imgView.image = UIImage(named:"sonNew")
                    }
                    else if data.relation?.uppercased() == "DAUGHTER"{
                        cell.imgView.image = UIImage(named:"Asset 56")
                    }
                    else if data.relation?.uppercased() == "TWINS"{
                        cell.imgView.image = UIImage(named:"twins")
                    }
                    
                    if let IsWindowPeriodOpen = UserDefaults.standard.value(forKey: "IsWindowPeriodOpen") as? String  {
                        
                        if let IsEnrollmentSaved = UserDefaults.standard.value(forKey: "IsEnrollmentSaved") as? String  {
                            //Added on 30Aug2022
                            if IsWindowPeriodOpen == "1" && IsEnrollmentSaved == "0" {
                                //if IsWindowPeriodOpen == "0" && IsEnrollmentSaved == "0" {
                                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFromEditIcon(_:)))
                                cell.m_editButton.addGestureRecognizer(tapGesture)
                                
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
                                position = indexPath.row
                                
                                hideDeleteView(cell: cell)
                                
                                if data.canDelete == true {
                                    cell.m_backGroundView.addGestureRecognizer(leftRecognizer)
                                    cell.m_backGroundView.addGestureRecognizer(rightRecognizer)
                                }
                                else {
                                    cell.m_backGroundView.gestureRecognizers = nil
                                }
                                
                                data.index = indexPath.row
                                cell.getIndex(indexPath.row)
                                
//                                cell.m_deleteButton.addTarget(self, action: #selector(deleteButtonClicked(_:)), for: .touchUpInside)
                                cell.delegate = self
                               
                                let dates = getCurrentDate()//dateFormatter.string(from: Date())
                                var minAge = dependentDetailsStructJsonArray[indexPath.row].minAge
                                var maxAge = dependentDetailsStructJsonArray[indexPath.row].maxAge
                                var minDate = Calendar.current.date(byAdding: .year, value: -Int(minAge)!, to: dates)!
                                var maxDate = Calendar.current.date(byAdding: .year, value: -Int(maxAge)!, to: dates)!
                                var datestr : Date = Date()
                                
                                if #available(iOS 13.4, *) {
                                  //  self.txtDOB.addInputViewDatePicker(target: self, selector: #selector(self.doneButtonPressed))
                                    self.txtDOB.addInputViewDatePicker(maxDate,minDate, target: self, selector: #selector(self.doneButtonPressed))
                                    self.txtDobTwin1.addInputViewDatePicker(maxDate,minDate, target: self, selector: #selector(self.doneButtonPressedT1))
                                    self.txtDobTwin2.addInputViewDatePicker(maxDate,minDate, target: self, selector: #selector(self.doneButtonPressedT2))
                                } else {
                                    // Fallback on earlier versions
                                }
                                
                            }
                            else {
                            }
                        }
                        else {
                        }
                    }
                    
                    return cell
                }
                
//            }else{
//                self.showAlert(message: "Window Period is expired.")
//            }
//            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoaded == 0 {
               //isLoaded = 1
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section != 0 {
    if dependentDetailsStructJsonArray.count > indexPath.row {
        /*if dependentDetailsStructJsonArray[indexPath.row].IsDisabled == false {
    return true
    }*/
    return false
    }
    return false
    }
    return false
    
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 240//UITableViewAutomaticDimension
        }
        else {
            // let totalRows = tableView.numberOfRows(inSection: indexPath.section)
            // if indexPath.row != totalRows - 1 {
            //let dict = structDataSource[indexPath.row]
            let dict = dependentDetailsStructJsonArray[indexPath.row]
            
            //if dict.isDisabled == false {
                return 130
                
//            }
//            else {
//                return UITableViewAutomaticDimension
//                
//            }
        }
    }
    
    
}

extension DependantsListVCNew{
    
    func animateTable() {
        
        tableView.reloadData(){
            self.isLoaded = 1
        }
        
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

    @objc func handleTap(_ sender: UISwipeGestureRecognizer) {
        if !isDisabled{
            resetFormView()
            let tapLocation = sender.location(in: self.tableView)
            let indexPath:IndexPath = self.tableView.indexPathForRow(at: tapLocation) as! IndexPath
            var data = dependentDetailsStructJsonArray[indexPath.row]
            
            print("Inside Tapped : ",data," : ",indexPath.row)
            fromEdit = false
            
            if data.relation?.uppercased() == "TWINS"{
                viewBackTwins.isHidden = false
                viewFormTwins.isHidden = false
                self.lblSelectedFileT1.text = "File name data"
                self.lblSelectedFileT2.text = "File name data"
                btnMaleTwin1Act(self)
                btnMaleTwin2Act(self)
                /*let addDependant  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"AddTwinsVC1") as! AddDisabledTwinsVC
                 
                 self.navigationController?.present(addDependant, animated: true, completion: nil)
                 */
            }
            else{
                viewBackTwins.isHidden = true
                viewFormTwins.isHidden = true
                lblAddNewDependent.text = "add new dependent"
                btnAdd.setTitle("add", for: .normal)
                if data.gender == ""{
                    if data.relation?.uppercased() == "SON"{
                        globalGender = "MALE"
                    }else if data.relation?.uppercased() == "DAUGHTER"{
                        globalGender = "FEMALE"
                    }
                }
                
                if data.isDisabled == true{
                    
                }
                else if data.relation?.uppercased() == "PARTNER"{
                    formViewForDependent.isHidden = false
                    txtRelation.text = data.relation?.uppercased()
                    txtName.text = ""
                    txtAge.text = ""
                    txtDOB.text = ""
                    position = indexPath.row
                    radioBtnView.isHidden = false
                    maleBtnTapped(self)
                    self.selectedFileNameLbl.text = "File name data"
                    
                }else{
                    formViewForDependent.isHidden = false
                    txtRelation.text = data.relation?.uppercased()
                    txtName.text = ""
                    txtAge.text = ""
                    txtDOB.text = ""
                    position = indexPath.row
                    radioBtnView.isHidden = true
                    self.selectedFileNameLbl.text = "File name data"
                    
                }
                
                if data.relation?.uppercased() == "SPOUSE"{
                    var userGender = UserDefaults.standard.value(forKey: "LoginUserGender") as? String
                    if userGender?.uppercased() == "MALE"{
                        globalGender = "FEMALE"
                    }else{
                        globalGender = "MALE"
                    }
                }
            }
        }else{
           // self.showAlert(message: "Window Period is expired.")
        }
    }
    
    @objc func handleTapFromEditIcon(_ sender: UISwipeGestureRecognizer) {
        if !isDisabled{
            fromEdit = true
            let tapLocation = sender.location(in: self.tableView)
            let indexPath:IndexPath = self.tableView.indexPathForRow(at: tapLocation) as! IndexPath
            var data = dependentDetailsStructJsonArray[indexPath.row]
            
            print("Inside Tapped : ",tapLocation," : ",indexPath.row)
            globalSrNo = data.personSrNo!
            globalRelationId = data.relationID!
            globalGender = data.gender!
            
            formViewForDependent.isHidden = false
            lblAddNewDependent.text = "edit dependent"
            btnAdd.setTitle("save", for: .normal)
            txtRelation.text = data.relation?.uppercased()
            txtName.text = data.name?.firstCharacterUpperCase()
            txtDOB.text = data.dateOfBirth
            let year = data.dateOfBirth
            print("Year: ",year!.substring(from: year!.index(year!.endIndex, offsetBy: -4)))
            selectedYear = Int(year!.substring(from: year!.index(year!.endIndex, offsetBy: -4)))!
            
            currentAge = currentYear - selectedYear
            txtAge.text = data.age//String(currentAge)
            position = indexPath.row
            radioBtnView.isHidden = true
            
            
        }
            
//            if data.relation?.uppercased() == "TWINS"{
//
//            }
//            else{
//                if data.isDisabled == true{
//
//                }
//                else if data.relation?.uppercased() == "PARTNER"{
//                    formViewForDependent.isHidden = false
//                    txtRelation.text = data.relation?.uppercased()
//                    txtName.text = ""
//                    txtAge.text = ""
//                    txtDOB.text = ""
//                    let year = data.dateOfBirth
//                    print("Year: ",year!.substring(from: year!.index(year!.endIndex, offsetBy: -4)))
//                    selectedYear = Int(year!.substring(from: year!.index(year!.endIndex, offsetBy: -4)))!
//
//                    currentAge = currentYear - selectedYear
//                    txtAge.text = String(currentAge)
//
//                    position = indexPath.row
//                    radioBtnView.isHidden = false
//                }
//                else{
//                    formViewForDependent.isHidden = false
//                    txtRelation.text = data.relation?.uppercased()
//                    txtName.text = data.name?.firstCharacterUpperCase()
//                    txtDOB.text = data.dateOfBirth
//                    let year = data.dateOfBirth
//                    print("Year: ",year!.substring(from: year!.index(year!.endIndex, offsetBy: -4)))
//                    selectedYear = Int(year!.substring(from: year!.index(year!.endIndex, offsetBy: -4)))!
//
//                    currentAge = currentYear - selectedYear
//                    txtAge.text = data.age//String(currentAge)
//                    position = indexPath.row
//                    radioBtnView.isHidden = true
//                }
//            }
//        }else{
//           // self.showAlert(message: "Window Period is expired.")
//        }
    }
   
    
    
    @IBAction func addBtnTapped(_ sender: Any) {
        if isConnectedToNetWithAlert(){
            if !isDisabled{
                if validations(){
                    if fromEdit{
                        let appendUrl = "UpdateDependant?Personsrno=\(globalSrNo)&Dependantname=\(txtName.text!)&Relationid=\(globalRelationId)&Gender=\(globalGender)&Age=\(txtAge.text!)&Dateofbirth=\(txtDOB.text!)"
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
                        
                    }else{
                        
                        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
                        
                        m_employeedict=userArray[0]
                        
                        var oe_group_base_Info_Sr_No = String()
                        var groupChildSrNo = String()
                        var empSrNo = String()
                        var relationId = "11"//String()
                        
                        for val in arrRelation{
                            if globalGender.uppercased() == val.relationName.uppercased(){
                                relationId = val.relationID
                                break
                            }
                        }
                    
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
                        
                        
                        let appendUrl = "AddDependant?Employeesrno=\(empSrNo)&Relationid=\(relationId)&Personname=\(txtName.text!)&Dateofmarriage=&Windowperiodactive=1&Grpchildsrno=\(groupChildSrNo)&Oegrpbasinfosrno=\(oe_group_base_Info_Sr_No)&Gender=\(globalGender)&IsTwins=0&ParentalPremium=0&Age=\(txtAge.text!)&Dateofbirth=\(txtDOB.text!)"
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
                    }
                    //            if position > -1{
                    //
                    //                if validations(){
                    //
                    //                    // for IsDisabled = false
                    //
                    //                    dependentDetailsStructJsonArray[position].name = txtName.text!
                    //                    dependentDetailsStructJsonArray[position].dateOfBirth = txtDOB.text!
                    //                    // print("Data is",selectedYear," : ",currentYear," : ",currentAge)
                    //                    dependentDetailsStructJsonArray[position].age = txtAge.text!
                    //                    dependentDetailsStructJsonArray[position].isDisabled = false
                    //
                    //                    if dependentDetailsStructJsonArray[position].relation?.uppercased() == "PARTNER"{
                    //                        dependentDetailsStructJsonArray[position].gender = partnerGender
                    //                        dependentDetailsStructJsonArray.remove(at: (position - 1))
                    //                    }
                    //                    else if dependentDetailsStructJsonArray[position].relation?.uppercased() == "SPOUSE"{
                    //                        dependentDetailsStructJsonArray[position].gender = spouseGender
                    //                        dependentDetailsStructJsonArray.remove(at: (position + 1))
                    //                    }
                    //
                    //
                    //
                    //                    tableView.reloadData()
                    //                    resetFormView()
                    //                }
                    //            }
                    
                    // print("Add btn Tapped ",dependentDetailsStructJsonArray[position])
                }else{
                    
                }
            }
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        formViewForDependent.isHidden = true
    }
    
    
    
    func resetFormView(){
        formViewForDependent.isHidden = true
        txtName.text = ""
        txtName.errorMessage = ""
        txtName.lineColor = UIColor.lightGray
        txtName.textColor = UIColor.black
        txtDOB.text = ""
        txtDOB.errorMessage = ""
        txtDOB.lineColor = UIColor.lightGray
        txtAge.text = ""
        switchBtn.isOn = false
        uploadDisableCertiBtn.backgroundColor = UIColor.lightGray
        uploadDisableCertiBtn.isEnabled = false
        selectedFileNameView.backgroundColor = UIColor.lightGray
        selectedFileNameLbl.textColor = UIColor.white
    }
    
}

extension DependantsListVCNew{
    //Animations
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch? = touches.first
        print("Touch is: ",touch)
        
        if(touch?.view == formViewForDependent){
               formViewForDependent.isHidden = true
           }
//        if(touch?.view == viewFormTwins){
//            viewBackTwins.isHidden = true
//            viewFormTwins.isHidden = true
//           }
    }
    
    private func validationsTwins() -> Bool {
        if(txtNameTwin1.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            txtNameTwin1.errorMessage="Enter Name"
            return false
        }else if(txtNameTwin2.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            txtNameTwin2.errorMessage="Enter Name"
            return false
        }

        else if(txtDobTwin1.text=="")
        {
            txtDobTwin1.errorMessage="Select Date of Birth"
            return false
        }else if(txtDobTwin2.text=="")
        {
            txtDobTwin2.errorMessage="Select Date of Birth"
            return false
        }else if (txtDobTwin1.text != txtDobTwin2.text){
            showAlert(message: "birth date should be same")
            return false
        }
            
        else {
//            if(txtName.text != "")
//            {
//                for i in 0..<dependentDetailsStructJsonArray.count{
//                    if txtName.text?.lowercased() ==
//                        dependentDetailsStructJsonArray[position].name?.lowercased(){
//                        print("Same data Added ")
//                        return true
//                    }
//                    else if txtName.text?.lowercased() ==
//                                dependentDetailsStructJsonArray[i].name?.lowercased(){
//                        self.displayActivityAlert(title: "Dependant name cannot be similar")
//                        return false
//                    }
//                }
//                return true
//            }
            return true
        }
        
    }
    
    private func validations() -> Bool {
        if(txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            txtName.errorMessage="Enter Name"
            return false
        }

        else if(txtDOB.text=="")
        {
            txtDOB.errorMessage="Select Date of Birth"
            return false
        }
        else {
            if(txtName.text != "")
            {
                for i in 0..<dependentDetailsStructJsonArray.count{
                    if txtName.text?.lowercased() ==
                        dependentDetailsStructJsonArray[position].name?.lowercased(){
                        print("Same data Added ")
                        return true
                    }
                    else if txtName.text?.lowercased() ==
                                dependentDetailsStructJsonArray[i].name?.lowercased(){
                        self.displayActivityAlert(title: "Dependant name cannot be similar")
                        return false
                    }
                }
                return true
            }
            return true
        }
        
    }
    
    @objc func doneButtonPressed(_ minage : String,_ maxage : String) {
        if let  datePicker = self.txtDOB.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            //dateFormatter.dateStyle = .medium
            self.txtDOB.text = dateFormatter.string(from: datePicker.date)
            selectedYear = datePicker.date.year
            currentYear = Calendar.current.component(.year, from: Date())
            print("selectedYear is: ",selectedYear)
            print("currentYear is: ",currentYear)
            currentAge = currentYear - selectedYear
            self.txtAge.text = String(currentAge)
        }
        self.txtDOB.resignFirstResponder()
     }
    
    @objc func doneButtonPressedT1(_ minage : String,_ maxage : String) {
        if let  datePicker = self.txtDobTwin1.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            //dateFormatter.dateStyle = .medium
            self.txtDobTwin1.text = dateFormatter.string(from: datePicker.date)
            selectedYear = datePicker.date.year
            currentYear = Calendar.current.component(.year, from: Date())
            print("selectedYear is: ",selectedYear)
            print("currentYear is: ",currentYear)
            currentAge = currentYear - selectedYear
            self.txtAgeTwin1.text = String(currentAge)
        }
        self.txtDobTwin1.resignFirstResponder()
     }
    
    @objc func doneButtonPressedT2(_ minage : String,_ maxage : String) {
        if let  datePicker = self.txtDobTwin2.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            //dateFormatter.dateStyle = .medium
            self.txtDobTwin2.text = dateFormatter.string(from: datePicker.date)
            selectedYear = datePicker.date.year
            currentYear = Calendar.current.component(.year, from: Date())
            print("selectedYear is: ",selectedYear)
            print("currentYear is: ",currentYear)
            currentAge = currentYear - selectedYear
            self.txtAgeTwin2.text = String(currentAge)
        }
        self.txtDobTwin2.resignFirstResponder()
     }
    
}

extension DependantsListVCNew:UIScrollViewDelegate {
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
}


extension DependantsListVCNew{
    
    //MARK:- Gesture Control - Add
    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
        print("Swipe made..")
        
        
        if sender.direction == .left {
            //self.tableView.reloadData()
 
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
                if !self.isDisabled{
                    cell.m_deleteButton.isHidden = false
                    cell.lblDelete.isHidden = false
                }else{
                    self.showAlert(message: "Window Period is expired.")
                }
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
    
    
    
    @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
        let index = IndexPath(row: sender.view!.tag, section: 1)
        
        guard let cell = tableView.cellForRow(at: index) as? CellForExistingDependants else {
            return
        }
        
        hideDeleteView(cell: cell)
 
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
   
    func passIndex(type: String, index: Int) {
        if type == "delete"{
            var srNo = dependentDetailsStructJsonArray[index].personSrNo!
            self.deleteDependant(msg:"Would you like to remove this dependant?", SrNo: srNo)
        }
    }
//    //MARK:- Delete Tapped...
//    @objc func deleteButtonClicked(_ sender: UIButton) {
//        print("Delete Dependant...\(sender.tag) : \(position)")
//
//        //Removing data from specific row
//
//
//        var data = dependentDetailsStructJsonArray[position]
//
//        if data.pairNo != "0"{
//
//        }
//        else{
//            let indexPath = IndexPath(row: sender.tag, section: 1)
//            var srNo = String()
//            if let perSrNo = data.personSrNo {
//                srNo = String(perSrNo)
//                self.deleteDependant(indexPath: indexPath,msg:"Would you like to remove this dependant?", SrNo: srNo)
//            }else{
//                self.deleteDependant(indexPath: indexPath,msg:"Would you like to remove this dependant?", SrNo: "")
//            }
//        }
//    }
  
    
    //MARK:- Actionsheet Delete
    private func deleteDependant(msg:String,SrNo:String) {
        
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .actionSheet)
 
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            var m_employeedict : EMPLOYEE_INFORMATION?

            m_employeedict=userArray[0]
           
            var groupChildSrNo = String()
            var empSrNo = String()
            
           
            if let groupChlNo = m_employeedict?.groupChildSrNo
            {
                groupChildSrNo=String(groupChlNo)
            }
            if let empSr = m_employeedict?.empSrNo
            {
                empSrNo = String(empSr)
            }
            var personSrNo = SrNo
            var appendUrl = "DeleteDependant?EmployeeSrNo=61787&GrpChildSrNo=1024&PersonSrNo=\(personSrNo)"
            var dict : [String:Any] = [:]
            
            webServices().postDataForEnrollment(appendUrl, dict, completion: { (data,error) in
                if error == ""{
                    print(data)
//                    var jsonData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                    var msg : AnyObject = jsonData["message"] as? AnyObject!
//                    var msgStr = msg["Message"] as? String
                    DispatchQueue.main.async{
                        //self.showAlert(message:"DEPENDANT DELETED SUCCESSFULLY")
                        self.getStructureDataForDependentDetails()
                    }
                }else{
                    self.showAlert(message: error)
                }
                
            })
            
            
//            if self.dependentDetailsStructJsonArray.count > 0{
//
//                var data = self.dependentDetailsStructJsonArray[self.position]
//
//                if data.relation?.uppercased() == "SPOUSE" && self.dependentDetailsStructJsonArray[self.position + 1].relation?.uppercased() != "PARTNER"{
//                    //self.dependentDetailsStructJsonArray[self.position].isAdded = false
//                    self.dependentDetailsStructJsonArray[self.position].name = ""
//                    self.dependentDetailsStructJsonArray[self.position].age = ""
//                    self.dependentDetailsStructJsonArray[self.position].dateOfBirth = ""
//                    var newDepedent: Dependent = Dependent.init()
//                    newDepedent.relation = "PARTNER"
//
//                    self.dependentDetailsStructJsonArray.insert(newDepedent, at: 1)
//                }
//                else if data.relation?.uppercased() == "PARTNER" && self.dependentDetailsStructJsonArray[self.position - 1].relation?.uppercased() != "SPOUSE"{
//                    //self.dependentDetailsStructJsonArray[self.position].isAdded = false
//                    self.dependentDetailsStructJsonArray[self.position].name = ""
//                    self.dependentDetailsStructJsonArray[self.position].age = ""
//                    self.dependentDetailsStructJsonArray[self.position].dateOfBirth = ""
//
//                    var newDepedent: Dependent = Dependent.init()
//                    newDepedent.relation = "SPOUSE"
//
//                    self.dependentDetailsStructJsonArray.insert(newDepedent, at: 0)
//                }
//                else{
//                   // self.dependentDetailsStructJsonArray[self.position].isAdded = false
//                    self.dependentDetailsStructJsonArray[self.position].name = ""
//                    self.dependentDetailsStructJsonArray[self.position].age = ""
//                    self.dependentDetailsStructJsonArray[self.position].dateOfBirth = ""
//                    if data.relation == "SON"{
//                        self.dependentDetailsStructJsonArray[self.position].relation = "SON"
//                    }
//                    else if data.relation == "DAUGHTER"{
//                        self.dependentDetailsStructJsonArray[self.position].relation = "DAUGHTER"
//                    }
//
//                }
//
//
//                if data.pairNo == "0" {
//
//                }
//                else{
//
//                    let twinArray = self.dependentDetailsStructJsonArray.filter({$0.pairNo == data.pairNo && $0.canDelete == true})
//
//                    //Refer DependantListVC
//                    print("Delete from server ",twinArray)
//
//                    }
//                }
            print("After delete updated data",self.dependentDetailsStructJsonArray)
            self.tableView.reloadData()
        }))
 
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
 
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    enum AttachmentType: String{
        case camera, video, photoLibrary
    }
    
    
    //MARK: - Constants
    struct Constants {
        static let actionFileTypeHeading = "Add a File"
        static let actionFileTypeDescription = "Choose a filetype to add..."
        static let camera = "Camera"
        static let phoneLibrary = "Phone Library"
        static let video = "Video"
        static let file = "File"
        
        
        static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        
        static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        
        static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
        
        
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
        
    }
    
    //MARK: - Authorisation Status
    // This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController){
        currentVC = vc
        
        let status = PHPhotoLibrary.authorizationStatus()
        print("status: ",status," attachmentTypeEnum : ",attachmentTypeEnum)
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera()
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video{
                videoLibrary()
            }
        case .denied:
            print("permission denied")
            self.addAlertForSettings(attachmentTypeEnum)
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    print("access given")
                    if attachmentTypeEnum == AttachmentType.camera{
                        self.openCamera()
                    }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                }else{
                    print("restriced manually")
                    self.addAlertForSettings(attachmentTypeEnum)
                }
            })
        case .restricted:
            print("permission restricted")
            self.addAlertForSettings(attachmentTypeEnum)
        default:
            break
        }
    }
    
    func openCamera(){
       
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            self.newPic = true
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - PHOTO PICKER
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            //            currentVC?.present(myPickerController, animated: true, completion: nil)
            
            DispatchQueue.main.async {
                self.getTopMostViewController()?.present(myPickerController, animated: true, completion: nil)
            }
            self.newPic = false
            
        }
    }
    
    
    func openDocumentPicker()
    {
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    //MARK: - VIDEO PICKER
    func videoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            //            currentVC?.present(myPickerController, animated: true, completion: nil)
            DispatchQueue.main.async {
                self.getTopMostViewController()?.present(myPickerController, animated: true, completion: nil)
            }
            self.newPic = false
            
        }
    }
    
    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType){
        print("attachmentTypeEnum: ",attachmentTypeEnum)
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera{
            alertTitle = Constants.alertForCameraAccessMessage
            print("AttachmentType.camera: ",AttachmentType.camera)
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary{
            alertTitle = Constants.alertForPhotoLibraryMessage
            print("AttachmentType.photoLibrary: ",AttachmentType.photoLibrary)
        }
        if attachmentTypeEnum == AttachmentType.video{
            alertTitle = Constants.alertForVideoLibraryMessage
            print("AttachmentType.video: ",AttachmentType.video)
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .default) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
        
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        //currentVC?.present(cameraUnavailableAlertController , animated: true, completion: nil)
        
        DispatchQueue.main.async {
            self.present(cameraUnavailableAlertController , animated: true, completion: nil)
        }
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    
}


extension DependantsListVCNew{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        getTopMostViewController()?.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.imagePickedBlock?(image)
            
            
            
            if newPic {
                
                //var obj = UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                
                
                m_attachedDocumentsArray.append(image)
                m_filesArray.append("camera_Image.jpg")
                
                displaySelectedFiles()
                
                
            } else {
                
                if #available(iOS 11.0, *) {
                    if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
                        print(imageURL)
                        m_fileUrl = imageURL
                        
                    }
                } else {
                    if let imageUrl = info[UIImagePickerControllerMediaURL] as? URL {
                        print(imageUrl)
                        m_fileUrl = imageUrl
                        
                    }
                }
                
                
                //uncommented by Pranit
                m_selectedFileName = m_fileUrl!.lastPathComponent
                let fileName = m_selectedFileName
                let fileNameArr = m_selectedFileName.characters.split{$0 == "."}.map(String.init)
                let type = fileNameArr[fileNameArr.count-1]
                
                //let type = ""
                
                if(m_typeArray.contains(type))
                {
                    
                    
                    print("import result :\(m_fileUrl)")
                    
                    m_filesArray.append(m_selectedFileName)
                    m_attachedDocumentsArray.append(m_fileUrl)
                    displaySelectedFiles()
                }
                else
                {
                    displayActivityAlert(title: "You can not upload \(type) files")
                }
            }
            
        } else{
            print("Something went wrong in  image")
        }
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL{
            print("videourl: ", videoUrl)
            //trying compression of video
            let data = NSData(contentsOf: videoUrl as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
            compressWithSessionStatusFunc(videoUrl)
        }
        else
        {
            print("Something went wrong in  video")
        }
        getTopMostViewController()?.dismiss(animated: true, completion: nil)
    }
    
    func displaySelectedFiles(){
        if isDisabledT1{
            lblSelectedFileT1.text = m_filesArray.last
        }else if isDisabledT2{
            lblSelectedFileT2.text = m_filesArray.last
        }else{
            selectedFileNameLbl.text=m_filesArray.last
        }
    }
    
    //MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                
                DispatchQueue.main.async {
                    self.videoPickedBlock?(compressedURL as NSURL)
                }
                
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
}
