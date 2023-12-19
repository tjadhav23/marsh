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
    
    var employeeDetailsArray = [Employee_details]()

    var isSelected = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        insideView.addSubview(tableView)
        imgIconView.image = getRelationWiseImage(relation: "employee", m_gender: "Male")
        lblPageHeader.text = "Employee Details"
    
        insideView.layer.cornerRadius = 10.0
 
        // Single Data cell
        tableView.register(UINib(nibName: "cellEmployeeDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "cellEmployeeDetailsTableViewCell")
        // Double Data cell
        tableView.register(UINib(nibName: "cellEmployeeDetails2TableViewCell", bundle: nil), forCellReuseIdentifier: "cellEmployeeDetails2TableViewCell")
        
          
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataForEmployeeDetails()
    }
    
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = self.insideView.bounds
        CATransaction.commit()
    }
    
    
    func getDataForEmployeeDetails(){
        if(isConnectedToNetWithAlert()){
            
            let url = "http://localhost:3000/getemployee_details"
            var urlRequest = URLRequest(url: URL(string: url)!)
            self.employeeDetailsArray.removeAll()
           
            let datatask = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
                (data, httpUrlResponse, error ) in
                guard let dataResponse = data,
                      error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
                do{
                    //here dataResponse received from a network request
                    let json = try JSONDecoder().decode(Empolyee_DetailsNestedJSONModel.self, from: dataResponse)
                    let dataArray = json.employee_details
                    
                    //print("Data Array : ",dataArray)
                    
                    DispatchQueue.main.async {
                        for item in dataArray {
                                self.employeeDetailsArray.append(item)
                        }
                        print("employeeDetailsArray : ",self.employeeDetailsArray)
                        print("employeeDetailsArray count: ",self.employeeDetailsArray.count)
                        self.tableView.reloadData()
                    }
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            })
            datatask.resume()
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
            
            if isSelected != indexPath.row{
                cell.btnEditIcon.setImage(UIImage(named: "Asset 59"), for: .normal)
            }
            else{
                cell.btnEditIcon.setImage(UIImage(named: "emergency_tick"), for: .normal)
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
        
        print("Data fro delegate \(header) , \(value) , \(position)")
        isSelected = position
        self.tableView.reloadData()
        
    }
}
