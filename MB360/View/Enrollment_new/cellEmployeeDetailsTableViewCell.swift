//
//  cellEmployeeDetailsTableViewCell.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 22/08/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import UIKit

protocol cellEmployeeDetailsTableViewCellDelegate: AnyObject {
    func editButtonClicked(header: String, value: String, position: Int)
}

class cellEmployeeDetailsTableViewCell: UITableViewCell {

    weak var delegate: cellEmployeeDetailsTableViewCellDelegate?
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var btnEditIcon: UIButton!
    @IBOutlet weak var valueBorderView: UIView!
    
    var previous = -1
    
    var indexpath: Int = 0
    var header = ""
    var value = ""
    var buttonclicked = 0
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func editButtonClicked(_ sender: Any) {
        
        delegate?.editButtonClicked(header: header, value: value, position: indexpath)
        print("Data in cell \(header) , \(value) , \(indexpath)")
        changeFormat()
    }
    
    
    func configure(header: String, value: String, position: Int){
        
        self.header = header
        self.value = value
        self.indexpath = position
    }
    
    func changeFormat(){
        
         if btnEditIcon.isSelected{
            if txtValue.text?.isEmpty ?? true {
                
                self.inputViewController?.showAlert(message: "Enter \(lblHeader.text) value")
            }
            else if txtValue.text!.count > 0 {//txtValue.text?.count == 10{
             
                btnEditIcon.setImage(UIImage(named: "Asset 59"), for: .normal)
                btnEditIcon.isSelected = false
                print("Updated")
                self.txtValue.isUserInteractionEnabled = false
                txtValue.resignFirstResponder()
                valueBorderView.backgroundColor = UIColor.clear
            }
            else{
                self.inputViewController?.showAlert(message: "Please enter valid mobile number")
            }
        }
        else{
            btnEditIcon.setImage(UIImage(named: "emergency_tick"), for: .normal)
            btnEditIcon.isSelected = true
            self.txtValue.isUserInteractionEnabled = true
            //print("Edit")
            txtValue.becomeFirstResponder()
            valueBorderView.backgroundColor = UIColor.lightGray
        }
    }
}
