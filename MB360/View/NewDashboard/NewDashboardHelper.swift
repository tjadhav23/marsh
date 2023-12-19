//
//  NewDashboardHelper.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 21/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import Foundation
import TrustKit
import AesEverywhere

extension NewDashboardViewController {
    func getAdminSettingsJSONNew(){
        if(isConnectedToNetWithAlert())
        {
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if userGroupChildNo != "" && userOegrpNo != ""//(userArray.count>0)
            {
//                m_employeedict=userArray[0]
//                if m_employeedict?.officialEmailID != nil {
//                    UserDefaults.standard.set(m_employeedict?.officialEmailID, forKey: "emailid")
//                }
                var oe_group_base_Info_Sr_No = String()
                var groupChildSrNo = String()
                
                if let empNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String//m_employeedict?.oe_group_base_Info_Sr_No
                {
                    oe_group_base_Info_Sr_No = String(empNo)
                }
                if let groupChlNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String//m_employeedict?.groupChildSrNo
                {
                    groupChildSrNo=String(groupChlNo)
                }
                
                
                let url = APIEngine.shared.getAdminSettingsJsonURL(grpchildsrno:groupChildSrNo, oegrpbasinfosrno: oe_group_base_Info_Sr_No)
                let urlreq = NSURL(string : url)
                print("getAdminSettingsJSONNew url: ",url)
                
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
                
                //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
                authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                print("authToken getAdminSettingsJSONNew:",authToken)
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
                    DispatchQueue.main.async{
                        //SSL Pinning
                        if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                            // Handle SSL connection failure
                            print("SSL connection error: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                self.alertForLogout(titleMsg: error.localizedDescription)
                            }
                        }
                        else if let error = error {
                            print("error:", error)
                            DispatchQueue.main.async {
                                self.m_enrollmentDetailLoader.stopAnimating()
                                getAdminStatus = false //if admin setting not working
                                self.m_windowPeriodStatusLbl.text="CLOSED"
                                m_windowPeriodStatus=false
                                self.m_daysLbl.isHidden=true
                                self.m_daysLeftTitleLbl.isHidden=true
                                self.enrollMentImageView.isHidden=false
                                self.m_enrollmentStatusLbl.text=""
                                self.m_enrollmentStatusImgview.image=UIImage(named: "")
                            }
                            self.hidePleaseWait()
                            return
                        }
                        else
                        {
                            if let httpResponse = response as? HTTPURLResponse
                            {
                                print("getAdminSettingsJSONNew httpResponse.statusCode: ",httpResponse.statusCode)
                                if httpResponse.statusCode == 200
                                {
                                    do {
                                        if let data = data, let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                                        {
                                            print("Admin Data Found")
                                            print(jsonResult)
                                            if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                                if let status = msgDict.value(forKey: "Status") as? Bool {
                                                
                                                    if status == true
                                                    {
                                                        getAdminStatus = true //if admin setting working
                                                        //Group_Admin_Basic_Settings
                                                        if let mainSettings = jsonResult.value(forKey: "Group_Admin_Basic_Settings") as? NSDictionary {
                                                            print("mainSettings: ",mainSettings)
                                                            let newDict = self.removeNSNull(from: mainSettings as! [String : Any])
                                                            print("newDict without null: ",newDict)
                                                            
                                                            UserDefaults.standard.set(newDict, forKey: "EnrollmentGroupAdminBasicSettings")
                                                            
                                                            if let isEnrollmentThroughtMB = mainSettings["ENROLLMENT_THROUGH_MB"] as? String {
                                                                if isEnrollmentThroughtMB.lowercased() == "yes" {
                                                                    UserDefaults.standard.set(true, forKey: "isEnrollmentThroughtMB")
                                                                    self.hideUnhideEnrollment()
                                                                }
                                                                else {
                                                                    UserDefaults.standard.set(false, forKey: "isEnrollmentThroughtMB")
                                                                    self.hideUnhideEnrollment()
                                                                }
                                                            }
                                                            
                                                        }
//                                                        DispatchQueue.main.async{
//                                                            //Group_Relation
//                                                            if let groupRelationArray = jsonResult.value(forKey: "Group_Relation") as? [NSDictionary] {
//                                                                let status = DatabaseManager.sharedInstance.deleteEnrollmentGroupRelationsDetails()
//                                                                for dict in groupRelationArray
//                                                                {
//                                                                    DatabaseManager.sharedInstance.saveEnrollmentGroupRelatoionsDetailsJSON(contactDict: dict)
//                                                                }
//
//                                                            }
//                                                        }
                                                        
                                                        //Enroll_Life_Event_Info
                                                        if let liveEventInfo = jsonResult.value(forKey: "Enroll_Life_Event_Info") as? NSDictionary {
                                                            
                                                            
                                                            for item in liveEventInfo{
                                                                print("Items : ",item.value as? String)
                                                                if item.value as? String != nil{
                                                                    //UserDefaults.standard.set(liveEventInfo, forKey: "EnrollmentLifeEventInfo")
                                                                }
                                                            }
                                                            
                                                        }
                                                        
                                                        //Enrollment_Misc_Info
                                                        if let miscInfo = jsonResult.value(forKey: "Enrollment_Misc_Info") as? NSDictionary {
                                                            UserDefaults.standard.set(miscInfo, forKey: "EnrollmentMiscInformation")
                                                        }
                                                        
                                                        //Enroll_Topup_Options
                                                        if let dictMainTopUp = jsonResult.value(forKey: "Enroll_Topup_Options") as? NSDictionary {
                                                            if let topUPAvailabilityDict = dictMainTopUp.value(forKey: "TopupApplicability_data") as? NSDictionary {
                                                                /*
                                                                 "GMCTopup": "YES",
                                                                 "GPATopup": "NO",
                                                                 "GTLTopup": "NO"
                                                                 */
                                                            }
                                                      
                                                        }//dictMainTopUp
                                                            
                                                        //WINDOW PERIOD INFO
                                                        //Group_Window_Period_Info
                                                        if let windPerInfo = jsonResult.value(forKey: "Group_Window_Period_Info") as? NSDictionary {
                                                            /*
                                                            if let openWindPeriodInfo = windPerInfo.value(forKey: "OpenEnroll_WP_Information_data") as? NSDictionary {
                                                                self.openEnrollmentDict = openWindPeriodInfo as! [String : String]
                                                                
                                                                UserDefaults.standard.set(openWindPeriodInfo, forKey: "OpenEnroll_WP_Information_data")
                                                            }
                                                             */
                                                            /*
                                                            if let wpForNewJoinee = windPerInfo.value(forKey: "WP_ForNewJoinee_data") as? NSDictionary {
                                                                self.newJoineeEnrollmentDict = wpForNewJoinee as! [String : String]
                                                                UserDefaults.standard.set(wpForNewJoinee, forKey: "WP_ForNewJoinee_data")

                                                            }
                                                             */
                                                            if let openWindPeriodInfo = windPerInfo.value(forKey: "OpenEnroll_WP_Information_data") as? NSDictionary,
                                                               let unwrappedDict = openWindPeriodInfo as? [String: String] {
                                                                self.openEnrollmentDict = unwrappedDict
                                                                UserDefaults.standard.set(openWindPeriodInfo, forKey: "OpenEnroll_WP_Information_data")
                                                            }
                                                            
                                                            if let wpForNewJoinee = windPerInfo.value(forKey: "WP_ForNewJoinee_data") as? NSDictionary,
                                                               let unwrappedDict = wpForNewJoinee as? [String: String] {
                                                                self.newJoineeEnrollmentDict = unwrappedDict
                                                                UserDefaults.standard.set(wpForNewJoinee, forKey: "WP_ForNewJoinee_data")
                                                            }

                                                            
                                                            //WP_DurationForOpting_ParentalCoverage_data
                                                            if let wpForParental = windPerInfo.value(forKey: "WP_DurationForOpting_ParentalCoverage_data") as? NSDictionary {
                                                                //UserDefaults.standard.set(wpForParental, forKey: "WP_DurationForOpting_ParentalCoverage_data")
                                                                
                                                            }
                                                            
                                                            //WP_DurationForOpting_TopupCoverage_data
                                                            if let wpForTopUpCoverage = windPerInfo.value(forKey: "WP_DurationForOpting_TopupCoverage_data") as? NSDictionary {
                                                                
                                                            }
                                                        }
                                                        
                                                        if let isEnrollmentThroughMB = UserDefaults.standard.value(forKey: "isEnrollmentThroughtMB") as? Bool {
                                                            if isEnrollmentThroughMB {
                                                                //Uncomment after API working
                                                                //Enrollmented closed in PIng
                                                                // self.getGHITopUpOptionsFromServer()
                                                                self.setEnrollmentData()
                                                            }
                                                            else {
                                                                m_windowPeriodStatus = false
                                                                self.hideUnhideEnrollment()
                                                            }
                                                        }
                                                        
                                                        
                                                            
                                                        self.getPolicyCoveragesDetails_Data()
                                                        
                                                        
                                                    }
                                                    else{
                                                        print("Status false",status)
                                                        self.m_enrollmentDetailLoader.stopAnimating()
                                                        getAdminStatus = false //if admin setting not working
                                                        self.m_windowPeriodStatusLbl.text="CLOSED"
                                                        m_windowPeriodStatus=false
                                                        self.m_daysLbl.isHidden=true
                                                        self.m_daysLeftTitleLbl.isHidden=true
                                                        self.enrollMentImageView.isHidden=false
                                                        self.m_enrollmentStatusLbl.text=""
                                                        self.m_enrollmentStatusImgview.image=UIImage(named: "")
                                                        self.getPolicyCoveragesDetails_Data()
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                            print(jsonResult)
                                        }
                                    }catch{
                                        
                                    }
                                }
                                else if httpResponse.statusCode == 401{
                                    self.retryCountAdmin+=1
                                    print("retryCountAdmin: ",self.retryCountAdmin)
                                    
                                    if self.retryCountAdmin <= self.maxRetryAdmin{
                                        print("Some error occured getAdminSettingsJSONNew",httpResponse.statusCode)
                                        self.getUserTokenGlobal(completion: { (data,error) in
                                            self.getAdminSettingsJSONNew()
                                        })
                                    }
                                    else{
                                        print("retryCountAdmin 401 else : ",self.retryCountAdmin)
                                        
                                            self.m_enrollmentDetailLoader.stopAnimating()
                                            getAdminStatus = false //if admin setting not working
                                            self.m_windowPeriodStatusLbl.text="CLOSED"
                                            m_windowPeriodStatus=false
                                            self.m_daysLbl.isHidden=true
                                            self.m_daysLeftTitleLbl.isHidden=true
                                            self.enrollMentImageView.isHidden=false
                                            self.m_enrollmentStatusLbl.text=""
                                            self.m_enrollmentStatusImgview.image=UIImage(named: "")
                                            self.getPolicyCoveragesDetails_Data()
                                    }
                                    
                                    /*
                                     self.getUserTokenGlobal(completion: { (data,error) in
                                     self.getNewLoadSessionDataFromServerNew()
                                     })
                                     */
                                }
                                else if httpResponse.statusCode == 400{
                                    DispatchQueue.main.sync(execute: {
                                        
                                        self.retryCountAdmin+=1
                                        print("retryCountAdmin: ",self.retryCountAdmin)
                                        
                                        if self.retryCountAdmin <= self.maxRetryAdmin{
                                            print("Some error occured getAdminSettingsJSONNew",httpResponse.statusCode)
                                            self.getUserTokenGlobal(completion: { (data,error) in
                                                self.getAdminSettingsJSONNew()
                                            })
                                        }
                                        else{
                                            print("retryCountAdmin 400 else : ",self.retryCountAdmin)
                                                self.m_enrollmentDetailLoader.stopAnimating()
                                                getAdminStatus = false //if admin setting not working
                                                self.m_windowPeriodStatusLbl.text="CLOSED"
                                                m_windowPeriodStatus=false
                                                self.m_daysLbl.isHidden=true
                                                self.m_daysLeftTitleLbl.isHidden=true
                                                self.enrollMentImageView.isHidden=false
                                                self.m_enrollmentStatusLbl.text=""
                                                self.m_enrollmentStatusImgview.image=UIImage(named: "")
                                                self.getPolicyCoveragesDetails_Data()
                                            
                                        }
                                    })
                                }
                                else{
                                    self.hidePleaseWait()
                                    
                                    print("else executed",httpResponse.statusCode)
                                    if httpResponse.statusCode == 429{
                                        self.displayActivityAlert(title: "Too many request, please try again later")
                                    }
                                    else{
                                        //self.displayActivityAlert(title: m_errorMsg)
                                        print("m_errorMsg: ",m_errorMsg)
                                    }
                                    
                                    //Testing
                                    //let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                    
                                    //enterOTPVC.mobileNumber=self.txtEmailId.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
                                }
                            }
                            else {
                                print("Can't cast response to NSHTTPURLResponse")
                                //self.displayActivityAlert(title: m_errorMsg)
                                print("m_errorMsg: ",m_errorMsg)
                                self.hidePleaseWait()
                            }
                        }
                    }
                }
                apiRequestAdminSetting = task
                apiRequestAdminSetting?.resume()
                
            }
        }
    }
    
    func getAdminSettingsJSON() {
        
        
        if(isConnectedToNetWithAlert())
        {
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                m_employeedict=userArray[0]
                if m_employeedict?.officialEmailID != nil {
                    UserDefaults.standard.set(m_employeedict?.officialEmailID, forKey: "emailid")
                }
                var oe_group_base_Info_Sr_No = String()
                var groupChildSrNo = String()
                
                if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
                {
                    oe_group_base_Info_Sr_No = String(empNo)
                }
                if let groupChlNo = m_employeedict?.groupChildSrNo
                {
                    groupChildSrNo=String(groupChlNo)
                }
                
                
                let url = APIEngine.shared.getAdminSettingsJsonURL(grpchildsrno:groupChildSrNo, oegrpbasinfosrno: oe_group_base_Info_Sr_No)
                let urlreq = NSURL(string : url)
                
                //self.showPleaseWait(msg: "")
                print("getAdminSettingsJsonURL : \(url)")
                
                EnrollmentServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (data, error) in
                    
                    if error != nil
                    {
                        print("error ",error!)
                        //self.hidePleaseWait()
                        //self.displayActivityAlert(title: m_errorMsg)
                        print("m_errorMsg: ",m_errorMsg)
                    }
                    else
                    {
                        // self.hidePleaseWait()
                        print("found Admin Setting....")
                        
                        do {
                            print("Started parsing Admin Settings Session...")
                            print(data)
                            
                            if let jsonResult = data as? NSDictionary
                            {
                                print("Admin Data Found")
                                if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                    if let status = msgDict.value(forKey: "Status") as? Bool {
                                    
                                        if status == true
                                        {
                                            getAdminStatus = true //if admin setting working
                                            //Group_Admin_Basic_Settings
                                            if let mainSettings = jsonResult.value(forKey: "Group_Admin_Basic_Settings") as? NSDictionary {
                                                print("mainSettings: ",mainSettings)
                                                //UserDefaults.standard.set(mainSettings, forKey: "EnrollmentGroupAdminBasicSettings")
                                                
                                                if let isEnrollmentThroughtMB = mainSettings["ENROLLMENT_THROUGH_MB"] as? String {
                                                    if isEnrollmentThroughtMB.lowercased() == "yes" {
                                                        UserDefaults.standard.set(true, forKey: "isEnrollmentThroughtMB")
                                                        self.hideUnhideEnrollment()
                                                    }
                                                    else {
                                                        UserDefaults.standard.set(false, forKey: "isEnrollmentThroughtMB")
                                                        self.hideUnhideEnrollment()
                                                    }
                                                }
                                                
                                            }
                                            
                                            //Group_Relation
                                            if let groupRelationArray = jsonResult.value(forKey: "Group_Relation") as? [NSDictionary] {
                                                let status = DatabaseManager.sharedInstance.deleteEnrollmentGroupRelationsDetails()
                                                for dict in groupRelationArray
                                                {
                                                    DatabaseManager.sharedInstance.saveEnrollmentGroupRelatoionsDetailsJSON(contactDict: dict)
                                                }
                                                
                                            }
                                            
                                            //Enroll_Life_Event_Info
                                            if let liveEventInfo = jsonResult.value(forKey: "Enroll_Life_Event_Info") as? NSDictionary {
                                                
                                                
                                                for item in liveEventInfo{
                                                    print("Items : ",item.value as? String)
                                                    if item.value as? String != nil{
                                                        UserDefaults.standard.set(liveEventInfo, forKey: "EnrollmentLifeEventInfo")
                                                    }
                                                }
                                                
                                            }
                                            
                                            //Enrollment_Misc_Info
                                            if let miscInfo = jsonResult.value(forKey: "Enrollment_Misc_Info") as? NSDictionary {
                                                UserDefaults.standard.set(miscInfo, forKey: "EnrollmentMiscInformation")
                                            }
                                            
                                            //Enroll_Topup_Options
                                            if let dictMainTopUp = jsonResult.value(forKey: "Enroll_Topup_Options") as? NSDictionary {
                                               if let topUPAvailabilityDict = dictMainTopUp.value(forKey: "TopupApplicability_data") as? NSDictionary {
                                                    /*
                                                 "GMCTopup": "YES",
                                                 "GPATopup": "NO",
                                                 "GTLTopup": "NO"
                                                 */
                                                }
                                          
                                                //TopupSumInsured_Cls_data
                                                /*
                                                if let topUPEnrollDict = dictMainTopUp.value(forKey: "TopupSumInsured_Cls_data") as? NSDictionary {
                                                    if let gmcTopUpArray = topUPEnrollDict.value(forKey: "GMCTopupOptions_data") as? [NSDictionary] {
                                                        for gmcOuter in gmcTopUpArray {
                                                            let baseGmc = gmcOuter.value(forKey: "BASE_SI") as? String
                                                            print("BASE_SI====\(baseGmc)")
                                                            if let topUpGMCArray = gmcOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                            {
                                                                
                                                                DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GMC")
                                                                for topUpObjDict in topUpGMCArray {
                                                                    let userDict = ["productCode":"GMC","BaseSumInsured":baseGmc,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                    DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict as NSDictionary)

                                                                }
                                                            }
                                                            
                                                            
                                                        }
                                                    }
                                                
                                                    if let gpaTopUpArray = topUPEnrollDict.value(forKey: "GPATopupOptions_data") as? [NSDictionary] {
                                                        for gpaOuter in gpaTopUpArray {
                                                            let baseGpa = gpaOuter.value(forKey: "BASE_SI") as? String
                                                            print("BASE_SI====\(baseGpa)")
                                                            if let topUpGPAArray = gpaOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                            {
                                                                DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GPA")

                                                                for topUpObjDict in topUpGPAArray {
                                                                    let userDict = ["productCode":"GPA","BaseSumInsured":baseGpa,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                    DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict as NSDictionary)

                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    if let gtlTopUpArray = topUPEnrollDict.value(forKey: "GTLTopupOptions_data") as? [NSDictionary] {
                                                        for gtlOuter in gtlTopUpArray {
                                                            let baseGtl = gtlOuter.value(forKey: "BASE_SI") as? String
                                                            print("BASE_SI====\(baseGtl)")
                                                            if let topUpGTLArray = gtlOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                            {
                                                                DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GTL")

                                                                for topUpObjDict in topUpGTLArray {
                                                                    let userDict = ["productCode":"GTL","BaseSumInsured":baseGtl,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                    DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict as NSDictionary)

                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    
                                                }
                                            */
                                            }//dictMainTopUp
                                                
                                            //WINDOW PERIOD INFO
                                            //Group_Window_Period_Info
                                            if let windPerInfo = jsonResult.value(forKey: "Group_Window_Period_Info") as? NSDictionary {
                                                
                                                /*
                                                if let openWindPeriodInfo = windPerInfo.value(forKey: "OpenEnroll_WP_Information_data") as? NSDictionary {
                                                    self.openEnrollmentDict = openWindPeriodInfo as! [String : String]
                                                    
                                                    UserDefaults.standard.set(openWindPeriodInfo, forKey: "OpenEnroll_WP_Information_data")
                                                }
                                                
                                                if let wpForNewJoinee = windPerInfo.value(forKey: "WP_ForNewJoinee_data") as? NSDictionary {
                                                    self.newJoineeEnrollmentDict = wpForNewJoinee as! [String : String]
                                                    UserDefaults.standard.set(wpForNewJoinee, forKey: "WP_ForNewJoinee_data")

                                                }
                                                */
                                                if let openWindPeriodInfo = windPerInfo.value(forKey: "OpenEnroll_WP_Information_data") as? NSDictionary,
                                                   let unwrappedDict = openWindPeriodInfo as? [String: String] {
                                                    self.openEnrollmentDict = unwrappedDict
                                                    UserDefaults.standard.set(openWindPeriodInfo, forKey: "OpenEnroll_WP_Information_data")
                                                }
                                                
                                                if let wpForNewJoinee = windPerInfo.value(forKey: "WP_ForNewJoinee_data") as? NSDictionary,
                                                   let unwrappedDict = wpForNewJoinee as? [String: String] {
                                                    self.newJoineeEnrollmentDict = unwrappedDict
                                                    UserDefaults.standard.set(wpForNewJoinee, forKey: "WP_ForNewJoinee_data")
                                                }
                                                
                                                //                                                if let wpForNewJoinee = windPerInfo.value(forKey: "WP_ForNewJoinee_data") as? NSDictionary {
                                                //
                                                //                                                }
                                                
                                                //WP_DurationForOpting_ParentalCoverage_data
                                                if let wpForParental = windPerInfo.value(forKey: "WP_DurationForOpting_ParentalCoverage_data") as? NSDictionary {
                                                    //UserDefaults.standard.set(wpForParental, forKey: "WP_DurationForOpting_ParentalCoverage_data")
                                                    
                                                }
                                                
                                                //WP_DurationForOpting_TopupCoverage_data
                                                if let wpForTopUpCoverage = windPerInfo.value(forKey: "WP_DurationForOpting_TopupCoverage_data") as? NSDictionary {
                                                    
                                                }
                                            }
                                            
                                            if let isEnrollmentThroughMB = UserDefaults.standard.value(forKey: "isEnrollmentThroughtMB") as? Bool {
                                                if isEnrollmentThroughMB {
                                                    //Uncomment after API working
                                                    //Enrollmented closed in PIng
                                                    // self.getGHITopUpOptionsFromServer()
                                                    self.setEnrollmentData()
                                                }
                                                else {
                                                    m_windowPeriodStatus = false
                                                    self.hideUnhideEnrollment()
                                                }
                                            }
                                            
                                            
                                                
                                            
                                            self.getClaims()
                                            //self.getAllQueries()
                                            self.getHospitalsCount()
                                            
                                        }
                                        else{
                                            print("Status false",status)
                                            self.m_enrollmentDetailLoader.stopAnimating()
                                            getAdminStatus = false //if admin setting not working
                                        }
                                        
                                    }
                                    
                                    
                                }
                                
                                print(jsonResult)
                            }//if let dict
                        }//do
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }
                }
            }//userArray.count
        }
        
    }
    
    
    //MARK:- GHI TopUp
        func getGHITopUpOptionsFromServer()
        {
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                m_employeeDict=userArray[0]
            }
            
            
            if(isConnectedToNetWithAlert())
            {
                
                if(userArray.count>0)
                {
                    
                    
                    var oe_group_base_Info_Sr_No = String()
                    var groupChildSrNo = String()
                    var empSrNo = String()
                    var empIDNo = String()
                    
                    if let empNo = m_employeeDict?.oe_group_base_Info_Sr_No
                    {
                        oe_group_base_Info_Sr_No = String(empNo)
                    }
                    if let groupChlNo = m_employeeDict?.groupChildSrNo
                    {
                        groupChildSrNo=String(groupChlNo)
                    }
                    if let empsrno = m_employeeDict?.empSrNo
                    {
                        empSrNo=String(empsrno)
                    }
                    if let empidno = m_employeeDict?.empIDNo
                    {
                        empIDNo=String(empidno)
                    }
                    
                    
                    
                    let url = APIEngine.shared.getNewTopUpOptionsJsonURL(grpchildsrno: groupChildSrNo, oegrpbasinfosrno:oe_group_base_Info_Sr_No , employeesrno: empSrNo, empIdenetificationNo: empIDNo)
                    
                    let urlreq = NSURL(string : url)
                    
                    //self.showPleaseWait(msg: "")
                    print("getGHITopUpOptionsFromServer: ",url)
                    
                        let dict = ["":""]

                        EnrollmentServerRequestManager.serverInstance.postDictionaryDataToServer(url: url, dictionary: dict as NSDictionary, view: self) { (data, error) in

                            
                        if error != nil
                        {
                            print("error ",error!)
                            //self.hidePleaseWait()
                            //self.displayActivityAlert(title: m_errorMsg)
                            print("m_errorMsg: ",m_errorMsg)
                        }
                        else
                        {
                            // self.hidePleaseWait()
                            print("found Admin Setting....")
                            
                            do {
                                print("Started parsing Top Up...")
                                print(data)
                                
                                if let jsonResult = data as? NSDictionary
                                {
                                    print("Admin Data Found")
                                    if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                        if let status = msgDict.value(forKey: "Status") as? Bool {
                                            
                                            if status == true
                                            {
                                                print(jsonResult)
                                                
                                                
                                                UserDefaults.standard.set(false, forKey:"gmcPolicy")
                                                UserDefaults.standard.set(false, forKey:"gpaPolicy")
                                                UserDefaults.standard.set(false, forKey:"gtlPolicy")

                                                
                                                if let IsEnrollmentSaved = jsonResult.value(forKey: "IsEnrollmentSaved") as? Int {
                                                    UserDefaults.standard.set(String(IsEnrollmentSaved), forKey: "IsEnrollmentSaved")
                                                    if IsEnrollmentSaved == 1 {
                                                        self.m_enrollmentStatus = true
                                                    }
                                                    else {
                                                        self.m_enrollmentStatus = false
                                                    }

                                                    
                                                }
                                                
                                                if let IsWindowPeriodOpen = jsonResult.value(forKey: "IsWindowPeriodOpen") as? Int {
                                                    UserDefaults.standard.set(String(IsWindowPeriodOpen), forKey: "IsWindowPeriodOpen")
                                                   
                                                    if IsWindowPeriodOpen == 1 {
                                                        self.isWindowPeriodOpen = true
                                                        m_windowPeriodStatus = true
                                                    }
                                                    else {
                                                        self.isWindowPeriodOpen = false
                                                        m_windowPeriodStatus = false
                                                    }
                                                }
                                                
                                                if let ExtGroupSrNo = jsonResult.value(forKey: "ExtGroupSrNo") as? Int {
                                                    UserDefaults.standard.set(String(ExtGroupSrNo), forKey: "ExtGroupSrNoEnrollment")
                                                }
                                                
                                                
                                                //SumInsuredData
                                                if let tempDict = jsonResult.value(forKey: "SumInsuredData") as? NSDictionary {
                                                if let dictMainTopUp = tempDict.value(forKey: "Enroll_Topup_Options") as? NSDictionary {
                                                    
                                                var gmcTopUp = false
                                                var gpaTopUp = false
                                                var gtlTopUp = false
                                                
                                                UserDefaults.standard.set("0", forKey:"ghiSelectedTopup")
                                                UserDefaults.standard.set("0", forKey:"gpaSelectedTopup")
                                                UserDefaults.standard.set("0", forKey:"gtlSelectedTopup")

                                                
                                                if let topUpApplicabilityDict = dictMainTopUp.value(forKey: "TopupApplicability_data") as? NSDictionary {
                                                    if let gmc = topUpApplicabilityDict.value(forKey: "GMCTopup") as? String {
                                                        if gmc == "YES" {
                                                            gmcTopUp = true
                                                            UserDefaults.standard.set(true, forKey:"gmcPolicy")

                                                        }
                                                    }
                                                    
                                                    if let gpa = topUpApplicabilityDict.value(forKey: "GPATopup") as? String {
                                                        if gpa == "YES" {
                                                            gpaTopUp = true
                                                            UserDefaults.standard.set(true, forKey:"gpaPolicy")

                                                        }
                                                    }
                                                    
                                                    if let gtl = topUpApplicabilityDict.value(forKey: "GTLTopup") as? String {
                                                        if gtl == "YES" {
                                                            gtlTopUp = true
                                                            UserDefaults.standard.set(true, forKey:"gtlPolicy")

                                                        }
                                                    }
                                                    
                                                }
                                                
                                                
                                                 if let topUPEnrollDict = dictMainTopUp.value(forKey: "TopupSumInsured_Cls_data") as? NSDictionary
                                                {
                                                    if gmcTopUp == true {
                                                        if let gmcTopUpArray = topUPEnrollDict.value(forKey: "GMCTopupOptions_data") as? [NSDictionary] {
                                                            for gmcOuter in gmcTopUpArray {
                                                                let baseGmc = gmcOuter.value(forKey: "BASE_SI") as? String
                                                                print("BASE_SI====\(baseGmc)")
                                                                UserDefaults.standard.set(baseGmc, forKey: "baseGmc")
                                                                
                                                                if let topUpGMCArray = gmcOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                                {
                                                                    DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GMC")
                                                                    for topUpObjDict in topUpGMCArray {
                                                                        let userDict = ["productCode":"GMC","BaseSumInsured":baseGmc,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                        
                                                        if let isOpted = topUpObjDict.value(forKey: "Opted") as? String {
                                                        if isOpted == "YES" {
                                                        UserDefaults.standard.set(topUpObjDict.value(forKey: "TSumInsured"), forKey: "ghiSelectedTopup")
                                                        }
                                                        }
                                                                        DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict as NSDictionary)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    if gpaTopUp == true {
                                                        if let gpaTopUpArray = topUPEnrollDict.value(forKey: "GPATopupOptions_data") as? [NSDictionary] {
                                                            for gpaOuter in gpaTopUpArray {
                                                                let baseGpa = gpaOuter.value(forKey: "BASE_SI") as? String
                                                                print("BASE_SI====\(baseGpa)")
                                                                
                                                                if let topUpGPAArray = gpaOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                                {
                                                                    DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GPA")
                                                                    
                                                                    for topUpObjDict in topUpGPAArray {
                                                                        let userDict1 = ["productCode":"GPA","BaseSumInsured":baseGpa,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                        
                                                                    if let isOpted = topUpObjDict.value(forKey: "Opted") as? String {
                                                                    if isOpted == "YES" {
                                                                    UserDefaults.standard.set(topUpObjDict.value(forKey: "TSumInsured"), forKey: "gpaSelectedTopup")
                                                                    }
                                                                    }
                                                                        DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict1 as NSDictionary)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    
                                                    if gtlTopUp == true {
                                                        if let gtlTopUpArray = topUPEnrollDict.value(forKey: "GTLTopupOptions_data") as? [NSDictionary] {
                                                            for gtlOuter in gtlTopUpArray {
                                                                let baseGtl = gtlOuter.value(forKey: "BASE_SI") as? String
                                                                print("BASE_SI====\(baseGtl)")
                                                                
                                                                if let topUpGTLArray = gtlOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                                {
                                                                    DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GTL")
                                                                    for topUpObjDict in topUpGTLArray {
                                                                        let userDict2 = ["productCode":"GTL","BaseSumInsured":baseGtl,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                        if let isOpted = topUpObjDict.value(forKey: "Opted") as? String {
                                                                            if isOpted == "YES" {
                                                                                UserDefaults.standard.set(topUpObjDict.value(forKey: "TSumInsured"), forKey: "gtlSelectedTopup")
                                                                            }
                                                                        }
                                                                        DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict2 as NSDictionary)
                                                                        
                                                                        
                                                                        
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }//topUPEnrollDict

           
                                                
                                                self.setEnrollmentData()
                                               // let indexset = IndexSet(integer: 1)
                                                }
                                                //self.tableView.reloadSections([1], with: .none)
                                            }
                                            else {
                                                //No Data found
                                            }
                                        }//status
                                    }//msgDict
                                }//jsonResult
                                }
                            }
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                            }
                        }//else
                    }//server call
                }//userArray
            }
    }
        
    func getNewLoadSessionDataFromServerNew() {
        if(isConnectedToNetWithAlert())
        {
            var loginType =  UserDefaults.standard.value(forKey: "loginTypeForJson") as? String ?? ""
            //let url = APIEngine.shared.getLoadSessionJsonURL(mobileNo:mobNo)
            print("logintype",loginType)
            var loginwith =  UserDefaults.standard.value(forKey: "loginType") as? String ?? ""
            print("loginwith",loginwith)

            m_loginIDMobileNumber = UserDefaults.standard.value(forKey: "m_loginIDMobileNumber") as? String ?? ""
            m_loginIDEmail = UserDefaults.standard.value(forKey: "m_loginIDEmail") as? String ?? ""
          
            print("m_loginIDMobileNumber: ",m_loginIDMobileNumber," m_loginIDEmail: ",m_loginIDEmail," m_loginIDWeb: ",m_loginIDWeb)
            
            var url = ""
            
            if loginwith.lowercased() == "mobileno"{
                
                var encryptMobNo = try! AES256.encrypt(input: m_loginIDMobileNumber, passphrase: m_passphrase_Portal)
                print("m_loginIDMobileNumber encrypt: ",encryptMobNo)
                
                let allowedCharacterSet = CharacterSet.alphanumerics // Set of allowed characters
                let urlEncodedNoString = encryptMobNo.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                print("urlEncodedString: ",urlEncodedNoString)
                
                url = APIEngine.shared.getLoadSessionJsonURLPortal(mobileNo:urlEncodedNoString!)
            }else if loginwith.lowercased() == "email"{
                
                var encryptEmail = try! AES256.encrypt(input: m_loginIDEmail, passphrase: m_passphrase_Portal)
                let allowedCharacterSet = CharacterSet.alphanumerics // Set of allowed characters
                let urlEncodedNoString = encryptEmail.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                print("urlEncodedString: ",urlEncodedNoString)
                
                url = APIEngine.shared.getLoadSessionJsonURLPortal(emailId:urlEncodedNoString!)
            }else if loginwith.lowercased() == "web"{
                var encryptWeb = try! AES256.encrypt(input: m_loginIDWeb, passphrase: m_passphrase_Portal)
                let allowedCharacterSet = CharacterSet.alphanumerics // Set of allowed characters
                let urlEncodedNoString = encryptWeb.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                print("urlEncodedString: ",urlEncodedNoString)
                url = APIEngine.shared.getLoadSessionJsonURLPortal(webLogin:urlEncodedNoString!)
            }
             
            let urlreq = NSURL(string : url)
            
            //self.showPleaseWait(msg: "")
            print("533 getNewLoadSessionDataFromServerNew url: \(url)")
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?
            request.httpMethod = "post"
            
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
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
            print("authToken getNewLoadSessionDataFromServerNew:",authToken)
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
          
  
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                //SSL Pinning
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                    // Handle SSL connection failure
                    print("SSL connection error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.alertForLogout(titleMsg: error.localizedDescription)
                    }
                }
                else if let error = error {
                    print("getNewLoadSessionDataFromServerNew() error:", error)
                    DispatchQueue.main.async {
                        self.m_enrollmentDetailLoader.stopAnimating()
                        getAdminStatus = false //if admin setting not working
                        self.m_windowPeriodStatusLbl.text="CLOSED"
                        m_windowPeriodStatus=false
                        self.m_daysLbl.isHidden=true
                        self.m_daysLeftTitleLbl.isHidden=true
                        self.enrollMentImageView.isHidden=false
                        self.m_enrollmentStatusLbl.text=""
                        self.m_enrollmentStatusImgview.image=UIImage(named: "")
                        self.dataCalling()
                    }
                    return
                }
                else{
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        print("getNewLoadSessionDataFromServerNew httpResponse.statusCode: ",httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            self.retryCountLoadsession = 0
                            self.hidePleaseWait()
                            print("found some")
                            
                            do {
                                
                                guard let data = data else { return }
                                print(data)
                                
                                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                                print("Json: ",json)
                                // let user = try! JSONDecoder().decode(Welcome.self, from: data ?? Data())
                                
                                if let jsonResult = json as? NSDictionary
                                {
                                    print("Data Found")
                                    
                                    print(jsonResult)
                                    if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                        if let Message = msgDict.value(forKey: "Message") as? String{
                                            if Message == "LoadSession Details found"{
                                                if let statusVal = msgDict.value(forKey: "Status") as? Bool {
                                                    print("statusVal: ",statusVal)
                                                    var status = UserDefaults.standard.set(statusVal, forKey: "loadsessionStatusValue")
                                                    print("UserDefault loadsessionStatusValue API: ",status)
                                                    if statusVal == true {
                                                        
                                                        if let groupInfo = jsonResult.value(forKey: "Group_Info_data") as? NSDictionary {
                                                            
                                                            if let groupCodeString = groupInfo.value(forKey:"GROUPCODE") as? String {
                                                                GROUPCODE = groupCodeString
                                                                UserDefaults.standard.set(GROUPCODE, forKey: "groupCodeString")
                                                            }
                                                            
                                                        }
                                                        
                                                        //Group Products array
                                                        if let GroupProductsArr = jsonResult.value(forKey: "GroupProducts") as? NSArray {
                                                            
                                                            m_productCodeArray.removeAll()
                                                            UserDefaults.standard.setValue(m_productCodeArray, forKey: "ProductsArray")
                                                            DispatchQueue.main.async{
                                                                for dict in GroupProductsArr {
                                                                    if let tempd = dict as? NSDictionary {
                                                                        if tempd.value(forKey: "PRODUCT_CODE") as? String == "GMC"{
                                                                            if tempd.value(forKey: "ACTIVE") as? String  == "1"{
                                                                                m_productCodeArray.append("GMC")
                                                                                
                                                                            }
                                                                        }
                                                                        else if tempd.value(forKey: "PRODUCT_CODE") as? String  == "GPA"{
                                                                            if tempd.value(forKey: "ACTIVE") as? String  == "1"{
                                                                                m_productCodeArray.append("GPA")
                                                                            }
                                                                        }
                                                                        else{
                                                                            if tempd.value(forKey: "ACTIVE") as? String  == "1"{
                                                                                m_productCodeArray.append("GTL")
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                    UserDefaults.standard.setValue(m_productCodeArray, forKey: "ProductsArray")
                                                                    m_productCodeArray=UserDefaults.standard.value(forKey: "ProductsArray") as! Array<String>
                                                                }
                                                            }
                                                        }
                                                        
                                                        if let Group_PoliciesArr = jsonResult.value(forKey: "Group_Policies") as? NSArray {
                                                            
                                                        }
                                                        
                                                        
                                                        //Group_Policies_Employees_Dependants
                                                        
                                                        //var arrData = DatabaseManager.sharedInstance.retrievePersonDetails(productCode: "")
                                                        //print("existing savepersondetailsjson",arrData)
                                                        
                                                            var statusDelDep : Bool = false
                                                            //DispatchQueue.main.async{
                                                            statusDelDep = DatabaseManager.sharedInstance.deletePersonDetails(personSrNo: "")
                                                            //}
                                                            if(statusDelDep)
                                                            {
                                                                print("Dependant found....")
                                                                
                                                                if let groupPolicyMainDepDictArray = jsonResult.value(forKey: "Group_Policies_Employees_Dependants") as? NSArray {
                                                                    print(groupPolicyMainDepDictArray)
                                                                    
                                                                    if groupPolicyMainDepDictArray.count > 0 {
                                                                        self.dependantsDictArray?.removeAll()
                                                                        print("saved dependant data...")
                                                                        if let mainDict = groupPolicyMainDepDictArray[0] as? NSDictionary {
                                                                            if let mainGmcPEDict = mainDict.value(forKey: "GroupGMCPolicyEmpDependants_data") as? NSArray {
                                                                                let dictArray = mainGmcPEDict as? [[String: String]] ?? []

                                                                                   // Save the array in UserDefaults
                                                                                   UserDefaults.standard.set(dictArray, forKey: "groupGMCPolicyEmpDependants_UserDefault")
                                                                                for innerDict1 in mainGmcPEDict {
                                                                                    self.dependantsDictArray?.append(innerDict1 as? NSDictionary as! [String : String])
                                                                                    //DispatchQueue.main.async{
                                                                                    //DatabaseManager.sharedInstance.savePersonDetailsJSON(personDetailsDict: innerDict1 as! NSDictionary)
                                                                                    var arr = innerDict1 as? [String:String]
                                                                                    print("arr GroupGMCPolicyEmpDependants_data :",arr)
                                                                                    userEmployeeSrno = (arr!["EMPLOYEE_SR_NO"] as? String)!
                                                                                    print("userEmployeeSrno: ",userEmployeeSrno)
                                                                                    UserDefaults.standard.setValue(userEmployeeSrno, forKey: "userEmployeeSrnoValue")
                                                                                    
                                                                                    
                                                                                    if arr!["RELATIONID"] as? String == "17"{
                                                                                        m_loginUserName =  (arr!["PERSON_NAME"] as? String)!
                                                                                        UserDefaults.standard.setValue(m_loginUserName, forKey: "LoginUserName")
                                                                                        
                                                                                        m_loginUserGender =  (arr!["GENDER"] as? String)!
                                                                                        UserDefaults.standard.setValue(m_loginUserGender, forKey: "LoginUserGender")
                                                                                        
                                                                                        //userPersonSrnNo = (arr!["PERSON_SR_NO"] as? String)!
                                                                                        //print("userPersonSrnNo: ",userPersonSrnNo)
                                                                                        //UserDefaults.standard.setValue(userPersonSrnNo, forKey: "userPersonSrnNoValue")
                                                                                        
                                                                                        print("usergender")
                                                                                    }
                                                                                    //}
                                                                                }
                                                                            }
                                                                            
                                                                            if let mainGpaPEDict = mainDict.value(forKey: "GroupGPAPolicyEmpDependants_data") as? NSArray {
                                                                                print("mainGpaPEDict Data for savePersonDetailsJSON: ",mainGpaPEDict)
                                                                                for innerDict2 in mainGpaPEDict {
                                                                                    self.dependantsDictArray?.append(innerDict2 as? NSDictionary as! [String : String])
                                                                                    //DispatchQueue.main.async{
                                                                                    //DatabaseManager.sharedInstance.savePersonDetailsJSON(personDetailsDict: innerDict2 as! NSDictionary)
                                                                                    //}
                                                                                }
                                                                            }
                                                                            
                                                                            if let mainGTLPEDict = mainDict.value(forKey: "GroupGTLPolicyEmpDependants_data") as? NSArray {
                                                                                for innerDict3 in mainGTLPEDict {
                                                                                    self.dependantsDictArray?.append(innerDict3 as? NSDictionary as! [String : String])
                                                                                    //DispatchQueue.main.async{
                                                                                    DatabaseManager.sharedInstance.savePersonDetailsJSON(personDetailsDict: innerDict3 as! NSDictionary)
                                                                                    //}
                                                                                }
                                                                            }
                                                                            
                                                                        }
                                                                    }//>0
                                                                }else{
                                                                    print("Group_Policies_Employees_Dependants not found")
                                                                }
                                                                
                                                                DispatchQueue.main.async {
                                                                    
                                                                    let tempDict = NSDictionary()
                                                                    //self.setupTabbar(userDict:tempDict)
                                                                    UserDefaults.standard.set(true, forKey: "isAlreadylogin")
                                                                    self.refreshControl.endRefreshing()
                                                                }
                                                            }//emp depend status
                                                            
                                                            
                                                            
                                                            print("Complete Parsing....")
                                                        
                                                        
                                                        if let groupPolicyMainDictArray = jsonResult.value(forKey: "Group_Policies_Employees") as? NSArray {
                                                            print("Group_Policies_Employees",groupPolicyMainDictArray)
                                                            
                                                            if groupPolicyMainDictArray.count > 0 {
                                                                if let mainDict = groupPolicyMainDictArray[0] as? NSDictionary {
                                                                    if let mainGmcPEDict = mainDict.value(forKey: "GroupGMCPolicyEmployee_data") as? NSArray {
                                                                        
                                                                        for innerDict1 in mainGmcPEDict {
                                                                            var arr = innerDict1 as? [String:String]
                                                                            
                                                                            userEmployeeSrno = (arr!["EMPLOYEE_SR_NO"] as? String)!
                                                                            print("userEmployeeSrno: ",userEmployeeSrno)
                                                                            UserDefaults.standard.setValue(userEmployeeSrno, forKey: "userEmployeeSrnoValue")
                                                                            
                                                                            
                                                                            
                                                                            userEmployeIdNo =  (arr!["EMPLOYEE_IDENTIFICATION_NO"] as? String)!
                                                                            print("userEmployeIdNo: ",userEmployeIdNo)
                                                                            //userEmployeIdNo = (innerDict1!["EMPLOYEE_IDENTIFICATION_NO"] as? String)!]
                                                                            
                                                                            UserDefaults.standard.setValue(userEmployeIdNo, forKey: "userEmployeIdNoValue")
                                                                            
                                                                            
                                                                            print("userEmployeIdNo: ",userEmployeIdNo)
                                                                            userOegrpNo = (arr!["OE_GRP_BAS_INF_SR_NO"] as? String)!
                                                                            print("useroegrpNo: ",userOegrpNo)
                                                                            userOegrpNoGMC = (arr!["OE_GRP_BAS_INF_SR_NO"] as? String)!
                                                                            
                                                                            userGroupChildNo = (arr!["GROUPCHILDSRNO"] as? String)!
                                                                            print("usergrpNo: ",userGroupChildNo)
                                                                            
                                                                            userDESIGNATION = (arr!["DESIGNATION"] as? String)!
                                                                            print("userDESIGNATION: ",userDESIGNATION)
                                                                            
                                                                            employeeSrNoGMC = (arr!["EMPLOYEE_SR_NO"] as? String)!
                                                                            print("employeeSrNoGMC: ",employeeSrNoGMC)
                                                                            
                                                                            employeeDOJ = (arr!["DATE_OF_JOINING"] as? String)!
                                                                            print("employeeDOJ: ",employeeDOJ)
                                                                            
                                                                            UserDefaults.standard.setValue(userOegrpNo, forKey: "userOegrpNoValue")
                                                                            UserDefaults.standard.setValue(userGroupChildNo, forKey: "userGroupChildNoValue")
                                                                            UserDefaults.standard.setValue(employeeSrNoGMC, forKey: "employeeSrNoGMCValue")
                                                                            
                                                                            UserDefaults.standard.setValue(employeeDOJ, forKey: "employeeDOJValue")
                                                                            
                                                                            UserDefaults.standard.setValue(userDESIGNATION, forKey: "userDESIGNATIONValue")
                                                                            
                                                                            print("Default Values ")
                                                                            print("userOegrpNo: ",userOegrpNo," userGroupChildNo: ",userGroupChildNo," employeeSrNoGMC: ",employeeSrNoGMC," employeeDOJ: ",employeeDOJ," userDESIGNATION:",userDESIGNATION)
                                                                        }
                                                                    }
                                                                    
                                                                    if let mainGpaPEDict = mainDict.value(forKey: "GroupGPAPolicyEmployee_data") as? NSArray {
                                                                        for innerDict2 in mainGpaPEDict {
                                                                            
                                                                            var dict = innerDict2 as! NSDictionary
                                                                            if userOegrpNoGPA == dict["OE_GRP_BAS_INF_SR_NO"] as? String{
                                                                             userEmployeeSrnoGPA = dict["EMPLOYEE_SR_NO"] as! String
                                                                                UserDefaults.standard.set(userEmployeeSrnoGPA, forKey: "userEmployeeSrnoValueGPA")
                                                                                print("userEmployeeSrnoGPA",userEmployeeSrnoGPA)
                                                                            }
                                                                            
                                                                        }
                                                                    }
                                                                    
                                                                    if let mainGTLPEDict = mainDict.value(forKey: "GroupGTLPolicyEmployee_data") as? NSArray {
                                                                        for innerDict3 in mainGTLPEDict {
                                                                            
                                                                            var dict = innerDict3 as! NSDictionary
                                                                            if userOegrpNoGTL == dict["OE_GRP_BAS_INF_SR_NO"] as? String{
                                                                             userEmployeeSrnoGTL = dict["EMPLOYEE_SR_NO"] as! String
                                                                                UserDefaults.standard.set(userEmployeeSrnoGTL, forKey: "userEmployeeSrnoValueGTL")
                                                                                print("userEmployeeSrnoGTL",userEmployeeSrnoGTL)
                                                                            }
                                                                            
                                                                        }
                                                                    }
                                                                }
                                                                
                                                                
                                                                
                                                            }//>0
                                                        }
                                                        
                                                        if let groupPolicyArray = jsonResult.value(forKey: "Group_Policies") as? NSArray {
                                                            print(groupPolicyArray)
                                                            if groupPolicyArray.count > 0 {
                                                                if let mainDict = groupPolicyArray[0] as? NSDictionary {
                                                                    if let mainGmcPEDict = mainDict.value(forKey: "GroupGMCPolicies_data") as? NSArray {
                                                                        print("mainGmcPEDict : ",mainGmcPEDict)
                                                                        
                                                                        
                                                                        // Convert the NSArray to a Swift Array of dictionaries
                                                                        if let gmcPoliciesArray = mainGmcPEDict as? [[String: Any]] {
                                                                            // Save the converted array to UserDefaults
                                                                            UserDefaults.standard.set(gmcPoliciesArray, forKey: "GroupGMCPoliciesData_Loadsession")
                                                                            UserDefaults.standard.synchronize() // Ensure that the data is saved immediately
                                                                        }
                                                                        
                                                                        if mainGmcPEDict.count > 0{
                                                                            isGHIDataPresent = true
                                                                        }else{
                                                                            isGHIDataPresent = false
                                                                        }
                                                                        for innerDict in mainGmcPEDict {
                                                                            
                                                                            var dict = innerDict as? NSDictionary
                                                                            if dict?["POLICY_TYPE"] as? String == "BASE"{
                                                                                TPA_CODE_GMC_Base = (dict?["TPA_CODE"] as? String)!
                                                                                UserDefaults.standard.set(TPA_CODE_GMC_Base, forKey: "TPA_CODE_GMC_BaseValue")
                                                                                print("TPA_CODE_GMC_BaseValue: ",TPA_CODE_GMC_Base)
                                                                                
                                                                                //POLICY_NUMBER
                                                                                POLICY_NUMBER_GMC_Base = (dict?["POLICY_NUMBER"] as? String)!
                                                                                UserDefaults.standard.set(POLICY_NUMBER_GMC_Base, forKey: "POLICY_NUMBER_GMC_Base")
                                                                                print("POLICY_NUMBER_GMC_Base: ",POLICY_NUMBER_GMC_Base)
                                                                                
                                                                                //POLICY_COMMENCEMENT_DATE
                                                                                POLICY_COMMENCEMENT_DATE_GMC_Base = (dict?["POLICY_COMMENCEMENT_DATE"] as? String)!
                                                                                UserDefaults.standard.set(POLICY_COMMENCEMENT_DATE_GMC_Base, forKey: "POLICY_COMMENCEMENT_DATE_GMC_Base")
                                                                                print("POLICY_COMMENCEMENT_DATE_GMC_Base: ",POLICY_COMMENCEMENT_DATE_GMC_Base)
                                                                                
                                                                                //POLICY_VALID_UPTO
                                                                                POLICY_VALID_UPTO_GMC_Base = (dict?["POLICY_VALID_UPTO"] as? String)!
                                                                                UserDefaults.standard.set(POLICY_VALID_UPTO_GMC_Base, forKey: "POLICY_VALID_UPTO_GMC_Base")
                                                                                print("POLICY_VALID_UPTO_GMC_Base: ",POLICY_VALID_UPTO_GMC_Base)
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                    //gpa policy
                                                                    if let mainGpaPEDict = mainDict.value(forKey: "GroupGPAPolicies_data") as? NSArray {
                                                                        print(mainGpaPEDict)
                                                                        if mainGpaPEDict.count > 0{
                                                                            isGPADataPresent = true
                                                                        }else{
                                                                            isGPADataPresent = false
                                                                        }
                                                                        for innerDict in mainGpaPEDict {
                                                                            
                                                                            var dict = innerDict as? NSDictionary
                                                                            if dict?["POLICY_TYPE"] as? String == "BASE"{
                                                                                userOegrpNoGPA = (dict?["OE_GRP_BAS_INF_SR_NO"] as? String)!
                                                                                UserDefaults.standard.set(userOegrpNoGPA, forKey: "userOegrpNoValueGPA")
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                    //gtl policy
                                                                    if let mainGtlPEDict = mainDict.value(forKey: "GroupGTLPolicies_data") as? NSArray {
                                                                        print(mainGtlPEDict)
                                                                        if mainGtlPEDict.count > 0{
                                                                            isGTLDataPresent = true
                                                                        }else{
                                                                            isGTLDataPresent = false
                                                                        }
                                                                        for innerDict in mainGtlPEDict {
                                                                           
                                                                            var dict = innerDict as? NSDictionary
                                                                            if dict?["POLICY_TYPE"] as? String == "BASE"{
                                                                                userOegrpNoGTL = (dict?["OE_GRP_BAS_INF_SR_NO"] as? String)!
                                                                                UserDefaults.standard.set(userOegrpNoGTL, forKey: "userOegrpNoValueGTL")
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                               
                                                            }
                                                        }
                                                        DispatchQueue.main.async{
                                                            //self.checkEmployeeDataPresent(self.m_GMCTab, self.GPATab, self.GTLTab)
                                                           // self.getEnrollStatus()
                                                            self.getAdminSettingsJSONNew()
                                                        }
                                                        
                                                        //}
                                                        //}
                                                        
                                                        // dispatch_async(dispatch_get_main_queue(), {
                                                    }
                                                }
                                            }else{
                                                print("Loadsession Failed")
                                                //let errorHandlerVC : LoginViewController_New = LoginViewController_New()
                                                //self.navigationController?.pushViewController(errorHandlerVC, animated: true)
                                                DispatchQueue.main.sync(execute: {
                                                    if errorHandlerVCCounter == 0{
                                                        errorHandlerVCCounter = errorHandlerVCCounter + 1
                                                        let errorHandlerVC : LoginViewController_New = LoginViewController_New()
                                                        self.navigationController?.pushViewController(errorHandlerVC, animated: true)
                                                    }
                                                    else{
                                                        print("Inside getUserTokenGlobal 401 already called")
                                                    }
                                                })
                                            }
                                        }
                                    }
                                }
                            }//do
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                            }
                            
                        }
                        else{
                            print("Some error occured getNewLoadSessionDataFromServerNew \(httpResponse.statusCode)")
                            
                            if httpResponse.statusCode == 401{
                                self.retryCountLoadsession+=1
                                print("retryCountLoadsession: ",self.retryCountLoadsession)
                                
                                if self.retryCountLoadsession <= self.maxRetryLoadsession{
                                    print("Some error occured getNewLoadSessionDataFromServerNew",httpResponse.statusCode)
                                    self.getUserTokenGlobal(completion: { (data,error) in
                                        self.getNewLoadSessionDataFromServerNew()
                                    })
                                }
                                else{
                                    print("retryCountLoadsession 401 else : ",self.retryCountLoadsession)
                                }
                                
                                /*
                                 self.getUserTokenGlobal(completion: { (data,error) in
                                 self.getNewLoadSessionDataFromServerNew()
                                 })
                                 */
                            }
                            else if httpResponse.statusCode == 400{
                                DispatchQueue.main.sync(execute: {
                                    
                                    self.retryCountLoadsession+=1
                                    print("retryCountLoadsession: ",self.retryCountLoadsession)
                                    
                                    if self.retryCountLoadsession <= self.maxRetryLoadsession{
                                        print("Some error occured getNewLoadSessionDataFromServerNew",httpResponse.statusCode)
                                        self.getUserTokenGlobal(completion: { (data,error) in
                                            self.getNewLoadSessionDataFromServerNew()
                                        })
                                    }
                                    else{
                                        print("retryCountLoadsession 400 else : ",self.retryCountLoadsession)
                                        
                                        errorHandlerVCCounter = errorHandlerVCCounter + 1
                                        let errorHandlerVC : LoginViewController_New = LoginViewController_New()
                                        self.navigationController?.pushViewController(errorHandlerVC, animated: true)
                                    }
                                })
                            }
                            else{
                                self.hidePleaseWait()
                                if httpResponse.statusCode == 429{
                                    self.displayActivityAlert(title: "Too many request, please try again later")
                                }
                                else{
                                    //self.displayActivityAlert(title: m_errorMsg)
                                    print("m_errorMsg: ",m_errorMsg)
                                }
                            }
                        }
                    }
                    else{
                        print("Can't cast response to NSHTTPURLResponse")
                        //self.displayActivityAlert(title: m_errorMsg)
                        print("m_errorMsg: ",m_errorMsg)
                        self.hidePleaseWait()
                    }
                }
            }
            apiRequestLoadSession = task
            apiRequestLoadSession?.resume()
        }
    }

    
    
    func getNewLoadSessionDataFromServer() {
        if(isConnectedToNetWithAlert())
        {
            let loginType =  UserDefaults.standard.value(forKey: "loginTypeForJson") as? String ?? ""
            //let url = APIEngine.shared.getLoadSessionJsonURL(mobileNo:mobNo)
            
            let url = APIEngine.shared.getLoadSessionJsonURLPortal(mobileNo:loginType.URLEncoded)
            let urlreq = NSURL(string : url)
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?
            request.httpMethod = "post"
            
            let session = URLSession(configuration: .default)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
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
            print("authToken getNewLoadSessionDataFromServer:",authToken)
            request.setValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                              
            print("533 getNewLoadSessionDataFromServer : \(url)")
            
            EnrollmentServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (data, error) in
                
                
                //let request : NSMutableURLRequest = NSMutableURLRequest()
                //request.url = urlreq as URL?// NSURL(string: urlreq)
                //request.httpMethod = "GET"
                
                //let task = URLSession.shared.dataTask(with: urlreq! as URL)
                //{(data, response, error)  -> Void in
                if error != nil
                {
                    print("error ",error!)
                    //self.hidePleaseWait()
                    //self.displayActivityAlert(title: m_errorMsg)
                    print("m_errorMsg: ",m_errorMsg)
                }
                else
                {
                    // self.hidePleaseWait()
                    print("found some")
                    
                    do {
                        
                        print("Started parsing Load Session...",url)
                        print(data)
                        
                        // let user = try! JSONDecoder().decode(Welcome.self, from: data ?? Data())
                        
                        if let jsonResult = data as? NSDictionary
                        {
                            print("Data Found")
                            
                            print(jsonResult)
                            if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                if let statusVal = msgDict.value(forKey: "Status") as? Bool {
                                    if statusVal == true {
                                        
                                        if let groupInfo = jsonResult.value(forKey: "Group_Info_data") as? NSDictionary {
                                            
                                            if let groupCodeString = groupInfo.value(forKey:"GROUPCODE") as? String {
                                                UserDefaults.standard.set(groupCodeString, forKey: "groupCodeString")
                                            }
                                            
                                        }
                                        
                                                    //Group Products array
                                                    if let GroupProductsArr = jsonResult.value(forKey: "GroupProducts") as? NSArray {
                                                        
                                                        m_productCodeArray.removeAll()
                                                        UserDefaults.standard.setValue(m_productCodeArray, forKey: "ProductsArray")

                                                        for dict in GroupProductsArr {
                                                            if let tempd = dict as? NSDictionary {
                                                                if tempd.value(forKey: "PRODUCT_CODE") as? String == "GMC"{
                                                                    if tempd.value(forKey: "ACTIVE") as? String  == "1"{
                                                                        m_productCodeArray.append("GMC")
                                                                        
                                                                    }
                                                                }
                                                                else if tempd.value(forKey: "PRODUCT_CODE") as? String  == "GPA"{
                                                                    if tempd.value(forKey: "ACTIVE") as? String  == "1"{
                                                                        m_productCodeArray.append("GPA")
                                                                    }
                                                                }
                                                                else{
                                                                    if tempd.value(forKey: "ACTIVE") as? String  == "1"{
                                                                        m_productCodeArray.append("GTL")
                                                                    }
                                                                }
                                                            }
                                                            
                                                            UserDefaults.standard.setValue(m_productCodeArray, forKey: "ProductsArray")
                                                            m_productCodeArray=UserDefaults.standard.value(forKey: "ProductsArray") as! Array<String>
                                                        }
                                                    }
                           
                              //Group_Policies_Employees_Dependants
                            let statusDelDep = DatabaseManager.sharedInstance.deletePersonDetails(personSrNo: "")
                            if(statusDelDep)
                            {
                                print("Dependant found....")
                                
                                if let groupPolicyMainDepDictArray = jsonResult.value(forKey: "Group_Policies_Employees_Dependants") as? NSArray {
                                    print(groupPolicyMainDepDictArray)
                                    
                                    if groupPolicyMainDepDictArray.count > 0 {
                                        self.dependantsDictArray?.removeAll()
                                        print("saved dependant data...")
                                        if let mainDict = groupPolicyMainDepDictArray[0] as? NSDictionary {
                                            if let mainGmcPEDict = mainDict.value(forKey: "GroupGMCPolicyEmpDependants_data") as? NSArray {
                                                for innerDict1 in mainGmcPEDict {
                                                    self.dependantsDictArray?.append(innerDict1 as? NSDictionary as! [String : String])
                                                    DatabaseManager.sharedInstance.savePersonDetailsJSON(personDetailsDict: innerDict1 as! NSDictionary)
                                                }
                                            }
                                            
                                            if let mainGpaPEDict = mainDict.value(forKey: "GroupGPAPolicyEmpDependants_data") as? NSArray {
                                                for innerDict2 in mainGpaPEDict {
                                                    self.dependantsDictArray?.append(innerDict2 as? NSDictionary as! [String : String])
                                                    DatabaseManager.sharedInstance.savePersonDetailsJSON(personDetailsDict: innerDict2 as! NSDictionary)
                                                }
                                            }
                                            
                                            if let mainGTLPEDict = mainDict.value(forKey: "GroupGTLPolicyEmpDependants_data") as? NSArray {
                                                for innerDict3 in mainGTLPEDict {
                                                    self.dependantsDictArray?.append(innerDict3 as? NSDictionary as! [String : String])
                                                    DatabaseManager.sharedInstance.savePersonDetailsJSON(personDetailsDict: innerDict3 as! NSDictionary)
                                                }
                                            }
                                            
                                        }
                                    }//>0
                                }
                                
                                DispatchQueue.main.async {
                                    
                                    let tempDict = NSDictionary()
                                    //self.setupTabbar(userDict:tempDict)
                                    UserDefaults.standard.set(true, forKey: "isAlreadylogin")
                                    self.refreshControl.endRefreshing()
                                }
                            }//emp depend status
                            
                            print("Complete Parsing....")

                            // dispatch_async(dispatch_get_main_queue(), {
                                }
                            }
                        }
                        }
                    }//do
                    catch let JSONError as NSError
                    {
                        print(JSONError)
                    }
                    
                    
                }
                
                
            }
            // task.resume()
        }
    }
    
}





/*
 if let isOpted = topUpObjDict.value(forKey: "Opted") as? String {
 if isOpted == "YES" {
 UserDefaults.standard.set(topUpObjDict.value(forKey: "TSumInsured"), forKey: "gpaSelectedTopup")
 }
 }
 */


extension NewDashboardViewController {
    //Get Top Bar Button API...
    func getTopThreeButtonsAPI()
    {
            
            var m_employeedict : EMPLOYEE_INFORMATION?
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        
            if userArray.count > 0 {
             m_employeedict=userArray[0]
             var groupChildSrNo = String()
            
            if let groupChildSR = m_employeedict?.groupChildSrNo {
                groupChildSrNo=String(groupChildSR)
            }
            
            print(groupChildSrNo)
            let url = APIEngine.shared.getServicableTabs(strGroupChildSrno: groupChildSrNo)
            print("ShowHidebutton url ",url)
            
            ServerRequestManager.serverInstance.getRequestDataFromServerWithoutLoader(url: url, view: self) { (response, error) in
                
                if let messageDictionary = response?["message"].dictionary
                {
                    if let status = messageDictionary["Status"]?.bool
                    {
                        if status == true {
                            
                            //UserDefaults.standard.set(false, forKey: "isInsurance")
                            //UserDefaults.standard.set(false, forKey: "isWellness")
                            //UserDefaults.standard.set(false, forKey: "isFitness")

                            print("ShowHideButtonsforInsurance: ",response)
                            if let buttonsArray = response?["showButtons"].array {
                                UserDefaults.standard.set(true, forKey: "getOfflineTabs")
                                for arrDict in buttonsArray {
                                    guard let serviceName = arrDict["SERVICE_NAME"].string else {
                                        return
                                    }
                                    
                                    switch serviceName.uppercased() {
                                    case "INSURANCE":
                                        UserDefaults.standard.set(true, forKey: "isInsurance")
                                        if !self.servicesArray.contains("Insurance") {
                                        self.servicesArray.append("Insurance")
                                        }
                                    case "WELLNESS":
                                        UserDefaults.standard.set(true, forKey: "isWellness")
                                        if !self.servicesArray.contains("Wellness") {
                                        //self.servicesArray.append("Wellness")
                                        }
                                    case "FITNESS":
                                        UserDefaults.standard.set(true, forKey: "isFitness")
                                        if !self.servicesArray.contains("Fitness") {
                                        //self.servicesArray.append("Fitness")
                                        }
                                    default:
                                        break
                                    }
                                }
                            }
                            print("servicesArray ",self.servicesArray)
                            self.topCollectionView.reloadData()
                        }
                        else {
                            //employee record not found
                            //let msg = messageDictionary["Message"]?.string
                            //self.displayActivityAlert(title: m_errorMsg )
                        }
                    }
                }//msgDic
            }
        }
    }
    
    func getTopThreeButtonsOffline() {
        if let isInsurance = UserDefaults.standard.value(forKey:"isInsurance") as? Bool {
            if isInsurance {
            if !servicesArray.contains("Insurance") {
                self.servicesArray.append("Insurance")
            }
            }
        }
        
        if let isInsurance = UserDefaults.standard.value(forKey:"isWellness") as? Bool {
            if !servicesArray.contains("Wellness") {
                //self.servicesArray.append("Wellness")
            }
        }
        
        if let isFitness = UserDefaults.standard.value(forKey:"isFitness") as? Bool {
            if isFitness {
            if !servicesArray.contains("Fitness") {
               // self.servicesArray.append("Fitness")
            }
            }
        }

        self.topCollectionView.reloadData()

    }
    
    //Remove Null..
    func removeNSNull(from dict: [String: Any]) -> [String: Any] {
        var mutableDict = dict
        let keysWithEmptString = dict.filter { $0.1 is NSNull }.map { $0.0 }
        for key in keysWithEmptString {
            mutableDict[key] = ""
        }
        return mutableDict
    }
  

}
