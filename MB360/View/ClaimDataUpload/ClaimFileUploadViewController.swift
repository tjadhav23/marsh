//
//  ClaimFileUploadViewController.swift
//  MyBenefits360
//
//  Created by Thynksight on 06/09/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit
import Photos
import FlexibleSteppedProgressBar
import Foundation

class ClaimFileUploadViewController: UIViewController,UIDocumentPickerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,FlexibleSteppedProgressBarDelegate,UITextViewDelegate {
    
    
    @IBOutlet weak var tblList: UITableView!
    
    @IBOutlet weak var lblUpload: UILabel!
    
    @IBOutlet weak var lblDetail1: UILabel!
    
    @IBOutlet weak var lblDetail2: UILabel!
    
    @IBOutlet weak var progressBarView: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var errorVew: UIView!
    
    @IBOutlet weak var imgError: UIImageView!
    
    
    @IBOutlet weak var lblErrortitle: UILabel!
    
    @IBOutlet weak var lblErrordetail: UILabel!
    
    @IBOutlet weak var bottomVew: UIView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var arrName = ["Birth certificate","Aadhar card","Pan card","Additional document"]
    var arrIndex : [String] = ["0","0","0","0"]
    var arrSize : [String] = ["","","",""]
    var documentPicker = UIDocumentPickerViewController(documentTypes: ["public.composite-content"], in: .import)
    var m_uploadingImage = UIImage()
    var m_fileUploadData = Data()
    var m_selectedFileName = String()
    var m_filesArray = Array<String>()
    var m_attachedDocumentsArray = Array<Any>()
    var m_fileUrl: URL?
    var imagePickedBlock: ((UIImage) -> Void)?
    let m_typeArray = ["png","jpg","jpeg","doc","docx","xml","xls","xlsx","pdf"]
    private var progressBarWithDifferentDimensions: FlexibleSteppedProgressBar!
    var progressColor = FontsConstant.shared.app_FontPrimaryColor
    var textColorHere = FontsConstant.shared.app_FontPrimaryColor
    var backgroundColor = UIColor(hexString: "#C2C2C2") // LIGHT Grey
    var arrDetails : [DetailDoc] = []
    private var isSelected : Int = -1
    var maxCharacterCount = 100
    var countCharacter = 0
    var passdata : passData? = nil
    var imageCaptured = false
    var editdata : AaDatum? = nil
    var isFromEdit : Bool = false
    
   
    
    fileprivate var currentVC: UIViewController?
    var newPic = false
    enum AttachmentType: String{
        case camera, video, photoLibrary
    }
    var selectedIndex : Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the custom cell XIB with the table view
           let nib = UINib(nibName: "ClaimFileUploadTableViewCell", bundle: nil)
        tblList.register(nib, forCellReuseIdentifier: "ClaimFileUploadTableViewCell")
           
           // Set the table view's delegate and data source to self
        tblList.delegate = self
        tblList.dataSource = self
        // Do any additional setup after loading the view.
        
        //tblList.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden=false
        navigationItem.title="link13Name".localized()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        navigationItem.leftBarButtonItem = getBackButtonNew()
        
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        DispatchQueue.main.async()
            {
                menuButton.isHidden=true
                menuButton.accessibilityElementsHidden=true
        }
        bottomVew.alpha = 1
        if !imageCaptured{
            print(editdata)
            print(passdata)
            
            getUploadedDocsList()
            setupUI()
        }
        else{
            print("Print imageCaptured true")
        }
        
        
    }
    
    
    func getBackButtonNew()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "back button"), style: .plain, target: self, action: #selector(backButtonClicked)) // action:#selector(Class.MethodName) for swift 3

        
        return button1
    }
    @objc override func backButtonClicked()
    {
        print ("backButtonClicked")
        if let secondViewController = navigationController?.viewControllers.first(where: { $0 is UploadedClaimsViewController }) as? UploadedClaimsViewController {
                 // Pop back to the second view controller
                 navigationController?.popToViewController(secondViewController, animated: true)
             }
    }
    func setupUI(){
        
        lblUpload.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h18))
        lblUpload.textColor = FontsConstant.shared.app_FontBlackColor
        lblDetail1.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h13))
        lblDetail1.textColor = FontsConstant.shared.app_lightGrayColor
        lblDetail2.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h12))
        lblDetail2.textColor = FontsConstant.shared.app_lightGrayColor
        btnNext.layer.cornerRadius = cornerRadiusForView
        btnNext.isUserInteractionEnabled = false
        btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
        //setupProgressBarWithDifferentDimensions()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }

    
    @IBAction func btnNextAct(_ sender: UIButton) {
        var tempArr = arrDetails.filter{ $0.isEdit == true && $0.isDisabled == false}
        print(tempArr)
        if tempArr.count > 0{
            var count : Int = 0
            for i in 0..<tempArr.count{
                var doc_req_by = (passdata?.doc_req_by)!
                var clm_docs_upload_req_sr_no = (passdata?.clm_docs_upload_req_sr_no)!
                var clm_req_docs_sr_no = tempArr[i].clmReqDocsSrNo ?? 0
                var remark : String = ""
                if tempArr[i].remark == ""{
                    remark = "NOT AVAILALE"
                }else{
                    remark = tempArr[i].remark ?? "NOT AVAILALE"
                }
                //var remark = tempArr[i].remark ?? "NOT AVAILABLE"
                var tpaCode = TPA_CODE_GMC_Base
                var clmNo = (passdata?.clm_int_sr_no)!
                var fileName = tempArr[i].fileName!
                var fileurl = tempArr[i].fileUrl!
                count += 1
                uploadClaimDocument(doc_req_by, clm_docs_upload_req_sr_no, String(clm_req_docs_sr_no), remark, tpaCode, clmNo, fileName,fileurl,count,tempArr)
            }
        }else{
            let vc : ClaimDataStatusViewController = ClaimDataStatusViewController()
            vc.isFromEdit = true
            vc.clm_int_sr_no = passdata!.clm_int_sr_no
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    @IBAction func btnBackAct(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func setupProgressBarWithDifferentDimensions() {
        progressBarWithDifferentDimensions = FlexibleSteppedProgressBar()
        progressBarWithDifferentDimensions.translatesAutoresizingMaskIntoConstraints = false
        progressBarView.addSubview(progressBarWithDifferentDimensions)

        // iOS9+ auto layout code
        let horizontalConstraint = progressBarWithDifferentDimensions.centerXAnchor.constraint(equalTo: progressBarView.centerXAnchor)
        let verticalConstraint = progressBarWithDifferentDimensions.topAnchor.constraint(
            equalTo: progressBarView.topAnchor,
            constant: 0 // position from top for bar
        )

        let widthConstraint = progressBarWithDifferentDimensions.widthAnchor.constraint(equalTo: progressBarView.widthAnchor, constant: -80)
        widthConstraint.isActive = true

        let heightConstraint = progressBarWithDifferentDimensions.heightAnchor.constraint(equalTo: progressBarView.heightAnchor)

        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])

        progressBarWithDifferentDimensions.numberOfPoints = 3
        progressBarWithDifferentDimensions.lineHeight = 3
        progressBarWithDifferentDimensions.radius = 6
        progressBarWithDifferentDimensions.progressRadius = 11
        progressBarWithDifferentDimensions.progressLineHeight = 3
        progressBarWithDifferentDimensions.delegate = self
        progressBarWithDifferentDimensions.useLastState = true
        progressBarWithDifferentDimensions.lastStateCenterColor = progressColor
        progressBarWithDifferentDimensions.selectedBackgoundColor = progressColor
        progressBarWithDifferentDimensions.selectedOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.lastStateOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.currentSelectedCenterColor = progressColor
        progressBarWithDifferentDimensions.stepTextColor = textColorHere
        progressBarWithDifferentDimensions.currentSelectedTextColor = progressColor
        progressBarWithDifferentDimensions.completedTillIndex = 2
        progressBarWithDifferentDimensions.stepAnimationDuration = 20
        
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == progressBarWithDifferentDimensions {
            if position == FlexibleSteppedProgressBarTextLocation.bottom {
                switch index {

                case 0: return "Claims Details"
                case 1: return "Beneficiary Details"
                case 2: return "File Upload"
                default: return ""

                }
            }
        }
        return ""
    }
    
    func getEditData(){
        
        print(editdata)
        if editdata?.files != "" && editdata?.files != "-"{
            var arrtemp : [String] = (editdata?.files.components(separatedBy: "~"))!
            arrtemp.removeLast()
            var name : [String] = []
            var arrEditData : [DetailDoc] = []
            
            for val in arrtemp{
                var str = val.components(separatedBy: "(")
                var docName = str[1].replacingOccurrences(of: ")", with: "")
               
                var item  : DetailDoc = DetailDoc(id: "", clmDocName: "", clmDocDescription: "", clmReqDocsSrNo: 0, isDocMandatory: 0, isDocToInclInCommMail: 0)
                item.clmDocName = docName
                item.isDisabled = true
                item.isEdit = true
                arrEditData.append(item)
            }
            print(arrEditData)
            arrDetails = arrEditData + arrDetails
            print(arrDetails)
           
            DispatchQueue.main.async{
                self.loader.isHidden = false
               
                
            }
        
            
          
          
        }
        
        print(arrDetails)
        
//        var arrTemp : [String] = []
//        for i in 0..<arrDetails.count - 1{
//            if arrDetails[i].isDocMandatory == 1 && arrDetails[i].isEdit == false{
//                arrTemp.append("0")
//
//            }
//
//        }
        
      
    
        DispatchQueue.main.async {
//            if arrTemp.contains("0"){
//                self.btnNext.isUserInteractionEnabled = false
//                self.btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
//            }else{
//                self.btnNext.isUserInteractionEnabled = true
//                self.btnNext.backgroundColor = FontsConstant.shared.app_FontAppColor
//            }
            if self.editdata?.status.lowercased() == "incomplete"{
                self.btnNext.isUserInteractionEnabled = false
                self.btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
            }else{
                self.btnNext.isUserInteractionEnabled = true
                self.btnNext.backgroundColor = FontsConstant.shared.app_FontAppColor
            }
            self.loader.isHidden = true
            self.tblList.reloadData()
        }
        
        
    }
    
    
    func getUploadedDocsList(){
        let appendUrl = "IntimateClaim/LoadRequiredClaimsDocDetails?groupchildsrno=\(userGroupChildNo)&oegrpbasinfsrno=\(userOegrpNo)"
        webServices().getRequestForJsonCDU(appendUrl, completion: {
            (data,error,resp) in
            if error != ""{
                DispatchQueue.main.async{
                    self.tblList.isHidden = true
                    self.errorVew.isHidden = false
                    self.imgError.image=UIImage(named: "claimnotfound")
                    self.lblErrortitle.text = "No data found"
                    self.lblErrordetail.text = "During_Enrollment_Detail_ErrorMsg".localized()
                }
            }else{
                if let httpResponse = resp as? HTTPURLResponse//response as? HTTPURLResponse
                {
                    print("getUploadedDocsList: ",httpResponse.statusCode)
                    if httpResponse.statusCode == 200
                    {
                        do {
                            let json = try JSONDecoder().decode(GetDocDetails.self, from: data!)
                            let arr = json.detail
                            self.arrDetails = arr
                            self.arrName = []
                            for val in self.arrDetails{
                                self.arrName.append(val.clmDocName)
                            }
                            var item  : DetailDoc = DetailDoc(id: "", clmDocName: "", clmDocDescription: "", clmReqDocsSrNo: 0, isDocMandatory: 0, isDocToInclInCommMail: 0)
                            item.clmDocName = "Additional document"
                            self.arrDetails.append(item)
                            self.arrName.append("Additional document")
                            if self.isFromEdit{
                                self.getEditData()
                            }else{
                                DispatchQueue.main.async {
                                    self.loader.isHidden = true
                                }
                            }
                            DispatchQueue.main.async{
                                if self.arrDetails.count > 0{
                                    self.tblList.isHidden = false
                                    self.errorVew.isHidden = true
                                    self.tblList.reloadData()
                                }else{
                                    self.tblList.isHidden = true
                                    self.errorVew.isHidden = false
                                    self.imgError.image=UIImage(named: "claimnotfound")
                                    self.lblErrortitle.text = "No data found"
                                    self.lblErrordetail.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                }
                                
                            }
                            
                        }catch{}
                    }else{
                        DispatchQueue.main.async{
                            self.tblList.isHidden = true
                            self.errorVew.isHidden = false
                            self.imgError.image=UIImage(named: "claimnotfound")
                            self.lblErrortitle.text = "No data found"
                            self.lblErrordetail.text = "During_Enrollment_Detail_ErrorMsg".localized()
                        }
                    }
                }
            }
            
        })
    }
    
    
    @IBAction func btnBacktohomeAct(_ sender: UIButton) {
        if let secondViewController = navigationController?.viewControllers.first(where: { $0 is UploadedClaimsViewController }) as? UploadedClaimsViewController {
                 // Pop back to the second view controller
                 navigationController?.popToViewController(secondViewController, animated: true)
             }
    }
    
    
    func uploadClaimDocument(_ doc_req_by : String,_ clm_docs_upload_req_sr_no : String,_ clm_req_docs_sr_no : String,_ remark : String,_ tpa : String,_ clmNo : String,_ fileName : String,_ fileUrl : URL,_ count : Int,_ tempArr : [DetailDoc]) {
        // Define the URL
        guard let url = URL(string: "\(WebServiceManager.getSharedInstance().newBaseurl)" + "IntimateClaim/Insertcliamdocreqdetails") else {
            print("Invalid URL")
            return
        }
        self.showPleaseWait(msg: "Please wait...")
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Define the form data parameters
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Define the form data body
        var body = Data()
        
        // Add form fields
        let formData = [
            "DOC_REQ_BY": "\(doc_req_by)",
            "CLM_DOCS_UPLOAD_REQ_SR_NO": "\(clm_docs_upload_req_sr_no)",
            "CLM_REQ_DOCS_SR_NO": "\(clm_req_docs_sr_no)",
            "CLM_DOC_UPD_REMARK": "\(remark)",
            "TPA_CODE": "\(tpa)",
            "CLAIM_NO": "\(clmNo)"
        ]
        print(formData)
        
        for (key, value) in formData {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        print(fileName)
        // Add the file data
         let fileURL = fileUrl//m_fileUrl//
        print(fileURL)
        let fileName = fileURL.lastPathComponent
        print(fileName)
       
               // httpBody.append("Content-Type: image/jpeg\r\n\r\n")

            
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
        if fileName.contains(".pdf"){
            body.append("Content-Type: application/pdf\r\n\r\n")
        }else if fileName.contains(".png"){
            body.append("Content-Type: image/png\r\n\r\n")
        }else{
            body.append("Content-Type: image/jpeg\r\n\r\n")
        }
            
        if let fileData = try? Data(contentsOf: fileURL) {
                body.append(fileData)
            }
            
            body.append("\r\n")
       // }
        
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
       
        // Create a URLSession task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.hidePleaseWait()
            }
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async{
                    self.tblList.isHidden = true
                    self.errorVew.isHidden = false
                    self.imgError.image=UIImage(named: "pageNotFound")
                    self.lblErrortitle.text = "No data found"
                    self.lblErrordetail.text = "During_Enrollment_Detail_ErrorMsg".localized()
                }
               // return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            
            if let responseData = data {
                // Handle the response data here
                print("Response Data: \(String(data: responseData, encoding: .utf8) ?? "")")
                do {
                    let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:Any]
                    let res = json?["res"] as? [String:Any]
                    let msg = res?["Message"] as? String
                    let status = res?["Status"] as? Bool
                    
                    if count == tempArr.count{
                        DispatchQueue.main.async{
                            self.bottomVew.alpha = 0
                            //self.showAlert(message: msg!)
                            if status == true{
                                let vc : ClaimDataStatusViewController = ClaimDataStatusViewController()
                                vc.clm_int_sr_no = clmNo
                                vc.isFromEdit = self.isFromEdit
                                self.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                    self.tblList.isHidden = true
                                    self.errorVew.isHidden = false
                                    self.imgError.image=UIImage(named: "pageNotFound")
                                    self.lblErrortitle.text = msg
                                    self.lblErrordetail.text = ""
                                
                            }
                        }
                    }
                    
                }catch{
                    
                }
            }else{
                DispatchQueue.main.async{
                    self.tblList.isHidden = true
                    self.errorVew.isHidden = false
                    self.imgError.image=UIImage(named: "pageNotFound")
                    self.lblErrortitle.text = "No data found"
                    self.lblErrordetail.text = "During_Enrollment_Detail_ErrorMsg".localized()
                }
            }
        }
        
        task.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ClaimFileUploadViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblList.dequeueReusableCell(withIdentifier: "ClaimFileUploadTableViewCell", for: indexPath) as! ClaimFileUploadTableViewCell

        print("arrDetails: ",arrDetails)
        if arrDetails[indexPath.row].isDisabled == true{
            cell.isUserInteractionEnabled = false
            cell.lblName.textColor = FontsConstant.shared.app_lightGrayColor
        }else{
            cell.isUserInteractionEnabled = true
            cell.lblName.textColor = FontsConstant.shared.app_FontBlackColor
        }
        
        cell.lblName.text = arrDetails[indexPath.row].clmDocName
        cell.lblFileName.text = arrDetails[indexPath.row].fileName
        if arrDetails[indexPath.row].isEdit == true {
            cell.imgAttach.image = UIImage(named: "editDoc")
            cell.lblImageStatus.isHidden = true
            //cell.lblImageStatus.text = arrSize[indexPath.row]

        }else{
            cell.imgAttach.image = UIImage(named: "attach")
            cell.lblImageStatus.isHidden = true

        }
        
        if indexPath.row == isSelected{
            cell.vew2.alpha = 1
           
           
        }
        else{
            cell.vew2.alpha = 0
            
        }
        //performSelectionAction(for: indexPath.row)
        cell.txtVew.delegate = self
        cell.setData(indexPath.row)
        cell.delegate = self
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == isSelected{
            return 230
        }else {
            return 60
            
        }
    }
    
    func performSelectionAction(for indexPath: Int) {
        // Perform the action you want when a row is selected
        print("Selected row at indexPath: \(indexPath)")
        // You can replace this with your desired action
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let claimSubmission : ClaimDataUploadViewController = ClaimDataUploadViewController()
//        navigationController?.pushViewController(claimSubmission, animated: true)
        
        if isSelected == indexPath.row {
            isSelected = -1
//            btnNext.isUserInteractionEnabled = false
//            btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
            
        }
        else {
            
            if arrDetails[indexPath.row].isEdit == false{
                            documentPicker.delegate = self
                            let AddQeryVC :ClaimFileUploadViewController = (ClaimFileUploadViewController() as? ClaimFileUploadViewController)!
                            showAttachmentActionSheet(vc:  AddQeryVC)
                            // present(documentPicker, animated: true, completion: nil)
            }else{
                isSelected = indexPath.row
            }
//            btnNext.isUserInteractionEnabled = true
//            btnNext.backgroundColor = FontsConstant.shared.app_FontAppColor
        }
        selectedIndex = indexPath.row
        tblList.reloadData()
        
//        selectedIndex = indexPath.row
//        if arrIndex[indexPath.row] == "0"{
//            documentPicker.delegate = self
//            let AddQeryVC :ClaimFileUploadViewController = (ClaimFileUploadViewController() as? ClaimFileUploadViewController)!
//            showAttachmentActionSheet(vc: AddQeryVC)
//            // present(documentPicker, animated: true, completion: nil)
//        }else{
//            print("delete button tapped")
//            deleteFile(indexPath: indexPath)
//            
//        }
    }
    
   
    
    func showAttachmentActionSheet(vc: UIViewController)
    {
        currentVC = vc
        let actionSheet = UIAlertController(title: "Add a File", message: "Choose a filetype to add...", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Phone Library", style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
        }))
        
    
        
        actionSheet.addAction(UIAlertAction(title: "File", style: .default, handler: { (action) -> Void in
            self.openDocumentPicker()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
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

    func openDocumentPicker()
    {
        present(documentPicker, animated: true, completion: nil)
    }
    
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
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(){
     
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = true
            }
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
        DispatchQueue.main.async{
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
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType){
        print("attachmentTypeEnum: ",attachmentTypeEnum)
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera{
            alertTitle = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
            print("AttachmentType.camera: ",AttachmentType.camera)
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary{
            alertTitle = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
            print("AttachmentType.photoLibrary: ",AttachmentType.photoLibrary)
        }
      
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        //currentVC?.present(cameraUnavailableAlertController , animated: true, completion: nil)
        
        DispatchQueue.main.async {
            self.present(cameraUnavailableAlertController , animated: true, completion: nil)
        }
    }
    
}



extension ClaimFileUploadViewController : UIDocumentMenuDelegate{
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController)
    {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
        
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        
            m_fileUrl = url
            print("import result :\(m_fileUrl)")
            m_selectedFileName = url.lastPathComponent
            m_filesArray.append(m_selectedFileName)
            m_attachedDocumentsArray.append(m_fileUrl)
           
            let imageUrl = url
            
            do {
                if let image = UIImage(contentsOfFile: imageUrl.path)
                {
                    m_uploadingImage = image
                }
                
                m_fileUploadData = try Data(contentsOf: imageUrl as URL)
                let fileSizeInBytes = Int64(m_fileUploadData.count)
                let fileSizeInMB = Double(fileSizeInBytes) / (1024 * 1024) // Convert to MB

                let bcf = ByteCountFormatter()
                bcf.allowedUnits = [.useKB] // optional: restricts the units to MB only
                bcf.countStyle = .file
                
                let string1 = bcf.string(fromByteCount: Int64(m_fileUploadData.count))
                let size = NSString(string: string1)
                print("formatted result: \(size.floatValue)")
                print("size: \(size)")
                print("fileSizeInMB MB size: \(fileSizeInMB)")
                print("m_selectedFileName",m_selectedFileName)
                let keyExists = arrDetails.contains { $0.fileName == m_selectedFileName}
                print(keyExists)
                
                if(fileSizeInMB == 0.0)
                {
                    displayActivityAlert(title: "This File has 0 KB size")
                }
                else if(fileSizeInMB > 5.0)
                {
                    displayActivityAlert(title: "This File exceeds the maximum upload size")
                }
                else if keyExists{
                    displayActivityAlert(title: "File already exists")
                }
              
                else
                {
                    displaySelectedFiles(m_selectedFileName,size as String,m_fileUrl!,"")
                }
                
            }
            catch
            {
                print("Unable to load data: \(error)")
            }
            
        
        
    }
    
    func displaySelectedFiles(_ fileName : String,_ size : String,_ fileUrl : URL,_ originalFileName : String){
        print("fileName",fileName)
        print("selectedIndex",selectedIndex)
        arrDetails[selectedIndex].fileName = fileName
        arrDetails[selectedIndex].isEdit = true
        arrDetails[selectedIndex].fileUrl = fileUrl
        arrDetails[selectedIndex].originalFileName = originalFileName
//        arrIndex[selectedIndex] = "1"
//        arrSize[selectedIndex] = size
        
        
        print("arrDetails::: ",arrDetails)
        print("arrName::: ",arrName)
        if !arrName.contains("Additional document"){
           
            var item  : DetailDoc = DetailDoc(id: "", clmDocName: "", clmDocDescription: "", clmReqDocsSrNo: 0, isDocMandatory: 0, isDocToInclInCommMail: 0)
            item.clmDocName = "Additional document"
            arrDetails.append(item)
           
        }
        
        var arrTemp : [String] = []
        for i in 0..<arrDetails.count - 1{
            if arrDetails[i].isDocMandatory == 1 && arrDetails[i].isEdit == false{
                arrTemp.append("0")
            }
            
        }
        
        if arrTemp.contains("0"){
            btnNext.isUserInteractionEnabled = false
            btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
        }else{
            btnNext.isUserInteractionEnabled = true
            btnNext.backgroundColor = FontsConstant.shared.app_FontAppColor
        }
        isSelected = selectedIndex
        
        
        tblList.reloadData()
        //let cell = tblList.cellForRow(at: selectedIndex) as? ClaimFileUploadTableViewCell
        
    }
}

extension ClaimFileUploadViewController
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        getTopMostViewController()?.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.imagePickedBlock?(image)
            
            print("Cell selected no ",selectedIndex)
            
            /*if newPic {
                m_attachedDocumentsArray.append(image)
                m_filesArray.append("camera_Image.jpg")
                let data: NSData = NSData(data: UIImageJPEGRepresentation((image), 0.3)!)
                
                
                let imageSize: Int = data.length
                let imageSizeInKB: Int = Int(imageSize) / 1024
                let imageSizeStr = "\(imageSizeInKB) Kb"
                
                
                //let tempDirectory = FileManager.default.temporaryDirectory
                let tempDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let filename = "camera_Image_\(selectedIndex).jpg"
                let imageURL = tempDirectory.appendingPathComponent(filename)
                
                print("Image url is : ",imageURL)
                            if #available(iOS 11.0, *) {
            //                    if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
            //                        print(imageURL)
            //                        m_fileUrl = imageURL
            //                    }
                                m_fileUrl = imageURL
                                print("m_fileUrl : ",m_fileUrl)
                            } else {
                                if let imageUrl = info[UIImagePickerControllerMediaURL] as? URL {
                                    print(imageUrl)
                                    m_fileUrl = imageUrl
                                    
                                }
                            }
                
                do {
                    m_fileUrl = imageURL
                    try imageData.write(to: m_fileUrl!)
                    displaySelectedFiles(filename, imageSizeStr, m_fileUrl!,"")
                   
                } catch {
                    print("Error saving image: \(error)")
                }
             
                imageCaptured = true
                            
            }*/
            if newPic {
                
                //var obj = UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                
                m_attachedDocumentsArray.append(image)
                m_filesArray.append("camera_Image.jpg")
                let imageData: NSData = NSData(data: UIImageJPEGRepresentation((image), 0.3)!)
                
                
                
                let imageSize: Int = imageData.length
                let imageSizeInKB: Int = Int(imageSize) / 1024
                let imageSizeStr = "\(imageSizeInKB) Kb"
                
                
                let tempDirectory = FileManager.default.temporaryDirectory
                let timestamp = Int(Date().timeIntervalSince1970)
                let filename = "camera_image_\(timestamp).jpg"
                //let filename = "camera_Image_\(selectedIndex).jpg"
                let imageURL = tempDirectory.appendingPathComponent(filename)
                
                print("Image url is : ",imageURL)
                if #available(iOS 11.0, *) {
                    //                    if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
                    //                        print(imageURL)
                    //                        m_fileUrl = imageURL
                    //                    }
                    m_fileUrl = imageURL
                    print("m_fileUrl : ",m_fileUrl)
                } else {
                    if let imageUrl = info[UIImagePickerControllerMediaURL] as? URL {
                        print(imageUrl)
                        m_fileUrl = imageUrl
                        
                    }
                }
                
                do {
                    m_fileUrl = imageURL
                    try imageData.write(to: m_fileUrl!)
                    displaySelectedFiles(filename, imageSizeStr, m_fileUrl!,"")
                    
                } catch {
                    print("Error saving image: \(error)")
                }
                
                imageCaptured = true
                
            }
            else {
                var originalFileName : String = ""
                if #available(iOS 11.0, *) {
                    if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
                        print("selected imageURL::",imageURL)
                        m_fileUrl = imageURL
                        
                    }
                } else {
                    if let imageUrl = info[UIImagePickerControllerMediaURL] as? URL {
                        print("selected imageURL:::",imageUrl)
                        m_fileUrl = imageUrl
                        
                    }
                }
                
                            if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
                                    let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                                    let asset = result.firstObject
                                    print(asset?.value(forKey: "filename"))
                                originalFileName = asset?.value(forKey: "filename") as! String
                                //arrDetails[selectedIndex].originalFileName = asset?.value(forKey: "filename") as! String

                                }
                //uncommented by Pranit
                m_selectedFileName = m_fileUrl!.lastPathComponent
                print("Selcted File Name: ",m_selectedFileName)
                let fileName = m_selectedFileName
                let fileNameArr = m_selectedFileName.characters.split{$0 == "."}.map(String.init)
                let type = fileNameArr[fileNameArr.count-1]
                
                //let type = ""
                
                if(m_typeArray.contains(type))
                {
                    
                    let data: NSData = NSData(data: UIImageJPEGRepresentation((image), 0.3)!)
                    let imageSize: Int = data.length
                    let imageSizeInKB: Int = Int(imageSize) / 1024
                    let imageSizeStr = "\(imageSizeInKB) Kb"
                    print("imagesize",imageSizeInKB)
                    print("import result :\(m_fileUrl)")
                    
                    m_filesArray.append(m_selectedFileName)
                    m_attachedDocumentsArray.append(m_fileUrl)
                    let keyExists = arrDetails.contains { $0.originalFileName == originalFileName}
                    print(keyExists)
                    if keyExists{
                        displayActivityAlert(title: "File already exists")
                    }else{
                        displaySelectedFiles(m_selectedFileName, imageSizeStr,m_fileUrl!,originalFileName)
                    }
                }
                else
                {
                    displayActivityAlert(title: "You can not upload \(type) files")
                }
            }
            //Shubham commented
           /* else{
                
                if let referenceURL = info[UIImagePickerControllerReferenceURL] as? URL {
                    // Use referenceURL to obtain the original filename
                    m_selectedFileName = referenceURL.lastPathComponent
                    print("If m_selectedFileName: ",m_selectedFileName)
                } else {
                    // If UIImagePickerControllerReferenceURL is not available, generate a unique filename using UUID
                    let uniqueFilename = UUID().uuidString + ".jpg"
                    m_selectedFileName = uniqueFilename
                    print("else m_selectedFileName: ",m_selectedFileName)
                }
                
                
                // Save the image with the obtained filename
                if let imageData = UIImageJPEGRepresentation(image, 0.3) {
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let imageURL = documentsDirectory.appendingPathComponent(m_selectedFileName)
                    m_fileUrl = imageURL
                    let data: NSData = NSData(data: UIImageJPEGRepresentation((image), 0.3)!)
                    let imageSize: Int = data.length
                    let imageSizeInKB: Int = Int(imageSize) / 1024
                    let imageSizeStr = "\(imageSizeInKB) Kb"
                    print("imagesize",imageSizeInKB)
                    print("import result :\(m_fileUrl)")
                    
                    
                    do {
                        try imageData.write(to: imageURL)
                        m_fileUrl = imageURL
                        displaySelectedFiles(m_selectedFileName, imageSizeStr, m_fileUrl!)
                    } catch {
                        print("Error saving image: \(error)")
                    }
                }
            }*/
        }
        else{
            print("Something went wrong in  image")
        }
        
        
        getTopMostViewController()?.dismiss(animated: true, completion: nil)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if(textView.text=="Write text here.......")
        {
            textView.text=""
        }
        textView.textColor=UIColor.black
        //        animateTextView(textView, with: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        //Commented On press return in keyboard atopping to type
        
         if(text=="\n")
         {
         view.endEditing(true)
         }
         
        
        // return true
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
       
        
        if numberOfChars == maxCharacterCount
        {
            displayActivityAlert(title: "character limit is \(maxCharacterCount)")
        }
        
        return numberOfChars <= maxCharacterCount;
        
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        view.endEditing(true)
        print("selectedIndex",selectedIndex)
        print(textView.text)
        arrDetails[selectedIndex].remark = textView.text
        tblList.reloadData()
        print(arrDetails)
       // m_instructionView.endEditing(true)
        //        animateTextView(textView, with: true)
    }
    func textViewDidChange(_ textView: UITextView)
    {
        guard let text = textView.text else  {
            return
        }
        let totalLength = text.count
        let newlineCount = text.filter {$0 == "\n"}.count
        print("Total characters are \(totalLength) of which \(newlineCount) are newLines total of all characters counting newlines twice is \(totalLength + newlineCount)")
        countCharacter = totalLength
        print(selectedIndex)
        print(textView.text)
        arrDetails[selectedIndex].count = countCharacter
        arrDetails[selectedIndex].remark = textView.text!
        if let cell = tblList.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? ClaimFileUploadTableViewCell {
            cell.lblCounter.text = "\(countCharacter) / \(maxCharacterCount)"
            cell.txtVew.text = textView.text
              }
        print(arrDetails)
        //counterLbl.text = "Typed \(countCharacter) / \(maxCharacterCount) characters"
        
    }
}


extension ClaimFileUploadViewController : tableCellDelegate{
    func passIndex(type: String, index: Int) {
        if type.lowercased() == "browse"{
            documentPicker.delegate = self
            let AddQeryVC :ClaimFileUploadViewController = (ClaimFileUploadViewController() as? ClaimFileUploadViewController)!
            showAttachmentActionSheet(vc:  AddQeryVC)
        }else if type.lowercased() == "delete"{
            let alert = UIAlertController(title: "", message: "Would you like to delete file?", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
                print("User click Delete button")

                
                self.arrDetails[index].fileName = "No file choosen."
                self.arrDetails[index].isEdit = false
                
                var arrTemp : [String] = []
                for i in 0..<self.arrDetails.count - 1{
                    if self.arrDetails[i].isDocMandatory == 1 && self.arrDetails[i].isEdit == false{
                        arrTemp.append("0")
                    }
                    
                }
                
                if arrTemp.contains("0"){
                    self.btnNext.isUserInteractionEnabled = false
                    self.btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
                }else{
                    self.btnNext.isUserInteractionEnabled = true
                    self.btnNext.backgroundColor = FontsConstant.shared.app_FontAppColor
                }
                
                self.tblList.reloadData()
                
               
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
             
            }))

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
    }
    
    
}
