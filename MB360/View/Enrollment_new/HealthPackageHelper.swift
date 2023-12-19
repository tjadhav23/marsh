//
//  HealthPackageHelper.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 26/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
extension HealthPackagesVC {
    
    //http://www.mybenefits360.in/mb360api/api/HealthCheckup/GetHCPackageDepInfo?EmpSrNo=36471&GroupChildSrNo=1275&OeGrpBasInfSrNo=757&ExtGrpsrNo=3
    func getHealthPackagesFromServer() {
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
                
                guard let groupSrNo = UserDefaults.standard.value(forKey: "ExtGroupSrNoEnrollment") as? String else {
                    return
                }
                
                
                
                let url = APIEngine.shared.getHealthPackages(EmpSrNo:empSrNo,GroupChildSrNo:groupChildSrNo,OeGrpBasInfSrNo:oe_group_base_Info_Sr_No,ExtGrpsrNo:groupSrNo)
                
                
                let urlreq = NSURL(string : url)
                
                //self.showPleaseWait(msg: "")
                print(url)
                EnrollmentServerRequestManager.serverInstance.getArrayRequestDataFromServer(url: url, view: self) { (data, error) in
                    
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
                            
                            
                            self.maleArrayHC.removeAll()
                            self.femaleArrayHC.removeAll()
                            self.hcDependantModelArray.removeAll()
                            self.packageArray.removeAll()
                            
                            if let msgDict = data?["MalePackages"].dictionary
                            {
                                print("Admin Data Found")
                                
                                if let packageDetailsArray = msgDict["PackagDetails"]?.array {
                                    
                                    
                                    
                                    for packObj in packageDetailsArray {
                                        print(packObj["PACKAGE_NAME"].string)
                                        
                                        var packName = ""
                                        var price = ""
                                        if let packageName = packObj["PACKAGE_NAME"].string {
                                            packName = packageName
                                        }
                                        if let price1 = packObj["PRICE"].string {
                                            price = price1
                                        }
                                        
                                        var testModelArray = [packageIncludesModel]()
                                        if let testArray = packObj["PackageTest"].array {
                                            for testObj in testArray {
                                                
                                                let testModelObj = packageIncludesModel.init(DIAG_PKG_LST_SR_NO: testObj["DIAG_PKG_LST_SR_NO"].string, DIAG_PKG_TESTS_SR_NO: testObj["DIAG_PKG_TESTS_SR_NO"].string, DIAG_PKG_TEST_DESC: testObj["DIAG_PKG_TEST_DESC"].string, DIAG_PKG_TEST_NAME: testObj["DIAG_PKG_TEST_NAME"].string, IS_ACTIVE: testObj["IS_ACTIVE"].string)
                                                
                                                
                                                
                                                testModelArray.append(testModelObj)
                                            }
                                        }
                                        if price != "-1" {

                                        let finalObj = HealthPackagesModel.init(PRICE: price, PACKAGE_NAME: packName, testArray: testModelArray,gender: "Male")
                                        self.packageArray.append(finalObj)
                                        }
                                    }//outer for
                                    
                                }//status
                            }//male arrray
                            
                            if let msgDict = data?["FemalePackages"].dictionary
                            {
                                print("Admin Data Found")
                                
                                if let packageDetailsArray = msgDict["PackagDetails"]?.array {
                                    for packObj in packageDetailsArray {
                                        print(packObj["PACKAGE_NAME"].string)
                                        
                                        var packName = ""
                                        var price = ""
                                        if let packageName = packObj["PACKAGE_NAME"].string {
                                            packName = packageName
                                        }
                                        if let price1 = packObj["PRICE"].string {
                                            price = price1
                                        }
                                        
                                        var testModelArray = [packageIncludesModel]()
                                        if let testArray = packObj["PackageTest"].array {
                                            for testObj in testArray {
                                                
                                                let testModelObj = packageIncludesModel.init(DIAG_PKG_LST_SR_NO: testObj["DIAG_PKG_LST_SR_NO"].string, DIAG_PKG_TESTS_SR_NO: testObj["DIAG_PKG_TESTS_SR_NO"].string, DIAG_PKG_TEST_DESC: testObj["DIAG_PKG_TEST_DESC"].string, DIAG_PKG_TEST_NAME: testObj["DIAG_PKG_TEST_NAME"].string, IS_ACTIVE: testObj["IS_ACTIVE"].string)
                                                
                                                
                                                
                                                testModelArray.append(testModelObj)
                                            }
                                        }
                                        
                                        if price != "-1" {
                                        let finalObj = HealthPackagesModel.init(PRICE: price, PACKAGE_NAME: packName, testArray: testModelArray,gender: "Female")
                                        self.packageArray.append(finalObj)
                                        }
                                    }//outer for
                                    
                                }//status
                            }
                            
                            if let allDepDict = data?["AllDependands"].dictionary
                            {
                                print("Admin Data Found")
                                
                                if let dependantArray = allDepDict["DepaendantDetails"]?.array {
                                    for packObj in dependantArray {

                                        let objc = HCDependantModel.init(Age: packObj["Age"].string, DateOfBirth: packObj["DateOfBirth"].string, Disabled: packObj["Disabled"].string, Gender: packObj["Gender"].string, IsSelected: packObj["IsSelected"].boolValue, Name: packObj["Name"].string, PackageSrNo: packObj["PackageSrNo"].string, PersonSrNo: packObj["PersonSrNo"].string, Relation: packObj["Relation"].string, RelationID: packObj["RelationID"].string)
                                        self.hcDependantModelArray.append(objc)
                                        
                                        
                                    }//outer for
                                    
                                }//status
                            }
                            
                            self.maleArrayHC = self.hcDependantModelArray.filter({$0.Gender?.lowercased() == "male" || $0.Gender?.lowercased() == "other" })
                            self.femaleArrayHC = self.hcDependantModelArray.filter({$0.Gender?.lowercased() == "female" || $0.Gender?.lowercased() == "other" })

                            self.tableView.reloadData()
                            
                        }//jsonResult
                            
                            
                        catch let JSONError as NSError
                        {
                            print(JSONError)
                        }
                    }//else
                }//server call
            }//userArray
        }
    }
    
    func optHealthCheckupAPI(urlSec:String) {
        
        guard let IsWindowPeriodOpen = UserDefaults.standard.value(forKey: "IsWindowPeriodOpen") as? String else {
                       return
                   }
        
        guard let IsEnrollmentSaved = UserDefaults.standard.value(forKey: "IsEnrollmentSaved") as? String else {
            return
        }
        
                   
                   if IsWindowPeriodOpen == "1" && IsEnrollmentSaved == "0" {

        
        print("SECOND CHILD...")
        if(isConnectedToNetWithAlert())
        {
            
            let urlreq = NSURL(string : urlSec)
            
            //self.showPleaseWait(msg: "")
            print(urlSec)
            let dict = ["":""]
            
            EnrollmentServerRequestManager.serverInstance.postDataToServer(url: urlSec, dictionary: dict as NSDictionary, view: self) { (data, error) in
                
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
                        if let jsonResult = data?.dictionary
                        {
                            print("optHealthCheckupAPI Data Found")
                            
                            if let status = jsonResult["Status"]?.bool {
                                
                                if status == true
                                {
                                    self.getHealthPackagesFromServer()
                                    
                                }
                                else {
                                    //No Data found
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
        }
        }
        
    }
    
    
    
    
    
    
    
    
    /*
    func getPersonDetails()
    {
        maleArray=[]
        femaleArray.removeAll()
        // m_membersRelationIdArray=[]
        //  m_membersArray=[]
        m_productCode="GMC"
        
        let array = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: m_spouse)
        if(array.count>0)
        {
            femaleArray.append(array[0])
        }
        
        let arrayOFSelf = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "EMPLOYEE")
        if(arrayOFSelf.count>0)
        {
            if arrayOFSelf[0].gender?.lowercased() == "male" {
            maleArray.append(arrayOFSelf[0])
            }
            else {
                femaleArray.append(arrayOFSelf[0])
            }
        }
        
        
        let arrayofSon = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "SON")
        if(arrayofSon.count>0)
        {
            
            if(arrayofSon.count==2)
            {
                maleArray.append(arrayofSon[0])
                maleArray.append(arrayofSon[1])
            }
            else if(arrayofSon.count==3)
            {
                maleArray.append(arrayofSon[0])
                maleArray.append(arrayofSon[1])
                maleArray.append(arrayofSon[2])
            }
            else
            {
                maleArray.append(arrayofSon[0])
            }
        }
        
        
        let arrayofDaughter = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "DAUGHTER")
        if(arrayofDaughter.count>0)
        {
            if(arrayofDaughter.count==2)
            {
                femaleArray.append(arrayofDaughter[0])
                femaleArray.append(arrayofDaughter[1])
            }
            else if(arrayofDaughter.count==3)
            {
                femaleArray.append(arrayofDaughter[0])
                femaleArray.append(arrayofDaughter[1])
                femaleArray.append(arrayofDaughter[2])
            }
            else
            {
                femaleArray.append(arrayofDaughter[0])
            }
        }
        
        let fatherarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "FATHER")
        if(fatherarray.count>0)
        {
            maleArray.append(fatherarray[0])
        }
        let motherarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "MOTHER")
        if(motherarray.count>0)
        {
            femaleArray.append(motherarray[0])
        }
        let fatherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "FATHER-IN-LAW")
        if(fatherInLawarray.count>0)
        {
            maleArray.append(fatherInLawarray[0])
        }
        let motherInLawarray = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: m_productCode, relationName: "MOTHER-IN-LAW")
        if(motherInLawarray.count>0)
        {
            femaleArray.append(motherInLawarray[0])
        }
        
        maleArray.append(contentsOf: femaleArray)
        self.tableView.reloadData()
        print(femaleArray)
        print(maleArray)
        // getRelationsfromServer()
        
        
    }
    */
}
*/

struct HCDependantModel {
    
    var Age : String?
    var DateOfBirth : String?
    var Disabled : String?
    var Gender : String?
    var IsSelected = false
    var Name : String?
    var PackageSrNo : String?
    var PersonSrNo : String?
    var Relation  : String?
    var RelationID  : String?
}


struct HealthPackagesModel {
    var PRICE : String?
    var PACKAGE_NAME: String
    var testArray = [packageIncludesModel]()
    var gender : String?
}

struct packageIncludesModel {
    
    var DIAG_PKG_LST_SR_NO :String?
    var DIAG_PKG_TESTS_SR_NO :String?
    var DIAG_PKG_TEST_DESC :String?
    var DIAG_PKG_TEST_NAME :String?
    var IS_ACTIVE :String?
}
