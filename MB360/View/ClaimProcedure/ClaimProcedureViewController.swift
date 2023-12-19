//
//  ClaimProcedureViewController.swift
//  MyBenefits
//
//  Created by Semantic on 19/06/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import FirebaseCrashlytics
import WebKit


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch
        {
            Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
class ClaimProcedureViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, WKUIDelegate, WKNavigationDelegate,NewPoicySelectedDelegate {
    
    @IBOutlet weak var viewForWebView: UIView!
    @IBOutlet weak var m_segmentView: UIView!
    @IBOutlet weak var m_topBar: UIView!
    @IBOutlet weak var m_GTLShadowView: UIView!
    @IBOutlet weak var m_GPAShadowView: UIView!
    @IBOutlet weak var m_shadowView: UIView!
    @IBOutlet weak var GTLTab: UIButton!
    @IBOutlet weak var GPATab: UIButton!
    
    @IBOutlet weak var m_scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var m_scrollView: UIScrollView!
    @IBOutlet weak var m_indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var m_tableviewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var m_reimbursmentButton: UIButton!
    @IBOutlet weak var m_cashlessButton: UIButton!
    @IBOutlet weak var m_GMCTab: UIButton!
    @IBOutlet weak var m_tableView: UITableView!
    
    @IBOutlet weak var policyNamelbl: UILabel!
    
    @IBOutlet weak var PolicylblView: UIView!
    let reuseIdentifier = "cell"
    var m_productCode = String()
    var selectedRowIndex = -1
    var datasource = [ExpandedCaimProcedure]()
    var isFromSideBar = Bool()
    
   // @IBOutlet weak var m_webView: UIWebView!
    
    @IBOutlet weak var m_titleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_titleLbl: UILabel!
    @IBOutlet weak var m_ttleView: UIView!
    
    @IBOutlet weak var heightTopBar: NSLayoutConstraint!
    var m_webView: WKWebView!
    var policyDetailsArray = Array<CoveragesDetails>()
    var selectedPolicyValue = ""
    var policyDataArray = [OE_GROUP_BASIC_INFORMATION]()
    var selectedIndexPosition = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Top bar hide buttons
        m_GMCTab.isHidden=true
        GPATab.isHidden=true
        GTLTab.isHidden=true
        
        m_GMCTab.layer.borderWidth = 2
        GPATab.layer.borderWidth = 2
        GTLTab.layer.borderWidth = 2
        
        m_GMCTab.layer.cornerRadius = cornerRadiusForView
        GPATab.layer.cornerRadius = cornerRadiusForView
        GTLTab.layer.cornerRadius = cornerRadiusForView
        PolicylblView.setBorderToViewSelectPolicy(color:hexStringToUIColor(hex: "E5E5E5"))
        m_tableView.register(GMCTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let nib = UINib (nibName: "GMCTableViewCell", bundle: nil)
        m_tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
//        self.tabBarController?.tabBar.isHidden=true
        self.addTarget()
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        print("Claim Procedure Page Data from UserDefaults  m_productCode \(m_productCode) selectedPolicyValue \(selectedPolicyValue) selectedIndexPosition \(selectedIndexPosition)")
        //FOR WKWEBVIEW
       let webconfig = WKWebViewConfiguration()
       // m_webView = WKWebView(frame: CGRect(x: 4, y: 4, width: self.viewForWebView.bounds.width - 4, height: self.viewForWebView.bounds.height - 20), configuration: webconfig)
        m_webView = WKWebView()
        m_webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

       m_webView.frame = CGRect(origin: CGPoint.zero, size: viewForWebView.frame.size)

        m_webView.uiDelegate = self as WKUIDelegate
        m_webView.navigationDelegate = self as WKNavigationDelegate

        viewForWebView.addSubview(m_webView)
        m_webView.translatesAutoresizingMaskIntoConstraints = false
        m_webView.clipsToBounds = false
        

//        viewForWebView.addConstraint(NSLayoutConstraint(item: m_webView, attribute: .trailing, relatedBy: .equal, toItem: nil, attribute: .trailing, multiplier: 1, constant: 8))
//        viewForWebView.addConstraint(NSLayoutConstraint(item: m_webView, attribute: .leading, relatedBy: .equal, toItem: nil, attribute: .leading, multiplier: 1, constant: 8))
//
//        viewForWebView.addConstraint(NSLayoutConstraint(item: m_webView, attribute: .top, relatedBy: .equal, toItem: nil, attribute: .bottom, multiplier: 1, constant: 8))
//        viewForWebView.addConstraint(NSLayoutConstraint(item: m_webView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: 131))

        
        //m_webView.addConstaintsToSuperview(leftOffset: 4, topOffset: 4)
        //m_webView.addConstaints(height: self.viewForWebView.frame.height - 15, width: self.viewForWebView.frame.width - 4)
        
        
        
        
        self.m_tableView.estimatedRowHeight = 3400;
        self.m_tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.m_tableView.setNeedsLayout()
        self.m_tableView.layoutIfNeeded()
        
        m_topBar.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
        m_segmentView.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
        m_segmentView.layer.borderWidth=1
        //m_segmentView.layer.cornerRadius = cornerRadiusForView
        setData()
        m_indicator.stopAnimating()
        
        //m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        m_productCodeArray=UserDefaults.standard.value(forKey: "ProductsArray") as! Array<String>
        print("m_productCodeArray: ",m_productCodeArray)
        
        print("Active Policy: ",m_productCodeArray)
        
        if(m_productCodeArray.contains("GMC")){
            print("GMC present")
            m_GMCTab.isHidden = false
        }
        if(m_productCodeArray.contains("GPA")){
            print("GPA present")
            GPATab.isHidden = false
        }
        if(m_productCodeArray.contains("GTL")){
            print("GTL present")
            GTLTab.isHidden = false
        }
        
        print("m_productCode: ",m_productCode)
        if m_productCode == "GMC"{
            GMCTabSeleted()
            m_GMCTab.isHidden = false
        }
        else if m_productCode == "GPA"{
            GPATabSelected()
            GPATab.isHidden = false
        }
        else if m_productCode == "GTL"{
            GTLTabSelected()
            GTLTab.isHidden = false
        }
    }
    @objc override func backButtonClicked()
    {
       
        _ = navigationController?.popViewController(animated: true)
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        navigationController?.navigationBar.isHidden=false
    }
    
  
    func setData()
    {
        self.navigationItem.title="Claim Procedures"
        navigationController?.isNavigationBarHidden=false
        navigationItem.leftBarButtonItem=getBackButton()
        //navigationItem.rightBarButtonItem=getRightBarButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
       // m_webView.layer.masksToBounds = false
        m_webView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        m_webView.layer.shadowOpacity = 30
        m_webView.layer.shadowOffset = CGSize(width: 0.0, height: 4)
        m_webView.layer.shadowRadius = 3
        m_webView.layer.cornerRadius = 5
        
        
        datasource.append(ExpandedCaimProcedure(title: "cashless"))
        datasource.append(ExpandedCaimProcedure(title: "reimbursement"))
        
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        
        //setTopbarProducts()
        
    }
    func setTopbarProducts()
    {
        
        if(m_productCodeArray.count==1)
        {
            if(m_productCodeArray.contains("GMC"))
            {
                GMCTabSeleted()
                m_GMCTab.isUserInteractionEnabled=false
                GPATab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=false
                
                GPATab.setTitleColor(UIColor.white, for: .normal)
                GTLTab.setTitleColor(UIColor.white, for: .normal)
            }
            else if(m_productCodeArray.contains("GPA"))
            {
                GPATabSelected()
                m_GMCTab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=false
                GPATab.isUserInteractionEnabled=false
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
                GTLTab.setTitleColor(UIColor.white, for: .normal)
            }
            else if(m_productCodeArray.contains("GTL"))
            {
                GTLTabSelected()
                GPATab.isUserInteractionEnabled=false
                m_GMCTab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=false
                GPATab.setTitleColor(UIColor.white, for: .normal)
                m_GMCTab.setTitleColor(UIColor.white, for: .normal)
            }
            //self.heightTopBar.constant = 0
            //self.m_topBar.isHidden = true
        }
        else if(m_productCodeArray.count==2)
        {
           
            if(m_productCodeArray.contains("GMC") && m_productCodeArray.contains("GPA"))
            {
                
                m_GMCTab.isUserInteractionEnabled=true
                GPATab.isUserInteractionEnabled=true
                GTLTab.isUserInteractionEnabled=false
                m_GMCTab.isHidden=false
                GPATab.isHidden=false
                GTLTab.isHidden=true
                GMCTabSeleted()
                
            }
            else if(m_productCodeArray.contains("GMC") && m_productCodeArray.contains("GTL"))
            {
                
                m_GMCTab.isUserInteractionEnabled=true
                GPATab.isUserInteractionEnabled=false
                GTLTab.isUserInteractionEnabled=true
                m_GMCTab.isHidden=false
                GPATab.isHidden=true
                GTLTab.isHidden=false
                GMCTabSeleted()
            }
            else if(m_productCodeArray.contains("GPA") && m_productCodeArray.contains("GTL"))
            {
                
                m_GMCTab.isUserInteractionEnabled=false
                GPATab.isUserInteractionEnabled=true
                GTLTab.isUserInteractionEnabled=true
                m_GMCTab.isHidden=true
                GPATab.isHidden=false
                GTLTab.isHidden=false
                GPATabSelected()
                
            }
            else
            {
                //EnrollmentDetails()
                
            }
        }
        else
        {
            GMCTabSeleted()
        }
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
    
    func GMCTabSeleted()
    {
       
        m_productCode="GMC"
        
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        }
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        if policyDataArray.count > selectedIndexPosition{
            print("ClaimProcedureViewController selectedIndexPosition GMC ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("ClaimProcedureViewController selectedIndexPosition GMC ",selectedIndexPosition)
        }
        
        getEnrollStatus(m_productCode, selectedIndexPosition, selectedPolicyValue)
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        m_segmentView.isHidden=false
        selectedRowIndex=0
        cashlessButtonClicked(m_cashlessButton)
        m_shadowView.dropShadow()
        m_GTLShadowView.layer.masksToBounds=true
        m_GPAShadowView.layer.masksToBounds=true
        m_GMCTab.layer.masksToBounds=true
        m_GMCTab.layer.cornerRadius=cornerRadiusForView//m_GMCTab.frame.size.height/2
        //m_GMCTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        m_GMCTab.layer.borderWidth=0
        m_GMCTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
//        GMCLine.backgroundColor=hexStringToUIColor(hex: "4B66EA")
        m_GMCTab.setTitleColor(UIColor.white, for: .normal)
        
//        GPALine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
//        GTLLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        GPATab.layer.borderColor=UIColor.white.cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        GTLTab.layer.borderColor=UIColor.white.cgColor
        GTLTab.setBackgroundImage(nil, for: .normal)
        
        m_indicator.isHidden=true
        m_tableView.isHidden=false
         m_ttleView.isHidden=true
        m_webView.isHidden=true
        self.viewForWebView.isHidden = true
        
        GPATab.layer.borderWidth = 2
        GTLTab.layer.borderWidth = 2
        
        GPATab.layer.cornerRadius = cornerRadiusForView//8
        GTLTab.layer.cornerRadius = cornerRadiusForView//8
        m_shadowView.layer.cornerRadius = cornerRadiusForView//8
        
        GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GTLTab.setBackgroundImage(nil, for: .normal)
        GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GPATab.setBackgroundImage(nil, for: .normal)

        m_tableView.reloadData()
        scrollToTop()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
//        webView.frame.size.height = 1
//        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        m_indicator.stopAnimating()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       /* let cell : ClaimProcedureTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ClaimProcedureTableViewCell
        cell.lbl1.layer.masksToBounds=true
        cell.lbl1.layer.cornerRadius=15
        cell.lbl2.layer.masksToBounds=true
        cell.lbl2.layer.cornerRadius=15
        cell.lbl3.layer.masksToBounds=true
        cell.lbl3.layer.cornerRadius=15
        cell.lbl4.layer.masksToBounds=true
        cell.lbl4.layer.cornerRadius=15
        cell.lbl5.layer.masksToBounds=true
        cell.lbl5.layer.cornerRadius=15
        cell.lbl6.layer.masksToBounds=true
        cell.lbl6.layer.cornerRadius=15
        cell.lbl7.layer.masksToBounds=true
        cell.lbl7.layer.cornerRadius=15
        
//        cell.m_expandButton.tag=indexPath.row
//        cell.m_expandButton.addTarget(self, action: #selector(expandButtonClicked), for: .touchUpInside)
        if(datasource.count>0)
        {
            cell.setContent(data: datasource[indexPath.row])
        }
        cell.m_detailView.isHidden=false
        if(m_productCode=="GMC")
        {
            m_segmentView.isHidden=false
            m_tableviewTopConstraint.constant=70
            
            cell.m_title3Lbl.isHidden=false
            cell.m_title4Lbl.isHidden=false
            cell.m_title5Lbl.isHidden=false
            cell.m_title6Lbl.isHidden=false
            cell.m_title7Lbl.isHidden=false
            cell.m_detail3Lbl.isHidden=false
            cell.m_detail4Lbl.isHidden=false
            cell.m_detail5Lbl.isHidden=false
            cell.m_detail6Lbl.isHidden=false
            cell.m_detail7Lbl.isHidden=false
            cell.m_lineLbl3.isHidden=false
            cell.m_lineLbl4.isHidden=false
            cell.lbl3.isHidden=false
            cell.lbl4.isHidden=false
            cell.lbl5.isHidden=false
            cell.lbl6.isHidden=false
            cell.lbl7.isHidden=false
            cell.m_lineLbl2.isHidden=false
            cell.m_lineLbl3.isHidden=false
            cell.m_lineLbl4.isHidden=false
            cell.m_lineLbl6.isHidden=false
            cell.m_linelbl5.isHidden=false
 
            switch selectedRowIndex
            {
            case 0:
//
                cell.m_separator.isHidden=true
                cell.m_gmcWebView.isHidden=true
                cell.m_webViewHeightConstraint.constant=0
                cell.m_bottomConstraint.constant=10
                cell.m_detailViewHeightConstraint.constant=1230
                cell.m_title1Lbl.text="Get admitted to Network Hospital"
                cell.m_title2Lbl.text="Hospital sends cashless request to TPA"
                cell.m_title3Lbl.text="Coordinate with customer service team incase of any queries"
                cell.m_title4Lbl.text="TPA authorises cashless as per policy definition"
                cell.m_title5Lbl.text="Avail treatment and get discharged"
                cell.m_title6Lbl.text="Hospital sends bill directly to TPA"
                cell.m_title7Lbl.text="TPA processes claim and pays the hospital"
                
                cell.m_detail1Lbl.text="Walk into Network Hospital of your choice and produce your Health ID card and Photo ID card at the TPA helpdesk or reception. List of Network Hospitals is available on MyBenefits App and check whether hospital is in Network of the TPA. Also carry any previous consultation notes or investigation reports if available."
                cell.m_detail2Lbl.text="Hospital will send Cashless hospitalisation request to your TPA within 24 hours from date of admission. Hospital may ask for certain deposit amount at the time of admission which will be refunded back on approval of payment from the TPA."
                cell.m_detail3Lbl.text="TPA reverts within 3 hours of receipt of cashless request. In case of any issues, your customer service representative will assist you for any queries or documentation."
                cell.m_detail4Lbl.text="TPA will authorise Cashless Amount as per your Policy Definition and send it to the hospital."
                cell.m_detail5Lbl.text="Avail treatment from the Hospital and get discharged. Before discharge, ensure that you pay for any non-medical expenses and sign relevant documents if any."
                cell.m_detail6Lbl.text="Hospital will send final bill to TPA for processing and payment."
                cell.m_detail7Lbl.text="TPA processes the claims and makes payment to the hospital as per claims admissibility."
                break
            case 1:
                cell.m_gmcWebView.scrollView.delegate = self;
                cell.m_gmcWebView.scrollView.showsVerticalScrollIndicator=false
                cell.m_gmcWebView.scrollView.isScrollEnabled=false
                cell.m_separator.isHidden=false
                cell.m_gmcWebView.isHidden=false
                cell.m_webViewHeightConstraint.constant=920
                //                cell.m_bottomConstraint.constant=10
//                cell.m_bottomConstraint.priority=UILayoutPriority(rawValue: 1000)
                cell.m_detailViewHeightConstraint.constant=1350
                cell.m_title1Lbl.text="Intimate claim to TPA"
                cell.m_title2Lbl.text="Get admitted to Hospital and pay for your treatment"
                cell.m_title3Lbl.text="Submit claim documents to TPA for processing"
                cell.m_title4Lbl.text="TPA scrutinizes claim as per policy definition"
                cell.m_title5Lbl.text="Coordinate with Customer Service team incase of queries"
                cell.m_title6Lbl.text="Claim processed and approved"
                cell.m_title7Lbl.text="Approved amount transferred to Bank account"
                
                cell.m_detail1Lbl.text="Intimate about your hospitalisation by clicking on the contact numbers available on MyBenefits App. Intimation of Hospitalisation should be done immediately on admission. In case of planned hospitalisation intimate prior to admission."
                cell.m_detail2Lbl.text="Get admitted to Hospital of your choice, and pay for your treatment."
                cell.m_detail3Lbl.text="Submit all necessary documents along with duly filled claim form to the TPA within 15 days of discharge. Checklist of claim documents is mentioned below."
                cell.m_detail4Lbl.text="TPA will determine whether the condition requiring admission & the treatment are as per policy coverage. All Non-payable expenses will not be paid."
                cell.m_detail5Lbl.text="In case if any additional documents are required, a Deficiency Letter will be mailed to you. Submit the deficient documents within the stipulated time period mentioned in the letter. If you fail to submit the documents in the mentioned timeframe, 2 more reminders will be mailed to you; subsequent to which your claim will be closed. Re-opening of the claim will be at the discretion of the Insurance Company. In case of any issues, your customer service representative will assist you for any queries or documentation."
                cell.m_detail6Lbl.text="Based on processing of the claim, a denial or approval is executed."
                cell.m_detail7Lbl.text="In case of rejection, a letter is mailed to you stating the reason for rejection. In case of approval a settlement is made by transferring the approved amount to your Bank Account."
                
//                let htmlFile = Bundle.main.path(forResource: "claimchekclist", ofType: "html")
//                let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
//                cell.m_checklistLbl.text=htmlString?.htmlToString
                

                
                if let url = Bundle.main.url(forResource: "claimchekclist", withExtension: "html")
                {
                    let request = NSURLRequest(url: url)
                    cell.m_gmcWebView.loadRequest(request as URLRequest)
                }
               
                
                break
            default:
                break
            }*/
        
        let cell : GMCTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GMCTableViewCell
        
        
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        if(selectedRowIndex==0)
        {
            //cell.imageView?.image=UIImage(named: "cashless_ios")
            cell.mainimageView?.image=UIImage(named: "cashless_ios")
            cell.imageView?.contentMode = .scaleAspectFill
            
        }
        else
        {
            cell.mainimageView?.image=UIImage(named: "Reimbursement_ios")
            cell.imageView?.contentMode = .scaleAspectFill
        }
        
        if(m_productCode=="GMC")
        {
            m_tableviewTopConstraint.constant=70
//            cell.imageView=UIImage(named: "cashless")
            
            return cell
        }
        else if(m_productCode=="GPA")
        {
            m_tableView.isHidden=true
           
           
            m_segmentView.isHidden=true
            m_tableviewTopConstraint.constant=15
//            cell.m_detailViewHeightConstraint.constant=650
            
         /*   cell.m_title3Lbl.isHidden=true
            cell.m_title4Lbl.isHidden=true
            cell.m_title5Lbl.isHidden=true
            cell.m_title6Lbl.isHidden=true
            cell.m_title7Lbl.isHidden=true
            cell.m_detail3Lbl.isHidden=true
            cell.m_detail4Lbl.isHidden=true
            cell.m_detail5Lbl.isHidden=true
            cell.m_detail6Lbl.isHidden=true
            cell.m_detail7Lbl.isHidden=true
            cell.m_lineLbl2.isHidden=true
            cell.m_lineLbl3.isHidden=true
            cell.m_lineLbl4.isHidden=true
            cell.lbl3.isHidden=true
            cell.lbl4.isHidden=true
            cell.lbl5.isHidden=true
            cell.lbl6.isHidden=true
            cell.lbl7.isHidden=true
            cell.m_lineLbl4.isHidden=true
            cell.m_lineLbl6.isHidden=true
            cell.m_linelbl5.isHidden=true
            
                cell.m_title1Lbl.text="Documentation for Death Claims"
                cell.m_title2Lbl.text="Documentation for Temporary Total Disablement(TTD)/Accidental Injury Claims"
            
                    cell.m_detail1Lbl.text="""
            1]Claim Form of the Insurance Company duly signed, with Stamp & Medical Report Form (Part II) duly signed by attending doctor with stamp
            2]Death Certificate
            3]Post-Mortem Report
            4]Incident Report
            5]Police Panchnama / F.I.R. etc
            6]Any other supporting documents related to the claim
            """
            cell.m_detail2Lbl.text="""
            1]Claim Form of the Insurance Company duly signed, with Stamp & Medical Reports Form (Part II) duly signed by the attending doctor with stamp
            2]Incident Report (HOW, WHEN & WHERE)
            3]Leave record from Employer
            4]Fitness Certificate from attending doctor
            5]Lab Reports
            6]Any other supporting documents related to the claim
            """*/
            
            
        }
        else if(m_productCode=="GTL")
        {
            m_tableView.isHidden=true
            
            m_segmentView.isHidden=true
            m_tableviewTopConstraint.constant=15
           // cell.m_detailViewHeightConstraint.constant=1100
            /*
               
                    //            cell.m_titleLbl.text="Claim through Cashless Mode"
                    cell.m_title1Lbl.text="Complete the claim form"
                    cell.m_title2Lbl.text="Arrange for appropriate documents"
                    cell.m_title3Lbl.text="Arrange for medical reports for medical related claims"
                    cell.m_title4Lbl.text="Submit required documents along with the claim form"
                
                    
                    cell.m_detail1Lbl.text="Complete the appropriate CLAIM Form depending upon which claim is to be made. Different forms are to be filled for claims against riders, death, hospital cash benefit, group term insurance and gratuity. These forms are available in the utilities section which can be downloaded from here. All details with respect to client id, policy number, policy holder name, etc should be duly filled."
                    cell.m_detail2Lbl.text="Based on the claims made, appropriate documents need to be provided. Documents can be submitted in original or photocopies, attested by a Gazetted officer, Magistrate, Tahsildar or police Sub-inspector."
                    cell.m_detail3Lbl.text="In case of hospitalization or medical related claims, produce all medical bills and medical report issued by the attending physician qualified under law to issue such a report."
                    cell.m_detail4Lbl.text="""
                    Once the form is completed and documents are in place, submit them to your HR OR to our Office. Alternatively, you can also send us your documents by post to :
                    Operations Department
                    Life and General Insurance and Reinsurance Brokers Pvt. Ltd.,
                    Unit No. 8, 7th Floor, Centre - 1,
                    World Trade Centre, Cuffe Parade,
                    Mumbai - 400005
"""
                cell.m_title3Lbl.isHidden=false
                cell.m_title4Lbl.isHidden=false
                cell.m_title5Lbl.isHidden=true
                cell.m_title6Lbl.isHidden=true
                cell.m_title7Lbl.isHidden=true
                cell.m_detail3Lbl.isHidden=false
                cell.m_detail4Lbl.isHidden=false
                cell.m_detail5Lbl.isHidden=true
                cell.m_detail6Lbl.isHidden=true
                cell.m_detail7Lbl.isHidden=true
                cell.lbl3.isHidden=false
                cell.lbl4.isHidden=false
                cell.lbl5.isHidden=true
                cell.lbl6.isHidden=true
                cell.lbl7.isHidden=true
                cell.m_lineLbl2.isHidden=false
                cell.m_lineLbl3.isHidden=false
                cell.m_lineLbl4.isHidden=true
                cell.m_lineLbl6.isHidden=true
                cell.m_linelbl5.isHidden=true
                
                m_segmentView.isHidden=true
                m_tableviewTopConstraint.constant=15
            cell.m_detailViewHeightConstraint.constant=1100*/
            
            
        }
        
        //shadowForCell(view: cell.m_backGroundView)
        return cell
    }
   /* func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if let postCell = cell as? ClaimProcedureTableViewCell
        {
            self.tableView(tableView: m_tableView, willDisplayMyCell: postCell, forRowAtIndexPath: indexPath as NSIndexPath)
        }
        
    }
    private func tableView(tableView: UITableView, willDisplayMyCell myCell: ClaimProcedureTableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        TipInCellAnimator.animate(cell: myCell)
    }*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(selectedRowIndex==0)
        {
            if(Device.IS_IPAD)
            {
               return 1000
            }
            else if(Device.IS_IPHONE_6)
            {
                return 735
            }
            else if(Device.IS_IPHONE_6P)
            {
                return 800
            }
            else if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
            {
               return 615
            }
            else if(Device.IS_IPHONE_X)
            {
               return 735
            }
            else if(Device.IS_IPHONE_XsMax)
            {
                return 800
            }
            else
            {
                return 735
            }
            
            
        }
        else
        {
            if(Device.IS_IPAD)
            {
                return 1000
            }
            else if(Device.IS_IPHONE_6)
            {
                return 820
            }
            else if(Device.IS_IPHONE_6P)
            {
                return 890
            }
            else if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
            {
                return 690
            }
            else if(Device.IS_IPHONE_X)
            {
                return 820
            }
            else if(Device.IS_IPHONE_XsMax)
            {
                return 895
            }
            else
            {
                return 820
            }
            
        }
    }
   
    @IBAction func cashlessButtonClicked(_ sender: Any)
    {
        
        selectedRowIndex = 0
        m_reimbursmentButton.backgroundColor=UIColor.white
        m_reimbursmentButton.setTitleColor(UIColor.black, for: .normal)
        m_cashlessButton.setTitleColor(UIColor.white, for: .normal)
        //m_cashlessButton.backgroundColor=hexStringToUIColor(hex: gradiantColor2)
        m_cashlessButton.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        m_reimbursmentButton.setBackgroundImage(nil, for: .normal)
        m_tableView.reloadData()
        scrollToTop()
    }
    @IBAction func reimbursmentButtonClicked(_ sender: Any)
    {
       
        selectedRowIndex = 1
        m_cashlessButton.backgroundColor=UIColor.white
        m_cashlessButton.setTitleColor(UIColor.black, for: .normal)
        m_reimbursmentButton.setTitleColor(UIColor.white, for: .normal)
        //m_reimbursmentButton.backgroundColor=hexStringToUIColor(hex: gradiantColor2)
        m_reimbursmentButton.setTitleColor(UIColor.white, for: .normal)
        m_reimbursmentButton.setBackgroundImage(#imageLiteral(resourceName: "base nav"), for: .normal)
        m_cashlessButton.setBackgroundImage(nil, for: .normal)
       
        m_tableView.reloadData()
        scrollToTop()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
     /*   if(tableView==m_tableView)
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
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        */
    }
    @objc func expandButtonClicked(sender:UIButton)
   {
    
    let index = IndexPath(row: sender.tag, section: 0)
        tableView(m_tableView, didSelectRowAt: index)
    }
    
    @IBAction func GTLTabSelected(_ sender: Any)
    {
        if isGTLDataPresent{
            GTLTabSelected()
        }else{
            self.displayActivityAlert(title: "Policy not available!")
        }
    }
    @IBAction func GPATabSelected(_ sender: Any)
    {
        if isGPADataPresent{
            GPATabSelected()
        }else{
            self.displayActivityAlert(title: "Policy not available!")
        }
    }
    @IBAction func GMCTabSelected(_ sender: Any)
    {
        if isGHIDataPresent{
            GMCTabSeleted()
        }else{
            self.displayActivityAlert(title: "Policy not available!")
        }
    }
    func GPATabSelected()
    {
        m_productCode = "GPA"
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        }
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        if policyDataArray.count > selectedIndexPosition{
            print("ClaimProcedureViewController selectedIndexPosition GPA ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("ClaimProcedureViewController selectedIndexPosition GPA ",selectedIndexPosition)
        }
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        
        
        m_GPAShadowView.dropShadow()
        m_shadowView.layer.masksToBounds = true
        m_GTLShadowView.layer.masksToBounds=true
        
        
        GPATab.layer.masksToBounds=true
        GPATab.layer.cornerRadius=cornerRadiusForView//GPATab.frame.size.height/2
        //GPATab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        GPATab.layer.borderWidth=0
        GPATab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        GPATab.setTitleColor(UIColor.white, for: .normal)
        
        //        GPALine.backgroundColor=hexStringToUIColor(hex: "4B66EA")
        //        GMCLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        //        GTLLine.backgroundColor=hexStringToUIColor(hex: "E5E5E5")
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        GTLTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        GTLTab.layer.borderColor=UIColor.white.cgColor
        GTLTab.setBackgroundImage(nil, for: .normal)
        
        m_GMCTab.layer.borderWidth = 2
        GTLTab.layer.borderWidth = 2
        
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
        GTLTab.layer.cornerRadius = cornerRadiusForView//8
        m_GPAShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        GTLTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GTLTab.setBackgroundImage(nil, for: .normal)
        
        //m_tableView.reloadData()
        //scrollToTop()
        
        
       // let htmlFile = Bundle.main.path(forResource: "gpa_instructions", ofType: "html")
        //let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
       // m_textView.text=htmlString?.htmlToString
        
        m_indicator.startAnimating()
        
        if let url = Bundle.main.url(forResource: "gpa_instructions", withExtension: "html")
        {
            let request = URLRequest(url: url)
        //m_webView.load(request)
            
            let htmlFile = Bundle.main.path(forResource: "gpa_instructions", ofType: "html")
            let htmlString = (try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8))!

            m_webView.loadHTMLStringWithMagic(content: htmlString, baseURL: url)
           
        }
         m_indicator.isHidden=false
        m_titleViewHeightConstraint.constant=0
        m_titleLbl.text="GROUP PERSONAL ACCIDENT PROCEDURE STEPS"
        m_webView.isHidden=false
        viewForWebView.isHidden = false
        
        m_ttleView.isHidden=true
        m_segmentView.isHidden=true
        m_tableView.isHidden=true
        
    }
    func scrollToTop()
    {
        let indexpath = IndexPath(row: 0, section: 0)
        m_tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
    }
    func GTLTabSelected()
    {
        
        m_productCode = "GTL"
        UserDefaults.standard.setValue(m_productCode, forKey: "PRODUCT_CODE")
        if selectedIndexPosition < 1{
            selectedIndexPosition = 0
            UserDefaults.standard.setValue(selectedIndexPosition, forKey: "Selected_Index_Position")
        }
        else{
            selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        }
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        if policyDataArray.count > selectedIndexPosition{
            print("ClaimProcedureViewController selectedIndexPosition GTL ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("ClaimProcedureViewController selectedIndexPosition GTL ",selectedIndexPosition)
        }
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
        }
        m_segmentView.isHidden=true
        m_tableView.isHidden=true
        m_GTLShadowView.dropShadow()
        m_GPAShadowView.layer.masksToBounds=true
        m_shadowView.layer.masksToBounds=true
        GTLTab.layer.masksToBounds=true
        GTLTab.layer.cornerRadius=cornerRadiusForView//GTLTab.frame.size.height/2
        //GTLTab.layer.borderColor=hexStringToUIColor(hex: "4B66EA").cgColor
        GTLTab.layer.borderWidth=0
        GTLTab.setBackgroundImage(#imageLiteral(resourceName: "base nav Rect"), for: .normal)
        GTLTab.setTitleColor(UIColor.white, for: .normal)

        
        GPATab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        m_GMCTab.setTitleColor(hexStringToUIColor(hex: "696969"), for: .normal)
        
        m_GMCTab.layer.borderColor=UIColor.white.cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        GPATab.layer.borderColor=UIColor.white.cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        
        GPATab.layer.borderWidth = 2
        m_GMCTab.layer.borderWidth = 2
        
        GPATab.layer.cornerRadius = cornerRadiusForView//8
        m_GMCTab.layer.cornerRadius = cornerRadiusForView//8
        m_GTLShadowView.layer.cornerRadius = cornerRadiusForView//8
        
        GPATab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        GPATab.setBackgroundImage(nil, for: .normal)
        m_GMCTab.layer.borderColor=UIColor(hexString: "E5E5E5").cgColor
        m_GMCTab.setBackgroundImage(nil, for: .normal)
        
        
        m_tableView.reloadData()
        scrollToTop()
        
        //let htmlFile = Bundle.main.path(forResource: "gtl_instructions", ofType: "html")
       // let htmlString = try? String(contentsOfFile: htmlFile ?? "")
        //let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        //m_textView.text=htmlString?.htmlToString
        
        m_indicator.startAnimating()
        if let url = Bundle.main.url(forResource: "gtl_instructions", withExtension: "html")
        {
            //let request = URLRequest(url: url)
            
            //m_webView.load(request)
            //m_webView.loadRequest(request as URLRequest)
            
            
                
                let htmlFile = Bundle.main.path(forResource: "gtl_instructions", ofType: "html")
                let htmlString = (try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8))!

                m_webView.loadHTMLStringWithMagic(content: htmlString, baseURL: url)
               
            }
            
        
        m_indicator.isHidden=false
        m_titleViewHeightConstraint.constant=0
        m_titleLbl.text="GROUP TERM LIFE PROCEDURE STEPS"
        m_webView.isHidden=false
        self.viewForWebView.isHidden = false

        m_ttleView.isHidden=true
        m_tableView.isHidden=true
        m_segmentView.isHidden=true
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension WKWebView {

    /// load HTML String same font like the UIWebview
    ///
    //// - Parameters:
    ///   - content: HTML content which we need to load in the webview.
    ///   - baseURL: Content base url. It is optional.
    func loadHTMLStringWithMagic(content:String,baseURL:URL?){
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        loadHTMLString(headerString + content, baseURL: baseURL)
    }
}
extension ClaimProcedureViewController {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
        self.m_indicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func addTarget()
    {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.selectPolicyName (_:)))
        self.PolicylblView.addGestureRecognizer(gesture)
        
    }
    
    @objc func selectPolicyName(_ sender:UITapGestureRecognizer)
    {
        print("selectPolicyName 1029")
        
        let policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        print("policyDataArray: ",policyDataArray)
        
        if policyDataArray.count > 0 {
            let vc  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"SelectPolicyOptionsVC") as! SelectPolicyOptionsVC
            //vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .custom
            vc.policyDelegateObj = self
            vc.policyCount = policyDataArray.count
            UserDefaults.standard.set(true, forKey: "isPolicyChanged")
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func policyChangedDelegateMethod() {
        print("Called policyChangedDelegateMethod")
        
        policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        selectedPolicyValue = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as! String
        selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? 0
        print("selectedIndexPosition is : ",selectedIndexPosition)
        
        if policyDataArray.count > selectedIndexPosition{
            print("ClaimProcedureViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        else{
            selectedIndexPosition = 0
            print("ClaimProcedureViewController selectedIndexPosition select ",selectedIndexPosition)
        }
        
        if policyDataArray.count > 0{
            policyNamelbl.text = policyDataArray[selectedIndexPosition].policyNumber
        }
        else{
            policyNamelbl.text = ""
            
        }
        
        if m_productCode == "GMC"{
            GMCTabSeleted()
        }
        else if m_productCode == "GPA"{
            GPATabSelected()
        }
        else if m_productCode == "GTL"{
            GTLTabSelected()
        }
    }
}


extension UIView {

    public func addConstaintsToSuperview(leftOffset: CGFloat, topOffset: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: self,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.superview,
                           attribute: .leading,
                           multiplier: 1,
                           constant: leftOffset).isActive = true

        NSLayoutConstraint(item: self,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.superview,
                           attribute: .top,
                           multiplier: 1,
                           constant: topOffset).isActive = true
    }

    public func addConstaints(height: CGFloat, width: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: self,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: height).isActive = true


        NSLayoutConstraint(item: self,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: width).isActive = true
    }
}
