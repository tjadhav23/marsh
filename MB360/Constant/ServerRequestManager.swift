//
//  ServerRequestManager.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 28/05/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AesEverywhere

class ServerRequestManager: NSObject {
    
    static let serverInstance = ServerRequestManager()
    var imageView = UIImageView()
    static var server = ServerRequestManager()
    var username = "MB360"
    var password = "$EM@MB360"
    
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    
    func postDataToServer(url:String,dictionary:NSDictionary, view:UIViewController, onComplition:@escaping (JSON?,NSError?)->Void){
        
        //let serverURL = URL(string: String(format: url))
        // print("URL:",serverURL!)
        
        // view.showPleaseWait(msg: "Please wait...")
        view.view.showSpinner()
        
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
                view.view.removeSpinner()
                
                let jsonData = JSON(response.result.value!)
                print(jsonData)
                onComplition(jsonData,nil)
                break
            case .failure(let error):
                // Helper.sharedInstance.hideLoader()
                view.view.removeSpinner()
                
                print(error.localizedDescription)
                
                
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                
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
    
    func postDataToServerWithLoader(url:String,dictionary:NSDictionary, view:UIViewController, onComplition:@escaping (JSON?,NSError?)->Void){
        
        //let serverURL = URL(string: String(format: url))
        // print("URL:",serverURL!)
        
        view.showPleaseWait(msg: "")
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
                view.hidePleaseWait()
                
                let jsonData = JSON(response.result.value!)
                print(jsonData)
                onComplition(jsonData,nil)
                break
            case .failure(let error):
                 view.hidePleaseWait()
                
                print(error.localizedDescription)
                
                
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
            }
        })
        
        
    }
    
    func deleteDataToServer(url:String, view:UIViewController, onComplition:@escaping (JSON?,NSError?)->Void){
        
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        
        //view.showPleaseWait(msg: "Please wait...")
        view.view.showSpinner()
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        
        
        Alamofire.request(serverURL!, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:{ response in
            
            switch response.result{
                
            case .success:
                //  Helper.sharedInstance.hideLoader()
                // view.hidePleaseWait()
                view.view.removeSpinner()
                
                
                let jsonData = JSON(response.result.value!)
                print(jsonData)
                onComplition(jsonData,nil)
                break
            case .failure(let error):
                // Helper.sharedInstance.hideLoader()
                //view.hidePleaseWait()
                view.view.removeSpinner()
                print(error.localizedDescription)
                
                
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
            }
        })
        
        
    }
    
    func deleteDataToServerWithoutLoader(url:String, onComplition:@escaping (JSON?,NSError?)->Void){
        
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        
        //view.showPleaseWait(msg: "Please wait...")
        // view.view.showSpinner()
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        
        
        Alamofire.request(serverURL!, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:{ response in
            
            switch response.result{
                
            case .success:
                //  Helper.sharedInstance.hideLoader()
                // view.hidePleaseWait()
                //view.view.removeSpinner()
                
                
                let jsonData = JSON(response.result.value!)
                print(jsonData)
                onComplition(jsonData,nil)
                break
            case .failure(let error):
                // Helper.sharedInstance.hideLoader()
                //view.hidePleaseWait()
                //view.view.removeSpinner()
                print(error.localizedDescription)
                
                
                //self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
            }
        })
        
        
    }
    
    func putDataToServer(url:String,dictionary:NSDictionary, view:UIViewController, onComplition:@escaping (JSON?,NSError?)->Void){
        
        //view.showPleaseWait(msg: "Please wait...")
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        print(dictionary)
        view.view.showSpinner()
        
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        // Helper.sharedInstance.showLoader()
        
        let jsonObj = dictionary.json
        
        let parameters:Parameters = dictionary as! Parameters
        
        Alamofire.request(serverURL!, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler:{ response in
            switch response.result{
                
            case .success:
                //  Helper.sharedInstance.hideLoader()
                // view.hidePleaseWait()
                
                view.view.removeSpinner()
                
                let jsonData = JSON(response.result.value!)
                print(jsonData)
                onComplition(jsonData,nil)
                break
            case .failure(let error):
                // Helper.sharedInstance.hideLoader()
                //view.hidePleaseWait()
                view.view.removeSpinner()
                
                print(error.localizedDescription)
                
                
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
            }
        })
        
        
    }
    
    /*
     func postDataToServerTypeTwo(url:String,dictionary:[String:Any], view:UIViewController, onComplition:@escaping (JSON?,NSError?)->Void){
     
     //let serverURL = URL(string: String(format: url))
     // print("URL:",serverURL!)
     
     let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
     let serverURL = URL(string: urlString!)
     print("URL:",serverURL)
     // print(dictionary)
     print(dictionary)
     
     let header:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
     
     //  Helper.sharedInstance.showLoader()
     let parameters:Parameters = dictionary
     
     Alamofire.request(serverURL!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON(completionHandler:{ response in
     switch response.result{
     
     case .success:
     // Helper.sharedInstance.hideLoader()
     
     let jsonData = JSON(response.result.value!)
     print(jsonData)
     onComplition(jsonData,nil)
     break
     case .failure(let error):
     // Helper.sharedInstance.hideLoader()
     
     print(error.localizedDescription)
     
     
     self.ShowAlert(viewController: view, message: error.localizedDescription)
     
     
     let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
     onComplition(nil,errorObj)
     break
     }
     })
     
     
     }
     */
    
    //MARK:- Get Data with view
    func getRequestDataFromServer(url:String,view:UIViewController, onComplition:@escaping (JSON?,NSError?)->Void){
        
        
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        
        //view.view.showSpinner()
        view.showPleaseWait(msg: "")
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        // Helper.sharedInstance.showLoader()
        
        Alamofire.request(serverURL!, method:.get, parameters: nil, encoding:URLEncoding.default, headers:headers).responseJSON(completionHandler:{ response in
            
            
            switch response.result{
                
            case .success:
                view.hidePleaseWait()
                
                
                // view.view.removeSpinner()
                
                let jsonData = JSON(response.result.value!)
                print(jsonData)
                onComplition(jsonData,nil)
                break
            case .failure(let error):
                
                view.hidePleaseWait()
                
                //view.view.removeSpinner()
                
                
                print(error.localizedDescription)
                self.ShowAlert(viewController: view, message: error.localizedDescription)
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj)
                break
            }
        })
        
        
    }
    
    func getRequestDataFromServerWithoutLoader(url:String,view:UIViewController, onComplition:@escaping (JSON?,NSError?)->Void){
        
        
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        
        //  view.view.showSpinner()
        
        var headers: HTTPHeaders = [:]
        var encryptedUserName = try! AES256.encrypt(input: m_authUserName_Portal, passphrase: m_passphrase_Portal)
        var encryptedPassword = try! AES256.encrypt(input: m_authPassword_Portal, passphrase: m_passphrase_Portal)

        if let authorizationHeader = Request.authorizationHeader(user: encryptedUserName, password: encryptedPassword) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        /*
        authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
        print("authToken getRequestDataFromServerWithoutLoader for TopHideButton:",authToken)
        if urlString?.contains("ShowHideButtonsforInsurance"){
            headers = ["Authorization": "Bearer \(authToken)"]
        }
        else{
            if let authorizationHeader = Request.authorizationHeader(user: encryptedUserName, password: encryptedPassword) {
                headers[authorizationHeader.key] = authorizationHeader.value
            }
        }
        */
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
    
    //FOR AKTIVO
//    func postDataToServerWithHeader(url:String,dictionary:NSDictionary, view:UIViewController, headerParam:NSDictionary,onComplition:@escaping (JSON?,NSError?)->Void){
//
//        if isFromRefresh == 0 {
//            //view.showPleaseWait(msg: "")
//            view.showFitnessLoader(msg: "", type: 1)
//        }
//        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        let serverURL = URL(string: urlString!)
//        print("URL:",serverURL)
//        print(dictionary)
//
//        let headers: HTTPHeaders = ["Accept":"application/json","Cache-Control":"no-cache","Content-Type":"application/x-www-form-urlencoded","Postman-Token":"dynamic"]
//
//        let parameters:Parameters = dictionary as! Parameters
//
//        Alamofire.request(serverURL!, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON(completionHandler:{ response in
//            switch response.result{
//
//            case .success:
//                // view.hidePleaseWait()
//
//                let jsonData = JSON(response.result.value!)
//                print(jsonData)
//                onComplition(jsonData,nil)
//                break
//            case .failure(let error):
//                view.hidePleaseWait()
//                print(error.localizedDescription)
//
//
//                self.ShowAlert(viewController: view, message: error.localizedDescription)
//
//
//                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
//                onComplition(nil,errorObj)
//                break
//            }
//        })
//
//
//    }
    
    
//    func getDataToServerWithHeaderSecond(url:String, view:UIViewController, token:String,onComplition:@escaping (JSON?,NSError?,_ rawData:Any?)->Void){
//        if isFromRefresh == 0 {
//
//            //         view.showPleaseWait(msg: "")
//            view.showFitnessLoader(msg: "", type: 1)
//
//        }
//        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        let serverURL = URL(string: urlString!)
//        print("URL:",serverURL)
//
//
//        let headers: HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization":token]
//
//
//        Alamofire.request(serverURL!, method:.get, parameters: nil, encoding:URLEncoding.default, headers:headers).responseJSON(completionHandler:{ response in
//
//
//            switch response.result{
//
//            case .success:
//                // view.hidePleaseWait()
//
//                let jsonData = JSON(response.result.value!)
//                print(jsonData)
//                onComplition(jsonData,nil,response.result.value)
//                break
//            case .failure(let error):
//
//                view.hidePleaseWait()
//
//                print(error.localizedDescription)
//                if error.localizedDescription.contains("JSON could not be")
//                {
//                    self.ShowAlert(viewController: view, message: m_errorMsg)
//
//                }
//                else {
//                    self.ShowAlert(viewController: view, message: error.localizedDescription)
//                }
//
//
//                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
//                onComplition(nil,errorObj,response.result.value)
//                break
//            }
//        })
//
//
//    }
    
    
    //Added For compete challenges
    func getDataToServerWithHeaderLoader(url:String, view:UIViewController, token:String,onComplition:@escaping (JSON?,NSError?,_ rawData:Any?)->Void){
            
        view.showPleaseWait(msg: "")
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let serverURL = URL(string: urlString!)
        print("URL:",serverURL)
        
        
        let headers: HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization":token]
        
        
        Alamofire.request(serverURL!, method:.get, parameters: nil, encoding:URLEncoding.default, headers:headers).responseJSON(completionHandler:{ response in
            
            
            switch response.result{
                
            case .success:
            view.hidePleaseWait()
                
                let jsonData = JSON(response.result.value!)
                print(jsonData)
                onComplition(jsonData,nil,response.result.value)
                break
            case .failure(let error):
                
                view.hidePleaseWait()
                
                print(error.localizedDescription)
                if error.localizedDescription.contains("JSON could not be")
                {
                    self.ShowAlert(viewController: view, message: m_errorMsg)
                    
                }
                else {
                    self.ShowAlert(viewController: view, message: error.localizedDescription)
                }
                
                
                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
                onComplition(nil,errorObj,response.result.value)
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
    
    
//    func postOnboardingDataToServerWithHeader(url:String,dictionary:NSDictionary, view:UIViewController, headerParam:HTTPHeaders,onComplition:@escaping (JSON?,NSError?)->Void){
//
//        if isFromRefresh == 0 {
//            //view.showPleaseWait(msg: "")
//            view.showFitnessLoader(msg: "", type: 1)
//        }
//        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        let serverURL = URL(string: urlString!)
//        print("URL:",serverURL)
//        print(dictionary)
//
//        let headers: HTTPHeaders = headerParam
//        let parameters:Parameters = dictionary as! Parameters
//        print(headers)
//        Alamofire.request(serverURL!, method: .post, parameters: parameters, encoding: JSONEncoding() as ParameterEncoding, headers: headers).responseJSON(completionHandler:{ response in
//            switch response.result{
//
//            case .success:
//                // view.hidePleaseWait()
//
//                let jsonData = JSON(response.result.value!)
//                print(jsonData)
//                onComplition(jsonData,nil)
//                break
//            case .failure(let error):
//                view.hidePleaseWait()
//                print(error.localizedDescription)
//
//
//                self.ShowAlert(viewController: view, message: error.localizedDescription)
//
//
//                let errorObj = NSError(domain: error.localizedDescription, code: 0, userInfo:nil)
//                onComplition(nil,errorObj)
//                break
//            }
//        })
//
//
//    }
    
}
/*
 class BlurLoader: UIView {
 
 var blurEffectView: UIVisualEffectView?
 let imageView = UIImageView()
 
 override init(frame: CGRect) {
 let blurEffect = UIBlurEffect(style: .dark)
 let blurEffectView = UIVisualEffectView(effect: blurEffect)
 blurEffectView.frame = frame
 blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 self.blurEffectView = blurEffectView
 super.init(frame: frame)
 //addSubview(blurEffectView)
 addLoader()
 }
 
 required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 
 private func addLoader() {
 guard let blurEffectView = blurEffectView else { return }
 
 imageView.frame = CGRect(x: 0 , y: 0, width: 70, height: 50)
 imageView.loadGif(name: "loading")
 imageView.translatesAutoresizingMaskIntoConstraints = false
 imageView.backgroundColor = UIColor.red
 
 self.addSubview(imageView)
 
 let centerX = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: blurEffectView, attribute: .centerX, multiplier: 1, constant: 0)
 let centerY = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: blurEffectView, attribute: .centerY, multiplier: 1, constant: 0)
 
 NSLayoutConstraint.activate([centerX,centerY])
 let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
 let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70)
 
 imageView.addConstraints([heightConstraint, widthConstraint])
 }
 
 
 }
 
 
 extension UIView {
 func setBlur() {
 if !UIAccessibilityIsReduceTransparencyEnabled() {
 self.backgroundColor = .clear
 
 let blurEffect = UIBlurEffect(style: .dark)
 let blurEffectView = UIVisualEffectView(effect: blurEffect)
 //always fill the view
 blurEffectView.frame = self.bounds
 blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 
 self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
 } else {
 self.backgroundColor = .black
 }
 
 
 }
 }
 
 extension UIView {
 func showBlurLoader() {
 let blurLoader = BlurLoader(frame: UIScreen.main.bounds)
 self.addSubview(blurLoader)
 
 }
 
 func removeBluerLoader() {
 if let blurLoader = subviews.first(where: { $0 is BlurLoader }) {
 blurLoader.removeFromSuperview()
 }
 
 if let imageView = subviews.first(where: { $0 is UIImageView }) {
 imageView.removeFromSuperview()
 }
 }
 }
 
 */
extension UIView {
    func showSpinner() {
//        let blurLoader = NewLoader(frame: UIScreen.main.bounds)
//        self.addSubview(blurLoader)
    }
    
    func removeSpinner() {
//        if let blurLoader = self.subviews.first(where: { $0 is NewLoader }) {
//            blurLoader.removeFromSuperview()
//        }
    }
}


