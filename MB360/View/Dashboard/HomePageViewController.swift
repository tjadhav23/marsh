
//
//  HomePageViewController.swift
//  MyBenefits
//
//  Created by Semantic on 08/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit


class HomePageViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,XMLParserDelegate,UITabBarDelegate,UIDocumentInteractionControllerDelegate {
//    @IBOutlet weak var m_bottomView: UIView!
    
//    @IBOutlet weak var m_bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_nameLbl: UILabel!
    @IBOutlet weak var m_collectionView: UICollectionView!
    
   
    @IBOutlet weak var m_scrollView: UIScrollView!
    
    let m_reuseIdentifier = "cell"
//    var m_iconImageArray = [#imageLiteral(resourceName: "enrollment"),#imageLiteral(resourceName: "Mycoverage"),#imageLiteral(resourceName: "Claim"),#imageLiteral(resourceName: "IntimateClaim"),#imageLiteral(resourceName: "NetworkHospital"),#imageLiteral(resourceName: "ContactDetails"),#imageLiteral(resourceName: "MyQuery"),#imageLiteral(resourceName: "PolicyFeature"),#imageLiteral(resourceName: "ClaimProcedure"),#imageLiteral(resourceName: "Utility"),#imageLiteral(resourceName: "Ecard"),#imageLiteral(resourceName: "faq")]
//    var m_titleArray = ["link1Name".localized(),"link2Name".localized(),"link3Name".localized(),"link4Name".localized(),"link5Name".localized(),"link6Name".localized(),"link7Name".localized(),"link8Name".localized(),"link9Name".localized(),"link10Name".localized(),"link11Name".localized(),"link12Name".localized()]
    var m_employeedict : EMPLOYEE_INFORMATION?
    var m_iconImageArray = [#imageLiteral(resourceName: "enrollment"),#imageLiteral(resourceName: "MyCoverage"),#imageLiteral(resourceName: "Ecard"),#imageLiteral(resourceName: "IntimateClaim"),#imageLiteral(resourceName: "NetworkHospital"),#imageLiteral(resourceName: "Claim"),#imageLiteral(resourceName: "PolicyFeature"),#imageLiteral(resourceName: "ClaimProcedure"),#imageLiteral(resourceName: "Utility"),#imageLiteral(resourceName: "faq-1"),#imageLiteral(resourceName: "ContactDetails"),#imageLiteral(resourceName: "MyQuery")]
    var m_titleArray = ["link1Name".localized(),"link2Name".localized(),"link3Name".localized(),"link4Name".localized(),"link5Name".localized(),"link6Name".localized(),"link7Name".localized(),"link8Name".localized(),"link9Name".localized(),"link10Name".localized(),"link11Name".localized(),"link12Name".localized()]
    
    
    var xmlKey = String()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    var dictionaryKeys = ["WINDOW_PERIOD_ACTIVE","PARENTAL_PREMIUM", "CROSS_COMBINATION_ALLOWED", "PAR_POL_INCLD_IN_MAIN_POLICY", "LIFE_EVENT_DOM","LIFE_EVENT_CHILDDOB","SON_MAXAGE","DAUGHTER_MAXAGE","PARENTS_MAXAGE","LIFE_EVENT_DOM_VALDTN_MSG","LIFE_EVENT_CHILDDOB_VALDTN_MSG","SON_MAXAGE_VALDTN_MSG","DAUGHTER_MAXAGE_VALDTN_MSG","PARENTS_MAXAGE_VALDTN_MSG","IS_TOPUP_OPTION_AVAILABLE","TOPUP_OPTIONS","TOPUP_PREMIUMS","ENRL_CNRFM_ALLOWED_FREQ","ENRL_CNRFM_MESSAGE","WINDOW_PERIOD_END_DATE","WINDOW_PERIOD_ACTIVE_TILL_MESSAGE","TOTAL_POLICY_FAMILY_COUNT","RELATION_COVERED_IN_FAMILY","RELATION_ID_COVERED_IN_FAMILY","MAIN_POLICY_FAMILY_COUNT","PARENTAL_POLICY_FAMIL_COUNT","IS_ENROLLMENT_CONFIRMED","EMPLOYEE_EDITABLE_FIELDS","TOPUP_OPT_TOTAL_DAYS_LAPSED","EMPLOYEE_RELATION", "EMPLOYEE_RELATION_ID", "EMPLOYEE_NAME", "EMPLOYEE_DOB","EMPLOYEE_AGE","EMPLOYEE_GENDER","PERSON_SR_NO","OFFICIAL_EMAIL_ID","PERSONAL_EMAIL_ID","CELLPHONE_NO","BASE_SUM_INSURED","TOPUP_SUM_INSURED","EMPLOYEE_IDENTIFICATION_NO","EMPLOYEE_GRADE","EMPLOYEE_DEPARTMENT","EMPLOYEE_DESIGNATION","EMPLOYEE_DOJ","EMP_TOPUP_OPTED","EMP_TOPUP_SI","EMP_TOPUP_PREMIUM","EMP_TOPUP_PREM_DEDTN_MESSAGE","EMP_TOPUP_OPTD_SR_NO","PERSON_SR_NO","DEPENDANT_RELATION","DEPENDANT_RELATION_ID","DEPENDANT_NAME","DEPENDANT_DOB","DEPENDANT_AGE","EcardInformation"]
    
    
//    let dictionaryKeys = ["EMPLOYEE_RELATION", "EMPLOYEE_RELATION_ID", "EMPLOYEE_NAME", "EMPLOYEE_DOB","EMPLOYEE_AGE","EMPLOYEE_GENDER","PERSON_SR_NO","OFFICIAL_EMAIL_ID","PERSONAL_EMAIL_ID","CELLPHONE_NO","BASE_SUM_INSURED","TOPUP_SUM_INSURED","EMPLOYEE_IDENTIFICATION_NO","EMPLOYEE_GRADE","EMPLOYEE_DEPARTMENT","EMPLOYEE_DESIGNATION","EMPLOYEE_DOJ","EMP_TOPUP_OPTED","EMP_TOPUP_SI","EMP_TOPUP_PREMIUM","EMP_TOPUP_PREM_DEDTN_MESSAGE","EMP_TOPUP_OPTD_SR_NO","PERSON_SR_NO","DEPENDANT_RELATION","DEPENDANT_RELATION_ID","DEPENDANT_NAME","DEPENDANT_DOB","DEPENDANT_AGE"]
    
    var collectionHeaderView = CollectionReusableView()
    var m_userDict : EMPLOYEE_INFORMATION?
    var documentController: UIDocumentInteractionController = UIDocumentInteractionController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem=nil
        let nib = UINib (nibName: "DashboardCollectionViewCell", bundle: nil)
        m_collectionView.register(nib, forCellWithReuseIdentifier: m_reuseIdentifier)
        
        self.m_collectionView.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        
        self.m_collectionView.register(UINib(nibName: "CollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        
        m_collectionView.delegate=self
        m_collectionView.dataSource=self
        m_collectionView.backgroundColor=UIColor.white
        
       self.tabBarController?.tabBar.isHidden=false
        tabBarController?.tabBar.tintColor=hexStringToUIColor(hex: hightlightColor)
        tabBarController?.tabBar.backgroundColor=hexStringToUIColor(hex: "E3EAFD")
        
      

       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        navigationItem.rightBarButtonItem=getRightBarButton()
        
        self.tabBarController?.tabBar.isHidden=false
        
        let logo = UIImage(named: "whitelogo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height:10))
        imageView.image=logo
        imageView.contentMode=UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.leftBarButtonItem?.isEnabled=false
        navigationItem.leftBarButtonItem?.accessibilityElementsHidden=true
        
        self.navigationController?.navigationBar.layer.shouldRasterize=false
        print(m_userDict)
      if let name = m_userDict?.empIDNo
      {
        self.m_nameLbl.text="hello".localized()+name+"!"
      }
      else
      {
        
        
        var employeeDetailsArray : Array<EMPLOYEE_INFORMATION> = []
        
        
        employeeDetailsArray = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
        
        if(employeeDetailsArray.count>0)
        {
            
            
            m_userDict = employeeDetailsArray[0]
//            self.m_nameLbl.text="Hello, "+(m_userDict?.empIDNo)!+"!"
        }
    }
        setLayout()
    }
    func setLayout()
    {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if(Device.IS_IPAD)
        {
            
            layout.itemSize = CGSize(width: 240, height: 250)
        }
        else if(Device.IS_IPHONE_6)
        {
            layout.itemSize = CGSize(width: 110, height: 120)
        }
        else if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
        {
            layout.itemSize = CGSize(width: 89, height: 120)
        }
        else if(Device.IS_IPHONE_X)
        {
            layout.itemSize = CGSize(width: 110, height: 120)
            //            m_bottomViewHeightConstraint.constant=70
        }
        else
        {
            layout.itemSize = CGSize(width: 140, height: 150)
        }
        
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        m_collectionView.collectionViewLayout=layout
        
        automaticallyAdjustsScrollViewInsets=false

        m_scrollView.contentInset=UIEdgeInsets.zero
        m_scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        m_scrollView.contentOffset = CGPoint(x:0.0,y:0.0)
      
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
       
        let status=UserDefaults.standard.object(forKey: "isAlreadylogin") as? Bool
        if(status==false||status==nil)
        {
            getDataSettings()
        }
//        m_collectionView.frame.size.height=view.frame.size.height
    }
    
    @IBAction func profileTabSelected(_ sender: Any)
    {
        _ = Bundle.main.loadNibNamed("ProfileViewController", owner: self, options: nil)?[0];
//        m_dateView.frame=view.frame
//        view.addSubview(m_dateView)
        
//        let profile : ProfileViewController = ProfileViewController()
//        navigationController?.pushViewController(profile, animated: true)
    }
    
    @IBAction func homeTabSelected(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    func getDataSettings()
    {
        if(isConnectedToNet())
        {
            showPleaseWait(msg: "Please wait...")
            
            if m_userDict != nil
            {
                getDataSettingsUrl()
                getAdminSettingsUrl()
            }
            else
            {
                var employeeDetailsArray : Array<EMPLOYEE_INFORMATION> = []
                
                DispatchQueue.main.async(execute:
                    {
                        employeeDetailsArray = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
            
                        
                        
                        if(employeeDetailsArray.count>0)
                        {
                            self.m_userDict = employeeDetailsArray[0]
                            self.getDataSettingsUrl()
                            self.getAdminSettingsUrl()
                            
                        }
                    })
            }
        }
            
            
                
        
        
    }
    
    func getDataSettingsUrl()
    {
//        self.m_nameLbl.text="Hello, "+(m_userDict?.empIDNo!)! as String+"!"
        var groupchildsrno = String()
        var oegrpbasinfsrno = String()
        var employeesrno = String()
        
        if let childNo = m_userDict?.groupChildSrNo
        {
            groupchildsrno = String(childNo)
        }
        if let oeinfNo = m_userDict?.oe_group_base_Info_Sr_No
        {
            oegrpbasinfsrno = String(oeinfNo)
        }
       
        if let empSrNo = m_userDict?.empSrNo
        {
            employeesrno = String(empSrNo)
        }
        
        
        let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getEnrollmentDataSettings(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno, employeesrno: employeesrno))
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = urlreq as URL?// NSURL(string: urlreq)
        request.httpMethod = "GET"
        
        
        
        let task = URLSession.shared.dataTask(with: urlreq! as URL)
        {   (data, response, error) in
            
            if data == nil
            {
                
                return
            }
            self.xmlKey = "EmployeeSettings"
            let parser = XMLParser(data: data!)
            parser.delegate = self as XMLParserDelegate
            parser.parse()
            print(self.resultsDictArray ?? "")
            for obj in self.resultsDictArray!
            {
                
                print(obj)
                let userDict : NSDictionary = obj as NSDictionary
                UserDefaults.standard.set(userDict, forKey: "DataSettingsDict")
                print(userDict)
                
            }
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "isAlreadylogin")
            self.hidePleaseWait()
            
        }
        task.resume()
    }
    
    func getAdminSettingsUrl()
    {
//        self.m_nameLbl.text="Hello, "+(m_userDict?.empIDNo!)! as String+"!"
        var groupchildsrno = String()
        var oegrpbasinfsrno = String()
        
        if let childNo = m_userDict?.groupChildSrNo
        {
            groupchildsrno = String(childNo)
        }
        if let oeinfNo = m_userDict?.oe_group_base_Info_Sr_No
        {
            oegrpbasinfsrno = String(oeinfNo)
        }
        
        var employeesrno = String()
        if let empSrNo = m_userDict?.empSrNo
        {
            employeesrno = String(empSrNo)
        }
        let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getAdminSettingsUrl(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno, employeesrno: employeesrno))
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = urlreq as URL?// NSURL(string: urlreq)
        request.httpMethod = "GET"
        
        
        
        let task = URLSession.shared.dataTask(with: urlreq! as URL)
        {
            (data, response, error) in
            
            if data == nil
            {
                
                return
            }
            self.xmlKey = "Adminsettings"
            let parser = XMLParser(data: data!)
            parser.delegate = self
            parser.parse()
            
            
            for dict in self.resultsDictArray!
            {
                let userDict : NSDictionary = dict as NSDictionary
                UserDefaults.standard.set(userDict, forKey: "AdminSettingsDic")
            }
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "isAlreadylogin")
            self.hidePleaseWait()
            
            
            
        }
        task.resume()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return m_titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : DashboardCollectionViewCell = collectionView .dequeueReusableCell(withReuseIdentifier: m_reuseIdentifier, for: indexPath) as! DashboardCollectionViewCell
        
        cell.m_titleLbl?.text=m_titleArray[indexPath.row]
        cell.m_imageView?.image=m_iconImageArray[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        if let window = appdelegate?.window
//        {
//            window?.rootViewController = navigationController
//
//        }
        
        
//        UIApplication.shared.keyWindow?.rootViewController = navigationController
        
        switch indexPath.row
        {
        case 0:
//            let enrollMent : EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
//            navigationController?.pushViewController(enrollMent, animated: true)
            
            return
        case 1:
            let myCoverages : MyCoveragesViewController = MyCoveragesViewController()
            myCoverages.m_employeedict=m_userDict
            navigationController?.pushViewController(myCoverages, animated: true)
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            return
        case 2:
            downloadEcard()
            return
        case 3:
            let intimation : MyIntimationViewController = MyIntimationViewController()
            navigationController?.pushViewController(intimation, animated: true)
            return
        case 4:
            let networkHospitals : NetworkHospitalsViewController = NetworkHospitalsViewController()
            navigationController?.pushViewController(networkHospitals, animated: true)
            return
        case 5:
            let myClaims:MyClaimsViewController = MyClaimsViewController()
                navigationController?.pushViewController(myClaims, animated: true)
            
            return
            
        case 6:
            let policyFeatures : PolicyFeaturesViewController = PolicyFeaturesViewController()
            navigationController?.pushViewController(policyFeatures, animated: true)
            
            return
        case 7:
            let claimProcedure : ClaimProcedureViewController = ClaimProcedureViewController()
            navigationController?.pushViewController(claimProcedure, animated: true)
            return
        case 8:
            let utilities : UtilitiesViewController = UtilitiesViewController()
            navigationController?.pushViewController(utilities, animated: true)
           return
        case 9:
            let myQueries : MyQueriesViewController = MyQueriesViewController()
            navigationController?.pushViewController(myQueries, animated: true)
            return
        case 10:
            let contactsVC : ContactDetailsViewController = ContactDetailsViewController()
            navigationController?.pushViewController(contactsVC, animated: true)
            return
        case 11:
            let FAQVC : FAQViewController = FAQViewController()
            navigationController?.pushViewController(FAQVC, animated: true)
            return
        default:
            return
        }
        
    }
    
    func downloadEcard()
    {
       /* if(isConnectedToNetWithAlert())
        {
            
            showPleaseWait(msg: """
Please wait...
Fetching E-card
""")
            let groupInfoArray  =  DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "GMC")
            let groupDict = groupInfoArray[0]
            let groupMasterArray  =  DatabaseManager.sharedInstance.retrieveGroupChildMasterDetails(productCode:"")
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            
            let groupMasterDict = groupMasterArray[0]
            
            if(userArray.count>0)
            {
                m_employeedict=userArray[0]
            }
            
            var empNo = String()
            if let empSrNo = m_employeedict?.empIDNo
            {
                empNo = String(empSrNo)
            }
            
            var policyNo = groupDict.policyNumber
            policyNo = policyNo?.replacingOccurrences(of: "/", with: "~")
            
            //            dataRequest.addChild(name: "tpacode", value: groupDict.tpa_Code)
            //            dataRequest.addChild(name: "employeeno", value: empNo)
            //            dataRequest.addChild(name: "policynumber", value:policyNo )
            //
            var policyComDate = groupDict.policyComencmentDate
            policyComDate = policyComDate?.replacingOccurrences(of: "/", with: "~")
            var policyValidUpto = groupDict.policyValidUpto
            policyValidUpto = policyValidUpto?.replacingOccurrences(of: "/", with: "~")
            
            //            dataRequest.addChild(name: "policycommencementdt", value:policyComDate)
            //            dataRequest.addChild(name: "policyvaliduptodt", value: policyValidUpto)
            //            dataRequest.addChild(name: "groupcode", value: groupMasterDict.groupCode)
            //
            
            
            let root = NSXMLElement(name: "DataRequest")
            let xml = NSXMLDocument(rootElement: root)
            root.addChild(NSXMLElement(name: "tpacode", stringValue:groupDict.tpa_Code))
            root.addChild(NSXMLElement(name: "employeeno", stringValue:empNo))
            root.addChild(NSXMLElement(name: "policynumber", stringValue:policyNo))
            root.addChild(NSXMLElement(name: "policycommencementdt", stringValue:policyComDate))
            root.addChild(NSXMLElement(name: "policyvaliduptodt", stringValue:policyValidUpto))
            root.addChild(NSXMLElement(name: "groupcode", stringValue:groupMasterDict.groupCode))
            
            
            println(xml.XMLString)
            let uploadData = xml.data(using: .utf8)
            
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getEcardDetailsPostUrl() as String)
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody=uploadData
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if error != nil
                {
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
                                self.xmlKey = "DocumentElement"
                                let parser = XMLParser(data: data!)
                                parser.delegate = self as? XMLParserDelegate
                                parser.parse()
                                print(self.resultsDictArray ?? "")
                                for obj in self.resultsDictArray!
                                {
                                    let status = obj["EcardInformation"]
                                    
                                    DispatchQueue.main.async(execute:
                                        {
                                            
                                            self.tabBarController?.selectedIndex=2
                                            
                                            if(status=="E-card under process")
                                            {
                                                self.displayActivityAlert(title: status!)
                                                self.hidePleaseWait()
                                            }
                                            else
                                            {
                                                self.saveEcard(obj:obj)
                                                
                                            }
                                            
                                            
                                    })
                                }
                                
                            }
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                                Crashlytics.sharedInstance().recordError(m_errorMsg as! Error)
                                self.hidePleaseWait()
                            }
                        }
                        else
                        {
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
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
        */
    }
    
    func saveEcard(obj:[String:String])
    {
       /* if let fileName = obj["EcardInformation"]
        {
            showPleaseWait()
           
            
          
                
                    let urlString : NSString = fileName as NSString
                    let urlStr : NSString = urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                    
                    if  let url = NSURL(string: urlStr as String)
                    {
                        //                    let url : URL = URL(string:fileName as! String)
                        let request = URLRequest(url: url as URL)
                        let session = URLSession(configuration: URLSessionConfiguration.default)
                        
                        let task = session.dataTask(with: request, completionHandler:
                        {(data, response, error) -> Void in
                            
                            
                            let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                            
                            
                            let fileName = urlStr.lastPathComponent
                            
                                
                                let destinationUrl = documentsUrl.appendingPathComponent(fileName)
                                let fileURLPath = documentsUrl.appendingPathComponent("\(fileName).pdf")
                                if let data = data
                                {
                                    do
                                    {
                                    self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
                                        try data.write(to: destinationUrl!, options: .atomic)
                                        try data.write(to: destinationUrl!)
                                    
                                        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                                        let documentsDirectory = paths[0]
                                        print(documentsDirectory)
                                        self.hidePleaseWait()
                                        self.displayActivityAlert(title: "E-card downloaded")
                                    }
                                    catch
                                    {
                                        print(error)
                                    }
                                    
                                    self.documentController = UIDocumentInteractionController(url: destinationUrl!)
                                }
                            
    
                            
                        })
                        task.resume()
                    }
                    else
                    {
                        self.hidePleaseWait()
                        self.displayActivityAlert(title: "File not found")

                    }
            
        }
        else
        {
            displayActivityAlert(title: "File not found")
        }*/
        if let fileName = obj["EcardInformation"]
        {
            showPleaseWait(msg: "Please wait...")
            DispatchQueue.main.async
                {
                    let url : NSString = fileName as NSString
                    var urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                    
                    if var searchURL : NSURL = NSURL(string: urlStr as String)
                    {
                        //                    let url : URL = URL(string:fileName as! String)
                        let request = URLRequest(url: searchURL as URL)
                        let session = URLSession(configuration: URLSessionConfiguration.default)
                        
                        let task = session.dataTask(with: request, completionHandler:
                        {(data, response, error) -> Void in
                            
                            
                            let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                            
                            
                            if let fileName = searchURL.lastPathComponent
                            {
                                
                                let destinationUrl = documentsUrl.appendingPathComponent(fileName)
                                let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
                                if let data = data
                                {
                                    do
                                    {
                                        self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
                                        try data.write(to: destinationUrl!, options: .atomic)
                                        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                                        let documentsDirectory = paths[0]
                                        print(documentsDirectory)
                                        self.hidePleaseWait()
                                        self.displayActivityAlert(title: "E-card downloaded")
                                    }
                                    catch
                                    {
                                        print(error)
                                    }
                                    
//                                    self.documentController = UIDocumentInteractionController(url: destinationUrl!)
                                }
                                else
                                {
                                    self.hidePleaseWait()
                                    self.isConnectedToNetWithAlert()
                                }
                            }
                            
                            
                        })
                        task.resume()
                        
                    }
                    else
                    {
                        self.hidePleaseWait()
                        self.displayActivityAlert(title: "File not found")
                        
                    }
            }
        }
        else
        {
            hidePleaseWait()
            displayActivityAlert(title: "File not found")
        }
        
        
    }
    

    func openSelectedDocumentFromURL(documentURLString: String)
    {
        DispatchQueue.main.async()
        {
            //code
            let documentURL: NSURL = NSURL(fileURLWithPath: documentURLString)
            self.documentController = UIDocumentInteractionController(url: documentURL as URL)
            self.documentController.delegate = self
            self.documentController.presentPreview(animated: true)
        }
    }
    
    
    // MARK: - UIDocumentInteractionViewController delegate methods
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        hidePleaseWait()
        return self
    }
    
    
    
    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        
        if elementName == xmlKey
        {
            currentDictionary = [String : String]()
        }
        else if dictionaryKeys.contains(elementName)
        {
            self.currentValue = String()
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        self.currentValue += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == xmlKey
        {
            resultsDictArray?.append(currentDictionary!)
            self.currentDictionary = [:]
            
        }
        else if dictionaryKeys.contains(elementName)
        {
            
            if let dict = self.currentDictionary
            {
                self.currentDictionary![elementName] = currentValue
                self.currentValue = ""
            }
            
        }
        
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        
        
    }
}
