//
//  ClaimsStatusViewController.swift
//  MyBenefits
//
//  Created by Semantic on 12/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class ClaimsStatusViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
//    @IBOutlet weak var m_StepindicatorView: StepIndicatorView!
    
    @IBOutlet weak var m_tableView: UITableView!
    let reuseIdentifier = "cell"
    var m_claimDetailsDict : MyClaimsDetails?
    var m_employeedict : PERSON_INFORMATION?
    var m_groupDict : OE_GROUP_BASIC_INFORMATION?
    
    var timer = Timer()
    let delay = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden=true
        m_tableView.register(ClaimStatusTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        let nib = UINib (nibName: "ClaimStatusTableViewCell", bundle: nil)
        m_tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        m_tableView.tableFooterView=UIView()
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        
        let userArray : [OE_GROUP_BASIC_INFORMATION] = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "")
        if (userArray.count>0)
        {
            
            m_groupDict=userArray[0]
        }
//        m_StepindicatorView.currentStep=0
        timer.invalidate()
        
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(delay), target: self, selector: #selector(delayedAction), userInfo: nil, repeats: true)
       
        
        
        
        
    }
    
    
    @objc func delayedAction()
   {
     print("Stepper start")
//     StepIndicatorView.setAnimationBeginsFromCurrentState(true)
//     m_StepindicatorView.currentStep=m_StepindicatorView.currentStep+1
//    if(m_StepindicatorView.currentStep>m_StepindicatorView.numberOfSteps)
//    {
//        timer.invalidate()
//    }
    }
   
    override func viewWillAppear(_ animated: Bool)
    {
        navigationItem.leftBarButtonItem=getBackButton()
        navigationItem.title="Claim Status"
    }
    override func backButtonClicked()
    {
        self.tabBarController?.tabBar.isHidden=true
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : ClaimStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ClaimStatusTableViewCell
        
        cell.selectionStyle=UITableViewCellSelectionStyle.none

        
        shadowForCell(view: cell.m_backGroundView)
        cell.m_backGroundView.layer.cornerRadius=10
        cell.m_statusButton.layer.cornerRadius=15
        
        
        if(indexPath.row==0)
        {
//            cell.m_statusButton.backgroundColor=hexStringToUIColor(hex: "4B66EA")
            cell.m_statusButton.setImage(#imageLiteral(resourceName: "avatarWhite"), for: .normal)
            cell.m_statusLbl.text="Member Information"
            
//            cell.m_policyNoLbl.text = m_groupDict?.policyNumber
////            cell.m_genderLbl.text=m_employeedict?.gender
//            cell.m_policyPeriodLbl.text=(m_groupDict?.policyComencmentDate)!+" To "+(m_groupDict?.policyValidUpto)!
            
            cell.m_nameLbl.text=m_claimDetailsDict?.beneficiary
            cell.m_relationLbl.text=m_claimDetailsDict?.relation
            
        }
        else if(indexPath.row==1)
        {
            cell.m_statusButton.backgroundColor=hexStringToUIColor(hex: "4B66EA")
            cell.m_statusButton.setImage(#imageLiteral(resourceName: "ClaimReport"), for: .normal)
            cell.m_statusLbl.text="Claim Reported on"
            
//            let str = String(m_groupDict?.policyNumber)
//            cell.m_policyNoLbl.text = String(m_groupDict?.policyNumber)
//            cell.m_genderLbl.text=m_employeedict?.gender
//            cell.m_policyPeriodLbl.text=((m_groupDict?.policyComencmentDate)!+" To "+(m_groupDict?.policyValidUpto)!
            
            cell.m_nameLbl.text=m_claimDetailsDict?.beneficiary
            cell.m_relationLbl.text=m_claimDetailsDict?.relation
            
        }
        else if(indexPath.row==2)
        {
            cell.m_statusButton.backgroundColor=hexStringToUIColor(hex: "26C281")
            cell.m_statusButton.setImage(#imageLiteral(resourceName: "checkSymbol"), for: .normal)
            cell.m_statusLbl.text="Claim Paid"
            
            cell.m_title1Lbl.text="Claim Number"
//            cell.m_nameLbl.text = m_claimDetailsDict?.value(forKey: "CLAIM_NO") as? String
            
            cell.m_title2Lbl.text="Estimated Amount"
           // cell.m_policyNoLbl.text=m_claimDetailsDict?.value(forKey: "TOTAL_CLAIM_AMT")as? String
            
            cell.m_title3Lbl.text="Name of Provider"
//            cell.m_policyPeriodLbl.text=m_claimDetailsDict.value(forKey: "<#T##String#>")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 210
    }
}
