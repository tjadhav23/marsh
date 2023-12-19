//
//  ClaimDataUpload.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 30/08/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import PDFKit



class ClaimDataUpload: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var mainView: UIView!
    //var webView: WKWebView!
    @IBOutlet weak var webView: WKWebView!
      
    var m_employeedict : EMPLOYEE_INFORMATION?
    var employeesrno = String()
    var documentController: UIDocumentInteractionController = UIDocumentInteractionController()

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }


    
    override func viewDidLoad() {
        menuButton.isHidden = true
        self.tabBarController?.tabBar.isHidden=true
        self.webView.scrollView.showsHorizontalScrollIndicator = false
        self.webView.scrollView.showsVerticalScrollIndicator = false
        
        
        super.viewDidLoad()
        print("Inside ClaimDataUpload ")
        setupNavBarDetails()
        getUrlCall()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        menuButton.isHidden = true
        self.navigationController?.navigationBar.isHidden=false
        self.tabBarController?.tabBar.isHidden=true
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
    }
    
    func getUrlCall(){
        
        userEmployeeSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String ?? ""
        employeesrno = userEmployeeSrno
        authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
        print("authToken HandleAppSession:",authToken)
        let link = WebServiceManager.sharedInstance.downloadBaseUrl+"HandleAppSession.ASPX?APPLOGIN="+authToken+"&Qval=allclaims"
        let url = URL (string: link)
        let requestObj = URLRequest(url: url!)
        print("RequestObj: ",requestObj)
        
        DispatchQueue.main.async {
            // Update the UI on the main thread
            self.webView.load(requestObj)
        }
    }
    
    func setupNavBarDetails()
    {
        self.navigationItem.title="Claim data upload"
        self.navigationController?.isNavigationBarHidden=false
        self.navigationItem.leftBarButtonItem = self.getBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [self.hexStringToUIColor(hex: hightlightColor),self.hexStringToUIColor(hex: gradiantColor2)])
        self.navigationController?.navigationBar.dropShadow()
    }
    
    //    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    //        DispatchQueue.global(qos: .userInitiated).async {
    //            self.showPleaseWait(msg: "")
    //        }
    //    }
    
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.showPleaseWait(msg: "")
        }
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.hidePleaseWait()
        }
    }
}
