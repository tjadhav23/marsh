//
//  HelperForDependantList.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 19/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import Foundation
import UIKit

//======================= DependantsListVC ========================
extension DependantsListVC {
    func getRelationWiseImage(relation:String,m_gender:String) -> UIImage {
        
        switch relation
        {
        case "EMPLOYEE".lowercased() :
            
            if(m_gender.lowercased() == "male") {
                return UIImage(named: "Asset 36")!
            } else{
                return UIImage(named: "Female Employee")!
            }
            
        case "SPOUSE".lowercased() :
            
            if(m_gender.lowercased() == "male"){
                return UIImage(named: "Husband")!
            }else{
                return UIImage(named: "Asset 57")!
            }
            
        case "PARTNER".lowercased() :
            
            if(m_gender.lowercased() == "male")
            {
                return UIImage(named: "Husband")!
            }
            else if (m_gender.lowercased() == "female")
            {
                return UIImage(named: "Asset 57")!
            }
            else {
                return UIImage(named: "partner_icon")!
            }
            
        case "wife" :
            return UIImage(named: "Asset 57")!
            
        case "husband" :
            return UIImage(named: "Husband")!
            
        case "SON".lowercased() :
            
            return UIImage(named: "sonNew")!
            
            
        case "DAUGHTER".lowercased() :
            
            return UIImage(named: "Asset 56")!
            
        case "twins".lowercased() :
            
            if(m_gender.lowercased() == "male"){
                return UIImage(named: "sonNew")!
            }  else{
                return UIImage(named: "Asset 56")!
            }
            
        case "FATHER".lowercased() :
            
            return UIImage(named: "grandfather")!
            
        case "MOTHER".lowercased() :
            
            return UIImage(named: "grandmother")!
            
        case "FATHER-IN-LAW".lowercased():
            
            return UIImage(named: "grandfather")!
            
        case "MOTHER-IN-LAW".lowercased() :
            
            return UIImage(named: "grandmother")!
            
        default :
            return UIImage(named: "son")!
        }
    }
    
}



//============================AddNewDependantVC================================

extension AddNewDependantVC {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        //        textField.setBorderToView(color: UIColor.white)
        if(textField.placeholder=="First Name + Last Name")
        {
            
            //if(txtName.text?.count==1)
            // {
            txtName.text = txtName.text!.firstCharacterUpperCase()
            // txtName.autocapitalizationType = UITextAutocapitalizationType.sentences
            // txtName.textColor=UIColor.black
            // }
            
            
            let MAX_LENGTH_PHONENUMBER = 100
            let ACCEPTABLE_NUMBERS     = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        else if(textField.placeholder=="Age(yrs)")
        {
            let MAX_LENGTH_PHONENUMBER = 2
            let ACCEPTABLE_NUMBERS     = "0123456789"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        
        return true
    }
}

//============================AddNewDisabledDependantVC================================

extension AddNewDisabledDependantVC {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        //        textField.setBorderToView(color: UIColor.white)
        if(textField.placeholder=="First Name + Last Name")
        {
            
            //if(txtName.text?.count==1)
            // {
            txtName.text = txtName.text!.firstCharacterUpperCase()
            // txtName.autocapitalizationType = UITextAutocapitalizationType.sentences
            // txtName.textColor=UIColor.black
            // }
            
            
            let MAX_LENGTH_PHONENUMBER = 100
            let ACCEPTABLE_NUMBERS     = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        else if(textField.placeholder=="Age(yrs)")
        {
            let MAX_LENGTH_PHONENUMBER = 2
            let ACCEPTABLE_NUMBERS     = "0123456789"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        
        return true
    }
}


extension String {
    func firstCharacterUpperCase() -> String {
        if let firstCharacter = characters.first {
            return replacingCharacters(in: startIndex..<index(after: startIndex), with: String(firstCharacter).uppercased())
        }
        return ""
    }
}


extension AddEditParentVC {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        //        textField.setBorderToView(color: UIColor.white)
        if(textField.placeholder=="First Name + Last Name")
        {
            
            //if(txtName.text?.count==1)
            // {
            //m_nameTextfield.text = m_nameTextfield.text!.firstCharacterUpperCase()
            // txtName.autocapitalizationType = UITextAutocapitalizationType.sentences
            // txtName.textColor=UIColor.black
            // }
            
            
            let MAX_LENGTH_PHONENUMBER = 100
            let ACCEPTABLE_NUMBERS     = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        else if(textField.placeholder=="Age(yrs)")
        {
            let MAX_LENGTH_PHONENUMBER = 2
            let ACCEPTABLE_NUMBERS     = "0123456789"
            let newLength: Int = textField.text!.count + string.count - range.length
            let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
            let strValid = string.rangeOfCharacter(from: numberOnly as CharacterSet) == nil
            return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
        }
        
        return true
    }
}

//MARK:- Server Call
extension DependantsListVC {
    func getDependantsFromServer() {
        print("@@ getDependantsFromServer...")
        if(isConnectedToNetWithAlert())
        {
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                m_employeedict=userArray[0]
                
                var oe_group_base_Info_Sr_No = String()
                var groupChildSrNo = String()
                var empSrNo = String()
                var empIDNo = String()
                
                if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
                {
                    oe_group_base_Info_Sr_No = String(empNo)
                }
                if let groupChlNo = m_employeedict?.groupChildSrNo
                {
                    groupChildSrNo=String(groupChlNo)
                }
                if let empsrno = m_employeedict?.empSrNo
                {
                    empSrNo=String(empsrno)
                }
                if let empidno = m_employeedict?.empIDNo
                {
                    empIDNo=String(empidno)
                }
                
//                guard let groupSrNo = UserDefaults.standard.value(forKey: "ExtGroupSrNo") else {
//                    return
//                }
                
                let url = APIEngine.shared.getDependantListJSONURL(Windowperiodactive: "1", GroupChildSrNo: groupChildSrNo, OeGrpBasInfSrNo: oe_group_base_Info_Sr_No, EmpSrNo: empSrNo)
                
                
                let urlreq = NSURL(string : url)
                print(url)
                EnrollmentServerRequestManager.serverInstance.getArrayRequestDataFromServer(url: url, view: self) { (data, error) in
                    
                    if error != nil
                    {
                        print("error ",error!)
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        print("found....")
                        self.addedChildCount = 0
                        do {
                            print("Started parsin...")
                            print("dataa : ",data?["Dependent"])
                            
                            //if let jsonResultArray = data?.array
                            if let jsonResultArray = data?["Dependent"].array
                            {
                                    self.structDataSource.removeAll()
                                    self.tempDataSource.removeAll()
                                    self.m_membersNameArray.removeAll()
                                
                                    print(jsonResultArray.count)
                                    for obj in jsonResultArray {
                                      
                                        self.m_membersNameArray.append(obj["Name"].string ?? "")
                                        
                                        var sortId = 10
                                        let relationName = obj["Relation"].string
                                        
                                        switch relationName?.lowercased() {
                                        case "wife","husband","Spouse","SPOUSE":
                                            sortId = 1
                                        case "partner":
                                            sortId = 2
                                        case "son":
                                            sortId = 3
                                        case "daughter":
                                            sortId = 4
                                            
                                        default:
                                            sortId = 10
                                        }
        
                                        
                                         var certiName = ""
                                         var disabledFlag = false
                                         for i in 0..<self.differentDataSource.count{
                                            let dict = self.differentDataSource[i]
                                            if dict.IsDisabled == true && obj["PersonSrNo"].string == dict.personSrNo {
                                                
                                                certiName = dict.CertificateFile!
                                                disabledFlag = true
                                                break
                                            }
                                        }
                                          
                                          //......................>>....................
                                    
                                   // let objPerson = DependantDBRecords.init(IsSelected: obj["IsSelected"].bool, IsApplicable: obj["IsApplicable"].bool, CanDelete: obj["CanDelete"].bool, ReasonForNotAbleToDelete:  obj["ReasonForNotAbleToDelete"].string, CanUpdate: obj["CanUpdate"].bool, IsTwins: obj["IsTwins"].string, ReasonForNotAbleToUpdate: obj["ReasonForNotAbleToUpdate"].string, IsDisabled: obj["IsDisabled"].bool, PairNo: obj["PairNo"].string, age: Int(obj["Age"].string!), cellPhoneNUmber: "", dateofBirth: obj["DateOfBirth"].string, emailIDStr: "", empSrNo: 0, gender: obj["Gender"].string, isValid: 0, personName: obj["Name"].string, personSrNo: Int(obj["PersonSrNo"].string!), productCode: "", relationID:Int(obj["RelationID"].string!) , relationname: obj["Relation"].string, isEmpty: false, sortId: 1, twinPair: 111, isHeader: false, primiumAmountDep:obj["ExtraChildPremium"].string,selectedFilename: certiName,isDiffAbled: disabledFlag ,isPremiumShow: false, premiumAmount: 0, parentPercentage: 0)
                                        
                                        //let objPerson = DependantDBRecords.init(srNo: 1, personName: obj["personName"].string, relation: obj["relation"].string, gender: obj["gender"].string, relationID: obj["relationID"].string, age: obj["age"].string, dateofBirth: obj["dateofBirth"].string, personSrNo: obj["personSrNo"].string, reasonForNotAbleToDelete: obj["reasonForNotAbleToDelete"].string, isTwins: obj["isTwins"].string, reasonForNotAbleToUpdate: obj["reasonForNotAbleToUpdate"].string, twinpairNo: obj["twinpairNo"].string, extraChildPremium: obj["extraChildPremium"].string, premiumAmount: obj["premiumAmount"].string, enrollment_Reason: obj["enrollment_Reason"].string, productCode: obj["productCode"].string, parentPercentage: 0.0, isPremiumShow: obj["isPremiumShow"].bool, isSelected: obj["isSelected"].bool, isApplicable: obj["isApplicable"].bool, canDelete: obj["canDelete"].bool, canUpdate: obj["canUpdate"].bool, isDisabled: obj["isDisabled"].bool, isAdded: obj["isAdded"].bool, cellPhoneNUmber: "", emailIDStr: "", empSrNo: 0, isValid: 0, twinPair: 0, isHeader: false, selectedFilename: certiName)
                                        
                                        let objPerson = DependantDBRecords.init(srNo: 0, personName: obj["personName"].string, relation: obj["relation"].string, gender: obj["gender"].string, relationID: obj["relationID"].string, age: obj["age"].string, dateofBirth: obj["dateofBirth"].string, personSrNo: obj["personSrNo"].string, reasonForNotAbleToDelete: obj["reasonForNotAbleToDelete"].string, isTwins: obj["isTwins"].string, reasonForNotAbleToUpdate: obj["reasonForNotAbleToUpdate"].string, twinpairNo: obj["twinpairNo"].string, extraChildPremium: obj["extraChildPremium"].string, premiumAmount: obj["premiumAmount"].string, enrollment_Reason: obj["enrollment_Reason"].string, productCode: obj["productCode"].string, parentPercentage: 0.0, isPremiumShow: obj["isPremiumShow"].bool, isSelected: obj["isSelected"].bool, isApplicable: obj["isApplicable"].bool, canDelete: obj["canDelete"].bool, canUpdate: obj["canUpdate"].bool, isDisabled: obj["isDisabled"].bool, isAdded: obj["isAdded"].bool, cellPhoneNUmber: "", emailIDStr: "", empSrNo: 0, isValid: 0, twinPair: 0, isHeader: false, selectedFilename: "")
                                                                        
                                    self.tempDataSource.append(objPerson)
                                }
                                print("Temp data ",self.tempDataSource)
                                print("structDataSource data ",self.structDataSource)
                                
                                self.structDataSource = self.tempDataSource
                                
                                print("structDataSource filled data ",self.structDataSource)
                                // self.filledFinalArray()
                                //self.getDifferentlyAbledFromServer()
                                print("All Members Name : \(self.m_membersNameArray)")
                                self.tableView.reloadData()
                            }//jsonResult
                            else{
                                print("Outside jsonResultArray = data?.array",data)
                            }
                        }//do
                            
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
            }//userArray
        }
        else {
            self.refreshControl.endRefreshing()
        }
    }
    
    
    func filledFinalArray() {
        print("filledFinalArray()...\(tempDataSource)")
        self.structDataSource.removeAll()
        
        let array = tempDataSource.filter({$0.relation?.lowercased() == "spouse"})
        //let array = tempDataSource.filter({$0.relationname?.lowercased() == m_spouse.lowercased()})

        if(array.count>0)
        {
            print("Filled Array: ",array)
            var obj = array[0]
            if obj.gender?.lowercased() == "male" {
                obj.relation = "Husband"
            }
            else {
                obj.relation = "Wife"
            }
            
            self.structDataSource.append(obj)
            isEmptyList = true
        }
        else {
            print("Spouse Empty")
            
            //Partner
            let arrayp = tempDataSource.filter({$0.relation?.lowercased() == "PARTNER".lowercased()})
                   if(arrayp.count>0)
                   {
                       let obj = arrayp[0]
                       self.structDataSource.append(obj)
                        isEmptyList = true
                   }
                   else {
                         isEmptyList = false
                        EmptyObj.isAdded = true
                        EmptyObj.relation = m_spouse
                        EmptyObj.srNo = 1
                        //EmptyObj.relationID = Int(getRelationId(relation: "SPOUSE"))
                        EmptyObj.relationID = getRelationId(relation: "SPOUSE")
                        if m_spouse.lowercased() == "wife" {
                            EmptyObj.gender = "Female"
                        }
                        else {
                            EmptyObj.gender = "Male"
                        }
                        
                        self.structDataSource.append(EmptyObj)
                        
                        EmptyObj.isAdded = true
                        EmptyObj.premiumAmount = ""
                        EmptyObj.relation = "PARTNER"
                        EmptyObj.srNo = 2
                        EmptyObj.relationID = "21"
                        self.structDataSource.append(EmptyObj)
                }
        }
        
       
        
        //SON
        
        let arrayofSon = tempDataSource.filter({($0.relation?.lowercased() == "son" || $0.relation?.lowercased() == "daughter") && $0.isTwins == "NO"})
        if(arrayofSon.count>0)
        {
            for i in 0..<arrayofSon.count {
                self.structDataSource.append(arrayofSon[i])
            }
            self.addedChildCount = arrayofSon.count
        }
        
            
        let twinsPairArray = tempDataSource.filter({$0.isTwins == "YES"})
        var twinPairCount = twinsPairArray.count / 2
        if twinsPairArray.count == 2 {
            
            self.structDataSource.append(twinsPairArray[0])
            self.structDataSource.append(twinsPairArray[1])

            self.addedChildCount += 1

        }
        else if twinsPairArray.count == 4 {
            self.structDataSource.append(twinsPairArray[0])
            self.structDataSource.append(twinsPairArray[1])
            self.structDataSource.append(twinsPairArray[2])
            self.structDataSource.append(twinsPairArray[3])

            self.addedChildCount += 2
            
        }

//Sort main array agewise to show sorted list...
        
        for i in 0..<structDataSource.count {
        for j in (i + 1)..<structDataSource.count {
            let dict = structDataSource[i]
            let dict1 = structDataSource[j]
                    if let age = dict.age, let age1 = dict1.age {
                        if age < age1 {
                           let a = structDataSource[i]
                           structDataSource[i] = structDataSource[j]
                           structDataSource[j] = a
                           
                            let b = m_membersNameArray[i]
                            m_membersNameArray[i] = m_membersNameArray[j]
                            m_membersNameArray[j] = b
                        }
                      }
               }
           }
        structDataSourceD.removeAll() //remove Husband/wife/Partner from sorted list show them 1st if available...
        structDataSourceD = structDataSource
        for i in 0..<structDataSource.count {
            if structDataSource[i].relation?.lowercased() == "husband" || structDataSource[i].relation?.lowercased() == "wife" || structDataSource[i].relation?.lowercased() == "partner" {
                structDataSourceD.remove(at: i)
                structDataSourceD.insert(structDataSource[i], at: 0)
                break
            }
        }
        
        structDataSource = structDataSourceD
//....
        
        m_ChildCount = twinPairCount + arrayofSon.count //Total Child Count
       
// Get Extra Child details
        let no_Of_Extra_Child = m_ChildCount - 2
        var noofextrachild = 0
        m_extraMemberArray.removeAll()
        if structDataSource.count > 0 && no_Of_Extra_Child > 0 {
            
            var sizeoffamilydata = structDataSource.count - 1
            for i in 0..<no_Of_Extra_Child {
                if structDataSource[sizeoffamilydata].isTwins == "YES" || structDataSource[sizeoffamilydata].isTwins == "yes" {
                    
                    structDataSource[sizeoffamilydata].isPremiumShow = true
                    
                    let relation = structDataSource[sizeoffamilydata].gender?.uppercased() == "MALE" ? "Son" : "Daughter"
                    m_extraMemberArray.append("\(structDataSource[sizeoffamilydata].personName ?? "") (Twin - \(relation))")
                    
                    sizeoffamilydata = sizeoffamilydata - 1
                    structDataSource[sizeoffamilydata].isPremiumShow = true
                    
                    let relation1 = structDataSource[sizeoffamilydata].gender?.uppercased() == "MALE" ? "Son" : "Daughter"
                    m_extraMemberArray.append("\(structDataSource[sizeoffamilydata].personName ?? "") (Twin - \(relation1))")

                    noofextrachild = noofextrachild + 1
                } else {
                    
                    structDataSource[sizeoffamilydata].isPremiumShow = true
                    
                    let relation1 = structDataSource[sizeoffamilydata].gender?.uppercased() == "MALE" ? "Son" : "Daughter"
                    m_extraMemberArray.append("\(structDataSource[sizeoffamilydata].personName ?? "") (\(relation1))")

                }
                sizeoffamilydata = sizeoffamilydata - 1
                noofextrachild = noofextrachild + 1
            }
        }
        print(m_extraMemberArray)
        if m_extraMemberArray.count > 0{
            UserDefaults.standard.set("", forKey: "ExtraChildName")
            let finalStr = m_extraMemberArray.joined(separator: ",")
            print(finalStr)
            UserDefaults.standard.set(String(finalStr), forKey: "ExtraChildName")
        }else{
            UserDefaults.standard.set("", forKey: "ExtraChildName")
        }
//...
// Covered Dependant Name
        strArrayCoverMembers.removeAll()
        
        if structDataSource.count > 0{
            tempDataSourceNew.removeAll()
            tempDataSourceNew = structDataSource
                   var noofcoverdependents = 0
                   if isEmptyList == false {
                       tempDataSourceNew.remove(at: 0)
                       tempDataSourceNew.remove(at: 0)
                        if tempDataSourceNew.count > 0{
                            noofcoverdependents = tempDataSourceNew.count - noofextrachild
                        }else{
                            noofcoverdependents = noofextrachild
                        }
                   }else{
                       noofcoverdependents = tempDataSourceNew.count - noofextrachild
                   }
                   
                if noofcoverdependents > 0{
                    for i in 0..<noofcoverdependents {
                        if tempDataSourceNew[i].isTwins == "YES" || tempDataSourceNew[i].isTwins == "yes" {
                            
                            let relation = tempDataSourceNew[i].gender?.uppercased() == "MALE" ? "Son" : "Daughter"
                            strArrayCoverMembers.append("\(tempDataSourceNew[i].personName ?? "") (Twin - \(relation))")
                            
                        }else{
                            let relation1 = tempDataSourceNew[i].relation
                            strArrayCoverMembers.append("\(tempDataSourceNew[i].personName ?? "") (\(relation1 ?? ""))")
                        }
                    }
                }
        }
       //.........................
        print(strArrayCoverMembers)
        if strArrayCoverMembers.count > 0{
            UserDefaults.standard.set("", forKey: "CoveredDependantName")
            let finalStr = strArrayCoverMembers.joined(separator: ",")
            print(finalStr)
            UserDefaults.standard.set(String(finalStr), forKey: "CoveredDependantName")
        }else{
            UserDefaults.standard.set("", forKey: "CoveredDependantName")
        }
 //...
    
        addChild()
        if m_ChildCount < 2 {
            addTwins()
        }

        /* //Shubham commected for testing
        if structDataSource.count > 0 {
            UserDefaults.standard.set("", forKey: "ExtraChildCount")
            UserDefaults.standard.set(0, forKey: "ExtraChildCountInt")
            UserDefaults.standard.set("", forKey: "ExtraChildPremium")
            UserDefaults.standard.set(0, forKey: "ExtraChildPremiumInt")
            
            for i in 0..<structDataSource.count {
                print("tooooo...")
                let dict = structDataSource[i]
                if let str = dict.premiumAmount , dict.premiumAmount != ""{
                    m_ExtraAmount = str
                    let a = Int(str)
                    let ExtraChildPremium = (m_ChildCount - 2) * a!

                    UserDefaults.standard.set(String(m_ChildCount - 2), forKey: "ExtraChildCount")
                    UserDefaults.standard.set(Int(m_ChildCount - 2), forKey: "ExtraChildCountInt")
                    UserDefaults.standard.set(String(ExtraChildPremium), forKey: "ExtraChildPremium")
                    UserDefaults.standard.set(Int(ExtraChildPremium), forKey: "ExtraChildPremiumInt")
                    break
                }
            }
            
        }else{
          

            UserDefaults.standard.set("", forKey: "ExtraChildCount")
            UserDefaults.standard.set(0, forKey: "ExtraChildCountInt")
            UserDefaults.standard.set("", forKey: "ExtraChildPremium")
            UserDefaults.standard.set(0, forKey: "ExtraChildPremiumInt")
        }
    
        */
        self.tableView.reloadData()
        isLoaded = 1

    }//FUNC END
    
    func addTwins(){
       self.EmptyObj.isAdded = true
       self.EmptyObj.relation = "Twins"
       self.EmptyObj.srNo = 5
       
       self.structDataSource.append(self.EmptyObj)
    }
    
    func addChild(){
        print("Son Empty")
        let array2:Array<EnrollmentGroupRelations> = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: "SON")
        var minAge = "0"
        var maxAge = "0"
        var relationId = ""
        if array2.count > 0 {
            relationId = array2[0].relationID!
            maxAge = array2[0].minAge!
            minAge = array2[0].maxAge!
        }
        
        EmptyObj.isAdded = true
        EmptyObj.relation = "SON"
        EmptyObj.srNo = 3
        EmptyObj.gender = "Male"
        if relationId != "" {
            EmptyObj.relationID = relationId //Int(relationId)
        }
        self.structDataSource.append(EmptyObj)
        
//....
        print("DAUGHTER Empty")
        let array1:Array<EnrollmentGroupRelations> = DatabaseManager.sharedInstance.retrieveEnrollmentGroupRelationsDetails(relation: "DAUGHTER")
        var minAge1 = "0"
        var maxAge1 = "0"
        var relationId1 = ""
        if array1.count > 0 {
            relationId1 = array1[0].relationID!
            maxAge1 = array1[0].minAge!
            minAge1 = array1[0].maxAge!
        }
        
        EmptyObj.isAdded = true
        EmptyObj.relation = "DAUGHTER"
        EmptyObj.gender = "Female"
        
        EmptyObj.srNo = 4
        if relationId1 != "" {
            EmptyObj.relationID = relationId //Int(relationId1)
        }
        self.structDataSource.append(EmptyObj)
    }
    
    
    
    private func addEmptyChildCards() {
        //Add Twins Empty Card
        let array = self.structDataSource.filter({$0.srNo == 5 && $0.isAdded == true})
        
        if array.count == 0 {
            self.EmptyObj.isAdded = true
            self.EmptyObj.relation = "Twins"
            self.EmptyObj.srNo = 5
            
            self.structDataSource.append(self.EmptyObj)
        }
        
        //Add Son Empty Card
        let sonArray = self.structDataSource.filter({$0.srNo == 3 && $0.isAdded == true})
        
        if sonArray.count == 0 {
            self.EmptyObj.isAdded = true
            self.EmptyObj.relation = "SON"
            EmptyObj.gender = "Male"
            
            self.EmptyObj.srNo = 3
            self.EmptyObj.relationID = self.getRelationId(relation: "SON") //Int(self.getRelationId(relation: "SON"))
            self.structDataSource.append(self.EmptyObj)
        }
        
        
        //Add Daughter Empty Card
        let daughterArray = self.structDataSource.filter({$0.srNo == 4 && $0.isAdded == true})
        
        if daughterArray.count == 0 {
            self.EmptyObj.isAdded = true
            self.EmptyObj.relation = "DAUGHTER"
            EmptyObj.gender = "Female"
            
            self.EmptyObj.srNo = 4
            self.EmptyObj.relationID = self.getRelationId(relation: "DAUGHTER") //Int(self.getRelationId(relation: "DAUGHTER"))
            self.structDataSource.append(self.EmptyObj)
        }
    }
    
    func deleteDependantToServer(url:String,personSrNo:String) {
        if(isConnectedToNetWithAlert())
        {
          //,
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
            
                let urlreq = NSURL(string : url)
                
                print(url)
                let dict = ["":""]
                
                EnrollmentServerRequestManager.serverInstance.deleteDataToServer(url: url, dictionary: dict as NSDictionary, view: self) { (data, error) in
                    
                    if error != nil
                    {
                        print("error ",error!)
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        do {
                            print("Started parsing ...")
                            print(data)
                           
                            if let statusDict = data?["message"].dictionary
                                {
                                    if let status = statusDict["Status"]?.bool {
        
                                        if status == true
                                        {
                                            let msg = statusDict["Message"]?.string
                                            //call delete DA here
                                            self.deleteDifferentlyAbledFromServer(personSrNo: personSrNo)
                                            self.getDependantsFromServer()
                                        }
                                        else {
                                            let msg = statusDict["Message"]?.string
                                            self.displayActivityAlert(title: msg ?? "Failed to delete Dependant")
                                        }
                                    }//status
                                    
                                
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
    
     func deleteCh1DependantToServer(url1:String,url2:String,personSrNo1:String,personSrNo2:String) {
        if(isConnectedToNetWithAlert())
        {
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
            
                print(url1)
                let dict = ["":""]
                
                EnrollmentServerRequestManager.serverInstance.deleteDataToServer(url: url1, dictionary: dict as NSDictionary, view: self) { (data, error) in
                    
                    if error != nil
                    {
                        print("error ",error!)
                        //self.hidePleaseWait()
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        // self.hidePleaseWait()
                        print("....")

                        do {
                            print(data)
                            
                           
                                print("deleteCh1DependantToServer Data Found")
                            if let statusDict = data?["message"].dictionary
                                {
                                    if let status = statusDict["Status"]?.bool {
        
                                        if status == true
                                        {
                                            self.deleteDifferentlyAbledFromServer(personSrNo: personSrNo1)
                                            self.deleteCh2DependantToServer(url2: url2, personSrNo: personSrNo2)
                                        }
                                        else {
                                            //No Data found
                                            let msg = statusDict["Message"]?.string
                                            self.displayActivityAlert(title: msg ?? "Failed to delete Dependant")
                                        }
                                    }//status
                                    
                                
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
    
     func deleteCh2DependantToServer(url2:String,personSrNo:String) {
        if(isConnectedToNetWithAlert())
        {
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
            
                
                //self.showPleaseWait(msg: "")
                print(url2)
                let dict = ["":""]
                
                EnrollmentServerRequestManager.serverInstance.deleteDataToServer(url: url2, dictionary: dict as NSDictionary, view: self) { (data, error) in
                    
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
                            print(data)
                            
                           
                                print("deleteCh1DependantToServer Data Found")
                            if let statusDict = data?["message"].dictionary
                                {
                                    if let status = statusDict["Status"]?.bool {
        
                                        if status == true
                                        {
                                            let msg = statusDict["Message"]?.string
                                            self.deleteDifferentlyAbledFromServer1(personSrNo: personSrNo)
                                            self.getDependantsFromServer()
                                        }
                                        else {
                                            //No Data found
                                            let msg = statusDict["Message"]?.string
                                            self.displayActivityAlert(title: msg ?? "Failed to delete Dependant")
                                        }
                                    }//status
                                    
                                
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

    //MARK: - Differently Abled Child JSONURL

    func getDifferentlyAbledFromServer() {
        print("@@ getDifferentlyAbledChildJSONURL...")
        if(isConnectedToNetWithAlert())
        {
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
                m_employeedict=userArray[0]
                var empSrNo = String()
                if let empsrno = m_employeedict?.empSrNo{
                    empSrNo=String(empsrno)
                }
                               
                let url = APIEngine.shared.getDifferentlyAbledChildJSONURL(EmployeeSrNo: empSrNo)
                let urlreq = NSURL(string : url)
                
                print(url)
                EnrollmentServerRequestManager.serverInstance.getArrayRequestDataFromServer(url: url, view: self) { (data, error) in
                    
                    if error != nil
                    {
                        print("error ",error!)
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        print("found....")
                        
                        do {
                            print("Started parsin...")
                            print(data)
                            
                            if data?.dictionary?["Status"] == true {
                                if let jsonResultArray = data?.dictionary?["Data"]?.array
                                {
                                    self.differentDataSource.removeAll()
                                    
                                    print(jsonResultArray.count)
                                    for obj in jsonResultArray {

                           /*
                            Printing description of obj:
                            ▿ {
                              "PersonDiffAbledSrNo" : 64,
                              "IsDiffAbled" : 0,
                              "CertificateFile" : "",
                              "personSrNo" : 4635233
                            }
                                         */
                                       // let objPerson = DifferentlyDBRecords.init(PersonDiffAbledSrNo: String(obj["PersonDiffAbledSrNo"].int!), personSrNo: String(obj["personSrNo"].int!), IsDiffAbled: obj["IsDiffAbled"].int, CertificateFile: obj["CertificateFile"].string)
                                        let objPerson = DifferentlyDBRecords.init(PersonDiffAbledSrNo: obj["personDiffAbleSrNo"].string, personSrNo:  obj["personSrNo"].string, IsDisabled:  obj["isDisabled"].bool, CertificateFile:  obj["certificateFile"].string)
                                        
                                        
                                        self.differentDataSource.append(objPerson)
                                    }
                                    print("differentDataSource array: \(self.differentDataSource)")
                                    self.getDependantsFromServer()
                                }//jsonResult
                            }
                        }//do
                            
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
            }//userArray
        }
        else {
            self.refreshControl.endRefreshing()
        }
    }
    
    
    
    func deleteDifferentlyAbledFromServer(personSrNo:String) {
        print("@@ deleteDifferentlyAbledFromServer...")
        if(isConnectedToNetWithAlert())
        {
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
               
                let url = APIEngine.shared.deleteDifferentlyAbledChildJSONURL(PersonSrNo: personSrNo)
                let urlreq = NSURL(string : url)
                
                print(url)
                EnrollmentServerRequestManager.serverInstance.getArrayRequestDataFromServer(url: url, view: self) { (data, error) in
                    
                    if error != nil
                    {
                        print("error ",error!)
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        print("found....")
                        do {
                            print("Started parsin...")
                            print(data)
                            
                            if data?.dictionary?["Status"] == true {
                                if let jsonResultArray = data?.dictionary?["Data"]?.array
                                {
                                    
                                }//jsonResult
                            }
                        }//do
                            
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
            }//userArray
        }
        else {
            self.refreshControl.endRefreshing()
        }
    }
    
    
    func deleteDifferentlyAbledFromServer1(personSrNo:String) {
        print("@@ deleteDifferentlyAbledFromServer...")
        if(isConnectedToNetWithAlert())
        {
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            if(userArray.count>0)
            {
               
                let url = APIEngine.shared.deleteDifferentlyAbledChildJSONURL(PersonSrNo: personSrNo)
                let urlreq = NSURL(string : url)
                
                print(url)
                EnrollmentServerRequestManager.serverInstance.getArrayRequestDataFromServer(url: url, view: self) { (data, error) in
                    
                    if error != nil
                    {
                        print("error ",error!)
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    else
                    {
                        print("found....")
                        do {
                            print("Started parsin...")
                            print(data)
                            
                            if data?.dictionary?["Status"] == true {
                                if let jsonResultArray = data?.dictionary?["Data"]?.array
                                {
                                    
                                }//jsonResult
                            }
                        }//do
                            
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
            }//userArray
        }
        else {
            self.refreshControl.endRefreshing()
        }
    }
    
}


/*
 
 let obj = DependantDBRecords.init(IsSelected: arrayofSon[0].IsSelected, IsApplicable: arrayofSon[0].IsApplicable
 , CanDelete: arrayofSon[0].CanDelete
 , ReasonForNotAbleToDelete: arrayofSon[0].ReasonForNotAbleToDelete
 , CanUpdate: arrayofSon[0].CanUpdate
 , IsTwins: arrayofSon[0].IsTwins
 , ReasonForNotAbleToUpdate: arrayofSon[0].ReasonForNotAbleToUpdate
 , IsDisabled: arrayofSon[0].IsDisabled, PairNo: arrayofSon[0].PairNo
 , age: arrayofSon[0].age
 , cellPhoneNUmber: arrayofSon[0].cellPhoneNUmber
 , dateofBirth: arrayofSon[0].dateofBirth
 , emailIDStr: arrayofSon[0].emailIDStr
 , empSrNo: arrayofSon[0].empSrNo
 , gender: arrayofSon[0].gender
 , isValid: arrayofSon[0].isValid
 , personName: arrayofSon[0].personName
 , personSrNo: arrayofSon[0].personSrNo
 , productCode: arrayofSon[0].productCode
 , relationID: arrayofSon[0].relationID
 , relationname: arrayofSon[0].relationname
 , isEmpty: arrayofSon[0].isEmpty
 , sortId: arrayofSon[0].sortId
 , twinPair: arrayofSon[0].twinPair
 , isHeader: arrayofSon[0].isHeader
 , premiumAmount: arrayofSon[0].premiumAmount
 , parentPercentage: arrayofSon[0].parentPercentage)
 
 self.structDataSource.append(obj)
 
 
 let obj1 = DependantDBRecords.init(IsSelected: arrayofSon[1].IsSelected, IsApplicable: arrayofSon[1].IsApplicable
 , CanDelete: arrayofSon[1].CanDelete
 , ReasonForNotAbleToDelete: arrayofSon[1].ReasonForNotAbleToDelete
 , CanUpdate: arrayofSon[1].CanUpdate
 , IsTwins: arrayofSon[1].IsTwins
 , ReasonForNotAbleToUpdate: arrayofSon[1].ReasonForNotAbleToUpdate
 , IsDisabled: arrayofSon[1].IsDisabled, PairNo: arrayofSon[1].PairNo
 , age: arrayofSon[1].age
 , cellPhoneNUmber: arrayofSon[1].cellPhoneNUmber
 , dateofBirth: arrayofSon[1].dateofBirth
 , emailIDStr: arrayofSon[1].emailIDStr
 , empSrNo: arrayofSon[1].empSrNo
 , gender: arrayofSon[1].gender
 , isValid: arrayofSon[1].isValid
 , personName: arrayofSon[1].personName
 , personSrNo: arrayofSon[1].personSrNo
 , productCode: arrayofSon[1].productCode
 , relationID: arrayofSon[1].relationID
 , relationname: arrayofSon[1].relationname
 , isEmpty: arrayofSon[1].isEmpty
 , sortId: arrayofSon[1].sortId
 , twinPair: arrayofSon[1].twinPair
 , isHeader: arrayofSon[1].isHeader
 , premiumAmount: arrayofSon[1].premiumAmount
 , parentPercentage: arrayofSon[1].parentPercentage)
 */
