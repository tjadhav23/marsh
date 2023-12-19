//
//  ClaimDataUploadViewController.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 05/09/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar

class ClaimDataUploadViewController: UIViewController,FlexibleSteppedProgressBarDelegate,CAPSPageMenuDelegate{
    
    
    
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    
    
    var progressBarWithDifferentDimensions: FlexibleSteppedProgressBar!
    
    var selectedItemIndex: Int = 0
    var backgroundColor = UIColor(hexString: "#C2C2C2") //LIGHT Grey
    var progressColor = FontsConstant.shared.app_FontPrimaryColor
    var textColorHere = FontsConstant.shared.app_FontPrimaryColor
    
    var maxIndex = -1
    var pageMenu : CAPSPageMenu?
    
    
    @IBOutlet weak var m_mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProgressBarWithDifferentDimensions()
        
        //New code
        var controllerArray : [UIViewController] = []
        
        let controller1 : ClaimDetailsFormViewController = ClaimDetailsFormViewController(nibName: "ClaimDetailsFormViewController", bundle: nil)
        
        controller1.title = "ClaimDetailsFormViewController"
        controllerArray.append(controller1)
        
        let controller2 : ClaimBeneficiaryDetailsViewController = ClaimBeneficiaryDetailsViewController(nibName: "ClaimBeneficiaryDetailsViewController", bundle: nil)
        controller2.title = "ClaimBeneficiaryDetailsViewController"
        controllerArray.append(controller2)
        
        let controller3 : ClaimFileUploadViewController = ClaimFileUploadViewController(nibName: "ClaimFileUploadViewController", bundle: nil)
        controller3.title = "ClaimFileUploadViewController"
        controllerArray.append(controller3)
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)),
            .menuItemFont(UIFont(name: FontsConstant.shared.OpenSansRegular, size: 35.0)!),
            .menuHeight(0),
            .menuMargin(0.0),
            .selectionIndicatorHeight(0.0),
            .bottomMenuHairlineColor(UIColor.white),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .selectedMenuItemLabelColor(UIColor.white)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: m_mainView.frame.height - 0.0), pageMenuOptions: parameters)
        
        pageMenu?.delegate=self
        
        m_mainView.addSubview(pageMenu!.view)
        
        // Initially hide previousBtn and make nextButton non-clickable
        previousBtn.isHidden = true
        nextButton.isUserInteractionEnabled = false
        nextButton.backgroundColor = .gray
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden=false
        navigationItem.title="link13Name".localized()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        navigationItem.leftBarButtonItem = getBack()
        
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        DispatchQueue.main.async()
        {
            menuButton.isHidden=true
            menuButton.accessibilityElementsHidden=true
        }
        
        setupUI()
        
    }
    
    func getBack()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "back button"), style: .plain, target: self, action: #selector(backButtonClick)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func backButtonClick()
    {
        print ("backButtonClicked")
        self.tabBarController?.tabBar.isHidden=false
        //        _ = navigationController?.popViewController(animated: true)
        if let navigationController = self.navigationController {
            if let firstViewController = navigationController.viewControllers.first {
                navigationController.popToViewController(firstViewController, animated: true)
            }
        }
    }
    
    func setupUI(){
        
        nextButton.layer.cornerRadius = cornerRadiusForView
        
        previousBtn.layer.borderColor=UIColor.lightGray.cgColor
        previousBtn.layer.borderWidth=1
        previousBtn.tintColor=UIColor.lightGray
        previousBtn.layer.cornerRadius = cornerRadiusForView
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setupProgressBarWithDifferentDimensions() {
        progressBarWithDifferentDimensions = FlexibleSteppedProgressBar()
        progressBarWithDifferentDimensions.translatesAutoresizingMaskIntoConstraints = false
        self.progressBarView.addSubview(progressBarWithDifferentDimensions)
        
        // iOS9+ auto layout code
        let horizontalConstraint = progressBarWithDifferentDimensions.centerXAnchor.constraint(equalTo: self.progressBarView.centerXAnchor)
        let verticalConstraint = progressBarWithDifferentDimensions.topAnchor.constraint(
            equalTo: progressBarView.topAnchor,
            constant: 0 //position from top for bar
        )
        
        let widthConstraint = progressBarWithDifferentDimensions.widthAnchor.constraint(equalTo: progressBarView.widthAnchor, constant: -40)
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
                     didSelectItemAtIndex index: Int) {
        if index == 0 {
            // Clear/reset the progress to the initial stage
            progressBar.currentIndex = 0
            progressBar.completedTillIndex = 0
            maxIndex = 0 // Update maxIndex to 0
            
            // Additional logic to reset any other necessary states or data
            // ...
        } else {
            progressBar.currentIndex = index
            progressBar.completedTillIndex = index
            
            if index > maxIndex {
                maxIndex = index
            }
        }
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == progressBarWithDifferentDimensions {
            if position == FlexibleSteppedProgressBarTextLocation.bottom {
                switch index {
                    
                case 0: return "Claims Details"
                case 1: return "Add"
                case 2: return "File Upload"
                default: return ""
                    
                }
            }
        }
        return ""
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int)
    {
        nextButton.tag=index
        previousBtn.tag=index
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // Increment the selected item index
        print("selectedItemIndex next: ",selectedItemIndex)
        
        selectedItemIndex += 1
        
        // Ensure the selected item index doesn't exceed the maximum index (maxIndex)
        selectedItemIndex = min(selectedItemIndex, progressBarWithDifferentDimensions.numberOfPoints - 1)
        
        // Update the progress bar to reflect the new selected item index
        progressBarWithDifferentDimensions.currentIndex = selectedItemIndex
        progressBarWithDifferentDimensions.completedTillIndex = selectedItemIndex
        
        
        switch sender.tag
        {
        case 0:
            pageMenu?.moveToPage(1)
            break
        case 1:
            pageMenu?.moveToPage(2)
            break
        case 2:
            pageMenu?.moveToPage(3)
            break
            
        default:
            break
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        // Decrement the selected item index
        print("selectedItemIndex back: ",selectedItemIndex)
        selectedItemIndex -= 1
        
        // Ensure the selected item index doesn't go below 0
        selectedItemIndex = max(selectedItemIndex, 0)
        
        // Update the progress bar to reflect the new selected item index
        progressBarWithDifferentDimensions.currentIndex = selectedItemIndex
        progressBarWithDifferentDimensions.completedTillIndex = selectedItemIndex
        
        switch sender.tag
        {
        case 1:
            pageMenu?.moveToPage(0)
            break
        case 2:
            pageMenu?.moveToPage(1)
            break
        default:
            break
        }
    }
}





