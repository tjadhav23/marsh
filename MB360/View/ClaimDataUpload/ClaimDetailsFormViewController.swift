//
//  ClaimDetailsFormViewController.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 07/09/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar

protocol ClaimDetailsFormDelegate: AnyObject {
    func selectionStatusDidChange(isSuccess: Bool)
}

struct passData {
    var claim_intimated : String
    var clm_pre_hosp : String
    var clm_main_hosp : String
    var clm_post_hosp : String
    var doc_req_by : String
    var clm_int_sr_no : String
    var clm_intimation_no : String
    var person_sr_no : String
    var clm_Dest : String
    var clm_docs_upload_req_sr_no : String
    var clm_req_docs_sr_no : String
}

class ClaimDetailsFormViewController: UIViewController,FlexibleSteppedProgressBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var quest1_option1: UIView!
    @IBOutlet weak var quest1_option2: UIView!
    
    
    @IBOutlet weak var quest2_View: UIView!
    @IBOutlet weak var quest2_option1: UIView!
    @IBOutlet weak var quest2_option2: UIView!
    
    @IBOutlet weak var quest2_View_Height: NSLayoutConstraint!
    @IBOutlet weak var quest2_option1_Lbl_Height: NSLayoutConstraint!
    @IBOutlet weak var quest2_option1_img_Height: NSLayoutConstraint!
    
    @IBOutlet weak var quest2_option2_img_Height: NSLayoutConstraint!
    @IBOutlet weak var quest2_option2_Lbl_Height: NSLayoutConstraint!
    
    @IBOutlet weak var quest3_option1: UIView!
    @IBOutlet weak var quest3_option2: UIView!
    @IBOutlet weak var quest3_option3: UIView!
    
    
    @IBOutlet weak var quest1_radio1: UIImageView!
    @IBOutlet weak var quest1_radio2: UIImageView!
    
    @IBOutlet weak var quest2_radio1: UIImageView!
    @IBOutlet weak var quest2_radio2: UIImageView!
    
    @IBOutlet weak var quest3_check1: UIImageView!
    @IBOutlet weak var quest3_check2: UIImageView!
    @IBOutlet weak var quest3_check3: UIImageView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var progressBarView: UIView!
    
    var isChecked1 = false
    var isChecked2 = false
    var isChecked3 = false
    
    var isQuest1Selected = false
    var isQuest2Selected = false
    var isQuest3Selected = false
    
    var isClaimIntimated : String = ""
    var clm_pre_hosp : String = "0"
    var clm_main_hosp : String = "0"
    var clm_post_hosp : String = "0"
    var clm_dest : String = ""
    
     var delegate: ClaimDetailsFormDelegate? = nil
       weak var containerViewController: ClaimContainerViewController?
    private var progressBarWithDifferentDimensions: FlexibleSteppedProgressBar!
    var progressColor = FontsConstant.shared.app_FontPrimaryColor
    var textColorHere = FontsConstant.shared.app_FontPrimaryColor
    var backgroundColor = UIColor(hexString: "#C2C2C2") // LIGHT Grey
    var passDict : [String:String] = [:]
    var isFromEdit : Bool = false
    var editData : AaDatum? = nil

    let vc : ClaimBeneficiaryDetailsViewController = ClaimBeneficiaryDetailsViewController()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isScrollEnabled = false
        setupUI()
       
    }
    
    func setupUI() {
        // Border Color initial
        quest1_option1.layer.borderWidth = 0.8
        quest1_option1.layer.cornerRadius = cornerRadiusForView
        quest1_option1.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
        
        quest1_option2.layer.borderWidth = 0.8
        quest1_option2.layer.cornerRadius = cornerRadiusForView
        quest1_option2.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
        
        quest2_option1.layer.borderWidth = 0.8
        quest2_option1.layer.cornerRadius = cornerRadiusForView
        quest2_option1.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
        
        quest2_option2.layer.borderWidth = 0.8
        quest2_option2.layer.cornerRadius = cornerRadiusForView
        quest2_option2.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
        
        quest3_option1.layer.borderWidth = 0.8
        quest3_option1.layer.cornerRadius = cornerRadiusForView
        quest3_option1.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
        
        quest3_option2.layer.borderWidth = 0.8
        quest3_option2.layer.cornerRadius = cornerRadiusForView
        quest3_option2.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
        
        quest3_option3.layer.borderWidth = 0.8
        quest3_option3.layer.cornerRadius = cornerRadiusForView
        quest3_option3.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
        btnNext.layer.cornerRadius = cornerRadiusForView
        btnNext.isUserInteractionEnabled = false
        btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
        
        // Add AutoLayout constraints for progressBarView
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressBarView.topAnchor.constraint(equalTo: view.topAnchor),
            progressBarView.heightAnchor.constraint(equalToConstant: 100.0), // Set the height to 100
        ])
        //setupProgressBarWithDifferentDimensions()
    }
    
    func setupProgressBarWithDifferentDimensions() {
        progressBarWithDifferentDimensions = FlexibleSteppedProgressBar()
        progressBarWithDifferentDimensions.translatesAutoresizingMaskIntoConstraints = false
        progressBarView.addSubview(progressBarWithDifferentDimensions)

        // iOS9+ auto layout code
        let horizontalConstraint = progressBarWithDifferentDimensions.centerXAnchor.constraint(equalTo: progressBarView.centerXAnchor)
        let verticalConstraint = progressBarWithDifferentDimensions.topAnchor.constraint(
            equalTo: progressBarView.topAnchor,
            constant: 0 // position from top for bar
        )

        let widthConstraint = progressBarWithDifferentDimensions.widthAnchor.constraint(equalTo: progressBarView.widthAnchor, constant: -80)
        widthConstraint.isActive = true

        let heightConstraint = progressBarWithDifferentDimensions.heightAnchor.constraint(equalTo: progressBarView.heightAnchor)

        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])

        progressBarWithDifferentDimensions.numberOfPoints = 3
        progressBarWithDifferentDimensions.lineHeight = 3
        progressBarWithDifferentDimensions.radius = 6
        progressBarWithDifferentDimensions.progressRadius = 11
        progressBarWithDifferentDimensions.progressLineHeight = 3
        progressBarWithDifferentDimensions.delegate = self
        progressBarWithDifferentDimensions.useLastState = true
        progressBarWithDifferentDimensions.lastStateCenterColor = progressColor
        progressBarWithDifferentDimensions.selectedBackgoundColor = progressColor
        progressBarWithDifferentDimensions.selectedOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.lastStateOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.currentSelectedCenterColor = progressColor
        progressBarWithDifferentDimensions.stepTextColor = textColorHere
        progressBarWithDifferentDimensions.currentSelectedTextColor = progressColor
        progressBarWithDifferentDimensions.completedTillIndex = 0
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == progressBarWithDifferentDimensions {
            if position == FlexibleSteppedProgressBarTextLocation.bottom {
                switch index {

                case 0: return "Claims Details"
                case 1: return "Beneficiary Details"
                case 2: return "File Upload"
                default: return ""

                }
            }
        }
        return ""
    }
    
    @IBAction func btnNextAct(_ sender: UIButton) {
       // passData.init(claim_intimated: isClaimIntimated, clm_pre_hosp: clm_pre_hosp, clm_main_hosp: clm_main_hosp, clm_post_hosp: clm_post_hosp, doc_req_by: "", clm_int_sr_no: "", clm_intimation_no: "", person_sr_no: "")
        var passdata : passData? = nil
        if isFromEdit{
            passdata = passData(claim_intimated: isClaimIntimated, clm_pre_hosp: clm_pre_hosp, clm_main_hosp: clm_main_hosp, clm_post_hosp: clm_post_hosp, doc_req_by: "", clm_int_sr_no: "", clm_intimation_no: "", person_sr_no: "",clm_Dest: clm_dest,clm_docs_upload_req_sr_no: editData!.clmDocsUploadReqSrNo,clm_req_docs_sr_no: "")
            vc.isFromEdit = true
            vc.editData = editData
        }else{
        passdata = passData(claim_intimated: isClaimIntimated, clm_pre_hosp: clm_pre_hosp, clm_main_hosp: clm_main_hosp, clm_post_hosp: clm_post_hosp, doc_req_by: "", clm_int_sr_no: "", clm_intimation_no: "", person_sr_no: "",clm_Dest: clm_dest,clm_docs_upload_req_sr_no: "",clm_req_docs_sr_no: "")
            vc.isFromEdit = false
        }
        vc.passdata = passdata
        navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor), hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        navigationItem.leftBarButtonItem = getBackButton()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Claim Data Upload"
        menuButton.isHidden = true
        DispatchQueue.main.async() {
            menuButton.isHidden = true
        }
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        if isFromEdit{
           print(editData)
            setDataForEdit()
           
        }
        
        viewTapped()
        
    }
    func viewTapped() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        quest1_option1.addGestureRecognizer(tapGesture1)
        quest1_option1.isUserInteractionEnabled = true
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        quest1_option2.addGestureRecognizer(tapGesture2)
        quest1_option2.isUserInteractionEnabled = true
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        quest2_option1.addGestureRecognizer(tapGesture3)
        quest2_option1.isUserInteractionEnabled = true
        
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        quest2_option2.addGestureRecognizer(tapGesture4)
        quest2_option2.isUserInteractionEnabled = true
        
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        quest3_option1.addGestureRecognizer(tapGesture5)
        quest3_option1.isUserInteractionEnabled = true
        
        let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        quest3_option2.addGestureRecognizer(tapGesture6)
        quest3_option2.isUserInteractionEnabled = true
        
        let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        quest3_option3.addGestureRecognizer(tapGesture7)
        quest3_option3.isUserInteractionEnabled = true
    }
    
    func setDataForEdit(){
        if editData?.claimIntimated.lowercased() == "claim intimated"{
            isQuest1Selected = true
            isClaimIntimated = "1"
            quest1_radio1.image = UIImage(named: "greyRadioClose")
            quest1_radio2.image = UIImage(named: "greyRadioOpen")
            quest1_option1.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
            quest1_option2.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
            
            //2nd view show
            quest2_View_Height.constant = 138
            quest2_option1_Lbl_Height.constant = 25
            quest2_option1_img_Height.constant = 20
            
            quest2_option2_Lbl_Height.constant = 25
            quest2_option2_img_Height.constant = 20
        }else{
            isQuest1Selected = true
            isClaimIntimated = "0"
            quest1_radio1.image = UIImage(named: "greyRadioOpen")
            quest1_radio2.image = UIImage(named: "greyRadioClose")
            quest1_option2.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
            quest1_option1.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
            //2nd view hide
            quest2_View_Height.constant = 0
            quest2_option1_Lbl_Height.constant = 0
            quest2_option1_img_Height.constant = 0
            
            quest2_option2_Lbl_Height.constant = 0
            quest2_option2_img_Height.constant = 0
            
            quest2_radio1.image = UIImage(named: "greyRadioOpen")
            quest2_radio2.image = UIImage(named: "greyRadioOpen")
            vc.claimIntimatedPalce = ""
        }
        
        if editData?.claimIntimatedDest.lowercased() == "benefits you"{
            isQuest2Selected = true
            clm_dest = "1"
            quest2_radio1.image = UIImage(named: "greyRadioClose")
            quest2_radio2.image = UIImage(named: "greyRadioOpen")
            quest2_option1.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
            quest2_option2.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
            vc.claimIntimatedPalce = "Benefits you"
        }else{
            isQuest2Selected = true
            clm_dest = "2"
            quest2_radio1.image = UIImage(named: "greyRadioOpen")
            quest2_radio2.image = UIImage(named: "greyRadioClose")
            quest2_option2.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
            quest2_option1.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
            vc.claimIntimatedPalce = "Third party administrator (TPA)"
        }
        
        var arrTypeOfClaim = editData?.typeOfClaim.components(separatedBy: "+")
        print(arrTypeOfClaim)
        
        if arrTypeOfClaim?.count == 1{
            
            if editData!.typeOfClaim.lowercased().contains("pre-hospitalisation"){
                isChecked1.toggle()
                quest3_option1.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check1, isChecked: isChecked1, vew: quest3_option1)
                clm_pre_hosp = "1"
                clm_main_hosp = "0"
                clm_post_hosp = "0"
            }
            
            if editData!.typeOfClaim.lowercased().contains("main-hospitalisation"){
                isChecked2.toggle()
                quest3_option2.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check2, isChecked: isChecked2, vew: quest3_option2)
                clm_pre_hosp = "0"
                clm_main_hosp = "1"
                clm_post_hosp = "0"
            }
            
            if editData!.typeOfClaim.lowercased().contains("post-hospitalisation"){
                isChecked3.toggle()
                quest3_option3.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check3, isChecked: isChecked3, vew: quest3_option3)
                clm_pre_hosp = "0"
                clm_main_hosp = "0"
                clm_post_hosp = "1"
            }
        }else if arrTypeOfClaim?.count == 2{
            if editData!.typeOfClaim.lowercased().contains("pre-hospitalisation") && editData!.typeOfClaim.lowercased().contains("main-hospitalisation") {
                isChecked1.toggle()
                quest3_option1.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check1, isChecked: isChecked1, vew: quest3_option1)
                isChecked2.toggle()
                quest3_option2.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check2, isChecked: isChecked2, vew: quest3_option2)
                clm_pre_hosp = "1"
                clm_main_hosp = "1"
                clm_post_hosp = "0"
            }else if editData!.typeOfClaim.lowercased().contains("main-hospitalisation") && editData!.typeOfClaim.lowercased().contains("post-hospitalisation") {
                isChecked2.toggle()
                quest3_option2.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check2, isChecked: isChecked2, vew: quest3_option2)
                isChecked3.toggle()
                quest3_option3.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check3, isChecked: isChecked3, vew: quest3_option3)
                clm_pre_hosp = "0"
                clm_main_hosp = "1"
                clm_post_hosp = "1"
            }else if editData!.typeOfClaim.lowercased().contains("pre-hospitalisation") && editData!.typeOfClaim.lowercased().contains("post-hospitalisation") {
                isChecked1.toggle()
                quest3_option1.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check1, isChecked: isChecked1, vew: quest3_option1)
                isChecked3.toggle()
                quest3_option3.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check3, isChecked: isChecked3, vew: quest3_option3)
                clm_pre_hosp = "1"
                clm_main_hosp = "0"
                clm_post_hosp = "1"
            }
            
        }else{
            isChecked1.toggle()
            quest3_option1.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
            updateCheckImage(for: quest3_check1, isChecked: isChecked1, vew: quest3_option1)
            isChecked2.toggle()
            quest3_option2.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
            updateCheckImage(for: quest3_check2, isChecked: isChecked2, vew: quest3_option2)
            isChecked3.toggle()
            quest3_option3.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
            updateCheckImage(for: quest3_check3, isChecked: isChecked3, vew: quest3_option3)
            
            clm_pre_hosp = "1"
            clm_main_hosp = "1"
            clm_post_hosp = "1"
        }
        
        if (isQuest1Selected && isClaimIntimated == "0" && (isChecked1 || isChecked2 || isChecked3)) || (isQuest1Selected && isClaimIntimated == "1" && isQuest2Selected && (isChecked1 || isChecked2 || isChecked3)) {
            print("Success")
            btnNext.isUserInteractionEnabled = true
            btnNext.backgroundColor = FontsConstant.shared.app_FontAppColor
        } else {
            print("failure")
            btnNext.isUserInteractionEnabled = false
            btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
            //delegate?.selectionStatusDidChange(isSuccess: false)
        }
        
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        if let tappedView = sender.view {
            let tappedViewTag = tappedView.tag
            print("View with tag \(tappedViewTag) tapped!")
            
            switch tappedViewTag {
            case 1:
                isQuest1Selected = true
                isClaimIntimated = "1"
                quest1_radio1.image = UIImage(named: "greyRadioClose")
                quest1_radio2.image = UIImage(named: "greyRadioOpen")
                quest1_option1.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                quest1_option2.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
                
                //2nd view show
                quest2_View_Height.constant = 138
                quest2_option1_Lbl_Height.constant = 25
                quest2_option1_img_Height.constant = 20
                
                quest2_option2_Lbl_Height.constant = 25
                quest2_option2_img_Height.constant = 20
                
            case 2:
                isQuest1Selected = true
                isClaimIntimated = "0"
                quest1_radio1.image = UIImage(named: "greyRadioOpen")
                quest1_radio2.image = UIImage(named: "greyRadioClose")
                quest1_option2.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                quest1_option1.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
                //2nd view hide
                quest2_View_Height.constant = 0
                quest2_option1_Lbl_Height.constant = 0
                quest2_option1_img_Height.constant = 0
                
                quest2_option2_Lbl_Height.constant = 0
                quest2_option2_img_Height.constant = 0
                
//                quest2_radio1.image = UIImage(named: "greyRadioOpen")
//                quest2_radio2.image = UIImage(named: "greyRadioOpen")
//                vc.claimIntimatedPalce = ""
                
            case 3:
                isQuest2Selected = true
                clm_dest = "1"
                quest2_radio1.image = UIImage(named: "greyRadioClose")
                quest2_radio2.image = UIImage(named: "greyRadioOpen")
                quest2_option1.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                quest2_option2.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
                vc.claimIntimatedPalce = "Benefits you"
                
            case 4:
                isQuest2Selected = true
                clm_dest = "2"
                quest2_radio1.image = UIImage(named: "greyRadioOpen")
                quest2_radio2.image = UIImage(named: "greyRadioClose")
                quest2_option2.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                quest2_option1.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
                vc.claimIntimatedPalce = "Third party administrator (TPA)"
            case 5:
                isChecked1.toggle()
                print(isChecked1)
                quest3_option1.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check1, isChecked: isChecked1, vew: quest3_option1)
                if isChecked1{
                    clm_pre_hosp = "1"
                }else{
                    clm_pre_hosp = "0"
                }
//                clm_main_hosp = "0"
//                clm_post_hosp = "0"
            case 6:
                isChecked2.toggle()
                quest3_option2.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check2, isChecked: isChecked2, vew: quest3_option2)
                if isChecked2{
                    clm_main_hosp = "1"
                }else{
                    clm_main_hosp = "0"
                }
            case 7:
                isChecked3.toggle()
                quest3_option3.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
                updateCheckImage(for: quest3_check3, isChecked: isChecked3, vew: quest3_option3)
                if isChecked3{
                    clm_post_hosp = "1"
                }else{
                    clm_post_hosp = "0"
                }

            default:
                break
            }
            

            if (isQuest1Selected && isClaimIntimated == "0" && (isChecked1 || isChecked2 || isChecked3)) || (isQuest1Selected && isClaimIntimated == "1" && isQuest2Selected && (isChecked1 || isChecked2 || isChecked3)) {
                print("Success")
                btnNext.isUserInteractionEnabled = true
                btnNext.backgroundColor = FontsConstant.shared.app_FontAppColor
            } else {
                print("failure")
                btnNext.isUserInteractionEnabled = false
                btnNext.backgroundColor = FontsConstant.shared.app_FontLightGreyColor
                //delegate?.selectionStatusDidChange(isSuccess: false)
            }
        }
    }
    
    func updateCheckImage(for imageView: UIImageView, isChecked: Bool , vew : UIView) {
        if isChecked {
            imageView.image = UIImage(named: "Check Box - Checked-1")
            vew.layer.borderColor = FontsConstant.shared.HosptailLblPrimary.cgColor
        } else {
            imageView.image = UIImage(named: "Check Box - Unchecked-1")
            vew.layer.borderColor = FontsConstant.shared.app_FontLightGreyColor.cgColor
        }
    }
    
 
  
}

