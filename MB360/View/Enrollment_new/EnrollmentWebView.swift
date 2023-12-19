//
//  EnrollmentWebView.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 01/03/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import PDFKit

/*
class EnrollmentWebView: UIViewController,UIWebViewDelegate, UIDocumentInteractionControllerDelegate{


    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var webView: UIWebView!
    var m_employeedict : EMPLOYEE_INFORMATION?
    var employeesrno = String()
    var documentController: UIDocumentInteractionController = UIDocumentInteractionController()

    
    override func viewDidLoad() {
        menuButton.isHidden = true
        self.tabBarController?.tabBar.isHidden=true
        super.viewDidLoad()
        print("Inside EnrollmentWebView ")
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        setupNavBarDetails()
        getUrlCall()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        navigationController?.navigationBar.isHidden=false
        self.tabBarController?.tabBar.isHidden=true
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        menuButton.isHidden=true
    }
    
    func setupNavBarDetails()
    {
        /*
        self.navigationController?.navigationBar.navBarDropShadow()
        //cartBottomView.backgroundColor = Color.bottomColor.value
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
        
        lbNavTitle.text = "Enrollment"
        self.navigationItem.titleView = lbNavTitle
        
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        //self.navigationItem.title = "Doctor 24x7"
        //self.navigationController?.navigationBar.changeFont()
        */
        
//        navigationController?.isNavigationBarHidden=false
//        navigationItem.leftBarButtonItem=getBackButton()
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
//        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
//        navigationController?.navigationBar.dropShadow()
//        self.tabBarController?.tabBar.isHidden=false
        self.navigationItem.title="Enrollment"
                navigationController?.isNavigationBarHidden=false
                navigationItem.leftBarButtonItem=getBackButton()
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        
        
    }
    
    @objc func backTapped() {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func getUrlCall(){
        
        userEmployeeSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String ?? ""
        employeesrno = userEmployeeSrno
        authToken = UserDefaults.standard.value(forKey: "userAppToken") as! String
        print("authToken HandleAppSession:",authToken)
        //let link = "http://15.206.179.89:91/HandleAppSession.ASPX?APPLOGIN=67032"//+employeesrno
        //let link = WebServiceManager.sharedInstance.downloadBaseUrl+"HandleAppSession.ASPX?APPLOGIN="+employeesrno
        let link = WebServiceManager.sharedInstance.downloadBaseUrl+"HandleAppSession.ASPX?APPLOGIN="+authToken
        let url = URL (string: link)
        let requestObj = URLRequest(url: url!)
        print("RequestObj: ",requestObj)
        self.webView.loadRequest(requestObj)
        
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        showPleaseWait(msg: "")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hidePleaseWait()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let str = request.url?.absoluteString
        print("Inside shouldStartLoadWith: ",str!)
        var pdfUrl = "flex/flexsummary/"+employeesrno+"/SUMMARY_FILE_"+employeesrno
       
        if request.url?.absoluteString.range(of: pdfUrl) != nil {
            print("pdfUrl: ",pdfUrl)
            do
            {
                // Add PDFView to view controller.
                let pdfView = PDFView(frame: self.view.bounds)
                self.view.addSubview(pdfView)
                
                // Fit content in PDFView.
                pdfView.autoScales = true
                
                // Load Sample.pdf file.
                
                let fileURL = URL(string: str!)
                print("fileURL: ",fileURL," str: ",str)
                pdfView.document = PDFDocument(url: fileURL!)
                
            }
            catch
            {
                print(error)
            }
        }
        return true
    }
}

*/


class EnrollmentWebView: UIViewController, WKUIDelegate, WKNavigationDelegate {

    
    var webView: WKWebView!
    var m_employeedict : EMPLOYEE_INFORMATION?
    var employeesrno = String()
    var documentController: UIDocumentInteractionController = UIDocumentInteractionController()
    var appTimer: Timer?

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
        print("Inside EnrollmentWebView ")
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
        let link = WebServiceManager.sharedInstance.downloadBaseUrl+"HandleAppSession.ASPX?APPLOGIN="+authToken
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
        self.navigationItem.title="Enrollment"
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
            self.appTimer = Timer.scheduledTimer(withTimeInterval: 18, repeats: true) { timer in
                
                print("web Timer fired!")
                self.hidePleaseWait()
            }
        }
    }
    /*
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        DispatchQueue.main.async {
            
            print("Inside decidePolicyFor: ", url)
            let pdfUrl = "flex/flexsummary/\(self.employeesrno)/SUMMARY_FILE_\(self.employeesrno)"
            
            if url.range(of: pdfUrl) != nil {
                print("pdfUrl: ", pdfUrl)
                let pdfView = PDFView(frame: self.view.bounds)
                self.view.addSubview(pdfView)
                pdfView.autoScales = true
                
                if let fileURL = URL(string: url) {
                    print("fileURL: ", fileURL, " str: ", url)
                    pdfView.document = PDFDocument(url: fileURL)
                }
            }
            decisionHandler(.allow)
        }
    }
     */
}

