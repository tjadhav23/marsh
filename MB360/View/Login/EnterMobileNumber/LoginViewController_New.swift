//
//  LoginViewController_New.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 26/09/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation
import UIKit
import FirebaseCrashlytics
import TrustKit
import AesEverywhere

class LoginViewController_New: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var icon: UIImageView!
    
    //Top Lbls
    @IBOutlet weak var h1Lbl: UILabel!
    @IBOutlet weak var h2Lbl: UILabel!
    @IBOutlet weak var h3Lbl: UILabel!
    @IBOutlet weak var h4Lbl: UILabel!
    
    
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var mobileTappedView: UIView!
    @IBOutlet weak var mobileTappedLbl: UILabel!
    
    @IBOutlet weak var emailTappedView: UIView!
    @IBOutlet weak var emailTappedLbl: UILabel!
    
    @IBOutlet weak var webTappedView: UIView!
    @IBOutlet weak var webTappedLbl: UILabel!
    
    @IBOutlet weak var singleLoginView: UIView!
    @IBOutlet weak var loginWith: UILabel!
    @IBOutlet weak var underline: UIView!
    
    @IBOutlet weak var errorMsg: UILabel!
    
    
    @IBOutlet weak var mobileTxtView: UIView!
    @IBOutlet weak var txtMobileno: UITextField!
    
    @IBOutlet weak var emailTxtView: UIView!
    @IBOutlet weak var txtEmailId: UITextField!
    
    @IBOutlet weak var webTextView: UIView!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var passwordBtn: UIButton!
    
    @IBOutlet weak var mobileBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    
    @IBOutlet weak var btnMobileVew: UIButton!
    @IBOutlet weak var btnEmailVew: UIButton!
    @IBOutlet weak var btnWebVew: UIButton!
    
    
    
    
    
    var whiteColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 1).cgColor
    
    var isSelected = ""
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var iconClick = true
  
    override func viewDidLoad(){
        
        self.setupFontsUI()
        UserDefaults.standard.set(nil, forKey: "userEmployeeSrnoValue")
        UserDefaults.standard.set(nil, forKey: "userEmployeIdNoValue")
        UserDefaults.standard.set(nil, forKey: "userPersonSrnNoValue")
        UserDefaults.standard.setValue("", forKey: "loginMobileNo")
        UserDefaults.standard.setValue("", forKey: "loginEmailID")
        
        menuButton.isHidden = true
        menuButton.removeFromSuperview()
        
        menuButton.isHidden = true
        menuButton.removeFromSuperview()
        
        UserDefaults.standard.setValue("true", forKey: "firstTimeInstall")
        
        getCoreDataDBPath()
        
        //Overlay screens used in enrollment
        UserDefaults.standard.setValue(false, forKey: "dependantOverlay")
        UserDefaults.standard.setValue(false, forKey: "parentalOverlay")
        
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        initialViews()
        //self.mobileTappedView.layer.backgroundColor = blueColor.cgColor
        //self.mobileTappedView.layer.cornerRadius = 25
        self.mobileTappedLbl.textColor = UIColor.white
        self.mobileTxtView.isHidden = false
        self.emailTxtView.isHidden = false
        self.webTextView.isHidden = true
        //self.mobileBtn.isHidden = false
        self.emailBtn.isHidden = false
        isSelected = "mobile"
        addgestures()
        mobilelayoutSettings()
        emaillayoutSettings()
        weblayoutSettings()
        
        
        //for sending to next textfield
        self.txtGroupName.delegate = self
        self.txtUserName.delegate = self
        self.txtPassword.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
            
            
    func setupFontsUI(){
        //Header Lbl set
        
        h1Lbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: 40)
        h1Lbl.textColor = FontsConstant.shared.app_FontPrimaryColor
        
        h2Lbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.contentSize25))
        h2Lbl.textColor = FontsConstant.shared.app_FontPrimaryColor
        
        h3Lbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h20))
        h3Lbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        h4Lbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h20))
        h4Lbl.textColor = FontsConstant.shared.app_FontPrimaryColor
        
        
        //Selection lbl
        mobileTappedLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        mobileTappedLbl.textColor = FontsConstant.shared.app_FontAppColor
        
        emailTappedLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        emailTappedLbl.textColor = FontsConstant.shared.app_FontAppColor
        
        webTappedLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        webTappedLbl.textColor = FontsConstant.shared.app_FontAppColor
        
        errorMsg.font = UIFont(name: FontsConstant.shared.OpenSansLight, size: CGFloat(FontsConstant.shared.h17))
        errorMsg.textColor = FontsConstant.shared.app_FontAppColor
        
        txtMobileno.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h17))
        
        txtEmailId.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h17))
        
        txtGroupName.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h17))
        
        txtUserName.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h17))
        
        txtPassword.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h17))
        
        
        mobileBtn.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h17))
        
        emailBtn.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h17))
        
        webBtn.titleLabel?.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h17))
        
        
        loginWith.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h17))
        loginWith.textColor = FontsConstant.shared.app_FontPrimaryColor
        
        underline.layer.cornerRadius = 1
    }
            
            //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
            
    
    override func viewDidAppear(_ animated: Bool)
    {
         menuButton.isHidden=true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.txtGroupName:
            self.txtUserName.becomeFirstResponder()
        case self.txtUserName:
            self.txtPassword.becomeFirstResponder()
        case self.txtPassword:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        UserDefaults.standard.setValue("", forKey: "loginMobileNo")
        UserDefaults.standard.setValue("", forKey: "loginEmailID")
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
        menuButton.isHidden = true
    }
    
    
    @IBAction func hideShowPasswordBtn(_ sender: Any) {
        print("hideShowPasswordBtn Tapped")
        
        if(iconClick == true) {
            txtPassword.isSecureTextEntry = false
            passwordBtn.setImage(UIImage(named:"passwordVisible"), for: .normal)
        } else {
            txtPassword.isSecureTextEntry = true
            passwordBtn.setImage(UIImage(named:"passwordHide"), for: .normal)
        }
        
        iconClick = !iconClick
    }
    
    
    @IBAction func mobileBtnPressed(_ sender: Any) {
        

        
        print("Tapped mobile",txtMobileno.text ?? "")
        
        if txtMobileno.text?.isEmpty ?? true
        {
           
            displayActivityAlert(title: "Please enter valid mobile number")
            
        }
        else
        {
            if (txtMobileno.text?.count == 10)
            {
                print("Tapped mobile count getPostLoginDetailsForMobile")
               // var txtMobilenoX = try! AES256.encrypt(input: txtMobileno.text!, passphrase: m_passphrase_Portal)
                UserDefaults.standard.setValue(txtMobileno.text!, forKey: "loginMobileNo")
                getPostLoginDetailsForMobile()
//                let url = NSURL(string: "")
//                let session = URLSession(
//                               configuration: URLSessionConfiguration.ephemeral,
//                               delegate: URLSessionPinningDelegate(),
//                               delegateQueue: nil)
//
//                let task = session.dataTask(with: url as! URL, completionHandler: { (data, response, error) -> Void in
//                    print(error)
//                })
                 
            }
            else
            {
                displayActivityAlert(title: "Please enter valid mobile number")
            }
        }
        
    }
    
 
    @IBAction func emailBtnPressed(_ sender: Any) {
        
        print("Tapped email",txtEmailId.text ?? "")
//        if txtEmailId.text?.isEmpty ?? true
//        {
//           
//            displayActivityAlert(title: "Enter E-mail ID")
//            
//        }
//        else
//        {
//            if isValidEmail(emailStr: txtEmailId.text!) == false {
//                shakeTextfield(textField: txtEmailId)
//                displayActivityAlert(title: "Please enter valid E-mail ID")
//            }
//            else
//            {
//                print("Inside getPostLoginDetailsForMobile")
//                //var txtMobilenoX = try! AES256.encrypt(input: txtMobileno.text!, passphrase: m_passphrase_Portal)
//                UserDefaults.standard.setValue(txtEmailId.text!, forKey: "loginEmailID")
//                getPostLoginDetailsForEmail()
//            }
//        }
        
        if !(txtMobileno.text == "")
        {
            if (txtMobileno.text?.count == 10)
            {
                print("Tapped mobile count getPostLoginDetailsForMobile")
                UserDefaults.standard.setValue(txtMobileno.text!, forKey: "loginMobileNo")
                getPostLoginDetailsForMobile()

            }
            else
            {
                displayActivityAlert(title: "Please enter valid mobile number")
            }
        }
        else if !(txtEmailId.text == "")
        {
            if isValidEmail(emailStr: txtEmailId.text!) == false {
                shakeTextfield(textField: txtEmailId)
                displayActivityAlert(title: "Please enter valid e-mail ID")
            }
            else
            {
                print("Inside getPostLoginDetailsForEmail")
                //var txtMobilenoX = try! AES256.encrypt(input: txtMobileno.text!, passphrase: m_passphrase_Portal)
                UserDefaults.standard.setValue(txtEmailId.text!, forKey: "loginEmailID")
                getPostLoginDetailsForEmail()
            }
        }
        else{
            displayActivityAlert(title: "Please enter registered \n mobile \n or \n e-mail ID")
        }
     
        
    }
    
    @IBAction func webBtnPressed(_ sender: Any) {
        print("Tapped web",txtGroupName.text ?? "")
        
        if txtGroupName.text?.isEmpty ?? true
        {
            displayActivityAlert(title: "Please Enter the Group Name")
        }
        else  if txtUserName.text?.isEmpty ?? true
        {
            displayActivityAlert(title: "Please Enter the Username")
        }
        else if txtPassword.text?.isEmpty ?? true
        {
            displayActivityAlert(title: "Please Enter the password")
        }
        else{
            print("Inside getPostLoginDetailsForWeb")
            getPostLoginDetailsForWeb()

        }
        
        
        
    }
    
    @IBAction func btnMobileVewAct(_ sender: UIButton) {
        self.action(sender.tag)
    }
    
    @IBAction func btnMailAct(_ sender: UIButton) {
        self.action(sender.tag)
    }
    
    
    
    @IBAction func btnWebAct(_ sender: UIButton) {
        self.action(sender.tag)
    }
    
    
    func action(_ tag : Int){
        switch tag {
        case 1 :
            print("select first view")
            initialViews()
           // self.mobileTappedView.setGradientBackground(colorTop: hexStringToUIColor(hex: hightlightColor), colorBottom:hexStringToUIColor(hex: gradiantColor2))
            self.btnMobileVew.setBackgroundImage(UIImage(named: "base nav Rect_login"), for: .normal)

            //self.mobileTappedView.applyGradient(colours: [Color.greenTop.value, Color.greenBottom.value], locations: nil)
            self.btnEmailVew.setBackgroundImage(UIImage(named: "base nav plainImg"), for: .normal)
            self.btnWebVew.setBackgroundImage(UIImage(named: "base nav plainImg"), for: .normal)
            
            self.mobileTappedLbl.textColor = UIColor.white
            
            self.mobileTxtView.isHidden = false
            self.emailTxtView.isHidden = true
            self.webTextView.isHidden = true
            self.mobileBtn.isHidden = false
            self.emailBtn.isHidden = true
            self.webBtn.isHidden = true
            self.mobilelayoutSettings()
            
            
        case 2 :
            print("select second view")
            initialViews()
            //self.emailTappedView.setGradientBackground(colorTop: hexStringToUIColor(hex: hightlightColor), colorBottom:hexStringToUIColor(hex: gradiantColor2))
            self.btnEmailVew.setBackgroundImage(UIImage(named: "base nav Rect_login"), for: .normal)
            //self.emailTappedView.applyGradient(colours: [Color.greenTop.value, Color.greenBottom.value], locations: nil)
            self.btnMobileVew.setBackgroundImage(UIImage(named: "base nav plainImg"), for: .normal)
            self.btnWebVew.setBackgroundImage(UIImage(named: "base nav plainImg"), for: .normal)
            
            self.emailTappedLbl.textColor = UIColor.white
            
            self.mobileTxtView.isHidden = true
            self.emailTxtView.isHidden = false
            self.webTextView.isHidden = true
            self.mobileBtn.isHidden = true
            self.emailBtn.isHidden = false
            self.webBtn.isHidden = true
            self.emaillayoutSettings()
            
            
        case 3 :
            print("select third view")
            initialViews()
           // self.webTappedView.setGradientBackground(colorTop: hexStringToUIColor(hex: hightlightColor), colorBottom:hexStringToUIColor(hex: gradiantColor2))
            self.btnWebVew.setBackgroundImage(UIImage(named: "base nav Rect_login"), for: .normal)
            self.btnEmailVew.setBackgroundImage(UIImage(named: "base nav plainImg"), for: .normal)
            self.btnMobileVew.setBackgroundImage(UIImage(named: "base nav plainImg"), for: .normal)
            
            //self.webTappedView.applyGradient(colours: [Color.greenTop.value, Color.greenBottom.value], locations: nil)
            self.webTappedLbl.textColor = UIColor.white
            
            self.mobileTxtView.isHidden = true
            self.emailTxtView.isHidden = true
            self.webTextView.isHidden = false
            self.mobileBtn.isHidden = true
            self.emailBtn.isHidden = true
            self.webBtn.isHidden = false
            self.weblayoutSettings()
        default:
            print("default")
        }
    }
    
}

extension LoginViewController_New{
    
    func addgestures(){
           //self.mobileTappedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
           //self.mobileTappedView.isUserInteractionEnabled = true
            //For Testing
        self.txtMobileno.text = ""//"9004752086"
           
           //self.emailTappedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
           //self.emailTappedView.isUserInteractionEnabled = true
            //For Testing
        self.txtEmailId.text = ""//"charudatt.revadekar@semantictech.in"
        
           self.webTappedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
           self.webTappedView.isUserInteractionEnabled = true
        self.txtGroupName.text = ""//"NAYASA1"
        self.txtUserName.text = ""//"NAYASA06"
        self.txtPassword.text = ""//"Test@123"
       }
       
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
           let tag = gestureRecognizer.view?.tag
           switch tag! {
           case 1 :
               print("select first view")
               initialViews()
               //self.mobileTappedView.layer.backgroundColor = blueColor.cgColor
               self.mobileTappedLbl.textColor = UIColor.white
               
               self.mobileTxtView.isHidden = false
               self.emailTxtView.isHidden = true
               self.webTextView.isHidden = true
               self.mobileBtn.isHidden = false
               self.emailBtn.isHidden = true
               self.webBtn.isHidden = true
               
           case 2 :
               print("select second view")
               initialViews()
               //self.emailTappedView.layer.backgroundColor = blueColor.cgColor
               self.emailTappedLbl.textColor = UIColor.white
               
               self.mobileTxtView.isHidden = true
               self.emailTxtView.isHidden = false
               self.webTextView.isHidden = true
               self.mobileBtn.isHidden = true
               self.emailBtn.isHidden = false
               self.webBtn.isHidden = true
               
               
           case 3 :
               print("select third view")
               initialViews()
               //self.webTappedView.layer.backgroundColor = blueColor.cgColor
               self.webTappedLbl.textColor = UIColor.white
               
               self.mobileTxtView.isHidden = true
               self.emailTxtView.isHidden = true
               self.webTextView.isHidden = false
               self.mobileBtn.isHidden = true
               self.emailBtn.isHidden = true
               self.webBtn.isHidden = false
               
           default:
               print("default")
           }
       }
    
}

//Set Layout Views
extension LoginViewController_New{
    
    func initialViews(){
        self.errorMsg.text = ""
        self.stackView.layer.borderWidth = 0
        //self.stackView.layer.borderColor = UIColor.lightGray.cgColor
        //self.stackView.layer.cornerRadius = 25
        
        
        //self.mobileTappedView.layer.backgroundColor = whiteColor
        //self.mobileTappedView.layer.cornerRadius = 25
        self.mobileTappedLbl.textColor = FontsConstant.shared.app_FontPrimaryColor//UIColor.blue
        //self.emailTappedView.layer.backgroundColor = whiteColor
        //self.emailTappedView.layer.cornerRadius = 25
        self.emailTappedLbl.textColor = FontsConstant.shared.app_FontPrimaryColor//UIColor.blue
        self.webTappedView.layer.backgroundColor = whiteColor
        //self.webTappedView.layer.cornerRadius = 25
        self.webTappedLbl.textColor = FontsConstant.shared.app_FontPrimaryColor//UIColor.blue
        
        self.mobileTappedView.layer.borderWidth = 0.5
        self.mobileTappedView.layer.borderColor = FontsConstant.shared.app_FontPrimaryColor.cgColor
        self.emailTappedView.layer.borderWidth = 0.5
        self.emailTappedView.layer.borderColor = FontsConstant.shared.app_FontPrimaryColor.cgColor
        self.webTappedView.layer.borderWidth = 0.5
        self.webTappedView.layer.borderColor = FontsConstant.shared.app_FontPrimaryColor.cgColor
        
        self.mobileBtn.isHidden = true
        self.emailBtn.isHidden = true
        self.webBtn.isHidden = true
        
        self.txtMobileno.text = ""
        self.txtEmailId.text = ""
        self.txtGroupName.text = ""
        self.txtUserName.text = ""
        self.txtPassword.text = ""
    }
    
    func mobilelayoutSettings()
    {
        txtMobileno.layer.masksToBounds=true
        txtMobileno.delegate=self
        txtMobileno.layer.borderColor=UIColor.lightGray.cgColor
        txtMobileno.layer.borderWidth=1
        txtMobileno.becomeFirstResponder()
        txtMobileno.tintColor=UIColor.black
        txtMobileno.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        txtMobileno.addTarget(self, action: #selector(mobtxteditingChanged(sender:)), for: .editingChanged)
        txtMobileno.layer.cornerRadius=cornerRadiusForView
        setLeftSideImageViewLogin(image: #imageLiteral(resourceName: "call"), textField: txtMobileno)
        
        mobileBtn.layer.masksToBounds=true
        if(Device.IS_IPAD)
        {
            
            txtMobileno.layer.cornerRadius=cornerRadiusForView
        }
        else
        {
            
            txtMobileno.layer.cornerRadius=cornerRadiusForView
        }
        mobileBtn.layer.cornerRadius=mobileBtn.frame.size.height/2
        mobileBtn.dropShadow()
        
    }
   
    func emaillayoutSettings()
    {
        txtEmailId.layer.masksToBounds=true
        txtEmailId.delegate=self
        txtEmailId.layer.borderColor=UIColor.lightGray.cgColor
        txtEmailId.layer.borderWidth=1
        txtEmailId.becomeFirstResponder()
        txtEmailId.tintColor=UIColor.black
        txtEmailId.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        //txtEmailId.addTarget(self, action: #selector(emailtxteditingChanged(sender:)), for: .editingChanged)
      
        txtEmailId.layer.cornerRadius=cornerRadiusForView
        setLeftSideImageViewLogin(image: #imageLiteral(resourceName: "emailIcon"), textField: txtEmailId)
        
        emailBtn.layer.masksToBounds=true
        if(Device.IS_IPAD)
        {
            
            txtEmailId.layer.cornerRadius=cornerRadiusForView
        }
        else
        {
            
            txtEmailId.layer.cornerRadius=cornerRadiusForView
        }
        emailBtn.layer.cornerRadius=emailBtn.frame.size.height/2
        emailBtn.dropShadow()
    }
    
    func weblayoutSettings()
    {
        //For Group Name
        txtGroupName.layer.masksToBounds=true
        txtGroupName.delegate=self
        txtGroupName.layer.borderColor=UIColor.lightGray.cgColor
        txtGroupName.layer.borderWidth=1
        txtGroupName.becomeFirstResponder()
        txtGroupName.tintColor=UIColor.black
        txtGroupName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        txtGroupName.layer.cornerRadius=cornerRadiusForView
        setLeftSideImageViewLogin(image: #imageLiteral(resourceName: "groupIcon"), textField: txtGroupName)
        
        //For UserNmae
        txtUserName.layer.masksToBounds=true
        txtUserName.delegate=self
        txtUserName.layer.borderColor=UIColor.lightGray.cgColor
        txtUserName.layer.borderWidth=1
        //txtUserName.becomeFirstResponder()
        txtUserName.tintColor=UIColor.black
        txtUserName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        txtUserName.layer.cornerRadius=cornerRadiusForView
        setLeftSideImageViewLogin(image: #imageLiteral(resourceName: "userIcon"), textField: txtUserName)
        
        //For password
        txtPassword.layer.masksToBounds=true
        txtPassword.delegate=self
        txtPassword.layer.borderColor=UIColor.white.cgColor
        txtPassword.layer.borderWidth=0
        //txtPassword.becomeFirstResponder()
        txtPassword.tintColor=UIColor.black
        txtPassword.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        setLeftSideImageViewLogin(image: #imageLiteral(resourceName: "passwordIcon"), textField: txtPassword)
        passwordView.layer.cornerRadius = cornerRadiusForView
        passwordView.layer.borderWidth=1
        passwordView.layer.borderColor=UIColor.lightGray.cgColor
        //txtPassword.layer.cornerRadius=txtMobileno.frame.size.height/2
        //setRightSideImageViewLogin(image:  #imageLiteral(resourceName: "passwordHide"), textField: txtPassword)
        
        
        
        webBtn.layer.masksToBounds=true
        if(Device.IS_IPAD)
        {
            txtGroupName.layer.cornerRadius = cornerRadiusForView
            txtUserName.layer.cornerRadius = cornerRadiusForView
            passwordView.layer.cornerRadius = cornerRadiusForView
        }
        else
        {
            txtGroupName.layer.cornerRadius = cornerRadiusForView
            txtUserName.layer.cornerRadius = cornerRadiusForView
            passwordView.layer.cornerRadius = cornerRadiusForView
        }
        webBtn.layer.cornerRadius=webBtn.frame.size.height/2
        webBtn.dropShadow()
    }
   
}

//Animation and design textField
extension LoginViewController_New{
    
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
        // self.view.frame=self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
         UIView.commitAnimations()
         
     }
    
    func setLeftSideImageViewLogin(image : UIImage,textField : UITextField)
    {
        var viewPadding = UIView(frame: CGRect(x: 5, y: 0, width: 30 , height: Int(textField.frame.size.height)))
        
        let imageView = UIImageView (frame:CGRect(x: 0, y: 0, width: 24 , height: 24))
        imageView.contentMode=UIViewContentMode.scaleAspectFit
        imageView.center = viewPadding.center
        imageView.image  = image
        viewPadding .addSubview(imageView)
        
        if textField == txtMobileno{
            viewPadding = UIView(frame: CGRect(x: 5, y: 0, width: 60 , height: Int(textField.frame.size.height)))
            let imageView = UIImageView (frame:CGRect(x: 5, y: 0, width:24 , height: 24))
            imageView.contentMode=UIViewContentMode.scaleAspectFit
            
            imageView.center.y = viewPadding.center.y
            imageView.image  = image
            viewPadding .addSubview(imageView)
            
            let lblView = UILabel(frame: CGRect(x: Int(imageView.frame.size.width)+10, y: 0, width: 40 , height: Int(textField.frame.size.height)))
            lblView.backgroundColor = UIColor.clear
            //lblView.center = viewPadding.center
            lblView.text = "+91 "
            lblView.font = UIFont(name: FontsConstant.shared.regular, size: CGFloat(FontsConstant.shared.h17))
            viewPadding.addSubview(lblView)
            print("inside if",textField)
        }
             else{
                 print("outside if",textField)
             }
        
        textField.leftView = viewPadding
        textField.leftViewMode = .always
    }
    
    func setRightSideImageViewLogin(image : UIImage,textField : UITextField)
    {
        let viewPadding = UIView(frame: CGRect(x: -15, y: 0, width: 30 , height: Int(textField.frame.size.height)))
        
        let imageView = UIImageView (frame:CGRect(x: 0, y: 0, width: 24 , height: 24))
        imageView.contentMode=UIViewContentMode.scaleAspectFit
        imageView.center = viewPadding.center
        imageView.image  = image
        viewPadding .addSubview(imageView)
        
        textField.rightView = viewPadding
        textField.rightViewMode = .always
    }
}

//TextFields methods
extension LoginViewController_New{
    
    @objc func textFieldDidChange(_ textfield:UITextField)
    {
        
        animateTextField(textfield, with: false)
        
        if textfield == txtMobileno {
            if txtMobileno.text?.isEmpty ?? true
            {
                shakeTextfield(textField: textfield)
            }
            else
            {
                if (txtMobileno.text!.count > 10)
                {
                    shakeTextfield(textField: textfield)
                }
            }
        }
        else if textfield == txtEmailId {
            if isValidEmail(emailStr: txtEmailId.text!) == false {
               // shakeTextfield(textField: txtEmailId)
                
            }
        }
        
    }
    
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == txtMobileno {
                txtEmailId.text = ""
            } else if textField == txtEmailId {
                txtMobileno.text = ""
            }
            
            return true
        }
    
    
    @objc private func mobtxteditingChanged(sender: UITextField) {

            if let text = sender.text, text.count >= 10 {
                sender.text = String(text.dropLast(text.count - 10))
                return
            }
    }
    
   /* @objc private func emailtxteditingChanged(sender: UITextField) {

            if let text = sender.text, text.count < 0 {
                sender.text = String(text.dropLast(text.count - 10))
                return
            }
    }
    */
    
    
}

//Validations for txtfields
extension LoginViewController_New{
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
}

//Server call
extension LoginViewController_New{
    
    func getPostLoginDetailsForMobile()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg:"Please wait...")
            var url : NSURL? = nil
            if isWithOtp{
                url = NSURL(string: WebServiceManager.getSharedInstance().getSendOtpPostUrlPortal() as String)
            }else{
                url = NSURL(string: WebServiceManager.getSharedInstance().getWOOtpPostUrlPortal() as String)
            }
            var loginMobileNoValue = UserDefaults.standard.value(forKey: "loginMobileNo") as! String
           // loginMobileNoValue = UserDefaults.standard.value(forKey: "loginMobileNo") as! String//try! AES256.decrypt(input: loginMobileNoValue, passphrase: m_passphrase_Portal)
            print("From user Default Mobile values: ",loginMobileNoValue)
            let jsonDict = ["mobileno":"\(loginMobileNoValue)"]
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            
            print("jsonData: ",jsonData)
            print("jsonDict: ",jsonDict)
            var request = URLRequest(url: url! as URL)
            request.httpMethod = "post"
            request.httpBody = jsonData
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("Request: ",request)
            print("Request Body: ",request.httpBody)
            
            //SSL Pinning
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
            sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
            TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
            let session = URLSession(
                           configuration: sessionConfig,
                           delegate: URLSessionPinningDelegate(),
                           delegateQueue: nil)
          
            let task = session.dataTask(with: request) { [self] (data, response, error) in
                //SSL Pinning
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 || error.code == -1022{
                    // Handle SSL connection failure
                    print("SSL connection error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        alertForLogout(titleMsg: "Some error occured.Please try again later")
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
                            do {
                                guard let data = data else { return }
                                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
                                print("jsonResponse: ", json)
                                self.resultsDictArray = [json]
                                
                                print("resultsDictArray: ",self.resultsDictArray)
                                
                                let jsonData = try JSONSerialization.data(withJSONObject: json)
                                
                                // Convert to a string and print
                                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                                    print("Converted json:",JSONString)
                                }
                                
                                for obj in self.resultsDictArray!
                                {
                                    let status = obj["OTPStatusInformation"]
                                    let mainstatus = obj["status"]
                                    print("Status: ",status)
                                    
                                    if mainstatus?.lowercased() == "success"{
                                        DispatchQueue.main.async(execute:
                                                                    {
                                            m_loginIDMobileNumber = ""
                                            m_loginIDEmail = ""
                                            m_loginIDWeb = ""
                                            m_loginIDMobileNumber = self.txtMobileno.text!
                                            
                                            if(status == "3") //|| (status == "1")
                                            {
                                                
                                                let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                                
                                                //sending email in mobileNumber
                                                enterOTPVC.mobileNumber=self.txtMobileno.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
                                                
                                            }
                                            else if(status=="2")
                                            {
                                                
                                                self.displayActivityAlert(title: "Mobile number doesn't exist")
                                            }
                                            else if(status=="1")
                                            {
                                                /*
                                                 let msg = """
                                                 Your Benefits You India services have expired or your mobile number is not updated in our records.
                                                 Kindly call our customer service representative or your HR
                                                 """
                                                 */
                                                let msg = "Multiple Mobile number exists"
                                                
                                                self.displayActivityAlert(title: msg)
                                            }
                                            else if(status == "0")
                                            {
                                                self.displayActivityAlert(title: "OTP not generated")
                                            }
                                            else
                                            {
                                                var msg = errorMsg(httpResponse.statusCode)
                                                self.displayActivityAlert(title: msg)
                                                //                                            let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                                //
                                                //                                            enterOTPVC.mobileNumber=self.txtEmailId.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
                                            }
                                            self.hidePleaseWait()
                                        })
                                    }
                                    else{
                                        print("RequestOTP status FAILURE")
                                        self.hidePleaseWait()
                                    }
                                }
                                
                                
                            } catch {
                                print("error:", error)
                                self.hidePleaseWait()
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                            }
                        }
                        else{
                            self.hidePleaseWait()
                            
                            print("else executed",httpResponse.statusCode)
                            if httpResponse.statusCode == 429{
                                self.displayActivityAlert(title: "Too many request, please try again later")
                            }
                            else{
                                let msg = """
                                        Your Benefits You India services has expired or your mobile number is not updated in our records.
                                        Kindly call our customer service representative or your HR
                                        """
                                self.displayActivityAlert(title: msg)
                            }
                            
                        }
                    }
                    else {
                        print("Can't cast response to NSHTTPURLResponse")
                        self.displayActivityAlert(title: m_errorMsg)
                        self.hidePleaseWait()
                    }
                }
                
            }
            task.resume()
        }
        else{
            displayActivityAlert(title: "Please check your internet")
        }
    }
    
    func getPostLoginDetailsForEmail()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg:"Please wait...")
            
            let url = NSURL(string: WebServiceManager.getSharedInstance().getSendOtpPostUrlPortal() as String)
            var loginEmailIDValue = UserDefaults.standard.value(forKey: "loginEmailID") as! String
            //loginEmailIDValue = try! AES256.decrypt(input: loginEmailIDValue, passphrase: m_passphrase_Portal)
            loginEmailIDValue = loginEmailIDValue.uppercased()
            print("From user Default Email values: ",loginEmailIDValue)
            let jsonDict = ["officialemailId":"\(loginEmailIDValue)"]
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            
            print("jsonData: ",jsonData)
            print("jsonDict: ",jsonDict)
            var request = URLRequest(url: url! as URL)
            request.httpMethod = "post"
            request.httpBody = jsonData
            
            request.httpBody = jsonData
            
            var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
            
            var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("Request: ",request)
            print("Request Body: ",request.httpBody)
            
            //SSL Pinning
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
            sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
            TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
            let session = URLSession(
                           configuration: sessionConfig,
                           delegate: URLSessionPinningDelegate(),
                           delegateQueue: nil)
          
            
            let task = session.dataTask(with: request) { [self] (data, response, error) in
                //SSL Pinning
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 || error.code == -1022{
                    // Handle SSL connection failure
                    print("SSL connection error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        alertForLogout(titleMsg: "Some error occured.Please try again later")
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
                            do {
                                guard let data = data else { return }
                                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
                                print("jsonResponse: ", json)
                                self.resultsDictArray = [json]
                                
                                print("resultsDictArray: ",self.resultsDictArray)
                                
                                let jsonData = try JSONSerialization.data(withJSONObject: json)
                                
                                // Convert to a string and print
                                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                                    print("Converted json:",JSONString)
                                }
                                
                                for obj in self.resultsDictArray!
                                {
                                    let status = obj["OTPStatusInformation"]
                                    
                                    print("Status: ",status)
                                    
                                    DispatchQueue.main.async(execute:
                                                                {
                                        m_loginIDMobileNumber = ""
                                        m_loginIDEmail = ""
                                        m_loginIDWeb = ""
                                        m_loginIDEmail = self.txtEmailId.text!
                                        if(status == "3")
                                        {
                                            
                                            let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                            
                                            enterOTPVC.mobileNumber=self.txtEmailId.text!; self.navigationController?.pushViewController(enterOTPVC, animated: true)
                                            
                                        }
                                        else if(status=="2")
                                        {
                                            
                                            self.displayActivityAlert(title: "E-mail Id doesn't exist")
                                        }
                                        else if(status=="1")
                                        {
                                            /*let msg = """
                                                    Your Benefits You India services have expired or your mobile number is not updated in our records.
                                                    Kindly call our customer service representative or your HR
                                                    """
                                            */
                                            let msg = "Multiple Official E-mail Id exists"
                                            self.displayActivityAlert(title: msg)
                                        }
                                        else if(status == "0")
                                        {
                                            self.displayActivityAlert(title: "OTP not generated")
                                        }
                                        else
                                        {
                                            self.hidePleaseWait()
                                            
                                            print("else executed",httpResponse.statusCode)
                                            if httpResponse.statusCode == 429{
                                                self.displayActivityAlert(title: "Too many request, please try again later")
                                            }
                                            else{
                                                let msg = """
                                                        Your Benefits You India services has expired or your email id is not updated in our records.
                                                        Kindly call our customer service representative or your HR
                                                        """
                                                self.displayActivityAlert(title: msg)
                                            }
                                            
                                        }
                                        self.hidePleaseWait()
                                    })
                                    
                                }
                                
                                
                            } catch {
                                print("error:", error)
                                self.hidePleaseWait()
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                            }
                        }
                        else{
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed")
                        }
                    }
                    else {
                        print("Can't cast response to NSHTTPURLResponse")
                        self.displayActivityAlert(title: m_errorMsg)
                        self.hidePleaseWait()
                    }
                    
                    
                }
                
            }
            task.resume()
        }
    }
    
    
    func getPostLoginDetailsForWeb()
    {
        if(isConnectedToNetWithAlert())
        {
            showPleaseWait(msg:"Please wait...")
            
            let url = NSURL(string: WebServiceManager.getSharedInstance().getSendWebLoginPostUrlPortal() as String)
            
            let jsonDict = ["GroupCode":"\(txtGroupName.text!)",
                            "UserName":"\(txtUserName.text!)",
                            "Password":"\(txtPassword.text!)"]
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
            
            print("jsonData: ",jsonData)
            print("jsonDict: ",jsonDict)
            var request = URLRequest(url: url! as URL)
            request.httpMethod = "post"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonData
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("Request: ",request)
            print("Request Body: ",request.httpBody)

            //SSL Pinning
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
            sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
            TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
            let session = URLSession(
                           configuration: sessionConfig,
                           delegate: URLSessionPinningDelegate(),
                           delegateQueue: nil)
          
            let task = session.dataTask(with: request) { [self] (data, response, error) in
                //SSL Pinning
                if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 || error.code == -1022{
                    // Handle SSL connection failure
                    print("SSL connection error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        alertForLogout(titleMsg: "Some error occured.Please try again later")
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
                            do {
                                guard let data = data else { return }
                                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
                                print("jsonResponse: ", json)
                                self.resultsDictArray = [json]
                                
                                print("resultsDictArray: ",self.resultsDictArray)
                                
                                
                                let jsonData = try JSONSerialization.data(withJSONObject: json)
                                
                                // Convert to a string and print
                                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                                    print("Converted json:",JSONString)
                                }
                                
                                
                                
                                for obj in self.resultsDictArray!
                                {
                                    let status = obj["status"]
                                    let message = obj["Message"]
                                    let uniqueID = obj["UniqueID"]
                                    let Token = obj["AuthToken"]

                                    print("Web Portal \(status) \(message) \(uniqueID)")
                                    
                                    
                                    DispatchQueue.main.async(execute:
                                                                {
                                        m_loginIDMobileNumber = ""
                                        m_loginIDEmail = ""
                                        m_loginIDWeb = ""
                                        m_loginIDWeb = uniqueID ?? "-1"
                                        if message?.uppercased() == "SUCCESS"{
                                            
                                            print("Valid Web Credentials")
                                            if (status == "1")
                                            {
                                                authToken = Token as! String
                                                
                                                //authToken = try! AES256.encrypt(input: authToken, passphrase: m_passphrase_Portal)
                                                
                                                UserDefaults.standard.set(authToken, forKey: "userAppToken") as? String

                                                let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                                enterOTPVC.getNewLoadSessionDataFromServerNew()
                                                navigationController?.pushViewController(enterOTPVC, animated: true)
                                             
                                            }
                                            else{
                                                self.displayActivityAlert(title: "Invalid details")
                                            }
                                        }
                                        else{
                                            let enterOTPVC : EnterOTPViewController = EnterOTPViewController()
                                            enterOTPVC.getNewLoadSessionDataFromServer()
                                            navigationController?.pushViewController(enterOTPVC, animated: true)
                                            //self.displayActivityAlert(title: message!)
                                        }
                                        
                                        self.hidePleaseWait()
                                    })
                                    
                                }
                                
                                
                            } catch {
                                print("error:", error)
                                self.hidePleaseWait()
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                            }
                        }
                        else if httpResponse.statusCode == 401 || httpResponse.statusCode == 400{
                            
                                print("Some error occured getPostLoginDetailsForWeb")
                            self.getUserTokenGlobal(completion: { (data,error) in
                                self.getPostLoginDetailsForWeb()
                            })
                            }
                        else{
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
                            print("else executed")
                        }
                    }
                    else {
                        print("Can't cast response to NSHTTPURLResponse")
                        self.displayActivityAlert(title: m_errorMsg)
                        self.hidePleaseWait()
                    }
                    
                    
                }
                
            }
            task.resume()
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
}

