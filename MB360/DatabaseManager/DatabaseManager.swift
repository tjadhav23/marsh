//
//  DatabaseManager.swift
//  MyBenefits
//
//  Created by Semantic on 11/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import CoreData


var Timestamp: TimeInterval
{
    return NSDate().timeIntervalSince1970 * 1000
}

class DatabaseManager: NSObject
{

        static let sharedInstance = DatabaseManager()
        class func getSharedInstance()-> DatabaseManager
        {
            return sharedInstance
            
        }
        
        var m_tableNames = ["EmployeeDetails","EnrollmentDetails","Intimations","ContactDetails","NetworkHospitalsDetails","ProfileDetails","PolicyFeature","PolicyFeaturesDetails","PolicyAnnexure","MyClaimsDetails","DependantDetails","OE_GROUP_CHILD_MASTER","OE_GROUP_BASIC_INFORMATION","EnrollmentGroupRelations","Queries","TopupDetails","OverviewDetails"]
    
        var employeeDetailsTable = "EmployeeDetails"
        var enrollmentDetailsTable = "EnrollmentDetails"
        var intimationTable = "Intimations"
        var contactDetailsTable = "ContactDetails"
    var coveragePolicyTable = "CoveragePolicyData"
    var coveragesDetailsTable = "CoveragesDetails"
    var faqDetailsTable = "FaqDetails"
    var utilitiesTable = "UtilitiesDetails"
        var hospitalDetailsTable = "NetworkHospitalsDetails"
        var profileDetailsTable = "ProfileDetails"
        var policyFeaturesTable = "PolicyFeature"
        var policyFeaturesDetailsTable = "PolicyFeaturesDetails"
    
        var PolicyAnnexureTable = "PolicyAnnexure"
        var myClaimDetailsTable = "MyClaimsDetails"
        var dependantsDetailsTable = "DependantDetails"
        var topupDetailsTable = "TopupDetails"
        var parentsPremiumDetailsTable = "ParentsPremiumDetails"

        var groupChildMasterDetailsTable = "OE_GROUP_CHILD_MASTER"
        var groupBasicInfoDetailsTable = "OE_GROUP_BASIC_INFORMATION"
        var employeeInformationTable = "EMPLOYEE_INFORMATION"
        var personInformationTable = "PERSON_INFORMATION"
        var enrollmentGroupRelationsTable = "EnrollmentGroupRelations"
        var queriesTable = "Queries"
    
        var overviewTable = "OverviewDetails"
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
        var GROUPCHILDSRNOValue = 0
    
   //MARK:- GroupChildMasterDetailsTable
    //MARK:-
//    func saveGroupChildMasterDetails(groupDetailsDict: NSDictionary)
//    {
//        print("groupDetailsDict : ",groupDetailsDict)
//        let managedContext = appDelegate.managedObjectContext
//
//        //let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
//
//        let employee = NSEntityDescription.insertNewObject(forEntityName: groupChildMasterDetailsTable, into: managedContext) as! OE_GROUP_CHILD_MASTER
//
//        let GROUPCHILDSRNO = (groupDetailsDict.value(forKey: "GROUPCHILDSRNO")as! NSString).integerValue
//        GROUPCHILDSRNOValue = GROUPCHILDSRNO
//        let GROUPCODE = groupDetailsDict.value(forKey:"GROUPCODE")
//        let GROUPNAME = groupDetailsDict.value(forKey: "GROUPNAME")
//
//        if let groupCodeString = groupDetailsDict.value(forKey:"GROUPCODE") as? String {
//        UserDefaults.standard.set(groupCodeString, forKey: "groupCodeString")
//            print("groupCodeString :",groupCodeString)
//            print("UserDefaults :",UserDefaults.standard.set(groupCodeString, forKey: "groupCodeString"))
//        }
//
//        employee.groupChildSrNo=Int32(GROUPCHILDSRNO)
//        employee.groupCode=GROUPCODE as? String
//        employee.groupName=GROUPNAME as? String
//
//        do {
//            try managedContext.save()
//            //5
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//    }
    
    func saveGroupChildMasterDetails(groupDetailsDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: groupChildMasterDetailsTable, into: managedContext) as! OE_GROUP_CHILD_MASTER
        
        let GROUPCHILDSRNO = (groupDetailsDict.value(forKey: "GROUPCHILDSRNO")as! NSString).integerValue
        let GROUPCODE = groupDetailsDict.value(forKey:"GROUPCODE")
        let GROUPNAME = groupDetailsDict.value(forKey: "GROUPNAME")
        
        if let groupCodeString = groupDetailsDict.value(forKey:"GROUPCODE") as? String {
        UserDefaults.standard.set(groupCodeString, forKey: "groupCodeString")
            print("groupCodeString :",groupCodeString)
            print("UserDefaults :",UserDefaults.standard.set(groupCodeString, forKey: "groupCodeString"))
        }
       
        employee.groupChildSrNo=Int32(GROUPCHILDSRNO)
        employee.groupCode=GROUPCODE as? String
        employee.groupName=GROUPNAME as? String
        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    func retrieveGroupChildMasterDetails(productCode:String) ->Array<OE_GROUP_CHILD_MASTER>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<OE_GROUP_CHILD_MASTER>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:groupChildMasterDetailsTable)
        if (productCode==""){
            
        }    else {
            
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
            fetchRequest.returnsObjectsAsFaults=false
        }
        
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [OE_GROUP_CHILD_MASTER]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }
    
    func deleteGroupChildMasterDetails(productCode : String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:groupChildMasterDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    //MARK:- GroupBasicInfoDetailsTable
    //MARK:-
//    func saveGroupBasicInfoDetails(groupDetailsDict: NSDictionary)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
//
//        let employee = NSEntityDescription.insertNewObject(forEntityName: groupBasicInfoDetailsTable, into: managedContext) as! OE_GROUP_BASIC_INFORMATION
//
////        let context = NSPersistentContainer.viewContext
//        let employee1 = EMPLOYEE_INFORMATION(context: managedContext)
//
//        let TPACODE = groupDetailsDict.value(forKey: "tpa_code")
//        let TPANAME = groupDetailsDict.value(forKey:"tpa_name")
//        let INSCODE = groupDetailsDict.value(forKey: "ins_co_code")as? String
//        let INSNAME = groupDetailsDict.value(forKey: "ins_co_name")
//        let active = groupDetailsDict.value(forKey: "active")
//        let POLICYNO = groupDetailsDict.value(forKey: "policy_number")as? String
//        let POLICYCOMMDT = groupDetailsDict.value(forKey: "policy_commencement_date")
//        let POLICYVALIDUPTO = groupDetailsDict.value(forKey: "policy_validupto_date")
//        let isActive = groupDetailsDict.value(forKey: "active")
//        let OE_GRP_BAS_INF_SR_NO = employee1.oe_group_base_Info_Sr_No
//        let PRODUCTCODE = groupDetailsDict.value(forKey: "ProductCode")
//        let broker = groupDetailsDict.value(forKey: "BROKER_NAME")
//
//
//
////        employee.groupChildSrNo=GROUPCHILDSRNO as? String
//
//        employee.ins_Code=INSCODE
//        employee.ins_Name=INSNAME as? String
//        employee.policyComencmentDate=POLICYCOMMDT as? String
//        employee.policyNumber=POLICYNO as? String
//        employee.policyValidUpto=POLICYVALIDUPTO as? String
//        employee.productCode=PRODUCTCODE as? String
//        employee.tpa_Code=TPACODE as? String
//        employee.tpa_Name=TPANAME as? String
//        employee.oE_GRP_BAS_INF_SR_NO = Int32(OE_GRP_BAS_INF_SR_NO)
//        employee.isActive=isActive as? String
//        employee.brokerName=broker as? String
//
////        employee. = BROKERNAME as? String
//
//
//
//        do {
//            try managedContext.save()
//            //5
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//
//    }
    
    func saveGroupBasicInfoDetails(groupDetailsDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: groupBasicInfoDetailsTable, into: managedContext) as! OE_GROUP_BASIC_INFORMATION
        
//        let context = NSPersistentContainer.viewContext
        let employee1 = EMPLOYEE_INFORMATION(context: managedContext)
        
        let TPACODE = groupDetailsDict.value(forKey: "tpa_code")
        let TPANAME = groupDetailsDict.value(forKey:"tpa_name")
        let INSCODE = groupDetailsDict.value(forKey: "ins_co_code")as? String
        let INSNAME = groupDetailsDict.value(forKey: "ins_co_name")
        let active = groupDetailsDict.value(forKey: "active")
        let POLICYNO = groupDetailsDict.value(forKey: "policy_number")as? String
        let POLICYCOMMDT = groupDetailsDict.value(forKey: "policy_commencement_date")
        let POLICYVALIDUPTO = groupDetailsDict.value(forKey: "policy_validupto_date")
        let isActive = groupDetailsDict.value(forKey: "active")
        let OE_GRP_BAS_INF_SR_NO = employee1.oe_group_base_Info_Sr_No
        let PRODUCTCODE = groupDetailsDict.value(forKey: "ProductCode")
        let broker = groupDetailsDict.value(forKey: "BROKER_NAME")
       
   
      
//        employee.groupChildSrNo=GROUPCHILDSRNO as? String
        
        employee.ins_Code=INSCODE
        employee.ins_Name=INSNAME as? String
        employee.policyComencmentDate=POLICYCOMMDT as? String
        employee.policyNumber=POLICYNO as? String
        employee.policyValidUpto=POLICYVALIDUPTO as? String
        employee.productCode=PRODUCTCODE as? String
        employee.tpa_Code=TPACODE as? String
        employee.tpa_Name=TPANAME as? String
        employee.oE_GRP_BAS_INF_SR_NO = Int32(OE_GRP_BAS_INF_SR_NO)
        employee.isActive=isActive as? String
        employee.brokerName=broker as? String
        
        
        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    
    func retrieveGroupBasicInfoDetails(productCode:String) ->Array<OE_GROUP_BASIC_INFORMATION>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<OE_GROUP_BASIC_INFORMATION>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:groupBasicInfoDetailsTable)
        if (productCode=="")
        {
            fetchRequest.predicate=NSPredicate(format:"isActive == %@","ACTIVE")
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@ && isActive == %@",productCode,"ACTIVE")
            
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [OE_GROUP_BASIC_INFORMATION]
            let len =  records.count
            print("Data fetch count \(len)")
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        enrollmentDetailsArray=enrollmentDetailsArray.sorted(by: { $0.oE_GRP_BAS_INF_SR_NO < $1.oE_GRP_BAS_INF_SR_NO })
        print("enrollmentDetailsArray From Table: ",enrollmentDetailsArray)
        
        return enrollmentDetailsArray
    }
    
    func retrieveGroupBasicInfoDetailsEmpSr(productCode:String) ->Array<OE_GROUP_BASIC_INFORMATION>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<OE_GROUP_BASIC_INFORMATION>=[];
        
        
        let OE_GRP_BAS_INF_SR_NO = Int(getOE_GroupBaseNo(productCode: productCode))
        print("OE_GRP_BAS_INF_SR_NO: ",OE_GRP_BAS_INF_SR_NO)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:groupBasicInfoDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            print("OE_GRP_BAS_INF_SR_NO: ",OE_GRP_BAS_INF_SR_NO ?? 0)
            fetchRequest.predicate=NSPredicate(format:"productCode == %@ && isActive == %@ && oE_GRP_BAS_INF_SR_NO == \(OE_GRP_BAS_INF_SR_NO ?? 0)",productCode,"ACTIVE")
            
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [OE_GROUP_BASIC_INFORMATION]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }

    func retrieveGroupBasicInfoDetailsEmpSr(productCode:String , oegrpBasicInfo: Int64) ->Array<OE_GROUP_BASIC_INFORMATION>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<OE_GROUP_BASIC_INFORMATION>=[];
        
        
        //let OE_GRP_BAS_INF_SR_NO = Int(getOE_GroupBaseNo(productCode: productCode))
        let OE_GRP_BAS_INF_SR_NO = oegrpBasicInfo
        print("OE_GRP_BAS_INF_SR_NO: ",oegrpBasicInfo)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:groupBasicInfoDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            //fetchRequest.predicate=NSPredicate(format:"productCode == %@ && isActive == %@ && oE_GRP_BAS_INF_SR_NO == \(OE_GRP_BAS_INF_SR_NO ?? 0)",productCode,"ACTIVE")
            fetchRequest.predicate=NSPredicate(format:"productCode == %@ && isActive == %@ && oE_GRP_BAS_INF_SR_NO == \(OE_GRP_BAS_INF_SR_NO)",productCode,"ACTIVE")
            
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [OE_GROUP_BASIC_INFORMATION]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }
    
    func retrieveGroupBasicInfoDetailsEmpSr(oegrpBasicInfo:Int64) ->Array<OE_GROUP_BASIC_INFORMATION>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<OE_GROUP_BASIC_INFORMATION>=[];
        
        
        let OE_GRP_BAS_INF_SR_NO = Int(oegrpBasicInfo)//Int(getOE_GroupBaseNo(productCode: productCode))
        print("OE_GRP_BAS_INF_SR_NO: ",OE_GRP_BAS_INF_SR_NO)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:groupBasicInfoDetailsTable)
        if (oegrpBasicInfo==0)
        {
            
        }
        else
        {
            print("OE_GRP_BAS_INF_SR_NO: ",OE_GRP_BAS_INF_SR_NO ?? 0)
            fetchRequest.predicate=NSPredicate(format:"isActive == %@ && oE_GRP_BAS_INF_SR_NO == \(OE_GRP_BAS_INF_SR_NO ?? 0)","ACTIVE")
            
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [OE_GROUP_BASIC_INFORMATION]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        print("enrollmentDetailsArray: ",enrollmentDetailsArray)
        return enrollmentDetailsArray
    }
    
    
    func deleteGroupBasicInfoDetails(productCode : String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:groupBasicInfoDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    
    
    //MARK:- EmployeeInformationTable
    //MARK:-
    
//    func saveEmployeeDetails(enrollmentDetailsDict: NSDictionary,productCode:String)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
//
//        let employee = NSEntityDescription.insertNewObject(forEntityName: employeeInformationTable, into: managedContext) as! EMPLOYEE_INFORMATION
//
//        let GROUPCHILDSRNO = (enrollmentDetailsDict.value(forKey: "groupchildsrno")as! NSString).integerValue
//        let OE_GRP_BAS_INF_SR_NO = (enrollmentDetailsDict.value(forKey:"oe_grp_bas_inf_sr_no")as! NSString).integerValue
//        let date_of_joining = enrollmentDetailsDict.value(forKey: "date_of_joining")
//        let official_e_mail_id = enrollmentDetailsDict.value(forKey: "official_e_mail_id")
//        let department = enrollmentDetailsDict.value(forKey: "department")
//        let grade = enrollmentDetailsDict.value(forKey: "grade")
//        let EMPLOYEEID = enrollmentDetailsDict.value(forKey: "employee_id")
//        let designation = enrollmentDetailsDict.value(forKey: "designation")
//        let EMPLOYEESRNO = (enrollmentDetailsDict.value(forKey: "employee_sr_no")as! NSString).integerValue
//        let base_suminsured = enrollmentDetailsDict.value(forKey: "base_suminsured")
//        let topup_suminsured = enrollmentDetailsDict.value(forKey: "topup_suminsured")
//        let date_of_datainsert = enrollmentDetailsDict.value(forKey: "date_of_datainsert")
//        let topup_si_opted_flag = enrollmentDetailsDict.value(forKey: "topup_si_opted_flag")
//        let topup_si_opted = enrollmentDetailsDict.value(forKey: "topup_si_opted")
//        let topup_si_pk = enrollmentDetailsDict.value(forKey: "topup_si_pk")
//        let topup_si_premium = enrollmentDetailsDict.value(forKey: "topup_si_premium")
//
//
//        employee.dtaeOfJoining=date_of_joining as? String
//        employee.dateofDataInsert=date_of_datainsert as? String // Geeta
//        employee.officialEmailID=official_e_mail_id as? String
//        employee.empIDNo=EMPLOYEEID as? String
//        employee.empSrNo=Int64(EMPLOYEESRNO)
//        employee.groupChildSrNo=Int64(GROUPCHILDSRNO)
//        employee.department=department as? String
//        employee.productCode=productCode as? String
//        employee.grade=grade as? String
//        employee.designation=designation as? String
//        employee.oe_group_base_Info_Sr_No=Int64(OE_GRP_BAS_INF_SR_NO)
//        employee.baseSumInsured = base_suminsured as? String
//        employee.topupSumInsured = topup_suminsured as? String
//        employee.topupoptedflag = topup_si_opted_flag as? String
//        employee.topupoptedAmount = topup_si_opted as? String
//        employee.topupSrNo = topup_si_pk as? String
//        employee.topupSIPremium = topup_si_premium as? String
//
//        do {
//            try managedContext.save()
//            //5
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//
//    }
    func saveEmployeeDetails(enrollmentDetailsDict: NSDictionary,productCode:String)
    {
        let managedContext = appDelegate.managedObjectContext
        
        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: employeeInformationTable, into: managedContext) as! EMPLOYEE_INFORMATION
        
        let GROUPCHILDSRNO = (enrollmentDetailsDict.value(forKey: "groupchildsrno")as! NSString).integerValue
        let OE_GRP_BAS_INF_SR_NO = (enrollmentDetailsDict.value(forKey:"oe_grp_bas_inf_sr_no")as! NSString).integerValue
        let date_of_joining = enrollmentDetailsDict.value(forKey: "date_of_joining")
        let official_e_mail_id = enrollmentDetailsDict.value(forKey: "official_e_mail_id")
        let department = enrollmentDetailsDict.value(forKey: "department")
        let grade = enrollmentDetailsDict.value(forKey: "grade")
        let EMPLOYEEID = enrollmentDetailsDict.value(forKey: "employee_id")
        let designation = enrollmentDetailsDict.value(forKey: "designation")
        let EMPLOYEESRNO = (enrollmentDetailsDict.value(forKey: "employee_sr_no")as! NSString).integerValue
        let base_suminsured = enrollmentDetailsDict.value(forKey: "base_suminsured")
        let topup_suminsured = enrollmentDetailsDict.value(forKey: "topup_suminsured")
        let date_of_datainsert = enrollmentDetailsDict.value(forKey: "date_of_datainsert")
        let topup_si_opted_flag = enrollmentDetailsDict.value(forKey: "topup_si_opted_flag")
        let topup_si_opted = enrollmentDetailsDict.value(forKey: "topup_si_opted")
        let topup_si_pk = enrollmentDetailsDict.value(forKey: "topup_si_pk")
        let topup_si_premium = enrollmentDetailsDict.value(forKey: "topup_si_premium")
        
       
        employee.dtaeOfJoining=date_of_joining as? String
        employee.officialEmailID=official_e_mail_id as? String
        employee.empIDNo=EMPLOYEEID as? String
        employee.empSrNo=Int64(EMPLOYEESRNO)
        employee.groupChildSrNo=Int64(GROUPCHILDSRNO)
        employee.department=department as? String
        employee.productCode=productCode as? String
        employee.grade=grade as? String
        employee.designation=designation as? String
        employee.oe_group_base_Info_Sr_No=Int64(OE_GRP_BAS_INF_SR_NO)
        employee.baseSumInsured = base_suminsured as? String
        employee.topupSumInsured = topup_suminsured as? String
        employee.topupoptedflag = topup_si_opted_flag as? String
        employee.topupoptedAmount = topup_si_opted as? String
        employee.topupSrNo = topup_si_pk as? String
        employee.topupSIPremium = topup_si_premium as? String
        managedContext.perform{
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
        
    }
    
    
    func retrieveEmployeeDetails(productCode:String) ->Array<EMPLOYEE_INFORMATION>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<EMPLOYEE_INFORMATION>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:employeeInformationTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
            
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [EMPLOYEE_INFORMATION]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        print("enrollmentDetailsArray",enrollmentDetailsArray)
        return enrollmentDetailsArray
    }
    
    func deleteEmployeeDetails(productCode : String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:employeeInformationTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        managedContext.perform{
        do {
            print("deleteEmployeeDetails success")
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }
        
        return true
        
    }
    
    //MARK:- parentsPremiumDetailsTable
    //MARK:-
    func saveParentalPremiumDetails(enrollmentDetailsDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: parentsPremiumDetailsTable, into: managedContext) as! ParentsPremiumDetails
        
        employee.isParentsCovered = enrollmentDetailsDict.value(forKey: "ParentsCoveredInBasePolicy") as? String
        var premium = String()
        
        let keyArray = ["Premium","ParentsCoveredInBasePolicy","CrossCombinationOfParentsAllowed"]
        let relationsArray : NSArray = enrollmentDetailsDict.allKeys as NSArray
        for i in 0..<relationsArray.count
        {
            if(keyArray.contains(relationsArray[i] as! String))
            {
                
            }
            else
            {
                employee.relation=relationsArray[i] as? String
                employee.premium=enrollmentDetailsDict.value(forKey: "Premium") as? String
                employee.sumInsured=enrollmentDetailsDict.value(forKey: relationsArray[i] as! String) as? String
                
            }
            
        }
        
        
        
        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }

    
    func retrieveParentalPremiumDetails(relation:String) ->Array<ParentsPremiumDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<ParentsPremiumDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:parentsPremiumDetailsTable)
        if (relation=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"relation == %@",relation)
            
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [ParentsPremiumDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }
    
    func deleteParentalPremiumDetails(productCode : String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:parentsPremiumDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }

    //MARK:- personInformationTable
    //MARK:-
//    func savePersonDetails(personDetailsDict: NSDictionary)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        let person = NSEntityDescription.insertNewObject(forEntityName: personInformationTable, into: managedContext) as! PERSON_INFORMATION
//
//        let person_sr_no = (personDetailsDict.value(forKey: "person_sr_no")as! NSString).integerValue
//        let employee_sr_no = (personDetailsDict.value(forKey:"employee_sr_no")as! NSString).integerValue
//        let age = (personDetailsDict.value(forKey: "age")as! NSString).integerValue
//        let date_of_birth = personDetailsDict.value(forKey: "date_of_birth")
//        let cellphone_no = personDetailsDict.value(forKey: "cellphone_no")
//        let emrgcellphone_no = personDetailsDict.value(forKey: "emrgcellphone_no")// Added by Geeta
//        let person_name = personDetailsDict.value(forKey: "person_name")
//        let gender : String = personDetailsDict.value(forKey: "gender") as! String
//        var relationname :String = personDetailsDict.value(forKey: "relationname")as? String ?? ""
//        if(relationname=="SPOUSE")
//        {
//            if(gender=="Male")
//            {
//                relationname="HUSBAND"
//            }
//            else
//            {
//                relationname="WIFE"
//            }
//        }
//        let relationid = (personDetailsDict.value(forKey: "relationid")as! NSString).integerValue
//
//        var isEmployeePresentCount = 0
//
//        let array = retrievePersonDetails(productCode: "")
//        if(array.count>0)
//        {
//            for dict in array
//            {
//                if(dict.relationname=="EMPLOYEE")
//                {
//                    isEmployeePresentCount=isEmployeePresentCount+1
//
//                }
//
//            }
//
//            if(isEmployeePresentCount==0 && relationname=="EMPLOYEE")
//            {
//                person.personSrNo=Int32(person_sr_no)
//                person.age=Int32(age)
//                person.cellPhoneNUmber=cellphone_no as? String
//                person.emrgContactNumber=emrgcellphone_no as? String
//                person.dateofBirth=date_of_birth as? String
//                person.emailID=""
//                person.empSrNo=Int32(employee_sr_no)
//                person.gender=gender as? String
//                person.isValid=Int16(1)
//                person.personName=person_name as? String
//                person.relationID=Int32(relationid)
//                person.relationname=relationname as? String
//                person.productCode="GMC"
//                do {
//                    try managedContext.save()
//                    //5
//                } catch let error as NSError  {
//                    print("Could not save \(error), \(error.userInfo)")
//                }
//
//            }
//            else if(isEmployeePresentCount==1 && relationname=="EMPLOYEE")
//            {
//                person.personSrNo=Int32(person_sr_no)
//                person.age=Int32(age)
//                person.cellPhoneNUmber=cellphone_no as? String
//                person.emrgContactNumber=emrgcellphone_no as? String
//                person.dateofBirth=date_of_birth as? String
//                person.emailID=""
//                person.empSrNo=Int32(employee_sr_no)
//                person.gender=gender as? String
//                person.isValid=Int16(1)
//                person.personName=person_name as? String
//                person.relationID=Int32(relationid)
//                person.relationname=relationname as? String
//                person.productCode="GPA"
//                do {
//                    try managedContext.save()
//                    //5
//                } catch let error as NSError  {
//                    print("Could not save \(error), \(error.userInfo)")
//                }
//                isGPAEmployee=true
//            }
//            else if(isGPAEmployee==true && relationname=="EMPLOYEE")
//            {
//                person.personSrNo=Int32(person_sr_no)
//                person.age=Int32(age)
//                person.cellPhoneNUmber=cellphone_no as? String
//                person.emrgContactNumber=emrgcellphone_no as? String
//                person.dateofBirth=date_of_birth as? String
//                person.emailID=""
//                person.empSrNo=Int32(employee_sr_no)
//                person.gender=gender as? String
//                person.isValid=Int16(1)
//                person.personName=person_name as? String
//                person.relationID=Int32(relationid)
//                person.relationname=relationname as? String
//                person.productCode="GTL"
//                do {
//                    try managedContext.save()
//                    //5
//                } catch let error as NSError  {
//                    print("Could not save \(error), \(error.userInfo)")
//                }
//
//            }
//            else
//            {
//                person.personSrNo=Int32(person_sr_no)
//                person.age=Int32(age)
//                person.cellPhoneNUmber=cellphone_no as? String
//                person.emrgContactNumber=emrgcellphone_no as? String
//                person.dateofBirth=date_of_birth as? String
//                person.emailID=""
//                person.empSrNo=Int32(employee_sr_no)
//                person.gender=gender as? String
//                person.isValid=Int16(1)
//                person.personName=person_name as? String
//                person.relationID=Int32(relationid)
//                person.relationname=relationname as? String
//                person.productCode="GMC"
//                do {
//                    try managedContext.save()
//                    //5
//                } catch let error as NSError  {
//                    print("Could not save \(error), \(error.userInfo)")
//                }
//
//            }
//
//        }
//        else
//        {
//            person.personSrNo=Int32(person_sr_no)
//            person.age=Int32(age)
//            person.cellPhoneNUmber=cellphone_no as? String
//            person.emrgContactNumber=emrgcellphone_no as? String
//            person.dateofBirth=date_of_birth as? String
//            person.emailID=""
//            person.empSrNo=Int32(employee_sr_no)
//            person.gender=gender as? String
//            person.isValid=Int16(1)
//            person.personName=person_name as? String
//            person.relationID=Int32(relationid)
//            person.relationname=relationname as? String
//            person.productCode="GMC"
//            do {
//                try managedContext.save()
//                //5
//            } catch let error as NSError  {
//                print("Could not save \(error), \(error.userInfo)")
//            }
//        }
//
//    }
    
    func savePersonDetails(personDetailsDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let person = NSEntityDescription.insertNewObject(forEntityName: personInformationTable, into: managedContext) as! PERSON_INFORMATION
        
        let person_sr_no = (personDetailsDict.value(forKey: "person_sr_no")as! NSString).integerValue
        let employee_sr_no = (personDetailsDict.value(forKey:"employee_sr_no")as! NSString).integerValue
        let age = (personDetailsDict.value(forKey: "age")as! NSString).integerValue
        let date_of_birth = personDetailsDict.value(forKey: "date_of_birth")
        let cellphone_no = personDetailsDict.value(forKey: "cellphone_no")
        let person_name = personDetailsDict.value(forKey: "person_name")
        let gender : String = personDetailsDict.value(forKey: "gender") as! String
        var relationname :String = personDetailsDict.value(forKey: "relationname")as? String ?? ""
        if(relationname=="SPOUSE")
        {
            if(gender=="Male")
            {
                relationname="HUSBAND"
            }
            else
            {
                relationname="WIFE"
            }
        }
        let relationid = (personDetailsDict.value(forKey: "relationid")as! NSString).integerValue
        
        var isEmployeePresentCount = 0
        
        let array = retrievePersonDetails(productCode: "")
        if(array.count>0)
        {
            for dict in array
            {
                if(dict.relationname=="EMPLOYEE")
                {
                    isEmployeePresentCount=isEmployeePresentCount+1
                    
                }
                
            }
            
            if(isEmployeePresentCount==0 && relationname=="EMPLOYEE")
            {
                person.personSrNo=Int32(person_sr_no)
                person.age=Int32(age)
                person.cellPhoneNUmber=cellphone_no as? String
                person.dateofBirth=date_of_birth as? String
                person.emailID=""
                person.empSrNo=Int32(employee_sr_no)
                person.gender=gender as? String
                person.isValid=Int16(1)
                person.personName=person_name as? String
                person.relationID=Int32(relationid)
                person.relationname=relationname as? String
                person.productCode="GMC"
                do {
                    try managedContext.save()
                    //5
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            }
            else if(isEmployeePresentCount==1 && relationname=="EMPLOYEE")
            {
                person.personSrNo=Int32(person_sr_no)
                person.age=Int32(age)
                person.cellPhoneNUmber=cellphone_no as? String
                person.dateofBirth=date_of_birth as? String
                person.emailID=""
                person.empSrNo=Int32(employee_sr_no)
                person.gender=gender as? String
                person.isValid=Int16(1)
                person.personName=person_name as? String
                person.relationID=Int32(relationid)
                person.relationname=relationname as? String
                person.productCode="GPA"
                do {
                    try managedContext.save()
                    //5
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                isGPAEmployee=true
            }
            else if(isGPAEmployee==true && relationname=="EMPLOYEE")
            {
                person.personSrNo=Int32(person_sr_no)
                person.age=Int32(age)
                person.cellPhoneNUmber=cellphone_no as? String
                person.dateofBirth=date_of_birth as? String
                person.emailID=""
                person.empSrNo=Int32(employee_sr_no)
                person.gender=gender as? String
                person.isValid=Int16(1)
                person.personName=person_name as? String
                person.relationID=Int32(relationid)
                person.relationname=relationname as? String
                person.productCode="GTL"
                do {
                    try managedContext.save()
                    //5
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            }
            else
            {
                person.personSrNo=Int32(person_sr_no)
                person.age=Int32(age)
                person.cellPhoneNUmber=cellphone_no as? String
                person.dateofBirth=date_of_birth as? String
                person.emailID=""
                person.empSrNo=Int32(employee_sr_no)
                person.gender=gender as? String
                person.isValid=Int16(1)
                person.personName=person_name as? String
                person.relationID=Int32(relationid)
                person.relationname=relationname as? String
                person.productCode="GMC"
                do {
                    try managedContext.save()
                    //5
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            }
            
        }
        else
        {
            person.personSrNo=Int32(person_sr_no)
            person.age=Int32(age)
            person.cellPhoneNUmber=cellphone_no as? String
            person.dateofBirth=date_of_birth as? String
            person.emailID=""
            person.empSrNo=Int32(employee_sr_no)
            person.gender=gender as? String
            person.isValid=Int16(1)
            person.personName=person_name as? String
            person.relationID=Int32(relationid)
            person.relationname=relationname as? String
            person.productCode="GMC"
            do {
                try managedContext.save()
                //5
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
    }
    
    func retrievePersonDetails(productCode:String) ->Array<PERSON_INFORMATION>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<PERSON_INFORMATION>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:personInformationTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
            
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [PERSON_INFORMATION]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }
    
    func retrieveEmployeePersonDetails(productCode:String,relationName:String) ->Array<PERSON_INFORMATION>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<PERSON_INFORMATION>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:personInformationTable)
        if (productCode=="")
        {
            print("BLANK PRODUCT CODE")
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"relationname == %@ && productCode == %@",relationName,productCode)
            
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [PERSON_INFORMATION]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }
    
    func retrieveEmployeePersonDetails(oegrpBasicInfo:Int64) ->Array<PERSON_INFORMATION>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<PERSON_INFORMATION>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:personInformationTable)
        if (oegrpBasicInfo==0)
        {
            print("BLANK oegrpBasicInfo CODE")
        }
        else
        {
            print("oegrpBasicInfo: ",oegrpBasicInfo)
            //fetchRequest.predicate=NSPredicate(format:"oE_GRP_BAS_INF_SR_NO == %@",oegrpBasicInfo)
            fetchRequest.predicate=NSPredicate(format:"isActive == %@ && oE_GRP_BAS_INF_SR_NO == \(oegrpBasicInfo ?? 0)","ACTIVE")
      
            
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [PERSON_INFORMATION]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }
    //MARK:- Used in Wellness
    //MARK:- personInformationTable
    func retrieveEmployeePersonDetails(productCode:String) ->Array<PERSON_INFORMATION>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<PERSON_INFORMATION>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:personInformationTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"relationname == %@",productCode)
            
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [PERSON_INFORMATION]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }
    
    func deletePersonDetails(personSrNo : String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        let contextQueue = DispatchQueue(label: "com.example.app.contextQueue")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:personInformationTable)
        if (personSrNo=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"personSrNo == %@",personSrNo)
        }
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        managedContext.perform{
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not delete deletepersondetails \(error), \(error.userInfo)")
            }
        }
        
        return true
        
    }
    
    //MARK:- enrollmentDetailsTable
    //MARK:-
    
    func saveEnrollmentDetails(enrollmentDetailsDict: NSDictionary,productCode:String)
        {
            let managedContext = appDelegate.managedObjectContext
            
//            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
            
            let enrollment = NSEntityDescription.insertNewObject(forEntityName: enrollmentDetailsTable, into: managedContext) as! EnrollmentDetails
            
            let id = enrollmentDetailsDict.value(forKey: "EMPLOYEE_ID")
            let GROUPNAME = enrollmentDetailsDict.value(forKey:"GROUPNAME")
            let BENEFICIARY_NAME = enrollmentDetailsDict.value(forKey: "BENEFICIARY_NAME")
            let AGE = enrollmentDetailsDict.value(forKey: "AGE")
            let DATE_OF_BIRTH = enrollmentDetailsDict.value(forKey:"DATE_OF_BIRTH")
            let RELATION_WITH_EMPLOYEE = enrollmentDetailsDict.value(forKey: "RELATION_WITH_EMPLOYEE")as? String
            let BASE_SUM_INSURED = enrollmentDetailsDict.value(forKey: "BASE_SUM_INSURED")
            let TOPUP_SUM_INSURED = enrollmentDetailsDict.value(forKey:"TOPUP_SUM_INSURED")
            let SI_TABLED = enrollmentDetailsDict.value(forKey: "SI_TABLED")
            let SI_TABLEC = enrollmentDetailsDict.value(forKey: "SI_TABLEC")
            let SI_TABLEB = enrollmentDetailsDict.value(forKey: "SI_TABLEB")
            let SI_TABLEA = enrollmentDetailsDict.value(forKey: "SI_TABLEA")
            let TOTAL_SI = enrollmentDetailsDict.value(forKey: "TOTAL_SI")
            let CRITICAL_ILLNESS_SUM_INSURED = enrollmentDetailsDict.value(forKey: "CRITICAL_ILLNESS_SUM_INSURED")
            let ACC_DEATH_BENEFIT_SUM_INSURED = enrollmentDetailsDict.value(forKey: "ACC_DEATH_BENEFIT_SUM_INSURED")
            let TERMINAL_ILLNESS_SUM_INSURED = enrollmentDetailsDict.value(forKey: "TERMINAL_ILLNESS_SUM_INSURED")
            let PERMNT_TOT_DISAB_SUM_INSURED = enrollmentDetailsDict.value(forKey: "PERMNT_TOT_DISAB_SUM_INSURED")
            let PERMNT_PAR_DISAB_SUM_INSURED = enrollmentDetailsDict.value(forKey: "PERMNT_PAR_DISAB_SUM_INSURED")
            let OTHER_SUM_INSURED = enrollmentDetailsDict.value(forKey: "OTHER_SUM_INSURED")
            
            
            enrollment.employee_ID=id as? String
            enrollment.groupName=GROUPNAME as? String
            enrollment.beneficiaryName=BENEFICIARY_NAME as? String
            enrollment.age=AGE as? String
            enrollment.dob=DATE_OF_BIRTH as?String
            enrollment.relation=RELATION_WITH_EMPLOYEE
            enrollment.base_sum_insured=BASE_SUM_INSURED as? String
            enrollment.topUp_sum_insured=TOPUP_SUM_INSURED as? String
            enrollment.si_tableD=SI_TABLED as? String
            enrollment.si_tableC=SI_TABLEC as? String
            enrollment.si_tableB=SI_TABLEB as? String
            enrollment.si_tableA=SI_TABLEA as? String
            enrollment.total_SI=TOTAL_SI as? String
            enrollment.critical_illness_sum_insured=CRITICAL_ILLNESS_SUM_INSURED as? String
            enrollment.acc_death_benefit_sum_insured=ACC_DEATH_BENEFIT_SUM_INSURED as? String
            enrollment.terminal_illness_sum_insured=TERMINAL_ILLNESS_SUM_INSURED as! String?
            enrollment.permnt_tot_disab_sum_insured=PERMNT_TOT_DISAB_SUM_INSURED as? String
            enrollment.permny_per_disab_sum_insured=PERMNT_PAR_DISAB_SUM_INSURED as? String
            enrollment.other_sum_insured=OTHER_SUM_INSURED as? String
            enrollment.productCode=productCode
            
            
            do {
                try managedContext.save()
                //5
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }
    
    
    
    func retrieveEnrollmentDetails(productCode:String) ->Array<EnrollmentDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<EnrollmentDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:enrollmentDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [EnrollmentDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }

    func deleteEnrollmentDetails(productCode : String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:enrollmentDetailsTable)
        fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    //MARK:- intimationTable
    //MARK:-
//    func saveIntimationDetails(intimationDict: NSDictionary)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        let intimation = NSEntityDescription.insertNewObject(forEntityName: intimationTable, into: managedContext) as! Intimations
//
//        print("Intimations: ",intimation)
//
//        /*
//         //Core
//         let  INT_CLM_INTIMATION_NO = intimationDict.value(forKey: "IntimationNumber")
//         let CLM_INT_CLAIMANT = intimationDict.value(forKey: "Claimant")
//         let INT_CLM_INTIMATION_DT = intimationDict.value(forKey:"IntimationDate")
//         let INT_CLM_HOSPITAL = intimationDict.value(forKey: "HospitalName")
//         let INT_CLM_DOA_LIKELYDOA = intimationDict.value(forKey: "DateOfAdmission")
//         let INT_CLM_CLAIM_AMOUNT = intimationDict.value(forKey:"ClaimAmount")
//         let INT_CLM_DIAGNOSIS_OR_AILMENT = intimationDict.value(forKey: "DiagnosisAilment")as? String
//
//         print("\(INT_CLM_INTIMATION_NO) , \(INT_CLM_DIAGNOSIS_OR_AILMENT)")
//         intimation.claimNumber=INT_CLM_INTIMATION_NO as? String
//         intimation.claimant=CLM_INT_CLAIMANT as? String
//         intimation.claimIntimationDate=INT_CLM_INTIMATION_DT as? String
//         intimation.claimHospital=INT_CLM_HOSPITAL as? String
//         intimation.dateOfAdmission=INT_CLM_DOA_LIKELYDOA as? String
//         intimation.claimAmount=INT_CLM_CLAIM_AMOUNT as? String
//         intimation.claimDiagnosis=INT_CLM_DIAGNOSIS_OR_AILMENT as? String
//         intimation.timeStamp=Timestamp
//         */
//
//        //Portal
//        let INT_CLM_INTIMATION_NO = intimationDict.value(forKey: "INTIMATION_SR_NO")
//        let CLM_INT_CLAIMANT = intimationDict.value(forKey: "PERSON_NAME")
//        let INT_CLM_INTIMATION_DT = intimationDict.value(forKey:"INTIMATIONS")
//        let EMPLOYEE_NAME = intimationDict.value(forKey: "EMPLOYEE_NAME")//New
//        let EMPLOYEE_NO = intimationDict.value(forKey: "EMPLOYEE_NO")//New
//        let INT_CLM_HOSPITAL = intimationDict.value(forKey: "NAME_OF_HOSPITAL")
//        let INT_CLM_DOA_LIKELYDOA = intimationDict.value(forKey: "DOA_LIKELYDOA")
//        let INT_CLM_DIAGNOSIS_OR_AILMENT = intimationDict.value(forKey: "DIAGNOSIS_OR_AILMENT")as? String
//        let INT_CLM_CLAIM_AMOUNT = intimationDict.value(forKey:"CLAIM_AMOUNT")
//
//         //pending
//        //let CLM_INT_CLAIMANT = intimationDict.value(forKey: "Claimant") //pending
//
//        print("\(INT_CLM_INTIMATION_NO) , \(INT_CLM_DIAGNOSIS_OR_AILMENT)")
//        intimation.claimNumber=INT_CLM_INTIMATION_NO as? String
//        intimation.claimant=CLM_INT_CLAIMANT as? String
//        intimation.claimIntimationDate=INT_CLM_INTIMATION_DT as? String
//        intimation.employee_Name = EMPLOYEE_NAME as? String
//        intimation.employee_No = EMPLOYEE_NO as? String
//        intimation.claimHospital=INT_CLM_HOSPITAL as? String
//        intimation.dateOfAdmission=INT_CLM_DOA_LIKELYDOA as? String
//        intimation.claimDiagnosis=INT_CLM_DIAGNOSIS_OR_AILMENT as? String
//        intimation.claimAmount=INT_CLM_CLAIM_AMOUNT as? String
//        intimation.timeStamp=Timestamp
//
//
//        do {
//            try managedContext.save()
//            //5
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//
//    }
    
    func saveIntimationDetails(intimationDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let intimation = NSEntityDescription.insertNewObject(forEntityName: intimationTable, into: managedContext) as! Intimations
        
        print("Intimations:: ",intimation)
        
        /*
         //Core
         let  INT_CLM_INTIMATION_NO = intimationDict.value(forKey: "IntimationNumber")
         let CLM_INT_CLAIMANT = intimationDict.value(forKey: "Claimant")
         let INT_CLM_INTIMATION_DT = intimationDict.value(forKey:"IntimationDate")
         let INT_CLM_HOSPITAL = intimationDict.value(forKey: "HospitalName")
         let INT_CLM_DOA_LIKELYDOA = intimationDict.value(forKey: "DateOfAdmission")
         let INT_CLM_CLAIM_AMOUNT = intimationDict.value(forKey:"ClaimAmount")
         let INT_CLM_DIAGNOSIS_OR_AILMENT = intimationDict.value(forKey: "DiagnosisAilment")as? String
         
         print("\(INT_CLM_INTIMATION_NO) , \(INT_CLM_DIAGNOSIS_OR_AILMENT)")
         intimation.claimNumber=INT_CLM_INTIMATION_NO as? String
         intimation.claimant=CLM_INT_CLAIMANT as? String
         intimation.claimIntimationDate=INT_CLM_INTIMATION_DT as? String
         intimation.claimHospital=INT_CLM_HOSPITAL as? String
         intimation.dateOfAdmission=INT_CLM_DOA_LIKELYDOA as? String
         intimation.claimAmount=INT_CLM_CLAIM_AMOUNT as? String
         intimation.claimDiagnosis=INT_CLM_DIAGNOSIS_OR_AILMENT as? String
         intimation.timeStamp=Timestamp
         */
        
        //Portal
        let INT_CLM_INTIMATION_NO = intimationDict.value(forKey: "INTIMATION_SR_NO")
        let CLM_INT_CLAIMANT = intimationDict.value(forKey: "PERSON_NAME")
        let INT_CLM_INTIMATION_DT = intimationDict.value(forKey:"INTIMATIONS")
        let EMPLOYEE_NAME = intimationDict.value(forKey: "EMPLOYEE_NAME")//New
        let EMPLOYEE_NO = intimationDict.value(forKey: "EMPLOYEE_NO")//New
        let INT_CLM_HOSPITAL = intimationDict.value(forKey: "NAME_OF_HOSPITAL")
        let INT_CLM_DOA_LIKELYDOA = intimationDict.value(forKey: "DOA_LIKELYDOA")
        let INT_CLM_DIAGNOSIS_OR_AILMENT = intimationDict.value(forKey: "DIAGNOSIS_OR_AILMENT")as? String
        let INT_CLM_CLAIM_AMOUNT = intimationDict.value(forKey:"CLAIM_AMOUNT")
        let INT_CLM_CLAIM_NO = intimationDict.value(forKey:"CLAIM_INTIMATION_NO")
        let INT_CLM_CLAIM_TYPE = intimationDict.value(forKey:"CLAIM_TYPE")
        let INT_CLM_TPA_NO = intimationDict.value(forKey:"TPA_INTIMATION_NO")
        
         //pending
        //let CLM_INT_CLAIMANT = intimationDict.value(forKey: "Claimant") //pending
        
        print("\(INT_CLM_INTIMATION_NO) , \(INT_CLM_DIAGNOSIS_OR_AILMENT)")
        intimation.claimNumber=INT_CLM_INTIMATION_NO as? String
        intimation.claimant=CLM_INT_CLAIMANT as? String
        intimation.claimIntimationDate=INT_CLM_INTIMATION_DT as? String
        intimation.employee_Name = EMPLOYEE_NAME as? String
        intimation.employee_No = EMPLOYEE_NO as? String
        intimation.claimHospital=INT_CLM_HOSPITAL as? String
        intimation.dateOfAdmission=INT_CLM_DOA_LIKELYDOA as? String
        intimation.claimDiagnosis=INT_CLM_DIAGNOSIS_OR_AILMENT as? String
        intimation.claimAmount=INT_CLM_CLAIM_AMOUNT as? String
        intimation.claimIntimationNo=INT_CLM_CLAIM_NO as? String
        intimation.claimType=INT_CLM_CLAIM_TYPE as? String
        intimation.tpaIntimationNo=INT_CLM_TPA_NO as? String
        intimation.timeStamp=Timestamp
        
        print("Intimations::::: ",intimation)
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func retrieveIntimationDetails() ->Array<Intimations>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<Intimations>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:intimationTable)
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [Intimations]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        intimationDetailsArray=intimationDetailsArray.sorted(by: { $0.timeStamp > $1.timeStamp })
        
        return intimationDetailsArray
    }
    
    func deleteIntimationDetails()->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:intimationTable)
       
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    func saveFaqDetails(contactDict: NSDictionary,productCode : String){
        let managedContext = appDelegate.managedObjectContext

        let coverageDetails = NSEntityDescription.insertNewObject(forEntityName: faqDetailsTable, into: managedContext) as! FaqDetails

        var Faq_Question = contactDict.value(forKey: "Faq_Question") as? String
        var Faq_Sr_No = contactDict.value(forKey: "Faq_Sr_No") as? String
        var Faq_Order = contactDict.value(forKey: "Faq_Order") as? String
        var Faq_Ans = contactDict.value(forKey: "Faq_Ans") as? String
        
        

        coverageDetails.faq_Question=Faq_Question as? String
        coverageDetails.faq_Sr_No=Faq_Sr_No as? String
        coverageDetails.faq_Order=Faq_Order as? String
        coverageDetails.faq_Ans=Faq_Ans as? String
        coverageDetails.productCode = productCode as? String


        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }


    }
    
    func retrieveFaqDetails(productCode : String) ->Array<FaqDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<FaqDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:faqDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
            
        }
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [FaqDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
      //  intimationDetailsArray=intimationDetailsArray.sorted(by: { $0.timeStamp > $1.timeStamp })
        
        return intimationDetailsArray
    }
    
    func deleteFaqDetailsData(_ productCode : String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:faqDetailsTable)
       
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    
    
    func saveCoveragesDetails(contactDict: NSDictionary,productCode : String){
        let managedContext = appDelegate.managedObjectContext

        let coverageDetails = NSEntityDescription.insertNewObject(forEntityName: coveragesDetailsTable, into: managedContext) as! CoveragesDetails

        var EMPLOYEE_IDENTIFICATION_NO = (contactDict.value(forKey: "EMPLOYEE_IDENTIFICATION_NO") as? String)?.removeSpecialChars
        var PERSON_NAME = (contactDict.value(forKey: "PERSON_NAME") as? String)?.removeSpecialChars
        var GENDER = (contactDict.value(forKey: "GENDER") as? String)?.removeSpecialChars
        var DATE_OF_BIRTH = (contactDict.value(forKey: "DATE_OF_BIRTH") as? String)?.removeSpecialChars
        var AGE = (contactDict.value(forKey: "AGE") as? String)?.removeSpecialChars
        var SORT_ORDER = (contactDict.value(forKey: "SORT_ORDER") as? String)?.removeSpecialChars
        var RELATION = (contactDict.value(forKey: "RELATION") as? String)?.removeSpecialChars
        var BASE_SUM_INSURED = (contactDict.value(forKey: "BASE_SUM_INSURED") as? String)?.removeSpecialChars
        var TOP_UP_FLAG = (contactDict.value(forKey: "TOP_UP_FLAG") as? String)?.removeSpecialChars
        var TOP_UP_BASE_SUM_INSURED = (contactDict.value(forKey: "TOP_UP_BASE_SUM_INSURED") as? String)
        

        coverageDetails.age=AGE as? String
        coverageDetails.base_sum_insured=BASE_SUM_INSURED as? String
        coverageDetails.dob=DATE_OF_BIRTH as? String
        coverageDetails.emp_id_no=EMPLOYEE_IDENTIFICATION_NO as? String
        coverageDetails.gender=GENDER as? String
        coverageDetails.person_name=PERSON_NAME as? String
        coverageDetails.relation=RELATION as? String
        coverageDetails.sort_order=SORT_ORDER as? String
        coverageDetails.top_up_base_sum_insured=TOP_UP_BASE_SUM_INSURED as? String
        coverageDetails.top_up_flag=TOP_UP_FLAG as? String
        coverageDetails.productCode = productCode


        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }


    }
    
    func retrieveCoveragesDetails(productCode : String) ->Array<CoveragesDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<CoveragesDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:coveragesDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
            
        }
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [CoveragesDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
      //  intimationDetailsArray=intimationDetailsArray.sorted(by: { $0.timeStamp > $1.timeStamp })
        
        return intimationDetailsArray
    }
    
    func deleteCoverageDetailsData(_ productCode : String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:coveragesDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    
    
    
    func saveCoveragesPolicyData(contactDict: NSDictionary,_ productCode : String){
        let managedContext = appDelegate.managedObjectContext

        let coverages = NSEntityDescription.insertNewObject(forEntityName: coveragePolicyTable, into: managedContext) as! CoveragePolicyData

        var GROUPNAME = (contactDict.value(forKey: "GROUPNAME") as? String)?.removeSpecialChars
        var POLICY_NUMBER = (contactDict.value(forKey: "POLICY_NUMBER") as? String)?.removeSpecialChars
        var POLICY_COMMENCEMENT_DATE = (contactDict.value(forKey: "POLICY_COMMENCEMENT_DATE") as? String)?.removeSpecialChars
        var POLICY_VALID_UPTO = (contactDict.value(forKey: "POLICY_VALID_UPTO") as? String)?.removeSpecialChars
        var PRODUCT_CODE = (contactDict.value(forKey: "PRODUCT_CODE") as? String)?.removeSpecialChars
        var TPA_NAME = (contactDict.value(forKey: "TPA_NAME") as? String)?.removeSpecialChars
        var BROKER_NAME = (contactDict.value(forKey: "BROKER_NAME") as? String)?.removeSpecialChars
        var INSURANCE_CO_NAME = (contactDict.value(forKey: "INSURANCE_CO_NAME") as? String)?.removeSpecialChars
        

        coverages.broker_name=BROKER_NAME as? String
        coverages.grpname=GROUPNAME as? String
        coverages.insur_co_name=INSURANCE_CO_NAME as? String
        coverages.policy_commencement_date=POLICY_COMMENCEMENT_DATE as? String
        coverages.product_code=PRODUCT_CODE as? String
        coverages.policy_no=POLICY_NUMBER as? String
        coverages.policy_valid_upto=POLICY_VALID_UPTO as? String
        coverages.tpa_name=TPA_NAME as? String
        coverages.productCode = productCode
       


        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }


    }
    
    func retrieveCoveragesPolicyData(productCode : String) ->Array<CoveragePolicyData>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<CoveragePolicyData>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:coveragePolicyTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
            
        }
        fetchRequest.returnsObjectsAsFaults=false
        print("fetchRequest: ",fetchRequest)
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [CoveragePolicyData]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
      //  intimationDetailsArray=intimationDetailsArray.sorted(by: { $0.timeStamp > $1.timeStamp })
        print("intimationDetailsArray: ",intimationDetailsArray)
        return intimationDetailsArray
    }
    
    func deleteCoveragePolicyData(_ productCode : String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:coveragePolicyTable)
       
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    //MARK:- contactDetailsTable
    //MARK:-
    
//    func saveContactDetails(contactDict: NSDictionary,productCode:String)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        let contacts = NSEntityDescription.insertNewObject(forEntityName: contactDetailsTable, into: managedContext) as! ContactDetails
//
//       /*
//        var ESCALATION = contactDict.value(forKey: "EscalationNo") as? String
//        let PERSON_NAME = contactDict.value(forKey:"EscalationPerson")
//        let ADDRESS = contactDict.value(forKey: "EscalationAddress")
//        let LANDLINE_NO = contactDict.value(forKey: "LandlineNo")
//        let MOBILE_NO = contactDict.value(forKey:"MobileNo")
//        let FAX_NO = contactDict.value(forKey: "EscalationFax")as? String
//        let EMAIL_ID = contactDict.value(forKey: "EscalationEmailID")
//        let CONTACT_TYPE = contactDict.value(forKey:"EscalationType")
//        */
//
//        var ESCALATION = contactDict.value(forKey: "ESCALATION") as? String
//        let PERSON_NAME = contactDict.value(forKey:"CONTACT_PERSON")
//        let ADDRESS = contactDict.value(forKey: "ADDRESS")
//        let LANDLINE_NO = contactDict.value(forKey: "LANDLINE_NO")
//        let MOBILE_NO = contactDict.value(forKey:"MOBILE_NO")
//        let FAX_NO = contactDict.value(forKey: "FAX_NO")as? String
//        let EMAIL_ID = contactDict.value(forKey: "EMAIL")
//        let CONTACT_TYPE = contactDict.value(forKey:"DESCRIPTION")
//
//        if let level = ESCALATION?.components(separatedBy: " ")
//        {
//            if(level.count>1)
//            {
//                if let levelNumber : String? = level[1]
//                {
//                    ESCALATION = levelNumber!
//                }
//            }
//        }
//
//        contacts.escalation=ESCALATION as? String
//        contacts.person_Name=PERSON_NAME as? String
//        contacts.address=ADDRESS as? String
//        contacts.phoneNumber=LANDLINE_NO as? String
//        contacts.mobileNumber=MOBILE_NO as? String
//        contacts.faxNo=FAX_NO
//        contacts.emailID=EMAIL_ID as? String
//        contacts.contactType=CONTACT_TYPE as? String
//        contacts.productCode=productCode
//
//
//        do {
//            try managedContext.save()
//            //5
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//
//    }
    
    func saveUtilities(contactDict: NSDictionary){
        let managedContext = appDelegate.managedObjectContext
        
        let utilities = NSEntityDescription.insertNewObject(forEntityName: utilitiesTable, into: managedContext) as! UtilitiesDetails
        
        var DOWNLOAD_SR_NO = (contactDict.value(forKey: "DOWNLOAD_SR_NO") as? String)?.removeSpecialChars
        var DOWNLOAD_NAME = (contactDict.value(forKey: "DOWNLOAD_NAME") as? String)?.removeSpecialChars
        var DOWNLOAD_DISPLAY_NAME = (contactDict.value(forKey: "DOWNLOAD_DISPLAY_NAME") as? String)?.removeSpecialChars
        var PRODUCT_NAME = (contactDict.value(forKey: "PRODUCT_NAME") as? String)?.removeSpecialChars
        var PRODUCT_CODE = (contactDict.value(forKey: "PRODUCT_CODE") as? String)?.removeSpecialChars
        var DOWNLOAD_VISIBILITY = (contactDict.value(forKey: "DOWNLOAD_VISIBILITY") as? String)?.removeSpecialChars
        var SYS_GEN_FILE_NAME = (contactDict.value(forKey: "SYS_GEN_FILE_NAME") as? String)?.removeSpecialChars
        var FILE_TYPE = (contactDict.value(forKey: "FILE_TYPE") as? String)?.removeSpecialChars
        var GROUPCHILDSRNO = (contactDict.value(forKey: "GROUPCHILDSRNO") as? String)?.removeSpecialChars
        var OE_GRP_BAS_INF_SR_NO = (contactDict.value(forKey: "OE_GRP_BAS_INF_SR_NO") as? String)?.removeSpecialChars
        var FILE_PATH = (contactDict.value(forKey: "FILE_PATH") as? String)?.removeSpecialChars
        
        utilities.download_sr_no=DOWNLOAD_SR_NO as? String
        utilities.download_name=DOWNLOAD_NAME as? String
        utilities.download_display_name=DOWNLOAD_DISPLAY_NAME as? String
        utilities.product_name=PRODUCT_NAME as? String
        utilities.product_code=PRODUCT_CODE as? String
        utilities.download_visibility=DOWNLOAD_VISIBILITY as? String
        utilities.sys_gen_file_name=SYS_GEN_FILE_NAME as? String
        utilities.file_type=FILE_TYPE as? String
        utilities.grp_child_sr_no=GROUPCHILDSRNO as? String
        utilities.oe_grp_base_no = OE_GRP_BAS_INF_SR_NO as? String
        utilities.file_path = FILE_PATH as? String
    
        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
    }
    
    func retrieveUtilitiesDetails(productCode : String) ->Array<UtilitiesDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<UtilitiesDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:utilitiesTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"product_code == %@",productCode)
            
        }
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [UtilitiesDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
      //  intimationDetailsArray=intimationDetailsArray.sorted(by: { $0.timeStamp > $1.timeStamp })
        
        return intimationDetailsArray
    }
    
    func deleteUtilitiesDetails(_ productCode : String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:utilitiesTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"product_code == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    func saveContactDetails(contactDict: NSDictionary,productCode:String)
    {
        
        print("Data passed to save in Contacts ",contactDict)
        let managedContext = appDelegate.managedObjectContext
        
        let contacts = NSEntityDescription.insertNewObject(forEntityName: contactDetailsTable, into: managedContext) as! ContactDetails
        
        
        var ESCALATION = contactDict.value(forKey: "ESCALATION") as? String
        let PERSON_NAME = contactDict.value(forKey:"CONTACT_PERSON")
        let ADDRESS = contactDict.value(forKey: "ADDRESS")
        let LANDLINE_NO = contactDict.value(forKey: "LANDLINE_NO")
        let MOBILE_NO = contactDict.value(forKey:"MOBILE_NO")
        let FAX_NO = contactDict.value(forKey: "FAX_NO")as? String
        let EMAIL_ID = contactDict.value(forKey: "EMAIL")
        let CONTACT_TYPE = contactDict.value(forKey:"DESCRIPTION")
        let ADDITIONAL_TEXT = contactDict.value(forKey:"ADDITIONAL_TEXT")
        let DISP_EMAIL = contactDict.value(forKey:"DISP_EMAIL")
        let DISP_MOB = contactDict.value(forKey:"DISP_MOB")
        let DISP_ADD = contactDict.value(forKey:"DISP_ADD")
        let DISP_FAX = contactDict.value(forKey:"DISP_FAX")
        
        
        contacts.escalation=ESCALATION as? String
        contacts.person_Name=PERSON_NAME as? String
        contacts.address=ADDRESS as? String
        contacts.phoneNumber=LANDLINE_NO as? String
        contacts.mobileNumber=MOBILE_NO as? String
        contacts.faxNo=FAX_NO
        contacts.emailID=EMAIL_ID as? String
        contacts.contactType=CONTACT_TYPE as? String
        contacts.productCode=productCode
        contacts.dispAdd=DISP_ADD as? String
        contacts.dispFax=DISP_FAX as? String
        contacts.dispMob=DISP_MOB as? String
        contacts.dispEmail=DISP_EMAIL as? String
        
        
        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func retrieveContactDetails(productCode:String) ->Array<ContactDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var retrieveContactDetailsArray:Array<ContactDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:contactDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [ContactDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                print("Data records: \(i): ",record)
                retrieveContactDetailsArray.append(record)
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        print("retrieveContactDetailsArray from DB: ",retrieveContactDetailsArray)
        return retrieveContactDetailsArray
    }
    
    func deleteContactDetails(productCode:String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:contactDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    //MARK:- hospitalDetailsTable
    //MARK:-
    
    func saveNetworkHospitalsDetails(contactDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let contacts = NSEntityDescription.insertNewObject(forEntityName: hospitalDetailsTable, into: managedContext) as! NetworkHospitalsDetails
        
        let HOSP_NAME = contactDict.value(forKey: "HOSP_NAME")
        let HOSP_ADDRESS = contactDict.value(forKey:"HOSP_ADDRESS")
        let HOSP_PHONE_NO = contactDict.value(forKey: "HOSP_PHONE_NO")
        let HOSP_LEVEL_OF_CARE = contactDict.value(forKey: "HOSP_LEVEL_OF_CARE")
        let LONGITUDE = contactDict.value(forKey:"LONGITUDE")
        let LATITUDE = contactDict.value(forKey: "LATITUDE")as? String
        
        
        contacts.hosp_name=HOSP_NAME as? String
        contacts.hosp_address=HOSP_ADDRESS as? String
        contacts.hosp_phone_no=HOSP_PHONE_NO as? String
        contacts.hosp_level=HOSP_LEVEL_OF_CARE as? String
        contacts.long=LONGITUDE as? String
        contacts.lat=LATITUDE
        

        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
//
    }
    
    func retrieveHospitalDetails(searchString:String) ->Array<NetworkHospitalsDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<NetworkHospitalsDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:hospitalDetailsTable)
//        if (searchString=="")
//        {
//
//        }
//        else
//        {
//            fetchRequest.predicate=NSPredicate(format:"name == %@",searchString)
//        }
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [NetworkHospitalsDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    
    func deleteHospitalDetails(searchString:String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:hospitalDetailsTable)
//        if (searchString=="")
//        {
//
//        }
//        else
//        {
//            fetchRequest.predicate=NSPredicate(format:"name == %@",searchString)
//        }
//        fetchRequest.returnsObjectsAsFaults=false
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    //MARK:- profileDetailsTable
    //MARK:-
    
    func saveProfileDetails(profileDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: profileDetailsTable, into: managedContext) as! ProfileDetails
        
        let EMPLOYEE_NAME = profileDict.value(forKey: "EMPLOYEE_NAME")
        let EMPLOYEE_DESIGNATION = profileDict.value(forKey:"EMPLOYEE_DESIGNATION")
        let EMPLOYEE_DEPARTMENT = profileDict.value(forKey: "EMPLOYEE_DEPARTMENT")
        let EMPLOYEE_OFFICIAL_EMAIL_ID = profileDict.value(forKey: "EMPLOYEE_OFFICIAL_EMAIL_ID")
        let EMPLOYEE_MOBILENO = profileDict.value(forKey:"EMPLOYEE_MOBILENO")
        let EMPLOYEE_DATE_OF_BIRTH = profileDict.value(forKey: "EMPLOYEE_DATE_OF_BIRTH")as? String
        let EMPLOYEE_GENDER = profileDict.value(forKey: "EMPLOYEE_GENDER")
        let EMP_PER_ADDR_LINE1 = profileDict.value(forKey:"EMP_PER_ADDR_LINE1")
        let EMP_PER_ADDR_LINE2 = profileDict.value(forKey: "EMP_PER_ADDR_LINE2")
        let EMP_PER_ADDR_LANDMARK = profileDict.value(forKey: "EMP_PER_ADDR_LANDMARK")
        let EMP_CITY = profileDict.value(forKey: "EMP_CITY")
        let EMP_STATE = profileDict.value(forKey: "EMP_STATE")
        let EMP_PINCODE = profileDict.value(forKey: "EMP_PINCODE")
        
        let EMP_EMERGENCY_CONTACTNO = profileDict.value(forKey: "EMP_EMERGENCY_CONTACTNO")
        let EMP_PERSONAL_EMAIL_IDS = profileDict.value(forKey: "EMP_PERSONAL_EMAIL_IDS")
        let EMP_EMERGENCY_CONTACT_RELTN = profileDict.value(forKey: "EMP_EMERGENCY_CONTACT_RELTN")
        
       
        
        employee.empName=EMPLOYEE_NAME as? String
        employee.empDesignation=EMPLOYEE_DESIGNATION as? String
        employee.department=EMPLOYEE_DEPARTMENT as? String
        employee.gender=EMPLOYEE_GENDER as? String
        employee.mailIDOfficial=EMPLOYEE_OFFICIAL_EMAIL_ID as? String
        employee.personalEmailID=EMP_PERSONAL_EMAIL_IDS as? String
        employee.address1=EMP_PER_ADDR_LINE1 as? String
        employee.address2=EMP_PER_ADDR_LINE2 as! String
        employee.landmark=EMP_PER_ADDR_LANDMARK as? String
        employee.city=EMP_CITY as? String
        employee.state=EMP_STATE as? String
        employee.mobileNo=EMPLOYEE_MOBILENO as? String
        employee.dateofBirth=EMPLOYEE_DATE_OF_BIRTH as? String
        employee.emergencyContactNo=EMP_EMERGENCY_CONTACTNO as? String
        employee.emergencyContactRelation=EMP_EMERGENCY_CONTACT_RELTN as? String
       
//        employee.oeGroupBasSrNo = EMP_EMERGENCY_CONTACT_RELTN as? String
       
        
        
        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
//    func saveProfileDetailsPortal(profileDict: NSDictionary)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
//
//        let employee = NSEntityDescription.insertNewObject(forEntityName: profileDetailsTable, into: managedContext) as! ProfileDetails
//
//       // print("profileDict: ",profileDict)
//        let UserPersonalDetails : [String : Any] = profileDict.value(forKey: "UserPersonalDetails") as! [String : Any]
//
//        let UserOfficialDetails : [String : Any] = profileDict.value(forKey: "UserOfficialDetails") as! [String : Any]
//
//        let UserAddressDetails : [String : Any] = profileDict.value(forKey: "UserAddressDetails") as! [String : Any]
//
//        let UserDocumentsDetails : [Any]  = profileDict.value(forKey: "UserDocumentsDetails") as! [Any]
//
//
//        let EMPLOYEE_NAME = UserPersonalDetails["EMPLOYEE_NAME"]
//        let EMPLOYEE_DESIGNATION = UserOfficialDetails["DESIGNATION"]
//        let EMPLOYEE_DEPARTMENT = UserOfficialDetails["DEPARTMENT"]
//        let EMPLOYEE_OFFICIAL_EMAIL_ID = UserOfficialDetails["OFFICIAL_E_MAIL_ID"]
//        let EMPLOYEE_MOBILENO = UserPersonalDetails["CELLPHONE_NUMBER"]
//        let EMPLOYEE_DATE_OF_BIRTH = UserPersonalDetails["DATE_OF_BIRTH"]
//        let EMPLOYEE_GENDER = UserPersonalDetails["GENDER"]
//
//        let EMP_PER_ADDR_LINE1 = UserAddressDetails["EMP_PER_ADDR_LINE1"]
//        let EMP_PER_ADDR_LINE2 = UserAddressDetails["EMP_PER_ADDR_LINE2"]
//        let EMP_PER_ADDR_LANDMARK = UserAddressDetails["EMP_PER_ADDR_LANDMARK"]
//        let EMP_CITY = UserAddressDetails["EMP_CITY"]
//        let EMP_STATE = UserAddressDetails["EMP_STATE"]
//        let EMP_PINCODE = UserAddressDetails["EMP_PINCODE"]
//        let EMP_PERSONAL_EMAIL_IDS = UserPersonalDetails["E_MAIL_ID"]
//
//
//
//
//        //let EMP_EMERGENCY_CONTACTNO = profileDict.value(forKey: "EMP_EMERGENCY_CONTACTNO")
//        // let EMP_EMERGENCY_CONTACT_RELTN = profileDict.value(forKey: "EMP_EMERGENCY_CONTACT_RELTN")
//
//
//
//        employee.empName=EMPLOYEE_NAME as? String
//        employee.empDesignation=EMPLOYEE_DESIGNATION as? String
//        employee.department=EMPLOYEE_DEPARTMENT as? String
//        employee.gender=EMPLOYEE_GENDER as? String
//        employee.mailIDOfficial=EMPLOYEE_OFFICIAL_EMAIL_ID as? String
//        employee.personalEmailID=EMP_PERSONAL_EMAIL_IDS as? String
//        employee.address1=EMP_PER_ADDR_LINE1 as? String
//        employee.address2=EMP_PER_ADDR_LINE2 as? String
//        employee.landmark=EMP_PER_ADDR_LANDMARK as? String
//        employee.city=EMP_CITY as? String
//        employee.state=EMP_STATE as? String
//        employee.mobileNo=EMPLOYEE_MOBILENO as? String
//        employee.dateofBirth=EMPLOYEE_DATE_OF_BIRTH as? String
//        employee.pincode=EMP_PINCODE as? String
//
//       // employee.emergencyContactNo=EMP_EMERGENCY_CONTACTNO as? String
//       // employee.emergencyContactRelation=EMP_EMERGENCY_CONTACT_RELTN as? String
//
//        //employee.oeGroupBasSrNo = EMP_EMERGENCY_CONTACT_RELTN as? String
//
//
//
//
//        do {
//            try managedContext.save()
//            //5
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//
//    }
    
    func saveProfileDetailsPortal(profileDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: profileDetailsTable, into: managedContext) as! ProfileDetails
        
       // print("profileDict: ",profileDict)
        let UserPersonalDetails : [String : Any] = profileDict.value(forKey: "UserPersonalDetails") as! [String : Any]
        
        let UserOfficialDetails : [String : Any] = profileDict.value(forKey: "UserOfficialDetails") as! [String : Any]
        
        let UserAddressDetails : [String : Any] = profileDict.value(forKey: "UserAddressDetails") as! [String : Any]
        
        let UserDocumentsDetails : [Any]  = profileDict.value(forKey: "UserDocumentsDetails") as! [Any]
        
        
        let EMPLOYEE_NAME = ((UserPersonalDetails["EMPLOYEE_NAME"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
        print(EMPLOYEE_NAME)
        //let EMPLOYEE_DESIGNATION = UserOfficialDetails["DESIGNATION"]
        let EMPLOYEE_DESIGNATION = ((UserOfficialDetails["DESIGNATION"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
       // let EMPLOYEE_DEPARTMENT = UserOfficialDetails["DEPARTMENT"]
        let EMPLOYEE_DEPARTMENT = ((UserOfficialDetails["DEPARTMENT"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
       // let EMPLOYEE_OFFICIAL_EMAIL_ID = UserOfficialDetails["OFFICIAL_E_MAIL_ID"]
        let EMPLOYEE_OFFICIAL_EMAIL_ID = ((UserOfficialDetails["OFFICIAL_E_MAIL_ID"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
        //let EMPLOYEE_MOBILENO = UserPersonalDetails["CELLPHONE_NUMBER"]
        let EMPLOYEE_MOBILENO = ((UserPersonalDetails["CELLPHONE_NUMBER"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
        //let EMPLOYEE_DATE_OF_BIRTH = UserPersonalDetails["DATE_OF_BIRTH"]
        let EMPLOYEE_DATE_OF_BIRTH = ((UserPersonalDetails["DATE_OF_BIRTH"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
        //let EMPLOYEE_GENDER = UserPersonalDetails["GENDER"]
        let EMPLOYEE_GENDER = ((UserPersonalDetails["GENDER"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
        
        //let EMP_PER_ADDR_LINE1 = UserAddressDetails["EMP_PER_ADDR_LINE1"]
        let EMP_PER_ADDR_LINE1 = ((UserAddressDetails["EMP_PER_ADDR_LINE1"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
        //let EMP_PER_ADDR_LINE2 = UserAddressDetails["EMP_PER_ADDR_LINE2"]
        let EMP_PER_ADDR_LINE2 = ((UserAddressDetails["EMP_PER_ADDR_LINE2"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
       // let EMP_PER_ADDR_LANDMARK = UserAddressDetails["EMP_PER_ADDR_LANDMARK"]
        let EMP_PER_ADDR_LANDMARK = ((UserAddressDetails["EMP_PER_ADDR_LANDMARK"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
        //let EMP_CITY = UserAddressDetails["EMP_CITY"]
        let EMP_CITY = ((UserAddressDetails["EMP_CITY"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
       // let EMP_STATE = UserAddressDetails["EMP_STATE"]
        let EMP_STATE = ((UserAddressDetails["EMP_STATE"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
       // let EMP_PINCODE = UserAddressDetails["EMP_PINCODE"]
        let EMP_PINCODE = ((UserAddressDetails["EMP_PINCODE"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
        //let EMP_PERSONAL_EMAIL_IDS = UserPersonalDetails["E_MAIL_ID"]
        let EMP_PERSONAL_EMAIL_IDS = ((UserPersonalDetails["E_MAIL_ID"] as? String)?.replacingOccurrences(of: " ", with: "") as? String)?.removeSpecialChars
       
       
        
        
        //let EMP_EMERGENCY_CONTACTNO = profileDict.value(forKey: "EMP_EMERGENCY_CONTACTNO")
        // let EMP_EMERGENCY_CONTACT_RELTN = profileDict.value(forKey: "EMP_EMERGENCY_CONTACT_RELTN")
        
       
        
        employee.empName=EMPLOYEE_NAME
        employee.empDesignation=EMPLOYEE_DESIGNATION
        employee.department=EMPLOYEE_DEPARTMENT
        employee.gender=EMPLOYEE_GENDER
        employee.mailIDOfficial=EMPLOYEE_OFFICIAL_EMAIL_ID
        employee.personalEmailID=EMP_PERSONAL_EMAIL_IDS
        employee.address1=EMP_PER_ADDR_LINE1
        employee.address2=EMP_PER_ADDR_LINE2
        employee.landmark=EMP_PER_ADDR_LANDMARK
        employee.city=EMP_CITY
        employee.state=EMP_STATE
        employee.mobileNo=EMPLOYEE_MOBILENO
        employee.dateofBirth=EMPLOYEE_DATE_OF_BIRTH
        employee.pincode=EMP_PINCODE
        
       // employee.emergencyContactNo=EMP_EMERGENCY_CONTACTNO as? String
       // employee.emergencyContactRelation=EMP_EMERGENCY_CONTACT_RELTN as? String
       
        //employee.oeGroupBasSrNo = EMP_EMERGENCY_CONTACT_RELTN as? String
       
        
        
        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func retrieveProfileDetails() ->Array<ProfileDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var profileArray : Array<ProfileDetails>=[]
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:profileDetailsTable)
        
            fetchRequest.returnsObjectsAsFaults=false
      
        do
        {
             let records = try managedContext.fetch(fetchRequest)
            print(records)
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                profileArray.append(record as! ProfileDetails)
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
            return profileArray
    }
    
    func deleteProfileDetails()->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:profileDetailsTable)
       
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    //MARK:- policyFeaturesTable
    //MARK:-
    func savePolicyAnnexures(contactDict: NSDictionary,productCode:String)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let contacts = NSEntityDescription.insertNewObject(forEntityName: policyFeaturesTable, into: managedContext) as! PolicyFeature
        
        let ANNEXURE_NAME = contactDict.value(forKey: "ANNEXURE_NAME")
        let ANNEXURE_DESC = contactDict.value(forKey:"ANNEXURE_DESC")
        let FILE_NAME = contactDict.value(forKey: "FILE_NAME")
        let SYS_GEN_FILE_NAME = contactDict.value(forKey: "SYS_GEN_FILE_NAME")
       
        
        contacts.annexure_name=ANNEXURE_NAME as? String
        contacts.annexure_desc=ANNEXURE_DESC as? String
        contacts.fileName=FILE_NAME as? String
        contacts.systemGeneratedName=SYS_GEN_FILE_NAME as? String
        contacts.productCode=productCode
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func retrievePolicyAnnexures(productCode:String) ->Array<PolicyFeature>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<PolicyFeature>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:policyFeaturesTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [PolicyFeature]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    
    func deletePolicyAnnexures(productCode:String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:policyFeaturesTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    //MARK:- policyFeaturesDetailsTable
    //MARK:-
    
//    func saveNewPolicyFeatures(contactDict: NSDictionary,productCode:String)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        let contacts = NSEntityDescription.insertNewObject(forEntityName: policyFeaturesDetailsTable, into: managedContext) as! PolicyFeaturesDetails
//
//        let POL_FEAT_DISPLAY_TYPE = contactDict.value(forKey: "POL_FEAT_DISPLAY_TYPE")
//        let POL_FEAT_TYPE = contactDict.value(forKey:"POL_FEAT_TYPE")
//        let POL_INFORMATION = contactDict.value(forKey: "POL_INFORMATION")
//        let POL_TERMS_CONDITIONS = contactDict.value(forKey: "POL_TERMS_CONDITIONS")
//        let POL_INFO_DISPLAY_TO = contactDict.value(forKey: "POL_INFO_DISPLAY_TO")
//        if(POL_INFORMATION as? String == "RELATION")
//        {
//            print("familyRelation")
//        }
//        else
//        {
//            contacts.policyFeatureDisplayType=POL_FEAT_DISPLAY_TYPE as? String
//            contacts.policyFeatureType=POL_FEAT_TYPE as? String
//            contacts.policyInfo=POL_INFORMATION as? String
//            contacts.policyTermsCondition=POL_TERMS_CONDITIONS as? String
//            contacts.policyInfoDisplayTo=POL_INFO_DISPLAY_TO as? String
//            contacts.productCode=productCode
//
//            do {
//                try managedContext.save()
//                //5
//            } catch let error as NSError  {
//                print("Could not save \(error), \(error.userInfo)")
//            }
//        }
//
//
//    }
    
    func saveNewPolicyFeatures(contactDict: NSDictionary,productCode:String)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let contacts = NSEntityDescription.insertNewObject(forEntityName: policyFeaturesDetailsTable, into: managedContext) as! PolicyFeaturesDetails
        
        let POL_FEAT_DISPLAY_TYPE = contactDict.value(forKey: "POL_FEAT_DISPLAY_TYPE")
        let POL_FEAT_TYPE = contactDict.value(forKey:"POL_FEAT_TYPE")
        let POL_INFORMATION = contactDict.value(forKey: "POL_INFORMATION")
        let POL_TERMS_CONDITIONS = contactDict.value(forKey: "POL_TERMS_CONDITIONS")
        let POL_INFO_DISPLAY_TO = contactDict.value(forKey: "POL_INFO_DISPLAY_TO")
        if(POL_INFORMATION as? String == "RELATION")
        {
            print("familyRelation")
        }
        else
        {
            contacts.policyFeatureDisplayType=POL_FEAT_DISPLAY_TYPE as? String
            contacts.policyFeatureType=POL_FEAT_TYPE as? String
            contacts.policyInfo=POL_INFORMATION as? String
            contacts.policyTermsCondition=POL_TERMS_CONDITIONS as? String
            contacts.policyInfoDisplayTo=POL_INFO_DISPLAY_TO as? String
            contacts.productCode=productCode
            
            do {
                try managedContext.save()
                //5
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        
    }
    
    func savePolicyFeatures(contactDict: NSDictionary,productCode:String,policyIDType:Int)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let contacts = NSEntityDescription.insertNewObject(forEntityName: policyFeaturesDetailsTable, into: managedContext) as! PolicyFeaturesDetails
        
        let POL_FEAT_DISPLAY_TYPE = contactDict.value(forKey: "POL_FEAT_DISPLAY_TYPE")
        let POL_FEAT_TYPE = contactDict.value(forKey:"POL_FEAT_TYPE")
        let POL_INFORMATION = contactDict.value(forKey: "POL_INFORMATION")
        let POL_TERMS_CONDITIONS = contactDict.value(forKey: "POL_TERMS_CONDITIONS")
        let POL_INFO_DISPLAY_TO = contactDict.value(forKey: "POL_INFO_DISPLAY_TO")
        if(POL_INFORMATION as? String == "RELATION")
        {
           print("familyRelation")
        }
        else
        {
            contacts.policyFeatureDisplayType=POL_FEAT_DISPLAY_TYPE as? String
            contacts.policyFeatureType=POL_FEAT_TYPE as? String
            contacts.policyInfo=POL_INFORMATION as? String
            contacts.policyTermsCondition=POL_TERMS_CONDITIONS as? String
            contacts.policyInfoDisplayTo=POL_INFO_DISPLAY_TO as? String
            contacts.productCode=productCode
            contacts.policyID=Int32(policyIDType)
            do {
                try managedContext.save()
                //5
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        
    }
    func retrievePolicyFeaturesByName(productCode:String, name:String) ->Array<PolicyFeaturesDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<PolicyFeaturesDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:policyFeaturesDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@ && policyFeatureType==%@",productCode,name)
        }
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [PolicyFeaturesDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    func retrievePolicyFeatures(productCode:String) ->Array<PolicyFeaturesDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<PolicyFeaturesDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:policyFeaturesDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [PolicyFeaturesDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    func retrievePolicyFeaturesbyID(productCode:String,ID : Int) ->Array<PolicyFeaturesDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<PolicyFeaturesDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:policyFeaturesDetailsTable)
        if (ID<0 || ID==0)
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"policyID == %d && productCode == %@",ID,productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [PolicyFeaturesDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    func deletePolicyFeatures(productCode:String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:policyFeaturesDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    //MARK:- PolicyAnnexureTable
    //MARK:-
    func saveAnnexuresforTcl(contactDict: NSDictionary,productCode:String)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let contacts = NSEntityDescription.insertNewObject(forEntityName: PolicyAnnexureTable, into: managedContext) as! PolicyAnnexure
        
        let ANNEXURE_NAME = contactDict.value(forKey: "ANNEXURE_NAME")
        let ANNEXURE_DESC = contactDict.value(forKey:"ANNEXURE_DESC")
        let ANNEXURE_PATH = contactDict.value(forKey: "ANNEXURE_PATH")
        
        
        
        contacts.annexureName=ANNEXURE_NAME as? String
        contacts.annexureDesc=ANNEXURE_DESC as? String
        contacts.annexurePath=ANNEXURE_PATH as? String
       
        contacts.productCode=productCode
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func retrieveAnnexuresforTcl(productCode:String) ->Array<PolicyAnnexure>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<PolicyAnnexure>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:PolicyAnnexureTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [PolicyAnnexure]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    
    func deleteAnnexuresforTcl(productCode:String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:PolicyAnnexureTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    //MARK:- myClaimDetailsTable
    //MARK:-
//    func saveMyClaimDetails(contactDict: NSDictionary)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        let contacts = NSEntityDescription.insertNewObject(forEntityName: myClaimDetailsTable, into: managedContext) as! MyClaimsDetails
//        print("Database error log")
//        let BENEFICIARY = contactDict.value(forKey: "BeneficiaryName")
//        let TYPE_OF_CLAIM = contactDict.value(forKey:"ClaimType")
//        let TOTAL_CLAIM_AMT = contactDict.value(forKey: "ClaimAmount")
//        let CLAIM_DATE = contactDict.value(forKey: "ClaimDate")
//        let RELATION = contactDict.value(forKey: "RelationWithEmployee")
//        let CLAIM_Number = contactDict.value(forKey: "ClaimNo")
//        let status = contactDict.value(forKey: "ClaimStatus")
//        let claimSrNo = contactDict.value(forKey: "ClaimSrNo")
//
//        contacts.claimType=TYPE_OF_CLAIM as? String
//        contacts.beneficiary=BENEFICIARY as? String
//        contacts.claimAmount=TOTAL_CLAIM_AMT as? String
//        contacts.claimDate=CLAIM_DATE as? String
//        contacts.relation=RELATION as? String
//        contacts.claimNumber=CLAIM_Number as? String
//        contacts.claimStatus=status as? String
//        contacts.claimSrNo=claimSrNo as? String
//        print("Database error log")
//        do {
//            try managedContext.save()
//            //5
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//
//    }
    
    func saveMyClaimDetails(contactDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let contacts = NSEntityDescription.insertNewObject(forEntityName: myClaimDetailsTable, into: managedContext) as! MyClaimsDetails
        print("Database error log saveMyClaimDetails 3112")
        let BENEFICIARY = contactDict.value(forKey: "BENEFICIARY")
        let TYPE_OF_CLAIM = contactDict.value(forKey:"CLAIM_TYPE")
        let TOTAL_CLAIM_AMT = contactDict.value(forKey: "CLAIM_AMT")
        let CLAIM_DATE = contactDict.value(forKey: "CLAIM_DATE")
        let RELATION = contactDict.value(forKey: "RELATION_WITH_EMPLOYEE")
        let CLAIM_Number = contactDict.value(forKey: "CLAIM_NO")
        let status = contactDict.value(forKey: "CLAIM_STATUS")
        let claimSrNo = contactDict.value(forKey: "CLAIM_SR_NO")
        
        contacts.claimType=TYPE_OF_CLAIM as? String
        contacts.beneficiary=BENEFICIARY as? String
        contacts.claimAmount=TOTAL_CLAIM_AMT as? String
        contacts.claimDate=CLAIM_DATE as? String
        contacts.relation=RELATION as? String
        contacts.claimNumber=CLAIM_Number as? String
        contacts.claimStatus=status as? String
        contacts.claimSrNo=claimSrNo as? String
        print("Database error log saveMyClaimDetails 3130")
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func retrieveMyClaimDetails() ->Array<MyClaimsDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<MyClaimsDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:myClaimDetailsTable)
       
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [MyClaimsDetails]
            print("retrieveMyClaimDetails records:::",records)
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    func retrieveMyClaimsbyType(type:String) ->Array<MyClaimsDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<MyClaimsDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:myClaimDetailsTable)
        if (type=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"claimType == %@",type)
        }
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [MyClaimsDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    func deleteClaimDetails()->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:myClaimDetailsTable)
       
       
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    //MARK:- dependantsDetailsTable
    //MARK:-
    
    func saveDependantDetails(contactDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let contacts = NSEntityDescription.insertNewObject(forEntityName: dependantsDetailsTable, into: managedContext) as! DependantDetails
        
        let DEPENDANT_RELATION = contactDict.value(forKey: "DEPENDANT_RELATION")
        let DEPENDANT_RELATION_ID = contactDict.value(forKey:"DEPENDANT_RELATION_ID")
        let DEPENDANT_NAME = contactDict.value(forKey: "DEPENDANT_NAME")
        let DEPENDANT_DOB = contactDict.value(forKey: "DEPENDANT_DOB")
        let DEPENDANT_AGE = contactDict.value(forKey: "DEPENDANT_AGE")
        let PERSON_SR_NO = contactDict.value(forKey: "PERSON_SR_NO")
        
        contacts.dependantRelation=DEPENDANT_RELATION as? String
        contacts.dependantID=DEPENDANT_RELATION_ID as? String
        contacts.name=DEPENDANT_NAME as? String
        contacts.dob=DEPENDANT_DOB as? String
        contacts.age=DEPENDANT_AGE as? String
        contacts.personSrNo=PERSON_SR_NO as? String
        
        
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func retrieveDependantDetails() ->Array<DependantDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<DependantDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:dependantsDetailsTable)
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [DependantDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    func retrieveSpouseDetails() ->Array<DependantDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<DependantDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:dependantsDetailsTable)
        
        fetchRequest.predicate=NSPredicate(format:"dependantRelation == Son")
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [DependantDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    func retrieveDaughterDetails() ->Array<DependantDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<DependantDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:dependantsDetailsTable)
        
        fetchRequest.predicate=NSPredicate(format:"dependantRelation == Daughter")
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [DependantDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    func retrieveSonDetails() ->Array<DependantDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<DependantDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:dependantsDetailsTable)
        
        fetchRequest.predicate=NSPredicate(format:"dependantRelation == Daughter")
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [DependantDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return intimationDetailsArray
    }
    
    func deleteDependantDetails()->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:dependantsDetailsTable)
        
        
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    func deleteDependantDetailswithRelation(relation:String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:dependantsDetailsTable)
        
        
        fetchRequest.predicate=NSPredicate(format:"dependantRelation == %@",relation)
        fetchRequest.returnsObjectsAsFaults=false
        
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    //MARK:- enrollmentGroupRelationsTable
    //MARK:-
    func saveEnrollmentGroupRelatoionsDetails(contactDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let contacts = NSEntityDescription.insertNewObject(forEntityName: enrollmentGroupRelationsTable, into: managedContext) as! EnrollmentGroupRelations
        print("Database error log saveEnrollmentGroupRelatoionsDetails 3435")
        let RelationName = contactDict.value(forKey: "RelationName")
        let RelationID = contactDict.value(forKey:"RelationID")
        let MinAge = contactDict.value(forKey: "MinAge")
        let MaxAge = contactDict.value(forKey: "MaxAge")
        
        contacts.relationName=RelationName as? String
        contacts.relationID=RelationID as? String
        contacts.minAge=MinAge as? String
        contacts.maxAge=MaxAge as? String
        
        print("Database error log saveEnrollmentGroupRelatoionsDetails 3446")
        managedContext.perform{
            do {
                try managedContext.save()
                //5
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
    }
    
    func retrieveEnrollmentGroupRelationsDetails(relation:String) ->Array<EnrollmentGroupRelations>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<EnrollmentGroupRelations>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:enrollmentGroupRelationsTable)
        if(relation != "")
        {
            fetchRequest.predicate=NSPredicate(format:"relationName == %@",relation)
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        DispatchQueue.main.async{
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [EnrollmentGroupRelations]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
        
        return intimationDetailsArray
    }
    
    func deleteEnrollmentGroupRelationsDetails()->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:enrollmentGroupRelationsTable)
        
        
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        managedContext.perform{
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }
        
        return true
        
    }
    
    //MARK:- queriesTable
    //MARK:-
//    func saveEmployeeQueries(queryDict: NSDictionary)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        let contacts = NSEntityDescription.insertNewObject(forEntityName: queriesTable, into: managedContext) as! Queries
//        print("Database error log")
//        let EQ_CUST_QRY_SR_NO = queryDict.value(forKey: "EQ_CUST_QRY_SR_NO")
//        let TICKET_NUMBER = queryDict.value(forKey:"TICKET_NUMBER")
//        let COMPLETE_QUERY_TEXT = queryDict.value(forKey: "PARTIAL_QUERY_TEXT")
//        let POSTED_DATE = queryDict.value(forKey: "POSTED_DATE")
//        let PERSON_NAME = queryDict.value(forKey: "PERSON_NAME")
//        let EMPLOYEE_SR_NO = queryDict.value(forKey: "EMPLOYEE_SR_NO")
//        let EQ_CUST_QRY_SOLVED = queryDict.value(forKey: "EQ_CUST_QRY_SOLVED")
//        let NO_OF_REPLIES = queryDict.value(forKey:"NO_OF_REPLIES")
//        let EQ_CUST_QRY_ENDED = queryDict.value(forKey: "EQ_CUST_QRY_ENDED")
//        let LAST_REPLY = queryDict.value(forKey: "LAST_REPLY")
//
//        contacts.queryNo=EQ_CUST_QRY_SR_NO as? String
//        contacts.personName=PERSON_NAME as? String
//        contacts.empSrNo=EMPLOYEE_SR_NO as? String
//        contacts.completeQueryText=COMPLETE_QUERY_TEXT as? String
//        contacts.postedDate=POSTED_DATE as? String
//        contacts.ticketNumber=TICKET_NUMBER as? String
//        contacts.noofReplies=NO_OF_REPLIES as? String
//        contacts.querySolvedStatus=EQ_CUST_QRY_SOLVED as? String
//        contacts.queryEndedStatus=EQ_CUST_QRY_ENDED as? String
//        contacts.lastReply=LAST_REPLY as? String
//
//
//        print("Database error log")
//        do {
//            try managedContext.save()
//            //5
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//
//    }
    
   
   
    func saveEmployeeQueries(queryDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let contacts = NSEntityDescription.insertNewObject(forEntityName: queriesTable, into: managedContext) as! Queries
        print("Database error log saveEmployeeQueries 3566")
        let EQ_CUST_QRY_SR_NO = queryDict.value(forKey: "EQ_CUST_QRY_SR_NO")
        print("EQ_CUST_QRY_SR_NO: ",EQ_CUST_QRY_SR_NO)
        let TICKET_NUMBER = queryDict.value(forKey:"TICKET_NUMBER")
        print("TICKET_NUMBER: ",TICKET_NUMBER)
        let COMPLETE_QUERY_TEXT = queryDict.value(forKey: "COMPLETE_QUERY_TEXT")//PARTIAL_QUERY_TEXT
        print("COMPLETE_QUERY_TEXT: ",COMPLETE_QUERY_TEXT)
        let POSTED_DATE = queryDict.value(forKey: "POSTED_DATE")
        print("POSTED_DATE: ",POSTED_DATE)
        let PERSON_NAME = queryDict.value(forKey: "PERSON_NAME")
        print("PERSON_NAME: ",PERSON_NAME)
        let EMPLOYEE_SR_NO = queryDict.value(forKey: "EMPLOYEE_SR_NO")
        print("EMPLOYEE_SR_NO: ",EMPLOYEE_SR_NO)
        let EQ_CUST_QRY_SOLVED = queryDict.value(forKey: "EQ_CUST_QRY_SOLVED")
        print("EQ_CUST_QRY_SOLVED: ",EQ_CUST_QRY_SOLVED)
        let NO_OF_REPLIES = queryDict.value(forKey:"NO_OF_REPLIES")
        print("NO_OF_REPLIES: ",NO_OF_REPLIES)
        let EQ_CUST_QRY_ENDED = queryDict.value(forKey: "EQ_CUST_QRY_ENDED")
        print("EQ_CUST_QRY_ENDED: ",EQ_CUST_QRY_ENDED)
        let LAST_REPLY = queryDict.value(forKey: "LAST_REPLY")
        print("LAST_REPLY: ",LAST_REPLY)
        
       
        contacts.queryNo=EQ_CUST_QRY_SR_NO as? String
        contacts.personName=PERSON_NAME as? String
        contacts.empSrNo=EMPLOYEE_SR_NO as? String
        contacts.completeQueryText=COMPLETE_QUERY_TEXT as? String
        contacts.postedDate=POSTED_DATE as? String
        var TICKET_NUMBER_int = (TICKET_NUMBER as! NSString).integerValue
        var TICKET_NUMBER_int32 = Int32(TICKET_NUMBER_int)
        contacts.ticketNumber=TICKET_NUMBER_int32
        contacts.noofReplies=NO_OF_REPLIES as? String
        contacts.querySolvedStatus=EQ_CUST_QRY_SOLVED as? String
        contacts.queryEndedStatus=EQ_CUST_QRY_ENDED as? String
        contacts.lastReply=LAST_REPLY as? String
       
        
        print("Database error log saveEmployeeQueries 3592")
        managedContext.perform{
            do {
                try managedContext.save()
                //5
            } catch let error as NSError  {
                print("Could not save saveEmployeeQueries \(error), \(error.userInfo)")
            }
        }
        
    }
    
    /* //23May23Shubham Commected for crash in contacts.ticketNumber=TICKET_NUMBER_int32
    func saveEmployeeQueries(queryDict: NSDictionary) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate is not available.")
            return
        }

        guard let managedContext = appDelegate.managedObjectContext else {
            print("Managed object context is not available.")
            return
        }
        guard let contacts = NSEntityDescription.insertNewObject(forEntityName: queriesTable, into: managedContext) as? Queries else {
            print("Failed to create a new 'Queries' object.")
            return
        }
        
        print("Database error log saveEmployeeQueries 3566")
        
        if let EQ_CUST_QRY_SR_NO = queryDict.value(forKey: "EQ_CUST_QRY_SR_NO") as? String {
            contacts.queryNo = EQ_CUST_QRY_SR_NO
        }
        
        if let TICKET_NUMBER = queryDict.value(forKey: "TICKET_NUMBER") as? String {
            if let ticketNumberInt = Int(TICKET_NUMBER) {
                contacts.ticketNumber = Int32(ticketNumberInt)
            } else {
                contacts.ticketNumber = 0
                print("Invalid 'TICKET_NUMBER' value.")
            }
        }
        
        if let COMPLETE_QUERY_TEXT = queryDict.value(forKey: "COMPLETE_QUERY_TEXT") as? String {
            contacts.completeQueryText = COMPLETE_QUERY_TEXT
        }
        
        if let POSTED_DATE = queryDict.value(forKey: "POSTED_DATE") as? String {
            contacts.postedDate = POSTED_DATE
        }
        
        if let PERSON_NAME = queryDict.value(forKey: "PERSON_NAME") as? String {
            contacts.personName = PERSON_NAME
        }
        
        if let EMPLOYEE_SR_NO = queryDict.value(forKey: "EMPLOYEE_SR_NO") as? String {
            contacts.empSrNo = EMPLOYEE_SR_NO
        }
        
        if let EQ_CUST_QRY_SOLVED = queryDict.value(forKey: "EQ_CUST_QRY_SOLVED") as? String {
            contacts.querySolvedStatus = EQ_CUST_QRY_SOLVED
        }
        
        if let NO_OF_REPLIES = queryDict.value(forKey: "NO_OF_REPLIES") as? String {
            contacts.noofReplies = NO_OF_REPLIES
        }
        
        if let EQ_CUST_QRY_ENDED = queryDict.value(forKey: "EQ_CUST_QRY_ENDED") as? String {
            contacts.queryEndedStatus = EQ_CUST_QRY_ENDED
        }
        
        if let LAST_REPLY = queryDict.value(forKey: "LAST_REPLY") as? String {
            contacts.lastReply = LAST_REPLY
        }
        
        print("Database error log saveEmployeeQueries 3592")
        
        managedContext.perform {
            do {
                try managedContext.save()
                // Saved successfully
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
     */
    
    func retrieveQueries() ->Array<Queries>
    {
        let managedContext = appDelegate.managedObjectContext
        var intimationDetailsArray:Array<Queries>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:queriesTable)
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [Queries]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                intimationDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        //enrollmentDetailsArray=enrollmentDetailsArray.sorted(by: { $0.oE_GRP_BAS_INF_SR_NO < $1.oE_GRP_BAS_INF_SR_NO })
        
        intimationDetailsArray = intimationDetailsArray.sorted(by: {$0.ticketNumber > $1.ticketNumber})
        return intimationDetailsArray
    }
    
    func deleteQueries()->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:queriesTable)
        
        
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        managedContext.perform{
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not delete \(error), \(error.userInfo)")
            }
        }
        
        return true
        
    }
    
    //MARK:- topupDetailsTable
    //MARK:-
    func saveTopupDetails(detailsDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
       
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: topupDetailsTable, into: managedContext) as! TopupDetails
        
       
        let BaseSumInsured = detailsDict.value(forKey: "BaseSumInsured")
        let TSumInsured = detailsDict.value(forKey:"TSumInsured")
        let TSumInsuredPremium = detailsDict.value(forKey: "TSumInsuredPremium")as? String
        let productCode = detailsDict.value(forKey: "productCode")
        print(BaseSumInsured)
       if BaseSumInsured != nil
       {
        
        employee.baseSumInsured=BaseSumInsured as? String
        employee.topupInsured=TSumInsured as? String
        employee.premium=TSumInsuredPremium
        employee.productCode=productCode as? String
        

        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        }
        
    }
    
    
    
    func retrieveTopupDetails(productCode:String,bsi:String) ->Array<TopupDetails>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<TopupDetails>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:topupDetailsTable)
        if (bsi=="")
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@ && baseSumInsured == %@",productCode,bsi)
            
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [TopupDetails]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }
    
    
    
    
    func deleteTopupDetails(productCode : String)->Bool
    {
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:topupDetailsTable)
        if (productCode=="")
        {
            
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
        }
        fetchRequest.returnsObjectsAsFaults=false
        if let result = try? managedContext.fetch(fetchRequest)
        {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
        
        return true
        
    }
    
    //MARK:- JSON SAVER
   /* func saveGroupChildMasterDetailsJSON(groupDetailsDict: GroupInfoData)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: groupChildMasterDetailsTable, into: managedContext) as! OE_GROUP_CHILD_MASTER
        
        employee.groupChildSrNo=Int32(groupDetailsDict.groupchildsrno)!
        employee.groupCode = groupDetailsDict.groupcode
        employee.groupName = groupDetailsDict.groupname
         
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    */
    
    //MARK:- SAVE employeeInformationTable
    //MARK:-
//    func saveEmployeeDetailsJSON(enrollmentDetailsDict: NSDictionary,productCode:String)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
//
//        let employee = NSEntityDescription.insertNewObject(forEntityName: employeeInformationTable, into: managedContext) as! EMPLOYEE_INFORMATION
//
//
//
//        let GROUPCHILDSRNO = (enrollmentDetailsDict.value(forKey: "GROUPCHILDSRNO".uppercased())as! NSString).integerValue//...
//        let OE_GRP_BAS_INF_SR_NO = (enrollmentDetailsDict.value(forKey:"OE_GRP_BAS_INF_SR_NO".uppercased())as! NSString).integerValue //...
//        let date_of_joining = enrollmentDetailsDict.value(forKey: "DATE_OF_JOINING".uppercased())//...
//        let official_e_mail_id = enrollmentDetailsDict.value(forKey: "OFFICIAL_E_MAIL_ID".uppercased())//...
//        let department = enrollmentDetailsDict.value(forKey: "DEPARTMENT".uppercased())//...
//        let grade = enrollmentDetailsDict.value(forKey: "GRADE".uppercased())//...
//        let EMPLOYEEID = enrollmentDetailsDict.value(forKey: "EMPLOYEE_IDENTIFICATION_NO".uppercased())//...
//        let designation = enrollmentDetailsDict.value(forKey: "DESIGNATION".uppercased())//...
//        let EMPLOYEESRNO = (enrollmentDetailsDict.value(forKey: "EMPLOYEE_SR_NO".uppercased())as! NSString).integerValue//...
//        let base_suminsured = enrollmentDetailsDict.value(forKey: "BASE_SUM_INSURED".uppercased())//...
//        let topup_suminsured = enrollmentDetailsDict.value(forKey: "TOPUP_SUM_INSURED".uppercased())//...
//        let date_of_datainsert = enrollmentDetailsDict.value(forKey: "DATE_OF_DATA_INSERT".uppercased())
//        let topup_si_opted_flag = enrollmentDetailsDict.value(forKey: "TOPUP_SI_OPTED_FLAG".uppercased())//...
//        let topup_si_opted = enrollmentDetailsDict.value(forKey: "TOPUP_SI_OPTED".uppercased())//...
//        let topup_si_pk = enrollmentDetailsDict.value(forKey: "TOPUP_SI_PK".uppercased())//...
//        let topup_si_premium = enrollmentDetailsDict.value(forKey: "TOPUP_SI_PREMIUM".uppercased())//...
//
//
//        employee.dtaeOfJoining=date_of_joining as? String
//        employee.dateofDataInsert=date_of_datainsert as? String //Geeta
//        employee.officialEmailID=official_e_mail_id as? String
//        employee.empIDNo=EMPLOYEEID as? String
//        employee.empSrNo=Int64(EMPLOYEESRNO)
//        employee.groupChildSrNo=Int64(GROUPCHILDSRNO)
//        employee.department=department as? String
//        employee.productCode=productCode as? String
//        employee.grade=grade as? String
//        employee.designation=designation as? String
//        employee.oe_group_base_Info_Sr_No=Int64(OE_GRP_BAS_INF_SR_NO)
//        employee.baseSumInsured = base_suminsured as? String
//        employee.topupSumInsured = topup_suminsured as? String
//        employee.topupoptedflag = topup_si_opted_flag as? String
//        employee.topupoptedAmount = topup_si_opted as? String
//        employee.topupSrNo = topup_si_pk as? String
//        employee.topupSIPremium = topup_si_premium as? String
//
//        do {
//            try managedContext.save()
//            //5
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//
//    }
    
    
//    func saveEmployeeDetailsJSON(enrollmentDetailsDict: NSDictionary,productCode:String)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
//
//        let employee = NSEntityDescription.insertNewObject(forEntityName: employeeInformationTable, into: managedContext) as! EMPLOYEE_INFORMATION
//
//
//
//        let GROUPCHILDSRNO = (enrollmentDetailsDict.value(forKey: "GROUPCHILDSRNO".uppercased())as! NSString).integerValue//...
//        //let GROUPCHILDSRNO = (((enrollmentDetailsDict.value(forKey: "GROUPCHILDSRNO".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars as! NSString).integerValue
//        print("saveEmployeeDetailsJSON",enrollmentDetailsDict)
//
//        let OE_GRP_BAS_INF_SR_NO = (enrollmentDetailsDict.value(forKey:"OE_GRP_BAS_INF_SR_NO".uppercased())as! NSString).integerValue //...
//        //let OE_GRP_BAS_INF_SR_NO = (((enrollmentDetailsDict.value(forKey: "OE_GRP_BAS_INF_SR_NO".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars as! NSString).integerValue
//        let date_of_joining = enrollmentDetailsDict.value(forKey: "DATE_OF_JOINING".uppercased())//...
//        //let date_of_joining = ((enrollmentDetailsDict.value(forKey: "DATE_OF_JOINING".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars
//        let official_e_mail_id = enrollmentDetailsDict.value(forKey: "OFFICIAL_E_MAIL_ID".uppercased())//...
//        //let official_e_mail_id = (enrollmentDetailsDict.value(forKey: "OFFICIAL_E_MAIL_ID".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String
//        let department = enrollmentDetailsDict.value(forKey: "DEPARTMENT".uppercased())//...
//        // let department = ((enrollmentDetailsDict.value(forKey: "DEPARTMENT".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars
//        let grade = enrollmentDetailsDict.value(forKey: "GRADE".uppercased())//...
//        //let grade = ((enrollmentDetailsDict.value(forKey: "GRADE".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars
//        let EMPLOYEEID = enrollmentDetailsDict.value(forKey: "EMPLOYEE_IDENTIFICATION_NO".uppercased())//...
//        //let EMPLOYEEID = ((enrollmentDetailsDict.value(forKey: "EMPLOYEE_IDENTIFICATION_NO".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars
//        let designation = enrollmentDetailsDict.value(forKey: "DESIGNATION".uppercased())//...
//        //let designation = (enrollmentDetailsDict.value(forKey: "DESIGNATION".uppercased())as! String).removeSpecialChars
//        let EMPLOYEESRNO = (enrollmentDetailsDict.value(forKey: "EMPLOYEE_SR_NO".uppercased())as! NSString).integerValue//...
//        //let EMPLOYEESRNO = (((enrollmentDetailsDict.value(forKey: "EMPLOYEE_SR_NO".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars as! NSString).integerValue
//        let base_suminsured = enrollmentDetailsDict.value(forKey: "BASE_SUM_INSURED".uppercased())//...
//        //let base_suminsured = ((enrollmentDetailsDict.value(forKey: "BASE_SUM_INSURED".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars
//        let topup_suminsured = enrollmentDetailsDict.value(forKey: "TOPUP_SUM_INSURED".uppercased())//...
//        //let topup_suminsured = ((enrollmentDetailsDict.value(forKey: "TOPUP_SUM_INSURED".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars
//        let date_of_datainsert = enrollmentDetailsDict.value(forKey: "DATE_OF_DATA_INSERT".uppercased())
//        //let date_of_datainsert = ((enrollmentDetailsDict.value(forKey: "DATE_OF_DATA_INSERT".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars
//        let topup_si_opted_flag = enrollmentDetailsDict.value(forKey: "TOPUP_SI_OPTED_FLAG".uppercased())//...
//        //let topup_si_opted_flag = ((enrollmentDetailsDict.value(forKey: "TOPUP_SI_OPTED_FLAG".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars
//        let topup_si_opted = enrollmentDetailsDict.value(forKey: "TOPUP_SI_OPTED".uppercased())//...
//        //let topup_si_opted = ((enrollmentDetailsDict.value(forKey: "TOPUP_SI_OPTED".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars
//        let topup_si_pk = enrollmentDetailsDict.value(forKey: "TOPUP_SI_PK".uppercased())//...
//        //let topup_si_pk = ((enrollmentDetailsDict.value(forKey: "TOPUP_SI_PK".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars
//        let topup_si_premium = enrollmentDetailsDict.value(forKey: "TOPUP_SI_PREMIUM".uppercased())//...
//        //let topup_si_premium = ((enrollmentDetailsDict.value(forKey: "TOPUP_SI_PREMIUM".uppercased())as! String).replacingOccurrences(of: " ", with: "") as! String).removeSpecialChars
//
//
//        employee.dtaeOfJoining=date_of_joining as? String
//        employee.dateofDataInsert=date_of_datainsert as? String //Geeta
//        employee.officialEmailID=official_e_mail_id as? String
//        employee.empIDNo=EMPLOYEEID as? String
//        employee.empSrNo=Int64(EMPLOYEESRNO)
//        employee.groupChildSrNo=Int64(GROUPCHILDSRNO)
//        employee.department=department as? String
//        employee.productCode=productCode as? String
//        employee.grade=grade as? String
//        employee.designation=designation as? String
//        employee.oe_group_base_Info_Sr_No=Int64(OE_GRP_BAS_INF_SR_NO)
//        employee.baseSumInsured = base_suminsured as? String
//        employee.topupSumInsured = topup_suminsured as? String
//        employee.topupoptedflag = topup_si_opted_flag as? String
//        employee.topupoptedAmount = topup_si_opted as? String
//        employee.topupSrNo = topup_si_pk as? String
//        employee.topupSIPremium = topup_si_premium as? String
//        //managedContext.perform{
//        do {
//            try managedContext.save()
//            print("saveEmployeeDetailsJSON success")
//            //5
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//    //}
//
//    }
    
    
    
    func saveEmployeeDetailsJSON(enrollmentDetailsDict: NSDictionary,productCode:String)
    {
        let managedContext = appDelegate.managedObjectContext
        
        //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: employeeInformationTable, into: managedContext) as! EMPLOYEE_INFORMATION
        
    
        
        let GROUPCHILDSRNO = (enrollmentDetailsDict.value(forKey: "GROUPCHILDSRNO".uppercased())as! NSString).integerValue
        
        UserDefaults.standard.set(GROUPCHILDSRNO.description, forKey: "GroupChildSrNumber")
        
        let OE_GRP_BAS_INF_SR_NO = (enrollmentDetailsDict.value(forKey:"OE_GRP_BAS_INF_SR_NO".uppercased())as! NSString).integerValue
        let date_of_joining = enrollmentDetailsDict.value(forKey: "DATE_OF_JOINING".uppercased())
        let official_e_mail_id = enrollmentDetailsDict.value(forKey: "OFFICIAL_E_MAIL_ID".uppercased())
        let department = enrollmentDetailsDict.value(forKey: "DEPARTMENT".uppercased())
        let grade = enrollmentDetailsDict.value(forKey: "GRADE".uppercased())
        let EMPLOYEEID = enrollmentDetailsDict.value(forKey: "EMPLOYEE_IDENTIFICATION_NO".uppercased())
        let designation = enrollmentDetailsDict.value(forKey: "DESIGNATION".uppercased())
        let EMPLOYEESRNO = (enrollmentDetailsDict.value(forKey: "EMPLOYEE_SR_NO".uppercased())as! NSString).integerValue
        
        UserDefaults.standard.set(EMPLOYEESRNO.description, forKey: "EMPLOYEESRNumber")
        
        let base_suminsured = enrollmentDetailsDict.value(forKey: "BASE_SUM_INSURED".uppercased())
        let topup_suminsured = enrollmentDetailsDict.value(forKey: "TOPUP_SUM_INSURED".uppercased())
        let date_of_datainsert = enrollmentDetailsDict.value(forKey: "DATE_OF_DATA_INSERT".uppercased())
        let topup_si_opted_flag = enrollmentDetailsDict.value(forKey: "TOPUP_SI_OPTED_FLAG".uppercased())
        let topup_si_opted = enrollmentDetailsDict.value(forKey: "TOPUP_SI_OPTED".uppercased())
        let topup_si_pk = enrollmentDetailsDict.value(forKey: "TOPUP_SI_PK".uppercased())
        let topup_si_premium = enrollmentDetailsDict.value(forKey: "TOPUP_SI_PREMIUM".uppercased())
        
       
        employee.dtaeOfJoining=date_of_joining as? String
        employee.officialEmailID=official_e_mail_id as? String
        employee.empIDNo=EMPLOYEEID as? String
        employee.empSrNo=Int64(EMPLOYEESRNO)
        employee.groupChildSrNo=Int64(GROUPCHILDSRNO)
        employee.department=department as? String
        employee.productCode=productCode as? String
        employee.grade=grade as? String
        employee.designation=designation as? String
        employee.oe_group_base_Info_Sr_No=Int64(OE_GRP_BAS_INF_SR_NO)
        employee.baseSumInsured = base_suminsured as? String
        employee.topupSumInsured = topup_suminsured as? String
        employee.topupoptedflag = topup_si_opted_flag as? String
        employee.topupoptedAmount = topup_si_opted as? String
        employee.topupSrNo = topup_si_pk as? String
        employee.topupSIPremium = topup_si_premium as? String
     
        do {
            print("saveEmployeeDetailsJSON success")
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    //MARK:- SAVE personInformationTable
    //MARK:-
//    func savePersonDetailsJSON(personDetailsDict: NSDictionary)
//    {
//        let managedContext = appDelegate.managedObjectContext
//
//        let person = NSEntityDescription.insertNewObject(forEntityName: personInformationTable, into: managedContext) as! PERSON_INFORMATION
//
//
//
//        let person_sr_no = (personDetailsDict.value(forKey: "PERSON_SR_NO".uppercased())as! NSString).integerValue
//        let employee_sr_no = (personDetailsDict.value(forKey:"EMPLOYEE_SR_NO".uppercased())as! NSString).integerValue
//        //let age =
//        let age = (personDetailsDict.value(forKey: "AGE".uppercased())as! NSString).integerValue
//
//        let date_of_birth = personDetailsDict.value(forKey: "DATE_OF_BIRTH".uppercased())
//        let cellphone_no = personDetailsDict.value(forKey: "CELLPHONE_NUMBER".uppercased())
//        let emrgcellphone_no = personDetailsDict.value(forKey: "EMERGENCY_CONTACT_NUMBER".uppercased())
//        let person_name = personDetailsDict.value(forKey: "PERSON_NAME".uppercased())
//        let gender : String = personDetailsDict.value(forKey: "GENDER".uppercased()) as! String
//        var relationname :String = personDetailsDict.value(forKey: "RELATION_NAME".uppercased())as? String ?? ""
//        let relationid = (personDetailsDict.value(forKey: "RELATIONID".uppercased())as! NSString).integerValue
//
//        if(relationname.uppercased() == "SPOUSE" || relationname.uppercased()=="WIFE" || relationname.uppercased()=="HUSBAND")
//        {
//            if(gender.uppercased()=="Male".uppercased())
//            {
//                relationname="HUSBAND"
//                m_spouse = "HUSBAND"
//            }
//            else
//            {
//                relationname="WIFE"
//                m_spouse = "WIFE"
//
//            }
//        }
//
//        var isEmployeePresentCount = 0
//
//        let array = retrievePersonDetails(productCode: "")
//        if(array.count>0)
//        {
//            for dict in array
//            {
//                if(dict.relationname?.uppercased()=="EMPLOYEE")
//                {
//                    isEmployeePresentCount=isEmployeePresentCount+1
//
//                }
//
//            }
//
//            if(isEmployeePresentCount==0 && relationname.uppercased()=="EMPLOYEE")
//            {
//                person.personSrNo=Int32(person_sr_no)
//                person.age=Int32(age)
//                person.cellPhoneNUmber=cellphone_no as? String
//                person.emrgContactNumber=emrgcellphone_no as? String
//                person.dateofBirth=date_of_birth as? String
//                person.emailID=""
//                person.empSrNo=Int32(employee_sr_no)
//                person.gender=gender as? String
//                person.isValid=Int16(1)
//                person.personName=person_name as? String
//                person.relationID=Int32(relationid)
//                person.relationname=relationname as? String
//                person.productCode="GMC"
//                do {
//                    try managedContext.save()
//                    //5
//                } catch let error as NSError  {
//                    print("Could not save \(error), \(error.userInfo)")
//                }
//
//            }
//            else if(isEmployeePresentCount==1 && relationname.uppercased()=="EMPLOYEE")
//            {
//                person.personSrNo=Int32(person_sr_no)
//                person.age=Int32(age)
//                person.cellPhoneNUmber=cellphone_no as? String
//                person.emrgContactNumber=emrgcellphone_no as? String
//                person.dateofBirth=date_of_birth as? String
//                person.emailID=""
//                person.empSrNo=Int32(employee_sr_no)
//                person.gender=gender as? String
//                person.isValid=Int16(1)
//                person.personName=person_name as? String
//                person.relationID=Int32(relationid)
//                person.relationname=relationname as? String
//                person.productCode="GPA"
//                do {
//                    try managedContext.save()
//                    //5
//                } catch let error as NSError  {
//                    print("Could not save \(error), \(error.userInfo)")
//                }
//                isGPAEmployee=true
//            }
//            else if(isGPAEmployee==true && relationname.uppercased()=="EMPLOYEE")
//            {
//                person.personSrNo=Int32(person_sr_no)
//                person.age=Int32(age)
//                person.cellPhoneNUmber=cellphone_no as? String
//                person.emrgContactNumber=emrgcellphone_no as? String
//                person.dateofBirth=date_of_birth as? String
//                person.emailID=""
//                person.empSrNo=Int32(employee_sr_no)
//                person.gender=gender as? String
//                person.isValid=Int16(1)
//                person.personName=person_name as? String
//                person.relationID=Int32(relationid)
//                person.relationname=relationname as? String
//                person.productCode="GTL"
//                do {
//                    try managedContext.save()
//                    //5
//                } catch let error as NSError  {
//                    print("Could not save \(error), \(error.userInfo)")
//                }
//
//            }
//            else
//            {
//                person.personSrNo=Int32(person_sr_no)
//                person.age=Int32(age)
//                person.cellPhoneNUmber=cellphone_no as? String
//                person.emrgContactNumber=emrgcellphone_no as? String
//                person.dateofBirth=date_of_birth as? String
//                person.emailID=""
//                person.empSrNo=Int32(employee_sr_no)
//                person.gender=gender as? String
//                person.isValid=Int16(1)
//                person.personName=person_name as? String
//                person.relationID=Int32(relationid)
//                person.relationname=relationname as? String
//                person.productCode="GMC"
//                do {
//                    try managedContext.save()
//                    //5
//                } catch let error as NSError  {
//                    print("Could not save \(error), \(error.userInfo)")
//                }
//
//            }
//
//        }
//        else
//        {
//            person.personSrNo=Int32(person_sr_no)
//            person.age=Int32(age)
//            person.cellPhoneNUmber=cellphone_no as? String
//            person.emrgContactNumber=emrgcellphone_no as? String
//            person.dateofBirth=date_of_birth as? String
//            person.emailID=""
//            person.empSrNo=Int32(employee_sr_no)
//            person.gender=gender as? String
//            person.isValid=Int16(1)
//            person.personName=person_name as? String
//            person.relationID=Int32(relationid)
//            person.relationname=relationname as? String
//            person.productCode="GMC"
//            do {
//                try managedContext.save()
//                //5
//            } catch let error as NSError  {
//                print("Could not save \(error), \(error.userInfo)")
//            }
//        }
//
//    }
    
    func savePersonDetailsJSON(personDetailsDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let person = NSEntityDescription.insertNewObject(forEntityName: personInformationTable, into: managedContext) as! PERSON_INFORMATION
        
        
  
        let person_sr_no = (personDetailsDict.value(forKey: "PERSON_SR_NO".uppercased())as! NSString).integerValue
        let employee_sr_no = (personDetailsDict.value(forKey:"EMPLOYEE_SR_NO".uppercased())as! NSString).integerValue
        //let age =
        let age = (personDetailsDict.value(forKey: "AGE".uppercased())as! NSString).integerValue

        let date_of_birth = personDetailsDict.value(forKey: "DATE_OF_BIRTH".uppercased())
        let cellphone_no = personDetailsDict.value(forKey: "CELLPHONE_NUMBER".uppercased())
        let person_name = personDetailsDict.value(forKey: "PERSON_NAME".uppercased())
        let gender : String = personDetailsDict.value(forKey: "GENDER".uppercased()) as! String
        var relationname :String = personDetailsDict.value(forKey: "RELATION_NAME".uppercased())as? String ?? ""
        let relationid = (personDetailsDict.value(forKey: "RELATIONID".uppercased())as! NSString).integerValue

        if(relationname.uppercased() == "SPOUSE" || relationname.uppercased()=="WIFE" || relationname.uppercased()=="HUSBAND")
        {
            if(gender.uppercased()=="Male".uppercased())
            {
                relationname="HUSBAND"
                m_spouse = "HUSBAND"
            }
            else
            {
                relationname="WIFE"
                m_spouse = "WIFE"

            }
        }
        
        var isEmployeePresentCount = 0
        
        let array = retrievePersonDetails(productCode: "")
        if(array.count>0)
        {
            for dict in array
            {
                if(dict.relationname?.uppercased()=="EMPLOYEE")
                {
                    isEmployeePresentCount=isEmployeePresentCount+1
                    
                }
                
            }
            
            if(isEmployeePresentCount==0 && relationname.uppercased()=="EMPLOYEE")
            {
                person.personSrNo=Int32(person_sr_no)
                person.age=Int32(age)
                person.cellPhoneNUmber=cellphone_no as? String
                person.dateofBirth=date_of_birth as? String
                person.emailID=""
                person.empSrNo=Int32(employee_sr_no)
                person.gender=gender as? String
                person.isValid=Int16(1)
                person.personName=person_name as? String
                person.relationID=Int32(relationid)
                person.relationname=relationname as? String
                person.productCode="GMC"
                do {
                    try managedContext.save()
                    print("savepersondetailsjson gmc")
                    //5
                } catch let error as NSError  {
                    print("Could not save persondetailsjson\(error), \(error.userInfo)")
                }
                
            }
            else if(isEmployeePresentCount==1 && relationname.uppercased()=="EMPLOYEE")
            {
                person.personSrNo=Int32(person_sr_no)
                person.age=Int32(age)
                person.cellPhoneNUmber=cellphone_no as? String
                person.dateofBirth=date_of_birth as? String
                person.emailID=""
                person.empSrNo=Int32(employee_sr_no)
                person.gender=gender as? String
                person.isValid=Int16(1)
                person.personName=person_name as? String
                person.relationID=Int32(relationid)
                person.relationname=relationname as? String
                person.productCode="GPA"
                do {
                    try managedContext.save()
                    print("savepersondetailsjson gpa")
                    //5
                } catch let error as NSError  {
                    print("Could not save persondetailsjson\(error), \(error.userInfo)")
                }
                isGPAEmployee=true
            }
            else if(isGPAEmployee==true && relationname.uppercased()=="EMPLOYEE")
            {
                person.personSrNo=Int32(person_sr_no)
                person.age=Int32(age)
                person.cellPhoneNUmber=cellphone_no as? String
                person.dateofBirth=date_of_birth as? String
                person.emailID=""
                person.empSrNo=Int32(employee_sr_no)
                person.gender=gender as? String
                person.isValid=Int16(1)
                person.personName=person_name as? String
                person.relationID=Int32(relationid)
                person.relationname=relationname as? String
                person.productCode="GTL"
                do {
                    
                    try managedContext.save()
                    print("savepersondetailsjson gtl")
                    //5
                } catch let error as NSError  {
                    print("Could not save persondetailsjson\(error), \(error.userInfo)")
                }
                
            }
            else
            {
                person.personSrNo=Int32(person_sr_no)
                person.age=Int32(age)
                person.cellPhoneNUmber=cellphone_no as? String
                person.dateofBirth=date_of_birth as? String
                person.emailID=""
                person.empSrNo=Int32(employee_sr_no)
                person.gender=gender as? String
                person.isValid=Int16(1)
                person.personName=person_name as? String
                person.relationID=Int32(relationid)
                person.relationname=relationname as? String
                person.productCode="GMC"
                do {
                    try managedContext.save()
                    print("savepersondetailsjson gmc")
                    //5
                } catch let error as NSError  {
                    print("Could not save persondetailsjson\(error), \(error.userInfo)")
                }
                
            }
            
        }
        else
        {
            person.personSrNo=Int32(person_sr_no)
            person.age=Int32(age)
            person.cellPhoneNUmber=cellphone_no as? String
            person.dateofBirth=date_of_birth as? String
            person.emailID=""
            person.empSrNo=Int32(employee_sr_no)
            person.gender=gender as? String
            person.isValid=Int16(1)
            person.personName=person_name as? String
            person.relationID=Int32(relationid)
            person.relationname=relationname as? String
            person.productCode="GMC"
            do {
                try managedContext.save()
                print("savepersondetailsjson gmc")
                //5
            } catch let error as NSError  {
                print("Could not save persondetailsjson\(error), \(error.userInfo)")
            }
        }
        
    }
    //MARK:- groupBasicInfoDetailsTable
    //MARK:-
//    func saveGroupBasicInfoDetailsJSON(groupDetailsDict: NSDictionary)
//        {
//
//            print("SAVE GROUP BASIC \(groupDetailsDict)")
//            let managedContext = appDelegate.managedObjectContext
//
//            //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
//
//            let employee = NSEntityDescription.insertNewObject(forEntityName: groupBasicInfoDetailsTable, into: managedContext) as! OE_GROUP_BASIC_INFORMATION
//
//    //        let context = NSPersistentContainer.viewContext
//            let employee1 = EMPLOYEE_INFORMATION(context: managedContext)
//
//              //"OE_GRP_BAS_INF_SR_NO" = 280;
//
//            //Old Core
//            /*
//            let TPACODE = groupDetailsDict.value(forKey: "TPA_CODE".uppercased())
//            let TPANAME = groupDetailsDict.value(forKey:"TPA_NAME".uppercased())
//            let INSCODE = groupDetailsDict.value(forKey: "INS_CODE".uppercased())as? String
//            let INSNAME = groupDetailsDict.value(forKey: "INS_CO_NAME".uppercased())
//            let active = groupDetailsDict.value(forKey: "active".uppercased())
//            let POLICYNO = groupDetailsDict.value(forKey: "POLICY_NUMBER".uppercased())as? String
//            let POLICYCOMMDT = groupDetailsDict.value(forKey: "POLICY_COMMENCEMENT_DATE".uppercased())
//            let POLICYVALIDUPTO = groupDetailsDict.value(forKey: "POLICY_VALID_UPTO".uppercased())
//            let isActive = groupDetailsDict.value(forKey: "ACTIVE".uppercased()) as? String
//            //let OE_GRP_BAS_INF_SR_NO = employee1.oe_group_base_Info_Sr_No
//            print(groupDetailsDict.value(forKey: "OE_GRP_BAS_INF_SR_NO"))
//            let OE_GRP_BAS_INF_SR_NO = (groupDetailsDict.value(forKey: "OE_GRP_BAS_INF_SR_NO")as! NSString).integerValue
//            //groupDetailsDict.value(forKey: "OE_GRP_BAS_INF_SR_NO")
//            let PRODUCTCODE = groupDetailsDict.value(forKey: "PRODUCT_CODE".uppercased())
//            let broker = groupDetailsDict.value(forKey: "BROKER_NAME".uppercased())
//
//
//       //        employee.groupChildSrNo=GROUPCHILDSRNO as? String
//
//               employee.ins_Code=INSCODE
//               employee.ins_Name=INSNAME as? String
//               employee.policyComencmentDate=POLICYCOMMDT as? String
//               employee.policyNumber=POLICYNO as? String
//               employee.policyValidUpto=POLICYVALIDUPTO as? String
//               employee.productCode=PRODUCTCODE as? String
//               employee.tpa_Code=TPACODE as? String
//               employee.tpa_Name=TPANAME as? String
//               employee.oE_GRP_BAS_INF_SR_NO = Int32(OE_GRP_BAS_INF_SR_NO)
//               employee.isActive=isActive as? String
//               employee.brokerName=broker as? String
//
//       //        employee. = BROKERNAME as? String
//
//             */
//
//            let active = groupDetailsDict.value(forKey: "active".uppercased())
//             let broker = groupDetailsDict.value(forKey: "BROKER_NAME".uppercased())
//
//
//            let OE_GRP_BAS_INF_SR_NO = (groupDetailsDict.value(forKey: "OE_GRP_BAS_INF_SR_NO")as! NSString).integerValue
//            let POLICYNO = groupDetailsDict.value(forKey: "POLICY_NUMBER".uppercased())as? String
//            let INSNAME = groupDetailsDict.value(forKey: "INS_CO_NAME".uppercased())
//            let INSCODE = groupDetailsDict.value(forKey: "INS_CODE".uppercased())as? String
//            let TPANAME = groupDetailsDict.value(forKey:"TPA_NAME".uppercased())
//            let TPACODE = groupDetailsDict.value(forKey: "TPA_CODE".uppercased())
//            let POLICYCOMMDT = groupDetailsDict.value(forKey: "POLICY_COMMENCEMENT_DATE".uppercased())
//            let POLICYVALIDUPTO = groupDetailsDict.value(forKey: "POLICY_VALID_UPTO".uppercased())
//            let isActive = groupDetailsDict.value(forKey: "ACTIVE".uppercased()) as? String
//            let PRODUCTCODE = groupDetailsDict.value(forKey: "PRODUCT_CODE".uppercased())
//            let TYPE_OF_POL_SR_NO = groupDetailsDict.value(forKey: "TYPE_OF_POL_SR_NO".uppercased())
//            let POLICY_TYPE = groupDetailsDict.value(forKey: "POLICY_TYPE".uppercased())
//
//
//
//
//
//            employee.groupchildSrNo = Int32(GROUPCHILDSRNOValue)
//    //        employee. = BROKERNAME as? String
//            employee.oE_GRP_BAS_INF_SR_NO = Int32(OE_GRP_BAS_INF_SR_NO)
//            employee.policyNumber=POLICYNO as? String
//            employee.ins_Name=INSNAME as? String
//            employee.ins_Code=INSCODE
//            employee.tpa_Name=TPANAME as? String
//            employee.tpa_Code=TPACODE as? String
//            employee.policyComencmentDate=POLICYCOMMDT as? String
//            employee.policyValidUpto=POLICYVALIDUPTO as? String
//            employee.isActive=isActive as? String
//            employee.productCode=PRODUCTCODE as? String
//            employee.typeOfPolSrNo=TYPE_OF_POL_SR_NO as? String
//            employee.policyType=POLICY_TYPE as? String
//
//            employee.brokerName=broker as? String
//
//
//
//            do {
//                if isActive?.uppercased() == "ACTIVE" {
//                try managedContext.save()
//                }
//                    //5
//            } catch let error as NSError  {
//                print("Could not save \(error), \(error.userInfo)")
//            }
//
//        }
    
    
    func saveGroupBasicInfoDetailsJSON(groupDetailsDict: NSDictionary)
        {
            
            print("SAVE GROUP BASIC \(groupDetailsDict)")
            let managedContext = appDelegate.managedObjectContext
            
            //            let entity =  NSEntityDescription.entity(forEntityName: enrollmentDetailsTable,in:managedContext)
            
            let employee = NSEntityDescription.insertNewObject(forEntityName: groupBasicInfoDetailsTable, into: managedContext) as! OE_GROUP_BASIC_INFORMATION
            
    //        let context = NSPersistentContainer.viewContext
            let employee1 = EMPLOYEE_INFORMATION(context: managedContext)
            
              //"OE_GRP_BAS_INF_SR_NO" = 280;
         
            let TPACODE = groupDetailsDict.value(forKey: "TPA_CODE".uppercased())
            let TPANAME = groupDetailsDict.value(forKey:"TPA_NAME".uppercased())
            let INSCODE = groupDetailsDict.value(forKey: "INS_CODE".uppercased())as? String
            let INSNAME = groupDetailsDict.value(forKey: "INS_CO_NAME".uppercased())
            let active = groupDetailsDict.value(forKey: "active".uppercased())
            let POLICYNO = groupDetailsDict.value(forKey: "POLICY_NUMBER".uppercased())as? String
            let POLICYCOMMDT = groupDetailsDict.value(forKey: "POLICY_COMMENCEMENT_DATE".uppercased())
            let POLICYVALIDUPTO = groupDetailsDict.value(forKey: "POLICY_VALID_UPTO".uppercased())
            let isActive = groupDetailsDict.value(forKey: "ACTIVE".uppercased())
            //let OE_GRP_BAS_INF_SR_NO = employee1.oe_group_base_Info_Sr_No
            let OE_GRP_BAS_INF_SR_NO = Int((groupDetailsDict.value(forKey: "OE_GRP_BAS_INF_SR_NO")as? String)!)

            let PRODUCTCODE = groupDetailsDict.value(forKey: "PRODUCT_CODE".uppercased())
            let broker = groupDetailsDict.value(forKey: "BROKER_NAME".uppercased())
            let POLICY_TYPE = groupDetailsDict.value(forKey: "POLICY_TYPE".uppercased())
       
          
    //        employee.groupChildSrNo=GROUPCHILDSRNO as? String
            
            employee.ins_Code=INSCODE
            employee.ins_Name=INSNAME as? String
            employee.policyComencmentDate=POLICYCOMMDT as? String
            employee.policyNumber=POLICYNO as? String
            employee.policyValidUpto=POLICYVALIDUPTO as? String
            employee.productCode=PRODUCTCODE as? String
            employee.tpa_Code=TPACODE as? String
            employee.tpa_Name=TPANAME as? String
            employee.oE_GRP_BAS_INF_SR_NO = Int32(OE_GRP_BAS_INF_SR_NO!)
            employee.isActive=isActive as? String
            employee.brokerName=broker as? String
            employee.policyType=POLICY_TYPE as? String
           
    //        employee. = BROKERNAME as? String
            
            
            
            do {
                try managedContext.save()
                //5
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }
    //MARK:- SAVE enrollmentGroupRelationsTable
    //MARK:-
    //ADMIN SETTINGS
    
    func saveEnrollmentGroupRelatoionsDetailsJSON(contactDict: NSDictionary)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let contacts = NSEntityDescription.insertNewObject(forEntityName: enrollmentGroupRelationsTable, into: managedContext) as! EnrollmentGroupRelations
        print("Database error log saveEnrollmentGroupRelatoionsDetailsJSON 4501")
        
        let RelationName = contactDict.value(forKey: "RELATION")
        let RelationID = contactDict.value(forKey:"RELATION_ID")
        //let MinAge = contactDict.value(forKey: "MIN_AGE")
        
        if let MaxAge = contactDict.value(forKey: "MAX_AGE"){
            var age = MaxAge as? String
            if age != ""{
                contacts.maxAge=age
            }else{
                contacts.maxAge="0"
            }
        }
        if let MinAge = contactDict.value(forKey: "MIN_AGE"){
            var age = MinAge as? String
            if age != ""{
                contacts.minAge=age
            }else{
                contacts.minAge="0"
            }
        }
        
        contacts.relationName=RelationName as? String
        contacts.relationID=RelationID as? String
        //contacts.minAge=MinAge as? String ?? "0"
        //contacts.maxAge=MaxAge as? String ?? "0"
        
        print("Database error log",contacts.maxAge)
        managedContext.perform{
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
           
       }
    
    //MARK:- getSelectedEmpSrNo
    //MARK:-
    func getSelectedEmpSrNo1() -> String {
        var m_employeedict : EMPLOYEE_INFORMATION?
        var empidNo = ""
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if userArray.count > 0 {
            m_employeedict=userArray[0]
            
            if let empID = m_employeedict?.empSrNo
            {
                empidNo=String(empID)
                
            }
            return empidNo
            
        }
        return empidNo
        
    }
    
    
    func getEmployeeSerialNumber(productCode:String) -> String{
        let oegrpbasinfsrno = getOE_GroupBaseNo(productCode: productCode)
        if oegrpbasinfsrno != "" {
            let empInfo = DatabaseManager.sharedInstance.retrieveEmployeeSrNo(productCode: productCode, OeGroupBaseNo: Int(oegrpbasinfsrno)!)
                      
                      var empSrNo = String()
                      if empInfo.count > 0 {
                          empSrNo = empInfo[0].empSrNo.description
                        return empSrNo

                      }
                      else {
                        return ""
                        }
        }
        return ""
    }
    
    func getSelectedEmpSrNo() -> String {
        guard let empSr = UserDefaults.standard.value(forKey: "selectedEmpSrNo") as? String else {
            return ""
        }
        
        return empSr
        
    }
    
    //MARK:- New changes for offline data
    func retrieveEmployeeDependantsFrom(empSrNo:String,productCode:String,relationName:String) ->Array<PERSON_INFORMATION>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<PERSON_INFORMATION>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:personInformationTable)
        if (productCode=="")
        {
            print("BLANK PRODUCT CODE")
        }
        else
        {
            fetchRequest.predicate=NSPredicate(format:"relationname == %@ && empSrNo == %@",relationName,empSrNo)
        }
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [PERSON_INFORMATION]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }

    
    func getOE_GroupBaseNo(productCode:String) -> String {
        //If GMC
        var oegrpbasinfsrno = String()
        
        switch productCode {
        case "GMC","GHI":
            if let oegroup = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO") as? String {
                oegrpbasinfsrno = oegroup
            }
            return oegrpbasinfsrno
            
      
       case "GPA":
            if let oegroup = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO_GPA") as? String {
                oegrpbasinfsrno = oegroup
            }
            return oegrpbasinfsrno
            
        case "GTL":
            if let oegroup = UserDefaults.standard.value(forKey: "OE_GRP_BAS_INF_SR_NO_GTL") as? String {
                oegrpbasinfsrno = oegroup
            }
            return oegrpbasinfsrno

        default:
            return ""
        }
        
    }
    
    //MARK:- New Change Oe_Group May 2020
    func retrieveEmployeeSrNo(productCode:String,OeGroupBaseNo:Int) ->Array<EMPLOYEE_INFORMATION>
    {
        let managedContext = appDelegate.managedObjectContext
        var enrollmentDetailsArray:Array<EMPLOYEE_INFORMATION>=[];
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:employeeInformationTable)
       
            fetchRequest.predicate=NSPredicate(format:"productCode == %@ && oe_group_base_Info_Sr_No == \(OeGroupBaseNo)",productCode)
            
        
        
        fetchRequest.returnsObjectsAsFaults=false
        
        do
        {
            let records = try managedContext.fetch(fetchRequest)as! [EMPLOYEE_INFORMATION]
            let len =  records.count
            for i in 0..<len
            {
                let record = records[i]
                enrollmentDetailsArray.append(record)
                
                
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return enrollmentDetailsArray
    }
    
//    //MARK:- OverviewDetailstable
//     //MARK:-
//     func saveOverviewDetails(groupDetailsDict: NSDictionary)
//     {
//         let managedContext = appDelegate.managedObjectContext
//         let employee = NSEntityDescription.insertNewObject(forEntityName: overviewTable, into: managedContext) as! OverviewDetails
//
//         let GROUPCHILDSRNO = (groupDetailsDict.value(forKey: "WELLSRNO")
//         let SERVICENAME = groupDetailsDict.value(forKey:"SERVICENAME")
//         let JSONCONTENT = groupDetailsDict.value(forKey: "JSONCONTENT")
//
//
//         employee.groupChildSrNo=GROUPCHILDSRNO as? String
//         employee.groupCode=SERVICENAME as? String
//         employee.groupName=JSONCONTENT as? String
//
//         do {
//             try managedContext.save()
//             //5
//         } catch let error as NSError  {
//             print("Could not save \(error), \(error.userInfo)")
//         }
//     }
//
//
//
//     func retrieveGroupChildMasterDetails(productCode:String) ->Array<OE_GROUP_CHILD_MASTER>
//     {
//         let managedContext = appDelegate.managedObjectContext
//         var enrollmentDetailsArray:Array<OE_GROUP_CHILD_MASTER>=[];
//
//         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:groupChildMasterDetailsTable)
//         if (productCode==""){
//
//         }    else {
//
//             fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
//             fetchRequest.returnsObjectsAsFaults=false
//         }
//
//
//         do
//         {
//             let records = try managedContext.fetch(fetchRequest)as! [OE_GROUP_CHILD_MASTER]
//             let len =  records.count
//             for i in 0..<len
//             {
//                 let record = records[i]
//                 enrollmentDetailsArray.append(record)
//
//
//             }
//         }
//         catch let error as NSError
//         {
//             print("Could not fetch \(error), \(error.userInfo)")
//         }
//
//         return enrollmentDetailsArray
//     }
//
//     func deleteGroupChildMasterDetails(productCode : String)->Bool
//     {
//         let managedContext = appDelegate.managedObjectContext
//
//         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:groupChildMasterDetailsTable)
//         if (productCode=="")
//         {
//
//         }
//         else
//         {
//             fetchRequest.predicate=NSPredicate(format:"productCode == %@",productCode)
//         }
//         fetchRequest.returnsObjectsAsFaults=false
//         if let result = try? managedContext.fetch(fetchRequest)
//         {
//             for object in result {
//                 managedContext.delete(object as! NSManagedObject)
//             }
//         }
//
//         do {
//             try managedContext.save()
//         } catch let error as NSError  {
//             print("Could not delete \(error), \(error.userInfo)")
//         }
//
//         return true
//
//     }
    
    
}


//let container = NSPersistentContainer(name: "DbModel")
//// Begin of my code
//let cOpts : NSDictionary = [
//            EncryptedStore.optionPassphraseKey() : "123deOliveira4", //your Key
//            EncryptedStore.optionFileManager() : EncryptedStoreFileManager.default()
//        ]
//let desc = try! EncryptedStore.makeDescription(options: cOpts as! [AnyHashable : Any], configuration: nil)
//container.persistentStoreDescriptions = [desc]
////End
//container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//        if let error = error as NSError? {
//            fatalError("Unresolved error \(error), \(error.userInfo)")
//        }
//})
