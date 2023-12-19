//
//  EmployeeDetailsVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 22/08/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation
import UIKit

class EmployeeDetailsVC: UIViewController{
    
   
    @IBOutlet weak var imgIconView: UIImageView!
    @IBOutlet weak var lblPageHeader: UILabel!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ImgTimer: UIImageView!
    
    @IBOutlet weak var lblTimer: UILabel!
    var employeeDetailsArray = [Employee_details]()
    //var counter = 60
    var isSelected = -1
    var webReq = webServices()
    var countDownTime = ""
    var endDate : Date? //""
    var alertController: UIAlertController?
    var timer1 : Timer?
    var isDisabled : Bool = false
//    var buttonClicked : Bool = false
//    var isedit : Bool = false
//    var istick : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        insideView.addSubview(tableView)
        imgIconView.image = getRelationWiseImage(relation: "employee", m_gender: "Male")
        lblPageHeader.text = "Employee Details"
        setImgTintColor(ImgTimer, color: UIColor.white)
    
        insideView.layer.cornerRadius = 10.0
//        buttonClicked = false
//        isedit = false
//        istick = false
 
        // Single Data cell
        tableView.register(UINib(nibName: "cellEmployeeDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "cellEmployeeDetailsTableViewCell")
        // Double Data cell
        tableView.register(UINib(nibName: "cellEmployeeDetails2TableViewCell", bundle: nil), forCellReuseIdentifier: "cellEmployeeDetails2TableViewCell")
       
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
            lblTimer.text = "Window Period is expired."
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //buttonClicked = false
        getDataForEmployeeDetails()
        //countDown()
       // if currentDate < endDate{
            getWindowPeriodDetails()
        //}
    }
    
    
    @IBAction func btnTimerAct(_ sender: Any) {
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
        gradientLayer.frame = self.insideView.bounds
        CATransaction.commit()
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
            print(endDate)
            var dateFormatter = DateFormatter()
            //var endDate = "31/12/2022"
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let EndDate = dateFormatter.date(from:endDate)!
            let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: EndDate)!
            print(modifiedDate)
            let endDateComp = Calendar.current.dateComponents([.year, .month, .day], from: modifiedDate)
            print(endDateComp)
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
            lblTimer.text = countDownTime
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
    
    func getDataForEmployeeDetails(){
        if(isConnectedToNetWithAlert()){
            let appendUrl =  "http://localhost:3000/getemployee_details"
   self.employeeDetailsArray.removeAll()
            webReq.getDataForEnrollment(appendUrl, completion: { (data,error) in
                if error == ""{
                    do{
                        let json = try JSONDecoder().decode(Empolyee_DetailsNestedJSONModel.self, from: data)
                        let dataArray = json.employee_details

                        print("Data Array : ",dataArray)

                        DispatchQueue.main.async {
                            for item in dataArray {
                                self.employeeDetailsArray.append(item)
                            }
                            print("employeeDetailsArray : ",self.employeeDetailsArray)
                            print("employeeDetailsArray count: ",self.employeeDetailsArray.count)
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
    

    
    private func getRelationWiseImage(relation:String,m_gender:String) -> UIImage {
        
        switch relation
        {
        case "EMPLOYEE".lowercased() :
            
            if(m_gender.lowercased() == "male")
            {
                return UIImage(named: "Asset 36")!
            }
            else
            {
                return UIImage(named: "Female Employee")!
            }
            
        case "SPOUSE".lowercased() :
            
            if(m_gender.lowercased() == "male")
            {
                return UIImage(named: "Male")!
            }
            else
            {
                return UIImage(named: "women")!
            }
            
        case "wife" :
            return UIImage(named: "women")!
            
        case "husband" :
            return UIImage(named: "Male")!
            
            
            
        case "SON".lowercased() :
            
            return #imageLiteral(resourceName: "son")
            
            
        case "DAUGHTER".lowercased() :
            
            return #imageLiteral(resourceName: "daughter")
            
            
        case "FATHER".lowercased() :
            
            return #imageLiteral(resourceName: "Male")
            
            
        case "MOTHER".lowercased() :
            
            return #imageLiteral(resourceName: "women")
            
            
        case "FATHER-IN-LAW".lowercased():
            
            return #imageLiteral(resourceName: "Male")
            
            
        case "MOTHER-IN-LAW".lowercased() :
            
            return #imageLiteral(resourceName: "women")
            
            
        default :
            return #imageLiteral(resourceName: "Male")
            
            
            
        }
    }
    
    
}

extension EmployeeDetailsVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped me",indexPath.row)
        
        let cell = tableView.cellForRow(at: indexPath) as! cellEmployeeDetailsTableViewCell
        
       /* let cell = tableView.dequeueReusableCell(withIdentifier: "cellEmployeeDetailsTableViewCell", for: indexPath) as! cellEmployeeDetailsTableViewCell
        let editButton  = cell.btnEditIcon
        
        if cell.txtValue.isUserInteractionEnabled == false{
            cell.txtValue.isUserInteractionEnabled = true
            editButton?.setImage(UIImage(named: "Asset 38")!, for: .normal)
        }else{
            cell.txtValue.isUserInteractionEnabled = false
            editButton?.setImage(UIImage(named: "Asset 36")!, for: .normal)
        }*/
    }
}

extension EmployeeDetailsVC: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employeeDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if self.employeeDetailsArray.count > 0{
            let data = self.employeeDetailsArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellEmployeeDetailsTableViewCell", for: indexPath) as! cellEmployeeDetailsTableViewCell
          
            cell.lblHeader.text = data.FIELD_NAME
            cell.txtValue.text = data.FIELD_VALUE
            
            cell.configure(header: data.FIELD_NAME, value: data.FIELD_VALUE, position: indexPath.row)
            
            cell.delegate = self
//            print(currentDate)
//            print(endDate)
            if !isDisabled{
                if data.TO_EDITABLE == "1"{
                    cell.btnEditIcon.alpha = 1
//                    if !buttonClicked{
//                        if isSelected == -1{
//
                    
////                            isedit = true
////                            istick = false
//
//                        }
//                        else{
//                            cell.btnEditIcon.setImage(UIImage(named: "emergency_tick"), for: .normal)
////                            istick = true
////                            isedit = false
//                        }
//                    }else{
//                        if isedit{
//                            cell.btnEditIcon.setImage(UIImage(named: "emergency_tick"), for: .normal)
//                            isedit = false
//                            istick = true
//                        }else{
//                            cell.btnEditIcon.setImage(UIImage(named: "Asset 59"), for: .normal)
//                            istick = false
//                            isedit = true
//                        }
//                    }
                }else{
                    cell.btnEditIcon.alpha = 0
                }
            }
            else{
                print("disable true")
                cell.btnEditIcon.alpha = 0
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellEmployeeDetailsTableViewCell", for: indexPath) as! cellEmployeeDetailsTableViewCell
            return cell
        }
        
       // Working for 2 cells
        /*
        var cell: UITableViewCell?
        let data = self.employeeDetailsArray[indexPath.row]
        
        
        if self.employeeDetailsArray.count > 0{
            
            if data.FIELD_VALUE.count < 12{
                cell = tableView.dequeueReusableCell(withIdentifier: "cellEmployeeDetails2TableViewCell", for: indexPath) as! cellEmployeeDetails2TableViewCell
                
               // cell?.textLabel?.text = data.FIELD_VALUE
                
            }
            else{
                cell = tableView.dequeueReusableCell(withIdentifier: "cellEmployeeDetailsTableViewCell", for: indexPath) as! cellEmployeeDetailsTableViewCell
                
                //cell?.textLabel?.text = data.FIELD_VALUE
                
            }
        }
        return cell!
       */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


extension EmployeeDetailsVC: cellEmployeeDetailsTableViewCellDelegate{
    func editButtonClicked(header: String, value: String, position: Int) {
       // var arr = self.employeeDetailsArray
        print("Data fro delegate \(header) , \(value) , \(position)")
        
        
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
    
//    override func viewdidDisappear(_ animated: Bool) {
//        
//        self.timer1!.invalidate()
//    }
    
    
    
}
