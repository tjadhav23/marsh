//
//  ClaimUploadedDocsViewController.swift
//  MyBenefits360
//
//  Created by Thynksight on 12/10/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit
import TrustKit

class ClaimUploadedDocsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIDocumentInteractionControllerDelegate {

    
    

    @IBOutlet weak var tblList: UITableView!
    
    @IBOutlet weak var errorVew: UIView!
    
    @IBOutlet weak var imgError: UIImageView!
    
    @IBOutlet weak var lblErrortitle: UILabel!
    
    
    @IBOutlet weak var lblErrordetail: UILabel!
    var arrUrls : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register the custom cell XIB with the table view
           let nib = UINib(nibName: "ClaimUploadDocsTableViewCell", bundle: nil)
        tblList.register(nib, forCellReuseIdentifier: "ClaimUploadDocsTableViewCell")
        tblList.delegate = self
        tblList.dataSource = self
        arrUrls.removeLast()
        DispatchQueue.main.async{
            if self.arrUrls.count>0{
                self.tblList.isHidden = false
                self.errorVew.isHidden = true
                self.tblList.reloadData()
            }else{
                self.tblList.isHidden = true
                self.errorVew.isHidden = false
                self.imgError.image=UIImage(named: "claimnotfound")
                self.lblErrortitle.text = "No data found"
                self.lblErrordetail.text = "During_Enrollment_Detail_ErrorMsg".localized()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=true
        navigationController?.navigationBar.isHidden=false
        navigationItem.title="Uploaded Documents"
        //navigationItem.rightBarButtonItem=getRightBarButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        
       
        
        navigationItem.leftBarButtonItem = getBackButton()
        //navigationItem.leftBarButtonItem = nil
        menuButton.isHidden = true
       // menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
    }

    @objc private func homeButtonClicked(sender: UIButton)
    {
//        navigationController?.popViewController(animated: true)
        tabBarController!.selectedIndex = 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblList.dequeueReusableCell(withIdentifier: "ClaimUploadDocsTableViewCell", for: indexPath) as! ClaimUploadDocsTableViewCell
        var url = arrUrls[indexPath.row]
        if url.contains("("){
            var name = url.components(separatedBy: "(")
            cell.lblName.text = name[1].replacingOccurrences(of: ")", with: "")
            
        }
        if url.lowercased().contains(".xls") || url.lowercased().contains(".xlsx"){
            cell.imgIcon.image =  UIImage(named: "excel")
        }else if url.lowercased().contains(".jpeg") || url.lowercased().contains(".jpg"){
            cell.imgIcon.image =  UIImage(named: "img_new")
        }else if url.lowercased().contains(".doc"){
            cell.imgIcon.image =  UIImage(named: "word")
        }else if url.lowercased().contains(".pdf"){
            cell.imgIcon.image =  UIImage(named: "pdf-1")
        }else if url.lowercased().contains(".png"){
            cell.imgIcon.image =  UIImage(named: "png")
        }else{
            cell.imgIcon.image =  UIImage(named: "img_new")
        }
        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
        cell.vewMain.layer.cornerRadius = cornerRadiusForView
        
        return cell
    }
    
    @objc func downloadButtonClicked(sender:UIButton)
    {
        let indexpath = IndexPath(row:sender.tag,section:0)
         print(arrUrls)
        var arr = arrUrls[indexpath.row].components(separatedBy: "(")
        let url = arr[0]
        print(url)
        self.openSelectedDocumentFromURL(documentURLString: url)
        
        
    }
    
    private func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController
    {
        UINavigationBar.appearance().barTintColor = hexStringToUIColor(hex: hightlightColor)
        UINavigationBar.appearance().tintColor = hexStringToUIColor(hex: hightlightColor)
        UINavigationBar.appearance().backgroundColor = hexStringToUIColor(hex: hightlightColor)
        return self
    }
    
    // MARK: - UIDocumentInteractionViewController delegate methods
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
       hidePleaseWait()
        
        return self
    }
    private func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController)
    {
        
    }
    
    func openSelectedDocumentFromURL(documentURLString: String) {
        let newBaseurlPortal = WebServiceManager.getSharedInstance().downloadBaseUrlPortal
        let url = newBaseurlPortal.appending(documentURLString as! String)
                
                if let stringUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                {
                    let urlStr : NSString = stringUrl as NSString
                
                if let searchURL : NSURL = NSURL(string: urlStr as String)
                {
                    
                    print("UTILITIES mybenefits/Downloadables URL ",searchURL)
                    let request = URLRequest(url: searchURL as URL)
                    //let session = URLSession(configuration: URLSessionConfiguration.default)
                    
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
                        //SSL Pinning
                        if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                            // Handle SSL connection failure
                            print("SSL connection error: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                self.alertForLogout(titleMsg: error.localizedDescription)
                            }
                        }
                        else if error != nil {
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
                                    do
                                    {
                                        
                                        let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                                        
                                        if var fileName = searchURL.lastPathComponent
                                        {
                                          
                                            
                                            let destinationUrl = documentsUrl.appendingPathComponent(fileName)
                                            let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
                                            print(fileURLPath)

                                            if let data = data{
                                                
                                                if(destinationUrl != nil)
                                                {
                                                    try data.write(to: destinationUrl!, options: .atomic)
                                                    try self.openSelectedDocument(documentURLString: fileURLPath!.path)
                                                }
                                            }
                                            else{
                                                self.hidePleaseWait()
                                                self.isConnectedToNetWithAlert()
                                            }
                                        }
                                    }
                                    catch
                                    {
//                                        Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
//                                        print(error)
//                                        self.hidePleaseWait()
                                    }
                                }
                                else if httpResponse.statusCode == 404
                                {
                                    self.hidePleaseWait()
                                    
                                    self.displayActivityAlert(title: m_errorMsgFile)
                                    print("File not found executed")
                                }
                                else{
                                    self.hidePleaseWait()
                                    
                                    self.displayActivityAlert(title: m_errorMsg)
                                    print("else executed")
                                }
                            }
                            else
                            {
                                print("Can't cast response to NSHTTPURLResponse")
                                self.displayActivityAlert(title: m_errorMsg)
                                self.hidePleaseWait()
                                
                            }
                        }
                    }
                    task.resume()
                    
                }
                else
                {
                    self.hidePleaseWait()
                    self.displayActivityAlert(title: m_errorMsg)
                    
                }
                }
                else
                {
                    self.displayActivityAlert(title: m_errorMsg)
                    hidePleaseWait()
                }
    }
    
    func openSelectedDocument(documentURLString: String) throws {
       DispatchQueue.main.async()
        {
            //code
        
           if let documentURL: NSURL? = NSURL(fileURLWithPath: documentURLString)
           {
            UINavigationBar.appearance().barTintColor = self.hexStringToUIColor(hex: hightlightColor)
            UINavigationBar.appearance().tintColor = self.hexStringToUIColor(hex: hightlightColor)
            UINavigationBar.appearance().backgroundColor = self.hexStringToUIColor(hex: hightlightColor)
               UINavigationBar.appearance().titleTextAttributes = [
                   NSAttributedString.Key.foregroundColor: FontsConstant.shared.app_FontPrimaryColor
               ]
            documentController = UIDocumentInteractionController(url: documentURL! as URL)
            documentController.delegate = self
            documentController.presentPreview(animated: true)
           self.hidePleaseWait()
           }
        
        }
       
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
