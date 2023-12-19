//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
//import VHUD
// import SVProgressHUD
import MBProgressHUD
import IOSSecuritySuite
import TrustKit
import AesEverywhere


var isRemoveFlag = 0
var m_productCodeArray : Array<String>=[]
var menuButton = UIButton()
var employeeName = String()
var hightlightColor = "203368"//"0070d5"      //dark blue color
var gradiantColor2 = "203368"//"51acff"       //light blue color
var gradiantWhiteColor = "ffffff"  //pure white color
var isFromforeground = Bool()
var m_windowPeriodStatus = Bool()
var getAdminStatus = Bool()
var m_enrollmentLifeEventInfoDict = NSDictionary()

let m_authUserName = "MB360"
let m_authPassword = "$EM@MB360"
let m_authUserName_Portal = "MB360"
let m_authPassword_Portal = "$EM@MB360"
let m_passphrase_Portal = "c718eb7dad182udxdiu2uw1ui3d"
//let m_authUserName_Portal = "nPsnEnXx1s3nmwLKgYWYNMtCE/gJ0gUx5Me6ZDkocydjGo9kB0KvFx620L05C489HtUi5mI6XljZxUvW/b/2EM4LDmlMj24r+Ybju3ZcYVHKA2vVbrB/4uVMF4hBBtpi"
//let m_authPassword_Portal = "qZy+QBOVxQkVpVAo284+ZbOixwuuTwY1NSbYcpJSTHnB1G/0vhY+sSbLHNt1gGsKowkv6mvWcGVfQTvmVkETZiwK/wUY2SDzeGAuBDgs52mRt8mz/5uH0t7vszipVPLS"
var m_loginIDMobileNumber = String()
var m_loginIDEmail = String()
var m_loginIDWeb = String()
var m_OTP = String()
var m_loginUserGender = String()
var m_loginUserName = String()
var userEmployeeSrno = String()
var userEmployeeSrnoGPA = String()
var userEmployeeSrnoGTL = String()
var employeeSrNoGMCValue = String()
var userEmployeIdNo = String()
var userPersonSrnNo = String()
var userOegrpNo = String()
var userOegrpNoGMC = String()
var userOegrpNoGPA = String()
var userOegrpNoGTL = String()
var employeeSrNoGMC = String()
var employeeDOJ = String()
var userGroupChildNo = String()
var userDESIGNATION = String()
var TPA_CODE_GMC_Base = String()
var GROUPCODE = String()
var POLICY_NUMBER_GMC_Base = String()
var POLICY_COMMENCEMENT_DATE_GMC_Base = String()
var POLICY_VALID_UPTO_GMC_Base = String()
var isGHIDataPresent : Bool = false
var isGPADataPresent : Bool = false
var isGTLDataPresent : Bool = false

var authToken = String() // used for barer token api calls

let m_errorMsg = "Unable to reach server please try again later."
let err_no_503 = "Service is unavailable"
let err_no_404 = "No Response From Server"
let err_no_0 = "No Response From Server"
let err_no_1000 = "Invalid Request Code"
let err_no_1001 = "No data found!"
let err_no_1002 = " UndefinedError"
let err_no_1003 = "Error occured"
let err_no_1004 = "Coming soon"
let error_NoInternet = "No internet!"
let m_errorMsgFile = "File not found"
let error_State = "Something went wrong!"
var m_serverDate = Date()
var m_isFirstTime = true
var isGPAEmployee = false
var m_spouse = String()
var documentController: UIDocumentInteractionController = UIDocumentInteractionController()
var cornerRadiusForView : CGFloat = 8
var isJailbrokenDevice : Bool = false

var errorCount = 0
var errorHandlerVCCounter = 0
//SSL Values
let sslTimeOut : TimeInterval = 30
//let trustKitConfig = [
//    kTSKPinnedDomains: [
//        "*.benefitsyou.com": [
//            kTSKIncludeSubdomains: true,
//            kTSKPublicKeyHashes: [
//                "r/mIkG3eEpVdm+u/ko/cwxzOMo1bc04TyHIlByibiA5E=",
//                "5RkZzbncDxKQ+WUG1Ft48BRMTfag450oXOmWOfgik5Tk=",
//                "5RkZzbncDxKQ+WUG1Ft48BRMTfag450oXOmWOfgik5Tk="
//            ]
//        ]
//    ]
//]
//let trustKitConfig = [
//    kTSKPinnedDomains: [
//        "uat-employee.benefitsyou.com": [
//            kTSKIncludeSubdomains: true,
//            kTSKPublicKeyHashes: [
//                "grX4Ta9HpZx6tSHkmCrvpApTQGo67CYDnvprLg5yRME=",
//                "4kf/WXMC9NgXfHWIsy6w3zzeUYXa7kxJLaP5AM3mxHA=",
//                "4kf/WXMC9NgXfHWIsy6w3zzeUYXa7kxJLaP5AM3mxHA="
//            ]
//        ]
//    ]
//]

let trustKitConfig = [
    kTSKPinnedDomains: [
        "employee.benefitsyou.com": [
            kTSKIncludeSubdomains: true,
            kTSKPublicKeyHashes: [
                "grX4Ta9HpZx6tSHkmCrvpApTQGo67CYDnvprLg5yRME=",
                "PCw9IppwACE3PMA5kk0aNI3BczMvCG7en3R8k6BYqJE=",
                "PCw9IppwACE3PMA5kk0aNI3BczMvCG7en3R8k6BYqJE="
            ]
        ]
    ]
]

extension UIViewController {
    
    
    
//    func displayActivityAlert(title: String)
//    {
//        let pending = UIAlertController(title: title, message: nil, preferredStyle: .alert)
//
//        present(pending, animated: true, completion: nil)
//        let deadlineTime = DispatchTime.now() + .seconds(2)
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime)
//        {
//            pending.dismiss(animated: true, completion: nil)
//
//        }
//
//    }
    
    func displayActivityAlert(title: String)
    {
        DispatchQueue.main.async { () -> Void in

        let pending = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
            self.present(pending, animated: true, completion: nil)
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime)
        {
            pending.dismiss(animated: true, completion: nil)
            
        }
        }
        
    }
    
    func checkEmployeeDataPresent(_ btnGhi : UIButton,_ btnGpa : UIButton,_ btnGtl : UIButton){
        if isGHIDataPresent{
            btnGhi.isUserInteractionEnabled = true
        }else{
            btnGhi.isUserInteractionEnabled = false
        }
        
        if isGPADataPresent{
            btnGpa.isUserInteractionEnabled = true
        }else{
            btnGpa.isUserInteractionEnabled = false
        }
        
        if isGTLDataPresent{
            btnGtl.isUserInteractionEnabled = true
        }else{
            btnGtl.isUserInteractionEnabled = false
        }
        
    }
    
    func errorMsg(_ status: Int) -> String{
        var msg = ""
        switch status {
        case 500:
            msg = err_no_503
            break
        case 404:
            msg = err_no_404
            break
        case 1000:
            msg = err_no_1000
            break
        case 1001:
            msg = err_no_1001
            break
        case 1002:
            msg = err_no_1002
            break
        case 0:
            msg = err_no_0
            break
        default:
            msg = m_errorMsg
            break
        }
        
        return msg
    }
    
    func alertForLogout(titleMsg: String){
        let alertController = UIAlertController(title: titleMsg, message: "", preferredStyle: UIAlertControllerStyle.alert)
        
//            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
//            {
//                (result : UIAlertAction) -> Void in
//                print("Cancel")
//
//            }
        let yesAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {(result : UIAlertAction) -> Void in
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isAlreadylogin")
            
            menuButton.isHidden=true
            menuButton.removeFromSuperview()
            
            
            let loginVC :LoginViewController_New = LoginViewController_New()
            
            UserDefaults.standard.set("", forKey: "ExtGroupSrNo")
            UserDefaults.standard.set("", forKey: "ExtFamilySrNo")
            UserDefaults.standard.set("", forKey: "OrderMasterNo")
            UserDefaults.standard.set("", forKey: "GroupChildSrNo")
            UserDefaults.standard.set("", forKey: "emailid")
            
            UserDefaults.standard.set(nil, forKey: "MEMBER_ID")
            
            //for Added for Terms and codition on 1st time login
//                if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
//                    self.perviousTermsCondtion = "true"
//                }
//                else{
//                    self.perviousTermsCondtion = "false"
//                }
            //To display disclaimer every time
            UserDefaults.standard.setValue(nil, forKey: "isFitnessFirstTime")
            UserDefaults.standard.setValue(nil, forKey: "cigaretteCount")
            UserDefaults.standard.setValue(nil, forKey: "drinkCount")
            UserDefaults.standard.setValue(nil, forKey: "getOfflineTabs")

            UserDefaults.standard.set(false, forKey: "isInsurance")
            UserDefaults.standard.set(false, forKey: "isWellness")
            UserDefaults.standard.set(false, forKey: "isFitness")

            
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
            center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

            center.removeAllPendingNotificationRequests()
//                if self.perviousTermsCondtion == "true"{
//                    UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
//                }

            self.navigationController?.pushViewController(loginVC, animated: true)
            //        navigationController?.popToViewController(loginVC, animated: true)
            
        }
        //alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayActivityAlertWithSeconds(title: String,seconds:Int)
    {
        DispatchQueue.main.async { () -> Void in

        let pending = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
            self.present(pending, animated: true, completion: nil)
        let deadlineTime = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime)
        {
            pending.dismiss(animated: true, completion: nil)
            
        }
        }
        
    }
    
    func handleServerError(httpResponse:HTTPURLResponse)
    {
        var errorMsg:String="Something went wrong, please try again"
        if (httpResponse.statusCode == 400)
        {
            errorMsg="400_error"
        }
        else if(httpResponse.statusCode == 401)
        {
            errorMsg="401_error"
        }
        else if(httpResponse.statusCode == 403)
        {
            errorMsg="403_error"
        }
        else if(httpResponse.statusCode == 404)
        {
            errorMsg="404_error"
        }
        else if(httpResponse.statusCode == 405)
        {
            errorMsg="405_error"
        }
        else if(httpResponse.statusCode == 408)
        {
            errorMsg="408_error"
        }
        else if(httpResponse.statusCode == 500)
        {
            errorMsg="500_error"
        }
        else if(httpResponse.statusCode == -1001)
        {
            errorMsg="-1001_error"
        }
        
        let deadlineTime = DispatchTime.now() + .seconds(0)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime)
        {
//            ALLoadingView.manager.hideLoadingView(withDelay: 0.0)
            self.displayActivityAlert(title: errorMsg )
        }
    }
   
    func showAlert(message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "DISMISS", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertwithOk(message:String)
       {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel)
           {
               (result : UIAlertAction) -> Void in
               print("Cancel")
           }
           alert.addAction(cancelAction)
           self.present(alert, animated: true, completion: nil)
       }
    
    func showAlertDetails(message:String,title1:String)
    {
        let alert = UIAlertController(title: title1, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "DISMISS", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func isConnectedToNetWithAlert()->Bool
    {
        let status = Reach().connectionStatus()
        var netStatus = true
        switch status
        {
        case .unknown, .offline:
            print("Not connected")
            netStatus = false
            //self.displayActivityAlert(title: "Not connected to internet!")
            break;
        case .online(.wwan),.online(.wiFi):
            netStatus = true
            break
            
            
        }
        return netStatus
    }
    func isConnectedToNet()->Bool
    {
        let status = Reach().connectionStatus()
        var netStatus = true
        switch status
        {
        case .unknown, .offline:
            netStatus = false
            break;
        case .online(.wwan),.online(.wiFi):
            netStatus = true
            break
            
        }
        return netStatus

    }
    func getDocumentDirectory()->String
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return documentsPath
    }
    func createDirectoryIfNotAvailable(fullPath:String)
    {
        
//        let documentsDirectory = getDocumentDirectory()
//        let fullPath = "\(documentsDirectory)/\(dirName)"
        
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if (!fileManager.fileExists(atPath: fullPath, isDirectory:&isDir))
        {
            do {
                try FileManager.default.createDirectory(atPath: fullPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
            
        }
        
        
        
        
    }
    
    func convertDatetoString(_ date: Date) -> String
    {
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd
    }
    
    func convertSelectedStringToDate(dateString:String)->Date
          {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "dd~MM~yyyy" //Your date format
              dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
              
              if let date = dateFormatter.date(from: dateString)
              {
                  print(date )
                  
                  
                  return date
              }
              return Date()
          }
    
    func getRightBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "notification"), style: .plain, target: self, action: #selector(rightButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func rightButtonClicked()
    {
        print ("rightButtonClicked")

    }
    func getBackButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "back button"), style: .plain, target: self, action: #selector(backButtonClicked)) // action:#selector(Class.MethodName) for swift 3

        
        return button1
    }
    @objc func backButtonClicked()
    {
        print ("backButtonClicked")
        self.tabBarController?.tabBar.isHidden=false
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func getBackButtonHideTabBar()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "back button"), style: .plain, target: self, action: #selector(backButtonClickedHideTabBar)) // action:#selector(Class.MethodName) for swift 3

        
        return button1
    }
    @objc func backButtonClickedHideTabBar()
    {
        print ("backButtonClicked")
        self.tabBarController?.tabBar.isHidden=true
        _ = navigationController?.popViewController(animated: true)
    }
    
    
   
    func showHello()
    {
        
//        SVProgressHUD.show(withStatus: "Authenticating...").
    }
    func isConnectedToMobileDataWithAlert()->String
    {
        let status = Reach().connectionStatus()
        var netStatus = "Yes"
        switch status
        {
        case .unknown, .offline:
            print("Not connected")
            netStatus = "No"
            self.displayActivityAlert(title: "ConectionAlert")
            break;
        case .online(.wwan):
            netStatus = "Data"
            
            break
        case.online(.wiFi):
            netStatus = "WiFi"
            break
            
            
        }
        return netStatus
    }
    
    //MARK:- Add Loader
    func showPleaseWait(msg:String)
    {
        
        
//       GCD.dispatch(type: .async(queue: .main))
//        {
//
//            ALLoadingView.manager.resetToDefaults()
//            ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator, windowMode: .fullscreen)
//            ALLoadingView.manager.messageText=msg
//
//
//        }
        

        
        //        let progresshub = MBProgressHUD.init(for: self.view)
        
        DispatchQueue.main.async {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //hud.label.text = msg
            hud.backgroundColor = UIColor.clear
            hud.bezelView.backgroundColor = UIColor.clear
            hud.bezelView.color = UIColor.clear
            hud.bezelView.style = .solidColor

        }
    }
    
    
    func showPleaseWait1(msg:String)
    {
        
        
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.hide(animated: true, afterDelay: 0.5)
            //hud.label.text = msg
            hud.backgroundColor = UIColor.clear
            hud.bezelView.backgroundColor = UIColor.clear
            hud.bezelView.color = UIColor.clear
            hud.bezelView.style = .solidColor

        }
        
        
     
    }
    func hidePleaseWait1()
    {
        
        DispatchQueue.main.async {
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            
        }
      
    }
    
    func hidePleaseWait()
    {
//        GCD.dispatch(type: .async(queue: .main))
//        {
//            ALLoadingView.manager.hideLoadingView(withDelay: 1.0)
//            //            SVProgressHUD.dismiss()
//        }
        
        DispatchQueue.main.async {

            MBProgressHUD.hide(for: self.view, animated: true)


        }
        
    }
    func hexStringToUIColor (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6)
        {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            
        )
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
    
    func convertMMMStringToDate(dateString:String)->Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
       if let date = dateFormatter.date(from: dateString)
       {
            print(date )

        
            return date
        }
        return Date()
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
       if let date1 = dateFormatter.date(from: date)
       {
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return  dateFormatter.string(from: date1)
        
       }
        else
       {
         return date
        }
        
        
    }
    func shadowForCell(view:UIView)
    {
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 5
        view.layer.shadowColor = hexStringToUIColor(hex: "#969696").cgColor
        
//        view.layer.shouldRasterize = true
        
        view.layer.cornerRadius = cornerRadiusForView//8
    }
    func customShadowPath(view:UIView)
    {
       
        let shadowPath = UIBezierPath()
        // Start at the Top Left Corner
       
        shadowPath.move(to: CGPoint(x: 0.0, y: 0.0))
        
        
        
        // Move to the Top Right Corner
        shadowPath.addLine(to: CGPoint(x: view.frame.size.width, y: 0.0))
        
        // Move to the Bottom Right Corner
        shadowPath.addLine(to: CGPoint(x: view.bounds.width, y: view.bounds.height))
        
        // This is the extra point in the middle :) Its the secret sauce.
        shadowPath.addLine(to: CGPoint(x: view.bounds.width/2.0, y: view.bounds.height/2.0))
        
        // Move to the Bottom Left Corner
        shadowPath.addLine(to: CGPoint(x: 0.0, y: view.bounds.height))
        
        // Move to the Close the Path
        shadowPath.close()
        
        view.layer.shadowPath = shadowPath.cgPath
        
        view.layer.cornerRadius=cornerRadiusForView//8
        
    }
    func setBottomShadow(view:UIView)
    {
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = cornerRadiusForView//8
    }
    
    func setLeftSideImageView(image : UIImage,textField : UITextField)
    {
        let viewPadding = UIView(frame: CGRect(x: 5, y: 0, width: 30 , height: Int(textField.frame.size.height)))
        
        let imageView = UIImageView (frame:CGRect(x: 0, y: 0, width: 15 , height: 15))
        imageView.contentMode=UIViewContentMode.scaleAspectFit
        imageView.center = viewPadding.center
        imageView.image  = image
        viewPadding .addSubview(imageView)
        
        textField.leftView = viewPadding
        textField.leftViewMode = .always
        
        
        
        
    }
    
    func shakeTextfield(textField:UIView)
    {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
        
        textField.layer.add(animation, forKey: "position")
    }
    
    func checkjailbrokenDevice(){
        if IOSSecuritySuite.amIJailbroken() {
            //print("This device is jailbroken")
            isJailbrokenDevice = true
            self.showalertforJailbreakDevice()
            //self.showAlert(message: "This device is jailbroken")
           
            //return true
        }else{
            isJailbrokenDevice = false
            //return false
        }
    }
    
    func showalertforJailbreakDevice(){
        let alertController = UIAlertController(title: "This device is jailbroken", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
//            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
//            {
//                (result : UIAlertAction) -> Void in
//                print("Cancel")
//
//            }
        let yesAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {(result : UIAlertAction) -> Void in
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isAlreadylogin")

            menuButton.isHidden=true
            menuButton.removeFromSuperview()


            let loginVC :LoginViewController_New = LoginViewController_New()

            UserDefaults.standard.set("", forKey: "ExtGroupSrNo")
            UserDefaults.standard.set("", forKey: "ExtFamilySrNo")
            UserDefaults.standard.set("", forKey: "OrderMasterNo")
            UserDefaults.standard.set("", forKey: "GroupChildSrNo")
            UserDefaults.standard.set("", forKey: "emailid")

            UserDefaults.standard.set(nil, forKey: "MEMBER_ID")

            //for Added for Terms and codition on 1st time login
//                if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
//                    self.perviousTermsCondtion = "true"
//                }
//                else{
//                    self.perviousTermsCondtion = "false"
//                }
            //To display disclaimer every time
            UserDefaults.standard.setValue(nil, forKey: "isFitnessFirstTime")
            UserDefaults.standard.setValue(nil, forKey: "cigaretteCount")
            UserDefaults.standard.setValue(nil, forKey: "drinkCount")
            UserDefaults.standard.setValue(nil, forKey: "getOfflineTabs")

            UserDefaults.standard.set(false, forKey: "isInsurance")
            UserDefaults.standard.set(false, forKey: "isWellness")
            UserDefaults.standard.set(false, forKey: "isFitness")


            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
            center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

            center.removeAllPendingNotificationRequests()
//                if self.perviousTermsCondtion == "true"{
//                    UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
//                }

            self.navigationController?.pushViewController(loginVC, animated: true)
            //        navigationController?.popToViewController(loginVC, animated: true)
            UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                   to: UIApplication.shared, for: nil)
            
        }
        //alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getUserTokenGlobal(completion: @escaping (_ data: String, _ error: String)->()){
        
        var employeeSrno = String()
        var personSrnNo = String()
        var employeIdNo = String()
        var empSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String
        var empIDno = UserDefaults.standard.value(forKey: "userEmployeIdNoValue") as? String
        var perSrno = UserDefaults.standard.value(forKey: "userPersonSrnNoValue") as? String
       
        
        if empSrno != nil{
            employeeSrno = empSrno ?? ""
            print("employeeSrno: ",employeeSrno)
            employeeSrno = try! AES256.encrypt(input: employeeSrno, passphrase: m_passphrase_Portal)
        }
        if empIDno != nil{
            employeIdNo = empIDno ?? ""
            print("employeIdNo: ",employeIdNo)
            employeIdNo = try! AES256.encrypt(input: employeIdNo, passphrase: m_passphrase_Portal)
        }
        
        if perSrno != nil{
            personSrnNo = perSrno ?? ""
            print("personSrnNo: ",personSrnNo)
            personSrnNo = try! AES256.encrypt(input: personSrnNo, passphrase: m_passphrase_Portal)
        }
        
        
        let allowedCharacterSet = CharacterSet.alphanumerics // Set of allowed characters
        let urlEncodedemployeeSrno = employeeSrno.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        print("urlEncodedemployeeSrno: ",urlEncodedemployeeSrno)
        
        let urlEncodedpersonSrnNo = personSrnNo.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        print("urlEncodedpersonSrnNo: ",urlEncodedpersonSrnNo)
        
        let urlEncodedemployeIdNo = employeIdNo.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        print("urlEncodedemployeIdNo: ",urlEncodedemployeIdNo)
        
        
        
        let urlreq = NSURL(string: WebServiceManager.sharedInstance.getRefreshUserToken(employeeSrno: urlEncodedemployeeSrno!, personSrnNo: urlEncodedpersonSrnNo!, employeIdNo: urlEncodedemployeIdNo!))
        
        print("10001 getUserToken : \(urlreq)")
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = urlreq as URL?
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        print("authToken getUserTokenGlobal:",authToken)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let datatask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, httpUrlResponse, error ) in
//            guard let dataResponse = data,
//                  error == nil else {
//                print(error?.localizedDescription ?? "Response Error")
//                return }
            if error == nil{
                print(String(data: data!, encoding: .utf8)!)
                let resp = httpUrlResponse as! HTTPURLResponse
                let status = resp.statusCode
                print("getUserTokenGlobal httpResponse.statusCode: ",status)
                switch status{
                case 200:
                    do {
                        guard let data = data else { return }
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
                        print("jsonResponse: ", json)
                        
                        if let token = json["Authtoken"]
                        {
                            print("Token:  ",token)
                            if token.isEmpty{
                                print("Something went wrong!!!")
                                let errorHandlerVC : LoginViewController_New = LoginViewController_New()
                                self.navigationController?.pushViewController(errorHandlerVC, animated: true)
                            }
                            else{
                                UserDefaults.standard.set(token, forKey: "userAppToken")
                                var userAppToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                                authToken = userAppToken
                            }
                            completion(authToken,"")
                        }
                    } catch {
                        print("error:", error)
                        //self.hidePleaseWait()
                        //Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                    }
                    
                    break
                    
                case 400:
                        print("Inside getUserTokenGlobal 400 ")
                    DispatchQueue.main.sync(execute: {
                        if errorHandlerVCCounter == 0{
                            errorHandlerVCCounter = errorHandlerVCCounter + 1
                            let errorHandlerVC : LoginViewController_New = LoginViewController_New()
                            self.navigationController?.pushViewController(errorHandlerVC, animated: true)
                        }
                        else{
                            print("Inside getUserTokenGlobal 400 already called")
                        }
                    })
//                    DispatchQueue.main.sync(execute: {
//                        if errorHandlerVCCounter == 0{
//                            self.getPostValidateOTPForToken(completion: { (data,error) in
//                                print("Inside getUserTokenGlobal 400 after completion ")
//
//                            })
//                        }
//                        else{
//                            print("Inside getUserTokenGlobal 400 already called")
//                        }
//                    })
                    
                case 401:
//                    do{
                        print("Inside getUserTokenGlobal 401 ")
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
//                    DispatchQueue.main.sync(execute: {
//                        if errorHandlerVCCounter == 0{
//                            self.getPostValidateOTPForToken(completion: { (data,error) in
//                                print("Inside getUserTokenGlobal 401 after completion ")
//
//                            })
//                        }
//                        else{
//                            print("Inside getUserTokenGlobal 401 already called")
//                        }
//                    })

                default:
                    completion(authToken,"error")
                    break
                }
            }else{
                completion("",error!.localizedDescription)
            }
        })
        datatask.resume()
        
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { [self] (data, response, error) in
//            if let error = error {
//                print("error:", error)
//                return
//            }
//            else{
//                if let httpResponse = response as? HTTPURLResponse
//                {
//                    if httpResponse.statusCode == 200
//                    {
//                        do {
//                            guard let data = data else { return }
//                            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
//                            print("jsonResponse: ", json)
//
//                            if let token = json["Authtoken"]
//                            {
//                                print("Token:  ",token)
//                                if token.isEmpty{
//                                    print("Something went wrong!!!")
//                                }
//                                else{
//                                    authToken = token
//                                }
//                            }
//                        } catch {
//                            print("error:", error)
//                            //self.hidePleaseWait()
//                            //Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
//                        }
//                    }
//                    else if httpResponse.statusCode == 401{
//
//                        //self.hidePleaseWait()
//                        //self.displayActivityAlert(title: m_errorMsg)
//                        print("else 401 executed with \(httpResponse.statusCode)")
//                        //self.navigationController?.showAlert(message: "Some error occured.Please try again later")
//
//                        DispatchQueue.main.async{
//                            self.alertForLogout()
//                        }
//                    }
//                    else{
//                        print("else executed with \(httpResponse.statusCode)")
//                    }
//                }
//                else {
//                    print("Can't cast response to NSHTTPURLResponse")
//                    //                        self.displayActivityAlert(title: m_errorMsg)
//                    //                        self.hidePleaseWait()
//                }
//            }
//        }
////        if empSrno == nil && empIDno == nil && perSrno == nil{
////            print("Empty value: empSrno: ",empSrno,"empIDno: ",empIDno,"perSrno: ",perSrno)
////        }
////        else{
//            print("empSrno: ",empSrno,"empIDno: ",empIDno,"perSrno: ",perSrno)
//            task.resume()
        //}
    }
    
    
    func getPostValidateOTPForToken(completion: @escaping (_ data: String, _ error: String)->()){
        m_OTP = UserDefaults.standard.value(forKey: "userOTP") as! String
        m_loginIDMobileNumber = UserDefaults.standard.value(forKey: "m_loginIDMobileNumber") as? String ?? ""
        m_loginIDEmail = UserDefaults.standard.value(forKey: "m_loginIDEmail") as? String ?? ""
      
        let url = NSURL(string: WebServiceManager.getSharedInstance().getValidateOtpPostUrlPortal() as String)
            
            var jsonDict : [String : String] = [:]
        var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
            if !m_loginIDMobileNumber.isEmpty{
                jsonDict = ["mobileno":"\(m_loginIDMobileNumber)",
                            "enteredotp":"\(m_OTP)"]
            }
            else if !m_loginIDEmail.isEmpty{
                jsonDict = ["officialemailId":"\(m_loginIDEmail)",
                            "enteredotp":"\(m_OTP)"]
            }
            print("m_loginIDMobileNumber: ",m_loginIDMobileNumber," m_OTP: ",m_OTP)
            print("jsonDict values: ",jsonDict)
        
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            
            print("jsonData: ",jsonData)
            print("jsonDict: ",jsonDict)
            var request = URLRequest(url: url! as URL)
            request.httpMethod = "post"
            // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
        var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
        var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

            let authString = String(format: "%@:%@", encryptedUserName,encryptedPassword)
            print("m_authUserName_Portal ",encryptedUserName)
            print("m_authPassword_Portal ",encryptedPassword)
            
            let authData = authString.data(using: String.Encoding.utf8)!
            let base64AuthString = authData.base64EncodedString()
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
            
            print("getPostValidateOTPForToken: ",url)
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                if let error = error {
                    print("error:", error)
                    return
                }
                else{
                    if let httpResponse = response as? HTTPURLResponse
                    {
                        print("getPostValidateOTPForToken: ",httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            do {
                                guard let data = data else { return }
                                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
                                print("jsonResponse: ", json)
                                resultsDictArray = [json]
                                
                                print("resultsDictArray: ",resultsDictArray)
                                
                                let jsonData = try JSONSerialization.data(withJSONObject: json)
                                
                                // Convert to a string and print
                                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                                    print("Converted json:",JSONString)
                                }
                                
                                for obj in resultsDictArray!
                                {
                                    let otpValidatedInformation = obj["OTPValidatedInformation"]
                                    let status = obj["status"]
                                    
                                    print("Status: ",status," : ",otpValidatedInformation)
                                    
                                    DispatchQueue.main.async(execute:
                                                                {
                                        if(otpValidatedInformation == "1")
                                        {
                                            let AuthToken = obj["AuthToken"] as! String
                                            if AuthToken.isEmpty{
                                                //Logout
                                                print("please Logout")
                                            }
                                            else{
                                                UserDefaults.standard.set(AuthToken, forKey: "userAppToken")
                                                var userAppToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                                                authToken = userAppToken
                                                print("authToken: ",authToken)
                                            }
                                        }
                                        
                                    })
                                }
                                completion(authToken,"")
                            } catch {
                                print("error:", error)
                                
                                //Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                            }
                        }
                        else if httpResponse.statusCode == 401 || httpResponse.statusCode == 400{
                            
                            print("Some error occured getPolicyCoveragesDetails_Data")
                            //                            self.getUserTokenGlobal(completion: { (data,error) in
                            //                                self.getPostValidateOTPForToken()
                            //                            })
                            DispatchQueue.main.sync(execute: {
                                if errorHandlerVCCounter == 0{
                                    errorHandlerVCCounter = errorHandlerVCCounter + 1
                                    let errorHandlerVC : LoginViewController_New = LoginViewController_New()
                                    self.navigationController?.pushViewController(errorHandlerVC, animated: true)
                                }
                                else{
                                    print("Inside getUserTokenGlobal 400 already called")
                                }
                            })
                        }
                        else{
                            print("Something went wrong!!!")
                            
                            errorCount+=1
                            print("errorCount: ",errorCount)
                            if errorCount > 3{
                                print("errorCount greated than 3: ",errorCount)
//                                let loginViewController = LoginViewController_New()
//                                let navController = UINavigationController(rootViewController: loginViewController)
//                                navController.modalPresentationStyle = .fullScreen
//                                present(navController, animated: true, completion: nil)
                            }
                        }
                    }
                    else {
                        print("please Logout")
                    }
                }
            }
            
            if !m_OTP.isEmpty{
                print("m_OTP is: ",m_OTP)
                task.resume()
            }
            else{
                print("m_OTP is empty: ",m_OTP)
            }
        
    }
    
    
    func getOegrpNo(_ productCode : String) -> String?{
        var oegrpno = ""
        if productCode.uppercased() == "GMC"{
          oegrpno = userOegrpNo
        }else if productCode.uppercased() == "GPA"{
            oegrpno = userOegrpNoGPA
        }else{
            oegrpno = userOegrpNoGTL
        }
        return oegrpno
        
    }

    func getEmpsrNo(_ productCode : String) -> String?{
        var empsrno = ""
        if productCode.uppercased() == "GMC"{
          empsrno = userEmployeeSrno
        }else if productCode.uppercased() == "GPA"{
            empsrno = userEmployeeSrnoGPA
        }else{
            empsrno = userEmployeeSrnoGTL
        }
        return empsrno
        
    }
    
    func getEnrollStatus(_ productCode : String,_ selectedIndexPosition : Int,_ selectedPolicyValue : String){
        var clickedOegrp = ""
        var clickedEmpSrNo = ""
        if(isConnectedToNetWithAlert())
        {

            userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
            userOegrpNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String ?? ""
            userOegrpNoGPA = UserDefaults.standard.value(forKey: "userOegrpNoValueGPA") as? String ?? ""
            userOegrpNoGTL = UserDefaults.standard.value(forKey: "userOegrpNoValueGTL") as? String ?? ""
            
            userEmployeeSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String ?? ""
            userEmployeeSrnoGPA = UserDefaults.standard.value(forKey: "userEmployeeSrnoValueGPA") as? String ?? ""
            userEmployeeSrnoGTL = UserDefaults.standard.value(forKey: "userEmployeeSrnoValueGTL") as? String ?? ""
            employeeSrNoGMCValue = UserDefaults.standard.value(forKey: "employeeSrNoGMCValue") as? String ?? ""
            
            if productCode == "GMC"{
                clickedOegrp = userOegrpNo
                clickedEmpSrNo = userEmployeeSrno
            }
            else if productCode == "GPA"{
                clickedOegrp = userOegrpNoGPA
                clickedEmpSrNo = userEmployeeSrnoGPA
            }
            else if productCode == "GTL"{
                clickedOegrp = userOegrpNoGTL
                clickedEmpSrNo = userEmployeeSrnoGTL
            }
            
            print("getEnrollStatus Userdefaults userGroupChildNo: ",userGroupChildNo," clickedOegrp: ",clickedOegrp," m_productCode:",productCode," clickedEmpSrNo: ",clickedEmpSrNo," employeeSrNoGMCValue: ",employeeSrNoGMCValue)
            
            if userGroupChildNo != "" && clickedOegrp != ""
            {
                    //showPleaseWait(msg: "Please wait...")
                    
                    var groupchildsrno = String()
                    var oegrpbasinfsrno = String()
                    var employeesrno = String()
                    
                    if let childNo = userGroupChildNo as? String
                    {
                        groupchildsrno = String(childNo)
                        groupchildsrno = try! AES256.encrypt(input: groupchildsrno, passphrase: m_passphrase_Portal)
                        
                    }
                    if let empNo = clickedEmpSrNo as? String
                    {
                        employeesrno = String(empNo)
                        employeesrno = try! AES256.encrypt(input: employeesrno, passphrase: m_passphrase_Portal)
                    }
                    if selectedIndexPosition == 0{
                        if let oegrp = clickedOegrp as? String{
                            oegrpbasinfsrno = String(oegrp)
                            oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                        
                        }
                    }else{
                        oegrpbasinfsrno = selectedPolicyValue
                        oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                    
                    }
                    
                    print("m_productCode : ",productCode," : groupchildsrno: ",groupchildsrno," : employeesrno: ",employeesrno," : oegrpbasinfsrno: ",oegrpbasinfsrno)
                    
                let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getEnrollStatusUrlPortal(employeesrno: employeesrno.URLEncoded, GroupChildSrNo: groupchildsrno.URLEncoded, OeGrpBasInfSrNo: oegrpbasinfsrno.URLEncoded))
                
                //let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getEnrollStatusUrlPortal(employeesrno: "91728", GroupChildSrNo: "1531", OeGrpBasInfSrNo: "1588"))
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?
                    request.httpMethod = "POST"
                    
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
                    print("authToken getEnrollStatus:",authToken)
                 
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
                  
                    
                    print("getEnrollStatus url: ",urlreq)
                    
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                    //SSL Pinning
                    if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                        // Handle SSL connection failure
                        print("SSL connection error: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.alertForLogout(titleMsg: error.localizedDescription)
                        }
                    }
                    else if let error = error {
                        print("getEnrollStatus() error:", error)
                        return
                    }
                    else
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            print("getEnrollStatus httpResponse.statusCode: ",httpResponse.statusCode)
                            
                            if httpResponse.statusCode == 200
                            {
                                do {
                                    
                                    if let data = data, let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                                    {
                                        print("getEnrollStatus jsonResult ",jsonResult)
                                        if(jsonResult.count>0)
                                        {
                                            DispatchQueue.main.async
                                            {
                                                
                                                if let message = jsonResult.value(forKey: "message")
                                                {
                                                    let dict : NSDictionary = (message as? NSDictionary)!
                                                    let status = dict.value(forKey: "Status") as! Bool
                                                    print("status for getEnrollStatus :",status)
                                                    if(status)
                                                    {
                                                        //self.IsEnrollmentSavedStatus = jsonResult.value(forKey: "IsEnrollmentSaved") as? Int ?? -1
                                                        var status = jsonResult.value(forKey: "IsWindowPeriodOpen") as? Int ?? -1
                                                        print("IsWindowPeriodOpenStatus: ",status)
                                                        if status == 0{
                                                            m_windowPeriodStatus = false
                                                        }else{
                                                            m_windowPeriodStatus = true
                                                        }
                                                    }
                                                    else
                                                    {
                                                        print("Status false for getEnrollStatus()")
                                                        m_windowPeriodStatus = false
                                                    }
                                                }
                                                //self.hideRefreshLoader()
                                            }
                                            print(jsonResult.allKeys)
                                        }
                                        else
                                        {
                                            let deadlineTime = DispatchTime.now() + .seconds(1)
                                            DispatchQueue.main.asyncAfter(deadline: deadlineTime)
                                            {
                                                //self.hideRefreshLoader()
                                            }
                                        }
                                    }
                                } catch let JSONError as NSError
                                {
                                   
                                    
                                }
                            }else if httpResponse.statusCode == 401 || httpResponse.statusCode == 400{
                                //self.getEnrollStatus()
                                m_windowPeriodStatus = false
                            }
                            else
                            {
                                m_windowPeriodStatus = false
                                //self.hideRefreshLoader()
                                //self.hidePleaseWait()
                                print("else executed UIViewController getEnrollStatus")
                            }
                        }
                        else
                        {
                            m_windowPeriodStatus = false
                            print("Can't cast response to NSHTTPURLResponse")
                            //self.hideRefreshLoader()
                            print("m_errorMsg ",m_errorMsg)
                            //self.hidePleaseWait()
                        }
                        
                        DispatchQueue.main.async{
                            
                        }
                    }
                }
                    task.resume()
                
            }else{
                DispatchQueue.main.async
                {
                    
                }
            }
        }else{
            DispatchQueue.main.async
            {
              
            }
        }
    }


}



//SSL Pinning
extension UIViewController{
    class URLSessionPinningDelegate: NSObject, URLSessionDelegate{

        func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
                // Call into TrustKit here to do pinning validation
                if TrustKit.sharedInstance().pinningValidator.handle(challenge, completionHandler: completionHandler) == false {
                    // TrustKit did not handle this challenge: perhaps it was not for server trust
                    // or the domain was not pinned. Fall back to the default behavior
                    print("SSL Pinning .. failure")
                    completionHandler(.performDefaultHandling, nil)
                }else{
                    print("SSL Pinning .. successful")
                }
            }
    }
    
    /*
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)
                if (errSecSuccess == status) {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateData);
                        let size = CFDataGetLength(serverCertificateData);
                        let cert1 = NSData(bytes: data, length: size)
                        let file_der = Bundle.main.path(forResource: "benefitsyou.com", ofType: "cer")
                        if let file = file_der {
                            if let cert2 = NSData(contentsOfFile: file) {
                                if cert1.isEqual(to: cert2 as Data) { completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        // Pinning failed
        
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
      */
}

