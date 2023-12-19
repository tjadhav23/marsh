//
//  GHITopUpVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 25/01/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import QuartzCore

var GPATopUpArray = [TopUpOptions]()
var GTLTopUpArray = [TopUpOptions]()
var GHITopUpArray = [TopUpOptions]()

struct TopUpOptions {
    var baseAmount:String?
    var sumInsured:String?
    var premiumAmount:String?
    var policyName = ""
    var isOpted :String?
}

class GHITopUpVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var plansArray = [1000,5000,8000,10000,15000,25000]
    var siArray = ["3,00,000","5,00,000","10,00,000","15,00,000"]
    var premiumArray = ["10,487","11,208","19,276","21,162"]

    var relationArray = ["Father","Mother","Father-In-Law","Mother-In-Law"]
    var selectedGHIParentIndex = -1
  //  var selectedGPAPremium = 1
   // var selectedGTLPremium = 1
    
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    
    var hideCollectionViewDelegate : HideCollectionViewProtocol? = nil

    var lastContentOffset: CGFloat = 0 //ScrollViewDelegate
    var m_employeeDict : EMPLOYEE_INFORMATION?
    var countDownTime = ""
    var endDate : Date?
    var alertController: UIAlertController?
    var timer1 : Timer?
    var isDisabled : Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        print("#VDL-GHI")

        GHITopUpArray.removeAll()
        self.tableView.tableFooterView = UIView()
        
        self.navigationItem.title = "Select Top UP"
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        navigationController?.isNavigationBarHidden=false
        self.navigationItem.leftBarButtonItem=getBackButtonHideTabBar()

        //self.tableView.setBorderToView(color: UIColor.black)
        
        //shadowForCell(view: self.tableView)
        
        tableView.register(CellForInstructionHeaderCell.self, forCellReuseIdentifier: "CellForInstructionHeaderCell")
        tableView.register(UINib(nibName: "CellForInstructionHeaderCell", bundle: nil), forCellReuseIdentifier: "CellForInstructionHeaderCell")
        
        tableView.register(CellForTopupInsurance.self, forCellReuseIdentifier: "CellForTopupInsurance")
        tableView.register(UINib(nibName: "CellForTopupInsurance", bundle: nil), forCellReuseIdentifier: "CellForTopupInsurance")

        let startPoint = CGPoint(x:0.5, y:0.0)
        let endPoint = CGPoint(x:0.5, y:1.0)
        
       // self.view.setGradientBackgroundColor(colorTop: EnrollmentColor.gpaTop.value, colorBottom: EnrollmentColor.gpaBottom.value, startPoint: startPoint, endPoint: endPoint)

        setColorNew(view: self.view, colorTop: EnrollmentColor.ghiTop.value, colorBottom: EnrollmentColor.ghiBottom.value,gradientLayer:gradientLayer)

            // self.view.backgroundColor = EnrollmentColor.ghiTop.value

        //self.view.layer.contents = #imageLiteral(resourceName: "gmctopupbg").cgImage
        

        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if(userArray.count>0)
        {
            m_employeeDict=userArray[0]
        }
        
        let currentDate = getCurrentDate()
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        endDate = dateFormatter.date(from: GlobalendDate)
        
        if currentDate.compare(endDate!) == .orderedAscending {
        print("current date is small")
            isDisabled = false
            timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }else{
            print("current date is big")
            isDisabled = true
        }
        
        
        getPolicyDataFromDatabase()
    }
    
    private func getPolicyDataFromDatabase() {
        let policyData = DatabaseManager.sharedInstance.retrieveGroupBasicInfoDetails(productCode: "GMC")
        if policyData.count > 0 {
            print("OE GROUP BASE = \(policyData[0].oE_GRP_BAS_INF_SR_NO)")
        }
    }
    

        
    override func viewWillAppear(_ animated: Bool) {
        getGHITopUpOptionsFromServer()
        getWindowPeriodDetails()
       }
    
    @objc func updateCounter() {
        if !isDisabled{
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: endDate!)
            countDown(dateString)
        }
    }
    
    func countDown(_ endDate : String){
        
        if endDate != "" && timer1 != nil{
            var dateFormatter = DateFormatter()
            //var endDate = "31/12/2022"
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let EndDate = dateFormatter.date(from:endDate)!
            let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: EndDate)!
            let endDateComp = Calendar.current.dateComponents([.year, .month, .day], from: modifiedDate)
            //        let nextTriggerDate = Calendar.current.date(byAdding: .day, value: 1, to: EndDate)!
            //        let comps = Calendar.current.dateComponents([.year, .month, .day], from: nextTriggerDate)
            let nextBirthDate = Calendar.current.nextDate(after: Date(), matching: endDateComp, matchingPolicy: .nextTime)!
            
            let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: nextBirthDate)
            
            print(difference.day)     // 105
            print(difference.hour)    // 2
            print(difference.minute)  // 5
            print(difference.second)  // 30
            countDownTime = String(format: "%02d:%02d:%02d:%02d", difference.day!, difference.hour!,difference.minute!,difference.second!)//"\(difference.day!.description):\(difference.hour!.description):\(difference.minute!.description):\(difference.second!.description)"
            print("count time:\(countDownTime)")
            let index = IndexPath(row: 0, section: 0)
            
            if let cell = tableView.cellForRow(at: index) as? CellForInstructionHeaderCell{
                    cell.lblTimer.text = countDownTime
            }
            alertController?.message = countDownTime ?? ""//String(format: "%02d:%02d", minutes, seconds)
            
        }
    }
    
    func getWindowPeriodDetails(){
        let appendUrl = "getWindowPeriodDetails"
        
        webServices().getDataForEnrollment(appendUrl, completion: {(data,error) in
            if error == ""{
                do{
                    let json = try JSONDecoder().decode(WindowPeriodDetails.self, from: data)
                    print(json)
                    var endD = json.windowPeriod.windowEndDate_gmc
                    //self.endDate = endD
                    
                }catch{

                }
            }else{
                DispatchQueue.main.sync{
                    self.showAlertwithOk(message: error)
                }
            }
            
        })
    }
    
    func showAlert(){
        alertController = UIAlertController(title: "Timer ", message: "", preferredStyle: .alert)
        present(alertController!, animated: true){
            self.timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
            //self.timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
        let cancelAction = UIAlertAction(title: "DISMISS", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
            print("Cancel")
//            self.timer!.invalidate()
//            self.timer = nil
            self.timer1!.invalidate()
            self.timer1 = nil
        }
        alertController!.addAction(cancelAction)
    }
    
    
    
    @objc func TimerAct(sender: UIButton){
        let indexpath2 = IndexPath(row: sender.tag, section: 0)
        if !isDisabled{
            showAlert()
        }else{
            self.showAlert(message: "Window Period is expired.")
        }
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLayoutSubviews() {
         CATransaction.begin()
         CATransaction.setDisableActions(true)
         gradientLayer.frame = self.view.bounds
         CATransaction.commit()
       }
    
    var isLoaded = 0
  
    var sectionFirstLoaded = 0

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
          
    }
    

}
   extension GHITopUpVC:UITableViewDelegate,UITableViewDataSource {
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if GHITopUpArray.count > 0 {
        return GHITopUpArray.count + 1
        }
        return 0 
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
            if indexPath.row == 0 { //if cardView
                return 240//UITableViewAutomaticDimension
            }
        
      //  let totalRows = tableView.numberOfRows(inSection: indexPath.section)
      //  if indexPath.row != totalRows - 1 {

        //    return 55
       // }
        else {
//            return 100
                return UITableViewAutomaticDimension

        }
       
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
            if indexPath.row == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "InsuranceTypeCellFlex", for: indexPath) as! InsuranceTypeCellFlex
//                cell.lblInsuranceName.text = "Group Health Insurance"
//                //cell.lblInsuranceName.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//                cell.lblInsuranceName.layer.cornerRadius = 2.0
//                cell.lblSumInsuredAmount.text = "₹ 3,00,000"
//                cell.lblBottom.text = "Group Health Insurance Parental Inclusion"
//                designCard(view: cell.cardView)
//
//                cell.selectionStyle = UITableViewCell.SelectionStyle.none
//
//                return cell
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForInstructionHeaderCell", for: indexPath) as! CellForInstructionHeaderCell
                cell.lblHeaderName.text = "GMC Top-Up"
                cell.lblDescription.text = "your employer provides you with \n the following GMC Top-up options"
                cell.imgView.image = UIImage(named:"Asset 49")
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.btnTimer.tag = indexPath.row
                cell.btnTimer.addTarget(self, action: #selector(TimerAct), for: .touchUpInside)
                if !isDisabled{
                    cell.lblTimer.text = countDownTime
                }else{
                    cell.lblTimer.text = "Window Period is expired."
                }
                return cell

            }

               else { //Button Cell
                   let cell = tableView.dequeueReusableCell(withIdentifier: "CellForTopupInsurance", for: indexPath) as! CellForTopupInsurance
                   
                //cell.selectionStyle = UITableViewCell.SelectionStyle.default
                cell.lblOption.text = "Option " + String(indexPath.row)
                
                let amtText = GHITopUpArray[indexPath.row - 1].sumInsured ?? ""
               // cell.lblAmount.text =  getFormattedCurrency(amount: amtText)
                cell.lblAmount.text =  "₹ "+amtText

                
               // cell.lblAmount.text = "₹ " + (GHITopUpArray[indexPath.row - 1].sumInsured ?? "")
                
                let premiumAmtText = GHITopUpArray[indexPath.row - 1].premiumAmount ?? ""
                //cell.lblPremium.text = getFormattedCurrency(amount: premiumAmtText)
                cell.lblPremium.text = "Premium ₹ "+premiumAmtText
                   
                   if !isDisabled{
                       if GHITopUpArray[indexPath.row - 1].isOpted == "YES" {
                           selectedGHIParentIndex = indexPath.row
                           cell.imgCorrect.isHidden = false
                           cell.dotView.backgroundColor = #colorLiteral(red: 0.6930314302, green: 0.9565303922, blue: 0, alpha: 1)
                           cell.sideCutView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                           cell.backView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                       }
                       else {
                           cell.imgCorrect.isHidden = true
                           cell.dotView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                           cell.sideCutView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                           cell.backView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                           
                       }
                   }else{
                       cell.imgCorrect.isHidden = true
                       cell.dotView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                       cell.sideCutView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                       cell.backView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                   }
                
                cell.m_deleteButton.tag=indexPath.row
                cell.m_deleteButton.addTarget(self, action: #selector(deleteButtonClicked(_:)), for: .touchUpInside)


                  //Add Swipe Gesture
                  let leftRecognizer = UISwipeGestureRecognizer(target: self, action:
                      #selector(swipeMade(_:)))
                  leftRecognizer.direction = .left
                  let rightRecognizer = UISwipeGestureRecognizer(target: self, action:
                      #selector(swipeMade(_:)))
                rightRecognizer.direction = .right
                cell.backView.isUserInteractionEnabled = true
                
                cell.backView.tag = indexPath.row
                if let IsWindowPeriodOpen = UserDefaults.standard.value(forKey: "IsWindowPeriodOpen") as? String  {
                    if let IsEnrollmentSaved = UserDefaults.standard.value(forKey: "IsEnrollmentSaved") as? String  {
                        if IsWindowPeriodOpen == "1" && IsEnrollmentSaved == "0" {
                        //if IsWindowPeriodOpen == "0" && IsEnrollmentSaved == "0" {
                            cell.backView.addGestureRecognizer(leftRecognizer)
                            cell.backView.addGestureRecognizer(rightRecognizer)
                        }
                        else {
                        }
                    }
                    else {
                    }
                }
                else {}
                

                cell.lblDelete.isHidden = true
                cell.m_deleteButton.isHidden = true
                hideDeleteView(cell: cell)


                   return cell
               }

            }
       
            
        @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
              let index = IndexPath(row: sender.view!.tag, section: 1)
              
              guard let cell = tableView.cellForRow(at: index) as? CellForTopupInsurance else {
                  return
              }
              
              hideDeleteView(cell: cell)

          }
    //Shubham Uncomment after Api
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let totalRows = tableView.numberOfRows(inSection: indexPath.section)
            
            //if indexPath.row != 0 && indexPath.row != totalRows - 1 {
   //         isLoaded = 1
        
        guard let IsWindowPeriodOpen = UserDefaults.standard.value(forKey: "IsWindowPeriodOpen") as? String else {
                       return
                   }
        
        guard let IsEnrollmentSaved = UserDefaults.standard.value(forKey: "IsEnrollmentSaved") as? String else {
            return
        }
        
        if IsWindowPeriodOpen == "0" && IsEnrollmentSaved == "0" {
        if indexPath.row != 0 {
        //self.selectedGHIParentIndex = indexPath.row
            
            
            
            var empSrNo = ""
            if let empsrno = m_employeeDict?.empSrNo
                           {
                               empSrNo=String(empsrno)
                           }
            
            
            
            let summaryObj = summaryData.init(isHeader: false, firstText: "Health Insurance Top-Up", secondText: GHITopUpArray[indexPath.row - 1].sumInsured ?? "", isMultiline: false, tempExtra: GHITopUpArray[indexPath.row - 1].premiumAmount ?? "", isEmptyData: false)

            
            let dict = ["employeesrno":empSrNo,"benefit_si":GHITopUpArray[indexPath.row - 1].sumInsured,"benefit_amount":GHITopUpArray[indexPath.row - 1].premiumAmount,"benefit_amt_source":"1","mb_cust_prgs_bnft_sr_no":"2"]

            self.OptTopUpToServer(parameter: dict as NSDictionary, employeesrno: empSrNo, benefit_si: GHITopUpArray[indexPath.row - 1].sumInsured!, benefit_amount: GHITopUpArray[indexPath.row - 1].premiumAmount!, mb_cust_prgs_bnft_sr_no: "2", isAdd: true, setSummaryObj: summaryObj)
            
                    }
            
        }
        else {
         //show alert
        }
        
       
        
        
           // }
    }
    */
    
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("Selected Index: ",indexPath.row)
           
           if GHITopUpArray.count > 0{
               
               for i in 0...GHITopUpArray.count - 1{
                   GHITopUpArray[i].isOpted = "NO"
               }
               GHITopUpArray[indexPath.row - 1 ].isOpted = "YES"
               print("Inside didSelectRowAt: ",GHITopUpArray)
           }
           self.tableView.reloadData()
       }
       
       func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            print("DeSelected Index: ",indexPath.row)

           if GHITopUpArray.count > 0{
           GHITopUpArray[indexPath.row - 1 ].isOpted = "NO"
           self.tableView.reloadData()
           }
       }
       
    //MARK:- Currency Converter
       private func getFormattedCurrency(amount:String) -> String {
           
           if amount == "" {
               return ""
           }
           
           let myDouble = Double(amount)!
           let currencyFormatter = NumberFormatter()
           currencyFormatter.usesGroupingSeparator = true
           currencyFormatter.numberStyle = .currency
           currencyFormatter.currencySymbol = ""
           // localize to your grouping and decimal separator
           currencyFormatter.locale = Locale.current
           // We'll force unwrap with the !, if you've got defined data you may need more error checking
           var priceString = currencyFormatter.string(from: NSNumber(value: myDouble))!
           print(priceString)
           priceString = priceString.replacingOccurrences(of: ".00", with: "")
           priceString = priceString.replacingOccurrences(of: " ", with: "")

           let formatedString =  String(format: "₹ %@",priceString)
           
         //  let str = "₹ 3700"

           return formatedString.removeWhitespace()
       }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//         return .leastNormalMagnitude
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return .leastNormalMagnitude
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
                //layer.fillColor = UIColor.white.withAlphaComponent(0.8).cgColor
                layer.fillColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)

                if addLine {
                    let lineLayer: CALayer = CALayer()
                    let lineHeight: CGFloat = 1.0 / UIScreen.main.scale
                    lineLayer.frame = CGRect(x: bounds.minX + 10.0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
                    lineLayer.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                    layer.addSublayer(lineLayer)
                }

                let testView: UIView = UIView(frame: bounds)
                testView.layer.insertSublayer(layer, at: 0)
                testView.backgroundColor = UIColor.red
                cell.backgroundView = testView
            }
        }
    }
*/
    
    @objc private func nextTapped(_ sender : UIButton) {
        if self.selectedGHIParentIndex == -1 {
            self.showAlert(message: "Please Select Top UP")
        }
        else {
            let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"GPATopUpVC") as! GPATopUpVC
            flexIntroVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            flexIntroVC.m_windowPeriodEndDate=m_windowPeriodEndDate
            self.navigationController?.pushViewController(flexIntroVC, animated: true)
        }
    }
    @objc private func doNotTopUp(_ sender : UIButton) {
        
        let refreshAlert = UIAlertController(title: "Are you sure, you do not wish to opt this top-up?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Yes logic here")
          
                self.selectedGHIParentIndex = -2
           
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
    
    //MARK:- Set Footer View
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let vw = UIView()
            vw.backgroundColor = UIColor.clear
            //let titleLabel = UILabel(frame: CGRect(x:10,y: 5 ,width:350,height:150))
            return vw
       
        }

        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 60
            
        }
    
    //MARK:- TableView Animation
    func animateTable() {

        tableView.reloadData() {
            self.isLoaded = 1
        }

        let cells = tableView.visibleCells

        let tableHeight: CGFloat = tableView.bounds.size.height


        if sectionFirstLoaded == 0 {
            sectionFirstLoaded = 1
        for i in cells {

            let cell: UITableViewCell = i as UITableViewCell

            
            if i.isKind(of: CellForInstructionHeaderCell.self) {
                cell.transform = CGAffineTransform(translationX: 0, y: -tableHeight)

            }
            else{
                cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)

            }
            

        }
        }
        

        var index = 0

        

        for a in cells {

            if a.isKind(of: CellForTopupInsurance.self) {
            let cell: CellForTopupInsurance = a as! CellForTopupInsurance

            UIView.animate(withDuration: 2, delay: 0.4 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {

                cell.transform = CGAffineTransform(translationX: 0, y: 0)

                }, completion: nil)

            

            index += 1
            }
      
            else {
                //CellForParentalPremium
                let cell: CellForInstructionHeaderCell = a as! CellForInstructionHeaderCell

                UIView.animate(withDuration: 1.5, delay: 0.4 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {

                    cell.transform = CGAffineTransform(translationX: 0, y: 0)

                    }, completion: nil)

                

                index += 1
               
            }
            
        }//for

    }
}

//MARK:- SERVER CALL
extension GHITopUpVC {

    func OptTopUpToServer(parameter:NSDictionary,employeesrno:String,benefit_si:String,benefit_amount:String,mb_cust_prgs_bnft_sr_no:String,isAdd:Bool,setSummaryObj:summaryData) {
        
        if(isConnectedToNetWithAlert())
        {
                let url = APIEngine.shared.getOptRemoveTopUpJsonURL()
            
            
            
          //  let url = "http://www.mybenefits360.in/mb360api/api/EnrollmentDetails/OptRemoveTopupData?employeesrno=36464&benefit_si=500000&benefit_amount=24190&benefit_amt_source=1&mb_cust_prgs_bnft_sr_no=2"
            let urlStr = String(format: "%@?employeesrno=%@&benefit_si=%@&benefit_amount=%@&mb_cust_prgs_bnft_sr_no=%@&benefit_amt_source=1", url,employeesrno,benefit_si,benefit_amount,mb_cust_prgs_bnft_sr_no)
            
               // let urlreq = NSURL(string : urlStr)
                
                //self.showPleaseWait(msg: "")
                print(urlStr)
                
            let dict = ["":""]
            EnrollmentServerRequestManager.serverInstance.postDataToServer(url: urlStr, dictionary: dict as NSDictionary, view: self) { (data, error) in
                  
                    if error != nil
                    {
                        print("error ",error!)
                        //self.hidePleaseWait()
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        // self.hidePleaseWait()
                        
                        do {
                            print("GHITopUpVC")
                            print(data)
                            
                            if let statusDict = data?["message"].dictionary
                            {
                                if let status = statusDict["Status"]?.bool {
                                    if status == true {
                                        if isAdd {
                                        selectedGHI = setSummaryObj
                                        let msg = statusDict["Message"]?.string
                                        //self.displayActivityAlert(title: "Top-up updated successfully" )
                                        self.getGHITopUpOptionsFromServer()
                                        }
                                        else {
                                            self.selectedGHIParentIndex = -1
                                            selectedGHI.isEmptyData = true
                                            self.getGHITopUpOptionsFromServer()
                                        }
                                    }
                                    else {
                                        //let msg = statusDict["Message"]?.string
                                        self.displayActivityAlert(title: m_errorMsg)
                                    }
                                }
                            }
                            
                        }//do
                            
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
        
    }
}
    
    //MARK:- GHI TopUp
    func getGHITopUpOptionsFromServer()
    {
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if(userArray.count>0)
        {
            m_employeeDict=userArray[0]
        }
        
        
        if(isConnectedToNetWithAlert())
        {
            
            if(userArray.count>0)
            {
                
                
                var oe_group_base_Info_Sr_No = String()
                var groupChildSrNo = String()
                var empSrNo = String()
                var empIDNo = String()
                
                if let empNo = m_employeeDict?.oe_group_base_Info_Sr_No
                {
                    oe_group_base_Info_Sr_No = String(empNo)
                }
                if let groupChlNo = m_employeeDict?.groupChildSrNo
                {
                    groupChildSrNo=String(groupChlNo)
                }
                if let empsrno = m_employeeDict?.empSrNo
                {
                    empSrNo=String(empsrno)
                }
                if let empidno = m_employeeDict?.empIDNo
                {
                    empIDNo=String(empidno)
                }
                
                
                
                let url = APIEngine.shared.getNewTopUpOptionsJsonURL(grpchildsrno: groupChildSrNo, oegrpbasinfosrno:oe_group_base_Info_Sr_No , employeesrno: empSrNo, empIdenetificationNo: empIDNo)
                
                let urlreq = NSURL(string : url)
                
                //self.showPleaseWait(msg: "")
                print(url)
                
                    let dict = ["":""]

                    EnrollmentServerRequestManager.serverInstance.postDictionaryDataToServer(url: url, dictionary: dict as NSDictionary, view: self) { (data, error) in

                        
                    if error != nil
                    {
                        print("error ",error!)
                        //self.hidePleaseWait()
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        // self.hidePleaseWait()
                        print("found Admin Setting....")
                        
                        do {
                            print("Started parsing Top Up...")
                            print(data)
                            
                            if let jsonResult = data as? NSDictionary
                            {
                                print("Admin Data Found")
                                if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
                                    if let status = msgDict.value(forKey: "Status") as? Bool {
                                        
                                        if status == true
                                        {
                                            print("Json Result data : ",jsonResult)
                                            
                                            
                                            if let IsEnrollmentSaved = jsonResult.value(forKey: "IsEnrollmentSaved") as? Int {
                                                UserDefaults.standard.set(String(IsEnrollmentSaved), forKey: "IsEnrollmentSaved")
                                            }
                                            
                                            if let IsWindowPeriodOpen = jsonResult.value(forKey: "IsWindowPeriodOpen") as? Int {
                                                UserDefaults.standard.set(String(IsWindowPeriodOpen), forKey: "IsWindowPeriodOpen")
                                            }
                                            
                                            if let ExtGroupSrNo = jsonResult.value(forKey: "ExtGroupSrNo") as? Int {
                                                UserDefaults.standard.set(String(ExtGroupSrNo), forKey: "ExtGroupSrNoEnrollment")
                                            }
                                            
                                            //SumInsuredData
                                            if let tempDict = jsonResult.value(forKey: "SumInsuredData") as? NSDictionary {
                                            if let dictMainTopUp = tempDict.value(forKey: "Enroll_Topup_Options") as? NSDictionary {
                                                
                                                GHITopUpArray.removeAll()
                                                GTLTopUpArray.removeAll()
                                                GPATopUpArray.removeAll()
                                                
                                                var gmcTopUp = false
                                                var gpaTopUp = false
                                                var gtlTopUp = false
                                                
                                                UserDefaults.standard.set(false, forKey:"gmcPolicy")
                                                UserDefaults.standard.set(false, forKey:"gpaPolicy")
                                                UserDefaults.standard.set(false, forKey:"gtlPolicy")

                                                
                                                if let topUpApplicabilityDict = dictMainTopUp.value(forKey: "TopupApplicability_data") as? NSDictionary {
                                                    if let gmc = topUpApplicabilityDict.value(forKey: "GMCTopup") as? String {
                                                        if gmc == "YES" {
                                                            gmcTopUp = true
                                                            UserDefaults.standard.set(true, forKey:"gmcPolicy")

                                                        }
                                                    }
                                                    
                                                    if let gpa = topUpApplicabilityDict.value(forKey: "GPATopup") as? String {
                                                        if gpa == "YES" {
                                                            gpaTopUp = true
                                                            UserDefaults.standard.set(true, forKey:"gpaPolicy")

                                                        }
                                                    }
                                                    
                                                    if let gtl = topUpApplicabilityDict.value(forKey: "GTLTopup") as? String {
                                                        if gtl == "YES" {
                                                            gtlTopUp = true
                                                            UserDefaults.standard.set(true, forKey:"gtlPolicy")

                                                        }
                                                    }
                                                    
                                                }
                                                
                                                
                                                if let topUPEnrollDict = dictMainTopUp.value(forKey: "TopupSumInsured_Cls_data") as? NSDictionary {
                                                    if gmcTopUp == true {
                                                        if let gmcTopUpArray = topUPEnrollDict.value(forKey: "GMCTopupOptions_data") as? [NSDictionary] {
                                                            for gmcOuter in gmcTopUpArray {
                                                                let baseGmc = gmcOuter.value(forKey: "BASE_SI") as? String
                                                                print("BASE_SI====\(baseGmc)")
                                                                UserDefaults.standard.set(baseGmc, forKey: "baseGmc")
                                                                let obj = TopUpOptions.init(baseAmount: baseGmc, sumInsured: "", premiumAmount: "", policyName: "Group Health Insurance")
                                                                //self.AllTopUpArray.append(obj)
                                                                
                                                                if let topUpGMCArray = gmcOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                                {
                                                                    DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GMC")
                                                                    for topUpObjDict in topUpGMCArray {
                                                                        let userDict = ["productCode":"GMC","BaseSumInsured":baseGmc,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                        
                                                                        let objGmc = TopUpOptions.init(baseAmount: baseGmc, sumInsured: topUpObjDict.value(forKey: "TSumInsured") as! String, premiumAmount: topUpObjDict.value(forKey: "TSumInsured_Premium") as! String,isOpted:topUpObjDict.value(forKey: "Opted") as! String)
                                                                        GHITopUpArray.append(objGmc)
                                                                        DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict as NSDictionary)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    if gpaTopUp == true {
                                                        if let gpaTopUpArray = topUPEnrollDict.value(forKey: "GPATopupOptions_data") as? [NSDictionary] {
                                                            for gpaOuter in gpaTopUpArray {
                                                                let baseGpa = gpaOuter.value(forKey: "BASE_SI") as? String
                                                                print("BASE_SI====\(baseGpa)")
                                                                
                                                                //let obj = TopUpOptions.init(baseAmount: baseGpa, sumInsured: "", premiumAmount: "", policyName: "Group Personal Accident")
                                                                //self.AllTopUpArray.append(obj)
                                                                
                                                                if let topUpGPAArray = gpaOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                                {
                                                                    DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GPA")
                                                                    
                                                                    for topUpObjDict in topUpGPAArray {
                                                                        let userDict1 = ["productCode":"GPA","BaseSumInsured":baseGpa,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                        
                                                                        let objGpa = TopUpOptions.init(baseAmount: baseGpa, sumInsured: topUpObjDict.value(forKey: "TSumInsured") as! String, premiumAmount: topUpObjDict.value(forKey: "TSumInsured_Premium") as! String,isOpted:topUpObjDict.value(forKey: "Opted") as! String)

                                                                        GPATopUpArray.append(objGpa)
                                                                        DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict1 as NSDictionary)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    
                                                    if gtlTopUp == true {
                                                        if let gtlTopUpArray = topUPEnrollDict.value(forKey: "GTLTopupOptions_data") as? [NSDictionary] {
                                                            for gtlOuter in gtlTopUpArray {
                                                                let baseGtl = gtlOuter.value(forKey: "BASE_SI") as? String
                                                                print("BASE_SI====\(baseGtl)")
                                                                let obj = TopUpOptions.init(baseAmount: baseGtl, sumInsured: "", premiumAmount: "", policyName: "Group Term Life")
                                                                //self.AllTopUpArray.append(obj)
                                                                if let topUpGTLArray = gtlOuter.value(forKey: "TopSumInsureds_values") as? [NSDictionary]
                                                                {
                                                                    DatabaseManager.sharedInstance.deleteTopupDetails(productCode: "GTL")
                                                                    for topUpObjDict in topUpGTLArray {
                                                                        let userDict2 = ["productCode":"GTL","BaseSumInsured":baseGtl,"TSumInsured":topUpObjDict.value(forKey: "TSumInsured"),"TSumInsuredPremium":topUpObjDict.value(forKey: "TSumInsured_Premium")]
                                                                        DatabaseManager.sharedInstance.saveTopupDetails(detailsDict: userDict2 as NSDictionary)
                                                                        
                                                                        let objGtl = TopUpOptions.init(baseAmount: baseGtl, sumInsured: topUpObjDict.value(forKey: "TSumInsured") as! String, premiumAmount: topUpObjDict.value(forKey: "TSumInsured_Premium") as! String,isOpted:topUpObjDict.value(forKey: "Opted") as! String)

                                                                        GTLTopUpArray.append(objGtl)
                                                                        
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }//topUPEnrollDict
                                            }
                                                if self.isLoaded == 0 {
                                                    self.animateTable()

                                                }
                                                else {
                                                    self.tableView.reloadData()
                                                }

                                           // let indexset = IndexSet(integer: 1)
                                            }
                                            //self.tableView.reloadSections([1], with: .none)
                                        }
                                        else {
                                            //No Data found
                                        }
                                    }//status
                                }//msgDict
                            }//jsonResult
                        }//do
                            
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
            }//userArray
        }
        
    }
}


extension GHITopUpVC:UIScrollViewDelegate {

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
}

//DELETE WORKING OLD EXTENSION SWIPE TO DELETE RED View
/*
extension GHITopUpVC { //Swipe To Delete
 
     //SWIPE To DELETE
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if selectedGHIParentIndex == indexPath.row {
            return true
        }
        return false
     
    }

     
     //MARK:- Delete Button Code
     //Delete Start
     
     @available(iOS 11.0, *)
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
     let action =  UIContextualAction(style: .normal, title: "Remove Top-Up", handler: { (action,view,completionHandler ) in
     //do stuff
     completionHandler(true)
     print("Delete...")
    
        
        self.deleteTopUp()
     
     })
     
     //action.image = UIImage(named: "deletew")
     action.backgroundColor = .red
        
     let confrigation = UISwipeActionsConfiguration(actions: [action])
     return confrigation
     
      }
     
    private func deleteTopUp() {

        let alert = UIAlertController(title: "", message: "Would you like to remove selected Top Up?", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Remove", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
             self.selectedGHIParentIndex = -1
             self.tableView.reloadData()
          
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

     
     func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
         self.tableView.subviews.forEach { subview in
             print("YourTableViewController: \(String(describing: type(of: subview)))")
             
             if (String(describing: type(of: subview)) == "UISwipeActionPullView") {
                 if (String(describing: type(of: subview.subviews[0])) == "UISwipeActionStandardButton") {
                     var deleteBtnFrame = subview.subviews[0].frame
                     deleteBtnFrame.origin.y = 0
                     deleteBtnFrame.size.height = 110
                     // deleteBtnFrame.size.width = 200
                     
                     subview.subviews[0].backgroundColor = UIColor.red
                     
                     // Subview in this case is the whole edit View
                     subview.frame.origin.y =  subview.frame.origin.y + 0
                     subview.frame.size.height = 110
                     subview.subviews[0].frame = deleteBtnFrame
                     subview.backgroundColor = UIColor.red
                 }
             }
         }
     }
     
    //Delete End
 
}
*/

//Swipe Delete CRED View
extension GHITopUpVC {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if selectedGHIParentIndex == indexPath.row {
            return true
        }
        return false
     
    }
    
    //MARK:- Hide Delete
       func hideDeleteView(cell:CellForTopupInsurance) {
           let transitionNew = CGAffineTransform(translationX: 0, y: 0 )
           UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
               
               cell.backView.transform = transitionNew
               cell.m_deleteButton.isHidden = true
               cell.lblDelete.isHidden = true

           }, completion: {
               (value: Bool) in

           })
           
       }
    
    //MARK:- Gesture Control - Add
    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
        if !isDisabled{
            print("Swipe made..")
            let index = IndexPath(row: sender.view!.tag, section: 0)
            
            //Shubham added for testing
            selectedGHIParentIndex = index.row
            
            if selectedGHIParentIndex == index.row {
                
                if sender.direction == .left {
                    print("left.. For Delete")
                    self.tableView.reloadData()
                    
                    
                    guard let cell = tableView.cellForRow(at: index) as? CellForTopupInsurance else {
                        return
                    }
                    
                    //cell.m_backGroundView.backgroundColor = UIColor.red
                    
                    let transitionNew = CGAffineTransform(translationX: -100, y: 0 )
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                        
                        cell.backView.transform = transitionNew
                        
                    }, completion: {
                        (value: Bool) in
                        cell.m_deleteButton.isHidden = false
                        cell.lblDelete.isHidden = false
                    })
                }
                else { //Reset
                    print("Right.. cancel Delete")
                    
                    guard let cell = tableView.cellForRow(at: index) as? CellForTopupInsurance else {
                        return
                    }
                    
                    //cell.m_backGroundView.backgroundColor = UIColor.red
                    
                    let transitionNew = CGAffineTransform(translationX: 0, y: 0 )
                    cell.backView.transform = transitionNew
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                        //Reset view
                        //let reset = CGAffineTransform(translationX: 0, y: 0)
                        //self.imgBox.transform = reset
                        
                    }, completion: {
                        (value: Bool) in
                        cell.m_deleteButton.isHidden = true
                        cell.lblDelete.isHidden = true
                        
                    })
                }
            }
        }
    }
    
    //MARK:- Delete Tapped...
       @objc func deleteButtonClicked(_ sender: UIButton) {
           if !isDisabled{
               print("Delete Dependant...\(sender.tag)")
               
               let indexPath = IndexPath(row: sender.tag, section: 0)
               self.deleteTopUp(indexPath: indexPath)
               
           }
       }
    
    private func deleteTopUp(indexPath: IndexPath) {

        let alert = UIAlertController(title: "", message: "Would you like to remove selected Top Up?", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Remove", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
            
            var empSrNo = ""
            if let empsrno = self.m_employeeDict?.empSrNo
            {
                empSrNo=String(empsrno)
            }
            
            let dict = ["employeesrno":empSrNo,"benefit_si":"0","benefit_amount":"0","benefit_amt_source":"1","mb_cust_prgs_bnft_sr_no":"2"]
            
            let summaryObj = summaryData()
            self.OptTopUpToServer(parameter: dict as NSDictionary, employeesrno: empSrNo, benefit_si: "0", benefit_amount: "0", mb_cust_prgs_bnft_sr_no: "2", isAdd: false, setSummaryObj: summaryObj)
            
            
            
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
            guard let cell = self.tableView.cellForRow(at: indexPath) as? CellForTopupInsurance else {
                return
            }
            self.hideDeleteView(cell: cell)

        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

    
}
