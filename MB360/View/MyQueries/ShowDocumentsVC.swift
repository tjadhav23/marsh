//
//  ShowDocumentsVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 14/08/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class CellForDocsVC: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDocName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class ShowDocumentsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate,UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var docsArray = [NSDictionary]()
    var imageFormatsArray = [".png","PNG","JPEG",".jpeg",".JPG",".jpg","JPG","jpg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UtilitiesTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib (nibName: "UtilitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        
        self.tableView.tableFooterView = UIView()
        navigationItem.leftBarButtonItem = getBackButton()
        self.title = "Documents"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationItem.leftBarButtonItem = getBackButton()

        navigationController?.isNavigationBarHidden=false
        //        navigationItem.leftBarButtonItem=getBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        navigationItem.leftBarButtonItem = getBackButton()
        self.tabBarController?.tabBar.isHidden=true

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  self.docsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UtilitiesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UtilitiesTableViewCell
        
        let filePath = docsArray[indexPath.row].value(forKey: "FileName")
        let type = docsArray[indexPath.row].value(forKey: "FileType") as? String
        
        //cell.lblAttachment.text = filePath as! String
        let fileName = (filePath as! NSString).lastPathComponent
        let fileNameArr = fileName.characters.split{$0 == "\\"}.map(String.init)
        cell.m_fileNameLbl.text=fileNameArr[fileNameArr.count-1]

        if (type == ".xlsx" || type == "XLS" || type=="XLSX")
        {
            cell.m_iconImageView.image = UIImage(named: "excel")
        }
        else if(type == ".pdf" || type == "PDF")
        {
            cell.m_iconImageView.image = UIImage(named: "pdf-1")
        }
        else if(type == ".doc" || type == "DOC")
        {
            cell.m_iconImageView.image = UIImage(named: "word")
        }
        else if(imageFormatsArray.contains(type ?? ""))
        {
            cell.m_iconImageView.image = UIImage(named: "img")
        }
        else
        {
            cell.m_iconImageView.image = UIImage(named: "xlsfile")
        }
        
        cell.m_downloadButton.isUserInteractionEnabled = false
        shadowForCell(view: cell.m_backgroundView)
        cell.selectionStyle = .none

        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        if let dict : NSDictionary = docsArray[indexPath.row] as? NSDictionary
        {
            
            if let fileName = dict.value(forKey: "FileName")
            {
                showPleaseWait(msg: "Please wait...")
                
                //                DispatchQueue.main.async
                //                    {
                
                let url : NSString = fileName as! NSString
                
                
                if let stringUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                {
                    let urlStr : NSString = stringUrl as NSString
                    
                    if let searchURL : NSURL = NSURL(string: urlStr as String)
                    {
                        let request = URLRequest(url: searchURL as URL)
                        let session = URLSession(configuration: URLSessionConfiguration.default)
                        
                        let task = session.dataTask(with: request, completionHandler:
                        {(data, response, error) -> Void in
                            
                            do
                            {
                                
                                let documentsUrl =  FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first! as NSURL
                                
                                if var fileName = searchURL.lastPathComponent
                                {
                                    //added by Pranit
                                    //fileName=fileName.replacingOccurrences(of: "_GMC", with: "")
                                    
                                  
                                    let destinationUrl = documentsUrl.appendingPathComponent(fileName)
                                    let fileURLPath = documentsUrl.appendingPathComponent("\(fileName)")
                                    if let data = data
                                    {
                                        
                                        if(destinationUrl != nil)
                                        {
                                            
                                            //Added By Pranit - to write file
                                            try data.write(to: destinationUrl!, options: .atomic)
                                            
                                            
                                            try self.openSelectedDocumentFromURL(documentURLString: fileURLPath!.path)
                                            
                                            //                                            try data.write(to: destinationUrl!, options: .atomic)
                                            
                                            
                                            //                                            documentController = UIDocumentInteractionController(url: destinationUrl!)
                                        }
                                        //                                        self.showAlert(message: "destinationUrl:\(destinationUrl)")
                                    }
                                    else
                                    {
                                        self.hidePleaseWait()
                                        self.isConnectedToNetWithAlert()
                                    }
                                }
                            }
                            catch
                            {
                               // Crashlytics.sharedInstance().recordError(m_errorMsg as! Error)
                                print(error)
                                self.hidePleaseWait()
                            }
                            
                            self.hidePleaseWait()
                        })
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
                
                //                }
            }
            else
            {
                displayActivityAlert(title: m_errorMsg)
                hidePleaseWait()
            }
            
            
        }
    }

    func openSelectedDocumentFromURL(documentURLString: String) throws {
        DispatchQueue.main.async()
            {
                //code

                if let documentURL : NSURL? = NSURL(fileURLWithPath: documentURLString)
                {
                   
                    UINavigationBar.appearance().barTintColor = self.hexStringToUIColor(hex: hightlightColor)
                    UINavigationBar.appearance().tintColor = self.hexStringToUIColor(hex: hightlightColor)
                    UINavigationBar.appearance().backgroundColor = self.hexStringToUIColor(hex: hightlightColor)
                    UINavigationBar.appearance().titleTextAttributes = [
                        NSAttributedString.Key.foregroundColor: FontsConstant.shared.app_FontPrimaryColor
                    ]
                    documentController.delegate = self
                    
                    documentController = UIDocumentInteractionController(url: documentURL! as URL)
                    documentController.delegate = self
                    documentController.presentPreview(animated: true)
                    self.hidePleaseWait()

                }
                
        }
        
    }
    
    
    // MARK: - UIDocumentInteractionViewController delegate methods
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        hidePleaseWait()
        UINavigationBar.appearance().barTintColor = hexStringToUIColor(hex: hightlightColor)
        UINavigationBar.appearance().tintColor = hexStringToUIColor(hex: hightlightColor)
        UINavigationBar.appearance().backgroundColor = hexStringToUIColor(hex: hightlightColor)
        
        return self
    }
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController)
    {
        documentPicker.delegate = self as! UIDocumentPickerDelegate
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
        
    }

}
