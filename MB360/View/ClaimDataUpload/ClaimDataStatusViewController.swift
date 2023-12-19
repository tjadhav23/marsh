//
//  ClaimDataStatusViewController.swift
//  MyBenefits360
//
//  Created by Thynksight on 08/09/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import UIKit
import Lottie

class ClaimDataStatusViewController: UIViewController {
    

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDetails: UILabel!
    
    
    @IBOutlet weak var btnClaims: UIButton!
    
    
    var clm_int_sr_no : String = ""
    var isFromEdit : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
loadAnimation()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden=true
        setupUI()
        lblDetails.text = "Your claim data has been successfully uploaded.\n Your claim serial number is #\(clm_int_sr_no)"
        if isFromEdit{
            lblTitle.text = "Claim Data Updated"
        }else{
            lblTitle.text = "Claim Data Uploaded"
        }
    }
    
    func loadAnimation() {
        // Calculate the center of the screen
               let centerX = view.bounds.midX
               let centerY = view.bounds.midY

               // Load the animation view
               let animationView = LottieAnimationView(name: "uploaded")
        // Calculate the position and size for centering
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let animationWidth: CGFloat = 200.0 // Set your desired width
            let animationHeight: CGFloat = 200.0 // Set your desired height

            let xPos = (screenWidth - animationWidth) / 2
            let yPos = (screenHeight - animationHeight) / 2

            // Set the frame for the animation view
            animationView.frame = CGRect(x: xPos, y: yPos, width: animationWidth, height: animationHeight)

           
               animationView.contentMode = .scaleAspectFill
               animationView.loopMode = .loop
               animationView.play()

               // Add the animation view to the view hierarchy
               view.addSubview(animationView)
    }
    
    
    
    func setupUI(){
        
        lblTitle.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h24))
        lblTitle.textColor = FontsConstant.shared.app_FontBlackColor
        lblDetails.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h12))
        lblDetails.textColor = FontsConstant.shared.app_FontBlackColor
        btnClaims.backgroundColor = FontsConstant.shared.app_FontAppColor
        btnClaims.layer.cornerRadius = cornerRadiusForView
    }
    
    @IBAction func btnClaimsAct(_ sender: Any) {
        if let secondViewController = navigationController?.viewControllers.first(where: { $0 is UploadedClaimsViewController }) as? UploadedClaimsViewController {
                 // Pop back to the second view controller
                 navigationController?.popToViewController(secondViewController, animated: true)
             }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
