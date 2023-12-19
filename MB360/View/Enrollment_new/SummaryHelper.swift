//
//  SummaryHelper.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 28/03/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import Foundation


struct SummaryDataModel {
    var max_wallet_amount: String?
    var sodexo_amount: String?
    var gmc_base_si: String?
    var gmc_topup_si: String?
    var gmc_total_si: String?
    var gpa_base_si : String?
    var gpa_topup_si : String?
    var gpa_total_si : String?
    var gtl_base_si : String?
    var gtl_topup_si : String?
    var gtl_total_si : String?
    var parent_1 : String?
    var parent_1_premium : String?
    var parent_2 : String?
    var parent_2_premium : String?
    var gmc_topup_premium : String?
    var gpa_topup_premium : String?
    var gtl_topup_premium : String?
    var wallet_amount_used : String?
    var wallet_amount_available : String?
    var payroll_amount_used : String?
    var total_premium : String?
    var no_of_installments : String?
    var wellness_benefit_amount_7 : String?
    var wellness_benefit_amount_8 : String?
    var wellness_benefit_amount_9 : String?
    var wellness_benefit_amount_10 : String?
    var wellness_benefit_amount_11 : String?
    var wellness_benefit_amount_12 : String?
    var wellness_benefit_amount_13 : String?
    var wellness_benefit_amount_14 : String?
    var wellness_benefit_amount_15 : String?
    var wellness_benefit_amount_16 : String?
    var wellness_benefit_amount_17 : String?
    var confirmation_date : String?
    var gmc_base_si_parent_set1 : String?
    var gmc_base_si_parent_set2 : String?
    var extra_premium : String?
    var payroll_amount_used_Int : Int?
    var total_premium_Int : Int?
}


extension SummaryRightVC {
    
    func getSummaryFromServer() {
            print("@@ getDependantsFromServer...")
            if(isConnectedToNetWithAlert())
            {
                var m_employeedict : EMPLOYEE_INFORMATION?
                
                let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
                if(userArray.count>0)
                {
                    m_employeedict=userArray[0]
                 
                    var empSrNo = String()
                   
                    if let empsrno = m_employeedict?.empSrNo
                    {
                        empSrNo=String(empsrno)
                    }
                   
                    var extraPremium = String()
                    if let ExtraChildPremium = UserDefaults.standard.value(forKey: "ExtraChildPremium") as? String {
                        extraPremium = ExtraChildPremium 
                    }else{
                        extraPremium = ""
                    }
                    
                    let url = APIEngine.shared.getSummaryDataURL(empSrNo: empSrNo)
                    
                    
                    let urlreq = NSURL(string : url)
                    
                    //self.showPleaseWait(msg: "")
                    print(url)
                    let dict = ["" : ""]
                    EnrollmentServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: dict as NSDictionary, view: self) { (data, error) in

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
                                print("getSummaryFromServer Session...")
                                print(data)
                                
                                if let msgDict = data?["message"].dictionary
                                {
                                    let status = msgDict["Status"]?.bool
                                    
                                    if status == true {//start
                                        
                                    }//end
                                    
                                    if let sumDict = data?["Summary"].dictionary {
                                        if let dataArray = sumDict["data"]?.array {
                                            if dataArray.count > 0 {
                                                let dict = dataArray[0]
                                                
                                                self.summaryModelObj = SummaryDataModel.init(max_wallet_amount: dict["max_wallet_amount"].string, sodexo_amount: dict["sodexo_amount"].string, gmc_base_si: dict["gmc_base_si"].string, gmc_topup_si: dict["gmc_topup_si"].string, gmc_total_si: dict["gmc_total_si"].string, gpa_base_si: dict["gpa_base_si"].string, gpa_topup_si: dict["gpa_topup_si"].string, gpa_total_si: dict["gpa_total_si"].string, gtl_base_si: dict["gtl_base_si"].string, gtl_topup_si: dict["gtl_topup_si"].string, gtl_total_si: dict["gtl_total_si"].string, parent_1: dict["parent_1"].string, parent_1_premium: dict["parent_1_premium"].string, parent_2: dict["parent_2"].string, parent_2_premium: dict["parent_2_premium"].string, gmc_topup_premium: dict["gmc_topup_premium"].string, gpa_topup_premium: dict["gpa_topup_premium"].string, gtl_topup_premium: dict["gtl_topup_premium"].string, wallet_amount_used: dict["wallet_amount_used"].string, wallet_amount_available: dict["wallet_amount_available"].string, payroll_amount_used: dict["payroll_amount_used"].string, total_premium: dict["total_premium"].string, no_of_installments: dict["no_of_installments"].string, wellness_benefit_amount_7: dict["wellness_benefit_amount_7"].string, wellness_benefit_amount_8: dict["wellness_benefit_amount_8"].string, wellness_benefit_amount_9: dict["wellness_benefit_amount_9"].string, wellness_benefit_amount_10: dict["wellness_benefit_amount_10"].string, wellness_benefit_amount_11: dict["wellness_benefit_amount_11"].string, wellness_benefit_amount_12: dict["wellness_benefit_amount_12"].string, wellness_benefit_amount_13: dict["wellness_benefit_amount_13"].string, wellness_benefit_amount_14: dict["wellness_benefit_amount_14"].string, wellness_benefit_amount_15: dict["wellness_benefit_amount_15"].string, wellness_benefit_amount_16: dict["wellness_benefit_amount_15"].string, wellness_benefit_amount_17: dict["wellness_benefit_amount_17"].string, confirmation_date: dict["confirmation_date"].string, gmc_base_si_parent_set1: dict["gmc_base_si_parent_set1"].string, gmc_base_si_parent_set2: dict["gmc_base_si_parent_set2"].string, extra_premium: extraPremium, payroll_amount_used_Int: dict["payroll_amount_used"].int, total_premium_Int: dict["total_premium"].int)
                                                
                                                self.generateArray()
                                                
                                            }
                                        }
                                        
                                    }
                                    
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
    
    
    func setEnrollmentData()
    {
        if let groupAdminBasic = UserDefaults.standard.value(forKey: "EnrollmentGroupAdminBasicSettings")
        {
            m_groupAdminBasicSettingsDict = groupAdminBasic as! NSDictionary
        }
        
        if let enrollmentMiscInfo = UserDefaults.standard.value(forKey: "EnrollmentMiscInformation")
        {
            m_enrollmentMiscInformationDict = enrollmentMiscInfo as! NSDictionary
        }
        
        if let enrollmentLifeEvent = UserDefaults.standard.value(forKey: "EnrollmentLifeEventInfo")
        {
            m_enrollmentLifeEventInfoDict = enrollmentLifeEvent as! NSDictionary
        }
        
        if let serverDate = m_groupAdminBasicSettingsDict.value(forKey: "Server_Date")as? String
        {
            m_serverDate = convertStringToDate(dateString: serverDate)
        }
        else
        {
            m_serverDate = Date()
        }
        print(m_serverDate)
        
        let dict : NSDictionary = openEnrollmentDict as NSDictionary
        let newJoineeDict : NSDictionary = newJoineeEnrollmentDict as NSDictionary
        var isStartDateForNewJoinee = String()
        if let date = dict.value(forKey: "WINDOW_PERIOD_START_DATE")as? String
        {
            let startDate = convertStringToDate(dateString:date)
            let joiningDate = convertStringToDate(dateString: (m_employeedict?.dtaeOfJoining)!)
            print(joiningDate)
            if(joiningDate>startDate)
            {
                
                let enrollmentType = m_groupAdminBasicSettingsDict.value(forKey: "ENROLMENT_TYPE")as? String
                if(enrollmentType=="ONGOING")
                {
                    if let endDate = dict.value(forKey: "WINDOW_PERIOD_END_DATE")as? String
                    {
                        if let isStartDateNewJoinee = newJoineeDict.value(forKey: "STARTS_FROM_DATE_OF_DATAINSERT")
                        {
                            isStartDateForNewJoinee=isStartDateNewJoinee as! String
                        }
                        let duration = newJoineeDict.value(forKey: "DATE_DURATION")as! String
                        
                        //MARK:- WP
                        m_windowPeriodEndDate = convertStringToDate(dateString:endDate)
                        if(isStartDateForNewJoinee == "YES")
                        {
                            if let dataInsertDate = m_employeedict?.dateofDataInsert
                            {
                                let dateofDataInsert = convertStringToDate(dateString: dataInsertDate)
                                
                                if let extensionDays = Int(duration)
                                {
                                    if let tomorrow = Calendar.current.date(byAdding:.day, value: extensionDays, to: dateofDataInsert)
                                    {
                                        m_windowPeriodEndDate=tomorrow
                                    }
                                }
                            }
                            
                        }
                        else if let extensionDays = Int(duration)
                        {
                            if let tomorrow = Calendar.current.date(byAdding:.day, value: extensionDays, to: joiningDate)
                            {
                                m_windowPeriodEndDate=tomorrow
                            }
                        }
                       // calculateRemainingDays()
                    }
                }
            }
            else
            {
                if let date = dict.value(forKey: "WINDOW_PERIOD_END_DATE")as? String
                {
                    m_windowPeriodEndDate = convertStringToDate(dateString:date)
                   // calculateRemainingDays()
                    
                }
            }
            
            
        }
        
     
        
        
    }
}
