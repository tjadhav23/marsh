//
//  ViewQueryViewController.swift
//  MyBenefits
//
//  Created by Semantic on 08/02/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseCrashlytics
import SDWebImage
import TrustKit
import AesEverywhere

extension UIDocumentPickerDelegate{
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        print(cico)
        print(url)
        
        print(url.lastPathComponent)
        
        print(url.pathExtension)
        
    }
}
class ViewQueryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIDocumentPickerDelegate,UITextViewDelegate,UIDocumentMenuDelegate,UIDocumentInteractionControllerDelegate,XMLParserDelegate {
    
    @IBOutlet weak var sendMessageButtonClicked: UIButton!
    
    
    @IBOutlet weak var m_openImagesuperView: UIView!
    @IBOutlet weak var m_openImageView: UIImageView!
    
    @IBOutlet weak var m_documentView5Height: NSLayoutConstraint!
    @IBOutlet weak var m_documentView4Height: NSLayoutConstraint!
    @IBOutlet weak var m_document3Height: NSLayoutConstraint!
    @IBOutlet weak var m_documentView2Height: NSLayoutConstraint!
    @IBOutlet weak var m_documentView1Height: NSLayoutConstraint!
    @IBOutlet weak var m_replyTopLine: UILabel!
    @IBOutlet weak var m_queryStatusLbl: UILabel!
    @IBOutlet weak var sendAttachmentButtonClicked: UIButton!
    
    @IBOutlet weak var m_heightForQueryView: NSLayoutConstraint!
    @IBOutlet weak var m_sendButton: UIButton!
    @IBOutlet weak var attachmentButton: UIButton!
    
    @IBOutlet weak var m_msgTextview: UITextView!
    @IBOutlet weak var m_TicketNoView: UIView!
    @IBOutlet weak var m_bottomView: UIView!
    @IBOutlet weak var m_queryTableView: UITableView!
    
    @IBOutlet weak var lblTicketNumber: UILabel!
    
    var m_uploadingImage = UIImage()
    var m_fileUploadData = Data()
    var m_selectedFileName = String()
    var m_filesArray = Array<String>()
    var m_documentLblArray = Array<UILabel>()
    let m_typeArray = ["png","jpg","jpeg","doc","docx","xml","xls","xlsx","pdf","pages"]
    var m_queryNo = String()
    var m_queriesArray = NSArray()
    var m_attachmentArray1 = ["","","","","","","","","","","","","","","","","","",""]
    var m_attachmentArray2 = ["","","","","","","","","","","","","","","","","","",""]
    var m_attachmentArray3 = ["","","","","","","","","","","","","","","","","","",""]
    var m_attachmentTypeArray1 = ["","","","","","","","","","","","","","","","","","",""]
    var m_attachmentTypeArray2 = ["","","","","","","","","","","","","","","","","","",""]
    var m_attachmentTypeArray3 = ["","","","","","","","","","","","","","","","","","",""]
    //var m_queryDict : Queries?
    var m_queryDict : [String:Any] = [:]
    
    @IBOutlet weak var m_documentName5: UILabel!
    @IBOutlet weak var m_documentName4: UILabel!
    @IBOutlet weak var m_documentName3: UILabel!
    @IBOutlet weak var m_documentName2: UILabel!
    @IBOutlet weak var m_documentName1: UILabel!
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
    
    
    let reuseIdentifier = "cell"
    var m_employeedict : EMPLOYEE_INFORMATION?
    var m_fileUrl : URL?
    var m_attachedDocumentsArray = Array<Any>()
    var m_employeeArray = ["EMPLOYEE","EX-EMPLOYEE","RETIRED-EMPLOYEE"]
    var m_hrArray = ["SR-HR","HR","REGIONWISE-HR","LOCATIONWISE-HR","PLANTDEPARTMENTWISE-HR","SUB-GROUPWISE-HR","CITYWISE-HR","ACCOUNT-MANAGER-EXECUTIVE"]
    
    var imageFormatsArray = [".png","PNG","JPEG",".jpeg",".JPG",".jpg","JPG","jpg"]

    let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.composite-content"], in: .import)
    
    var ticketNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFontUI()
        //m_queryTableView.register(ViewQueryTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        //let nib = UINib (nibName: "ViewQueryTableViewCell", bundle: nil)
        //m_queryTableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        m_queryTableView.register(MessageViewCell.self, forCellReuseIdentifier: "MessageViewCell")
        let nib1 = UINib (nibName: "MessageViewCell", bundle: nil)
        m_queryTableView.register(nib1, forCellReuseIdentifier: "MessageViewCell")

        m_queryTableView.register(HRMsgViewCell.self, forCellReuseIdentifier: "HRMsgViewCell")
        let nib2 = UINib (nibName: "HRMsgViewCell", bundle: nil)
        m_queryTableView.register(nib2, forCellReuseIdentifier: "HRMsgViewCell")
        
        //m_queryTableView.separatorStyle=UITableViewCellSeparatorStyle.none
        m_queryTableView.isHidden=true
        getQueryDetails(queryNo: m_queryNo)
        if(m_queryDict["EQ_CUST_QRY_SOLVED"] as? String == "1")
        {
            m_queryStatusLbl.isHidden=false
            m_queryStatusLbl.text="Your query has solved"
            
            m_bottomView.isHidden=true

            m_heightForQueryView.constant = 0

            m_replyTopLine.isHidden=false//true
        }
        else if(m_queryDict["EQ_CUST_QRY_ENDED"] as! String == "1")
        {
            m_queryStatusLbl.isHidden=false
            m_queryStatusLbl.text="Your Query is Ended"
            
            m_bottomView.isHidden=true
            m_heightForQueryView.constant = 0
            m_replyTopLine.isHidden=false//true
        }
        else
        {
            m_queryStatusLbl.isHidden=true
            m_bottomView.isHidden=false
            m_replyTopLine.isHidden=false
            navigationItem.rightBarButtonItem=getRightButton()
        }
        
        self.lblTicketNumber.text = "Ticket No: \(ticketNo)"
        self.m_msgTextview.backgroundColor = UIColor.white
        self.m_msgTextview.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        self.m_msgTextview.setBorderToView(color: UIColor.lightGray)
        
      
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.m_queryTableView.addGestureRecognizer(tap) // Add gesture recognizer to background view
        scrollToBottom()
    }
    
    func setupFontUI(){
        
        m_replyTopLine.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        m_replyTopLine.textColor = FontsConstant.shared.app_FontBlackColor
        
        m_queryStatusLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_queryStatusLbl.textColor = FontsConstant.shared.app_WhiteColor
        
        lblTicketNumber.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        lblTicketNumber.textColor = FontsConstant.shared.app_WhiteColor
        
        m_msgTextview.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_msgTextview.textColor = FontsConstant.shared.app_FontSecondryColor
            
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
        
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
      
        print("In gesture")
        m_msgTextview.resignFirstResponder() // dismiss keyoard
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.isNavigationBarHidden=false
        //        navigationItem.leftBarButtonItem=getBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        navigationItem.leftBarButtonItem = getBackButton()
        self.tabBarController?.tabBar.isHidden=true
        self.navigationItem.title="View Query"
    
        menuButton.isHidden=true
        DispatchQueue.main.async()
            {
                menuButton.isHidden=true
        }
        scrollToBottom()
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        self.m_queryTableView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        menuButton.isHidden=true
        scrollToBottom()
    }
    func getRightButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:nil, style: .plain, target: self, action: #selector(rightBarButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        if(m_queryDict["EQ_CUST_QRY_SOLVED"] as! String == "1")
        {
            m_queryStatusLbl.isHidden=false
            m_queryStatusLbl.text="Your query has solved"
            
            m_bottomView.isHidden=true
            m_heightForQueryView.constant = 0

            m_replyTopLine.isHidden=false//true
            button1.title=""
        }
        else if(m_queryDict["EQ_CUST_QRY_ENDED"] as? String == "1")
        {
            m_queryStatusLbl.isHidden=false
            m_queryStatusLbl.text="Your Query is Ended"
            m_heightForQueryView.constant = 0
            m_bottomView.isHidden=true
            m_replyTopLine.isHidden=false//true
            button1.title=""
        }
        else
        {
            button1.title="SOLVED ?"
            m_queryStatusLbl.isHidden=true
            m_bottomView.isHidden=false
            m_replyTopLine.isHidden=false
        }
        
        return button1
    }
    func removeRightButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:nil, style: .plain, target: self, action: nil) // action:#selector(Class.MethodName) for swift 3
        
      
        button1.title = ""
        return button1
    }
    @objc func rightBarButtonClicked()
    {
        let alertController = UIAlertController(title: "Do you want to mark query as Solved?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
            
        }
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        {(result : UIAlertAction) -> Void in
            
            self.resolved()
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    //MARK:- markAsSolved
    func resolved()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: "Please wait...")
            let uploadDic:NSDictionary=[:]
            
            var uploadData: Data = NSKeyedArchiver.archivedData(withRootObject: uploadDic)
            uploadData = try! JSONSerialization.data(withJSONObject: uploadDic, options: .prettyPrinted)
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getmarkSolvedQueryUrl(queryNo:m_queryNo) as String)
            
            print(urlreq)
            print(uploadData)
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
            var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

            
            let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
            print("m_authUserName_Portal ",encryptedUserName)
            print("m_authPassword_Portal ",encryptedPassword)
            
            let authData = authString.data(using: String.Encoding.utf8)!
            let base64AuthString = authData.base64EncodedString()
            request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
            request.httpBody=uploadData
            
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
                    self.displayActivityAlert(title: "The request timed out")
                }
                else
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                            do
                            {
                                
                                if let data = data, let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                                {
                                    
                                    let status=jsonResult.value(forKey: "Status")as! Bool
                                    DispatchQueue.main.async
                                        {
                                            if(status)
                                            {
                                                
                                                self.navigationItem.rightBarButtonItem=nil
                                                
                                                self.m_queryStatusLbl.isHidden=false
                                                self.m_queryStatusLbl.text="Your query has solved"
                                                
                                                self.m_bottomView.isHidden=true
                                                self.m_heightForQueryView.constant = 0

                                                self.m_replyTopLine.isHidden=false//true
                                                let message=jsonResult.value(forKey: "Message")as! String
                                                self.displayActivityAlert(title: message)
                                                self.hidePleaseWait()
                                                
                                            }
                                            else
                                            {
                                                
                                                let message=jsonResult.value(forKey: "Message")as! String
                                                self.displayActivityAlert(title: message)
                                                self.hidePleaseWait()
                                                
                                            }
                                    }
                                }
                            }
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                            }
                        }
                        else
                        {
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
                        }
                        
                    } else {
                        print("Can't cast response to NSHTTPURLResponse")
                    }
                }
            }
            
            task.resume()
            
            
        }
        else
        {
            
        }
        
        
        
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc override func backButtonClicked()
    {
        print ("backButtonClicked")
        
        self.tabBarController?.tabBar.isHidden=true
        _ = navigationController?.popViewController(animated: true)
        
    }
    func getQueryDetails(queryNo:String)
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: "Please wait...Fetching Query details")
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getOneQueryDetailsUrl(queryNo: queryNo))
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?
            request.httpMethod = "GET"
            
            var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
            var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

            
            let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
            print("m_authUserName_Portal ",encryptedUserName)
            print("m_authPassword_Portal ",encryptedPassword)
            
            //let authString = String(format: "%@:%@", m_authUserName_Portal, m_authPassword_Portal)
            let authData = authString.data(using: String.Encoding.utf8)!
            let base64AuthString = authData.base64EncodedString()
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
            authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
            print("authToken getQueryDetails:",authToken)
         
            request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            print("getQueryDetails: ",urlreq)
            
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
                //SSL Pinning
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                    // Handle SSL connection failure
                    print("SSL connection error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.alertForLogout(titleMsg: error.localizedDescription)
                    }
                }
                else if error != nil
                {
                    print("error %@",error!)
                    
                    self.hidePleaseWait()
                }
                else
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                            do {
                                
                                if let data = data, let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                                {
                                    
                                    if(jsonResult.count>0)
                                    {
                                        DispatchQueue.main.async
                                            {
                                                
                                                if let result = jsonResult.value(forKey: "message")
                                                {
                                                    let dict : NSDictionary = (result as? NSDictionary)!
                                                    
                                                    if let status = dict.value(forKey: "Status")
                                                    {
                                                        if(status as! Bool)
                                                        {
                                                            self.m_queriesArray = jsonResult.value(forKey: "ListOfQueries") as! NSArray
                                                            self.m_queryTableView.reloadData()
                                                            self.m_queryTableView.isHidden=false
                                                        }
                                                    }
                                                }
                                                self.hidePleaseWait()
                                        }
                                        print(jsonResult.allKeys)
                                    }
                                    else
                                    {
                                        let deadlineTime = DispatchTime.now() + .seconds(2)
                                        DispatchQueue.main.asyncAfter(deadline: deadlineTime)
                                        {
                                            self.hidePleaseWait()
                                            
                                        }
                                        
                                    }
                                    
                                }
                            } catch let JSONError as NSError
                            {
                                print(JSONError)
                                
                            }
                        }
                        else
                        {
                            self.hidePleaseWait()
                            self.handleServerError(httpResponse: httpResponse)
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
        else
        {
            self.hidePleaseWait()
            
        }
    }
    
    @IBAction func attachmentButtonClicked(_ sender: Any)
    {
        print("In gesture")
        m_msgTextview.resignFirstResponder()
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
      
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.8212677836, green: 0.02510161325, blue: 0.4012640119, alpha: 1)

        self.present(documentPicker, animated: true,completion: {

            //self.documentPicker.view.tintColor = .red
        })
        
    }
    @IBAction func sendButtonClicked(_ sender: Any)
    {
        submitQuery()
        
    }
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    @IBAction func document1DeleteBtnClicked(_ sender: Any)
    {
        print("In gesture")
        m_msgTextview.resignFirstResponder()
        self.m_filesArray.remove(at: 0)
        self.m_attachedDocumentsArray.remove(at: 0)
        displaySelectedFiles()
    }
    
    @IBAction func document2DeleteBtnClicked(_ sender: Any)
    {
        print("In gesture")
        m_msgTextview.resignFirstResponder()
        self.m_filesArray.remove(at: 1)
        self.m_attachedDocumentsArray.remove(at: 1)
        displaySelectedFiles()
    }
    
    @IBAction func document3DeleteBtnClicked(_ sender: Any) {
        
        print("In gesture")
        m_msgTextview.resignFirstResponder()
        self.m_filesArray.remove(at: 2)
        self.m_attachedDocumentsArray.remove(at: 2)
        displaySelectedFiles()
    }
    
    @IBAction func document4DeleteBtnClicked(_ sender: Any) {
        
        print("In gesture")
        m_msgTextview.resignFirstResponder()
        self.m_filesArray.remove(at: 3)
        self.m_attachedDocumentsArray.remove(at: 3)
        displaySelectedFiles()
    }
    @IBAction func document5DeleteBtnClicked(_ sender: Any) {
        print("In gesture")
        m_msgTextview.resignFirstResponder()
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
            m_heightForQueryView.constant=50
            return
        case 1:
            m_documentView1.isHidden=false
            m_documentView2.isHidden=true
            m_documentView3.isHidden=true
            m_documentView4.isHidden=true
            m_documentView5.isHidden=true
            m_documentView1Height.constant=30
            m_documentName1.text=m_filesArray[0]
            m_document1ImageView.image=setImageIcon(fileName: m_filesArray[0])
            m_heightForQueryView.constant=80
            return
        case 2:
            m_documentView1.isHidden=false
            m_documentView2.isHidden=false
            m_documentView3.isHidden=true
            m_documentView4.isHidden=true
            m_documentView5.isHidden=true
            m_documentView2Height.constant=30
            m_documentName1.text=m_filesArray[0]
            m_documentName2.text=m_filesArray[1]
            m_document1ImageView.image=setImageIcon(fileName: m_filesArray[0])
            mdocuument2ImageView.image=setImageIcon(fileName: m_filesArray[1])
            m_heightForQueryView.constant=80
            return
        case 3:
            m_documentView1.isHidden=false
            m_documentView2.isHidden=false
            m_documentView3.isHidden=false
            m_documentView4.isHidden=true
            m_documentView5.isHidden=true
            m_document3Height.constant=30
            m_documentName1.text=m_filesArray[0]
            m_documentName2.text=m_filesArray[1]
            m_documentName3.text=m_filesArray[2]
            m_document1ImageView.image=setImageIcon(fileName: m_filesArray[0])
            mdocuument2ImageView.image=setImageIcon(fileName: m_filesArray[1])
            m_document3ImageView.image=setImageIcon(fileName: m_filesArray[2])
            m_heightForQueryView.constant=80
            return
        case 4:
            m_documentView1.isHidden=false
            m_documentView2.isHidden=false
            m_documentView3.isHidden=false
            m_documentView4.isHidden=false
            m_documentView5.isHidden=true
            m_documentView4Height.constant=30
            m_documentName1.text=m_filesArray[0]
            m_documentName2.text=m_filesArray[1]
            m_documentName3.text=m_filesArray[2]
            m_documentName4.text=m_filesArray[3]
            m_document1ImageView.image=setImageIcon(fileName: m_filesArray[0])
            mdocuument2ImageView.image=setImageIcon(fileName: m_filesArray[1])
            m_document3ImageView.image=setImageIcon(fileName: m_filesArray[2])
            m_document4ImmageView.image=setImageIcon(fileName: m_filesArray[3])
            m_heightForQueryView.constant=120
            return
        case 5:
            m_documentView1.isHidden=false
            m_documentView2.isHidden=false
            m_documentView3.isHidden=false
            m_documentView4.isHidden=false
            m_documentView5.isHidden=false
            m_documentView5Height.constant=30
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
            m_heightForQueryView.constant=120
            
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
    func submitQuery()
    {
        if(m_msgTextview.text=="Enter your reply here" || m_msgTextview.text=="")
        {
            displayActivityAlert(title: "Please insert your query")
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
                            print("httpResponse.statusCode : ",httpResponse.statusCode)
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
                                                    if let status  = jsonResult.value(forKey: "Status")
                                                    {
                                                        let boolStatus : Bool = (status as? Bool)!
                                                        if(boolStatus)
                                                        {
                                                            let message = jsonResult.value(forKey: "Message")
                                                            self.getQueryDetails(queryNo: self.m_queryNo)
                                                            self.m_queryTableView.reloadData()
                                                            self.hidePleaseWait()
                                                            self.displayActivityAlert(title:message as! String)
                                                            self.m_msgTextview.text="Enter your reply here"
                                                            self.m_msgTextview.textColor=UIColor.lightGray
                                                            
                                                            //Added By Pranit - To clear attachmentArray after submit query
                                                            self.m_attachedDocumentsArray.removeAll()
                                                            self.m_filesArray.removeAll()
                                                            self.displaySelectedFiles()
                                                            
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
                                print("else executed")
                            }
                            
                        } else {
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
    func createRequest() throws -> URLRequest
    {
        var employeesrno = String()
        if let empNo = m_employeedict?.empSrNo
        {
            employeesrno = String(empNo)
            employeesrno = try! AES256.encrypt(input: employeesrno, passphrase: m_passphrase_Portal)
        }
        let parameters : NSDictionary = ["Query":m_msgTextview.text,"EmpSrNo":employeesrno,"CustQuerySrNo":m_queryNo,"IsReply":true] // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let url = NSURL(string: WebServiceManager.getSharedInstance().getSubmitQueryUrl() as String)
        
        //        let url = NSURL(string:"http://www.mybenefits360.in/testupload/api/Upload/PostFile" as String)
        
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
        var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

        let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
        print("m_authUserName_Portal ",encryptedUserName)
        print("m_authPassword_Portal ",encryptedPassword)
        
       // let authString = String(format: "%@:%@", m_authUserName_Portal, m_authPassword_Portal)
        let authData = authString.data(using: String.Encoding.utf8)!
        let base64AuthString = authData.base64EncodedString()
        //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
        authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
        print("authToken EmployeeQueries/PostQueries:",authToken)
     
        request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")


        request.httpBody = try createBody(with: parameters , filePathKey: "file", fileUrlArray: m_attachedDocumentsArray, boundary: boundary)
        
        print("request.httpBody: ",request.httpBody)
        print("parameters: ",parameters)
        print("m_attachedDocumentsArray: ",m_attachedDocumentsArray)
        print("boundary: ",boundary)
        
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
        
        
        print(jsonData)
        
        
        
        
        for path in fileUrlArray
        {
            let fileUrl : URL = path as! URL
            let filename = fileUrl.lastPathComponent
            let data = try Data(contentsOf: fileUrl)
            let mimetype = mimeType(for: fileUrl.path)
            
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(data)
            body.append("\r\n")
        }
        
        
        body.append("--\(boundary)--\r\n")
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
    
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return m_queriesArray.count
    }
    @objc func viewMoreButtonTappedHemangi(sender:UITapGestureRecognizer)
    {
        let index = IndexPath(row: sender.view!.tag, section: 0)
        let cell : ViewQueryTableViewCell = m_queryTableView.cellForRow(at: index) as! ViewQueryTableViewCell
         let queryDict :NSDictionary = (m_queriesArray[index.row] as? NSDictionary)!
        let reason = queryDict.value(forKey: "Query") as? String
        
        if((cell.m_firstLbl.text?.contains("  Read less..."))!)
        {
            if(reason!.count>100)
            {
                
                let endIndex = reason!.index(reason!.startIndex, offsetBy: 100)
                var truncated = reason!.substring(to: endIndex)
                truncated=truncated+"  Read more..."
                let range = (truncated as NSString).range(of: "  Read more...")
                let attributedString = NSMutableAttributedString(string:truncated)
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: hexStringToUIColor(hex: "FFFFFF") , range: range)
                cell.m_firstLbl.attributedText=attributedString
            }
            else
            {
                cell.m_firstLbl.text=reason
            }
            
        }
        else
        {
            let fullText = reason!+"  Read less..."
            let range = (fullText as NSString).range(of: "  Read less...")
            let attributedString = NSMutableAttributedString(string:fullText)
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: hexStringToUIColor(hex: "FFFFFF") , range: range)
            cell.m_firstLbl.attributedText=attributedString
        }
        
        
    }
    
    @objc func viewMoreButtonTapped(sender:UITapGestureRecognizer)
    {
        
    
        /*
        let index = IndexPath(row: sender.view!.tag, section: 0)
        let cell : MessageViewCell = m_queryTableView.cellForRow(at: index) as! MessageViewCell
        let queryDict :NSDictionary = (m_queriesArray[index.row] as? NSDictionary)!
        let reason = queryDict.value(forKey: "Query") as? String
        
        if((cell.msgLabel.text?.contains("  Read less..."))!)
        {
            if(reason!.count>100)
            {
                
                let endIndex = reason!.index(reason!.startIndex, offsetBy: 100)
                var truncated = reason!.substring(to: endIndex)
                truncated=truncated+"  Read more..."
                let range = (truncated as NSString).range(of: "  Read more...")
                let attributedString = NSMutableAttributedString(string:truncated)
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: hexStringToUIColor(hex: "FFFFFF") , range: range)
                cell.msgLabel.attributedText=attributedString
            }
            else
            {
                cell.msgLabel.text=reason
            }
            
        }
        else
        {
            let fullText = reason!+"  Read less..."
            let range = (fullText as NSString).range(of: "  Read less...")
            let attributedString = NSMutableAttributedString(string:fullText)
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: hexStringToUIColor(hex: "FFFFFF") , range: range)
            cell.msgLabel.attributedText=attributedString
        }
        
        */
    }
    /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell : ViewQueryTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! ViewQueryTableViewCell
        cell.m_firstLbl.isUserInteractionEnabled=true
       
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        setBottomShadow(view: cell.m_firstLbl)
        setBottomShadow(view: cell.m_secondLbl)
        setBottomShadow(view: cell.m_thirdLbl)
        shadowForCell(view: cell.m_secondLbl)
        cell.m_firstLblView.layer.masksToBounds=true
        cell.m_firstLblView.layer.cornerRadius=7
        cell.m_secondLblView.layer.masksToBounds=true
        cell.m_secondLblView.layer.cornerRadius=7
        cell.m_thirdLblView.layer.masksToBounds=true
        cell.m_thirdLblView.layer.cornerRadius=7
        if #available(iOS 11.0, *) {
            cell.m_firstLblView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            cell.m_secondLblView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            cell.m_thirdLblView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        }
        else
        {
            // Fallback on earlier versions
        }
        cell.m_firstImageView.layer.masksToBounds=true
        cell.m_firstImageView.layer.cornerRadius=cell.m_firstImageView.frame.height/2
        cell.m_firstImageView.layer.borderWidth=1
        cell.m_firstImageView.layer.borderColor=UIColor.lightGray.cgColor
        cell.m_secondImageview.layer.masksToBounds=true
        cell.m_secondImageview.layer.cornerRadius=cell.m_secondImageview.frame.height/2
        cell.m_secondImageview.layer.borderWidth=1
        cell.m_secondImageview.layer.borderColor=UIColor.lightGray.cgColor
        
        cell.m_thirdImageView.layer.cornerRadius=cell.m_thirdImageView.frame.height/2
        cell.m_thirdImageView.layer.borderWidth=1
        cell.m_thirdImageView.layer.borderColor=UIColor.lightGray.cgColor
        
        let queryDict :NSDictionary = (m_queriesArray[indexPath.row] as? NSDictionary)!
        //        let userImage = downloadImage(url: queryDict.value(forKey: "PostedByimage") as! String)
        let role: String = queryDict.value(forKey: "Role") as! String
        let attachmentArray : [NSDictionary] = queryDict.value(forKey: "Attachments") as! [NSDictionary]
        if(m_employeeArray.contains(role))
        {
            var queryText = queryDict.value(forKey: "Query") as? String
            queryText = queryText?.replacingOccurrences(of: "<br/>", with: "\n")
            
            //MARK:- Add Button....
            if(queryText!.count>100)
            {
                cell.m_firstLbl.tag = indexPath.row
                let gesture = UITapGestureRecognizer(target: self, action:  #selector (viewMoreButtonTapped (sender:)))
                cell.m_firstLbl.addGestureRecognizer(gesture)
                
                
                let endIndex = queryText!.index(queryText!.startIndex, offsetBy: 100)
                var truncated = queryText!.substring(to: endIndex)
                truncated=truncated+"....Read more"
                let range = (truncated as NSString).range(of: "....Read more")
                let attributedString = NSMutableAttributedString(string:truncated)
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: hexStringToUIColor(hex:"FFFFFF") , range: range)
                cell.m_firstLbl.attributedText=attributedString
            }
            else
            {
                cell.m_firstLbl.text=queryText!
            }
            
            
            cell.m_firstImageView.sd_setImage(with: URL(string: queryDict.value(forKey: "PostedByimage") as! String), placeholderImage: UIImage(named: "avatar"))
            cell.m_date1Lbl.text=queryDict.value(forKey: "PostedOn") as? String
            cell.m_userName1Lbl.text=queryDict.value(forKey: "PostedBy") as? String
            cell.m_moreButton.isHidden=true
            cell.m_moreButton.tag=indexPath.row
            
            cell.m_secondView.isHidden=true
            cell.m_secondImageview.isHidden=true
            cell.m_userName2Lbl.isHidden=true
            cell.m_userName3Lbl.isHidden=true
            cell.m_firstView.isHidden=false
            cell.m_firstImageView.isHidden=false
            cell.m_thirdView.isHidden=true
            cell.m_thirdImageView.isHidden=true
            
            cell.m_userName2TopConstraint.constant=0
            cell.m_userName2BottomConstraint.constant=0
            cell.m_firstImageviewHeight.constant=30
            cell.m_secondImageviewHeight.constant=0
            cell.m_thirdImageViewHeight.constant=0
            cell.m_userName3TopConstraint.constant=0
            cell.m_name3BottomConstraint.constant=0
            
            
            for i in 0..<attachmentArray.count
            {
                let filePath = attachmentArray[i].value(forKey: "FileName")
                let fileType = attachmentArray[i].value(forKey: "FileType")
                
                m_attachmentArray1[indexPath.row]=filePath as! String
                m_attachmentTypeArray1[indexPath.row]=fileType as! String
                if(i==0)
                {
                    cell.m_documentSubView1.isHidden=false
                    cell.m_documentSubView1.layer.masksToBounds=true
                    cell.m_documentSubView1.layer.cornerRadius=6
                    let fileName = (filePath as! NSString).lastPathComponent
                    let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
                    
                    cell.documentLbl1.text=fileNameArr[fileNameArr.count-1]
                    cell.documentLbl1.isUserInteractionEnabled=true
                    cell.documentLbl1.tag=indexPath.row
                    let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument1 (_:)))
                    cell.documentLbl1.addGestureRecognizer(gesture)
                    
                    cell.m_documentView1HeightConstraint.constant=40
                    cell.m_documentView4Height.constant=0
                    cell.m_documentView5Height.constant=0
                    cell.m_moreButton.isHidden=true
                    
                }
                else if(i==1)
                {
                    cell.m_documentSubview2.isHidden=false
                    cell.m_documentSubview2.layer.masksToBounds=true
                    cell.m_documentSubview2.layer.cornerRadius=6
                    let fileName = (filePath as! NSString).lastPathComponent
                    let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
                    cell.documentLbl2.text=fileNameArr[fileNameArr.count-1]
                    cell.documentLbl2.tag=indexPath.row
                    let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument2 (_:)))
                    cell.documentLbl2.addGestureRecognizer(gesture)
                    cell.m_moreButton.isHidden=true
                }
                else if(i==2)
                {
                    cell.m_moreButton.setTitle("+1 more", for: .normal)
                    cell.m_moreButton.isHidden=false
                    cell.m_moreButton.addTarget(self, action: #selector(moreButton1Clicked), for: .touchUpInside)
                    
                    
                }
                else if(i==3)
                {
                    
                    cell.m_moreButton.isHidden=false
                    cell.m_moreButton.setTitle("+2 more", for: .normal)
                }
                else if(i==4)
                {
                    
                    cell.m_moreButton.isHidden=false
                    cell.m_moreButton.setTitle("+3 more", for: .normal)
                }
            }
        } //For Emp sender
        else if(m_hrArray.contains(role))
        {
            var queryText = queryDict.value(forKey: "Query") as? String
            queryText = queryText?.replacingOccurrences(of: " ", with: "")
            queryText = queryText?.replacingOccurrences(of: "<b/>", with: "\n")
            cell.m_secondLbl.text=queryText!
            
            cell.m_secondImageview.sd_setImage(with: URL(string: queryDict.value(forKey: "PostedByimage") as! String), placeholderImage: UIImage(named: "avatar"))
            
            cell.m_date2Lbl.text=queryDict.value(forKey: "PostedOn") as? String
            cell.m_userName2Lbl.text=queryDict.value(forKey: "PostedBy") as? String
            cell.m_moreButton2.isHidden=true
            cell.m_moreButton2.tag=indexPath.row
            cell.m_moreButton2.addTarget(self, action: #selector(moreButton2Clicked), for: .touchUpInside)
            cell.m_userName1Lbl.isHidden=true
            cell.m_userName3Lbl.isHidden=true
            cell.m_secondView.isHidden=false
            cell.m_secondImageview.isHidden=false
            cell.m_firstView.isHidden=true
            cell.m_firstImageView.isHidden=true
            cell.m_thirdView.isHidden=true
            cell.m_thirdImageView.isHidden=true
            cell.m_documentView1HeightConstraint.constant=0
            cell.m_documentView2HeightConstraint.constant=0
            cell.m_documentView3HeightConstraint.constant=0
            cell.m_firstImageviewHeight.constant=0
            cell.m_userName1TopConstraint.constant=0
            cell.m_userName3TopConstraint.constant=0
            cell.m_name3BottomConstraint.constant=0
            cell.m_firstImageviewHeight.constant=0
            cell.m_secondImageviewHeight.constant=30
            cell.m_thirdImageViewHeight.constant=0
            
            for i in 0..<attachmentArray.count
            {
                let filePath = attachmentArray[i].value(forKey: "FileName")
                let fileType = attachmentArray[i].value(forKey: "FileType")
                cell.m_documentView2HeightConstraint.constant=70
                m_attachmentArray2[indexPath.row]=filePath as! String
                m_attachmentTypeArray2[indexPath.row]=fileType as! String
                if(i==0)
                {
                    cell.m_document2Subview1.isHidden=false
                    cell.m_document2Subview1.layer.masksToBounds=true
                    cell.m_document2Subview1.layer.cornerRadius=6
                    let fileName = (filePath as! NSString).lastPathComponent
                    let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
                    cell.document2Lbl1.text=fileNameArr[fileNameArr.count-1]
                    cell.document2Lbl1.isUserInteractionEnabled=true
                    cell.document2Lbl1.tag=indexPath.row
                    let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument21 (_:)))
                    cell.document2Lbl1.addGestureRecognizer(gesture)
                    cell.m_documentView2HeightConstraint.constant=40
                    cell.m_document2View1Height.constant=30
                    cell.m_document2View4Height.constant=0
                    cell.m_document2View5Height.constant=0
                    cell.m_moreButton2.isHidden=true
                }
                else if(i==1)
                {
                    cell.m_document2Subview2.isHidden=false
                    cell.m_document2Subview2.layer.masksToBounds=true
                    cell.m_document2Subview2.layer.cornerRadius=6
                    let fileName = (filePath as! NSString).lastPathComponent
                    let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
                    cell.m_document2Lbl2.text=fileNameArr[fileNameArr.count-1]
                    cell.m_document2Lbl2.tag=indexPath.row
                    let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument22 (_:)))
                    cell.m_document2Lbl2.addGestureRecognizer(gesture)
                    cell.m_dcument2View2Height.constant=30
                    cell.m_moreButton2.isHidden=true
                }
                else if(i==2)
                {
                    cell.m_moreButton2.isHidden=false
                    cell.m_moreButton2.setTitle("+1 more", for: .normal)
                    
                }
                else if(i==3)
                {
                    cell.m_moreButton2.isHidden=false
                    cell.m_moreButton2.setTitle("+2 more", for: .normal)
                    
                }
                else if(i==4)
                {
                    cell.m_moreButton2.isHidden=false
                    cell.m_moreButton2.setTitle("+3 more", for: .normal)
                }
            }
        }
        else
        {
            cell.m_userName1Lbl.isHidden=true
            cell.m_userName2Lbl.isHidden=true
            cell.m_secondView.isHidden=true
            cell.m_secondImageview.isHidden=true
            cell.m_firstView.isHidden=true
            cell.m_firstImageView.isHidden=true
            cell.m_thirdView.isHidden=false
            var queryText = queryDict.value(forKey: "Query") as? String
            queryText = queryText?.replacingOccurrences(of: " ", with: "")
            queryText = queryText?.replacingOccurrences(of: "<b/>", with: "\n")
            cell.m_thirdLbl.text=queryText!
            
            cell.m_thirdImageView.sd_setImage(with: URL(string: queryDict.value(forKey: "PostedByimage") as! String), placeholderImage: UIImage(named: "avatar"))
            
            //            downloadImageFrom(link: queryDict.value(forKey: "PostedByimage") as! String, contentMode: UIViewContentMode.scaleAspectFit)
            
            cell.m_date3Lbl.text=queryDict.value(forKey: "PostedOn") as? String
            cell.m_userName3Lbl.text=queryDict.value(forKey: "PostedBy") as? String
            cell.m_moreButton3.isHidden=true
            cell.m_moreButton3.tag=indexPath.row
            cell.m_moreButton3.addTarget(self, action: #selector(moreButton3Clicked), for: .touchUpInside)
            cell.m_documentView1HeightConstraint.constant=0
            cell.m_documentView2HeightConstraint.constant=0
            cell.m_documentView3HeightConstraint.constant=0
            cell.m_userName2TopConstraint.constant=0
            cell.m_userName2BottomConstraint.constant=0
            cell.m_secondImageviewHeight.constant=0
            cell.m_firstImageviewHeight.constant=30
            cell.m_secondImageviewHeight.constant=0
            cell.m_thirdImageViewHeight.constant=30
            cell.m_userName1TopConstraint.constant=0
            
            
            for i in 0..<attachmentArray.count
            {
                let filePath = attachmentArray[i].value(forKey: "FileName")
                let fileType = attachmentArray[i].value(forKey: "FileType")
                m_attachmentArray3[indexPath.row]=filePath as! String
                m_attachmentTypeArray3[indexPath.row]=fileType as! String
                if(i==0)
                {
                    cell.m_document3Subview1.isHidden=false
                    cell.m_document3Subview1.layer.masksToBounds=true
                    cell.m_document3Subview1.layer.cornerRadius=6
                    let fileName = (filePath as! NSString).lastPathComponent
                    let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
                    cell.m_document3Lbl1.text=fileNameArr[fileNameArr.count-1]
                    cell.m_document3Lbl1.isUserInteractionEnabled=true
                    cell.m_document3Lbl1.tag=indexPath.row
                    let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument31 (_:)))
                    cell.m_document3Lbl1.addGestureRecognizer(gesture)
                    cell.m_documentView3HeightConstraint.constant=40
                    cell.m_document3View1Height.constant=30
                    cell.m_document3View4Height.constant=0
                    cell.m_document3View5Height.constant=0
                    cell.m_moreButton3.isHidden=true
                }
                else if(i==1)
                {
                    cell.m_document3Subview2.isHidden=false
                    cell.m_document3Subview2.layer.masksToBounds=true
                    cell.m_document3Subview2.layer.cornerRadius=6
                    let fileName = (filePath as! NSString).lastPathComponent
                    let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
                    cell.m_document3Lbl2.text=fileNameArr[fileNameArr.count-1]
                    cell.m_document3Lbl2.tag=indexPath.row
                    let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument32 (_:)))
                    cell.m_document3Lbl2.addGestureRecognizer(gesture)
                    cell.m_document3View2Height.constant=30
                    cell.m_moreButton3.isHidden=true
                }
                else if(i==2)
                {
                    cell.m_moreButton3.isHidden=false
                    cell.m_moreButton3.setTitle("+1 more", for: .normal)
                    
                }
                else if(i==3)
                {
                    cell.m_moreButton3.isHidden=false
                    cell.m_moreButton3.setTitle("+2 more", for: .normal)
                }
                else if(i==4)
                {
                    cell.m_moreButton3.isHidden=false
                    cell.m_moreButton3.setTitle("+3 more", for: .normal)
                    
                }
            }
        }
        
        
        return cell
        
        
        
        
    }
 */
    var selectedRow = -1
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let queryDict :NSDictionary = (m_queriesArray[indexPath.row] as? NSDictionary)!
        //        let userImage = downloadImage(url: queryDict.value(forKey: "PostedByimage") as! String)
        let role: String = queryDict.value(forKey: "Role") as! String
        let attachmentArray : [NSDictionary] = queryDict.value(forKey: "Attachments") as! [NSDictionary]
        if(m_employeeArray.contains(role))
        {
            
            let cell : MessageViewCell = tableView.dequeueReusableCell(withIdentifier: "MessageViewCell") as! MessageViewCell
            
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            setBottomShadow(view: cell.msgLabel)
            
            cell.m_firstLblView.layer.masksToBounds=true
            cell.m_firstLblView.layer.cornerRadius=7
            if #available(iOS 11.0, *) {
                cell.m_firstLblView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            }
            else
            {
                // Fallback on earlier versions
            }
            cell.imgView.layer.masksToBounds=true
            cell.imgView.layer.cornerRadius=cell.imgView.frame.height/2
            cell.imgView.layer.borderWidth=1
            
            
            var queryText = queryDict.value(forKey: "Query") as? String
            queryText = queryText?.replacingOccurrences(of: "<br/>", with: "\n")
            cell.msgLabel.text=queryText!
            
            
            
            cell.imgView.sd_setImage(with: URL(string: queryDict.value(forKey: "PostedByimage") as! String), placeholderImage: UIImage(named: "avatar"))
            //cell.lblTimeStamp.text=queryDict.value(forKey: "PostedOn") as? String
             cell.lblTimeStamp.text = String(format: "Posted On \n%@",queryDict.value(forKey: "PostedOn") as? String ?? "")
            cell.senderName.text=queryDict.value(forKey: "PostedBy") as? String
            
            //Attachments
            if attachmentArray.count > 0 {
                let filePath = attachmentArray[0].value(forKey: "FileName")
                let fileType = attachmentArray[0].value(forKey: "FileType")
                
                //cell.lblAttachment.text = filePath as! String
                let fileName = (filePath as! NSString).lastPathComponent
                let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
                cell.lblAttachment.text=fileNameArr[fileNameArr.count-1]
                
                setAttachementIcon(cell: cell, type: fileType as! String)

                
                if attachmentArray.count > 1 {
                    cell.btnMore.setTitle("+\(attachmentArray.count - 1) More", for: .normal)
                }
                else {
                    cell.btnMore.setTitle("", for: .normal)
                    cell.btnMore.isHidden = true
                    cell.widthForMoreAttachmentButton.constant = 0
                }
                cell.viewAttachment.isHidden = false
            }
            else { //No Attachment Added
                cell.btnMore.setTitle("", for: .normal)
                cell.widthForMoreAttachmentButton.constant = 0
                cell.heightForAttachmentView.constant = 0
                cell.lblAttachment.text = ""
                cell.viewAttachment.isHidden = true
            }
            var queryText1 = queryDict.value(forKey: "Query") as? String
            
            
            //MARK:- Add Button....
            if(queryText1!.count>100)
            {
                if indexPath.row == selectedRow {
                    cell.msgLabel.numberOfLines = 0
                    cell.moreTextButton.isHidden = true
                    cell.heightMoewText.constant = 0
                    cell.msgLabel.text=queryText1!
                }
                else {
                    cell.msgLabel.numberOfLines = 4
                    cell.moreTextButton.isHidden = false
                    cell.moreTextButton.tag = indexPath.row
                    cell.moreTextButton.addTarget(self, action: #selector(showMoreText(sender:)), for: .touchUpInside)
                    cell.heightMoewText.constant = 14
                    
                }
            }
            else
            {
                cell.heightMoewText.constant = 0
                cell.msgLabel.numberOfLines = 0
                cell.moreTextButton.isHidden = true
                cell.msgLabel.text=queryText1!
            }
            
            cell.btnMore.tag = indexPath.row
            cell.btnMore.addTarget(self, action: #selector(moreDocsTapped(sender:)), for: .touchUpInside)
            
            let msgLabelGesture = UITapGestureRecognizer(target: self, action: #selector(openSingleDocument(sender:)))
            cell.lblAttachment.addGestureRecognizer(msgLabelGesture)
            cell.lblAttachment.isUserInteractionEnabled = true
            cell.lblAttachment.tag = indexPath.row

            return cell
        }
            
            //MARK:- HR_CELL
       // else if(m_hrArray.contains(role))
        else
        {
            let cell : HRMsgViewCell = tableView.dequeueReusableCell(withIdentifier: "HRMsgViewCell") as! HRMsgViewCell
            
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            setBottomShadow(view: cell.msgLabel)
            
            cell.m_firstLblView.layer.masksToBounds=true
            cell.m_firstLblView.layer.cornerRadius=7
            if #available(iOS 11.0, *) {
               
                 cell.m_firstLblView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            }
            else
            {
                // Fallback on earlier versions
            }
            cell.imgView.layer.masksToBounds=true
            cell.imgView.layer.cornerRadius=cell.imgView.frame.height/2
            cell.imgView.layer.borderWidth=1
            
            var queryText = queryDict.value(forKey: "Query") as? String
            queryText = queryText?.replacingOccurrences(of: " ", with: "")
            queryText = queryText?.replacingOccurrences(of: "<b/>", with: "\n")
            cell.msgLabel.text=queryText!
            
            cell.imgView.sd_setImage(with: URL(string: queryDict.value(forKey: "PostedByimage") as! String), placeholderImage: UIImage(named: "avatar"))
            
            cell.lblTimeStamp.text = String(format: "Posted On \n%@",queryDict.value(forKey: "PostedOn") as? String ?? "")
            cell.senderName.text=queryDict.value(forKey: "PostedBy") as? String
            
            //Attachments
            if attachmentArray.count > 0 {
                let filePath = attachmentArray[0].value(forKey: "FileName")
                let fileType = attachmentArray[0].value(forKey: "FileType")
                
                //cell.lblAttachment.text = filePath as! String
                let fileName = (filePath as! NSString).lastPathComponent
                let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
                cell.lblAttachment.text=fileNameArr[fileNameArr.count-1]
                setAttachementIcon(cell: cell, type: fileType as! String)
                
                
                if attachmentArray.count > 1 {
                    cell.btnMore.setTitle("+\(attachmentArray.count - 1) More", for: .normal)
                }
                else {
                    cell.btnMore.setTitle("", for: .normal)
                    cell.btnMore.isHidden = true
                    cell.widthForMoreAttachmentButton.constant = 0
                }
                cell.viewAttachment.isHidden = false
            }
            else { //No Attachment Added
                cell.btnMore.setTitle("", for: .normal)
                cell.widthForMoreAttachmentButton.constant = 0
                cell.heightForAttachmentView.constant = 0
                cell.lblAttachment.text = ""
                cell.viewAttachment.isHidden = true
            }
            var queryText1 = queryDict.value(forKey: "Query") as? String
            
            
            //MARK:- Add Button....
            if(queryText1!.count>100)
            {
                if indexPath.row == selectedRow {
                    cell.msgLabel.numberOfLines = 0
                    cell.moreTextButton.isHidden = true
                    cell.heightMoewText.constant = 0
                    cell.msgLabel.text=queryText1!
                }
                else {
                    cell.msgLabel.numberOfLines = 4
                    cell.moreTextButton.isHidden = false
                    cell.moreTextButton.tag = indexPath.row
                    cell.moreTextButton.addTarget(self, action: #selector(showMoreText(sender:)), for: .touchUpInside)
                    cell.heightMoewText.constant = 14
                    
                }
            }
            else
            {
                cell.heightMoewText.constant = 0
                cell.msgLabel.numberOfLines = 0
                cell.moreTextButton.isHidden = true
                cell.msgLabel.text=queryText1!
            }
            
            cell.btnMore.tag = indexPath.row
            cell.btnMore.addTarget(self, action: #selector(moreDocsTapped(sender:)), for: .touchUpInside)
            
            let msgLabelGesture = UITapGestureRecognizer(target: self, action: #selector(openSingleDocument(sender:)))
            cell.lblAttachment.tag = indexPath.row
            cell.lblAttachment.addGestureRecognizer(msgLabelGesture)
            cell.lblAttachment.isUserInteractionEnabled = true
            
            return cell
        }
        
        
    }
    
    
    func setAttachementIcon(cell:MessageViewCell,type:String) {
        if (type == ".xlsx" || type == "XLS" || type=="XLSX")
        {
            cell.imgAttachment.image = UIImage(named: "excel")
        }
        else if(type == ".pdf" || type == "PDF")
        {
            cell.imgAttachment.image = UIImage(named: "pdf-1")
        }
        else if(type == ".doc" || type == "DOC")
        {
            cell.imgAttachment.image = UIImage(named: "word")
        }
        else if (imageFormatsArray.contains(type))
        {
            cell.imgAttachment.image = UIImage(named: "img")
        }
        else
        {
            cell.imgAttachment.image = UIImage(named: "img")
        }
    }
    
    func setAttachementIcon(cell:HRMsgViewCell,type:String) {
        if (type == ".xlsx" || type == "XLS" || type=="XLSX")
        {
            cell.imgAttachment.image = UIImage(named: "excel")
        }
        else if(type == ".pdf" || type == "PDF")
        {
            cell.imgAttachment.image = UIImage(named: "pdf-1")
        }
        else if(type == ".doc" || type == "DOC")
        {
            cell.imgAttachment.image = UIImage(named: "word")
        }
        else if(imageFormatsArray.contains(type))
        {
            cell.imgAttachment.image = UIImage(named: "img")
        }
        else
        {
            cell.imgAttachment.image = UIImage(named: "xlsfile")
        }
    }
    
    //MARK:- Show More Tapped
    @objc func showMoreText(sender:UIButton)
    {
        selectedRow = sender.tag
        let index = IndexPath(row: sender.tag, section: 0)

        //self.m_queryTableView.reloadData()
        self.m_queryTableView.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)

        /*
        let queryDict :NSDictionary = (m_queriesArray[sender.tag] as? NSDictionary)!

        let index = IndexPath(row: sender.tag, section: 0)
        let cell : MessageViewCell = m_queryTableView.cellForRow(at: index) as! MessageViewCell
        var queryText1 = queryDict.value(forKey: "Query") as? String

        if(queryText1!.count>100)
        {
                cell.msgLabel.numberOfLines = 0
                cell.moreTextButton.isHidden = true
                cell.heightMoewText.constant = 0
                cell.msgLabel.text=queryText1!
        }
            else {
                cell.msgLabel.numberOfLines = 4
                cell.moreTextButton.isHidden = false
                cell.moreTextButton.tag = index.row
                cell.moreTextButton.addTarget(self, action: #selector(showMoreText(sender:)), for: .touchUpInside)
                cell.heightMoewText.constant = 14
            }
        */
        
        
        
    }
    
    //MARK:- Show More Document
    @objc func moreDocsTapped(sender:UIButton) {
        print("Inside: moreDocsTapped")
    let vc : ShowDocumentsVC = UIStoryboard.init(name: "Insurance", bundle: nil).instantiateViewController(withIdentifier:"ShowDocumentsVC") as! ShowDocumentsVC
        
        let queryDict :NSDictionary = (m_queriesArray[sender.tag] as? NSDictionary)!
        let attachmentArray : [NSDictionary] = queryDict.value(forKey: "Attachments") as! [NSDictionary]
        vc.docsArray = attachmentArray
    
    self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Open Single Document
    @objc func openSingleDocument(sender:UITapGestureRecognizer) {
        
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)

        let queryDict :NSDictionary = (m_queriesArray[indexpath.row] as? NSDictionary)!
        let attachmentArray : [NSDictionary] = queryDict.value(forKey: "Attachments") as! [NSDictionary]
   
        print("queryDict: ",queryDict)
        print("attachmentArray: ",attachmentArray)
        
            if let dict : NSDictionary = attachmentArray[0] as? NSDictionary
            {
                guard let fileNameUrl = dict.value(forKey: "FileName") as? String else { return  }
                let fileType=dict.value(forKey: "FileType") as? String
                
                if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
                {
                    print("Image")

                    downloadImageFromServer(url: fileNameUrl)
                    //let indexpath = IndexPath(row: 0, section: 0)
                    //let cell:ViewQueryTableViewCell =  ViewQueryTableViewCell()
                  //  downloadImage(url: fileNameUrl,cell:cell)
                }
                else
                {
                    print("fileNameUrl: ",fileNameUrl)
                    openSelectedDocument(fileUrl: fileNameUrl)
                }
                
            }
        }
    
    func openSelectedDocument(fileUrl:String?) {
        if let fileName = fileUrl
        {
            showPleaseWait(msg: "Please wait...")
            
            //                DispatchQueue.main.async
            //                    {
            
            //var convertedFileName = fileName.replace(string: "https://grouphealth.staypinc.com/", replacement: "http://15.206.179.89:90/")
            
            var convertedFileName = fileName
            
            let url : NSString = convertedFileName as! NSString
            print("openSelectedDocument url : ",url)
            
            if let stringUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            {
                let urlStr : NSString = stringUrl as NSString
                
                if let searchURL : NSURL = NSURL(string: urlStr as String)
                {
                    let request = URLRequest(url: searchURL as URL)
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    
                    let task = session.dataTask(with: request, completionHandler:
                    {(data, response, error) -> Void in
                        
                        do
                        {
                            
                            let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                            
                            if var fileName = searchURL.lastPathComponent
                            {
                                //added by Pranit
                                //fileName=fileName.replacingOccurrences(of: "_GMC", with: "")
                                
                                
                                let destinationUrl = documentsUrl.appendingPathComponent(fileName)
                                let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
                                if let data = data
                                {
                                    
                                    if(destinationUrl != nil)
                                    {
                                        
                                        //Added By Pranit - to write file
                                        try data.write(to: destinationUrl!, options: .atomic)
                                        
                                        
                                        try self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
                                        
                                        //                                            try data.write(to: destinationUrl!, options: .atomic)
                                        
                                        
                                        //                                            documentController = UIDocumentInteractionController(url: destinationUrl!)
                                    }
                                    //                                        self.showAlert(message: "destinationUrl:\(destinationUrl)")
                                }
                                else
                                {
                                    self.hidePleaseWait()
                                    self.isConnectedToNetWithAlert()
                                }
                            }
                        }
                        catch
                        {
                            // Crashlytics.sharedInstance().recordError(m_errorMsg as! Error)
                            print(error)
                            self.hidePleaseWait()
                        }
                        
                        self.hidePleaseWait()
                    })
                    task.resume()
                    
                }
                else
                {
                    self.hidePleaseWait()
                    self.displayActivityAlert(title: m_errorMsg)
                    
                }
            }
            else
            {
                self.displayActivityAlert(title: m_errorMsg)
                hidePleaseWait()
            }
            
            //                }
        }
        else
        {
            displayActivityAlert(title: m_errorMsg)
            hidePleaseWait()
        }

    }
        
    
        // MARK: - UIDocumentInteractionViewController delegate methods
        func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
            hidePleaseWait()
            
            return self
        }

    
    
    @objc func moreButton1Clicked(sender:UIButton)
    {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        
        
        if(m_attachmentArray1.count==3)
        {
            let filePath = m_attachmentArray1[2]
            cell.m_documentSubview3.isHidden=false
            cell.m_documentSubview3.layer.masksToBounds=true
            cell.m_documentSubview3.layer.cornerRadius=6
            let fileName = (filePath as! NSString).lastPathComponent
            let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
            cell.documentLbl3.text=fileNameArr[fileNameArr.count-1]
            cell.documentLbl3.tag=indexpath.row
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument3 (_:)))
            cell.documentLbl3.addGestureRecognizer(gesture)
        }
        else if(m_attachmentArray1.count==4)
        {
            let filePath = m_attachmentArray1[3]
            cell.m_documentSubview4.isHidden=false
            cell.m_documentSubview4.layer.masksToBounds=true
            cell.m_documentSubview4.layer.cornerRadius=6
            let fileName = (filePath as! NSString).lastPathComponent
            let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
            cell.documentLbl4.text=fileNameArr[fileNameArr.count-1]
            cell.documentLbl4.tag=indexpath.row
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument4 (_:)))
            cell.documentLbl4.addGestureRecognizer(gesture)
            
            cell.m_documentView1HeightConstraint.constant=70
            cell.m_documentView4Height.constant=30
            cell.m_documentView5Height.constant=0
        }
        else if(m_attachmentArray1.count==5)
        {
            let filePath = m_attachmentArray1[4]
            cell.m_documentSubview5.isHidden=false
            cell.m_documentSubview5.layer.masksToBounds=true
            cell.m_documentSubview5.layer.cornerRadius=6
            let fileName = (filePath as! NSString).lastPathComponent
            let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
            cell.documentLbl5.text=fileNameArr[fileNameArr.count-1]
            cell.documentLbl5.tag=indexpath.row
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument5 (_:)))
            
            cell.documentLbl5.addGestureRecognizer(gesture)
            cell.m_documentView5Height.constant=30
        }
    }
    @objc func moreButton2Clicked(sender:UIButton)
    {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        
        
        if(m_attachmentArray2.count==3)
        {
            let filePath = m_attachmentArray2[2]
            cell.m_document2Subview3.isHidden=false
            cell.m_document2Subview3.layer.masksToBounds=true
            cell.m_document2Subview3.layer.cornerRadius=6
            let fileName = (filePath as! NSString).lastPathComponent
            let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
            cell.m_document2Lbl3.text=fileNameArr[fileNameArr.count-1]
            cell.m_document2Lbl3.tag=indexpath.row
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument23 (_:)))
            cell.m_document2Lbl3.addGestureRecognizer(gesture)
            cell.m_document3View1Height.constant=30
        }
        else if(m_attachmentArray2.count==4)
        {
            let filePath = m_attachmentArray2[3]
            cell.m_document2Subview4.isHidden=false
            cell.m_document2Subview4.layer.masksToBounds=true
            cell.m_document2Subview4.layer.cornerRadius=6
            let fileName = (filePath as! NSString).lastPathComponent
            let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
            cell.m_document2Lbl4.text=fileNameArr[fileNameArr.count-1]
            cell.m_document2Lbl3.tag=indexpath.row
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument24 (_:)))
            cell.m_document2Lbl3.addGestureRecognizer(gesture)
            cell.m_document2View4Height.constant=30
            cell.m_documentView2HeightConstraint.constant=70
        }
        else if(m_attachmentArray2.count==5)
        {
            let filePath = m_attachmentArray2[4]
            cell.m_document2Subview5.isHidden=false
            cell.m_document2Subview5.layer.masksToBounds=true
            cell.m_document2Subview5.layer.cornerRadius=6
            let fileName = (filePath as! NSString).lastPathComponent
            let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
            cell.m_document2Lbl5.text=fileNameArr[fileNameArr.count-1]
            cell.m_document2Lbl5.tag=indexpath.row
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument25 (_:)))
            cell.m_document2Lbl5.addGestureRecognizer(gesture)
            
            cell.m_document2View5Height.constant=30
        }
    }
    @objc func moreButton3Clicked(sender:UIButton)
    {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        
        
        if(m_attachmentArray3.count==3)
        {
            let filePath = m_attachmentArray3[2]
            cell.m_document3Subview3.isHidden=false
            cell.m_document3Subview3.layer.masksToBounds=true
            cell.m_document3Subview3.layer.cornerRadius=6
            let fileName = (filePath as! NSString).lastPathComponent
            let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
            cell.m_document3Lbl3.text=fileNameArr[fileNameArr.count-1]
            cell.m_document3Lbl3.tag=indexpath.row
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument33 (_:)))
            cell.m_document3Lbl3.addGestureRecognizer(gesture)
            cell.m_document3View3Height.constant=30
        }
        else if(m_attachmentArray3.count==4)
        {
            let filePath = m_attachmentArray3[3]
            cell.m_document3Subview4.isHidden=false
            cell.m_document3Subview4.layer.masksToBounds=true
            cell.m_document3Subview4.layer.cornerRadius=6
            let fileName = (filePath as! NSString).lastPathComponent
            let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
            cell.m_document3Lbl4.text=fileNameArr[fileNameArr.count-1]
            cell.m_document3Lbl4.tag=indexpath.row
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument34 (_:)))
            cell.m_document3Lbl4.addGestureRecognizer(gesture)
            cell.m_documentView3HeightConstraint.constant=70
            cell.m_document3View4Height.constant=30
        }
        else if(m_attachmentArray3.count==5)
        {
            let filePath = m_attachmentArray3[4]
            cell.m_document3Subview5.isHidden=false
            cell.m_document3Subview5.layer.masksToBounds=true
            cell.m_document3Subview5.layer.cornerRadius=6
            let fileName = (filePath as! NSString).lastPathComponent
            let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
            cell.m_document3Lbl5.text=fileNameArr[fileNameArr.count-1]
            cell.m_document3Lbl5.tag=indexpath.row
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.openDocument35 (_:)))
            cell.m_document3Lbl5.addGestureRecognizer(gesture)
            cell.m_document3View5Height.constant=30
        }
    }
    @objc func openDocument1(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        print(m_attachmentArray1)
        let url=m_attachmentArray1[indexpath.row]
        let fileType=m_attachmentTypeArray1[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image = downloadImage(url: url,cell:cell)
            
            
            
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument2(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray1[indexpath.row]
        let fileType=m_attachmentTypeArray1[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
            
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument3(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray1[indexpath.row]
        let fileType=m_attachmentTypeArray1[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument4(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray1[indexpath.row]
        let fileType=m_attachmentTypeArray1[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
            
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument5(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray1[indexpath.row]
        let fileType=m_attachmentTypeArray1[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
           
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    
    @objc func openDocument21(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray2[indexpath.row]
        let fileType=m_attachmentTypeArray2[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
          
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument22(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray2[indexpath.row]
        let fileType=m_attachmentTypeArray2[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
           
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument23(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray2[indexpath.row]
        let fileType=m_attachmentTypeArray2[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
         
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument24(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray2[indexpath.row]
        let fileType=m_attachmentTypeArray2[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
         
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument25(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray2[indexpath.row]
        let fileType=m_attachmentTypeArray2[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
         
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument31(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray3[indexpath.row]
        let fileType=m_attachmentTypeArray3[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
          
            
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument32(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray3[indexpath.row]
        let fileType=m_attachmentTypeArray3[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
           
            
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument33(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray3[indexpath.row]
        let fileType=m_attachmentTypeArray3[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
          
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument34(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray3[indexpath.row]
        let fileType=m_attachmentTypeArray3[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
          
            
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    @objc func openDocument35(_ sender:UITapGestureRecognizer)
    {
        let indexpath = IndexPath(row: sender.view!.tag, section: 0)
        let cell:ViewQueryTableViewCell = m_queryTableView.cellForRow(at: indexpath) as! ViewQueryTableViewCell
        let url=m_attachmentArray3[indexpath.row]
        let fileType=m_attachmentTypeArray3[indexpath.row]
        if(fileType==".png" || fileType==".jpg" || fileType==".jpeg")
        {
            let image =  downloadImage(url: url,cell:cell)
           
        }
        else
        {
            openDocuments(url:url)
        }
        
    }
    //MARK:- Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //return 100
       return UITableViewAutomaticDimension
    }
    
    //MARK:- Download Image
    func downloadImageFromServer(url:String) {
        
        
        //Used for local
        //var stringurl = url.replace(string: "https://grouphealth.staypinc.com/", replacement: "http://15.206.179.89:90/")
        var stringurl = url
        stringurl = stringurl.replacingOccurrences(of: "\\", with: "/")
        print("downloadImageFromServer Url: ",stringurl)
        if let url1 = URL(string: stringurl) {
        let data = try? Data(contentsOf: url1)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            self.m_openImageView.image=image
            self.m_openImageView.isHidden=false
            self.m_openImagesuperView.isHidden=false
            
        }
        else {
            print("No Data Image 1")
            self.displayActivityAlert(title: "Image not found")
            }
        } //url
        else {
            print("No Data Image 1")
            self.displayActivityAlert(title: "Image not found")
        }
    }
    
    func downloadImage(url:String,cell:ViewQueryTableViewCell)->UIImage
    {
        var pictureURL : URL?
        let stringurl = url.replacingOccurrences(of: "\\", with: "/")
        pictureURL = URL(string: stringurl)
        print(pictureURL)
        
       // var downloadedImage = UIImage()

        let session = URLSession(configuration: .default)
      
        let downloadPicTask = session.dataTask(with: pictureURL!) { (data, response, error) in

            if let e = error
            {
                print("Error downloading cat picture: \(e)")
                self.displayActivityAlert(title: "Image not found")
            }
            else
            {
                
                if let res = response as? HTTPURLResponse
                {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if data != nil
                    {
                        if let downloadedImage:UIImage = UIImage(data: data as! Data){
                      // DispatchQueue.main.async
                       // {
                            print("Downloaded...")
                            self.m_openImageView.image=downloadedImage
                            self.m_openImageView.isHidden=false
                            self.m_openImagesuperView.isHidden=false
                       // }
                        
//                       return downloadedImage
                    }
                        else{
                            print("No Data Image 1")
                            self.displayActivityAlert(title: "Image not found")

                        }
                    }
                    else
                    {
                        print("Empty Image 2")
                        self.displayActivityAlert(title: "Image not found")
                    }
                }
                else
                {
                    print("Image not found 3")
                    self.displayActivityAlert(title: "Image not found")
                }
            }
        }
        
        downloadPicTask.resume()
        return UIImage(named: "outstanding")!
        
    }
    @IBAction func closeImageButtonClicked(_ sender: Any)
    {
        m_openImageView.isHidden=true
        m_openImagesuperView.isHidden=true
    }
    
    //MARK:- Download Documents
    func openDocuments(url:String)
    {
        
        showPleaseWait(msg: "Please wait...")
        
        let stringUrl = url.replacingOccurrences(of: "\\", with: "/")
        
        
            let urlStr : String = stringUrl as String
            
            if let searchURL : NSURL = NSURL(string: urlStr)
            {
                let request = URLRequest(url: searchURL as URL)
                let session = URLSession(configuration: URLSessionConfiguration.default)
                
                let task = session.dataTask(with: request, completionHandler:
                {(data, response, error) -> Void in
                    
                    do
                    {
                        
                        let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                        
                        if let fileName = searchURL.lastPathComponent
                        {
                            
                            let destinationUrl = documentsUrl.appendingPathComponent(fileName)
                            let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
                            if data != nil
                            {
                                
                                if(destinationUrl != nil)
                                {
                                    try self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
                                    
                                    
                                }
                                
                            }
                            else
                            {
                                self.hidePleaseWait()
                                self.isConnectedToNetWithAlert()
                            }
                        }
                    }
                    catch
                    {
                        Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                        print(error)
                        self.hidePleaseWait()
                    }
                    
                    self.hidePleaseWait()
                })
                task.resume()
                
            }
            else
            {
                self.hidePleaseWait()
                self.displayActivityAlert(title: m_errorMsg)
                
            }
        
        
    }
    func showTheDocumentsImage(url:String)->UIImage
    {
        var mainImage = UIImage()
        let catPictureURL = URL(string: url)!
        
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: catPictureURL)
        { (data, response, error) in
            // The download has finished.
            if let e = error
            {
                print("Error downloading cat picture: \(e)")
            }
            else
            {
                
                if let res = response as? HTTPURLResponse
                {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data
                    {
                        
                        mainImage = UIImage(data: imageData)!
                        
                    }
                    else
                    {
                        print("Couldn't get image: Image is nil")
                    }
                }
                else
                {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
        if(mainImage != nil)
        {
            return mainImage
        }
        return UIImage(named: "")!
    }
    func openSelectedDocumentFromURL(documentURLString: String) throws {
        DispatchQueue.main.async()
            {
                //code
                print("documentURLString: ",documentURLString)
                if let documentURL: NSURL? = NSURL(fileURLWithPath: documentURLString)
                {
                    UINavigationBar.appearance().barTintColor = self.hexStringToUIColor(hex: hightlightColor)
                    UINavigationBar.appearance().tintColor = self.hexStringToUIColor(hex: hightlightColor)
                    UINavigationBar.appearance().backgroundColor = self.hexStringToUIColor(hex: hightlightColor)
                    UINavigationBar.appearance().titleTextAttributes = [
                        NSAttributedString.Key.foregroundColor: FontsConstant.shared.app_FontPrimaryColor
                    ]
                    documentController.delegate = self

                    documentController = UIDocumentInteractionController(url: documentURL! as URL)
                    documentController.delegate = self
                    documentController.presentPreview(animated: true)
                    self.hidePleaseWait()
                }
                
        }
        
    }
    
    
    // MARK: - UIDocumentInteractionViewController delegate methods
    
     func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController
    {
        hidePleaseWait()

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
                    displayActivityAlert(title: "This File exceeds the maximum upload size")
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
                        if m_filesArray.contains(m_selectedFileName){
                            displayActivityAlert(title: "File already attached")
                        }else{
                            m_filesArray.append(m_selectedFileName)
                            m_attachedDocumentsArray.append(m_fileUrl)
                            displaySelectedFiles()
                        }
                       
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
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController)
    {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
        
    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if(textView.text=="Enter your reply here")
        {
            textView.text=""
            
        }
        textView.textColor=UIColor.black
        scrollToTop()
        animateTextView(textView, with: true)
    }
    func scrollToTop()
    {
        if(m_queriesArray.count>0)
        {
            let indexpath = IndexPath(row: 0, section: 0)
            m_queryTableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
        }
        
    }
    
    func scrollToBottom()
       {
           if(m_queriesArray.count>0)
           {
               // First figure out how many sections there are
               let lastSectionIndex = self.m_queryTableView!.numberOfSections - 1
    
               // Then grab the number of rows in the last section
               let lastRowIndex = self.m_queryTableView!.numberOfRows(inSection: lastSectionIndex) - 1
    
               // Now just construct the index path
               let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
    
               // Make the last row visible
               self.m_queryTableView?.scrollToRow(at: pathToLastRow as IndexPath, at: UITableViewScrollPosition.bottom , animated: true)
           }
           
       }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        view.endEditing(true)
        animateTextView(textView, with: false)
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text=="\n")
        {
            view.endEditing(true)
        }
        if(text=="")
        {
            
        }
        
        return true
    }
    func animateTextView(_ textVeiw:UITextView, with up: Bool)
    {
        var movementDistance=0
        let movementDuration=0.3
        movementDistance=300;
        
        
        let movement = (up ? -movementDistance : movementDistance);
            
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame=self.view.frame.offsetBy(dx: 0, dy: 0)
        self.m_TicketNoView.frame = self.m_TicketNoView.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        self.m_bottomView.frame = self.m_bottomView.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
             textField.resignFirstResponder() // dismiss keyboard
             return true
         }
}


