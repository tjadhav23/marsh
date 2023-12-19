//
//  HelperForAddTwins.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 11/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import Foundation
import UIKit

extension AddTwinsVC : UIGestureRecognizerDelegate,UITextFieldDelegate {
    

        
        @objc func myTargetFunction(textField: UITextField) {
            print("myTargetFunction")
            //addDatePicker()
        }

        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            if ((touch.view?.isDescendant(of: self.bottomView))!){
                return false
            }
            return true
        }
        


        @objc func keyboardWillShow(notification: NSNotification) {
            print("Keyboard Show",self.view.frame.origin.y)
               if !isKeyboardAppear {
                   if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                       if self.view.frame.origin.y == 0{
                           self.view.frame.origin.y -= keyboardSize.height
                        print("After Show",self.view.frame.origin.y)

                       }
                   }
                   isKeyboardAppear = true
               }
           }
           
           @objc func keyboardWillHide(notification: NSNotification) {
            print("Keyboard Hide",self.view.frame.origin.y)

               if isKeyboardAppear {
                   if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                       if self.view.frame.origin.y < 0{
                           self.view.frame.origin.y = 0
                        print("After Hide",self.view.frame.origin.y)

                       }
                   }
                   isKeyboardAppear = false
               }
           }
        
        
        @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
            self.view.endEditing(true)
            dismiss(animated: true, completion: nil)
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            self.view.endEditing(true)
            dismiss(animated: true, completion: nil)
        }
        
        @objc func handleDOBTap(_ sender: UITapGestureRecognizer) {
       
                self.view.endEditing(true)
                print("Select DOB")
            //addDatePicker()
            }
    
     @IBAction func btnCancelTapped(_ sender: Any) {
            dismiss(animated: true, completion: nil)
  
        }

}

//MARK:- GENDER CHANGE
extension AddTwinsVC {
    
    //FIRST CHILD
@IBAction func genderChanged(_ sender: UIButton) {
    selectedGenderFirst = sender.tag
    setGender(selectedGender: selectedGenderFirst)
}

 func setGender(selectedGender : Int) {
    if selectedGenderFirst == 0 {
        btnMale.setImage(UIImage(named:"blue radio checked"), for: .normal)
        btnFemale.setImage(UIImage(named: "blue radio"), for: .normal)
      //  btnOther.setImage(UIImage(named: "radio"), for: .normal)
    }
    else if selectedGenderFirst == 1 {
        btnFemale.setImage(UIImage(named:"blue radio checked"), for: .normal)
        btnMale.setImage(UIImage(named: "blue radio"), for: .normal)
       // btnOther.setImage(UIImage(named: "radio"), for: .normal)
    }
    else {
       // btnOther.setImage(UIImage(named:"radio_selected"), for: .normal)
        btnFemale.setImage(UIImage(named: "blue radio checked"), for: .normal)
        btnMale.setImage(UIImage(named: "blue radio"), for: .normal)
    }

}
    
    //SECOND CHILD
    @IBAction func secondChildGenderChanged(_ sender: UIButton) {
        selectedGenderSecond = sender.tag
        setGenderSecond(selectedGender: selectedGenderSecond)
    }

     func setGenderSecond(selectedGender : Int) {
        if selectedGenderSecond == 0 {
            btnMale2.setImage(UIImage(named:"blue radio checked"), for: .normal)
            btnFemale2.setImage(UIImage(named: "blue radio"), for: .normal)
           // btnOther2.setImage(UIImage(named: "radio"), for: .normal)
        }
        else if selectedGenderSecond == 1 {
            btnFemale2.setImage(UIImage(named:"blue radio checked"), for: .normal)
            btnMale2.setImage(UIImage(named: "blue radio"), for: .normal)
           // btnOther2.setImage(UIImage(named: "radio"), for: .normal)
        }
        else {
           // btnOther2.setImage(UIImage(named:"radio_selected"), for: .normal)
            btnFemale2.setImage(UIImage(named: "blue radio checked"), for: .normal)
            btnMale2.setImage(UIImage(named: "blue radio"), for: .normal)
        }

    }
    
}




//Date Picker
extension AddTwinsVC {
     func setDateToolBar()
    {
        // ToolBar - 1
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = self.hexStringToUIColor(hex: hightlightColor)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtDob.inputAccessoryView = toolBar
        
        // ToolBar - 2
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = .default
        toolBar2.isTranslucent = true
        toolBar2.tintColor = self.hexStringToUIColor(hex: hightlightColor)
        toolBar2.sizeToFit()

        // Adding Button ToolBar 2
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClickSecondChild))
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton2 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar2.setItems([cancelButton2, spaceButton2, doneButton2], animated: false)
        toolBar2.isUserInteractionEnabled = true

        txtDob2.inputAccessoryView = toolBar2
        
        datePicker.datePickerMode = UIDatePickerMode.date
        
        //Set Previous Date
        if isEdit == true {
            let oldDate = selectedObjFirst.dateofBirth?.getSimpleDate() ?? Date()
            self.datePicker.setDate(oldDate, animated: false)
        }
        
       
            let dateOld = Calendar.current.date(byAdding: .year, value: -24, to: Date())
            datePicker.minimumDate = dateOld

            datePicker.maximumDate = Date()

        
        
        
        
        self.txtDob.inputView = datePicker
        self.txtDob.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)

        self.txtDob2.inputView = datePicker
        self.txtDob2.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)

        
    }
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        
        txtDob.text = formatter.string(from: datePicker.date)

       // let m_selectedDate = datePicker.date
        let dateString = dateFormatter1.string(from: datePicker.date)
        print(dateString)
        
        let serverDt = Date()

        //self.txtAge.text = String(serverDt.years(from: datePicker.date)) + " yrs"
        self.firstChildAge = serverDt.years(from: datePicker.date)
        
        if self.firstChildAge > 1 {
                      self.txtAge.text = String(self.firstChildAge) + " yrs"
                  }
                  else {
                      self.txtAge.text = String(self.firstChildAge) + " yr"
                  }
        
        
        txtDob.resignFirstResponder()
    }
    @objc func doneClickSecondChild() {
           let dateFormatter1 = DateFormatter()
           dateFormatter1.dateStyle = .medium
           dateFormatter1.timeStyle = .none
           
           let formatter = DateFormatter()
           formatter.dateFormat = "dd-MMM-yyyy"
           
           txtDob2.text = formatter.string(from: datePicker.date)

           //let m_selectedDate = datePicker.date
           let dateString = dateFormatter1.string(from: datePicker.date)
           print(dateString)
           
           let serverDt = Date()

          // self.txtAge2.text = String(serverDt.years(from: datePicker.date)) + " yrs"
           self.secondChildAge = serverDt.years(from: datePicker.date)
        
        if self.secondChildAge > 1 {
                            self.txtAge2.text = String(self.secondChildAge) + " yrs"
                        }
                        else {
                            self.txtAge2.text = String(self.secondChildAge) + " yr"
                        }
        
           txtDob2.resignFirstResponder()
       }
    
    
    @objc func cancelClick() {
        txtDob.resignFirstResponder()
        txtDob2.resignFirstResponder()
    }

}
