//
//  WebServiceManager.swift
//  MyBenefits
//
//  Created by Semantic on 11/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class WebServiceManager: NSObject
{
 
     static let sharedInstance = WebServiceManager()
    
    //UAT
//    let downloadBaseUrl = "https://uat-employee.benefitsyou.com/"
//    let baseUrl = "https://uat-employee.benefitsyou.com/mb360apiv1/"
//    let newBaseurl = "https://uat-employee.benefitsyou.com/mb360apiv1/api/"
//    let baseUrlJson = "https://uat-employee.benefitsyou.com/mb360apiv1/api/EnrollmentDetails/"
//
//   // UAT Portal
//    let baseXmlUrl = "https://uat-employee.benefitsyou.com/appservice/"
//    let baseUrlPortal = "https://uat-employee.benefitsyou.com/mb360apiv1/api/"
//    let newBaseurlPortal = "https://uat-employee.benefitsyou.com/mb360apiv1/api/"
//    let webBaseUrlPortal = "https://uat-employee.benefitsyou.com/"
//    let downloadBaseUrlPortal = "https://uat-employee.benefitsyou.com/"
//
//    let baseUrlV3 = "https://uat-employee.benefitsyou.com/mb360apiv1/api/"

    //Production
    let downloadBaseUrl = "https://employee.benefitsyou.com/"
    let baseUrl = "https://employee.benefitsyou.com/mb360apiv1/"
    let newBaseurl = "https://employee.benefitsyou.com/mb360apiv1/api/"
    let baseUrlJson = "https://employee.benefitsyou.com/mb360apiv1/api/EnrollmentDetails/"

   // prod Portal
    let baseXmlUrl = "https://employee.benefitsyou.com/appservice/"
    let baseUrlPortal = "https://employee.benefitsyou.com/mb360apiv1/api/"
    let newBaseurlPortal = "https://employee.benefitsyou.com/mb360apiv1/api/"
    let webBaseUrlPortal = "https://employee.benefitsyou.com/"
    let downloadBaseUrlPortal = "https://employee.benefitsyou.com/"
//
    let baseUrlV3 = "https://employee.benefitsyou.com/mb360apiv1/api/"
    
    //Production Portal New Url Extension
    let sendOtpPostUrl = "loginservice.svc/RequestOTP"
    let sendOtpPostUrlPortal = "Login/RequestOTP"
    let WOOtpPostUrlPortal = "Login/RequestOTPWO"
    let sendWebLoginPostUrlPortal = "Login/ValidateLogin"
    let validatePostUrlPortal = "Login/ValidateOTP"
    let getEnrollStatusUrlPortal = "EnrollmentStatus/GetEnrollStatus"
    let faqPostUrlPortal = "Faqs/Get_FaqsDetails"
    let policyFeaturesUrlPortal = "PolicyFeatures/GetPolicyFeatures"
    let contactDetailsPostURLPortal = "Escalation/GetGroupEscalationInfo"
    let utilitiesPostURLPortal = "Utilities/Get_UtilitiesDetails"
    let personInfoForIntimationUrlPortal = "IntimateClaim/LoadPersonsForIntimation"
    let intimateClaimPostUrlPortal = "IntimateClaim/NewIntimateClaim"
    let intimatedClaimsPostURLPortal = "IntimateClaim/LoadIntimatedClaims"
    let getClaimProcLayoutInfoPortal = "ClaimProcedure/GetClaimProcLayoutInfo"
    let getLoadClaimProcImagePathPotal = "ClaimProcedure/GetLoadClaimProcImagePath"
    let getClaimProcInstructionInfoPathPortal = "ClaimProcedure/GetClaimProcInstructionInfo"
    let getEmergencyContactNoPathPortal = "ClaimProcedure/GetEmergencyContactNo"
    let getClaimProcTextPathPotal = "ClaimProcedure/GetClaimProcTextPath"
    let getCoveragePolicyDataPathPortal = "PolicyCoverages/GetCoveragePolicyData"
    let loaduserprofiledetailsPathPortal = "UserProfile/loaduserprofiledetails"
    let getPolicyCoveragesDetailsPathPortal = "PolicyCoverages/GetPolicyCoveragesDetails"
    
    let refreshUserToken = "Login/RefreshUserToken"
    
    //ClaimProcedure URLS
    let filePathsPortal = "mybenefits/claimprocedures/"
    

    let sendOtpUrl = "loginservice.svc/appsendotp/"
    let validateOtpUrl = "loginservice.svc/appvalidateotp/"
    let appSessionValuesUrl = "loginservice.svc/appsessionvalues/"
    let enrollmentDetailsUrl = "enrollmentservice.svc/getenrollmentdetails/"
    let intimatedClaimsUrl = "intimateclaimservice.svc/getintimatedclaims/"
    let intimateNewClaimUrl = "intimateclaimservice.svc/AddIntimation/"
    let personInfoForIntimationUrl = "intimateclaimservice.svc/getpersonforintimation/"
    let contactDetailsUrl = "escalationsservice.svc/getescalations"
    let networkHospitalDetailsUrl = "hospitalService.svc/GetProviders"
    let dataSettingsUrl = "enrollmentservice.svc/GetEnrollmentDataSettings"
    let utilitiesDetailsUrl = "utilitiesservice.svc/getutilities"
    let adminSettingsUrl = "enrollmentservice.svc/GetEnrollmentAdminSettings"
    let updateEmployeeUrl = "enrollmentservice.svc/UpdateEmployeeData"
    let claimStatusUrl = "claimsservice.svc/getclaimdetails"
    let FAQUrl = "faqsservice.svc/getfaqsdetails"
    let profileDetailsUrl = "userprofileservice.svc/getprofileinfo"
    let policyFeaturesUrl = "policyfeaturesservice.svc/getpolicyfeatures"
    let policyAnnexuresUrl = "policyfeaturesservice.svc/getpolicyannexures"
    let addDependentsUrl = "enrollmentservice.svc/AddDependantData"
    let updateDependantUrl = "enrollmentservice.svc/UpdateDependantData"
    let deleteDependantUrl = "enrollmentservice.svc/DeleteDependantData"
    let updateEmployeeEnrollmentDetailsUrl = "enrollmentservice.svc/UpdateEmployeeData"
    let hospitalsCountUrl = "hospitalService.svc/GetProvidersCount"

 
    let validatePostUrl = "loginservice.svc/ValidateOTP"
    let appSessionValuesPostUrl = "loginservice.svc/LoadSessionValues"
    let claimDetailsPostURl = "claimsservice.svc/LoadEmployeeClaimsValues"
    let claimDetailsPostURlJson = "EnrollmentDetails/LoadEmployeeClaimsValues"
    let LoadDetailedClaimsValuesURlJson = "EnrollmentDetails/LoadDetailedClaimsValues"
    let claimStatusDetailsPostURl = "claimsservice.svc/LoadDetailedClaimsValues"
    let ecardDetailsPostURl = "appservice/enrollmentservice.svc/GetEcard"
    let ecardDetailsPostURlJSON = "EnrollmentDetails/GetEcard"
    let contactDetailsPostURL = "escalationsservice.svc/LoadEscalationsValues"
    let utilitiesPostURL = "utilitiesservice.svc/LoadUtilitiesValues"
    let intimatedClaimsPostURL = "intimateclaimservice.svc/LoadIntimatedClaims"
    let imtimateClaimPostUrl = "intimateclaimservice.svc/IntimateClaim"
    let adminSettingsPostURL = "enrollmentservice.svc/AdminSettings"
    let hospitalsPostUrl = "hospitalservice.svc/LoadProviders"
    let submitQueryPostURL = "EmployeeQueries/PostQueries"
    let addDependantPostURL = "enrollmentservice.svc/AddDependants"
    let deleteDependantPostURL = "enrollmentservice.svc/DeleteDependants"
    let updateDependantPostURL = "enrollmentservice.svc/UpdateDependants"
    let relationsPostURL = "enrollmentservice.svc/GetRelation"
    let hospitalsPostURL = "hospitalservice.svc/LoadProviders"
    let addTopupPostURL = "enrollmentservice.svc/AddEditTopupData"
    let confirmDataPostURL = "enrollmentservice.svc/ConfirmData"

    let employeeQueriesGetUrl = "EmployeeQueries/GetAllEmployeeQueries?"
    let queryDetailsGetUrl = "EmployeeQueries/GetSpecificQueryDetails?"
    let markSolvedUrl = "query/MarkedSolved?CustQuerySrNo="
    let checkEnrollmentStatusUrl = "Enrollment/CheckEnrollmentSaved?"
    let sendFirebaseIdToServer = "loginservice.svc/SaveFireBaseID"
    let enrollmentSummaryFileV2 = "EmployeeEnrollement/EnrollmentSummaryFile"

    class func getSharedInstance()-> WebServiceManager
    {
        return sharedInstance
        
    }

    /*****PostUrls******/
    
    func getSendOtpPostUrl()-> String
    {
        let checkUrl=baseUrl+sendOtpPostUrl
        return checkUrl
    }
    
    func getSendOtpPostUrlPortal()-> String
    {
        let checkUrl=baseUrlPortal+sendOtpPostUrlPortal
        return checkUrl
    }
    
    func getWOOtpPostUrlPortal()-> String
    {
        let checkUrl=baseUrlPortal+WOOtpPostUrlPortal
        return checkUrl
    }
    func getSendWebLoginPostUrlPortal()-> String
    {
        let checkUrl=baseUrlPortal+sendWebLoginPostUrlPortal
        return checkUrl
    }
    
    
    func getValidateOtpPostUrl()-> String
    {
        let checkUrl=baseUrl+validatePostUrl
        return checkUrl
    }
    
    func getValidateOtpPostUrlPortal()-> String
    {
        let checkUrl=baseUrlPortal+validatePostUrlPortal
        return checkUrl
    }
    
    func getAppSessionValuesPostUrl()-> String
    {
        let checkUrl=baseUrl+appSessionValuesPostUrl
        return checkUrl
    }
    
    func getClaimDetailsPostUrl()-> String
    {
        let checkUrl=baseXmlUrl+claimDetailsPostURl
        return checkUrl
    }
    
    func getClaimDetailsPostUrlJson(groupChildSrNo : String, employeesrno : String)-> String
    {
        let checkUrl = newBaseurl+claimDetailsPostURlJson+"?groupchildsrno="+groupChildSrNo+"&employeesrno="+employeesrno
        
        return checkUrl
    }

    func getLoadDetailedClaimsValuesJson(groupChildSrNo : String, oegrpbasinfsrno : String,claimsrno : String)-> String
    {
        let checkUrl = newBaseurl+LoadDetailedClaimsValuesURlJson+"?groupchildsrno="+groupChildSrNo+"&oegrpbasinfsrno="+oegrpbasinfsrno+"&claimsrno="+claimsrno
        
        return checkUrl
    }

    func getClaimStatusDetailsPostUrl()-> String
    {
        let checkUrl=baseXmlUrl+claimStatusDetailsPostURl
        return checkUrl
    }
    func getEcardDetailsPostUrl()-> String
    {
        let checkUrl=baseUrlPortal+ecardDetailsPostURl
        return checkUrl
    }
    
    func getEcardDetailsPostUrlJSON(tpacode : String ,employeeno: String,policynumber: String,policycommencementdt:String,policyvaliduptodt:String,groupcode:String,oegrpno:String)-> String
    {
        let checkUrl=baseUrlV3+ecardDetailsPostURlJSON+"?tpacode="+tpacode+"&employeeno="+employeeno+"&policynumber="+policynumber+"&policycommencementdt="+policycommencementdt+"&policyvaliduptodt="+policyvaliduptodt+"&groupcode="+groupcode+"&OeGrpBasInfSrNo="+oegrpno
        return checkUrl
    }
    func getContactDetailsPostUrl()->String
    {
        let checkUrl=baseUrl+contactDetailsPostURL
        return checkUrl
    }
    
    func getContactDetailsPostUrlPortal(groupchildsrno : String, oegrpbasinfsrno : String)->String
    {
        let checkUrl=baseUrlPortal+contactDetailsPostURLPortal+"?GroupChildSrNo=\(groupchildsrno)&OegrpBasInfSrNo=\(oegrpbasinfsrno)"
        return checkUrl
    }
    
    func getUtilitiesPostUrl()->String
    {
        let checkUrl=baseUrl+utilitiesPostURL
        return checkUrl
    }
    
    func getUtilitiesPostUrlPortal(groupchildsrno : String, oegrpbasinfsrno : String)->String
    {
        let checkUrl=baseUrlPortal+utilitiesPostURLPortal+"?grpchildsrno=\(groupchildsrno)&oegrpbasinfosrno=\(oegrpbasinfsrno)"
        return checkUrl
    }
    
    func getIntimatedClaimPostUrl()->String
    {
        let checkUrl=baseUrl+intimatedClaimsPostURL
        return checkUrl
    }
    
    func getIntimatedClaimPostUrlPortal(EmpSrNo:String,GroupChildSrNo:String,oegrpbasinfsrno:String) -> String
    {
        let checkUrl=baseUrlPortal+intimatedClaimsPostURLPortal+"?employeesrno=\(EmpSrNo)"+"&groupchildsrno=\(GroupChildSrNo)"+"&oegrpbasinfsrno=\(oegrpbasinfsrno)"
        return checkUrl
    }
  
    
    //USed on newDashboaerd
    func getAdminSettingsValuesPostUrl()->String
    {
        let checkUrl=baseUrl+adminSettingsPostURL
        return checkUrl
    }
    func getintimateClaimPostUrl()->String
    {
        let checkUrl=baseUrl+imtimateClaimPostUrl
        return checkUrl
    }
    
    func getintimateClaimPostUrlPortal()->String
    {
        let checkUrl=baseUrlPortal+intimateClaimPostUrlPortal
        return checkUrl
    }
    
    func getHospitalsPostUrl()->String
    {
        let checkUrl=baseUrl+hospitalsPostUrl
        return checkUrl
    }
    func getAddDependantPostUrl()->String
    {
        let checkUrl=baseUrl+addDependantPostURL
        return checkUrl
    }
    func getDeleteDependantPostUrl()->String
    {
        let checkUrl=baseUrl+deleteDependantPostURL
        return checkUrl
    }
    func getUpdateDependantPostUrl()->String
    {
        let checkUrl=baseUrl+updateDependantPostURL
        return checkUrl
    }
    func getRelationsPostUrl()->String
    {
        let checkUrl=baseUrl+relationsPostURL
        return checkUrl
    }
    func getAddTopupPostUrl()->String
    {
        let checkUrl=baseUrl+addTopupPostURL
        return checkUrl
    }
    func getconfirmDataPostUrl()->String
    {
        let checkUrl=baseUrl+confirmDataPostURL
        return checkUrl
    }
    func getSubmitQueryUrl()->String
    {
        //let checkUrl=newBaseurl+submitQueryPostURL
        let checkUrl=newBaseurlPortal+submitQueryPostURL
        return checkUrl
    }
    func getmarkSolvedQueryUrl(queryNo:String)->String
    {
        let checkUrl=newBaseurl+markSolvedUrl+queryNo
        return checkUrl
    }
    func getHospitalDetailsPostUrl()->String
    {
        let checkUrl=baseUrl+hospitalsPostURL
        return checkUrl
    }
    
    func getHospitalDetailsPostUrlPortal()->String
    {
        let checkUrl=baseXmlUrl+hospitalsPostURL
        return checkUrl
    }
    
    
    /******GetUrls*******/
    func getSendOtpUrl(mobileNumber : String) -> String
    {
        return baseUrl+sendOtpUrl+mobileNumber
    }
    
    func getValidateOtpUrl(mobileNumber : String, OTP : String) -> String
    {
        return baseUrl+validateOtpUrl+mobileNumber+"/"+OTP
    }
    
    func getAppSesionValuesUrl(mobileNumber : String)->String
    {
        return baseUrl+appSessionValuesUrl+mobileNumber
        
    }
    func getEnrollmentDataSettings(groupchildsrno : String, oegrpbasinfsrno : String,employeesrno : String)->String
    {
        let checkUrl=baseUrl+dataSettingsUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)/\(employeesrno)"
        return checkUrl
    }
    func getEnrollmentDetailsUrl(groupchildsrno : String, oegrpbasinfsrno : String,employeesrno : String,productcode : String)->String
    {
        let checkUrl=baseUrl+enrollmentDetailsUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)/\(employeesrno)/\(productcode)"
        return checkUrl
    }
    func getIntimatedClaimUrl(empNo:String)->String
    {
        let checkUrl=baseUrl+intimatedClaimsUrl+"\(empNo)"
        return checkUrl
    }
    func getQueriesUrl(empSrNo:String)->String
    {
       // let checkUrl=newBaseurl+employeeQueriesGetUrl+"EmpSrNo=\(empSrNo)"
        let checkUrl=baseUrlPortal+employeeQueriesGetUrl+"EmpSrNo=\(empSrNo)"
        return checkUrl
    }
    func getOneQueryDetailsUrl(queryNo:String)->String
    {
        //let checkUrl=newBaseurl+queryDetailsGetUrl+"CustQuerySrNo=\(queryNo)"
        let checkUrl=newBaseurlPortal+queryDetailsGetUrl+"CustQuerySrNo=\(queryNo)"
        return checkUrl
    }
    func getcheckEnrollmentStatusUrl(empSrNo:String)->String
    {
        let checkUrl=newBaseurl+checkEnrollmentStatusUrl+"Id=\(empSrNo)"
        return checkUrl
    }
    
    
    
    
    
    func getIntimateNewClaimUrl(employeesrno:Int64,personsrno:Int32,diagnosis:String,claimamount:String,likelydoa:String,nameofhospital:String,locationofhospital:String)->String
    {
        let checkUrl=baseUrl+intimateNewClaimUrl+"\(employeesrno)/\(personsrno)/\(diagnosis)/\(claimamount)/\(likelydoa)/\(nameofhospital)/\(locationofhospital)"
        
        let escapedAddress = checkUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return escapedAddress!
    }
    func getPersonInfoForIntimation(employeesrno:String)->String
    {
        let checkUrl=baseUrl+personInfoForIntimationUrl+"\(employeesrno)"
        return checkUrl
    }
    
    func getPersonInfoForIntimationPortal(groupchildsrno : String, oegrpbasinfsrno : String, empSrNo:String)->String
    {
        let checkUrl=baseUrlPortal+personInfoForIntimationUrlPortal+"?employeeSrNo=\(empSrNo)&groupChildSrNo=\(groupchildsrno)&oegrpBasInfSrNo=\(oegrpbasinfsrno)"
        return checkUrl
    }
    
    
    func getContactDetailsUrl(groupchildsrno : String, oegrpbasinfsrno : String)->String
    {
        let checkUrl=baseUrl+contactDetailsUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)"
        return checkUrl
    }
    
    func getNetworkHospitalUrl(groupchildsrno : String, oegrpbasinfsrno : String,searchString:String)->String
    {
        let checkUrl=baseUrl+networkHospitalDetailsUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)/\(searchString)"
        let escapedAddress = checkUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return escapedAddress!
    }
    func getUtilitiesDetailsUrl(groupchildsrno : String, oegrpbasinfsrno : Int64)->String
    {
        let checkUrl=baseUrl+utilitiesDetailsUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)"
        return checkUrl
    }
    func getAdminSettingsUrl(groupchildsrno : String, oegrpbasinfsrno : String,employeesrno:String)->String
    {
        let checkUrl=baseUrl+adminSettingsUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)/\(employeesrno)"
        return checkUrl
    }
    
    func enrollmentSummaryFileURL(employeesrno:String) ->String{
        
        let url = baseUrlV3+enrollmentSummaryFileV2+"?EmpSrNo=\(employeesrno)"
        return url
    }
    
    func getUpdateEmployeeDetailsurl(groupchildsrno : String, oegrpbasinfsrno : String,employeesrno:String)->String
    {
        let checkUrl=baseUrl+updateEmployeeUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)/\(employeesrno)"
        return checkUrl
    }

    func getClaimStatusDetails(groupCode : String, oegrpbasinfsrno : String,employeesrno:String,tpaCode:String,productCode:String)->String
    {
        let checkUrl=baseUrl+claimStatusUrl+"/\(employeesrno)/\(oegrpbasinfsrno)/\(tpaCode)/\(groupCode)/\(productCode)"
//        let checkUrl=baseUrl+claimStatusUrl+"/1063977/285/HITS/HFSS/GMC"
        return checkUrl
    }
    
    func getFAQDetailsurl(groupchildsrno : String, oegrpbasinfsrno : String)->String
    {
        let checkUrl=baseUrl+FAQUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)"
        return checkUrl
    }
    
    func getEnrollStatusUrlPortal(employeesrno : String, GroupChildSrNo : String, OeGrpBasInfSrNo : String)->String
    {
        let checkUrl = baseUrlPortal+getEnrollStatusUrlPortal+"?employeesrno=\(employeesrno)&GroupChildSrNo=\(GroupChildSrNo)&OeGrpBasInfSrNo=\(OeGrpBasInfSrNo)"
        return checkUrl
    }
    
    func getFAQDetailsurlPortal(groupchildsrno : String, oegrpbasinfsrno : String)->String
    {
        let checkUrl = baseUrlPortal+faqPostUrlPortal+"?grpchildsrno=\(groupchildsrno)&oegrpbasinfosrno=\(oegrpbasinfsrno)"
        return checkUrl
    }
    
    func getClaimProcLayoutInfoPortal(groupchildsrno : String, oegrpbasinfsrno : String, product: String, layoutOfClaim: String)->String
    {
        let checkUrl = baseUrlPortal+getClaimProcLayoutInfoPortal+"?GroupChildSrNo=\(groupchildsrno)&OegrpBasInfSrNo=\(oegrpbasinfsrno)&Product=\(product)&LayoutOfClaim=\(layoutOfClaim)"
        return checkUrl
    }
    
    func getPolicyCoveragesDetailsPortal(groupchildsrno : String, oegrpbasinfsrno : String, productType: String, employeeSrNo: String, employeesrnoGMC: String)->String
    {
        let checkUrl = baseUrlPortal+getPolicyCoveragesDetailsPathPortal+"?GroupChildSrNo=\(groupchildsrno)&OegrpBasInfSrNo=\(oegrpbasinfsrno)&ProductType=\(productType)&EmployeeSrNo=\(employeeSrNo)&EmployeeSrNoGMC=\(employeesrnoGMC)"
        return checkUrl
    }
    
    
    
    func getLoadClaimProcImagePathPortal(groupchildsrno : String, oegrpbasinfsrno : String, product: String, layoutOfClaim: String)->String
    {
        let checkUrl = baseUrlPortal+getLoadClaimProcImagePathPotal+"?GroupChildSrNo=\(groupchildsrno)&OegrpBasInfSrNo=\(oegrpbasinfsrno)&Product=\(product)&LayoutOfClaim=\(layoutOfClaim)"
        return checkUrl
    }
    
    
    func getImageFilePathPortal(groupchildsrno : String, oegrpbasinfsrno : String, product: String, layoutOfClaim: String)->String
    {
        let checkUrl = webBaseUrlPortal+filePathsPortal+"/\(groupchildsrno)/\(groupchildsrno)-\(oegrpbasinfsrno)/displayimage/"
        
        return checkUrl
    }
    
    func getStepsFilePathPortal(groupchildsrno : String, oegrpbasinfsrno : String, product: String, layoutOfClaim: String)->String
    {
        let checkUrl = webBaseUrlPortal+filePathsPortal+"/\(groupchildsrno)/\(groupchildsrno)-\(oegrpbasinfsrno)/displayinstructions/"
        
        return checkUrl
    }
    
    func getClaimProcFilePathPortal(groupchildsrno : String, oegrpbasinfsrno : String, product: String, layoutOfClaim: String)->String
    {
        let checkUrl = webBaseUrlPortal+filePathsPortal+"/\(groupchildsrno)/\(groupchildsrno)-\(oegrpbasinfsrno)/displayadditionalinstructions/"
        
        return checkUrl
    }
    
    
    func getCoveragePolicyDataPortal(groupchildsrno : String, oegrpbasinfsrno : String)->String
    {
        let checkUrl = baseUrlPortal+getCoveragePolicyDataPathPortal+"?GroupChildSrNo=\(groupchildsrno)&OegrpBasInfSrNo=\(oegrpbasinfsrno)"
        return checkUrl
    }
    
    func getClaimProcInstructionInfoPortal(groupchildsrno : String, oegrpbasinfsrno : String, product: String, layoutOfClaim: String)->String
    {
        let checkUrl = baseUrlPortal+getClaimProcInstructionInfoPathPortal+"?GroupChildSrNo=\(groupchildsrno)&OegrpBasInfSrNo=\(oegrpbasinfsrno)&Product=\(product)&LayoutOfClaim=\(layoutOfClaim)"
        return checkUrl
    }
    
    func getEmergencyContactNoPortal(TpaCode : String)->String
    {
        let checkUrl = baseUrlPortal+getEmergencyContactNoPathPortal+"?TpaCode=\(TpaCode)"
        return checkUrl
    }
    
    func getClaimProcTextPathPortal(groupchildsrno : String, oegrpbasinfsrno : String, product: String, layoutOfClaim: String)->String
    {
        let checkUrl = baseUrlPortal+getClaimProcTextPathPotal+"?GroupChildSrNo=\(groupchildsrno)&OegrpBasInfSrNo=\(oegrpbasinfsrno)&Product=\(product)&LayoutOfClaim=\(layoutOfClaim)"
        return checkUrl
    }
    
    
    func getProfileDetailsurl(groupchildsrno : String, oegrpbasinfsrno : String,employeesrno:String)->String
    {

        let checkUrl=baseUrlPortal+loaduserprofiledetailsPathPortal+"?grpchildsrno=\(groupchildsrno)&oegrpbasinfosrno=\(oegrpbasinfsrno)&empsrno=\(employeesrno)"
        
        return checkUrl
    }
    
    func getPolicyFeatresUrl(groupchildsrno : String, oegrpbasinfsrno : String, productId:String)->String
    {
        let checkUrl=baseUrl+policyFeaturesUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)/\(productId)"
        return checkUrl
    }
    
    func getPolicyFeatresUrlPortal(groupchildsrno : String, oegrpbasinfsrno : String, productId:String)->String
    {
        let checkUrl=baseUrlPortal+policyFeaturesUrlPortal+"?grpchildsrno=\(groupchildsrno)&oegrpbasinfosrno=\(oegrpbasinfsrno)&productype=\(productId)"
        return checkUrl
    }
    
    func getPolicyAnnexuresUrl(groupchildsrno : String, oegrpbasinfsrno : String)->String
    {
        let checkUrl=baseUrl+policyAnnexuresUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)"
        return checkUrl
    }
//    func getPolicyAnnexuresUrl(groupchildsrno : String, oegrpbasinfsrno : String)->String
//    {
//        let checkUrl=baseUrl+policyAnnexuresUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)"
//        return checkUrl
//    }
    
    func getAddDependentUrl(employeesrno:String,age:String,dateofbirth:String,relationid:String,personname:String,dateofmarriage:String,windowperiodactive:String,parpolicyseperate:String,groupchildsrno:String,oegrpbasinfsrno:String)->String
    {
        let checkUrl=baseUrl+addDependentsUrl+"/\(age)/\(dateofbirth)/\(relationid)/\(personname)/\(dateofmarriage)/\(windowperiodactive)/\(parpolicyseperate)/\(employeesrno)/\(groupchildsrno)/\(oegrpbasinfsrno)"
        return checkUrl
    }
    func getupdateDependantUrl(personSrNo:String,age:String,dateofbirth:String,personname:String)->String
    {
        let checkUrl=baseUrl+updateDependantUrl+"/\(personSrNo)/\(age)/\(dateofbirth)/\(personname)"
        return checkUrl
    }
    func getDeleteDependantUrl(employeesrno:String,personSrNo:String, groupchildsrno : String)->String
    {
        let checkUrl=baseUrl+deleteDependantUrl+"/\(personSrNo)/\(employeesrno)/\(groupchildsrno)"
        return checkUrl
    }
    func getUpdateEmployeeEnrollmentDetailsUrl(employeesrno:String,personSrNo:String, groupchildsrno : String,mobileNO:String, officialMailId : String,personalMailId : String)->String
    {
        let checkUrl=baseUrl+updateEmployeeEnrollmentDetailsUrl+"/\(employeesrno)/\(personSrNo)/\(groupchildsrno)/\(mobileNO)/\(officialMailId)/\(personalMailId)"
        return checkUrl
    }
    
    
    
    func getEnrollmentSummery(employeesrno:String,name:String,empID:String)->String
    {
        let checkUrl="https://portal.mybenefits360.com/mybenefits/flex/flexsummary/"+"\(employeesrno)/\(name)-\(empID).pdf"

        let escapedAddress = checkUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return escapedAddress!
    }
    
    
    func getHospitalsCountUrl(groupchildsrno : String, oegrpbasinfsrno : String,searchString:String)->String
    {
        //let checkUrl=baseXmlUrl+hospitalsCountUrl+"/\(groupchildsrno)/\(oegrpbasinfsrno)/\(searchString)"
        let checkUrl=newBaseurl+"EnrollmentDetails/GetProvidersCount?groupchildsrno=\(groupchildsrno)&oegrpbasinfsrno=\(oegrpbasinfsrno)&hospitalsearchtext=\(searchString)"
        
        return checkUrl
//        let escapedAddress = checkUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        return escapedAddress!
    }
    
    //Added By Pranit
     //To store Firebase Id On Server
     func saveFirebaseIdUrl() -> String {
         
         let url = baseUrl + sendFirebaseIdToServer
         return url
     }
    
    func getRefreshUserToken(employeeSrno: String, personSrnNo: String, employeIdNo: String) -> String{
        let url = baseUrlPortal + refreshUserToken + "?usrno1=\(employeeSrno)&usrno2=\(personSrnNo)&usrno3=\(employeIdNo)"
        
        return url
    }
    
}

