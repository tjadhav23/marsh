//
//  LoginViewController.swift
//  MyBenefits
//
//  Created by Semantic on 11/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import FirebaseCrashlytics

    
class LoginViewController: UIViewController,UITextFieldDelegate,XMLParserDelegate {
    @IBOutlet weak var m_nextButton: UIButton!
    @IBOutlet weak var m_sendOTPButton: UIButton!
    
    @IBOutlet weak var m_loginView: UIView!
   
    @IBOutlet weak var m_mobileNumberTxtField: UITextField!
    @IBOutlet weak var m_otpTextField: UITextField!
    @IBOutlet weak var m_otpLine: UILabel!
    
   
    @IBAction func resendOTPButton(_ sender: Any) {
    }
    
    var m_productCode = String()
    var xmlKey = String()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    
    var dictionaryKeys = ["RequestOTPResponse","OTPStatusInformation","OTPStatus","GROUPCHILDSRNO","GROUPCODE","GROUPNAME","TPACODE","TPANAME","INSCODE","INSNAME", "OE_GRP_BAS_INF_SR_NO" ,"POLICYNO","POLICYCOMMDT","POLICYVALIDUPTO","PRODUCTCODE","EMPLOYEEID","EMPLOYEENAME","GENDER","EMPLOYEESRNO"]
   
    override func viewDidLoad()
    {
        menuButton.isHidden = true
        menuButton.removeFromSuperview()

        super.viewDidLoad()
        
        menuButton.isHidden = true
        menuButton.removeFromSuperview()

        layoutSettings()
     
        UserDefaults.standard.setValue("true", forKey: "firstTimeInstall")
        
        getCoreDataDBPath()
        
        //Overlay screens used in enrollment
        UserDefaults.standard.setValue(false, forKey: "dependantOverlay")
        UserDefaults.standard.setValue(false, forKey: "parentalOverlay")

    }
    override func viewDidAppear(_ animated: Bool)
    {
         menuButton.isHidden=true
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden=true
        
        DispatchQueue.main.async()
            {
                
            menuButton.setImage(nil, for: .normal)
            menuButton.setBackgroundImage(nil, for: .normal)
            menuButton.isHidden=true
            menuButton.removeFromSuperview()
            
        }
        
        

        self.navigationController?.isNavigationBarHidden = true
//        m_mobileNumberTxtField.isUserInteractionEnabled=true
//        m_mobileNumberTxtField.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func layoutSettings()
    {
        m_mobileNumberTxtField.layer.masksToBounds=true
        m_mobileNumberTxtField.delegate=self
        m_mobileNumberTxtField.layer.borderColor=UIColor.lightGray.cgColor
        m_mobileNumberTxtField.layer.borderWidth=1
        m_mobileNumberTxtField.becomeFirstResponder()
        m_mobileNumberTxtField.tintColor=UIColor.black
        m_mobileNumberTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        m_mobileNumberTxtField.layer.cornerRadius=m_mobileNumberTxtField.frame.size.height/2
        setLeftSideImageView(image: #imageLiteral(resourceName: "call"), textField: m_mobileNumberTxtField)
        
        m_nextButton.layer.masksToBounds=true
        if(Device.IS_IPAD)
        {
            
            m_mobileNumberTxtField.layer.cornerRadius=39
        }
        else
        {
            
            m_mobileNumberTxtField.layer.cornerRadius=23
        }
        m_nextButton.layer.cornerRadius=m_nextButton.frame.size.height/2
        m_nextButton.dropShadow()
        
    }
    @IBAction func sendOTPButton(_ sender: Any)
    {
        if m_mobileNumberTxtField.text?.isEmpty ?? true
        {
           
            displayActivityAlert(title: "Enter mobile number")
            
        }
        else
        {
            if (m_mobileNumberTxtField.text?.count == 10)
            {
               
                getPostLoginDetails()
            }
            else
            {
                displayActivityAlert(title: "Please enter valid mobile number")
            }
        }
                
                
    }
    
    func getCoreDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

        print("Core Data DB Path :: \(path ?? "Not found")")
    }
    
    func getPostLoginDetails()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg:"Please wait...")
            
            /*let yourXML = AEXMLDocument()
            
            let dataRequest = yourXML.addChild(name: "DataRequest")
            dataRequest.addChild(name: "mobileno", value: m_mobileNumberTxtField.text!)
            print(yourXML.xml)*/
            
            let string="<DataRequest><mobileno>\(m_mobileNumberTxtField.text!)</mobileno></DataRequest>"
            let uploadData = string.data(using: .utf8)
            
            let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getSendOtpPostUrl() as String)
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?
            request.httpMethod = "POST"
            request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
            request.httpBody=uploadData
            let session = URLSession(configuration: .default)
            
            print(urlreq ?? "")
            print(string)
        
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if error != nil {
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
                                    let status = obj["OTPStatusInformation"]
                                    
                                    DispatchQueue.main.async(execute:
                                        {
                                        m_loginIDMobileNumber = self.m_mobileNumberTxtField.text!
                                            if(status == "3") //|| (status == "1")
                                            {
                                                
                                                let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                                
                                                enterOTPVC.mobileNumber=self.m_mobileNumberTxtField.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
                                                
                                            }
                                            else if(status=="2")
                                            {
//                                                let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
//
//                                                enterOTPVC.mobileNumber=self.m_mobileNumberTxtField.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
                                               self.displayActivityAlert(title: "Mobile number doesn't exist")
                                            }
                                            else if(status=="1")
                                            {
                                                let msg = """
                                                    Your Benefits You India services have expired or your mobile number is not updated in our records.
                                                    Kindly call our customer service representative or your HR
                                                    """
                                                self.displayActivityAlert(title: msg)
                                                /*let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                                
                                                enterOTPVC.mobileNumber=self.m_mobileNumberTxtField.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)*/
                                            }
                                            else if(status == "0")
                                            {
                                                                               self.displayActivityAlert(title: "OTP not generated")
                                               /* let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                                enterOTPVC.mobileNumber=self.m_mobileNumberTxtField.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)*/
                                            }
                                            else
                                            {
                                                let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                                
                                                enterOTPVC.mobileNumber=self.m_mobileNumberTxtField.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
                                            }
                                            self.hidePleaseWait()
                                    })
                                }
                                
                            }
                            catch let JSONError as NSError
                            {
                                print(JSONError)
                                self.hidePleaseWait()
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
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
    func storeAppSessionValues()
    {
       
        let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getAppSesionValuesUrl(mobileNumber: m_mobileNumberTxtField.text!))
       
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = urlreq as URL?// NSURL(string: urlreq)
        request.httpMethod = "GET"
        
        
        
        let task = URLSession.shared.dataTask(with: urlreq! as URL)
        {
            (data, response, error)  -> Void in
            if error != nil
            {
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
                        do {
                            
                            self.xmlKey = "SessionValues"
                            let parser = XMLParser(data: data!)
                            parser.delegate = self
                            parser.parse()
                            print(self.resultsDictArray ?? "")
                            DispatchQueue.main.async
                            {
                                let status = DatabaseManager.sharedInstance.deleteEmployeeDetails(productCode: self.m_productCode)
                                for obj in self.resultsDictArray!
                                {
               
                                    print(obj)
                                    let userDict : NSDictionary = self.resultsDictArray![0] as NSDictionary
                                    UserDefaults.standard.set(userDict , forKey: "UserAppSessionDict")
            
               
                                    if (status)
                                    {
                                        DatabaseManager.sharedInstance.saveEmployeeDetails(enrollmentDetailsDict: userDict,productCode: "")
                                    }
            
                
//                                    let srNo = userDict.value(forKey:"EMPLOYEESRNO")
//                                    UserDefaults.standard.set(srNo, forKey: "EmployeeSrNo")
                                    print(userDict)
                                }
                            }
                            print("error in call")
                            self.hidePleaseWait()
                        }
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                            Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                            self.hidePleaseWait()
                        }
                    }
                    else
                    {
                        self.hidePleaseWait()
                        Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                    }
                }
                else
                {
                    Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                    print("Can't cast response to NSHTTPURLResponse")
                }
                
            }
            
        }
        task.resume()
  
    }
    
    func animateTextField(_ textField:UITextField, with up: Bool)
    {
        var movementDistance=0
        let movementDuration=0.3
        if(textField.tag==1)
        {
            if(isFromforeground)
            {
                movementDistance=90;
            }
            else
            {
                movementDistance=0;
            }
            
        }
        else
        {
            movementDistance=80;
        }
        
        
        let movement = (up ? -movementDistance : movementDistance);
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame=self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
        
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
                    self.currentDictionary![elementName] = currentValue
                    self.currentValue = ""

                }
                
                
            }
            
            func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
            {
                
                
            }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        view.endEditing(true)
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        animateTextField(textField, with: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        animateTextField(textField, with: false)
        if(textField.tag == 2)
        {
            
            textField.resignFirstResponder()
            
        }
        if m_mobileNumberTxtField.text?.isEmpty ?? true
        {
            
            shakeTextfield(textField: textField)
            
        }
        else
        {
            if (m_mobileNumberTxtField.text?.count != 10)
            {
                shakeTextfield(textField: textField)
            }
            
        }
        
       
    }
    @objc func textFieldDidChange(_ textfield:UITextField)
    {
       
        if((textfield.text?.count)!>9)
        {
            textfield.resignFirstResponder()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let MAX_LENGTH_PHONENUMBER = 10
        let ACCEPTABLE_NUMBERS     = "0123456789"
        let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
        let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
        let strValid = string.rangeOfCharacter(from: numberOnly) == nil
        
        if(newLength>MAX_LENGTH_PHONENUMBER+1)
        {
            textField.resignFirstResponder()
        }
        return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
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
