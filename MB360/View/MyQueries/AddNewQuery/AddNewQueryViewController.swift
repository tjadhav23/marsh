//
//  AddNewQueryViewController.swift
//  MyBenefits
//
//  Created by Semantic on 26/03/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseCrashlytics
import Photos
import AssetsLibrary
import TrustKit
import AesEverywhere

class AddNewQueryViewController: UIViewController,UITextViewDelegate,XMLParserDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var m_documentName1: UILabel!
    @IBOutlet weak var m_iLabl: UILabel!
    @IBOutlet weak var m_instructionView: UIView!
    @IBOutlet weak var m_documentName5: UILabel!
    @IBOutlet weak var m_documentName4: UILabel!
    @IBOutlet weak var m_documentName3: UILabel!
    @IBOutlet weak var m_documentName2: UILabel!
    @IBOutlet weak var m_documentView5: UIView!
    @IBOutlet weak var m_documentView4: UIView!
    @IBOutlet weak var m_documentView3: UIView!
    @IBOutlet weak var m_documentView2: UIView!
    @IBOutlet weak var m_documentView1: UIView!
    @IBOutlet weak var m_document5ImageView: UIImageView!
    @IBOutlet weak var m_document4ImmageView: UIImageView!
    @IBOutlet weak var m_document3ImageView: UIImageView!
    @IBOutlet weak var mdocuument2ImageView: UIImageView!
    @IBOutlet weak var m_document1ImageView: UIImageView!
    @IBOutlet weak var m_submitQueryButton: UIButton!
    @IBOutlet weak var m_textView: UITextView!
    @IBOutlet weak var m_otherView: UIView!
    @IBOutlet weak var instructionValue1Lbl: UILabel!
    @IBOutlet weak var border1: UILabel!
    @IBOutlet weak var border2: UILabel!
    @IBOutlet weak var instructionValue2Lbl: UILabel!
    @IBOutlet weak var instructionValue3Lbl: UILabel!
    
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var counterLbl: UILabel!
    var maxCharacterCount = 3000
    var countCharacter = 0
    
    var selectedDropDown = "Select Category"
    
    @IBOutlet weak var m_textField: UITextField!
    let dateDropDown=DropDown()
    var m_membersArray = Array<String>()
    var selectedRowIndex = -1
    
    var presentedVC: UIViewController?
    var m_uploadingImage = UIImage()
    var m_fileUploadData = Data()
    var m_selectedFileName = String()
    var m_filesArray = Array<String>()
    var m_attachedDocumentsArray = Array<Any>()
    var m_fileUrl: URL?
    var m_documentLblArray = Array<UILabel>()
    var documentPicker = UIDocumentPickerViewController(documentTypes: ["public.composite-content"], in: .import)
    var m_employeedict : EMPLOYEE_INFORMATION?
    var xmlKey = String()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    let m_typeArray = ["png","jpg","jpeg","doc","docx","xml","xls","xlsx","pdf"]
    
    
    var newPic = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupFontUI()
        setLayout()
        menuButton.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //lblInstructions.textColor = Color.themeFontColor.value
        self.m_membersArray = ["Select Category","E-cards","Dependant Addition/Correction/Deletion","Policy features and Coverage Details","Enrollment Process","How to make a cashless claim","How to make a reimbursement claim","What is pre/post Hospitalization","Claim Intimation","Hospital Related","Contact Details","Claim Tracking","Others"]
        
    }
    
    func setupFontUI(){
        
        m_textView.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_textView.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_submitQueryButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h15))
        m_submitQueryButton.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_iLabl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_iLabl.textColor = FontsConstant.shared.app_WhiteColor
        
        lblInstructions.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
       // lblInstructions.textColor = FontsConstant.shared.app_FontAppColor
        
        instructionValue1Lbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        instructionValue1Lbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        instructionValue2Lbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        instructionValue2Lbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        instructionValue3Lbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        instructionValue3Lbl.textColor = FontsConstant.shared.app_FontBlackColor
        
        border1.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        border1.textColor = FontsConstant.shared.app_FontSecondryColor
        
        border2.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h20))
        border2.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_documentName1.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_documentName1.textColor = FontsConstant.shared.app_FontSecondryColor
        
        
        m_documentName2.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_documentName2.textColor = FontsConstant.shared.app_FontSecondryColor
        
        
        m_documentName3.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_documentName3.textColor = FontsConstant.shared.app_FontSecondryColor
        
        
        m_documentName4.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_documentName4.textColor = FontsConstant.shared.app_FontSecondryColor
        
        
        m_documentName5.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_documentName5.textColor = FontsConstant.shared.app_FontSecondryColor
        
        
        m_textField.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_textField.textColor = FontsConstant.shared.app_FontBlackColor
        
      //  counterView.backgroundColor = FontsConstant.shared.app_
        
        counterLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        counterLbl.textColor = FontsConstant.shared.app_WhiteColor
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        
        if self.view.frame.origin.y >= 0 {
            //Commented to make view fixed
            // self.view.frame.origin.y -= 150
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y <= 0 {
            //Commented to make view fixed
            // self.view.frame.origin.y = 64.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden=false
        navigationController?.isNavigationBarHidden=false
        self.navigationItem.title="New Query".localized()
        navigationItem.leftBarButtonItem=getBackButton()
        //navigationItem.rightBarButtonItem=getRightBarButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        
        counterView.isHidden = true
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        self.tabBarController?.tabBar.isHidden=true
        DispatchQueue.main.async()
        {
            menuButton.isHidden=true
        }
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if userArray.count>0{
            m_employeedict=userArray[0]
        }
        menuButton.isHidden=true
    }
    @objc override func backButtonClicked()
    {
        self.tabBarController?.tabBar.isHidden=true
        
        _ = navigationController?.popViewController(animated: true)
        
        /*if let presentedVC = presentedViewController
         {
         let transition = CATransition()
         transition.duration = 0.5
         transition.type = kCATransitionPush
         transition.subtype = kCATransitionFromBottom
         transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
         presentedVC.view.window!.layer.add(transition, forKey: kCATransition)
         }
         
         dismiss(animated: false, completion: nil)
         
         presentedVC = nil*/
    }
    func setLayout()
    {
        m_instructionView.layer.masksToBounds=true
        m_instructionView.layer.borderWidth=1
        m_instructionView.layer.borderColor=hexStringToUIColor(hex:hightlightColor).cgColor
        m_instructionView.layer.cornerRadius=10
        m_textView.setBorderToView(color: hexStringToUIColor(hex: "E5E5E5"))
        m_textView.layer.masksToBounds=true
        m_textView.layer.cornerRadius=14
        m_submitQueryButton.layer.masksToBounds=true
        m_submitQueryButton.layer.cornerRadius=m_submitQueryButton.frame.size.height/2
        m_iLabl.layer.masksToBounds=true
        m_iLabl.layer.cornerRadius=m_iLabl.frame.size.height/2
        m_documentView1.layer.masksToBounds=true
        m_documentView1.layer.cornerRadius=cornerRadiusForView//8
        m_documentView2.layer.masksToBounds=true
        m_documentView2.layer.cornerRadius=cornerRadiusForView//8
        m_documentView3.layer.masksToBounds=true
        m_documentView3.layer.cornerRadius=cornerRadiusForView//8
        m_documentView4.layer.masksToBounds=true
        m_documentView4.layer.cornerRadius=cornerRadiusForView//8
        m_documentView5.layer.masksToBounds=true
        m_documentView5.layer.cornerRadius=cornerRadiusForView//8
        counterView.isHidden = true
        counterLbl.text = "Typed \(countCharacter) / \(maxCharacterCount) characters"
        counterView.layer.cornerRadius = cornerRadiusForView//8
        counterView.layer.masksToBounds=true
        
        
        m_textField.delegate=self
        print("selectedDropDown: ",selectedDropDown)
        m_textField.text=selectedDropDown
        m_textField.layer.masksToBounds=true
        m_textField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
        m_textField.layer.borderWidth=1
        m_textField.layer.cornerRadius=25
    }
    func submitQuery()
    {
        if((m_textField.text=="Select Category" || m_textField.text=="") && (m_textView.text=="Write your query here" || m_textView.text==""))
        {
            displayActivityAlert(title: "Please select category and insert your query")
        }
        else if(m_textField.text=="Select Category" || m_textField.text=="")
        {
            displayActivityAlert(title: "Please select category")
        }
        else if(m_textView.text=="Write your query here" || m_textView.text=="")
        {
            displayActivityAlert(title: "Please insert your query")
        }
        else if(m_textView.text.contains("<") || m_textView.text.contains(">") || m_textView.text.contains("&") || m_textView.text.contains("=") || m_textView.text.contains("<") || m_textView.text.contains("JAVASCRIPT") || m_textView.text.contains("SCRIPT") || m_textView.text.contains("*") || m_textView.text.contains("{") || m_textView.text.contains("}") || m_textView.text.contains("-") || m_textView.text.contains("^") || m_textView.text.contains("`") || m_textView.text.contains("~") || m_textView.text.contains("$") || m_textView.text.contains("#") || m_textView.text.contains("WINDOW.") || m_textView.text.contains("DOCUMENT.") || m_textView.text.contains("VAL(") || m_textView.text.contains("LOG") || m_textView.text.contains("@"))
                    
        {
            displayActivityAlert(title: "Please insert valid query")
            //{ "<", "JAVASCRIPT", "SCRIPT", "ALERT", "CONSOLE", ">", "?", "*", "{", "}", "–", "—", "%", "&", "^", "`", "~", "$", "#", "WINDOW.", "DOCUMENT.", "VAL(", "LOG" };
        }
        
        
        else
        {
            if(isConnectedToNetWithAlert())
            {
                showPleaseWait(msg: "Please wait...")
                
                
                let request: URLRequest
                do {
                    request = try createRequest()
                } catch
                {
                    print(error)
                    hidePleaseWait()
                    return
                }
                
                //SSL Pinning
                let sessionConfig = URLSessionConfiguration.default
                sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
                sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
                TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
                let session = URLSession(
                               configuration: sessionConfig,
                               delegate: URLSessionPinningDelegate(),
                               delegateQueue: nil)
                
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    print("request: ",request)
                    print("response: ",response)
                    
                    print("error: ",error)
                    //SSL Pinning
                    if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                        // Handle SSL connection failure
                        print("SSL connection error: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.alertForLogout(titleMsg: error.localizedDescription)
                        }
                    }
                    else if error != nil {
                        print("error ",error!)
                        self.hidePleaseWait()
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            if httpResponse.statusCode == 200
                            {
                                do {
                                    print(String(data: data!, encoding: .utf8)!)
                                    if let data = data, let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                                    {
                                        if(jsonResult.count>0)
                                        {
                                            DispatchQueue.main.async
                                            {
                                                self.hidePleaseWait()
                                                if let status = jsonResult.value(forKey: "Status")
                                                {
                                                    let boolStatus : Bool = status as! Bool
                                                    if(boolStatus)
                                                    {
                                                        let number = jsonResult.value(forKey: "Message") as! String
                                                        
                                                        
                                                        //                                                            self.displayActivityAlert(title: """
                                                        //                                                                Query submitted succesfully.
                                                        //                                                                Ticket number is \(number)
                                                        //                                                                """)
                                                        
                                                        self.displayActivityAlert(title: "Query submitted successfully. Your Ticket No is:  \(number). Please use this ticket number for all future correspondence for this query")
                                                        
                                                        
                                                        //Query submitted successfully. Your Ticket No is: {0}. Please use this ticket number for all future correspondence for this query
                                                        
                                                        
                                                        self.m_textView.text="Write your query here"
                                                        self.m_textView.textColor=UIColor.lightGray
                                                        self.m_filesArray.removeAll()
                                                        self.m_attachedDocumentsArray.removeAll()
                                                        self.m_selectedFileName=""
                                                        self.m_fileUrl=nil
                                                        self.displaySelectedFiles()
                                                        
                                                        //Added By Pranit to navigate home screen
                                                        let deadlineTime = DispatchTime.now() + .seconds(2)
                                                        DispatchQueue.main.asyncAfter(deadline: deadlineTime)
                                                        {
                                                            print("Dismiss")
                                                            self.navigationController?.popViewController(animated: true)
                                                        }
                                                        
                                                        
                                                    }
                                                    else
                                                    {
                                                        self.displayActivityAlert(title: "Query not submitted. Please try again")
                                                    }
                                                }
                                            }
                                            
                                            
                                        }
                                        else
                                        {
                                            let deadlineTime = DispatchTime.now() + .seconds(1)
                                            DispatchQueue.main.asyncAfter(deadline: deadlineTime)
                                            {
                                                self.hidePleaseWait()
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                } catch let JSONError as NSError {
                                    print(JSONError)
                                    self.hidePleaseWait()
                                }
                            }
                            else
                            {
                                self.hidePleaseWait()
                                self.displayActivityAlert(title: m_errorMsg)
                                print("else executed ",httpResponse.statusCode)
                            }
                            
                        } else {
                            print("Can't cast response to NSHTTPURLResponse")
                            
                            self.hidePleaseWait()
                            
                        }
                        
                    }
                }
                
                task.resume()
                
                
            }
        }
    }
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    func createRequest() throws -> URLRequest
    {
        var employeesrno = String()
        if let empNo = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String//m_employeedict?.empSrNo
        {
            employeesrno = String(empNo)
            employeesrno = try! AES256.encrypt(input: employeesrno, passphrase: m_passphrase_Portal)
        }
        let parameters : NSDictionary = ["Query":m_textView.text,"EmpSrNo":employeesrno,"CustQuerySrNo":"","IsReply":false] // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let url = NSURL(string: WebServiceManager.getSharedInstance().getSubmitQueryUrl() as String)
        
        //        let url = NSURL(string:"http://www.mybenefits360.in/testupload/api/Upload/PostFile" as String)
        print("Submit Query = ", url)
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //let authString = String(format: "%@:%@", m_authUserName, m_authPassword)
        var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
        var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

        let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
        print("m_authUserName_Portal ",encryptedUserName)
        print("m_authPassword_Portal ",encryptedPassword)
        
        let authData = authString.data(using: String.Encoding.utf8)!
        let base64AuthString = authData.base64EncodedString()
        //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
        authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
        print("authToken m_fileUrl:",authToken)
     
        request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")


        print("m_fileUrl: ",m_fileUrl)
        
        request.httpBody = try createBody(with: parameters , filePathKey: "file", fileUrlArray: m_attachedDocumentsArray, boundary: boundary)
        
        print("request: ",request)
        print("request: Body ",request.httpBody)
        
        return request
    }
    private func createBody(with parameters: NSDictionary, filePathKey: String, fileUrlArray: Array<Any>, boundary: String) throws -> Data
    {
        var body = Data()
        var uploadData: Data = NSKeyedArchiver.archivedData(withRootObject: parameters)
        uploadData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        
        let jsonString = String(data: uploadData, encoding:.utf8 )
        let jsonData : String = jsonString!
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"QueryData\"\r\n\r\n")
        body.append("\(String(describing: jsonData))\r\n")
        
        
        print("jsonData: ",jsonData)
        print("Before For ")
        for path in fileUrlArray
        {
            
            if let fileUrl : URL = path as? URL {
                let filename = fileUrl.lastPathComponent
                let data = try Data(contentsOf: fileUrl)
                let mimetype = mimeType(for: fileUrl.path)
                
                if(data != nil)
                {
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
                    body.append("Content-Type: \(mimetype)\r\n\r\n")
                    body.append(data)
                    body.append("\r\n")
                }
                else
                {
                    displayActivityAlert(title: "")
                }
            }
            else { //If image
                print("Camera Image Found")
                if let img = path as? UIImage {
                    let filename = "cameraImg"
                    if let data =  UIImagePNGRepresentation(img) {
                        let mimetype = "application/octet-stream"
                        
                        body.append("--\(boundary)\r\n")
                        body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
                        body.append("Content-Type: \(mimetype)\r\n\r\n")
                        body.append(data)
                        body.append("\r\n")
                    }
                }//If Image
            }
            
        }//for
        
        
        body.append("--\(boundary)--\r\n")
        print("body: ",body)
        return body
    }
    
    
    private func mimeType(for path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    @IBAction func selectAttachmentButtonClicked(_ sender: Any)
    {
        /* let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePNG),String(kUTTypeXML),String(kUTTypePDF),String(kUTTypeText)], in: .import)
         importMenu.delegate = self
         importMenu.modalPresentationStyle = .formSheet
         self.present(importMenu, animated: true, completion: nil)*/
        
        
        documentPicker.delegate = self
        //
        
        
        let AddQeryVC :AddNewQueryViewController = (AddNewQueryViewController() as? AddNewQueryViewController)!
        showAttachmentActionSheet(vc: AddQeryVC)
        
        
    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if(textView.text=="Write your query here")
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
        if numberOfChars > 0{
            counterView.isHidden = false
        }
        else{
            counterView.isHidden = true
        }
        
        if numberOfChars == maxCharacterCount
        {
            displayActivityAlert(title: "character limit is \(maxCharacterCount)")
        }
        
        return numberOfChars <= maxCharacterCount;
        
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        view.endEditing(true)
        m_instructionView.endEditing(true)
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
        counterLbl.text = "Typed \(countCharacter) / \(maxCharacterCount) characters"
        
    }
    func animateTextView(_ textVeiw:UITextView, with up: Bool)
    {
        var movementDistance=0
        let movementDuration=0.3
        movementDistance=150;
        
        
        let movement = (up ? -movementDistance : movementDistance);
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame=self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        m_otherView.endEditing(true)
        m_textView.endEditing(true)
        view.endEditing(true)
    }
    private func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController
    {
        UINavigationBar.appearance().barTintColor = hexStringToUIColor(hex: hightlightColor)
        UINavigationBar.appearance().tintColor = hexStringToUIColor(hex: hightlightColor)
        UINavigationBar.appearance().backgroundColor = hexStringToUIColor(hex: hightlightColor)
        return self
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        
        if(m_attachedDocumentsArray.count>=5)
        {
            displayActivityAlert(title: "You can not attach more than 5 files")
        }
        else
        {
            
            
            
            
            
            let imageUrl = url
            
            do {
                if let image = UIImage(contentsOfFile: imageUrl.path)
                {
                    m_uploadingImage = image
                }
                
                m_fileUploadData = try Data(contentsOf: imageUrl as URL)
                let bcf = ByteCountFormatter()
                bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                bcf.countStyle = .file
                
                let string1 = bcf.string(fromByteCount: Int64(m_fileUploadData.count))
                let size = NSString(string: string1)
                print("formatted result: \(size.floatValue)")
                if(size.floatValue==0)
                {
                    displayActivityAlert(title: "This File has 0 KB size")
                }
                else if(size.floatValue>5)
                {
                    //displayActivityAlert(title: "This File exceeds the maximum upload size")
                    displayActivityAlert(title: "File size should not exceed 5MB")
                    
                }
                else if(m_filesArray.contains(imageUrl.lastPathComponent))
                {
                    displayActivityAlert(title: "File already exist")
                }
                else
                {
                    let fileName = imageUrl.lastPathComponent
                    let fileNameArr = fileName.characters.split{$0 == "."}.map(String.init)
                    let type = fileNameArr[fileNameArr.count-1]
                    if(m_typeArray.contains(type))
                    {
                        m_fileUrl = url
                        print("import result :\(m_fileUrl)")
                        m_selectedFileName = url.lastPathComponent
                        m_filesArray.append(m_selectedFileName)
                        m_attachedDocumentsArray.append(m_fileUrl)
                        displaySelectedFiles()
                    }
                    else
                    {
                        displayActivityAlert(title: "You can not upload \(type) files")
                    }
                    
                }
                
            }
            catch
            {
                print("Unable to load data: \(error)")
            }
            
        }
        
    }
    @IBAction func document1DeleteBtnClicked(_ sender: Any)
    {
        self.m_filesArray.remove(at: 0)
        self.m_attachedDocumentsArray.remove(at: 0)
        displaySelectedFiles()
    }
    
    @IBAction func document2DeleteBtnClicked(_ sender: Any)
    {
        self.m_filesArray.remove(at: 1)
        self.m_attachedDocumentsArray.remove(at: 1)
        displaySelectedFiles()
    }
    
    @IBAction func document3DeleteBtnClicked(_ sender: Any) {
        self.m_filesArray.remove(at: 2)
        self.m_attachedDocumentsArray.remove(at: 2)
        displaySelectedFiles()
    }
    
    @IBAction func document4DeleteBtnClicked(_ sender: Any) {
        self.m_filesArray.remove(at: 3)
        self.m_attachedDocumentsArray.remove(at: 3)
        displaySelectedFiles()
    }
    @IBAction func document5DeleteBtnClicked(_ sender: Any) {
        self.m_filesArray.remove(at: 4)
        self.m_attachedDocumentsArray.remove(at: 4)
        displaySelectedFiles()
    }
    @objc func deleteFileButtonClicked(sender:UIButton)
    {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        self.m_filesArray.remove(at: indexpath.row)
        self.m_attachedDocumentsArray.remove(at: indexpath.row)
    }
    
    func displaySelectedFiles()
    {
        switch m_filesArray.count
        {
        case 0:
            m_documentView1.isHidden=true
            m_documentView2.isHidden=true
            m_documentView3.isHidden=true
            m_documentView4.isHidden=true
            m_documentView5.isHidden=true
            return
        case 1:
            m_documentView1.isHidden=false
            m_documentView2.isHidden=true
            m_documentView3.isHidden=true
            m_documentView4.isHidden=true
            m_documentView5.isHidden=true
            
            m_documentName1.text=m_filesArray[0]
            m_document1ImageView.image=setImageIcon(fileName: m_filesArray[0])
            return
        case 2:
            m_documentView1.isHidden=false
            m_documentView2.isHidden=false
            m_documentView3.isHidden=true
            m_documentView4.isHidden=true
            m_documentView5.isHidden=true
            
            m_documentName1.text=m_filesArray[0]
            m_documentName2.text=m_filesArray[1]
            m_document1ImageView.image=setImageIcon(fileName: m_filesArray[0])
            mdocuument2ImageView.image=setImageIcon(fileName: m_filesArray[1])
            return
        case 3:
            m_documentView1.isHidden=false
            m_documentView2.isHidden=false
            m_documentView3.isHidden=false
            m_documentView4.isHidden=true
            m_documentView5.isHidden=true
            
            m_documentName1.text=m_filesArray[0]
            m_documentName2.text=m_filesArray[1]
            m_documentName3.text=m_filesArray[2]
            m_document1ImageView.image=setImageIcon(fileName: m_filesArray[0])
            mdocuument2ImageView.image=setImageIcon(fileName: m_filesArray[1])
            m_document3ImageView.image=setImageIcon(fileName: m_filesArray[2])
            return
        case 4:
            m_documentView1.isHidden=false
            m_documentView2.isHidden=false
            m_documentView3.isHidden=false
            m_documentView4.isHidden=false
            m_documentView5.isHidden=true
            
            m_documentName1.text=m_filesArray[0]
            m_documentName2.text=m_filesArray[1]
            m_documentName3.text=m_filesArray[2]
            m_documentName4.text=m_filesArray[3]
            m_document1ImageView.image=setImageIcon(fileName: m_filesArray[0])
            mdocuument2ImageView.image=setImageIcon(fileName: m_filesArray[1])
            m_document3ImageView.image=setImageIcon(fileName: m_filesArray[2])
            m_document4ImmageView.image=setImageIcon(fileName: m_filesArray[3])
            
            return
        case 5:
            m_documentView1.isHidden=false
            m_documentView2.isHidden=false
            m_documentView3.isHidden=false
            m_documentView4.isHidden=false
            m_documentView5.isHidden=false
            
            m_documentName1.text=m_filesArray[0]
            m_documentName2.text=m_filesArray[1]
            m_documentName3.text=m_filesArray[2]
            m_documentName4.text=m_filesArray[3]
            m_documentName5.text=m_filesArray[4]
            m_document1ImageView.image=setImageIcon(fileName: m_filesArray[0])
            mdocuument2ImageView.image=setImageIcon(fileName: m_filesArray[1])
            m_document3ImageView.image=setImageIcon(fileName: m_filesArray[2])
            m_document4ImmageView.image=setImageIcon(fileName: m_filesArray[3])
            m_document5ImageView.image=setImageIcon(fileName: m_filesArray[4])
            
            
            return
        default:
            return
        }
        
    }
    
    func setImageIcon(fileName:String)->UIImage
    {
        let fileNameArr = fileName.characters.split{$0 == "."}.map(String.init)
        let type = fileNameArr[fileNameArr.count-1]
        var image = UIImage(named: "pdf-1")
        switch type
        {
        case "png":
            image = UIImage(named: "img")!
            return image!
        case "jpg":
            image = UIImage(named: "img")!
            return image!
        case "jpeg":
            image = UIImage(named: "img")!
            return image!
        case "pdf":
            image = UIImage(named: "pdf-1")!
            return image!
        case "xml":
            image = UIImage(named: "xlsfile")!
            return image!
        case "xls":
            image = UIImage(named: "xlsfile")!
            return image!
        case "xlsx":
            image = UIImage(named: "xlsfile")!
            return image!
        case "doc":
            image = UIImage(named: "pdf-1")!
            return image!
        case "docx":
            image = UIImage(named: "pdf-1")!
            return image!
            
        default:
            //            displayActivityAlert(title: "You can not uplod \(type) file")
            return image!
        }
        return image!
    }
    @IBAction func submitQueryButtonClicked(_ sender: Any)
    {
        submitQuery()
    }
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController)
    {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
        
    }
    
    static let shared = AddNewQueryViewController()
    fileprivate var currentVC: UIViewController?
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    
    
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
    
    
    
    //MARK: - showAttachmentActionSheet
    // This function is used to show the attachment sheet for image, video, photo and file.
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
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    func openDocumentPicker()
    {
        present(documentPicker, animated: true, completion: nil)
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
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(){
        /*
         if UIImagePickerController.isSourceTypeAvailable(.camera){
         let myPickerController = UIImagePickerController()
         myPickerController.delegate = self
         myPickerController.sourceType = .camera
         //            currentVC?.present(myPickerController, animated: true, completion: nil)
         
         DispatchQueue.main.async {
         self.getTopMostViewController()?.present(myPickerController, animated: true, completion: nil)
         }
         
         
         }
         */
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
    
    //MARK: - VIDEO PICKER
    func videoLibrary(){
        DispatchQueue.main.async{
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
    }
    
    //MARK: - FILE PICKER
    //    func documentPicker(){
    //        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
    //        importMenu.delegate = self
    //        importMenu.modalPresentationStyle = .formSheet
    //        currentVC?.present(importMenu, animated: true, completion: nil)
    //    }
    //
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
    
    
    
    
}
//MARK: - IMAGE PICKER DELEGATE
// This is responsible for image picker interface to access image, video and then responsibel for canceling the picker
extension AddNewQueryViewController
{
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        setupDropDown(textField,at: textField.tag)
        dateDropDown.show()
        
        return false
        
        
    }
    
    func setupDropDown(_ selectButon: UITextField, at index: Int)
    {
        
        dateDropDown.anchorView = selectButon
        dateDropDown.bottomOffset = CGPoint(x: 0, y: 1)
        dateDropDown.width = m_textField.frame.size.width
        
        
        dateDropDown.dataSource =
        m_membersArray
        
        // Action triggered on selection
        dateDropDown.selectionAction =
        {
            [unowned self] (index, item) in
            
            self.selectedRowIndex = -1
            selectButon.textColor=UIColor.black
            selectButon.text=""+item
            
        }
        
    }
}


extension PHAsset {
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
