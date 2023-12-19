//
//  CoveragesInfoVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 14/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class CoveragesInfoVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgTimer: UIImageView!
    
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var vewTimer: UIView!
    var nameArray = ["Group Health Insurance","Group Personal Accident","Group Term Life"]
    var amountArray = ["₹ 5,00,000","₹ 1,31,66,730","₹ 61,95,938"]
    var AllTopUpArray = [TopUpOptions]()
    var myCoveragesArray = [Coverage]()
    
    var lastContentOffset: CGFloat = 0 //ScrollViewDelegate
    var hideCollectionViewDelegate : HideCollectionViewProtocol? = nil
    
    //For Animation willDisplay
    var shownIndexes : [IndexPath] = []
    let CELL_HEIGHT : CGFloat = 40
    var m_employeeDict : EMPLOYEE_INFORMATION?
    var isLoaded = 0
    var countDownTime = ""
    var countDownTimeGpa = ""
    var countDownTimeGtl = ""
    var endDate : Date?
    var endDateGPA : Date?
    var endDateGTL : Date?
    var alertController: UIAlertController?
    var timer1 : Timer?
    var timer2 : Timer?
    var timer3 : Timer?
    var isDisabled : Bool = false
    var isDisabledGpa : Bool = false
    var isDisabledGtl : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
        {
            self.tableView.isScrollEnabled = true
        }
        else {
            self.tableView.isScrollEnabled = false
        }
        
        //Add New Dependants Cell
        tableView.register(CellForInstructionHeaderCell.self, forCellReuseIdentifier: "CellForInstructionHeaderCell")
        tableView.register(UINib(nibName: "CellForInstructionHeaderCell", bundle: nil), forCellReuseIdentifier: "CellForInstructionHeaderCell")
        
        tableView.register(CellForCoverageInfo.self, forCellReuseIdentifier: "CellForCoverageInfo")
        tableView.register(UINib(nibName: "CellForCoverageInfo", bundle: nil), forCellReuseIdentifier: "CellForCoverageInfo")
        
        let startPoint = CGPoint(x:0.5, y:0.0)
        let endPoint = CGPoint(x:0.5, y:1.0)
        
        // self.view.setGradient(colorTop: EnrollmentColor.coveragesTop.value, colorBottom: EnrollmentColor.coveragesBottom.value, startPoint: startPoint, endPoint: endPoint, gradientLayer: gradientLayer)
        
        setColorNew(view: self.view, colorTop: EnrollmentColor.empDetailsTop.value, colorBottom: EnrollmentColor.empDetailsBottom.value,gradientLayer:gradientLayer)
        setImgTintColor(imgTimer, color: UIColor.white)
        //vewTimer.alpha = 0
        
        let currentDate = getCurrentDate()
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        endDate = dateFormatter.date(from: GlobalendDate)
        endDateGPA = dateFormatter.date(from: GlobalGPAendDate)
        endDateGTL = dateFormatter.date(from: GlobalGTLendDate)
        
        if currentDate.compare(endDate!) == .orderedAscending {
        print("current date is small")
            isDisabled = false
            timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }else{
            print("current date is big")
            isDisabled = true
        }
        
        if currentDate.compare(endDateGPA!) == .orderedAscending {
        print("current date is small")
            isDisabledGpa = false
            timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounterGpa), userInfo: nil, repeats: true)
        }else{
            print("current date is big")
            isDisabledGpa = true
        }
        if currentDate.compare(endDateGTL!) == .orderedAscending {
        print("current date is small")
            isDisabledGtl = false
            timer3 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounterGtl), userInfo: nil, repeats: true)
        }else{
            print("current date is big")
            isDisabledGtl = true
        }
        
       
        
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //          UIView.transition(with: tableView,
        //          duration: 0.35,
        //          options: .transitionCrossDissolve,
        //          animations: { self.tableView.reloadData() })
        //self.view.myCustomAnimation()
        //getGHITopUpOptionsFromServer()
        //fetchJsonDataFromCoverages()
        getDataForMyCoverages()
        getWindowPeriodDetails()

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
    
    
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = self.view.bounds
        CATransaction.commit()
    }
    
    var animationsQueue = ChainedAnimationsQueue()
    
    var sectionFirstLoaded = 0
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if isLoaded == 0 {
            cell.alpha = 0.0
            animationsQueue.queue(withDuration: 0.4, initializations: {
                cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, cell.frame.size.width, 0, 0)
            }, animations: {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            })
            }
        }
        else {
    if sectionFirstLoaded == 0 {

            cell.alpha = 0.0
            animationsQueue.queue(withDuration: 0.4, initializations: {
                cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -cell.frame.size.width, 0, 0)
            }, animations: {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            })
            
        }
        sectionFirstLoaded = 1
        }
    }
    
}


//MARK:- TableView Delegate & Datasource
extension CoveragesInfoVC {
    
    
    
    @objc func addToButton(sender: UIButton){
        
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        //self.showAlert(message: "Data \(indexpath1.row)")
        
        var data = self.myCoveragesArray[indexpath1.row]
        
        var empContribution = data.to_show_employee_contribution
        var companyContribution = data.to_show_employer_contribution
        
        if empContribution == "1" && companyContribution == "1"{
            self.showAlert(message: "Premium Contribution \nEmployee Contribution: \(data.employee_contribution) \nEmployee Contribution: \(data.employer_contribution) ")
        }
        else if empContribution == "1" && companyContribution == "0"{
            self.showAlert(message: "Premium Contribution \nEmployee Contribution: \(data.employee_contribution)")
        }
        else if empContribution == "0" && companyContribution == "1"{
            self.showAlert(message: "Premium Contribution \nEmployer Contribution: \(data.employer_contribution)")
        }
        else{
            
        }
        
      
    }
    
    @objc func TimerAct(sender: UIButton){
        let indexpath2 = IndexPath(row: sender.tag, section: 0)
        if indexpath2.row == 0{
            if !isDisabled{
                 showAlert()
             }else{
                 self.showAlert(message: "Window Period is expired.")
             }
        }else if indexpath2.row == 1{
            if !isDisabled{
                 showAlert()
             }else{
                 self.showAlert(message: "Window Period is expired.")
             }
        }else{
            if !isDisabled{
                 showAlert()
             }else{
                 self.showAlert(message: "Window Period is expired.")
             }
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
    
    
    func fetchJsonDataFromCoverages(){
        
        //var json: Any?
        
        if let path = Bundle.main.path(forResource: "MyCoveragesJson", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                //json = try? JSONSerialization.jsonObject(with: data)
                //myCoveragesArray.removeAll()
                let json = try! JSONDecoder().decode(CoveragesNestedJSONModel.self, from: data)
                let dataArray = json.coverages
                for item in dataArray {
                    // DATA INSIDE COVERAGES ARRAY
                   // print("Data is ",item)
                    myCoveragesArray.append(item)
                }
                print("Count for myCoveragesArray: ",myCoveragesArray.count)
            }catch{
                print("Error is: ",error)
            }
        }
    }
    
    
    
    func getDataForMyCoverages(){
        if(isConnectedToNetWithAlert()){
            let appendUrl = "http://localhost:3000/getCoverages"
            self.myCoveragesArray.removeAll()
            webServices().getDataForEnrollment(appendUrl, completion: { (data,error) in
                if error == ""{
                    do{
                        let json = try JSONDecoder().decode(CoveragesNestedJSONModel.self, from: data)
                        let dataArray = json.coverages
                        
                        
                        DispatchQueue.main.async {
                            for item in dataArray {
                                    self.myCoveragesArray.append(item)
                            }
                            print("myCoveragesArray count: ",self.myCoveragesArray.count)
                            self.tableView.reloadData()
                        }
                    }catch{

                    }
                }else{
                    DispatchQueue.main.sync{
                        self.showAlertwithOk(message: error)
                    }
                }
                
            })
        }
    }
    

    
}
    

extension CoveragesInfoVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }else{
            if endDateGPA!.compare(endDate!) == .orderedSame && endDateGTL!.compare(endDate!) == .orderedSame{
                return 130
            }else if endDateGPA == nil && endDateGTL == nil{
                return 130
            }else{
                return 130
            }
        }
        //return UITableViewAutomaticDimension
        
    }
    
    //MARK:- Set Footer View
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        //return AllTopUpArray.count
        return myCoveragesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForInstructionHeaderCell", for: indexPath) as! CellForInstructionHeaderCell
            cell.lblHeaderName.text = "My Coverage"
            cell.imgView.image = UIImage(named:"coverage")
            cell.btnTimer.alpha = 0
            cell.vewTimer.alpha = 0
            return cell
        }
        else { //Plans
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForCoverageInfo", for: indexPath) as! CellForCoverageInfo
            //cell.lblName.text = AllTopUpArray[indexPath.row].policyName
            //cell.lblAmount.text = getFormattedCurrency(amount: AllTopUpArray[indexPath.row].baseAmount!)
 
            var data = self.myCoveragesArray[indexPath.row]
            if endDateGPA!.compare(endDate!) == .orderedSame && endDateGTL!.compare(endDate!) == .orderedSame{
                vewTimer.alpha = 1
                cell.imgTimer.alpha = 0
                cell.lblTimer.alpha = 0
                if !isDisabled{
                    lblTimer.text = countDownTime
                }else{
                    lblTimer.text = "Window Period is expired."
                }
            }else if endDateGPA == nil && endDateGTL == nil{
                vewTimer.alpha = 1
                cell.imgTimer.alpha = 0
                cell.lblTimer.alpha = 0
                if !isDisabled{
                    lblTimer.text = countDownTime
                }else{
                    lblTimer.text = "Window Period is expired."
                }
            }else{
                vewTimer.alpha = 0
                cell.imgTimer.alpha = 1
                cell.lblTimer.alpha = 1
                if indexPath.row == 0{
                    if !isDisabled{
                        cell.lblTimer.text = countDownTime
                    }else{
                        cell.lblTimer.text = "Window Period is expired."
                    }
                }else if indexPath.row == 1{
                    if !isDisabledGpa{
                        cell.lblTimer.text = countDownTimeGpa
                    }else{
                        cell.lblTimer.text = "Window Period is expired."
                    }
                    
                }else{
                    if !isDisabledGtl{
                       cell.lblTimer.text = countDownTimeGtl
                    }else{
                        cell.lblTimer.text = "Window Period is expired."
                    }
                }
            }
            
            var policyType  =  data.policy_type
            
            switch policyType {
            case "1":
                cell.lblName.text =  "Group Health Insurance"
                
                    //how to show sum insured
                    if data.how_to_show_sum_insured == "0"{
                        cell.lblAmount.text = data.sum_insured
                    }else{
                        cell.lblAmount.text = "₹ "+data.sum_insured
                    }
                    
                    // to show sum insure type
                    if data.sum_insure_type == ""{
                        cell.lblSumInsureType.isHidden = true
                    }else{
                        cell.lblSumInsureType.isHidden = false
                        cell.lblSumInsureType.text = "("+data.sum_insure_type+")"
                    }
                    
                    //to show premium
                    
                    if data.to_show_premium == "0"{
                        cell.premiumView.isHidden = true
                    }else{
                        cell.premiumView.isHidden = false
                        cell.lblPremiumAmount.text = "₹ "+data.premium
                        cell.lblPremiumType.text = "("+data.premium_type+")"
                        
                        // To show Premium Amount
                        if data.premium == ""{
                            cell.lblPremium.isHidden = true
                        }else{
                            cell.lblPremium.isHidden = false
                        }
                        
                        // To show Premium_Type
                        if data.premium_type == ""{
                            cell.lblPremiumType.isHidden = true
                        }else{
                            cell.lblPremiumType.isHidden = false
                        }
                    }
                    
                    break
            
            case "2":
                cell.lblName.text =  "Group Personal Accident"
            
                //how to show sum insured
                if data.how_to_show_sum_insured == "0"{
                    cell.lblAmount.text = data.sum_insured
                }else{
                    cell.lblAmount.text = "₹ "+data.sum_insured
                }
                
                // to show sum insure type
                if data.sum_insure_type == ""{
                    cell.lblSumInsureType.isHidden = true
                }else{
                    cell.lblSumInsureType.isHidden = false
                    cell.lblSumInsureType.text = "("+data.sum_insure_type+")"
                }
                
                //to show premium
                
                if data.to_show_premium == "0"{
                    cell.premiumView.isHidden = true
                }else{
                    cell.premiumView.isHidden = false
                    cell.lblPremiumAmount.text = "₹ "+data.premium
                    cell.lblPremiumType.text = "("+data.premium_type+")"
                    
                    // To show Premium Amount
                    if data.premium == ""{
                        cell.lblPremium.isHidden = true
                    }else{
                        cell.lblPremium.isHidden = false
                    }
                    
                    // To show Premium_Type
                    if data.premium_type == ""{
                        cell.lblPremiumType.isHidden = true
                    }else{
                        cell.lblPremiumType.isHidden = false
                    }
                }
                
                break
            
               
                
            case "3":
                cell.lblName.text =  "Group Term Life"
                
                    //how to show sum insured
                    if data.how_to_show_sum_insured == "0"{
                        cell.lblAmount.text = data.sum_insured
                    }else{
                        cell.lblAmount.text = "₹ "+data.sum_insured
                    }
                    
                    // to show sum insure type
                    if data.sum_insure_type == ""{
                        cell.lblSumInsureType.isHidden = true
                    }else{
                        cell.lblSumInsureType.isHidden = false
                        cell.lblSumInsureType.text = "("+data.sum_insure_type+")"
                    }
                    
                    //to show premium
                    
                    if data.to_show_premium == "0"{
                        cell.premiumView.isHidden = true
                    }else{
                        cell.premiumView.isHidden = false
                        cell.lblPremiumAmount.text = "₹ "+data.premium
                        cell.lblPremiumType.text = "("+data.premium_type+")"
                        
                        // To show Premium Amount
                        if data.premium == ""{
                            cell.lblPremium.isHidden = true
                        }else{
                            cell.lblPremium.isHidden = false
                        }
                        
                        // To show Premium_Type
                        if data.premium_type == ""{
                            cell.lblPremiumType.isHidden = true
                        }else{
                            cell.lblPremiumType.isHidden = false
                        }
                    }
                    break
                
            default:
                break
            }
            
            // to show data on click of icon
            
            cell.btnInfo.tag = indexPath.row
            cell.btnInfo.addTarget(self, action: #selector(addToButton), for: .touchUpInside)
            cell.btnTimer.tag = indexPath.row
            cell.btnTimer.addTarget(self, action: #selector(TimerAct), for: .touchUpInside)
            
            
            return cell
        }
        
    }
}
    



extension CoveragesInfoVC:UIScrollViewDelegate {
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


class ChainedAnimationsQueue {
    
    private var playing = false
    private var animations = [(TimeInterval, () -> Void, () -> Void)]()
    
    init() {
    }
    
    /// Queue the animated changes to one or more views using the specified duration and an initialization block.
    ///
    /// - Parameters:
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
    ///   - initializations: A block object containing the changes to commit to the views to set their initial state. This block takes no parameters and has no return value. This parameter must not be NULL.
    ///   - animations: A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value. This parameter must not be NULL.
    func queue(withDuration duration: TimeInterval, initializations: @escaping () -> Void, animations: @escaping () -> Void) {
        self.animations.append((duration, initializations, animations))
        if !playing {
            playing = true
            DispatchQueue.main.async {
                self.next()
            }
        }
    }
    
    private func next() {
        if animations.count > 0 {
            let animation = animations.removeFirst()
            animation.1()
            UIView.animate(withDuration: animation.0, animations: animation.2, completion: { finished in
                self.next()
            })
        } else {
            playing = false
        }
    }
}


extension CoveragesInfoVC{
    @objc func updateCounterGpa() {
        if !isDisabledGpa{
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: endDateGPA!)
            countDownGpa(dateString)
        }
    }
    
    func countDownGpa(_ endDate : String){
        
        if endDate != "" && timer2 != nil{
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
            countDownTimeGpa = String(format: "%02d:%02d:%02d:%02d", difference.day!, difference.hour!,difference.minute!,difference.second!)//"\(difference.day!.description):\(difference.hour!.description):\(difference.minute!.description):\(difference.second!.description)"
            let index = IndexPath(row: 1, section: 1)
            
            if let cell = tableView.cellForRow(at: index) as? CellForCoverageInfo{
                    cell.lblTimer.text = countDownTimeGpa
            }
           // print("count time:\(countDownTime)")
            alertController?.message = countDownTime ?? ""//String(format: "%02d:%02d", minutes, seconds)
            
        }
    }
    
    @objc func updateCounterGtl() {
        if !isDisabledGtl{
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: endDateGTL!)
            countDownGtl(dateString)
        }
    }
    
    func countDownGtl(_ endDate : String){
        
        if endDate != "" && timer3 != nil{
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
            countDownTimeGtl = String(format: "%02d:%02d:%02d:%02d", difference.day!, difference.hour!,difference.minute!,difference.second!)//"\(difference.day!.description):\(difference.hour!.description):\(difference.minute!.description):\(difference.second!.description)"
            let index = IndexPath(row: 2, section: 1)
            
            if let cell = tableView.cellForRow(at: index) as? CellForCoverageInfo{
                    cell.lblTimer.text = countDownTimeGtl
            }
            //print("count time:\(countDownTime)")
            alertController?.message = countDownTime ?? ""//String(format: "%02d:%02d", minutes, seconds)
            
        }
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
            let index = IndexPath(row: 0, section: 1)
            
            if let cell = tableView.cellForRow(at: index) as? CellForCoverageInfo{
                    cell.lblTimer.text = countDownTime
            }
            lblTimer.text = countDownTime
            alertController?.message = countDownTime ?? ""//String(format: "%02d:%02d", minutes, seconds)
            
        }
    }
}
