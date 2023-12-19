//
//  MainAPIHelper.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 20/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import Foundation
import TrustKit
import AesEverywhere

extension EnterOTPViewController {
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


extension EnterOTPViewController {
  
    
    
    func getNewLoadSessionDataFromServer() {
        if(isConnectedToNetWithAlert())
        {
            //let url = APIEngine.shared.getLoadSessionJsonURL(mobileNo:m_mobileNumberTextField.text!)
            //Portal
            var otpValue = ""
            if !m_loginIDMobileNumber.isEmpty || !m_loginIDEmail.isEmpty{
                otpValue = getTextFromTextFields()
                otpValue = try! AES256.encrypt(input: otpValue, passphrase: m_passphrase_Portal)
            }
            else{
                print("Inside m_loginIDWeb : ",m_loginIDWeb)
            }
            var url = ""
            print("m_loginIDMobileNumber: ",m_loginIDMobileNumber," m_loginIDEmail: ",m_loginIDEmail," m_loginIDWeb: ",m_loginIDWeb)
            if !m_loginIDMobileNumber.isEmpty{
                print("m_loginIDMobileNumber: ",m_loginIDMobileNumber)
                m_loginIDMobileNumber = try! AES256.encrypt(input: m_loginIDMobileNumber, passphrase: m_passphrase_Portal)
                print("m_loginIDMobileNumber encrypt: ",m_loginIDMobileNumber)
                
                let allowedCharacterSet = CharacterSet.alphanumerics // Set of allowed characters
                let urlEncodedNoString = m_loginIDMobileNumber.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                print("urlEncodedString: ",urlEncodedNoString)
                
                let urlEncodedOTPString = otpValue.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                print("urlEncodedOTPString: ",urlEncodedOTPString)
                
                url = APIEngine.shared.getLoadSessionOTPJsonURLPortal(mobileNo: urlEncodedNoString!, otp: urlEncodedOTPString!)
            }
            else if !m_loginIDEmail.isEmpty{
                m_loginIDEmail = try! AES256.encrypt(input: m_loginIDEmail, passphrase: m_passphrase_Portal)
                
                url = APIEngine.shared.getLoadSessionOTPJsonURLPortal(emailId: m_loginIDEmail.URLEncoded, otp: otpValue.URLEncoded)
            }
            else if !m_loginIDWeb.isEmpty{
                m_loginIDWeb = try! AES256.encrypt(input: m_loginIDWeb, passphrase: m_passphrase_Portal)
                url = APIEngine.shared.getLoadSessionJsonURLPortal(webLogin:m_loginIDWeb.URLEncoded)
            }
            
            
            let urlreq = NSURL(string : url)
            
            //self.showPleaseWait(msg: "")
            print("35 getLoadSessionJsonURL : \(url)")
            
            
            
            EnrollmentServerRequestManager.serverInstance.getRequestDataFromServerPost(url: url, view: self) { (data, error) in
          
                if error != nil
                {
                    print("error:: ",error!)
                    //self.hidePleaseWait()
                    self.displayActivityAlert(title: m_errorMsg)
                }
                else
                {
                    
                    print("found some")
                    
                    do {
                        print("Started parsing Load Session...")
                        print(data)
                        
                        // let user = try! JSONDecoder().decode(Welcome.self, from: data ?? Data())
                        
                       // UserDefaults.standard.setValue(self.m_mobileNumberTextField.text!, forKey: "loginTypeForJson")
                        
                        print("\(m_loginIDMobileNumber) : \(m_loginIDEmail) : \(m_loginIDWeb)")
                        
                        if !m_loginIDMobileNumber.isEmpty{
                            UserDefaults.standard.setValue(m_loginIDMobileNumber, forKey: "loginTypeForJson")
                        }
                        else if !m_loginIDEmail.isEmpty{
                            UserDefaults.standard.setValue(m_loginIDEmail, forKey: "loginTypeForJson")
                        }
                        else if !m_loginIDWeb.isEmpty{
                            UserDefaults.standard.setValue(m_loginIDWeb, forKey: "loginTypeForJson")
                        }
                        
                        
                        if let jsonResult = data as? NSDictionary
                        {
                            print("Data Found")
                            self.policiesDictArray = []
                            self.dependantsDictArray = []
                            self.policyEmpDictArray = []
                            
                            print("getNewLoadSessionDataFromServer: ",jsonResult)
                            if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                if let statusVal = msgDict.value(forKey: "Status") as? Bool {
                                    if statusVal == true {
                                        //let user = try! JSONDecoder().decode(Welcome.self, from: data)
                                        // if user != nil {
                                        
                                        // let status = DatabaseManager.sharedInstance.deleteGroupChildMasterDetails(productCode: "")
                                        //print(status)
                                        // if(status)
                                        // {
                                        print("deleteGroupChildMasterDetails")
                                        
                                        if let groupDict = jsonResult.value(forKey: "Group_Info_data") as? NSDictionary {
                                            DatabaseManager.sharedInstance.deleteGroupChildMasterDetails(productCode: "")
                                            DatabaseManager.sharedInstance.saveGroupChildMasterDetails(groupDetailsDict: groupDict)
                                        }
                                       
                                        
                                        
                                        if let brokerInfoDict = jsonResult.value(forKey: "Broker_Info_data") as? NSDictionary {
                                            
                                            if let brokerName = brokerInfoDict.value(forKey: "BROKER_NAME")
                                            {
                                                if let name: String = brokerName as? String {
                                                    UserDefaults.standard.set(name, forKey: "BrokerName")
                                                }
                                            }
                                        }
                                        
                                        // Enrollment_Parental_Options
                                        if let EnrollmentParentalOptionsArr = jsonResult.value(forKey: "Enrollment_Parental_Options") as? NSArray {
                                            
                                            for item  in EnrollmentParentalOptionsArr{
                                                
                                                if let object = item as? [String: Any] {
                                                    // ID
                                                    let Enrollment_Through_MB = object["Enrollment_Through_MB"] as? String ?? "N/A"
                                                    
                                                    print("Enrollment_Through_MB: \(Enrollment_Through_MB)")
                                                    
                                                    
                                                        if Enrollment_Through_MB.lowercased() == "yes" {
                                                            UserDefaults.standard.set(true, forKey: "isEnrollmentThroughtMB")
                                                        }
                                                        else {
                                                            UserDefaults.standard.set(false, forKey: "isEnrollmentThroughtMB")
                                                        }
                                                    print("Enrollment_Through_MB : ",UserDefaults.standard.value(forKey: "isEnrollmentThroughtMB") as? Bool)
                                                    }
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
                                        
                                        
                                        //Group_Policies - Array - TopUp Options
                                        
                                        let statusdd = DatabaseManager.sharedInstance.deleteGroupBasicInfoDetails(productCode: "")
                                        if(statusdd)
                                        {
                                            print("deleteGroupBasicInfoDetails")
                                            if let policyMainDictArray = jsonResult.value(forKey: "Group_Policies") as? NSArray {
                                                print("Group_Policies data: ",policyMainDictArray)
                                                
                                                if policyMainDictArray.count > 0 {
                                                    if let mainDict = policyMainDictArray[0] as? NSDictionary {
                                                        if let mainGmcDict = mainDict.value(forKey: "GroupGMCPolicies_data") as? NSArray {
                                                            
                                                            for innerDict in mainGmcDict {
                                                                self.policiesDictArray?.append(innerDict as? NSDictionary as! [String : String])
                                                                var dict = innerDict as? NSDictionary
                                                                if dict?["POLICY_TYPE"] as? String == "BASE"{
                                                                    userOegrpNoGPA = (dict?["OE_GRP_BAS_INF_SR_NO"] as? String)!
                                                                    UserDefaults.standard.set(userOegrpNoGPA, forKey: "userOegrpNoValueGPA")
                                                                }
                                                            }
                                                            
                                                        }
                                                        
                                                        if let mainGpaDict = mainDict.value(forKey: "GroupGPAPolicies_data") as? NSArray {
                                                            
                                                            for innerDict in mainGpaDict {
                                                                self.policiesDictArray?.append(innerDict as? NSDictionary as! [String : String])
                                                            }
                                                            
                                                        }
                                                        
                                                        if let mainGTLDict = mainDict.value(forKey: "GroupGTLPolicies_data") as? NSArray {
                                                            
                                                            for innerDict in mainGTLDict {
                                                                self.policiesDictArray?.append(innerDict as? NSDictionary as! [String : String])
                                                            }
                                                            
                                                        }
                                                        
                                                        for i in 0..<self.policiesDictArray!.count
                                                        {
                                                            print("saveGroupBasicInfoDetails=\(self.policiesDictArray!.count)")
                                                            let userTempDict = self.policiesDictArray![i] as NSDictionary
                                                            DatabaseManager.sharedInstance.saveGroupBasicInfoDetailsJSON(groupDetailsDict: userTempDict)
                                                        }
                                                        
                                                    }
                                                }//>0
                                            }
                                        }//status
                                        print(self.policiesDictArray)
                                        
                                        //Setting Default Policy For MyCoverges
                                        var dataArray = self.policiesDictArray!
                                        var OE_GRP_BAS_INF_SR_NO_Default = ""
                                        var PRODUCT_CODE_Default = ""
                                        for index in 0..<dataArray.count {
                                            if index == 0{
                                                OE_GRP_BAS_INF_SR_NO_Default = dataArray[index]["OE_GRP_BAS_INF_SR_NO"] as! String
                                                PRODUCT_CODE_Default = dataArray[index]["PRODUCT_CODE"] as! String
                                                
                                                print("OE_GRP_BAS_INF_SR_NO_Default: ",OE_GRP_BAS_INF_SR_NO_Default)
                                                print("PRODUCT_CODE_Default: ",PRODUCT_CODE_Default)
                                                
                                                let productCode = String(PRODUCT_CODE_Default).removeSpecialChars
                                                UserDefaults.standard.setValue(productCode, forKey: "PRODUCT_CODE")
                                                
                                                let oeGroupBase = String(OE_GRP_BAS_INF_SR_NO_Default).removeSpecialChars
                                                UserDefaults.standard.setValue(oeGroupBase, forKey: "OE_GRP_BAS_INF_SR_NO")

                                            }
                                        }
                                        
                                        
                                        //Group_Policies_Employees
                                        let statusDelEMp = DatabaseManager.sharedInstance.deleteEmployeeDetails(productCode: "")
                                        if(statusDelEMp)
                                        {
                                            if let groupPolicyMainDictArray = jsonResult.value(forKey: "Group_Policies_Employees") as? NSArray {
                                                print(groupPolicyMainDictArray)
                                                
                                                if groupPolicyMainDictArray.count > 0 {
                                                    if let mainDict = groupPolicyMainDictArray[0] as? NSDictionary {
                                                        if let mainGmcPEDict = mainDict.value(forKey: "GroupGMCPolicyEmployee_data") as? NSArray {
                                                            for innerDict1 in mainGmcPEDict {
                                                                print("saveEmployeeDetailsJSON")
                                                                
                                                                self.policyEmpDictArray?.append(innerDict1 as? NSDictionary as! [String : String])
                                                                DatabaseManager.sharedInstance.saveEmployeeDetailsJSON(enrollmentDetailsDict: innerDict1 as! NSDictionary,productCode:"GMC")
                                                                
                                                            }
                                                        }
                                                        
                                                        if let mainGpaPEDict = mainDict.value(forKey: "GroupGPAPolicyEmployee_data") as? NSArray {
                                                            for innerDict2 in mainGpaPEDict {
                                                                self.policyEmpDictArray?.append(innerDict2 as? NSDictionary as! [String : String])
                                                                DatabaseManager.sharedInstance.saveEmployeeDetailsJSON(enrollmentDetailsDict: innerDict2 as! NSDictionary,productCode:"GPA")
                                                                
                                                            }
                                                        }
                                                        
                                                        if let mainGTLPEDict = mainDict.value(forKey: "GroupGTLPolicyEmployee_data") as? NSArray {
                                                            for innerDict3 in mainGTLPEDict {
                                                                self.policyEmpDictArray?.append(innerDict3 as? NSDictionary as! [String : String])
                                                                DatabaseManager.sharedInstance.saveEmployeeDetailsJSON(enrollmentDetailsDict: innerDict3 as! NSDictionary,productCode:"GTL")
                                                                
                                                            }
                                                        }
                                                        
                                                    }
                                                }//>0
                                            }
                                        } //statusEmpDel
                                        
                                        print(self.policyEmpDictArray)
                                        //New
                                        
                                        //Group_Policies_Employees_Dependants
                                        let statusDelDep = DatabaseManager.sharedInstance.deletePersonDetails(personSrNo: "")
                                        print("statusDelDep : ",statusDelDep)
                                        if(statusDelDep)
                                        {
                                            print("Dependant found....")
                                            
                                            if let groupPolicyMainDepDictArray = jsonResult.value(forKey: "Group_Policies_Employees_Dependants") as? NSArray {
                                                print(groupPolicyMainDepDictArray)
                                                
                                                if groupPolicyMainDepDictArray.count > 0 {
                                                    
                                                    print("saved dependant data...")
                                                    if let mainDict = groupPolicyMainDepDictArray[0] as? NSDictionary {
                                                        if let mainGmcPEDict = mainDict.value(forKey: "GroupGMCPolicyEmpDependants_data") as? NSArray {
                                                            for innerDict1 in mainGmcPEDict {
                                                                self.dependantsDictArray?.append(innerDict1 as? NSDictionary as! [String : String])
                                                                DatabaseManager.sharedInstance.savePersonDetailsJSON(personDetailsDict: innerDict1 as! NSDictionary)
                                                                var arr = innerDict1 as? [String:String]
                                                                if arr!["RELATIONID"] as? String == "17"{
                                                                    print("arr with relation 17 :",arr)
                                                                    m_loginUserName =  (arr!["PERSON_NAME"] as? String)!
                                                                    UserDefaults.standard.setValue(m_loginUserName, forKey: "LoginUserName")
                                                                  
                                                                    
                                                                    m_loginUserGender =  (arr!["GENDER"] as? String)!
                                                                    
                                                                    
                                                                    userPersonSrnNo = (arr!["PERSON_SR_NO"] as? String)!
                                                                    print("userPersonSrnNo: ",userPersonSrnNo)
                                                                    UserDefaults.standard.setValue(userPersonSrnNo, forKey: "userPersonSrnNoValue")
                                                                    
                                                                    
                                                                    UserDefaults.standard.setValue(m_loginUserGender, forKey: "LoginUserGender")
                                                                    
                                                                    
                                                                    print("usergender")
                                                                }
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
                                                self.loadSession = true
                                                print("loadSession \(self.loadSession) : adminSettings \(self.adminSettings)")
                                                //self.moveToEnrollment()
                                                UserDefaults.standard.set(true, forKey: "isAlreadylogin")
                                            }
                                        }//emp depend status
                                        
                                        print("Complete Parsing....")
                                        
                                        // Commented for Portal as we are not using Admin Setting call
                                        //self.getAdminSettingsJSON()
                                        //self.sendFCMTokenToServer()
                                        // dispatch_async(dispatch_get_main_queue(), {
                                    }
                                    else{
                                        print("Loadsession Failed")
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }else{
                                print("Loadsession Failed")
                                self.displayActivityAlert(title: "Some error occured")
                                self.navigationController?.popViewController(animated: true)
                                
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
    
    
    
    func getNewLoadSessionDataFromServerNew() {
        if(isConnectedToNetWithAlert())
        {
            //let url = APIEngine.shared.getLoadSessionJsonURL(mobileNo:m_mobileNumberTextField.text!)
            //Portal
            var otpValue = ""
            if !m_loginIDMobileNumber.isEmpty || !m_loginIDEmail.isEmpty{
                otpValue = getTextFromTextFields() //"1005"
                print("otpValue ",otpValue)
                otpValue = try! AES256.encrypt(input: otpValue, passphrase: m_passphrase_Portal)
                
            }
            else{
                print("Inside m_loginIDWeb : ",m_loginIDWeb)
            }
            var url = ""
            if !m_loginIDMobileNumber.isEmpty{
                print("m_loginIDMobileNumber: ",m_loginIDMobileNumber)
                var encryptMobNo = try! AES256.encrypt(input: m_loginIDMobileNumber, passphrase: m_passphrase_Portal)
                
                print("m_loginIDMobileNumber encrypt: ",encryptMobNo)
                
                let allowedCharacterSet = CharacterSet.alphanumerics // Set of allowed characters
                let urlEncodedNoString = encryptMobNo.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                print("urlEncodedString: ",urlEncodedNoString)
                
                let urlEncodedOTPString = otpValue.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                print("urlEncodedOTPString: ",urlEncodedOTPString)
                
                url = APIEngine.shared.getLoadSessionOTPJsonURLPortal(mobileNo: urlEncodedNoString!, otp: urlEncodedOTPString!)
            }
            else if !m_loginIDEmail.isEmpty{
                print("m_loginIDEmail: ",m_loginIDEmail)
                print("otpValue: ",otpValue)
                var encryptEmail = try! AES256.encrypt(input: m_loginIDEmail, passphrase: m_passphrase_Portal)
                
                print("m_loginIDEmail encrypt: ",encryptEmail)
                
                let allowedCharacterSet = CharacterSet.alphanumerics // Set of allowed characters
                let urlEncodedNoString = encryptEmail.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                print("urlEncodedString: ",urlEncodedNoString)
                
                let urlEncodedOTPString = otpValue.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                print("urlEncodedOTPString: ",urlEncodedOTPString)
                url = APIEngine.shared.getLoadSessionOTPJsonURLPortal(emailId: urlEncodedNoString!, otp: urlEncodedOTPString!)
            }
            else if !m_loginIDWeb.isEmpty{
                var encryptWeb = try! AES256.encrypt(input: m_loginIDWeb, passphrase: m_passphrase_Portal)
                let allowedCharacterSet = CharacterSet.alphanumerics // Set of allowed characters
                let urlEncodedNoString = encryptWeb.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
                print("urlEncodedString: ",urlEncodedNoString)
                url = APIEngine.shared.getLoadSessionJsonURLPortal(webLogin:urlEncodedNoString!)
            }
            
            
            let urlreq = NSURL(string : url)
            
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
            
            print("Request Body: ",request.httpBody)
            
            print("35 getNewLoadSessionDataFromServerNew : \(url)")
            
            
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
                    print("error:", error)
                    return
                }
                else{
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                            
                            
                            print("found some")
                            
                            do {
                                print("Started parsing Load Session...")
                                print(data)
                                
                                // let user = try! JSONDecoder().decode(Welcome.self, from: data ?? Data())
                                
                                // UserDefaults.standard.setValue(self.m_mobileNumberTextField.text!, forKey: "loginTypeForJson")
                                
                                print("\(m_loginIDMobileNumber) : \(m_loginIDEmail) : \(m_loginIDWeb)")
                                
                                if !m_loginIDMobileNumber.isEmpty{
                                    UserDefaults.standard.setValue(m_loginIDMobileNumber, forKey: "loginTypeForJson")
                                    UserDefaults.standard.setValue("mobileno", forKey: "loginType")
                                }
                                else if !m_loginIDEmail.isEmpty{
                                    UserDefaults.standard.setValue(m_loginIDEmail, forKey: "loginTypeForJson")
                                    UserDefaults.standard.setValue("email", forKey: "loginType")
                                }
                                else if !m_loginIDWeb.isEmpty{
                                    UserDefaults.standard.setValue(m_loginIDWeb, forKey: "loginTypeForJson")
                                    UserDefaults.standard.setValue("web", forKey: "loginType")
                                }
                                guard let data = data else { return }
                                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                                print("Json: ",json)
                                
                                if let jsonResult = json as? NSDictionary
                                {
                                    print("Data Found")
                                    self.policiesDictArray = []
                                    self.dependantsDictArray = []
                                    self.policyEmpDictArray = []
                                    
                                    print("getNewLoadSessionDataFromServer: ",jsonResult)
                                    if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                        if let Message = msgDict.value(forKey: "Message") as? String{
                                            if Message == "LoadSession Details found"{
                                                
                                                if let statusVal = msgDict.value(forKey: "Status") as? Bool {
                                                    if statusVal == true {
                                                        //let user = try! JSONDecoder().decode(Welcome.self, from: data)
                                                        // if user != nil {
                                                        
                                                        // let status = DatabaseManager.sharedInstance.deleteGroupChildMasterDetails(productCode: "")
                                                        //print(status)
                                                        // if(status)
                                                        // {
                                                        print("deleteGroupChildMasterDetails")
                                                        
                                                        if let groupDict = jsonResult.value(forKey: "Group_Info_data") as? NSDictionary {
                                                            DatabaseManager.sharedInstance.deleteGroupChildMasterDetails(productCode: "")
                                                            DatabaseManager.sharedInstance.saveGroupChildMasterDetails(groupDetailsDict: groupDict)
                                                        }
                                                        
                                                        
                                                        
                                                        if let brokerInfoDict = jsonResult.value(forKey: "Broker_Info_data") as? NSDictionary {
                                                            
                                                            if let brokerName = brokerInfoDict.value(forKey: "BROKER_NAME")
                                                            {
                                                                if let name: String = brokerName as? String {
                                                                    UserDefaults.standard.set(name, forKey: "BrokerName")
                                                                }
                                                            }
                                                        }
                                                        
                                                        // Enrollment_Parental_Options
                                                        if let EnrollmentParentalOptionsArr = jsonResult.value(forKey: "Enrollment_Parental_Options") as? NSArray {
                                                            
                                                            for item  in EnrollmentParentalOptionsArr{
                                                                
                                                                if let object = item as? [String: Any] {
                                                                    // ID
                                                                    let Enrollment_Through_MB = object["Enrollment_Through_MB"] as? String ?? "N/A"
                                                                    
                                                                    print("Enrollment_Through_MB: \(Enrollment_Through_MB)")
                                                                    
                                                                    
                                                                    if Enrollment_Through_MB.lowercased() == "yes" {
                                                                        UserDefaults.standard.set(true, forKey: "isEnrollmentThroughtMB")
                                                                    }
                                                                    else {
                                                                        UserDefaults.standard.set(false, forKey: "isEnrollmentThroughtMB")
                                                                    }
                                                                    print("Enrollment_Through_MB : ",UserDefaults.standard.value(forKey: "isEnrollmentThroughtMB") as? Bool)
                                                                }
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
                                                        
                                                        
                                                        //Group_Policies - Array - TopUp Options
                                                        
                                                        let statusdd = DatabaseManager.sharedInstance.deleteGroupBasicInfoDetails(productCode: "")
                                                        if(statusdd)
                                                        {
                                                            print("deleteGroupBasicInfoDetails")
                                                            if let policyMainDictArray = jsonResult.value(forKey: "Group_Policies") as? NSArray {
                                                                print("Group_Policies data: ",policyMainDictArray)
                                                                
                                                                if policyMainDictArray.count > 0 {
                                                                    if let mainDict = policyMainDictArray[0] as? NSDictionary {
                                                                        if let mainGmcDict = mainDict.value(forKey: "GroupGMCPolicies_data") as? NSArray {
                                                                            
                                                                            for innerDict in mainGmcDict {
                                                                                self.policiesDictArray?.append(innerDict as? NSDictionary as! [String : String])
                                                                            }
                                                                            
                                                                        }
                                                                        
                                                                        if let mainGpaDict = mainDict.value(forKey: "GroupGPAPolicies_data") as? NSArray {
                                                                            
                                                                            for innerDict in mainGpaDict {
                                                                                self.policiesDictArray?.append(innerDict as? NSDictionary as! [String : String])
                                                                                var dict = innerDict as? NSDictionary
                                                                                if dict?["POLICY_TYPE"] as? String == "BASE"{
                                                                                    userOegrpNoGPA = (dict?["OE_GRP_BAS_INF_SR_NO"] as? String)!
                                                                                    UserDefaults.standard.set(userOegrpNoGPA, forKey: "userOegrpNoValueGPA")
                                                                                }
                                                                                
                                                                            }
                                                                        }
                                                                        
                                                                            if let mainGTLDict = mainDict.value(forKey: "GroupGTLPolicies_data") as? NSArray {
                                                                                
                                                                                for innerDict in mainGTLDict {
                                                                                    self.policiesDictArray?.append(innerDict as? NSDictionary as! [String : String])
                                                                                    var dict = innerDict as? NSDictionary
                                                                                    if dict?["POLICY_TYPE"] as? String == "BASE"{
                                                                                        userOegrpNoGTL = (dict?["OE_GRP_BAS_INF_SR_NO"] as? String)!
                                                                                        UserDefaults.standard.set(userOegrpNoGTL, forKey: "userOegrpNoValueGTL")
                                                                                    }
                                                                                    
                                                                                }
                                                                            }
                                                                        
                                                                        for i in 0..<self.policiesDictArray!.count
                                                                        {
                                                                            print("saveGroupBasicInfoDetails=\(self.policiesDictArray!.count)")
                                                                            let userTempDict = self.policiesDictArray![i] as NSDictionary
                                                                            DatabaseManager.sharedInstance.saveGroupBasicInfoDetailsJSON(groupDetailsDict: userTempDict)
                                                                        }
                                                                        
                                                                    }
                                                                }//>0
                                                            }
                                                        }//status
                                                        print(self.policiesDictArray)
                                                        
                                                        //Setting Default Policy For MyCoverges
                                                        var dataArray = self.policiesDictArray!
                                                        var OE_GRP_BAS_INF_SR_NO_Default = ""
                                                        var PRODUCT_CODE_Default = ""
                                                        for index in 0..<dataArray.count {
                                                            if index == 0{
                                                                OE_GRP_BAS_INF_SR_NO_Default = dataArray[index]["OE_GRP_BAS_INF_SR_NO"] as! String
                                                                PRODUCT_CODE_Default = dataArray[index]["PRODUCT_CODE"] as! String
                                                                
                                                                print("OE_GRP_BAS_INF_SR_NO_Default: ",OE_GRP_BAS_INF_SR_NO_Default)
                                                                print("PRODUCT_CODE_Default: ",PRODUCT_CODE_Default)
                                                                
                                                                let productCode = String(PRODUCT_CODE_Default).removeSpecialChars
                                                                UserDefaults.standard.setValue(productCode, forKey: "PRODUCT_CODE")
                                                                
                                                                let oeGroupBase = String(OE_GRP_BAS_INF_SR_NO_Default).removeSpecialChars
                                                                UserDefaults.standard.setValue(oeGroupBase, forKey: "OE_GRP_BAS_INF_SR_NO")
                                                                
                                                            }
                                                        }
                                                        
                                                        
                                                        //Group_Policies_Employees
                                                        DispatchQueue.global().sync{
                                                            let statusDelEMp = DatabaseManager.sharedInstance.deleteEmployeeDetails(productCode: "")
                                                            if(statusDelEMp)
                                                            {
                                                                if let groupPolicyMainDictArray = jsonResult.value(forKey: "Group_Policies_Employees") as? NSArray {
                                                                    print(groupPolicyMainDictArray)
                                                                    
                                                                    if groupPolicyMainDictArray.count > 0 {
                                                                        if let mainDict = groupPolicyMainDictArray[0] as? NSDictionary {
                                                                            if let mainGmcPEDict = mainDict.value(forKey: "GroupGMCPolicyEmployee_data") as? NSArray {
                                                                                for innerDict1 in mainGmcPEDict {
                                                                                    print("saveEmployeeDetailsJSON : ",innerDict1)
                                                                                    var arr = innerDict1 as? [String:String]
                                                                                    
                                                                                    userEmployeeSrno = (arr!["EMPLOYEE_SR_NO"] as? String)!
                                                                                    print("userEmployeeSrno: ",userEmployeeSrno)
                                                                                    UserDefaults.standard.setValue(userEmployeeSrno, forKey: "userEmployeeSrnoValue")
                                                                                    
                                                                                    
                                                                                    
                                                                                    userEmployeIdNo =  (arr!["EMPLOYEE_IDENTIFICATION_NO"] as? String)!
                                                                                    print("userEmployeIdNo: ",userEmployeIdNo)
                                                                                    //userEmployeIdNo = (innerDict1!["EMPLOYEE_IDENTIFICATION_NO"] as? String)!]
                                                                                    
                                                                                    userOegrpNo = (arr!["OE_GRP_BAS_INF_SR_NO"] as? String)!
                                                                                    print("useroegrpNo: ",userOegrpNo)
                                                                                    userOegrpNoGMC = (arr!["OE_GRP_BAS_INF_SR_NO"] as? String)!
                                                                                    
                                                                                    userGroupChildNo = (arr!["GROUPCHILDSRNO"] as? String)!
                                                                                    print("usergrpNo: ",userGroupChildNo)
                                                                                    
                                                                                    UserDefaults.standard.setValue(userEmployeIdNo, forKey: "userEmployeIdNoValue")
                                                                                    
                                                                                    print("userEmployeIdNo: ",userEmployeIdNo)
                                                                                    UserDefaults.standard.setValue(userOegrpNo, forKey: "userOegrpNoValue")
                                                                                    UserDefaults.standard.setValue(userGroupChildNo, forKey: "userGroupChildNoValue")
                                                                                    self.policyEmpDictArray?.append(innerDict1 as? NSDictionary as! [String : String])
                                                                                    DatabaseManager.sharedInstance.saveEmployeeDetailsJSON(enrollmentDetailsDict: innerDict1 as! NSDictionary,productCode:"GMC")
                                                                                    
                                                                                }
                                                                            }
                                                                            
                                                                            if let mainGpaPEDict = mainDict.value(forKey: "GroupGPAPolicyEmployee_data") as? NSArray {
                                                                                for innerDict2 in mainGpaPEDict {
                                                                                    self.policyEmpDictArray?.append(innerDict2 as? NSDictionary as! [String : String])
                                                                                    DatabaseManager.sharedInstance.saveEmployeeDetailsJSON(enrollmentDetailsDict: innerDict2 as! NSDictionary,productCode:"GPA")
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
                                                                                    self.policyEmpDictArray?.append(innerDict3 as? NSDictionary as! [String : String])
                                                                                    DatabaseManager.sharedInstance.saveEmployeeDetailsJSON(enrollmentDetailsDict: innerDict3 as! NSDictionary,productCode:"GTL")
                                                                                    var dict = innerDict3 as! NSDictionary
                                                                                    if userOegrpNoGTL == dict["OE_GRP_BAS_INF_SR_NO"] as? String{
                                                                                        userEmployeeSrnoGTL = dict["EMPLOYEE_SR_NO"] as! String
                                                                                        UserDefaults.standard.set(userEmployeeSrnoGTL, forKey: "userEmployeeSrnoValueGTL")
                                                                                        print("userEmployeeSrnoGTL",userEmployeeSrnoGTL)
                                                                                    }
                                                                                    
                                                                                }
                                                                            }
                                                                            
                                                                            //self.isSaveEmployeeDetails = true
                                                                            
                                                                        }
                                                                    }//>0
                                                                }
                                                            } //statusEmpDel
                                                        }
                                                        
                                                        print(self.policyEmpDictArray)
                                                        //New
                                                        
                                                        //Group_Policies_Employees_Dependants
                                                        let statusDelDep = DatabaseManager.sharedInstance.deletePersonDetails(personSrNo: "")
                                                        print("statusDelDep : ",statusDelDep)
                                                        if(statusDelDep)
                                                        {
                                                            print("Dependant found....")
                                                            
                                                            if let groupPolicyMainDepDictArray = jsonResult.value(forKey: "Group_Policies_Employees_Dependants") as? NSArray {
                                                                print(groupPolicyMainDepDictArray)
                                                                
                                                                if groupPolicyMainDepDictArray.count > 0 {
                                                                    
                                                                    print("saved dependant data...")
                                                                    if let mainDict = groupPolicyMainDepDictArray[0] as? NSDictionary {
                                                                        if let mainGmcPEDict = mainDict.value(forKey: "GroupGMCPolicyEmpDependants_data") as? NSArray {
                                                                            for innerDict1 in mainGmcPEDict {
                                                                                self.dependantsDictArray?.append(innerDict1 as? NSDictionary as! [String : String])
                                                                                DatabaseManager.sharedInstance.savePersonDetailsJSON(personDetailsDict: innerDict1 as! NSDictionary)
                                                                                var arr = innerDict1 as? [String:String]
                                                                                if arr!["RELATIONID"] as? String == "17"{
                                                                                    m_loginUserGender =  (arr!["GENDER"] as? String)!
                                                                                    UserDefaults.standard.setValue(m_loginUserGender, forKey: "LoginUserGender")
                                                                                    
                                                                                    userPersonSrnNo = (arr!["PERSON_SR_NO"] as? String)!
                                                                                    print("userPersonSrnNo: ",userPersonSrnNo)
                                                                                    UserDefaults.standard.setValue(userPersonSrnNo, forKey: "userPersonSrnNoValue")
                                                                                    
                                                                                    print("usergender")
                                                                                }
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
                                                                        
                                                                        let array  = DatabaseManager.sharedInstance.retrievePersonDetails(productCode: "GMC")
                                                                        print("personDetails:",array)
                                                                        
                                                                    }
                                                                }//>0
                                                            }
                                                            
                                                            DispatchQueue.main.async {
                                                                
                                                                let tempDict = NSDictionary()
                                                                //self.setupTabbar(userDict:tempDict)
                                                                self.loadSession = true
                                                                print("loadSession \(self.loadSession) : adminSettings \(self.adminSettings)")
                                                                self.moveToEnrollment()
                                                                UserDefaults.standard.set(true, forKey: "isAlreadylogin")
                                                            }
                                                        }//emp depend status
                                                        
                                                        print("Complete Parsing....")
                                                        
                                                        // Commented for Portal as we are not using Admin Setting call
                                                        //self.getAdminSettingsJSON()
                                                        //self.sendFCMTokenToServer()
                                                        // dispatch_async(dispatch_get_main_queue(), {
                                                    }
                                                    else{
                                                        print("Loadsession Failed")
                                                        self.navigationController?.popViewController(animated: true)
                                                    }
                                                }
                                            }else{
                                                print("Loadsession Failed")
                                               // let errorHandlerVC : LoginViewController_New = LoginViewController_New()
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
                                    }else{
                                        print("Loadsession Failed")
                                        self.displayActivityAlert(title: "Some error occured")
                                        self.navigationController?.popViewController(animated: true)
                                        
                                    }
                                }
                            }//do
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                            }
                            
                        }
                        else{
                            print("Some error occured getNewLoadSessionDataFromServerNew \(httpResponse.statusCode) !!")
                            print("Loadsession Failed")
                            //let errorHandlerVC : LoginViewController_New = LoginViewController_New()
                            //self.navigationController?.pushViewController(errorHandlerVC, animated: true)
                            DispatchQueue.main.sync(execute: {
//                                if errorHandlerVCCounter == 0{
//                                    errorHandlerVCCounter = errorHandlerVCCounter + 1
//                                    let errorHandlerVC : LoginViewController_New = LoginViewController_New()
//                                    self.navigationController?.pushViewController(errorHandlerVC, animated: true)
//                                }
//                                else{
//                                    print("Inside getUserTokenGlobal 401 already called")
//                                }
                                let errorHandlerVC : LoginViewController_New = LoginViewController_New()
                                self.navigationController?.pushViewController(errorHandlerVC, animated: true)
                            })
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}


//Extension for Admin Settings
extension EnterOTPViewController {
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
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        // self.hidePleaseWait()
                        print("found Admin Setting....333")
                        
                        do {
                            print("Started parsing Admin Settings Session...")
                            print(data)
                            self.adminSettings = true
                            
                            if let jsonResult = data as? NSDictionary
                            {
                                print("Admin Data Found")
                                if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                    if let status = msgDict.value(forKey: "Status") as? Bool {
                                        
                                        if status == true
                                        {
                                            //Group_Admin_Basic_Settings
                                            if let mainSettings = jsonResult.value(forKey: "Group_Admin_Basic_Settings") as? [String:Any] {
                                                //UserDefaults.standard.set(mainSettings, forKey: "EnrollmentGroupAdminBasicSettings")
                                                
                                                let newDict = self.removeNSNull(from: mainSettings)
                                                UserDefaults.standard.set(newDict, forKey: "EnrollmentGroupAdminBasicSettings")
                                                
                                                if let isEnrollmentThroughtMB = newDict["ENROLLMENT_THROUGH_MB"] as? String {
                                                    if isEnrollmentThroughtMB.lowercased() == "yes" {
                                                        UserDefaults.standard.set(true, forKey: "isEnrollmentThroughtMB")
                                                    }
                                                    else {
                                                        UserDefaults.standard.set(false, forKey: "isEnrollmentThroughtMB")
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
                                                //UserDefaults.standard.set(liveEventInfo, forKey: "EnrollmentLifeEventInfo")
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
                                                
                                                if let openWindPeriodInfo = windPerInfo.value(forKey: "OpenEnroll_WP_Information_data") as? NSDictionary {
                                                    // self.openEnrollmentDict = openWindPeriodInfo as! [String : String]
                                                    UserDefaults.standard.set(openWindPeriodInfo, forKey: "OpenEnroll_WP_Information_data")
                                                    
                                                }
                                                
                                                if let wpForNewJoinee = windPerInfo.value(forKey: "WP_ForNewJoinee_data") as? NSDictionary {
                                                    //self.newJoineeEnrollmentDict = wpForNewJoinee as! [String : String]
                                                    UserDefaults.standard.set(wpForNewJoinee, forKey: "WP_ForNewJoinee_data")
                                                    
                                                }
                                                
                                                //if let wpForNewJoinee = windPerInfo.value(forKey: "WP_ForNewJoinee_data") as? NSDictionary {
                                                //                                                }
                                                
                                                //WP_DurationForOpting_ParentalCoverage_data
                                                if let wpForParental = windPerInfo.value(forKey: "WP_DurationForOpting_ParentalCoverage_data") as? NSDictionary {
                                                    //UserDefaults.standard.set(wpForParental, forKey: "WP_DurationForOpting_ParentalCoverage_data")
                                                    
                                                }
                                                
                                                //WP_DurationForOpting_TopupCoverage_data
                                                if let wpForTopUpCoverage = windPerInfo.value(forKey: "WP_DurationForOpting_TopupCoverage_data") as? NSDictionary {
                                                    
                                                }
                                            }
                                                                                    }
                                        
                                    }
                                   
                                }
                                
                                print(jsonResult)
                            }//if let dict
                            print("loadSession \(self.loadSession) : adminSettings \(self.adminSettings)")
                            self.moveToEnrollment()
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
}




