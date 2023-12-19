//
//  EnrollmentServerRequestManager.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 20/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AesEverywhere

class EnrollmentServerRequestManager: NSObject {
    
    static let serverInstance = EnrollmentServerRequestManager()
    var imageView = UIImageView()
    var username = "nPsnEnXx1s3nmwLKgYWYNMtCE/gJ0gUx5Me6ZDkocydjGo9kB0KvFx620L05C489HtUi5mI6XljZxUvW/b/2EM4LDmlMj24r+Ybju3ZcYVHKA2vVbrB/4uVMF4hBBtpi"//"Common"
    var password = "qZy+QBOVxQkVpVAo284+ZbOixwuuTwY1NSbYcpJSTHnB1G/0vhY+sSbLHNt1gGsKowkv6mvWcGVfQTvmVkETZiwK/wUY2SDzeGAuBDgs52mRt8mz/5uH0t7vszipVPLS"//"Password"
    
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    var m_employeeDict : EMPLOYEE_INFORMATION?

    func postDataToServer(url:String,dictionary:NSDictionary, view:UIViewController, onComplition:@escaping (JSON?,NSError?)->Void){
        
        
        view.showPleaseWait(msg: "")
        //let urlwithPercentEscapes = url.URLEncoded
        
        var urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        
       // let urlNew = url.replacingLastOccurrenceOfString(" ", with: "%20")
        let serverURL = URL(string: urlString!)

        print("URL:",serverURL)
        // print(dictionary)
        // print(dictionary)
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        // Helper.sharedInstance.showLoader()
        
        let jsonObj = dictionary.json
        
        let parameters:Parameters = dictionary as! Parameters
        
        //Shubham Commented
        //Alamofire.request(serverURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:{ response in
        Alamofire.request(serverURL!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler:{ response in
          
            switch response.result{
                
            case .success:
                //  Helper.sharedInstance.hideLoader()
                
                view.hidePleaseWait()
                
                let jsonData = JSON(response.result.value!)
                print(jsonData)
                onComplition(jsonData,nil)
                break
            case .failure(let error):
                // Helper.sharedInstance.hideLoader()
                view.hidePleaseWait()
                
                print(error.localizedDescription)
                
                
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
            }
        })
        
        
    }
    
    func postDictionaryDataToServer(url:String,dictionary:NSDictionary, view:UIViewController, onComplition:@escaping([String:AnyObject]?,NSError?)->Void){
        
        
        view.showPleaseWait(msg: "")
        //let urlwithPercentEscapes = url.URLEncoded
        
        var urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        
       // let urlNew = url.replacingLastOccurrenceOfString(" ", with: "%20")
        let serverURL = URL(string: urlString!)

        print("URL:",serverURL)
        // print(dictionary)
        // print(dictionary)
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        // Helper.sharedInstance.showLoader()
        
        let jsonObj = dictionary.json
        
        let parameters:Parameters = dictionary as! Parameters
        print("serverURL : ",serverURL,"\n parameters",parameters,"\n headers",headers)
        
        //Shubham Commented
        //  Alamofire.request(serverURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:{ response in
        Alamofire.request(serverURL!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler:{ response in
            
            print("Inside Alamofire serverURL : ",serverURL,"\n parameters",parameters,"\n headers",headers)
            
            print("response : ",response)
           
            
            switch response.result{
                
            case .success:
                //  Helper.sharedInstance.hideLoader()
                
                view.hidePleaseWait()
                
//                let jsonData = JSON(response.result.value!)
//                print(jsonData)
                if let data = response.result.value! as? NSDictionary {
                                         // do {
                                   //let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:AnyObject]
                                   onComplition(data as! [String : AnyObject],nil)
                               }
                               else {
                                   print("Failed to make dictionary")
                                   
                                   
                               }
                print("response: ",response.result.value!)
                break
            case .failure(let error):
                // Helper.sharedInstance.hideLoader()
                view.hidePleaseWait()
                
                print(error.localizedDescription)
                
                
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
            }
        })
        
        /*
         Alamofire.request(serverURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:{ response in
             
             switch response.result{
                 
             case .success:
                 //  Helper.sharedInstance.hideLoader()
                 
                 view.hidePleaseWait()
                 
 //                let jsonData = JSON(response.result.value!)
 //                print(jsonData)
                 if let data = response.result.value! as? NSDictionary {
                                          // do {
                                    //let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:AnyObject]
                                    onComplition(data as! [String : AnyObject],nil)
                                }
                                else {
                                    print("Failed to make dictionary")
                                    
                                    
                                }
                 break
             case .failure(let error):
                 // Helper.sharedInstance.hideLoader()
                 view.hidePleaseWait()
                 
                 print(error.localizedDescription)
                 
                 
                 self.ShowAlert(viewController: view, message: error.localizedDescription)
                 
                 
                 let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                 onComplition(nil,errorObj)
                 break
             }
         })
        */
        
    }
    
    
    
        func postDictionaryDataToServerNoLoader(url:String,dictionary:NSDictionary, onComplition:@escaping([String:AnyObject]?,NSError?)->Void){
            
            
            //let urlwithPercentEscapes = url.URLEncoded
            
            var urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

            
            let serverURL = URL(string: urlString!)

            print("URL:",serverURL)
      
            var headers: HTTPHeaders = [:]
            if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
                headers[authorizationHeader.key] = authorizationHeader.value
            }
            
            
            let jsonObj = dictionary.json
            
            let parameters:Parameters = dictionary as! Parameters
            
            Alamofire.request(serverURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:{ response in
                switch response.result{
                    
                case .success:
      
                    if let data = response.result.value! as? NSDictionary {
                                       onComplition(data as! [String : AnyObject],nil)
                                   }
                                   else {
                                       print("Failed to make dictionary")
                                       
                                       
                                   }
                    break
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    
                    
                    
                    
                    let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                    onComplition(nil,errorObj)
                    break
                }
            })
            
            
        }
    
    
    func postDataToServerWithoutLoader(url:String,dictionary:NSDictionary, view:UIViewController, onComplition:@escaping (JSON?,NSError?)->Void){
        
        //let serverURL = URL(string: String(format: url))
        // print("URL:",serverURL!)
        
        // view.showPleaseWait(msg: "Please wait...")
        //view.view.showSpinner()
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        // print(dictionary)
        print(dictionary)
        
        
        
        //let header:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        // Helper.sharedInstance.showLoader()
        
        let jsonObj = dictionary.json
        
        let parameters:Parameters = dictionary as! Parameters
        
        Alamofire.request(serverURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:{ response in
            switch response.result{
                
            case .success:
                //  Helper.sharedInstance.hideLoader()
                //view.view.removeSpinner()
                
                let jsonData = JSON(response.result.value!)
                print(jsonData)
                onComplition(jsonData,nil)
                break
            case .failure(let error):
                // Helper.sharedInstance.hideLoader()
                //view.view.removeSpinner()
                
                print(error.localizedDescription)
                
                
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
            }
        })
        
        
    }
    
    func deleteDataToServer(url:String,dictionary:NSDictionary, view:UIViewController, onComplition:@escaping (JSON?,NSError?)->Void){
        
        let serverURL = URL(string: String(format: url))
        print("URL:",serverURL!)
        
        view.showPleaseWait(msg: "")
        
        print("URL:",serverURL)
        // print(dictionary)
        // print(dictionary)
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        // Helper.sharedInstance.showLoader()
        
        let jsonObj = dictionary.json
        
        let parameters:Parameters = dictionary as! Parameters

        
        Alamofire.request(serverURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:{ response in
            
            switch response.result{
                
            case .success:
                //  Helper.sharedInstance.hideLoader()
                
                view.hidePleaseWait()
                
                let jsonData = JSON(response.result.value!)
                print(jsonData)
                onComplition(jsonData,nil)
                break
            case .failure(let error):
                // Helper.sharedInstance.hideLoader()
                view.hidePleaseWait()
                
                print(error.localizedDescription)
                
                
                self.ShowAlert(viewController: view, message: "Failed to delete dependant")
                
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
            }
        })
        
        
    }

    
    
    
    //MARK:- Get Data with view
    func getRequestDataFromServer(url:String,view:UIViewController, onComplition:@escaping ( [String:AnyObject]?,NSError?)->Void){
        
        
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        var requestMethod = HTTPMethod.get
        view.showPleaseWait(msg: "")
        // view.view.showSpinner()
        
         var headers: HTTPHeaders = [:]
        var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
        var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

        print("m_authUserName_Portal ",encryptedUserName)
        print("m_authPassword_Portal ",encryptedPassword)
//         if let authorizationHeader = Request.authorizationHeader(user: encryptedUserName, password: encryptedPassword) {
//         headers[authorizationHeader.key] = authorizationHeader.value
//         }
        authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
        print("authToken getRequestDataFromServer :",authToken)
        headers = ["Authorization": "Bearer \(authToken)"]
         
        // Helper.sharedInstance.showLoader()
        if urlString!.contains("LoadSessionValues"){
            requestMethod = HTTPMethod.post
        }else{
            requestMethod = HTTPMethod.get
        }
        print("requestMethod: ",requestMethod)
        
        
        Alamofire.request(serverURL!, method: requestMethod, parameters: nil, encoding:URLEncoding.default, headers:headers).responseJSON(completionHandler:{ response in
            
            print("Url is",serverURL)
            
            print("Response is: ",response)
            
            switch response.result{
                
            case .success:
                
                print("found data")
                //view.view.removeSpinner()
                view.hidePleaseWait()
                // let jsonData = JSON(response.result.value!)
                //print(jsonData)
                // onComplition(jsonData,nil)
                
                //
                if let data = response.result.value! as? NSDictionary {
                          // do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:AnyObject]
                    onComplition(data as! [String : AnyObject],nil)
                }
                else {
                    print("Failed to make dictionary")
                    
                    
                }
                
                  //  catch {
                //  print("Error while jsonserialization")
                //}
                //}
                
                
                break
            case .failure(let error):
                
                view.hidePleaseWait()
                
                // view.view.removeSpinner()
                
                
                print(error.localizedDescription)
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
                
            }
        })
        
        
    }
    
    
    func getRequestDataFromServerPostNew(url:String,view:UIViewController, onComplition:@escaping ( Data?,NSError?)->Void){
        
        
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        
        view.showPleaseWait(msg: "")
        // view.view.showSpinner()
        /*
         var headers: HTTPHeaders = [:]
         if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
         headers[authorizationHeader.key] = authorizationHeader.value
         }
         */
        // Helper.sharedInstance.showLoader()
        
        Alamofire.request(serverURL!, method:.post, parameters: nil, encoding:URLEncoding.default, headers:nil).responseJSON(completionHandler:{ response in
            
            
            switch response.result{
                
            case .success:
                
                print("found data")
                //view.view.removeSpinner()
                view.hidePleaseWait()
                // let jsonData = JSON(response.result.value!)
                //print(jsonData)
                // onComplition(jsonData,nil)
                
                //
//                if let data = response.result.value! as? NSDictionary {
//                          // do {
//                    //let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:AnyObject]
//                    onComplition(data as! [String : AnyObject],nil)
//                }
                if let Data = response.result.value{
                    onComplition(Data as! Data,nil)
                }else {
                    print("Failed to make dictionary")
                    
                    
                }
                
                  //  catch {
                //  print("Error while jsonserialization")
                //}
                //}
                
                
                break
            case .failure(let error):
                
                view.hidePleaseWait()
                
                // view.view.removeSpinner()
                
                
                print(error.localizedDescription)
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
                
            }
        })
        
        
    }
    
    
    //New added for Portal
    func getRequestDataFromServerPost(url:String,view:UIViewController, onComplition:@escaping ( [String:AnyObject]?,NSError?)->Void){
        
        
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        
        view.showPleaseWait(msg: "")
        // view.view.showSpinner()
        
         var headers: HTTPHeaders = [:]
        var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
        var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

        print("m_authUserName_Portal ",encryptedUserName)
        print("m_authPassword_Portal ",encryptedPassword)
        
         if let authorizationHeader = Request.authorizationHeader(user: encryptedUserName, password: encryptedPassword) {
         headers[authorizationHeader.key] = authorizationHeader.value
         }
         
        // Helper.sharedInstance.showLoader()
        
        Alamofire.request(serverURL!, method:.post, parameters: nil, encoding:URLEncoding.default, headers:headers).responseJSON(completionHandler:{ response in
            
            print("response: ",response)
            
            switch response.result{
                
            case .success:
                
                print("found data")
                //view.view.removeSpinner()
                view.hidePleaseWait()
                // let jsonData = JSON(response.result.value!)
                //print(jsonData)
                // onComplition(jsonData,nil)
                
                //
                if let data = response.result.value! as? NSDictionary {
                          // do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:AnyObject]
                    onComplition(data as! [String : AnyObject],nil)
                }
                else {
                    print("Failed to make dictionary")
                    
                    
                }
                
                  //  catch {
                //  print("Error while jsonserialization")
                //}
                //}
                
                
                break
            case .failure(let error):
                
                view.hidePleaseWait()
                
                // view.view.removeSpinner()
                
                
                print(error.localizedDescription)
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
                
            }
        })
        
        
    }
    
    
    func getArrayRequestDataFromServer(url:String,view:UIViewController, onComplition:@escaping ( JSON?,NSError?)->Void){
        
        
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        
        view.showPleaseWait(msg: "")
        // view.view.showSpinner()
        /*
         var headers: HTTPHeaders = [:]
         if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
         headers[authorizationHeader.key] = authorizationHeader.value
         }
         */
        // Helper.sharedInstance.showLoader()
        
        Alamofire.request(serverURL!, method:.get, parameters: nil, encoding:URLEncoding.default, headers:nil).responseJSON(completionHandler:{ response in
            
            
            switch response.result{
                
            case .success:
                
                print("found data")
                //view.view.removeSpinner()
                view.hidePleaseWait()
                 let jsonData = JSON(response.result.value!)
                print(jsonData)
                 onComplition(jsonData,nil)
                
                //
//                if let data = response.result.value! as? NSDictionary {
//                          // do {
//                    onComplition(data as! [String : AnyObject],nil)
//                }
//                else {
//                    print("Failed to make dictionary")
//
//
//                }
                
                  //  catch {
                //  print("Error while jsonserialization")
                //}
                //}
                
                
                break
            case .failure(let error):
                
                view.hidePleaseWait()
                
                // view.view.removeSpinner()
                
                
                print(error.localizedDescription)
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
                
            }
        })
        
        
    }

    var m_enrollmentStatus = false
    var isWindowPeriodOpen = false
    
        func getBGGHITopUpOptionsFromServer()
        {
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                m_employeeDict=userArray[0]
            }
            
            
            
                
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
                    print(url)
                    
                        let dict = ["":""]

                    self.postDictionaryDataToServerNoLoader(url: url, dictionary: dict as NSDictionary) { (data, error) in

                            
                        if error != nil
                        {
                            print("error ",error!)
                            //self.hidePleaseWait()
                        }
                        else
                        {
                            // self.hidePleaseWait()
                            print("found Admin Setting....524")
                            
                            do {
                                print("Started parsing Top Up...EnrollmentServerRequestManager")
                                print(data)
                                
                                let center = UNUserNotificationCenter.current()
                                center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
                                center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

                                
                                if let jsonResult = data as? NSDictionary
                                {
                                    print("Admin Data Found.. EnrollmentServerRequestManager")
                                    if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                        if let status = msgDict.value(forKey: "Status") as? Bool {
                                            
                                            if status == true
                                            {
                                                print(jsonResult)
                                                
                                                
                                                 
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
                                                
                                                

           
                                                
                                                self.setEnrollmentData()
                                                }
                                            }
                                    }
                                            else {
                                                //No Data found
                                            }
                                        }//status
                                    }//msgDict
                                
                            
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                            }
                        }//else
                    }//server call
                }//userArray
            
    }
    

    
    var m_windowPeriodEndDate = Date()
    var m_groupAdminBasicSettingsDict = NSDictionary()
    var m_enrollmentMiscInformationDict = NSDictionary()
    var newJoineeEnrollmentDict = [String: String]()
    var openEnrollmentDict = [String: String]()

    func setEnrollmentData()
    {
        
        if let openEnrollDict =  UserDefaults.standard.value(forKey: "OpenEnroll_WP_Information_data") as? [String : String] {
                   openEnrollmentDict = openEnrollDict
               }
               
               if let newJoineeDict = UserDefaults.standard.value(forKey: "WP_ForNewJoinee_data") as? [String : String] {
                newJoineeEnrollmentDict = newJoineeDict
               }
        
        if let groupAdminBasic = UserDefaults.standard.value(forKey: "EnrollmentGroupAdminBasicSettings")
        {
            m_groupAdminBasicSettingsDict = groupAdminBasic as! NSDictionary
        }
        
        if let enrollmentMiscInfo = UserDefaults.standard.value(forKey: "EnrollmentMiscInformation")
        {
            m_enrollmentMiscInformationDict = enrollmentMiscInfo as! NSDictionary
        }
        
        if let enrollmentLifeEvent = UserDefaults.standard.value(forKey: "EnrollmentLifeEventInfo")
        {
            m_enrollmentLifeEventInfoDict = enrollmentLifeEvent as! NSDictionary
        }
        
        if let serverDate = m_groupAdminBasicSettingsDict.value(forKey: "Server_Date")as? String
        {
            m_serverDate = convertStringToDate(dateString: serverDate)
        }
        else
        {
            m_serverDate = Date()
        }
        print(m_serverDate)
        
        let dict : NSDictionary = openEnrollmentDict as NSDictionary
        let newJoineeDict : NSDictionary = newJoineeEnrollmentDict as NSDictionary
        var isStartDateForNewJoinee = String()
        if let date = dict.value(forKey: "WINDOW_PERIOD_START_DATE")as? String
        {
            let startDate = convertStringToDate(dateString:date)
            let joiningDate = convertStringToDate(dateString: (m_employeeDict?.dtaeOfJoining)!)
            print(joiningDate)
            if(joiningDate>startDate)
            {
                
                let enrollmentType = m_groupAdminBasicSettingsDict.value(forKey: "ENROLMENT_TYPE")as? String
                if(enrollmentType=="ONGOING")
                {
                    if let endDate = dict.value(forKey: "WINDOW_PERIOD_END_DATE")as? String
                    {
                        if let isStartDateNewJoinee = newJoineeDict.value(forKey: "STARTS_FROM_DATE_OF_DATAINSERT")
                        {
                            isStartDateForNewJoinee=isStartDateNewJoinee as! String
                        }
                        let duration = newJoineeDict.value(forKey: "DATE_DURATION")as! String
                        
                        //MARK:- WP
                        m_windowPeriodEndDate = convertStringToDate(dateString:endDate)
                        if(isStartDateForNewJoinee == "YES")
                        {
                            if let dataInsertDate = m_employeeDict?.dateofDataInsert
                            {
                                let dateofDataInsert = convertStringToDate(dateString: dataInsertDate)
                                
                                if let extensionDays = Int(duration)
                                {
                                    if let tomorrow = Calendar.current.date(byAdding:.day, value: extensionDays, to: dateofDataInsert)
                                    {
                                        m_windowPeriodEndDate=tomorrow
                                    }
                                }
                            }
                            
                        }
                        else if let extensionDays = Int(duration)
                        {
                            if let tomorrow = Calendar.current.date(byAdding:.day, value: extensionDays, to: joiningDate)
                            {
                                m_windowPeriodEndDate=tomorrow
                            }
                        }
                        calculateRemainingDays()
                    }
                }
            }
            else
            {
                if let date = dict.value(forKey: "WINDOW_PERIOD_END_DATE")as? String
                {
                    m_windowPeriodEndDate = convertStringToDate(dateString:date)
                    calculateRemainingDays()
                    
                }
            }
            
            
        }
        
        
    }
    
    func convertStringToDate(dateString:String)->Date
       {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd/MM/yyyy" //Your date format
           dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
           
          if let date = dateFormatter.date(from: dateString)
          {
               print(date )

           
               return date
           }
           return Date()
       }
    func calculateRemainingDays()
    {
        let dateRangeStart = m_serverDate
        let dateRangeEnd = m_windowPeriodEndDate
        var components = Calendar.current.dateComponents([.day,.weekOfYear, .month], from: dateRangeStart, to: dateRangeEnd)
        var days : Int = Calendar.current.dateComponents([.day], from: dateRangeStart, to: dateRangeEnd).day ?? 0
                days = days+1
        
        
        if(days<=0)
        {
            
          //  m_windowPeriodStatusLbl.text="CLOSED"
            m_windowPeriodStatus=false
//            m_daysLbl.isHidden=true
//            m_daysLeftTitleLbl.isHidden=true
//            enrollMentImageView.isHidden=false
//            m_enrollmentStatusLbl.text="Download Summary"
//            m_enrollmentStatusImgview.image=UIImage(named: "download-2")
            //            m_enrollmentStatusLbl.text="Add Dependants"
            //            m_enrollmentStatusImgview.image=UIImage(named: "add")
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
            center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

            
        }
        else
        {
         //   m_windowPeriodStatusLbl.text="OPEN"
            m_windowPeriodStatus=true
         //   m_daysLbl.text = String(days)
         //   m_daysLbl.isHidden=false
         //   m_daysLeftTitleLbl.isHidden=false
         //   enrollMentImageView.isHidden=true
            if(m_enrollmentStatus)
            {
              //  m_enrollmentStatusLbl.text="Download Summary"
              //  m_enrollmentStatusImgview.image=UIImage(named: "download-2")
                let center = UNUserNotificationCenter.current()
                center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
                center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

            }
            else
            {
             //   m_enrollmentStatusLbl.text="Continue Enrollment"
            //    m_enrollmentStatusImgview.image=UIImage(named: "continue")
               setLocalNotifications(startDate: Date(), endDate: m_windowPeriodEndDate)

            }
            
        }
        
        print(dateRangeStart)
        print("difference is \(components.month ?? 0) months and \(components.weekOfYear ?? 0) weeks")
    }
    
        func setLocalNotifications(startDate:Date,endDate:Date) {
            // Swift
            
            var dateRangeArray = self.datesRange(from: startDate, to: endDate)
             print("Date Array-")
            print(dateRangeArray)
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
            center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

            if dateRangeArray.count > 0 {
                
                dateRangeArray.removeLast()

                for dateObj in dateRangeArray {
            
            
            let date = m_windowPeriodEndDate.getDateStrdd_mmm_yy()

            let content = UNMutableNotificationContent()
            content.title = "Enrollment Window"
            content.body = "Your Enrollment Window closes on \(date). Update your dependant details and confirm your benefits selections before closure of window."
                    
                 //   "Your Enrollment Window is open till \(date). Please confirm before the Enrollment Window periods ends."
            content.sound = UNNotificationSound.default()

            
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized {
                    // Notifications not allowed
                }
            }
            
           // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                    let gregorian = Calendar(identifier: .gregorian)

                    var dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: dateObj)
                    //dateComponents.year = 2020
                    dateComponents.hour = 11
                    dateComponents.minute = 0
                    dateComponents.second = 0
                    
                    let identifier = "EnrollmentLocalNotification"
    print(dateComponents)
                    
                    
                    let datepp = gregorian.date(from: dateComponents)!

                    let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: datepp)

                    let trigger =  UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                    

           // let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print(error)
                    // Something went wrong
                }
            })
                }//for
        }
        }
    
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        
        print("From = \(from)")
        print("To = \(to)")

        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
    
    /*
     //MARK:- Get Data with view
     func getQuickTypeRequestDataFromServer(url:String,view:UIViewController, onComplition:@escaping ( [String:AnyObject]?,NSError?)->Void){
     
     
     
     let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
     let serverURL = URL(string: urlString!)
     print("URL:",serverURL)
     
     view.showPleaseWait(msg: "")
     // view.view.showSpinner()
     /*
     var headers: HTTPHeaders = [:]
     if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
     headers[authorizationHeader.key] = authorizationHeader.value
     }
     */
     // Helper.sharedInstance.showLoader()
     
     Alamofire.request(serverURL!, method:.get, parameters: nil, encoding:URLEncoding.default, headers:nil).responseJSON(completionHandler:{ response in
     
     
     switch response.result{
     
     case .success:
     
     print("found data")
     view.hidePleaseWait()
     if let data = response.result.value! as? Data {
        let user = try! JSONDecoder().decode(Welcome.self, from: Data(response))

        
        onComplition(data as! [String : AnyObject],nil)

     }
     
     
     
     break
     case .failure(let error):
     
     view.hidePleaseWait()
     
     // view.view.removeSpinner()
     
     
     print(error.localizedDescription)
     self.ShowAlert(viewController: view, message: error.localizedDescription)
     
     let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
     onComplition(nil,errorObj)
     break
     
     }
     })
     
     
     }
  */
    func getRequestDataFromServerWithoutLoader(url:String,view:UIViewController, onComplition:@escaping (JSON?,NSError?)->Void){
        
        
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        
        //  view.view.showSpinner()
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        // Helper.sharedInstance.showLoader()
        
        Alamofire.request(serverURL!, method:.get, parameters: nil, encoding:URLEncoding.default, headers:headers).responseJSON(completionHandler:{ response in
            
            
            switch response.result{
                
            case .success:
                
                
                // view.view.removeSpinner()
                
                let jsonData = JSON(response.result.value!)
                print(jsonData)
                onComplition(jsonData,nil)
                break
            case .failure(let error):
                
                
                // view.view.removeSpinner()
                
                
                print(error.localizedDescription)
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
            }
        })
        
        
    }
    
    
    
    
    
    
    
    
    //MARK:- Show Alert
    func ShowAlert(viewController : UIViewController,message : String) {
        
        viewController.displayActivityAlert(title: message)
        
        //        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        //      alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        //    viewController.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}


extension String {
    var URLEncoded:String {
        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharset = NSCharacterSet(charactersIn: unreservedChars)
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: unreservedCharset as CharacterSet)
        return encodedString ?? self
    }
}
