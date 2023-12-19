//
//  HealthPackagesVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 25/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

struct  HealthPackage {
    var packId : String?
    var userName:String?
    var userId:Int?
    var price : Int?
    
}

struct HPManager {
    var obj : HealthPackage?
}

class HealthPackagesVC: UIViewController {
    
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    
   // @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
//    var PackageNames = [
//        "Basic Holistic Assessment",
//        "Demography Based Plan1-Male",
//        "Basic Essential Plan 2",
//        "Demography Based Plan2-Male"
//    ]
//
//    var PackageAmount = [
//        "2300","3700","2450","4700"
//    ]
//
//    var HealthPackageId = [
//        "11","12","13","14"
//    ]
    
    var hpManagerArray = [HealthPackage]()
    var hpFemaleArray = [HealthPackage]()
    var femaleArrayHC = [HCDependantModel]()
    var maleArrayHC = [HCDependantModel]()

    
    var m_productCode = String()
    var maleArray = Array<PERSON_INFORMATION>()
    var femaleArray = Array<PERSON_INFORMATION>()
    var isLoaded = 0
    var m_employeedict : EMPLOYEE_INFORMATION?
    
    var lastContentOffset: CGFloat = 0 //ScrollViewDelegate
    var hideCollectionViewDelegate : HideCollectionViewProtocol? = nil

    
    var packageArray = [HealthPackagesModel]()
    var hcDependantModelArray = [HCDependantModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // navigationController?.isNavigationBarHidden=true
        //self.navigationItem.leftBarButtonItem = getBackButtonHideTabBar()
        //self.title = "Health Packages"
        
        let startPoint = CGPoint(x:0.5, y:0.0)
        let endPoint = CGPoint(x:0.5, y:1.0)
        setColorNew(view: self.view, colorTop: EnrollmentColor.ghiTop.value, colorBottom: EnrollmentColor.ghiBottom.value,gradientLayer:gradientLayer)

       // segmentControl.layer.borderWidth = 1.0
       // segmentControl.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        

        tableView.register(CellForInstructionHeaderCell.self, forCellReuseIdentifier: "CellForInstructionHeaderCell")
        tableView.register(UINib(nibName: "CellForInstructionHeaderCell", bundle: nil), forCellReuseIdentifier: "CellForInstructionHeaderCell")

        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        m_employeedict=userArray[0]

        //Remove Extra space on tablview Content inset
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)

        
        //getPersonDetails()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getHealthPackagesFromServer()

    }
    

    
    
    let gradientLayer = CAGradientLayer()
//    override func viewDidLayoutSubviews() {
//         CATransaction.begin()
//         CATransaction.setDisableActions(true)
//         gradientLayer.frame = self.view.bounds
//         CATransaction.commit()
//       }

    
    
    @IBAction func segmentChanged(_ sender: Any) {
        
        self.tableView.reloadData()
        
    }
    

    
    @objc private func viewDetailsTapped(_ sender : UIButton) {
        
    }
    
    @objc private func packageIncludesTapped(_ sender : UITapGestureRecognizer) {
        
            let index = IndexPath(row: sender.view!.tag, section: sender.view!.tag)

        let vc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "HealthPackageIncludesVC") as! HealthPackageIncludesVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.testarray = packageArray[index.row - 1].testArray
        self.navigationController?.present(vc, animated: true, completion: nil)

    }
}


extension UITableView {
    func indexPathForView(view: UIView) -> IndexPath? {
            let originInTableView = self.convert(CGPoint.zero, from: (view))
            return self.indexPathForRow(at: originInTableView)
        }
}


//MARK:- TableView DataSource
extension HealthPackagesVC : UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        /*
        if segmentControl.selectedSegmentIndex == 0 {
            return PackageNames.count + 1
        }
        else {
            return PackageNames.count + 1
        }
        */
        
        return packageArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        if packageArray[section - 1].gender?.lowercased() == "male" {
            return maleArrayHC.count + 1
        }
        else {
            return femaleArrayHC.count + 1
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        // if indexPath.row != totalRows - 1 {
        
        // }
        //  return 60
        if indexPath.section == 0 {
        return UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension

        
        /*
        let secCount = tableView.numberOfSections
        if indexPath.section != secCount - 1 { //not last
            if indexPath.row == 0 {
                return 167
            }
            else {
                return 35
            }
        }
        else {
            return 60
            
        }
        */
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForInstructionHeaderCell", for: indexPath) as! CellForInstructionHeaderCell
            cell.lblHeaderName.text = "Health Check-up"
            cell.lblDescription.text = "a quick 60 minutes check-upto assess risk factors and warning signs"
            cell.imgView.image = UIImage(named:"HC top icon")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none

            return cell
        }
        else {
        
     
            if indexPath.row == 0 { // male price cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForHealthPackages", for: indexPath) as! CellForHealthPackages
                //shadowForCell(view: cell.backView)
                cell.viewPackageIncludes.tag = indexPath.section
                let gesture1 = UITapGestureRecognizer(target: self, action: #selector(packageIncludesTapped(_:)))
                cell.viewPackageIncludes.isUserInteractionEnabled=true
                cell.viewPackageIncludes.addGestureRecognizer(gesture1)
                
               // cell.lblPackName.text = PackageNames[indexPath.section - 1]
               // cell.lblAmount.text = "₹" + PackageAmount[indexPath.section - 1]

                cell.lblPackName.text = packageArray[indexPath.section - 1].PACKAGE_NAME
                cell.lblAmount.text = "₹" + (packageArray[indexPath.section - 1].PRICE ?? "")
                cell.lblGender.text = packageArray[indexPath.section - 1].gender

                if packageArray[indexPath.section - 1].gender == "Male" {
                    cell.lblGender.textColor = #colorLiteral(red: 0.231372549, green: 0.9294117647, blue: 1, alpha: 1)
                }
                else {
                    cell.lblGender.textColor = #colorLiteral(red: 0.7102946946, green: 0.3575393817, blue: 0.9889355964, alpha: 1)

                }
                
                cell.isUserInteractionEnabled = true
                return cell
            }
            else { //name cell
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForFlexPremium", for: indexPath) as! CellForFlexPremium
                cell.lblPremiumAmount.text = ""
             
                
                cell.lblRelation.text =  ""
                
               
                // designCardBox(view: cell.viewBox)
                //cell.lblRelation.font = UIFont(name: "HelveticaNeue-UltraLight",size: 20.0)
                cell.lblRelation.font = UIFont.systemFont(ofSize: 13.0)
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
               // if segmentControl.selectedSegmentIndex == 0 { //MALE
                    cell.lblRelation.text = hcDependantModelArray[indexPath.row - 1].Name
                
                if packageArray[indexPath.section - 1].gender?.lowercased() == "male" {
                    cell.lblRelation.text = maleArrayHC[indexPath.row - 1].Name
                    if maleArrayHC[indexPath.row - 1].IsSelected {


                        if packageArray[indexPath.section - 1].testArray.count > 0 {
                            if  maleArrayHC[indexPath.row - 1].PackageSrNo == packageArray[indexPath.section - 1].testArray[0].DIAG_PKG_LST_SR_NO {
                                cell.isUserInteractionEnabled = true
                                cell.imgView.image = UIImage(named: "hcChecked")
                            }
                            else {
                                cell.isUserInteractionEnabled = false
                                cell.imgView.image = UIImage(named: "disabled_checkbox")

                            }
                        }
                        else {
                            cell.isUserInteractionEnabled = false
                            cell.imgView.image = UIImage(named: "disabled_checkbox")
                        }

                    }
                    else {
                        cell.isUserInteractionEnabled = true
                        cell.imgView.image = UIImage(named: "hcCheckbox")

                    }
                }
                else {
                    cell.lblRelation.text = femaleArrayHC[indexPath.row - 1].Name
                    cell.imgView.image = UIImage(named: "hcCheckbox")
                    if femaleArrayHC[indexPath.row - 1].IsSelected {
                        
                        
                        if packageArray[indexPath.section - 1].testArray.count > 0 {
                            if  femaleArrayHC[indexPath.row - 1].PackageSrNo == packageArray[indexPath.section - 1].testArray[0].DIAG_PKG_LST_SR_NO {
                                cell.isUserInteractionEnabled = true
                                cell.imgView.image = UIImage(named: "hcChecked")
                            }
                            else {
                                cell.isUserInteractionEnabled = false
                                cell.imgView.image = UIImage(named: "disabled_checkbox")
                                
                            }
                        }
                        else {
                            cell.isUserInteractionEnabled = false
                            cell.imgView.image = UIImage(named: "disabled_checkbox")
                        }
                        
                    }
                    else {
                        cell.isUserInteractionEnabled = true
                        cell.imgView.image = UIImage(named: "hcCheckbox")

                    }
                }
                
                let rows = tableView.numberOfRows(inSection: indexPath.section)
                if indexPath.row == rows - 1 {
                    cell.bottomConstarint.constant = 12
                }
                else {
                    cell.bottomConstarint.constant = 2
                }
                
                var userId = 0
                /*
                if packageArray[indexPath.section - 1].gender?.lowercased() == "male" {
                    cell.lblRelation.text = maleArrayHC[indexPath.row - 1].Name
                    userId = Int(maleArrayHC[indexPath.row - 1].PersonSrNo!) ?? 0
                    if maleArrayHC[indexPath.row - 1].PackageSrNo != "" {
                        if maleArrayHC[indexPath.row - 1].PackageSrNo == packageArray[indexPath.section - 1].testArray[0].DIAG_PKG_LST_SR_NO {
                            cell.imgView.image = UIImage(named: "hcChecked")
                            cell.isUserInteractionEnabled = true
                        }
                        else {
                            cell.imgView.image = UIImage(named: "hcCheckbox")
                            cell.isUserInteractionEnabled = false
                        }
                    }
                    else {
                        cell.imgView.image = UIImage(named: "hcCheckbox")
                        cell.isUserInteractionEnabled = true
                    }
                }
                else { //Female
                    cell.lblRelation.text = femaleArrayHC[indexPath.row - 1].Name
                    userId = Int(femaleArrayHC[indexPath.row - 1].PersonSrNo!) ?? 0
                    
                    if femaleArrayHC[indexPath.row - 1].PackageSrNo != "" {
                        if femaleArrayHC[indexPath.row - 1].PackageSrNo == packageArray[indexPath.section - 1].testArray[0].DIAG_PKG_LST_SR_NO {
                            cell.imgView.image = UIImage(named: "hcChecked")
                            cell.isUserInteractionEnabled = true
                        }
                        else {
                            cell.imgView.image = UIImage(named: "hcCheckbox")
                            cell.isUserInteractionEnabled = false
                        }
                    }
                    else {
                        cell.imgView.image = UIImage(named: "hcCheckbox")
                        cell.isUserInteractionEnabled = true
                    }
                }
                */
                /*
                var packId  = ""
                if packageArray[indexPath.section - 1].testArray.count > 0 {
                    packId = packageArray[indexPath.section - 1].testArray[0].DIAG_PKG_LST_SR_NO ?? ""
                }
                    
                    let filtered = hpManagerArray.filter({$0.packId == packId && $0.userId == userId})
                    if filtered.count == 0 {//unchecked
                        cell.imgView.image = UIImage(named: "hcCheckbox")
                        let filteredSelected = hpManagerArray.filter({$0.userId == userId}) //enabledisable that name
                        if filteredSelected.count > 0 {
                            cell.isUserInteractionEnabled = false
                        }
                        else {cell.isUserInteractionEnabled = true
                        }
                    }
                    else {//checked
                        cell.imgView.image = UIImage(named: "hcChecked")
                        cell.isUserInteractionEnabled = true
                    }
                    
                  */
                return cell
            }
        }
       
    }
    
    
    
    /*
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             
             if indexPath.section == 0 {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "CellForInstructionHeaderCell", for: indexPath) as! CellForInstructionHeaderCell
                 cell.lblHeaderName.text = "Health Check-up"
                 cell.lblDescription.text = "a quick 60 minutes check-upto assess risk factors and warning signs"
                 cell.imgView.image = UIImage(named:"Asset 49")
                 cell.selectionStyle = UITableViewCell.SelectionStyle.none

                 return cell
             }
             else {
             
          
                 if indexPath.row == 0 { // male price cell
                     let cell = tableView.dequeueReusableCell(withIdentifier: "CellForHealthPackages", for: indexPath) as! CellForHealthPackages
                     //shadowForCell(view: cell.backView)
                     
                     let gesture1 = UITapGestureRecognizer(target: self, action: #selector(packageIncludesTapped(_:)))
                     cell.viewPackageIncludes.isUserInteractionEnabled=true
                     cell.viewPackageIncludes.addGestureRecognizer(gesture1)
                     
                     cell.lblPackName.text = PackageNames[indexPath.section - 1]
                     cell.lblAmount.text = "₹" + PackageAmount[indexPath.section - 1]
                     
     //                if segmentControl.selectedSegmentIndex == 0 {
     //                    cell.lblGender.text = "Male"
     //                }
     //                else {
     //                    cell.lblGender.text = "Female"
     //                }
                     
                     
                     cell.isUserInteractionEnabled = true
                     return cell
                 }
                 else { //name cell
                     
                     let cell = tableView.dequeueReusableCell(withIdentifier: "CellForFlexPremium", for: indexPath) as! CellForFlexPremium
                     cell.lblPremiumAmount.text = ""
                  
                     
                     cell.lblRelation.text =  ""
                     
                    
                     // designCardBox(view: cell.viewBox)
                     //cell.lblRelation.font = UIFont(name: "HelveticaNeue-UltraLight",size: 20.0)
                     cell.lblRelation.font = UIFont.systemFont(ofSize: 13.0)
                     
                     cell.selectionStyle = UITableViewCell.SelectionStyle.none
                     
                     if segmentControl.selectedSegmentIndex == 0 { //MALE
                         cell.lblRelation.text = maleArray[indexPath.row - 1].personName
                         
                         let userId = Int(maleArray[indexPath.row - 1].personSrNo)
                         let packId = HealthPackageId[indexPath.section - 1]
                         
                         let filtered = hpManagerArray.filter({$0.packId == packId && $0.userId == userId})
                         if filtered.count == 0 {
                             cell.imgView.image = UIImage(named: "unchecked")
                             let filteredSelected = hpManagerArray.filter({$0.userId == userId})
                             if filteredSelected.count > 0 {
                                 cell.isUserInteractionEnabled = false
                             }
                             else {cell.isUserInteractionEnabled = true
                             }
                             
                             
                         }
                         else {
                             cell.imgView.image = UIImage(named: "checked")
                             cell.isUserInteractionEnabled = true
                         }
                         
                         //check if user selected any packge
                         
                     }
                     else { //FEMALE
                         cell.lblRelation.text = femaleArray[indexPath.row - 1].personName
                         let userId = Int(femaleArray[indexPath.row - 1].personSrNo)
                         let packId = HealthPackageId[indexPath.section]
                         
                         let filtered = hpFemaleArray.filter({$0.packId == packId && $0.userId == userId})
                         if filtered.count == 0 {
                             cell.imgView.image = UIImage(named: "unchecked") //unchecked
                             
                             let filteredSelected = hpFemaleArray.filter({$0.userId == userId})
                             if filteredSelected.count > 0 {
                                 cell.isUserInteractionEnabled = false
                             }
                             else {cell.isUserInteractionEnabled = true
                             }

                         }
                         else {
                             cell.imgView.image = UIImage(named: "checked")
                             cell.isUserInteractionEnabled = true
                         }

                     }
                     return cell
                 }
             }
            
         }
     
     */
    //MARK:- Did Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            var packId  = ""
                if packageArray[indexPath.section - 1].testArray.count > 0 {
                packId = packageArray[indexPath.section - 1].testArray[0].DIAG_PKG_LST_SR_NO ?? ""
            }
            var userId = 0
            
            
            //for male
           // if segmentControl.selectedSegmentIndex == 0 {
            userId = Int(hcDependantModelArray[indexPath.row - 1].PersonSrNo!)!
                let filtered = hpManagerArray.filter({$0.packId == packId && $0.userId == userId})
                if filtered.count == 0 {
                    let obj = HealthPackage.init(packId: packId, userName: "", userId: userId)
                    self.hpManagerArray.append(obj)
                }
                else { //remove form array
                    self.hpManagerArray = hpManagerArray.filter ({$0.userId != userId || $0.packId != packId})
                   // self.tableView.reloadData()
                }
         //   }
//            else {
//                //for female
//                userId = Int(femaleArray[indexPath.row - 1].personSrNo)
//                let filtered = hpFemaleArray.filter({$0.packId == packId && $0.userId == userId})
//                if filtered.count == 0 {
//                    let obj = HealthPackage.init(packId: packId, userName: "", userId: userId)
//                    self.hpFemaleArray.append(obj)
//                }
//                else { //remove form array
//                    let array  = hpFemaleArray.filter ({$0.userId != userId || $0.packId != packId})
//                    self.hpFemaleArray = array
//
//                   // self.tableView.reloadData()
//                }
//
//            }
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                m_employeedict=userArray[0]
                
                var empSrNo = String()
                
                if let empsrno = m_employeedict?.empSrNo
                {
                    empSrNo=String(empsrno)
                }
                
                var personSr = ""
                var price = ""
                var packageSr = ""
                var isUserSelected = false
                if packageArray[indexPath.section - 1].gender?.lowercased() == "male" {
                    personSr = maleArrayHC[indexPath.row - 1].PersonSrNo ?? ""
                    isUserSelected = maleArrayHC[indexPath.row - 1].IsSelected
                }
                else {
                    personSr = femaleArrayHC[indexPath.row - 1].PersonSrNo ?? ""
                    isUserSelected = femaleArrayHC[indexPath.row - 1].IsSelected
                }
                
                if packageArray[indexPath.section - 1].testArray.count > 0 {
                    packageSr = packageArray[indexPath.section - 1].testArray[0].DIAG_PKG_LST_SR_NO!
                }
                price = packageArray[indexPath.section - 1].PRICE ?? ""

                if isUserSelected {
                    print("Remove")
                    let url = APIEngine.shared.removeHealthCheckup(EmpSrNo: empSrNo, PersonSrNo: personSr, Price: "0", PackageSrNo: packageSr)

                    print(url)
                    optHealthCheckupAPI(urlSec:url )
                    
                }
                else {
                    print("Add")
                    let url = APIEngine.shared.optHealthCheckup(EmpSrNo: empSrNo, PersonSrNo: personSr, Price: price, PackageSrNo: packageSr)
                    print(url)

                    optHealthCheckupAPI(urlSec:url)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func optTopup(url:String) {
        
    }
   
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
            //footerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                footerView.backgroundColor = UIColor.clear
            return footerView
            
            
            }

        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            if section != 0 {

            return 15
            }
            return 0
        }
    
        
    
    
    /*
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     //Sodexo Plans
     let totalRows = tableView.numberOfRows(inSection: indexPath.section)
     if indexPath.row != totalRows - 1 {
     let cell = tableView.dequeueReusableCell(withIdentifier: "CellForHealthPackages", for: indexPath) as! CellForHealthPackages
     shadowForCell(view: cell.backView)
     
     let gesture1 = UITapGestureRecognizer(target: self, action: #selector(packageIncludesTapped(_:)))
     cell.viewPackageIncludes.isUserInteractionEnabled=true
     cell.viewPackageIncludes.addGestureRecognizer(gesture1)
     
     if segmentControl.selectedSegmentIndex == 0 {
     cell.lblGender.text = "Male"
     }
     else {
     cell.lblGender.text = "Female"
     }
     
     if segmentControl.selectedSegmentIndex == 0 {
     for i in 0..<maleArray.count {
     switch i {
     case 1:
     cell.view1.isHidden = false
     cell.lbl1.text = maleArray[i].personName
     cell.ht1.constant = 30
     
     case 2:
     cell.view2.isHidden = false
     cell.lbl2.text = maleArray[i].personName
     cell.ht2.constant = 30
     
     case 3:
     cell.view3.isHidden = false
     cell.lbl3.text = maleArray[i].personName
     cell.ht3.constant = 30
     
     case 4:
     cell.view4.isHidden = false
     cell.lbl4.text = maleArray[i].personName
     cell.ht4.constant = 30
     
     
     
     default:
     break
     
     }
     }
     }
     else {
     for i in 0..<femaleArray.count {
     switch i {
     case 1:
     cell.view1.isHidden = false
     cell.lbl1.text = femaleArray[i].personName
     cell.ht1.constant = 30
     
     case 2:
     cell.view2.isHidden = false
     cell.lbl2.text = femaleArray[i].personName
     cell.ht2.constant = 30
     
     case 3:
     cell.view3.isHidden = false
     cell.lbl3.text = femaleArray[i].personName
     cell.ht3.constant = 30
     
     case 4:
     cell.view4.isHidden = false
     cell.lbl4.text = femaleArray[i].personName
     cell.ht4.constant = 30
     
     
     
     default:
     break
     
     }
     }
     }
     
     
     return cell
     }
     else {
     let cell = tableView.dequeueReusableCell(withIdentifier: "CellForBtnAddParentCell", for: indexPath) as! CellForBtnAddParentCell
     cell.btnAddParent.tag = indexPath.row
     cell.btnAddParent.addTarget(self, action: #selector(moveToNext(_:)), for: .touchUpInside)
     
     return cell
     }
     }
     */
    private func designCardBox(view:UIView) {
        //view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 2.0
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.layer.borderWidth = 1.0
    }
    
    
    @objc private func moveToNext(_ sender : UIButton) {
//        let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"DentalPackagesVC") as! DentalPackagesVC
//        self.navigationController?.pushViewController(flexIntroVC, animated: true)
    }
    
    
    
    @objc private func packageIncludes(_ sender : UITapGestureRecognizer) {
        guard let indexTapped = sender.view?.tag else { return  }
        
    }
    
    func animateTable() {

           tableView.reloadData()
               {   self.isLoaded = 1
               }

           let cells = tableView.visibleCells

           let tableHeight: CGFloat = tableView.bounds.size.height



           for i in cells {

               let cell: UITableViewCell = i as UITableViewCell

               if i.isKind(of: CellForInstructionHeaderCell.self) {
                             cell.transform = CGAffineTransform(translationX: 0, y: -tableHeight)

                         }
                         else{
                             cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)

                         }

           }

           

           var index = 0

           

           for a in cells {

               if a.isKind(of: CellForHealthPackages.self) {
               let cell: CellForHealthPackages = a as! CellForHealthPackages

               UIView.animate(withDuration: 2, delay: 0.4 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {

                   cell.transform = CGAffineTransform(translationX: 0, y: 0)

                   }, completion: nil)

               

               index += 1
               }
         
             else {
                   //CellForParentalPremium
                   let cell: CellForFlexPremium = a as! CellForFlexPremium

                   UIView.animate(withDuration: 1.5, delay: 0.4 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {

                       cell.transform = CGAffineTransform(translationX: 0, y: 0)

                       }, completion: nil)

                   

                   index += 1
                  
               }
               
           }//for

       }
}




extension HealthPackagesVC:UIScrollViewDelegate {
    // we set a variable to hold the contentOffSet before scroll view scrolls
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            if self.hideCollectionViewDelegate != nil {
                hideCollectionViewDelegate?.scrolled(index: 1)
            }
            
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            if self.hideCollectionViewDelegate != nil {
                hideCollectionViewDelegate?.show(index: 1)
            }
        } else {
            // didn't move
            if self.hideCollectionViewDelegate != nil {
                hideCollectionViewDelegate?.show(index: 1)
            }
            
        }
    }
    
  
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           scrollingFinished(scrollView: scrollView)
       }

       func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
           if decelerate {
               //didEndDecelerating will be called for sure
               return
           }
           else {
               scrollingFinished(scrollView: scrollView)
           }
       }

       func scrollingFinished(scrollView: UIScrollView) {
          // Your code
           if self.hideCollectionViewDelegate != nil {
               hideCollectionViewDelegate?.show(index: 1)
           }
       }
}
