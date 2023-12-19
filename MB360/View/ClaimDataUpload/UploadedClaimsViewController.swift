//
//  UploadedClaimsViewController.swift
//  MyBenefits360
//
//  Created by Thynksight on 08/09/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit

class UploadedClaimsViewController: UIViewController {
    
    @IBOutlet weak var lblClaims: UILabel!
    
    @IBOutlet weak var tblList: UITableView!
    
    @IBOutlet weak var btnNewReq: UIButton!
    
    @IBOutlet weak var errorVew: UIView!
    
    @IBOutlet weak var imgError: UIImageView!
    
    @IBOutlet weak var errorTitle: UILabel!
    
    @IBOutlet weak var errorDetail: UILabel!
    
    var arrList : [AaDatum] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Register the custom cell XIB with the table view
           let nib = UINib(nibName: "UploadedClaimListTableViewCell", bundle: nil)
        tblList.register(nib, forCellReuseIdentifier: "UploadedClaimListTableViewCell")
           
           // Set the table view's delegate and data source to self
        tblList.delegate = self
        tblList.dataSource = self
        // Do any additional setup after loading the view.
        
        tblList.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden=false
        navigationItem.title="link14Name".localized()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        navigationItem.leftBarButtonItem = getBackButton()
        
        self.tabBarController?.tabBar.isHidden=false
        menuButton.isHidden=false
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        DispatchQueue.main.async()
            {
                menuButton.isHidden=false
                menuButton.accessibilityElementsHidden=true
        }
        
        setupUI()
        getList()
        
    }
    
    @objc private func homeButtonClicked(sender: UIButton)
    {
        tabBarController!.selectedIndex = 2
    }
  
    
    func setupUI(){
        lblClaims.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h16))
        lblClaims.textColor = FontsConstant.shared.app_FontBlackColor
        btnNewReq.layer.cornerRadius = 4
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
    }


    @IBAction func btnNewReqAct(_ sender: UIButton) {
        let vc : ClaimDetailsFormViewController = ClaimDetailsFormViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

    func getList(){
        if isConnectedToNet(){
            let appendurl = "IntimateClaim/LoadALLClaimsDetails?EndIndex=50&StartIndex=0&Search&employeesrno=\(employeeSrNoGMC)&groupchildsrno=\(userGroupChildNo)&oegrpbasinfsrno=\(userOegrpNo)"
            webServices().getRequestForJsonCDU(appendurl, completion: { (data,error,resp) in
                if error != ""{
                    DispatchQueue.main.async{
                        self.tblList.isHidden = true
                        self.errorVew.isHidden = false
                        self.imgError.image=UIImage(named: "claimnotfound")
                        self.errorTitle.text = "No data found"
                        self.errorDetail.text = "During_Enrollment_Detail_ErrorMsg".localized()
                    }
                    
                }else{
                    if let httpResponse = resp as? HTTPURLResponse//response as? HTTPURLResponse
                    {
                        print("getDetailsPortal: ",httpResponse.statusCode)
                        if httpResponse.statusCode == 200
                        {
                            do {
                                let json = try JSONDecoder().decode(GetUploadedClaims.self, from: data!)
                                self.arrList = json.aaData
                                DispatchQueue.main.async {
                                    if self.arrList.count > 0{
                                        self.tblList.isHidden = false
                                        self.errorVew.isHidden = true
                                    }else{
                                        self.tblList.isHidden = true
                                        self.errorVew.isHidden = false
                                        self.imgError.image=UIImage(named: "claimnotfound")
                                        self.errorTitle.text = "No data found"
                                        self.errorDetail.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                    }
                                    self.tblList.reloadData()
                                }
                                
                                
                            }catch{
                                
                            }
                        }else{
                            DispatchQueue.main.async{
                                self.tblList.isHidden = true
                                self.errorVew.isHidden = false
                                self.imgError.image=UIImage(named: "claimnotfound")
                                self.errorTitle.text = "No data found"
                                self.errorDetail.text = "During_Enrollment_Detail_ErrorMsg".localized()
                            }
                        }
                    }
                }
                
                
            })
        }else{
            DispatchQueue.main.async{
                self.tblList.isHidden = true
                self.errorVew.isHidden = false
                self.imgError.image=UIImage(named: "nointernet")
                self.errorTitle.text = error_NoInternet
                self.errorDetail.text = ""
            }
            
        }
        
    }
    
    
    func getIdwiseRelationName(_ id : String) -> String{
      
      
        var relationName : String = ""
        switch id {
        case "4":
            relationName = "Daughter"
            break
        case "3":
            relationName = "Son"
        case "21":
            relationName = "Partner"
        case "1":
            relationName = "Father"
        case "5":
            relationName = "Father-In-Law"
        case "6":
            relationName = "Mother-In-Law"
        case "2":
            relationName = "Mother"
        case "11":
            relationName = "Spouse"
        case "17":
            relationName = "Employee"
        default:
            break
        }
        return relationName
        
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

extension UploadedClaimsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblList.dequeueReusableCell(withIdentifier: "UploadedClaimListTableViewCell", for: indexPath) as! UploadedClaimListTableViewCell
        var relation = getIdwiseRelationName(arrList[indexPath.row].relationid)
        cell.lblDate.text = arrList[indexPath.row].clmDocsUloadedOn
        cell.lblRequest.text = arrList[indexPath.row].clmDocsUploadReqNo
        cell.btnStatus.setTitle(arrList[indexPath.row].status, for: .normal)
        cell.lblClaimIntimated.text = "On \(arrList[indexPath.row].claimIntimatedDest)"
        cell.lblClaim.text = arrList[indexPath.row].typeOfClaim
        cell.lblIntimationNo.text = arrList[indexPath.row].claimIntimationNo
        cell.lblName.text = arrList[indexPath.row].personName
        cell.lblRelation.text = relation
        cell.lblDob.text = "\(arrList[indexPath.row].dateOfBirth) (\(arrList[indexPath.row].age) years)"
        cell.btnViewDocs.tag=indexPath.row
        cell.btnEdit.tag = indexPath.row
        cell.btnStatus.layer.cornerRadius = cornerRadiusForView
        cell.btnViewDocs.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
        cell.btnEdit.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
//        if arrList[indexPath.row].status.uppercased() == "INCOMPLETE"{
//            cell.btnViewDocs.isHidden = true
//            cell.VewBtnvew.isHidden = true
//        }else{
//            cell.btnViewDocs.isHidden = false
//            cell.VewBtnvew.isHidden = false
//        }
        
        return cell
    }
    
    @objc func downloadButtonClicked(sender:UIButton)
    {
        let indexpath = IndexPath(row:sender.tag,section:0)
        let vc : ClaimUploadedDocsViewController = ClaimUploadedDocsViewController()
        var arrurls = arrList[indexpath.row].files.components(separatedBy: "~")
        vc.arrUrls = arrurls
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @objc func editButtonClicked(sender:UIButton)
    {
        let indexpath = IndexPath(row:sender.tag,section:0)
        let vc : ClaimDetailsFormViewController = ClaimDetailsFormViewController()
        vc.editData = arrList[indexpath.row]
        vc.isFromEdit = true
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 440
    }
    
    
}
