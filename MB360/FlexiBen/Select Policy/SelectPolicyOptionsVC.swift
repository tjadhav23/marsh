//
//  SelectPolicyOptionsVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 02/05/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

protocol NewPoicySelectedDelegate {
    func policyChangedDelegateMethod()
}

class SelectPolicyOptionsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var HeaderLbl: UILabel!
    
    @IBOutlet weak var heightForTableView: NSLayoutConstraint!
    
    var selectedIndex = -1
    
    var policyDataArray = [OE_GROUP_BASIC_INFORMATION]()
    
    var policyDelegateObj : NewPoicySelectedDelegate? = nil
    var policyCount = 0
    var m_productCode = "GMC"
    var fromPageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if policyCount == 1 {
            heightForTableView.constant = 80
            
        }
        else if policyCount == 2 {
            heightForTableView.constant = 160
        }
        else {
            heightForTableView.constant = CGFloat((policyCount * 80))
        }
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.tableView.setCornerRadius()
        self.tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner] // Bottom right corner, Top Bottom corner respectively
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:
                                                    #selector(tapped(_:)))
        tapRecognizer.delegate = self
        self.backView.addGestureRecognizer(tapRecognizer)
        HeaderLbl.text = "Select Policy"
        
        HeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h18))
        HeaderLbl.textColor = FontsConstant.shared.app_WhiteColor
     
        imgIcon.image = UIImage(named:"policies")
        HeaderView.setCornerRadius()
        HeaderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        
        getPolicyDataFromDatabase()
        
        var selectedIndexPosition = UserDefaults.standard.value(forKey: "Selected_Index_Position") as? Int ?? -1
        var selectedOegroup = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as? Int32
        var baseOegroup = policyDataArray[0].oE_GRP_BAS_INF_SR_NO
        
        print("BaseOeGRP : ",baseOegroup," : selectedOegroup: ",selectedOegroup," : selectedIndexPosition ",selectedIndexPosition)
        
        if selectedIndexPosition < 1{
            intialPolicySelected()
        }
        else{
            
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if ((touch.view?.isDescendant(of: self.tableView))!){
            return false
        }
        return true
    }
    
    private func getPolicyDataFromDatabase() {
      
            m_productCode = UserDefaults.standard.value(forKey: "PRODUCT_CODE") as! String
        
        self.policyDataArray = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: m_productCode)
        
        print("policyDataArray 1 : ",self.policyDataArray)
        
        
        self.tableView.reloadData()
    }
    
    @objc private func tapped(_ sender : UITapGestureRecognizer) {
        update()
    }
    
    @objc func update() {
        if policyDelegateObj != nil {
            print("Inside policyDelegateObj: ",policyDelegateObj)
            self.policyDelegateObj?.policyChangedDelegateMethod()
        }
        print("Outside policyDelegateObj: ",policyDelegateObj)
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- TableView DataSource And Delegate

extension SelectPolicyOptionsVC {

func numberOfSections(in tableView: UITableView) -> Int {
    return 2
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
        return 0
    }
    else{
        print("Count : ",policyDataArray.count)
        return policyDataArray.count
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
    let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPolicyTableViewCell", for: indexPath) as! SelectPolicyTableViewCell
        print("indexPath : ",indexPath.row)
        print("policyDataArray: ",policyDataArray[indexPath.row])
    
        cell.lblAmount.text = policyDataArray[indexPath.row].policyNumber //Policy Name
    var policyType = "\(policyDataArray[indexPath.row].policyType!) POLICY"
        cell.lblPolicyType.text = policyType //Policy Type
        cell.lblOption.text = "["+convertDateFormater(policyDataArray[indexPath.row].policyComencmentDate!)+" To "+convertDateFormater(policyDataArray[indexPath.row].policyValidUpto!)+"]"
        
    
        print("Data is: 1 ",UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as? String)
        print("Data is: 2 ",policyDataArray[indexPath.row].oE_GRP_BAS_INF_SR_NO.description )
    
        if let oegroup = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as? String {
            if oegroup == policyDataArray[indexPath.row].oE_GRP_BAS_INF_SR_NO.description {
                cell.btnRadio.setImage(UIImage(named: "blue radio checked"), for: .normal)
            }
            else {
                cell.btnRadio.setImage(UIImage(named: "blue radio"), for: .normal)
            }
        }
        else {
            cell.btnRadio.setImage(UIImage(named: "blue radio"), for: .normal)
        }
        cell.btnRadio.tag = indexPath.row
        cell.btnRadio.addTarget(self, action: #selector(policyChanged(_:)), for: .touchUpInside)
        
      
        
        return cell
    //}
    
}
    
    @objc func policyChanged(_ sender : UIButton) {
        print("Policy radio tapped....")

        self.selectedIndex = sender.tag
        let productCode = policyDataArray[selectedIndex].productCode
        UserDefaults.standard.setValue(productCode, forKey: "PRODUCT_CODE")

        let oeGroupBase = String(policyDataArray[selectedIndex].oE_GRP_BAS_INF_SR_NO).removeSpecialChars
        UserDefaults.standard.setValue(oeGroupBase, forKey: "OE_GRP_BAS_INF_SR_NO")
        
        let selectedIndexValue = self.selectedIndex
        UserDefaults.standard.setValue(selectedIndexValue, forKey: "Selected_Index_Position")

        print("policyChanged: ",oeGroupBase," : ",productCode," : ",selectedIndexValue)
        self.tableView.reloadData()
    }
    
    func intialPolicySelected(){
        self.selectedIndex = 0
        
        let productCode = policyDataArray[selectedIndex].productCode
        UserDefaults.standard.setValue(productCode, forKey: "PRODUCT_CODE")
        
        let oeGroupBase = String(policyDataArray[selectedIndex].oE_GRP_BAS_INF_SR_NO).removeSpecialChars
        UserDefaults.standard.setValue(oeGroupBase, forKey: "OE_GRP_BAS_INF_SR_NO")

        print("intialPolicySelected: ",oeGroupBase," : ",productCode)
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("Did Select....",indexPath.section)
        if indexPath.section == 1 {
            
            self.selectedIndex = indexPath.row
            let productCode = policyDataArray[selectedIndex].productCode
            UserDefaults.standard.setValue(productCode, forKey: "PRODUCT_CODE")

            let oeGroupBase = String(policyDataArray[selectedIndex].oE_GRP_BAS_INF_SR_NO).removeSpecialChars
            UserDefaults.standard.setValue(oeGroupBase, forKey: "OE_GRP_BAS_INF_SR_NO")

            let groupchildSrNo = String(policyDataArray[selectedIndex].groupchildSrNo).removeSpecialChars
            UserDefaults.standard.setValue(groupchildSrNo, forKey: "GroupChildSrNo")
            
            
            let selectedIndexValue = self.selectedIndex
            UserDefaults.standard.setValue(selectedIndexValue, forKey: "Selected_Index_Position")

            print("policyChanged: oeGroupBase: ",oeGroupBase," : productCode: ",productCode," : groupchildSrNo: ",groupchildSrNo," index: ",selectedIndexValue)
            
            print("policyDataArray: ",policyDataArray)
            
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            update()
        }
        
    }
    


func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    if indexPath.section == 0 {
//        return 55
//    }
    return 80
    
}

//MARK:- Set Footer View
    
    /*
func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let vw = UIView()
    vw.backgroundColor = UIColor.clear
    //let titleLabel = UILabel(frame: CGRect(x:10,y: 5 ,width:350,height:150))
    return vw
    
}

func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if section == 1 {
        return 60
    }
    return 0
    }
    */
}

