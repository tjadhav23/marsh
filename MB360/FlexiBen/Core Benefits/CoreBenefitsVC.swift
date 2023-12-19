//
//  CoreBenefitsVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 17/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

var selectedPlanIndex = 1
class CoreBenefitsVC: UIViewController,SodexoPlansCollectionViewProtocol {
    
    
    func planChangeTapped(index:Int) {
        print("Sodexo Plan Changed......\(index)")
        selectedPlanIndex = index
        // self.tableView.reloadData()
        
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var plansArray = [1000,5000,8000,10000,15000,25000]
    var relationArray = ["Father","Mother","Father-In-Law","Mother-In-Law"]
    var selectedGHIParentIndex = 1
    var selectedGPAPremium = 1
    var selectedGTLPremium = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Core Benefits"
        
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        navigationController?.isNavigationBarHidden=false
        self.navigationItem.leftBarButtonItem=getBackButton()
        
        
    }
    
    
}

extension CoreBenefitsVC:UITableViewDelegate,UITableViewDataSource {
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1 + relationArray.count //GHI
        }
        else {
            return 1 + 3 //GPA/GTL
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { //Sodexo Cell
            //return 120
            return 0
        }
        else if indexPath.section == 1 { //GHI
            if indexPath.row == 0 { //if cardView
                return UITableViewAutomaticDimension
            }
            return 45
        }
        else { //GPA
            if indexPath.row == 0 { //if cardView
                return UITableViewAutomaticDimension
            }
            return 45
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Sodexo Plans
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SodexoPlansTableViewCell", for: indexPath) as! SodexoPlansTableViewCell
            cell.sodexoCollectionViewdDelegate = self
            cell.plansArray = self.plansArray
            return cell
        }
        else if indexPath.section == 1 { //GHI
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InsuranceTypeCellFlex", for: indexPath) as! InsuranceTypeCellFlex
                cell.lblInsuranceName.text = "Group Health Insurance"
                //cell.lblInsuranceName.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                cell.lblInsuranceName.layer.cornerRadius = 2.0
                cell.lblSumInsuredAmount.text = "₹ 65000"
                cell.lblBottom.text = "Group Health Insurance Parental Inclusion"
                designCard(view: cell.cardView)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForFlexPremium", for: indexPath) as! CellForFlexPremium
                cell.lblRelation.text = relationArray[indexPath.row - 1]
                designCardBox(view: cell.viewBox)
                
                cell.lblPremiumAmount.text = "₹ 25000"
                
                if #available(iOS 13.0, *) {
                    cell.imgView.image = UIImage(systemName: "plus")
                } else {
                    // Fallback on earlier versions
                    cell.imgView.image = UIImage(named: "add")
                    
                }
                
                return cell
            }
        }
            //GPA
        else if indexPath.section == 2 { //GPA
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InsuranceTypeCellFlex", for: indexPath) as! InsuranceTypeCellFlex
                cell.lblInsuranceName.text = "Group Personal Accident (Employee Cover)"
                //cell.lblInsuranceName.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                cell.lblInsuranceName.layer.cornerRadius = 2.0
                designCard(view: cell.cardView)
                
                cell.lblSumInsuredAmount.text = "₹ 21,24,125"
                cell.lblBottom.text = "Group Personal Accident (Employee Top-up Cover)"
                
                return cell
            }
            else {
                
                let totalRows = tableView.numberOfRows(inSection: indexPath.section)
                if indexPath.row != totalRows - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CellForFlexPremium", for: indexPath) as! CellForFlexPremium
                    cell.lblRelation.text = "₹ 50,000"
                    cell.lblPremiumAmount.text = "₹ 1,151"
                    
                    if indexPath.row != selectedGPAPremium {
                        cell.imgView.image = UIImage(named: "checkbox")
                    }
                    else {
                        cell.imgView.image = UIImage(named: "checked")
                        
                    }
                    
                    designCardBox(view: cell.viewBox)
                    //cell.lblRelation.font = UIFont(name: "HelveticaNeue-UltraLight",size: 20.0)
                    cell.lblRelation.font = UIFont.systemFont(ofSize: 13.0)
                    
                    
                    return cell
                    
                }
                else { //Button Cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CellForNoTopup", for: indexPath) as! CellForNoTopup
                    
                    cell.btnDoNotTopUp.tag = 2
                    cell.btnDoNotTopUp.addTarget(self, action: #selector(doNotTopUp(_:)), for: .touchUpInside)

                    return cell
                }
                
                
            }
        }
            //GTL
        else  { //GTL
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InsuranceTypeCellFlex", for: indexPath) as! InsuranceTypeCellFlex
                cell.lblInsuranceName.text = "Group Term Life (Employee Cover)"
                //cell.lblInsuranceName.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                cell.lblInsuranceName.layer.cornerRadius = 2.0
                designCard(view: cell.cardView)
                cell.lblSumInsuredAmount.text = "₹ 20,00,000"
                cell.lblBottom.text = "Group Term Life with Critical Illness Rider (Employee Top-up Cover)"
                
                return cell
            }
            else {
                
                let totalRows = tableView.numberOfRows(inSection: indexPath.section)
                
                if indexPath.row != totalRows - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CellForFlexPremium", for: indexPath) as! CellForFlexPremium
                    cell.lblRelation.text = "₹ 25,00,000"
                    cell.lblPremiumAmount.text = "₹ 4,096"
                    
                    if indexPath.row != selectedGTLPremium {
                        cell.imgView.image = UIImage(named: "checkbox")
                    }
                    else {
                        cell.imgView.image = UIImage(named: "checked")
                    }
                    designCardBox(view: cell.viewBox)
                    cell.lblRelation.font = UIFont.systemFont(ofSize: 13.0)
                    
                    return cell
                    
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CellForNoTopup", for: indexPath) as! CellForNoTopup
                    cell.btnDoNotTopUp.tag = 3
                    cell.btnDoNotTopUp.addTarget(self, action: #selector(doNotTopUp(_:)), for: .touchUpInside)
                    
                    
                    return cell
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section
        {
        case 1:
            print("GHI")
            print(indexPath)
            
            self.selectedGHIParentIndex = indexPath.row
            
        case 2:
            print("GPA")
            
            print(indexPath)
            
            self.selectedGPAPremium = indexPath.row
            
        case 3:
            print("GTL")
            
            print(indexPath)
            
            self.selectedGTLPremium = indexPath.row
            
        default:
            break
        }
        self.tableView.reloadData()
    }
    @objc private func doNotTopUp(_ sender : UIButton) {
        
        let refreshAlert = UIAlertController(title: "Are you sure, you do not wish to opt this top-up?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Yes logic here")
            if sender.tag == 2 {
                self.selectedGPAPremium = -1
            }
            else {
                self.selectedGTLPremium = -1
            }
            self.tableView.reloadData()
        }))
        
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    private func designCard(view:UIView) { //Sum insured blue card
        //view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 6.0
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.layer.borderWidth = 1.0
        // view.setGradientBackground1(colorTop: hexStringToUIColor(hex: "0171d5"), colorBottom:hexStringToUIColor(hex: "5eb1fd"))
        
    }
    
    private func designCardBox(view:UIView) {
        //view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 2.0
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.layer.borderWidth = 1.0
    }
    
    
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 50
    //    }
    /*
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     
     if (cell.responds(to: #selector(getter: UIView.tintColor))){
     if tableView == self.tableView {
     let cornerRadius: CGFloat = 12.0
     cell.backgroundColor = .clear
     let layer: CAShapeLayer = CAShapeLayer()
     let path: CGMutablePath = CGMutablePath()
     let bounds: CGRect = cell.bounds
     bounds.insetBy(dx: 25.0, dy: 0.0)
     var addLine: Bool = false
     
     if indexPath.row == 0 && indexPath.row == ( tableView.numberOfRows(inSection: indexPath.section) - 1) {
     path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
     
     } else if indexPath.row == 0 {
     path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
     path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
     path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
     path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
     
     } else if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
     path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
     path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
     path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
     path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
     
     } else {
     path.addRect(bounds)
     addLine = true
     }
     
     layer.path = path
     layer.fillColor = UIColor.white.withAlphaComponent(0.8).cgColor
     
     if addLine {
     let lineLayer: CALayer = CALayer()
     let lineHeight: CGFloat = 1.0 / UIScreen.main.scale
     lineLayer.frame = CGRect(x: bounds.minX + 10.0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
     lineLayer.backgroundColor = tableView.separatorColor?.cgColor
     layer.addSublayer(lineLayer)
     }
     
     let testView: UIView = UIView(frame: bounds)
     testView.layer.insertSublayer(layer, at: 0)
     testView.backgroundColor = .clear
     cell.backgroundView = testView
     }
     }
     }
     */
    
}


class TempCell: UITableViewCell {
    @IBOutlet weak var innerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.innerView.layer.cornerRadius = 10.0
        
        
    }
}
