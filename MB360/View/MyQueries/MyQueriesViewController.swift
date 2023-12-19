//
//  MyQueriesViewController.swift
//  MyBenefits
//
//  Created by Semantic on 30/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseCrashlytics
import TrustKit
import AesEverywhere

class MyQueriesViewController: UIViewController,UITextViewDelegate,XMLParserDelegate,UINavigationControllerDelegate {
    
    
    
    var documentController: UIDocumentInteractionController = UIDocumentInteractionController()
    
    @IBOutlet weak var m_selectButton: UIButton!
    
    @IBOutlet weak var m_textField: UITextField!
    
    @IBOutlet weak var m_tableView: UITableView!
    @IBOutlet weak var m_topbar: UIView!
    @IBOutlet weak var m_GPATab: UIButton!
    @IBOutlet weak var m_GMCTab: UIButton!
    
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
    
    @IBOutlet weak var m_noInternetView: UIView!
    @IBOutlet weak var m_errorImageView: UIImageView!
    
    @IBOutlet weak var m_errorMsgDetailLbl: UILabel!
    @IBOutlet weak var m_errorMsgTitleLbl: UILabel!
    
    @IBOutlet weak var m_addQueryButton: UIButton!
    @IBOutlet weak var m_myQueryTableView: UITableView!
    
    
    @IBOutlet weak var header_Lbl: UILabel!
    @IBOutlet weak var header1_Lbl: UILabel!
    @IBOutlet weak var header2_Lbl: UILabel!
    @IBOutlet weak var header3_Lbl: UILabel!
    
    
    var reuseIdentifier = "cell"
    var datasource = [ExpandedCell]()
    var selectedRowIndex = -1
    
    
    @IBOutlet weak var m_emptyStateView: UIView!
    var productCode = String()
    var m_employeedict : EMPLOYEE_INFORMATION?
    var xmlKey = String()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    
    
    var m_membersArray = Array<String>()
    var m_questionArray = Array<String>()
    var m_answersArray = Array<String>()
    var isFromSideBar = Bool()
    let dateDropDown=DropDown()
    var m_querisArray=Array<Queries>()
    var m_uploadingImage = UIImage()
    var m_fileUploadData = Data()
    var m_selectedFileName = String()
    var m_filesArray = Array<String>()
    var m_attachedDocumentsArray = Array<Any>()
    var m_fileUrl: URL?
    var m_documentLblArray = Array<UILabel>()
    
    var m_querisArrayNew: [[String: Any]] = []
    
    var documentPicker = UIDocumentPickerViewController(documentTypes: ["public.composite-content"], in: .import)
    
    override func viewDidLoad() {
        menuButton.isHidden = true
        //menuButtonF.isHidden = true

        super.viewDidLoad()
        self.setupFontUI()
        m_emptyStateView.isHidden=true
        
        userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
        userOegrpNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String ?? ""
        userEmployeeSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String ?? ""
        
        m_myQueryTableView.register(TableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let nib = UINib (nibName: "TableViewCell", bundle: nil)
        m_myQueryTableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        m_tableView.register(FAQTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let nib1 = UINib (nibName: "FAQTableViewCell", bundle: nil)
        m_tableView.register(nib1, forCellReuseIdentifier: reuseIdentifier)
        
        
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        m_myQueryTableView.separatorStyle=UITableViewCellSeparatorStyle.none
        m_tableView.tableFooterView=UIView()
        m_topbar.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
        
        m_addQueryButton.backgroundColor = hexStringToUIColor(hex: hightlightColor)
        //GMCTabSeleted()
        GPATabSelected((Any).self)
        
        
        navigationController?.isNavigationBarHidden=false
        navigationItem.leftBarButtonItem=getBackButton()
        //navigationItem.rightBarButtonItem=getRightBarButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        self.tabBarController?.tabBar.isHidden=true
        
        setLayout()
        
        //Before change sequence
        //self.m_membersArray=["  Select category","E-cards","Claim Intimation","Policy features and Coverage Details","Enrollment Process","How to make a cashless claim","How to make a reimbursement claim","What is pre/post Hospitalization","Dependant Addition/Correction/Deletion","Hospital Related","Contact Details","Claim Tracking","Others"]
        
        //After Change Sequence
        self.m_membersArray = ["  Select Category","E-cards","Dependant Addition/Correction/Deletion","Policy features and Coverage Details","Enrollment Process","How to make a cashless claim","How to make a reimbursement claim","What is pre/post Hospitalization","Claim Intimation","Hospital Related","Contact Details","Claim Tracking","Others"]
        
        m_textView.setBorderToView(color: hexStringToUIColor(hex: "E5E5E5"))
        m_textView.layer.masksToBounds=true
        m_textView.layer.cornerRadius=14
        m_textField.delegate=self
        m_textField.text="  Select Category"
        m_textField.layer.masksToBounds=true
        m_textField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
        m_textField.layer.borderWidth=1
        m_textField.layer.cornerRadius=25
        
        m_submitQueryButton.layer.masksToBounds=true
        m_submitQueryButton.layer.cornerRadius=m_submitQueryButton.frame.size.height/2
        
        
        self.navigationItem.title="My Queries"
        m_otherView.isHidden=true
        m_tableView.isHidden=true
        print("Inside Queries")
        
    }
    
    func setupFontUI(){
        m_GPATab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GPATab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        m_GMCTab.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h17))
        m_GMCTab.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
        
        //i_Lbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        //i_Lbl.textColor = FontsConstant.shared.app_WhiteColor
       
        header_Lbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        header_Lbl.textColor = FontsConstant.shared.app_FontAppColor
        
        header1_Lbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        header1_Lbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        header2_Lbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        header2_Lbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        header3_Lbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        header3_Lbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
//        border1.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
//        border1.textColor = FontsConstant.shared.app_FontSecondryColor
//        
//        border2.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
//        border2.textColor = FontsConstant.shared.app_FontSecondryColor
//        
//        border.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
//        border.textColor = FontsConstant.shared.app_FontSecondryColor
//        border.backgroundColor = FontsConstant.shared.app_FontSecondryColor
        
        
        
        m_textField.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_textField.textColor = FontsConstant.shared.app_FontBlackColor
               
        m_textView.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        m_textView.textColor = FontsConstant.shared.app_FontBlackColor
          
        m_submitQueryButton.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h15))
        m_submitQueryButton.titleLabel?.textColor = FontsConstant.shared.app_WhiteColor
       
        m_iLabl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
        m_iLabl.textColor = FontsConstant.shared.app_WhiteColor
        
//        instructionHeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h15))
//        instructionHeaderLbl.textColor = FontsConstant.shared.app_FontAppColor
//
//        instructionValueLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
//        instructionValueLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
//        border.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
//        border.textColor = FontsConstant.shared.app_FontSecondryColor
//        border.backgroundColor = FontsConstant.shared.app_FontSecondryColor
        
        //uploadHeaderlbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        //uploadHeaderlbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_documentName1.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_documentName1.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        m_documentName2.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_documentName2.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        m_documentName3.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_documentName3.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        m_documentName4.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_documentName4.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        m_documentName5.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_documentName5.textColor = FontsConstant.shared.app_FontBlackColor
        
        
        m_errorMsgTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h20))
        m_errorMsgTitleLbl.textColor = FontsConstant.shared.app_FontLightGreyColor
        
        m_errorMsgDetailLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h20))
        m_errorMsgDetailLbl.textColor = FontsConstant.shared.app_FontLightGreyColor
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden=false
        self.tabBarController?.tabBar.isHidden=true
        //navigationItem.rightBarButtonItem=getRightBarButton()
        //        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //        menuButton.frame = menuButton.frame
        //        menuButton.setImage(nil, for: .normal)
        //        menuButton.setBackgroundImage(nil, for: .normal)
        menuButton.isHidden=true
        DispatchQueue.main.async()
            {
                menuButton.isHidden=true
                menuButton.accessibilityElementsHidden=true
        }
        
        
        getAllQueries()
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        print(userArray)
        if userArray.count > 0{
            m_employeedict=userArray[0]
        }
        menuButton.isHidden=true
    }
    func setLayout()
    {
        m_addQueryButton.layer.masksToBounds=true
        m_addQueryButton.layer.cornerRadius=m_addQueryButton.frame.size.height/2
        m_instructionView.layer.masksToBounds=true
        m_instructionView.layer.borderWidth=1
        m_instructionView.layer.borderColor=hexStringToUIColor(hex:hightlightColor).cgColor
        m_instructionView.layer.cornerRadius=10
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
        
    }
    
    
    @IBAction func selectAttachmentButtonClicked(_ sender: Any)
    {
        /* let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePNG),String(kUTTypeXML),String(kUTTypePDF),String(kUTTypeText)], in: .import)
         importMenu.delegate = self
         importMenu.modalPresentationStyle = .formSheet
         self.present(importMenu, animated: true, completion: nil)*/
        
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func getLeftBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:UIImage(named: "menu"), style: .plain, target: self, action: #selector(leftButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func leftButtonClicked()
    {
        
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        //        tabBarController!.selectedIndex = 2
    }
    @IBAction func addQueryButtonClicked(_ sender: Any)
    {
        /* self.m_otherView.isHidden=false
         self.m_tableView.isHidden=true
         m_textField.text="Others"
         m_addQueryButton.isHidden=true*/
        
        let addQueryVC : AddNewQueryViewController = AddNewQueryViewController()
        /*
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        */
        let nvc = UINavigationController(rootViewController: addQueryVC)
        
        //        present(nvc, animated: false, completion: nil)
        navigationController?.pushViewController(addQueryVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Get All Query
    func getAllQueries()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg: "Please wait...Fetching Queries")
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            var employeesrno = String()
            if userEmployeeSrno != "" {
                if userArray.count > 0{
                    m_employeedict=userArray[0]
                }
            }
            if let empNo = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String//m_employeedict?.empSrNo
            {
                employeesrno = String(empNo)
                employeesrno = try! AES256.encrypt(input: employeesrno, passphrase: m_passphrase_Portal)
            }
            
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getQueriesUrl(empSrNo:employeesrno.URLEncoded))
            print("MyQueries url: ",urlreq)
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?
            request.httpMethod = "GET"
            
            
            var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
            var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

            let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
            print("m_authUserName_Portal ",encryptedUserName)
            print("m_authPassword_Portal ",encryptedPassword)
            
            let authData = authString.data(using: String.Encoding.utf8)!
            let base64AuthString = authData.base64EncodedString()
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
            authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
            print("authToken MyQueries:",authToken)
         
            request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
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
                    print("getAllQueries() error %@",error!)
                    
                    self.hidePleaseWait()
                    DispatchQueue.main.async{
                        self.m_myQueryTableView.isHidden=true
                        self.m_noInternetView.isHidden=false
                        self.m_errorImageView.image = UIImage(named: "error_State")
                        self.m_errorMsgTitleLbl.text=error_State
                        self.m_errorMsgDetailLbl.text=""
                    }
                }
                else
                {
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        print("response: ",response)
                        if httpResponse.statusCode == 200
                        {
                            do {
                                
                                if let data = data, let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                                {
                                    
                                    if(jsonResult.count>0)
                                    {
                                        DispatchQueue.main.async
                                            {
                                                
                                                if let message = jsonResult.value(forKey: "message")
                                                {
                                                    let dict : NSDictionary = (message as? NSDictionary)!
                                                    let status = dict.value(forKey: "Status") as! Bool
                                                    
                                                    if(status)
                                                    {
                                                        if let allQueries = jsonResult.value(forKey: "AllQueries")
                                                        {
                                                            //DatabaseManager.sharedInstance.deleteQueries()
                                                            self.m_querisArrayNew = []
                                                            let queryArray : NSArray = (allQueries as? NSArray)!
                                                            for i in 0..<queryArray.count {
                                                                if let dict = queryArray[i] as? [String: Any] {
                                                                    self.m_querisArrayNew.append(dict)
                                                                }
                                                            }
                                                            
                                                            print("Queriess array.count:::",self.m_querisArrayNew.count)
                                                            print("Queriess:::",self.m_querisArrayNew)
                                                        }
                                                        //self.m_querisArray = DatabaseManager.sharedInstance.retrieveQueries()
                                                        if(self.m_querisArrayNew.count==0)
                                                        {
                                                            self.m_myQueryTableView.isHidden=true
                                                            self.m_noInternetView.isHidden=false
                                                            self.m_errorImageView.image=UIImage(named: "noquery-1")
                                                            self.m_errorMsgTitleLbl.text="No Queries Found"
                                                            self.m_errorMsgDetailLbl.text=""
                                                        }
                                                        else
                                                        {
                                                            self.m_noInternetView.isHidden=true
                                                            self.m_myQueryTableView.reloadData()
                                                        }
                                                    }
                                                    else
                                                    {
                                                        if(self.m_querisArrayNew.count==0)
                                                        {
                                                          //  self.displayActivityAlert(title: "No queries found")
                                                            self.m_myQueryTableView.isHidden=true
                                                            self.m_noInternetView.isHidden=false
                                                            self.m_errorImageView.image=UIImage(named: "noquery-1")
                                                            self.m_errorMsgTitleLbl.text="No Queries Found"
                                                            self.m_errorMsgDetailLbl.text=""
                                                        }
                                                        else
                                                        {
                                                            self.displayActivityAlert(title: dict.value(forKey: "Message") as! String)
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                self.hidePleaseWait()
                                        }
                                        print(jsonResult.allKeys)
                                    }
                                    else
                                    {
                                        
                                        self.hidePleaseWait()
                                        
                                        
                                    }
                                    
                                }
                            } catch let JSONError as NSError
                            {
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                print(JSONError)
                                
                            }
                        }else if httpResponse.statusCode == 401 || httpResponse.statusCode == 400{
                            //self.hidePleaseWait()
                            self.getUserTokenGlobal(completion: { (data,error) in
                                self.getAllQueries()
                                self.hidePleaseWait()
                            })
                        }
                        else
                        {
                            print(httpResponse.statusCode)
                            self.hidePleaseWait()
                            //self.displayActivityAlert(title: m_errorMsg)
                            //self.m_querisArray = DatabaseManager.sharedInstance.retrieveQueries()
                            DispatchQueue.main.async{
                                if(self.m_querisArrayNew.count==0)
                                {
                                    self.m_myQueryTableView.isHidden=true
                                    self.displayActivityAlert(title: "No queries found")
                                }
                                else
                                {
                                    self.m_myQueryTableView.reloadData()
                                }
                            }
//                            self.hidePleaseWait()
//                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed 400")
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
            
            //self.displayActivityAlert(title: m_errorMsg)
            //self.m_querisArray = DatabaseManager.sharedInstance.retrieveQueries()
            DispatchQueue.main.async{
                if(self.m_querisArrayNew.count==0)
                {
                    self.m_myQueryTableView.isHidden=true
                    self.displayActivityAlert(title: "No queries found")
                }
                else
                {
                    self.m_myQueryTableView.reloadData()
                }
            }
            
        }
    }
    /* func createRequestBodyWith(parameters:[String:NSObject], filePathKey:String, boundary:String) -> Data
     {
     
     let body = NSMutableData()
     
     for (key, value) in parameters
     {
     body.appendString(string: "--\(boundary)\r\n")
     body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
     body.appendString(string: "\(value)\r\n")
     }
     let queryData = "QueryData"
     body.appendString(string: "--\(boundary)\r\n")
     body.appendString(string: "Content-Disposition: form-data; name=\"\(queryData)\"\r\n\r\n")
     body.appendString(string: "\(parameters)\r\n")
     
     
     body.appendString("--\(boundary)\r\n")
     let mimetype = "image/png"
     
     let defFileName = "activeProfile.png"
     
     let imageData = UIImageJPEGRepresentation(UIImage(named: defFileName)!, 0.5)
     
     body.appendString("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
     body.appendString("Content-Type: \(mimetype)\r\n\r\n")
     body.append(imageData!)
     body.appendString("\r\n")
     
     body.appendString("--\(boundary)\r\n")
     
     return body as Data
     }*/
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    func submitQuery()
    {
        if(m_textView.text=="Write your query here" || m_textView.text=="")
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
                                                            self.displayActivityAlert(title: """
                                                                Query submitted succesfully.
                                                                Ticket number is \(number)
                                                                """)
                                                            
                                                            self.m_textView.text="Write your query here"
                                                            self.m_textView.textColor=UIColor.lightGray
                                                            self.m_filesArray.removeAll()
                                                            self.m_attachedDocumentsArray.removeAll()
                                                            self.m_selectedFileName=""
                                                            self.m_fileUrl=nil
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
        let parameters : NSDictionary = ["Query":m_textView.text,"EmpSrNo":employeesrno.URLEncoded,"CustQuerySrNo":"","IsReply":false] // build your dictionary however appropriate
        
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
        
        let authData = authString.data(using: String.Encoding.utf8)!
        let base64AuthString = authData.base64EncodedString()
        //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
        authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
        print("authToken EmployeeQueries/PostQueries:",authToken)
     
        request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        

        print(m_fileUrl)
        
        request.httpBody = try createBody(with: parameters , filePathKey: "file", fileUrlArray: m_attachedDocumentsArray, boundary: boundary)
        
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
    
    @objc func viewQueryButtonClicked(sender:UIButton)
    {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        tableView(m_myQueryTableView, didSelectRowAt: indexpath)
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
        var image = UIImage(named: "pdf")
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
            image = UIImage(named: "excel")!
            return image!
        case "xls":
            image = UIImage(named: "excel")!
            return image!
        case "xlsx":
            image = UIImage(named: "excel")!
            return image!
        case "doc":
            image = UIImage(named: "word")!
            return image!
        case "docx":
            image = UIImage(named: "word")!
            return image!
            
        default:
            return image!
        }
        return image!
    }
    @IBAction func submitQueryButtonClicked(_ sender: Any)
    {
        submitQuery()
    }
   
    
    @objc func expandButtonClicked(sender:UIButton)
    {
        let indexPath = IndexPath(row:sender.tag, section:0)
        tableView(m_tableView, didSelectRowAt: indexPath)
    }
    @IBAction func selectButtonClicked(_ sender: Any)
    {
        //        setupDropDown(textField,at: textField.tag)
        //        dateDropDown.show()
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
    func animateTextView(_ textVeiw:UITextView, with up: Bool)
    {
        var movementDistance=0
        let movementDuration=0.3
        movementDistance=260;
        
        
        let movement = (up ? -movementDistance : movementDistance);
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame=self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
        
    }
    @IBAction func GMCTabSelected(_ sender: Any)
    {
        GMCTabSeleted()
        
        
    }
    
    @IBAction func GPATabSelected(_ sender: Any)
    {
        
        m_addQueryButton.isHidden=true
        productCode="GPA"
        
        m_GPATab.layer.masksToBounds=true
        m_GPATab.layer.cornerRadius=m_GPATab.frame.size.height/2
        //        m_GPATab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GPATab.layer.borderWidth=0
        m_GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        m_GPATab.setTitleColor(UIColor.white, for: .normal)
        
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        
        m_otherView.isHidden=true
        m_tableView.isHidden=true
        m_textField.isHidden=true
        m_selectButton.isHidden=true
        m_myQueryTableView.isHidden=false
        
        //        showPleaseWait(msg: """
        //Please wait...
        //Fetching Queries
        //""")
        
        getAllQueries()
        
        m_myQueryTableView.reloadData()
        
        //        let intimateVC :IntimateClaimViewController = IntimateClaimViewController()
        //        navigationController?.pushViewController(intimateVC, animated: true)
        
    }
    func GMCTabSeleted()
    {
        m_addQueryButton.isHidden=false
        productCode="GMC"
        
        
        m_GMCTab.layer.masksToBounds=true
        m_GMCTab.layer.cornerRadius=m_GMCTab.frame.size.height/2
        //        m_GMCTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GMCTab.layer.borderWidth=0
        m_GMCTab.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        m_GMCTab.setTitleColor(UIColor.white, for: .normal)
        
        m_GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        
        m_GPATab.layer.borderColor=UIColor.white.cgColor
        m_GPATab.setBackgroundImage(nil, for: .normal)
        
        m_otherView.isHidden=true
        m_tableView.isHidden=true
        m_textField.isHidden=false
        m_selectButton.isHidden=false
        m_myQueryTableView.isHidden=true
        m_noInternetView.isHidden = true
        
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
                //                selectButon.setTitle(item, for: .normal)
                
                //Added by Pranit - to resolve crash on MyQuery
                self.selectedRowIndex = -1
                selectButon.textColor=UIColor.black
                selectButon.text="  "+item
                self.datasource.removeAll()
                switch item {
                case "E-cards":
                    self.m_questionArray = ["Where is my E-card?","Do I get a physical card?","Why is my E-card not visible?","In how many days do I get my card?","Do I get individual or family E-card?","I can't see my family members E-card?","There is a correction in my E-card.","How do I use my E-card to make a claim?","Can I use my E-card as an Identity proof?","What is the validity of my E-card?"]
                    
                    self.m_answersArray=["Your E-card is available on the Dashboard. In the link availble at the bottom of the page, next to contact."," Yes. If your Employer insists on physical card then the same is couriered to your Corporate Address. Alternatively you can use a print-out of the E-card.","This happens when either your Enrollment Window is still open or your data is under process at the Insurance Company.","E-cards are visible within 7-10 Working Days on Benefits You India Portal from receipt of your Enrollment Details through HR or your Window Period Closure. The physical cards are dispatched to your HR, within 10-15 days from the receipt of enrollment details.","Yes. You get individual e-card for all the members who are enrolled in the policy.","Either you have not provided your family members details to your HR for enrollment in the policy OR you have not added them on Benefits You India Portal during Enrollment Window period.","For any correction in your E-card, you are requested to provide correct details to your Account manager/HR alongwith necessary copy of identity proof (e.g. Copy of Aadhaar Card or Pan Card or Driving License or Election Card or Passport or Marriage Certificate in case of newly married spouse)","Your E-card is an identification card only, and can be used excusilvely for Cashless claims. Claimant will have to produce a government authorised identity proof along with the E-card at the Admission Counter / TPA Desk at Network Hospital during cashless claims process. For Reimbursment claims, attach a copy of the E-card along with the Claim Documents during submission.","No. Your E-card cannot be used as an Identity proof because it does not carry any photo on it. Hence a Government Authorised photo identity proof should be produced alongwith your E-card (viz. Aadhaar Card, Pan Card, Driving License, Election Card, Passport Copy etc.)","The validity of your E-card is till the expiry of policy OR your date of leaving the organisation, whichever is earlier."]
                    break
                case "Claim Intimation":
                    self.m_questionArray=["How to intimate claim?","What is the claim intimation clause?","What is claim intimation?","Why claim intimation is necessary?"]
                    self.m_answersArray=["Claim can be intimated by filling up the Claim Intimation form under the Intimate Claim link on Benefits You India.","Claim Intimation simply means intimating the TPA or the Insurance Company that a claim is going to be made in the near future. Some of the policies indicate a time frame of 24 hours or 7 days from the date of admission, most of the policies require that intimation has to be lodged immediately on admission. Non-compliance to this may make your claim inadmissible.","Claim Intimation means informing about any hospitalization of insured person to the respective TPA. The same can be intimated to the TPA in writing by letter, e-mail, fax or on telephonic call providing all relevant information relating to claim which includes plan of treatment, health id card number, policy number, duration etc. within the prescribed time limit.","Claim Intimation is necessary because timely claim intimation helps in smooth & faster disposal of claim. It is important from an Insurance Company perspective, as they have to record the loss of any claim in advance to maintain their book of accounts."]
                    break
                case "Policy features and Coverage Details":
                    self.m_questionArray=["What are my policy features and coverage details?","What expenses are not covered under my policy?","What are Daycare procedures?","What are co-payment deductions?"]
                    self.m_answersArray=["Your Policy Terms and Coverage details are available in the Policy Features and My Coverages links in your Employee Login on Benefits You India App.","List of Expenses not covered in your policy are available in the Utilities tab under the heading Non-Payable expenses.","Due to advancement in medical technologies, certain treatments do not require 24 hours hospitalizations. These are called Day-Care Procedures. Comprehensive list of the same is available in the Utilities tab under the heading Day-Care Procedures.","Certain ailments in your policy might carry a percentage of expenses that have to be borne by the claimant incase of a claim. These are called co-payment deductions. List of ailments which carry co-payments if any are mentioned in your Policy Features."]
                    break
                case "Enrollment Process":
                    self.m_questionArray=["What is enrollment?(online-offline)","What is window period?","My window period is over.","Why can't I add my dependants?","What are life events?"]
                    
                    let enrollmentDetailString="""
There is two types of Enrollment Process viz. 1]Online Enrollment & 2] Offline Enrollment
ONLINE ENROLLMENT
Step 1:  Employee's Enrollment Data provided by the HR is uploaded in Benefits You India Portal.
Step 2:  Welcome Emailers are sent to all Employees on their registered/official email Id's explaining Login and Data updation process.
Step 3:  Employee's are required to complete enrollment of dependants and opting for additional benefits within the Window Period mentioned in the Welcome Mail.
Step 4: On Closure of the Window Period employee & dependant data is extracted from the portal and sent to Insurance company for the policy preparation / endorsments.
Step 5: E-cards will available in the portal within 7 days from enrollment completion.
OFFLINE ENROLLMENT
Step 1:  Employee's Enrollment Data provided by the HR is uploaded in Benefits You India Portal.
Step 2: Welcome Emailers are sent to all Employees on their registered/official email Id's explaining Login process.
Step 3: The data is sent to Insurance company for the policy preparation / endorsments.
Step 4: E-cards will available in the portal within 7 days from receipt of policy / endorsements from the insurance company.
"""
                    
                    self.m_answersArray=[enrollmentDetailString,"The Window Period is a duration of time given to the Employee to login to Benefits You India Portal and add/modify/delete their dependant information, as per policy terms & conditions. This maximum period alloted for this is 15 days but it may vary for each Employer Group. Refer the welcome mail received from Benefits You India for ou excat Window Period.","The Window Period is a duration of time given to the Employee to login to Benefits You India Portal and add/modify/delete  their dependant information, as per policy terms & conditions. This maximum period alloted for this is 15 days but it may  vary for each Employer Group. Refer the welcome mail received from Benefits You India for your exact Window Period. Your  Window Period closes after this stipulated time and you will not be able enroll dependants for Insurance Cover. In such an event contact your HR for futher guidance.","It means your  Window Period has closed and you have not enrolled dependants in the stipulated time. In such an event contact your HR for futher guidance.","Life Events refers to 'Mid-term inclusions of new born baby and spouse on account of marriage.' You are required to update the same on the Benefits You India portal within 15 days of the event and also intimate the HR about the same."]
                    break
                case "How to make a cashless claim":
                    self.m_questionArray=["How to make a cashless claim?","Which hospitals can I avail cashless facility?","How long does it take to process a cashless claim?","Do I need to pay security deposit at hospital?","Do I need to pay anything at discharge?","How do I know the status of cashless claim?","Who do I contact in case of emergency?","My cashless is denied."]
                    let cashlessProcessString = """
In order to avail the cashless claim facility, the insured has to be treated in a Network hospital. List of Network Hospitals can be found of Benefits You India App under the Network Hosptials link. By providing the details of the health insurance policy and presenting the e-card or other physical proof of the health insurance taken in the name of the policyholder, he or she can avail cashless hospitalization and treatment, if the illness/ injury is covered under the policy.
Claimant needs to contact the TPA cell or cashless counter of the hospital and obtain the Cashless Hospitalization Form, fill it up and get it duly signed by the Hospital doctor / authority with estimated cost and details of line of treatment to be given. The responsibility of forwarding the cashless request to TPA lies with the Hospital. Informatively, the hospital would Fax or email the same to TPA for approval of pre- authorization.
In case of planned Hospitalization, cashless request may be submitted by the hospital at least 24 hrs in advance.
In case of emergency hospitalization, the patient may be admitted in the hospital and cashless hospitalization request may be sent within 24 Hours of such admission. The TPA is obliged to issue the pre-authorization within 24 hours in case of planned hospitalization and 2 hours in case of emergency hospitalizations. The authorized amount may vary from 80% to 100% of the estimate subject to overall entitlement. In the event of furnishing of insufficient information related to treatment by hospital, Cashless authorization may be delayed.
Please refer the Claim Procedures Link on Benefits You India App for detailed information.
"""
                    
                    let processString = """
You may notice that even with the cashless service, there are some expenses that you will have to bear as  these expenses are not covered in your Health Insurance Policy. These expenses are listed below:
a.] Registration or Admission fee
b.] Visitors / Attendantís fee
c.] Charges for diet
d.] Ambulance charges
e.] Toiletries
f.] Document charges
g.] Service charge
h.] Expenses for diapers, oxygen masks, nebulizers which are considered under medicines category and Co-payment deductions
"""
                    let deniedString = """
A cashless request is denied by the TPA, based on various reasons, some of the common reasons are as below:
a.] The ailment / disease for which claimant is hospitalised is not covered under your insurance policy.
b.] Your Sum Insured is exhausted, due to settlement of previous claims.
c.] The current hospitalization is purely for investigations and the TPA is not able to justify the same with the information provided by the network hospital.
ï Denial of "Cashless Service" is not denial of treatment. You can continue with the treatment, pay for the services to the hospital, and later send the claim for processing on reimbursement basis.
"""
                    self.m_answersArray=[cashlessProcessString,"Cashless hospitalizations facility can be availed in any of the Network Hospitals empanelled with your TPA. List of Network Hospitals can be found of Benefits You India portal under the Network Hosptials link.","The TPA sanctions the initial cashless amount within 4-5 hours of cashless request from the hospital.","In India, hospitals may charge deposits from customers before they are admitted. While in normal circumstances, customers are not required to pay any cash, if they have taken a cashless policy, it has been observed that some hospitals ask such customers to pay a flat deposit. This deposit amount charged by hospitals depends on the type of surgery and the choice of hospitalization made. This deposit is generally taken for expenses not covered in the policy.",processString,"On receipt of the cashless request by the TPA from the Hopital and subsequent processing of the same, the Employee will receive automated SMS and email of the same on their registered mobile number and email id from Benefits You India at all stages of claim process and settlement. Real time status of the claim is also available on Benefits You India under the Claim Status link.","Emergency Contact details are mentioned under the link Contact Details in your Benefits You India login.",deniedString]
                    break
                case "How to make a reimbursement claim":
                    let claimProcedure = """
In the event that an insured is hospitalized in any hospital / nursing home (within India) as defined in the policy and pays the treatment expenses at the time of discharge, he / she needs to file a claim with the TPA for the amount due under the policy. The following documents in original should be submitted to the TPA within seven days from the date of Discharge from the Hospital:
a.] Claim Form duly filled and signed by the claimant
b.] Discharge Certificate from the hospital
c.] All documents pertaining to the illness starting from the date it was first detected i.e. Doctor's consultation reports/history
d.] Bills, Receipts, Cash Memos from hospital supported by proper prescription
e.] Receipt and diagnostic test report supported by a note from the attending medical practitioner/surgeon justifying such diagnostics.
f.] Surgeon's certificate stating the nature of the operation performed and surgeon's bill and receipt.
g.]Attending doctor's / consultant's / specialist's / anesthetist's bill and receipt, and certificate regarding diagnosis.
h.] Details of previous policies if the details are not already with TPA or any other information needed by the TPA for considering the claim.
Please refer the Claim Procedures Link on Benefits You India Portal for detailed information.
"""
                    let claimClosedString = """
Your claim is closed because of non compliance of required claim documents within the stipulated time limit given by the TPA / Insurance Company.
ï If you have the required documents, you can submit the same to the TPA. TPA will represent the claim Insurance Company for the "Reopening Approval of the Claim".
ï The Insurance Company will review the claim on its merits and decide on the further course of action. If the claim is deemed fit to processing, the Insurance Company instruct the TPA to process the claim as per th policy terms.
"""
                    self.m_questionArray=["How to file reimbursement claim?","What is the timeline for reimbursement claim submission?","What is the timeline for reimbursement claim settlement?","What is document deficiency?","How document deficiency is intimated?","What is a timeline to clear document deficiency?","What are the non-payable expenses?","How do I know the status of reimbursement claim?","My claim is partially paid.","What to do if my claim is rejected?","My claim is closed. What to do now?"]
                    self.m_answersArray=[claimProcedure,"Intimation of Reimbursement Claim has to be made within 72 hours of admission (intimation can also be made in advance in case of Planned Hopitalisation).Post Discharge, duly filled claim form along with the claim documents should be submitted within 15 days from date of discharge.","15 working days from date of submission of complete documents.","On Submission of your claim file is any documents required for processing the claim are missing, they are termed as Deficient Documents. In such a case, the claimant is required to submit these documents immediately to avoid delay in claim settlement.","Document deficiency is intimated through E-mail & SMS on claimants official email id & mobile number, within 7 working days from the receipt of claim documents by the TPA.","Deficient documents should be submitted within 7-10 working days from the date of receipt of email or sms by claimant stating document deficiency.","Your health insurance pays for reasonable and necessary medical expenditure as defined in the Policy. There are several items billed during hospitalization by some hospitals but not admissible under an insurance contract. These items will not be payable and expenditure towards such items will have to be borne by the claimant. List of Expenses not covered in your policy are available in the Utilities tab under the heading Non-Payable expenses.","On receipt of the Claim File by the TPA and subsequent processing of the same, the Employee will receive automated SMS and email of the same on their registered mobile number and email id from Benefits You India at all stages of claim process and settlement. Real time status of the claim is also available on Benefits You India under the Claim Status link.","If your claim is partially paid, that means the claim documents submitted by you are incomplete OR not submitted by you OR some documents submitted does not pertain to current hospitalization.","Your claim can be rejected, if it is not covered under the Policy terms or you have not submitted complete claim documents . In case, you are not satisfied by the reasons for rejection, you can represent the same to the TPA / Insurance Company with a copy to your HR and Benefits You India Operation Team, within 15 days of such rejection.","If you do not receive a response to your representation or if you are not satisfied with the response, you may write to Insurance Company's Grievance Cell and/or you may also call the Call Centre of Insurance Company.You also have the right to represent your case to the Insurance Ombudsman. The contact details of the office of the Insurance Ombudsman can be obtained from www.irda.gov.in",claimClosedString]
                    break
                case "What is pre/post Hospitalization":
                    self.m_questionArray=["What is pre/post hospitalization?","What expenses are covered in pre/post hospitalization?","What are the timelines for pre/post hospitalization claim submission?"]
                    self.m_answersArray=["Pre Hospitalization: Relevant medical expenses related to the treatment of the disease incurred before hospitalization for a period of 30 (THIRTY) days prior to the date of Hospitalization are payable.Post Hospitalization: Relevant medical expenses related to the treatment of the disease incurred after Discharge from the Hospital for a period of 60 (SIXTY) days after the date of discharge are payable.","Pre-Hospitalization Expenses include various charges related to medical tests before an individual gets hospitalized. Doctors/physicians conduct a slew of tests to accurately diagnose the medical condition of a patient before prescribing treatment. It is important to note that the number of days which are covered, tends to vary depending upon the type of health insurance company. However, in most cases, charges incurred by an individual 30 days prior to his or her admission to any hospital fall within the ambit of pre-hospitalization expenses. For instance, several tests such as blood test, urine test and X-ray among others are categorised as pre-hospitalization expenses.Post-Hospitalization Expenses include all expenses or charges incurred by an individual after he or she is hospitalized. For instance, the consulting physician may prescribe certain tests to ascertain the progress or recovery of a patient. It is important to note that the number of days which are covered tends to vary depending upon the type of health insurance provider. However, in most cases, charges incurred by an individual for 60 days from the discharge date comes under the ambit of post hospitalization expenses. Expenses related to various therapies, namely, acupuncture and naturopathy are not included by insurance providers in the category of post hospitalization expenses. However, diagnostic charges, consulting fees and medicine costs are covered.","The timeline to submit your pre/post hospitalization claim is 15 days from the date of discharge & 7 days from the date of completion of your treatment (Date if Discharge) for post hospitalization claim."]
                    break
                case "Dependant Addition/Correction/Deletion":
                    self.m_questionArray=["How do I add my dependants in the policy?","How do I remove my dependants from the policy?","My dependant details are incorrect.","My dependant details are not visible/showing.","I can't add my parents/in-laws.","I can't add my spouse.","I can't add my children.","I got married recently. How do I add my spouse?","How do I add my new born baby?"]
                    let dependantString="""
Step 1: Login to Benefits You India portal using login credentials mentioned in the Welcome Mail.
Step 2:  Employee's are required to complete enrollment of dependants and opting for additional benefits within the Window Period mentioned in the Welcome Mail. Employee can Add/Modify/Delete Dependants as per policy terms and conditions.
Step 3: Click on the Confirm Enrollment button after successfully updating dependant details.
"""
                    self.m_answersArray=[dependantString,"To remove existing dependants from the Policy, insured has submit details of dependants to be removed to the HR or Account Manager stating reason for deletion. Dependants will be deleted as per policy terms and conditions.","For any correction in your dependant details, you are requested to provide correct details alongwith necessary copy of identity proof (e.g.  Copy of Aadhaar Card or Pan Card or Driving License or Election Card or Passport or Marriage Certificate in case of newly married)","Dependant details are updated in Benefits You India Portal as per data received from HR as per Policy Terms & Conditions. If you find discrepancies in the data request you to coordinate with the HR. If you are unable to add your dependants during your enrollment window, request you to get in touch with your Level 1 Account manager mentioned in Contact Details.","Dependant details are updated in Benefits You India Portal as per data received from HR as per Policy Terms & Conditions. If you find descripencies in the data request you to coordinate with the HR. If you are still unable to add your dependants during your enrollment window, request you to get in touch with your Level 1 Account manager mentioned in Contact Details. Please note mid-term addition of Parents/In-Laws is not permitted.","Mid-term inclusions are permitted only in the case of spouse on account of marriage. Intimation of the same to be given to HR Team within 15 days of the event, simultaneously the same can be updated on Benefits You India Portal if enrollment option is provided.","Mid-term inclusions are permitted only in the case of a New Born baby. Intimation of the same to be given to HR Team within 15 days of the event, simultaneously the same can be updated on Benefits You India Portal if enrollment option is provided.","Intimation of the same to be given to HR Team within 15 days of your date of marriage or the same can be updated on Benefits You India Portal if enrollment option is provided.","Intimation of the same to be given to HR Team within 15 days of your date of birth of your child or the same can be updated on Benefits You India Portal if enrollment option is provided."]
                    break
                case "Hospital Related":
                    self.m_questionArray=["What are network hospitals?","'Where can I find list of network hospitals?","Do network hospitals change frequently?","Can I make reimbursement claim in network hospital?","What are non-network hospital?"]
                    self.m_answersArray=["Network Hospitals are Tertiary Care Hospitals / Secondary Care Hospitals / Nursing Homes / Day Care Centres empanelled with the TPA / Insurance Company, who entered into an agreement with the TPA / Insurance Company to provide Cashless facility to policyholders.","Updated list of Netwrok Hospitals can be found in the Benefits You India Login under the link Network Hospitals","Yes. The list of Network Hospitals is a dynamic list and therefore the latest can be verified and downloaded from Benefits You India portal","Yes. You can make reimbursement claim in a  Network hospital.","Non-Network Hospitals are those hospitals which have not been empanelled with the TPA / Insurance Company and cannot provide Cashless Treatment."]
                    break
                case "Contact Details":
                    self.m_questionArray=["Who do I contact for my health insurance queries?","What if my query is not answered?","What if my query resolution is not satisfactory?"]
                    self.m_answersArray=["Please refer the Contact Details link in Benefits You India for your Account Manager details. You can also raise a query ticket in the Employee Queries module. Your query will be resolved within 24 hrs of raising the query.","All queries raised on Benefits You India are answered. Benefits You India has a TAT of 24 hrs for query resolution.","If you find the query resolution unsatisfactory, you have an option to continue the query discussion till resolution or raise a new Query ticket."]
                    break
                case "Claim Tracking":
                    let claimStatusString = """
                    Yes - Insured  will receive automated SMS and email of claim on their registered mobile number and email id from Benefits You India at all stages of claim process and settlement. The stages of claim status are:
                    i.) Claim Intimation
                    ii.) Claim Acknowledgment Status
                    iii.) Claim Deficiency Status
                    iv.) Claim Deficiency Reminder
                    v.) Claim Closure Status
                    vi.) Claim Rejected Status
                    vii.) Claim Settlement Letter
"""
                    self.m_questionArray=["How do I track my claim?","Will I be intimated about my updated claim status?"]
                    self.m_answersArray=["Real time status of the claim is available of Benefits You India under the Claim Status link. Insured  will receive automated SMS and email of the same on their registered mobile number and email id from Benefits You India at all stages of claim process and settlement.",claimStatusString]
                    break
                default:
                    break
                }
                
                if(item=="Others")
                {
                    //                    self.m_addQueryButton.isHidden=true
                    //                    self.m_otherView.isHidden=false
                    //                    self.m_tableView.isHidden=true
                    let addQueryVC : AddNewQueryViewController = AddNewQueryViewController()
                    
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = kCATransitionPush
                    transition.subtype = kCATransitionFromTop
                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    self.view.window!.layer.add(transition, forKey: kCATransition)
                    
                    let nvc = UINavigationController(rootViewController: addQueryVC)
                    
                    //                    self.present(nvc, animated: false, completion: nil)
                    
                    self.navigationController?.pushViewController(addQueryVC, animated: true)
                    
                }
                else if(item=="  Select Category")
                {
                    self.m_addQueryButton.isHidden=false
                    self.m_tableView.isHidden=true
                    self.m_otherView.isHidden=true
                }
                else
                {
                    self.m_addQueryButton.isHidden=false
                    self.m_tableView.isHidden=false
                    self.m_otherView.isHidden=true
                    
                }
                for i in 0..<self.m_questionArray.count
                {
                    self.datasource.append(ExpandedCell(title: self.m_questionArray[i], answer: self.m_answersArray[i]))
                }
                print(self.m_questionArray)
                self.m_tableView.reloadData()
        }
        
    }
}


extension MyQueriesViewController : UITableViewDelegate,UITableViewDataSource{
    
    //MARK:- Did Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if(tableView==m_tableView)
        {
            if selectedRowIndex == indexPath.row
            {
                selectedRowIndex = -1
                let content = datasource[indexPath.row]
                content.expanded = !content.expanded
            }
            else
            {
                if self.selectedRowIndex != -1
                {
                    let content = datasource[selectedRowIndex]
                    content.expanded = !content.expanded
                    tableView.reloadData()
                    
                    
                }
                selectedRowIndex = indexPath.row
                let content = datasource[indexPath.row]
                content.expanded = !content.expanded
                
            }
            
            print("SelectedIndex = \(selectedRowIndex) IndexPath=\(indexPath.row)")
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            m_tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            
            
            
            
            /*  let content = datasource[indexPath.row]
             content.expanded = !content.expanded
             let cell : FAQTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! FAQTableViewCell
             if(datasource.count>0)
             {
             cell.setContent(data: datasource[indexPath.row])
             }
             
             //            tableView.reloadRows(at: [indexPath], with: .automatic)
             tableView.reloadData()
             m_tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)*/
        }
        else
        {
            
            
            let viewQueryVC : ViewQueryViewController = ViewQueryViewController()
            
            if let queryNo = m_querisArrayNew[indexPath.row]["EQ_CUST_QRY_SR_NO"] as? String
            {
                viewQueryVC.m_queryNo=queryNo
                let dict=m_querisArrayNew[indexPath.row]
                viewQueryVC.m_queryDict=dict
            }
            
            //Added By Pranit 6th Aug 19
            let dict = m_querisArrayNew[indexPath.row]
            var ticketValue = dict["TICKET_NUMBER"] as? String
            if let ticketNo = ticketValue  {
                viewQueryVC.ticketNo = ticketNo
            }
            navigationController?.pushViewController(viewQueryVC, animated: true)
            viewQueryVC.m_employeedict=m_employeedict
            //            getQueryDetails(queryNo:queryNo!)
            
        }
    }
    //MARK:- Height For Row At
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(tableView==m_tableView)
        {
            if indexPath.row == selectedRowIndex
            {
                print(indexPath.row)
                print("1")
                //if(datasource[indexPath.row].expanded)
                //{print("2")
                
                return UITableViewAutomaticDimension
            }
            else
            {print("3")
                
                return UITableViewAutomaticDimension
            }
            
            //}
            print("4")
            
            //return 60
        }
        else if(tableView==m_myQueryTableView)
        {
            print("5")
            
            return UITableViewAutomaticDimension
            
        }
        print("6")
        
        return UITableViewAutomaticDimension
    }
    
    
    //MARK:- TableView Delegate and Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView==m_myQueryTableView)
        {
            return m_querisArrayNew.count
        }
        else if(tableView==m_tableView)
        {
            return m_questionArray.count
        }
        else
        {
            return m_filesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(tableView==m_myQueryTableView)
        {
            
            m_myQueryTableView.separatorStyle=UITableViewCellSeparatorStyle.none
            let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! TableViewCell
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            cell.m_statusButton.layer.masksToBounds=true
            shadowForCell(view:cell.m_backGroundView)
            //            setBottomShadow(view: cell.m_backGroundView)
            
            cell.m_viewQueryButton.tag=indexPath.row
            cell.m_viewQueryButton.addTarget(self, action: #selector(viewQueryButtonClicked), for: .touchUpInside)
            cell.m_viewQueryButton.layer.cornerRadius=cell.m_viewQueryButton.frame.size.height/2
            cell.m_statusButton.layer.cornerRadius=cell.m_statusButton.frame.size.height/2
            
            
            let dict = m_querisArrayNew[indexPath.row]
            var ticketValue = "\(dict["TICKET_NUMBER"] as! String)"
            print("ticketValue: ",ticketValue)
            cell.m_queryNoLbl.text=ticketValue
            cell.m_queryDateLbl.text=dict["POSTED_DATE"] as! String
            if let lastReply = dict["LAST_REPLY"]
            {
                
                if(lastReply as! String=="This query has no replies")
                {
                    if dict["EQ_CUST_QRY_SOLVED"] as! String=="1" || dict["EQ_CUST_QRY_ENDED"] as! String=="1" {
                        cell.m_queryDetailTextLbl.text = lastReply as! String
                    }
                    else {
                        cell.m_queryDetailTextLbl.text = dict["COMPLETE_QUERY_TEXT"] as! String
                    }
                }
                else
                {
                    cell.m_queryDetailTextLbl.text=lastReply as! String
                }
                
            }
            else
            {
                cell.m_queryDetailTextLbl.text=dict["COMPLETE_QUERY_TEXT"] as! String
            }
            
            if let replies = dict["NO_OF_REPLIES"] as? String
            {
                cell.m_noofRepliesLbl.text = "[ \(replies) Replies ]"
            }
            
            
            
            if(dict["NO_OF_REPLIES"] as! String == "0")
            {
                cell.m_statusButton.text="New"
                cell.m_statusButton.backgroundColor=hexStringToUIColor(hex: "a116ae")
                if(dict["EQ_CUST_QRY_SOLVED"] as! String == "1")
                {
                    cell.m_statusButton.text="Solved"
                    cell.m_statusButton.backgroundColor=hexStringToUIColor(hex: "26c281")
                }
                if(dict["EQ_CUST_QRY_ENDED"] as! String == "1")
                {
                    cell.m_statusButton.text="Ended"
                    cell.m_statusButton.backgroundColor=hexStringToUIColor(hex: "ff1000")
                }
            }
            else if(dict["EQ_CUST_QRY_SOLVED"] as! String == "1")
            {
                cell.m_statusButton.text="Solved"
                cell.m_statusButton.backgroundColor=hexStringToUIColor(hex: "26c281")
            }
            else if(dict["EQ_CUST_QRY_ENDED"] as! String == "1")
            {
                cell.m_statusButton.text="Ended"
                cell.m_statusButton.backgroundColor=hexStringToUIColor(hex: "ff1000")
            }
            else
            {
                cell.m_statusButton.text="Replied"
                cell.m_statusButton.backgroundColor=hexStringToUIColor(hex: "e7be2a")
                if(dict["EQ_CUST_QRY_SOLVED"]  as! String == "1")
                {
                    cell.m_statusButton.text="Solved"
                    cell.m_statusButton.backgroundColor=hexStringToUIColor(hex: "26c281")
                }
                if(dict["EQ_CUST_QRY_ENDED"] as! String == "1")
                {
                    cell.m_statusButton.text="Ended"
                    cell.m_statusButton.backgroundColor=hexStringToUIColor(hex: "ff1000")
                }
            }
            
            
            
            
            
            return cell
            
        }
            
            //QUERY LIST
        else if(tableView == m_tableView)
        {
            let cell : FAQTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! FAQTableViewCell
            
            //        cell.selectionStyle=UITableViewCellSelectionStyle.none
            
            //            self.datasource.append(ExpandedCell(title: m_questionArray[indexPath.row], answer: m_answersArray[indexPath.row]))
            
            //            shadowForCell(view: cell.m_backGroundView)
            //            setBottomShadow(view: cell.m_backGroundView)
            cell.m_questionBackgroundView.layer.masksToBounds=true
            cell.m_questionBackgroundView.layer.cornerRadius=8
            cell.m_answerBackgroundView.layer.masksToBounds=true
            cell.m_answerBackgroundView.layer.cornerRadius=8
            if(datasource.count>0)
            {
                if indexPath.row == selectedRowIndex {
                    cell.setContentQuery(data: datasource[indexPath.row], expand: true)
                }
                else {
                    cell.setContentQuery(data: datasource[indexPath.row], expand: false)
                }
            }
            
            cell.m_expandButton.addTarget(self, action: #selector(expandButtonClicked), for: .touchUpInside)
            return cell
        }
        else
        {
            let cell : FilesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "fileCell") as! FilesTableViewCell
            
            cell.m_fileNameLbl.text=m_filesArray[indexPath.row]
            cell.m_deleteButton.tag=indexPath.row
            cell.m_deleteButton.addTarget(self, action: #selector(deleteFileButtonClicked), for: .touchUpInside)
            
            return cell
        }
        
        
    }
    
    
    
}


extension MyQueriesViewController : UIDocumentMenuDelegate,UIDocumentPickerDelegate{
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
        
        if(m_attachedDocumentsArray.count>=5)
        {
            displayActivityAlert(title: "You can not attach more than 5 files")
        }
        else
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
                    displaySelectedFiles()
                }
                
            }
            catch
            {
                print("Unable to load data: \(error)")
            }
            
        }
        
    }
}

extension MyQueriesViewController :UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if(textView.text=="Write your query here")
        {
            textView.text=""
        }
        textView.textColor=UIColor.black
        animateTextView(textView, with: true)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text=="\n")
        {
            view.endEditing(true)
        }
        
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        setupDropDown(textField,at: textField.tag)
        dateDropDown.show()
        
        return false
        
        
    }
    func textViewDidChange(_ textView: UITextView) {
        
    }
}
