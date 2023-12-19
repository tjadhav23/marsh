//
//  StatusHolder.swift
//  MyBenefits
//
//  Created by Semantic on 11/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class StatusHolder: NSObject
{
     static let sharedInstance = StatusHolder()
    
    class func getSharedInstance() -> StatusHolder
    {
        return sharedInstance
    }
    var results: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue: String?
    
    var m_searchArray : Array<String>=[]
    
    var m_employeeSrNo = String()
  
          let AppStatus = "AppStaus"
          let AppMobileNo = "mobileno"
          let AppGroupchildsrno = "GROUPCHILDSRNO"
          let AppOegrpbasinfsrno = "OE_GRP_BAS_INF_SR_NO"
          let AppGroupcode = "groupcode"
          let AppTpacode = "tpacode"
          let AppEmployeesrno = "EMPLOYEESRNO"
          let AppEmployeeid = "empid"
          let AppPolicyno = "Policyno"
          let AppPolicycommdt = "Policycommdt"
          let AppPolicyvalidupto = "Policyvalidupto"
          let AppInscoformname = "Inscoformname"
          let AppUserName = "UserName"
          let AppGender = "Gender"
          let GROUPNAME = "GROUPNAME"
          let TPANAME = "TPANAME"
          let PRODUCTCODE = "PRODUCTCODE"
          let INSCODE = "INSCODE"
   
    
    
   
          let AppStatusGPA = "AppStausGPA"
          let AppMobileNoGPA = "mobilenoGPA"
          let AppGroupchildsrnoGPA = "groupchildGPA"
          let AppOegrpbasinfsrnoGPA = "oegrpbasinfoGPA"
          let AppGroupcodeGPA = "groupcodeGPA"
          let AppTpacodeGPA = "tpacodeGPA"
          let AppEmployeesrnoGPA = "empsrnoGPA"
          let AppEmployeeidGPA = "empidGPA"
          let AppPolicynoGPA = "PolicynoGPA"
          let AppPolicycommdtGPA = "PolicycommdtGPA"
          let AppPolicyvaliduptoGPA = "PolicyvaliduptoGPA"
          let AppInscoformnameGPA = "InscoformnameGPA"
          let AppUserNameGPA = "UserNameGPA"
          let AppGenderGPA = "GenderGPA"
          let GROUPNAMEGPA = "GROUPNAMEGPA"
          let TPANAMEGPA = "TPANAMEGPA"
          let PRODUCTCODEGPA = "PRODUCTCODEGPA"
          let INSCODEGPA = "INSCODEGPA"
   
          let AppStatusGTL = "AppStausGTL"
          let AppMobileNoGTL = "mobilenoGTL"
          let AppGroupchildsrnoGTL = "groupchildGTL"
          let AppOegrpbasinfsrnoGTL = "oegrpbasinfoGTL"
          let AppGroupcodeGTL = "groupcodeGTL"
          let AppTpacodeGTL = "tpacodeGTL"
          let AppEmployeesrnoGTL = "empsrnoGTL"
          let AppEmployeeidGTL = "empidGTL"
          let AppPolicynoGTL = "PolicynoGTL"
          let AppPolicycommdtGTL = "PolicycommdtGTL"
          let AppPolicyvaliduptoGTL = "PolicyvaliduptoGTL"
          let AppInscoformnameGTL = "InscoformnameGTL"
          let AppUserNameGTL = "UserNameGTL"
          let AppGenderGTL = "GenderGTL"
          let GROUPNAMEGTL = "GROUPNAMEGTL"
          let TPANAMEGTL = "TPANAMEGTL"
          let PRODUCTCODEGTL = "PRODUCTCODEGTL"
          let INSCODEGTL = "INSCODEGTL"
  
    
    static   let cashlessdata = "<html>" +
        "<body>" +
        "<table style='width:100%;' cellpadding='0' cellspacing='0'>" +
        "<tr><td style='padding: 2px 10px 10px 10px;font-size= 11'><img src='https://www.lnginsurance.com/static_references/Images/app/Cashless_steps.png' alt='cashless steps' width='100%' min-height='70%' style='border: 2px solid #e7e7e7;' /></td></tr>" +//Poppins-Medium
        "<tr><td style='font-size: 22px; padding: 2px 10px 2px 10px; font-family: Poppins-Medium; color: #304FFE;'><strong>Cashless Procedure</strong></td></tr>" +
        "<tr><td style='font-size: 16px; padding: 2px 10px 2px 10px; font-family: Poppins-Medium; color: #0D3F7E;'>" +
        "<ul style='padding: 2px 5px 2px 20px;'>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 1 :</strong> <br/> Walk into Network Hospital of your choice and produce your Health ID card and Photo ID card at the TPA helpdesk or reception. List of Network Hospitals is available on MyBenefitsApp and check whether hospital is in Network of the TPA. Also carry any previous consultation notes or investigation reports if available.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 2 :</strong> <br/> Hospital will send Cashless hospitalisation request to your TPA within 24 hours from date of admission. Hospital may ask for certain deposit amount at the time of admission which will be refunded back on approval of payment from the TPA.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 3 :</strong> <br/> TPA reverts within 3 hours of receipt of cashless request. In case of any issues, your customer service representative will assist you for any queries or documentation.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 4 :</strong> <br/> TPA will authorise Cashless Amount as per your Policy Definition and send it to the hospital.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 5 :</strong> <br/> Avail treatment from the Hospital and get discharged. Before discharge, ensure that you pay for any non-medical expenses and sign relevant documents if any.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 6 :</strong> <br/> Hospital will send final bill to TPA for processing and payment.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 7 :</strong> <br/> TPA processes the claims and makes payment to the hospital as per claims admissibility.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong><span style='color: #ef4437;'>Note :</span></strong> <br/> Denial of 'Cashless Service' is not denial of treatment. You can continue with the treatment, pay for the services to the hospital, and later send the claim for reimbursement claim process.</li>" +
        "</ul>" +
        "</td></tr> " +
        "</table>" +
        "</body>" +
    "</html>"
    
    static  let reimbursementData = "<html>" +
        "<body>" +
        "<table style='width:100%;' cellpadding='0' cellspacing='0'>" +
        "<tr><td style='padding: 2px 10px 10px 10px; font-size= 11'><img src='https://www.lnginsurance.com/static_references/Images/app/Reimbursement_steps.png' class='img-responsive' alt='reimbursement steps' width='100%' min-height='70%' style='border: 2px solid #e7e7e7;' /></td></tr>" +
        "<tr><td style='font-size: 22px; padding: 2px 10px 2px 10px; font-family: Poppins-Medium; color: #304FFE;'><strong>Reimbursement Procedure</strong></td></tr>" +
        "<tr><td style='font-size: 16px; padding: 2px 10px 2px 10px; font-family: Poppins-Medium; color: #303F9F;'>" +
        "<ul style='padding: 2px 5px 2px 20px;'>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 1 :</strong> <br/> Intimate about your hospitalisation by clicking on the contact numbers available on MyBenefitsApp. Intimation of Hospitalisation should be done immediately on admission. In case of planned hospitalisation intimate prior to admission.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 2 :</strong> <br/> Get admitted to Hospital of your choice, and pay for your treatment.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 3 :</strong> <br/> Submit all necessary documents along with duly filled claim form to the TPA within 15 days of discharge. Checklist of claim documents is mentioned below.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 4 :</strong> <br/> TPA will determine whether the condition requiring admission & the treatment are as per policy coverage. All Non-payable expenses will not be paid.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 5 :</strong> <br/> In case if any additional documents are required, a Deficiency Letter will be mailed to you. Submit the deficient documents within the stipulated time period mentioned in the letter. If you fail to submit the documents in the mentioned timeframe, 2 more reminders will be mailed to you, subsequent to which your claim will be closed. Re-opening of the claim will be at the discretion of the Insurance Company. In case of any issues, your customer service representative will assist you for any queries or documentation.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 6 :</strong> <br/> Based on processing of the claim, a denial or approval is executed.</li>" +
        "<li style='padding: 2px 2px 10px 2px;'><strong>Step 7 :</strong> <br/> In case of denial, a rejection letter is mailed to you stating the reason for rejection. In case of approval a settlement is made by transferring the approved amount to your Bank Account.</li>" +
        "</ul>" +
        "</td></tr> " +
        "<tr><td style='font-size: 18px; padding: 2px 5px 2px 10px; font-family: Poppins-Medium; color: #304FFE;'><strong>Claim Documents Checklist</strong></td></tr>" +
        "<tr><td style='font-size: 16px; padding: 2px 10px 2px 10px; font-family: Poppins-Medium; color: #303F9F;'>" +
        "<ul style='padding: 2px 5px 2px 20px;'>" +
        "<li style='padding: 2px 2px 2px 2px;'>Original Hospital Final Bill</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>Original Numbered Receipts for payments made to the Hospital</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>Complete Break-up of the Hospital Bill</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>Original Discharge Card / Summary</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>All Original Investigation Reports</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>All Original Medicine / Chemist Bills with relevant prescriptions</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>Original Signed Claim Form</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>E-card Copy</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>Intimation Mail Copy</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>Paginated photo copies of Indoor Case papers of hospitalisation attested by the hospital</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>Latest USG (Ultra-sound Sonography Report) / Sonography Report in case of Maternity Related Claim</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>Stickers & Invoice of implants / Lens used during surgery</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>FIR (First Information Report) / MLC (Medico Legal Certificate) Copy, in case of Road Accidents. If MLC is not applicable then written confirmation from the first consulting Doctor / Hospital that the patient was not under influence of alcohol or drug along with Self Declaration of incident</li>" +
        "<li style='padding: 2px 2px 2px 2px;'>Documents for NEFT Transfer of payment for settlement of claim i.e. a cancelled cheque of employee's bank account with account no, IFSC Code, MICR code</li>" +
        "</ul>" +
        "</td></tr> " +
        "</table>" +
        "</body>" +
    "</html>";
    
    
}

