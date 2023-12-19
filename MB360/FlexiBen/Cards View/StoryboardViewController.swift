//
//  StoryboardViewController.swift
//  CenteredCollectionView_Example
//
//  Created by Benjamin Emdon on 2018-04-10.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CenteredCollectionView
import UIKit
import AVKit


class StoryboardViewController: UIViewController,InstructionCompleteProtocol {
   
    
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    let cellPercentWidth: CGFloat = 1.0
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblHeading: UILabel!
    
    //var strArray = ["","Introduction", "Employee Information","Dependant Information","Top Up","Parental Premium","CORE Benefits", "WELLNESS Benefits"]
    
    var strArray = ["","Introduction", "Employee Information","Dependant Information","Top Up","Parental Premium"]
    
    var buttonStrArray = ["","Read More","View Details","Add/Edit","Opt Top Up","Opt Parental Premium","View Details","View Details"]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CenteredCollectionView"
        
        // Get the reference to the CenteredCollectionViewFlowLayout (REQURED)
        centeredCollectionViewFlowLayout = (collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        
        // Modify the collectionView's decelerationRate (REQURED)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        // Make the example pretty ✨
        //view.applyGradient()
        
        // Assign delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
        //120
        // Configure the required item size (REQURED)
        //        centeredCollectionViewFlowLayout.itemSize = CGSize(
        //            width: view.bounds.width - 100,
        //            height: view.frame.height - 165
        //        )
        
        
        
        let screenSize = UIScreen.main.bounds
        //let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: view.bounds.width - 100,
            height: screenSize.height * 0.75
        )
        
//        centeredCollectionViewFlowLayout.itemSize = CGSize(
//            width: screenSize.width * 0.75,
//            height: screenSize.height * 0.75
//        )
        
        
        // Configure the optional inter item spacing (OPTIONAL)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 24
        
        self.view.setGradientBackground1(colorTop: hexStringToUIColor(hex: "0171d5"), colorBottom:hexStringToUIColor(hex: "5eb1fd"))
        
        setGender()
        
        getTopupOptions()
        getControllers()
    }
    
    //MARK:- Delegate & Protocol
    func completedInstructionReading() {
        print("Scroll To Next..")
        //self.centeredCollectionViewFlowLayout.scrollToPage(index: centeredCollectionViewFlowLayout.currentCenteredPage! + 1, animated: true)
        
        moveToNextCell()
        
    }
    
    func moveToNextCell() {
        let indexPath1 = IndexPath(row: centeredCollectionViewFlowLayout.currentCenteredPage! + 1, section: 0)
        collectionView.scrollToItem(at: indexPath1, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    
    func setGender()
    {
        let relationArray : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrievePersonDetails(productCode: "")
        print(relationArray)
        var familyDefinationArray = ["","","","","","","","","","","",""]
        for i in 0..<relationArray.count
        {
            let dict = relationArray[i]
            let relation = dict.relationname
            
            switch relation
            {
            case "EMPLOYEE":
                familyDefinationArray[0]="E"
                
                if(dict.gender?.capitalizingFirstLetter()=="Male")
                {
                    m_spouse="WIFE"
                }
                else
                {
                    m_spouse="HUSBAND"
                }
                
                
                break
            default :
                break
            }
        }
    }
    
    var controllerArray = [UIViewController]()
    
    //MARK:- Get All Controllers
    private func getControllers() {
        //0
        let vc = UINavigationController()
        self.controllerArray.append(vc)
        
        //1
        let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"IntroductionSecondScreenVC") as! IntroductionSecondScreenVC
        //flexIntroVC.m_isEnrollmentConfirmed = m_isEnrollmentConfirmed
        //flexIntroVC.m_windowPeriodEndDate = m_windowPeriodEndDate
        flexIntroVC.instructionReadingDelegate = self
        self.controllerArray.append(flexIntroVC)
        
        //2
//        let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
//        enrollmentVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
//        enrollmentVC.m_windowPeriodEndDate=m_windowPeriodEndDate
//        enrollmentVC.progressBar.currentIndex = 0
//        enrollmentVC.selectedIndexForView = 0
//        enrollmentVC.instructionReadingDelegateEmp = self
//
//        self.controllerArray.append(enrollmentVC)
//        
        //3
        let depDetails = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "DependantsListVCNew") as! DependantsListVCNew
        depDetails.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
        depDetails.m_windowPeriodEndDate=m_windowPeriodEndDate
        self.controllerArray.append(depDetails)
        
        
        self.collectionView.reloadData()
    }
    
    
    //===========================
    var m_enrollmentTopUpOptions = NSDictionary()
    var m_topupTitleArray = Array<String>()
    var disabledIndexArray = [Int]()
    
    var isShowTopUP = 0
    
    var collectionViewIndex = 0
    func getTopupOptions()
    {
        if let topupOptions = UserDefaults.standard.value(forKey: "EnrollmentTopUpOptions")
        {
            m_enrollmentTopUpOptions = topupOptions as! NSDictionary
            print(m_enrollmentTopUpOptions)
        }
        
        if let m_isGMCTopupApplicable = m_enrollmentTopUpOptions.value(forKey: "GMCTopup")
        {
            if(m_isGMCTopupApplicable as? String=="YES")
            {
                m_topupTitleArray.append("GHI Top-up Sum Insured")
            }
        }
        if let m_isGPATopupApplicable = m_enrollmentTopUpOptions.value(forKey: "GPATopup")
        {
            if(m_isGPATopupApplicable as? String=="YES")
            {
                m_topupTitleArray.append("GPA Top-up Sum Insured")
            }
        }
        if let m_isGTLTopupApplicable = m_enrollmentTopUpOptions.value(forKey: "GTLTopup")
        {
            if(m_isGTLTopupApplicable as? String=="YES")
            {
                m_topupTitleArray.append("GTL Top-up Sum Insured")
            }
        }
        
        
        if m_topupTitleArray.count > 0 {
            if disabledIndexArray.contains(4) == false {
                disabledIndexArray.remove(at: [4])
                
                isShowTopUP = 1
            }
            
        }
        else {
            disabledIndexArray.append(4)
            isShowTopUP = 0
            if strArray.contains("Top Up") {
                self.strArray.remove(at: [4])
            }
        }
        
        
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        
        navigationController?.isNavigationBarHidden=false
        self.navigationItem.title = "Enrollment"
        self.navigationItem.leftBarButtonItem=getBackButton()
    }
    
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        
        
        DispatchQueue.global(qos: .userInitiated).sync {
            
            let asset = AVAsset(url: URL(string: url)!)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            //Can set this to improve performance if target size is known before hand
            //assetImgGenerate.maximumSize = CGSize(width,height)
            let time = CMTimeMakeWithSeconds(1.0, 600)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                return thumbnail
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    
}

extension StoryboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Cell #\(indexPath.row)")
        /*
         switch indexPath.row {
         case 0: break
         
         case 1:
         let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"FlexIntroduction") as! FlexIntroduction
         flexIntroVC.m_isEnrollmentConfirmed = m_isEnrollmentConfirmed
         flexIntroVC.m_windowPeriodEndDate = m_windowPeriodEndDate
         
         UserDefaults.standard.set(false, forKey: "isFlexFirstTime")
         navigationController?.pushViewController(flexIntroVC, animated: true)
         
         case 2: //Emp Info
         
         let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
         enrollmentVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
         enrollmentVC.m_windowPeriodEndDate=m_windowPeriodEndDate
         enrollmentVC.progressBar.currentIndex = 0
         enrollmentVC.selectedIndexForView = 0
         
         navigationController?.pushViewController(enrollmentVC, animated: true)
         
         
         case 3: //Dependant Info
         let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
         enrollmentVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
         enrollmentVC.m_windowPeriodEndDate=m_windowPeriodEndDate
         enrollmentVC.progressBar.currentIndex = 1
         enrollmentVC.selectedIndexForView = 1
         navigationController?.pushViewController(enrollmentVC, animated: true)
         
         case 4: //Top Up
         
         if isShowTopUP == 1 {
         let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
         enrollmentVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
         enrollmentVC.m_windowPeriodEndDate=m_windowPeriodEndDate
         enrollmentVC.progressBar.currentIndex = 2
         enrollmentVC.selectedIndexForView = 2
         navigationController?.pushViewController(enrollmentVC, animated: true)
         }
         else {
         let coreBenefitsVc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "ParentalPremiumVC") as! ParentalPremiumVC
         navigationController?.pushViewController(coreBenefitsVc, animated: true)
         
         }
         case 5: //ParentalPremiumVC
         let coreBenefitsVc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "ParentalPremiumVC") as! ParentalPremiumVC
         navigationController?.pushViewController(coreBenefitsVc, animated: true)
         
         //        case 6: //Core Benefits
         //            let coreBenefitsVc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "CoreBenefitsVC") as! CoreBenefitsVC
         //            navigationController?.pushViewController(coreBenefitsVc, animated: true)
         
         default:
         break
         }
         */
    }
    
    
    //    if UserDefaults.standard.value(forKey: "isFlexFirstTime") != nil {
    //        let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
    //        enrollmentVC.m_isEnrollmentConfirmed=m_enrollmentStatus
    //        enrollmentVC.m_windowPeriodEndDate=m_windowPeriodEndDate
    //        navigationController?.pushViewController(enrollmentVC, animated: true)
    //    }
    //    else {
    //        let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"FlexIntroduction") as! FlexIntroduction
    //        flexIntroVC.m_isEnrollmentConfirmed=m_enrollmentStatus
    //        flexIntroVC.m_windowPeriodEndDate=m_windowPeriodEndDate
    //
    //        UserDefaults.standard.set(false, forKey: "isFlexFirstTime")
    //        navigationController?.pushViewController(flexIntroVC, animated: true)
    //
    //    }
}

//MARK:- CollectionView Delegate & Datasource
extension StoryboardViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "CollectionViewCell"), for: indexPath) as! StoryboardCollectionViewCell
        cell.label.text = strArray[indexPath.row]
        // cell.layer.cornerRadius = cell.bounds.height / 2
        //cell.layer.cornerRadius = 24.0
        cell.layer.cornerRadius = 13
        print("Index = ",indexPath.row)
        print("center = ",centeredCollectionViewFlowLayout.currentCenteredPage)
        //        if !cell.isAnimated {
        //
        //            UIView.animate(withDuration: 0.5, delay: 0.5 * Double(indexPath.row), usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: indexPath.row % 2 == 0 ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {
        //
        //                if indexPath.row % 2 == 0 {
        //                    AnimationUtility.viewSlideInFromLeft(toRight: cell)
        //                }
        //                else {
        //                    AnimationUtility.viewSlideInFromRight(toLeft: cell)
        //                }
        //
        //            }, completion: { (done) in
        //                cell.isAnimated = true
        //            })
        //        }
        
        //        if disabledIndexArray.contains(indexPath.row) {
        //            cell.backgroundColor = UIColor.lightGray
        //            cell.isUserInteractionEnabled = false
        //        }
        //        else {
        //            cell.backgroundColor = UIColor.white
        //            cell.isUserInteractionEnabled = true
        //
        //        }
        cell.isUserInteractionEnabled = true
        // cell.btnView.setTitle(self.buttonStrArray[indexPath.row], for: .normal)
        print(indexPath.row)
        if indexPath.row == 0 {
            cell.imgViewForVideo.isHidden = true
            cell.lblName.isHidden = false
            cell.lblSecond.isHidden = false
            cell.lblLast.isHidden = false
            cell.innerView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            cell.btnView.isHidden = true
            // cell.contentView.backgroundColor = UIColor.clear
            //cell.imgViewForVideo.image = createThumbnailOfVideoFromRemoteUrl(url: "https://core.mybenefits360.com/css/flexnew/img/FlexiBen.mp4")
            
            let array : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: "GMC", relationName: "EMPLOYEE")
            if(array.count>0)
            {
                let personInfo = array[0]
                if let name = personInfo.personName
                {
                    cell.lblName.text = "hi, " + name
                }
                
            }
            
            
            
            
            cell.lblName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.contentView.backgroundColor = UIColor.clear
            
            cell.lblHeading.text = ""
            cell.btnView.isHidden = false
            
            cell.btnView.tag = indexPath.row
            cell.btnView.addTarget(self, action: #selector(viewTapped(_:)), for: .touchUpInside)

        }
        else if indexPath.row == 1 {
            
            let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"IntroductionSecondScreenVC") as! IntroductionSecondScreenVC
            //flexIntroVC.m_isEnrollmentConfirmed = m_isEnrollmentConfirmed
            //flexIntroVC.m_windowPeriodEndDate = m_windowPeriodEndDate
            display(contentController: controllerArray[indexPath.row], on: cell.innerView)
            cell.lblHeading.text = "enrollment introduction"
            cell.innerView.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.white
            cell.btnView.isHidden = true
            

        }
        else if indexPath.row == 2 {
            
            display(contentController: controllerArray[indexPath.row], on: cell.innerView)
            cell.lblHeading.text = "employee information"
            cell.innerView.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.white
            cell.btnView.isHidden = true
            
        }
        else if indexPath.row == 3 {
            //let dependantList = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "DependantsListVC") as! DependantsListVC
            cell.lblHeading.text = ""
            
            display(contentController: controllerArray[indexPath.row], on: cell.innerView)
            cell.innerView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear

            cell.btnView.isHidden = true

        }
            
        else {
            cell.imgViewForVideo.isHidden = true
            cell.lblName.isHidden = true
            cell.lblSecond.isHidden = true
            cell.lblLast.isHidden = true
            cell.innerView.backgroundColor = UIColor.white
            cell.lblName.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed et dolore magna aliqua."
            cell.lblName.isHidden = false
            cell.lblName.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            // cell.backgroundColor = UIColor.white
            // cell.contentView.backgroundColor = UIColor.white
            cell.contentView.backgroundColor = UIColor.white
            
            cell.btnView.isHidden = true

            cell.lblHeading.text = String(indexPath.row)
            
        }
        
        
        cell.contentView.layer.cornerRadius = 24.0
        /*
         switch indexPath.row {
         case 0:
         let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "CollectionViewCell"), for: indexPath) as! StoryboardCollectionViewCell
         cell1.label.text = strArray[indexPath.row]
         cell1.imgViewForVideo.isHidden = true
         cell1.lblName.isHidden = false
         cell1.lblSecond.isHidden = false
         cell1.lblLast.isHidden = false
         cell1.innerView.backgroundColor = UIColor.clear
         cell1.backgroundColor = UIColor.clear
         cell1.btnView.isHidden = true
         // cell.contentView.backgroundColor = UIColor.clear
         //cell.imgViewForVideo.image = createThumbnailOfVideoFromRemoteUrl(url: "https://core.mybenefits360.com/css/flexnew/img/FlexiBen.mp4")
         cell.lblName.text = "hi, Rajesh"
         cell.lblName.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
         
         return cell1
         break
         
         case 1:
         let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"FlexIntroduction") as! FlexIntroduction
         flexIntroVC.m_isEnrollmentConfirmed = m_isEnrollmentConfirmed
         flexIntroVC.m_windowPeriodEndDate = m_windowPeriodEndDate
         display(contentController: flexIntroVC, on: cell.innerView)
         
         case 2:
         let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
         enrollmentVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
         enrollmentVC.m_windowPeriodEndDate=m_windowPeriodEndDate
         enrollmentVC.progressBar.currentIndex = 0
         enrollmentVC.selectedIndexForView = 0
         display(contentController: enrollmentVC, on: cell.innerView)
         
         
         case 3:
         let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
         enrollmentVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
         enrollmentVC.m_windowPeriodEndDate=m_windowPeriodEndDate
         enrollmentVC.progressBar.currentIndex = 1
         enrollmentVC.selectedIndexForView = 1
         display(contentController: enrollmentVC, on: cell.innerView)
         
         case 4:
         if isShowTopUP == 1 {
         let topUP: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
         topUP.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
         topUP.m_windowPeriodEndDate=m_windowPeriodEndDate
         topUP.progressBar.currentIndex = 2
         topUP.selectedIndexForView = 2
         cell.contentView.backgroundColor = UIColor.white
         cell.contentView.layer.cornerRadius = 24.0
         display(contentController: topUP, on: cell.innerView)
         
         }
         else {
         let coreBenefitsVc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "ParentalPremiumVC") as! ParentalPremiumVC
         display(contentController: coreBenefitsVc, on: cell.innerView)
         
         }
         
         case 5:
         let coreBenefitsVc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "ParentalPremiumVC") as! ParentalPremiumVC
         display(contentController: coreBenefitsVc, on: cell.innerView)
         break
         
         default:
         return cell
         
         
         }
         */
        
        cell.innerView.clipsToBounds = true
        cell.backgroundView?.clipsToBounds = true
        
        if indexPath.row != 0 {
        cell.lblName.isHidden = true
        cell.lblSecond.isHidden = true
        cell.lblLast.isHidden = true
        cell.btnView.isHidden = false
        cell.label.isHidden = true
            cell.btnView.isHidden = true
        }
        
//        if (collectionView.contentSize.width < collectionView.frame.size.height) {
//           table.scrollEnabled = NO;
//         }
//        else {
//           table.scrollEnabled = YES;
//         }
        
        print(self.collectionView.contentSize.width)
        print(collectionView.frame.size.height)
        return cell
    }
    
    
    func display(contentController content: UIViewController, on view: UIView) {
        self.addChildViewController(content)
        content.view.frame = view.bounds
        view.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    
    //MARK:- Next Tapped
    @objc func viewTapped(_ sender:UIButton) {
        print("Selected Cell #\(sender.tag)")
        
       // self.collectionView.scrollToNextItem()
        
       // self.centeredCollectionViewFlowLayout.scrollToPage(index: centeredCollectionViewFlowLayout.currentCenteredPage! + 1, animated: true)
        moveToNextCell()
        
        /*
        switch sender.tag {
        case 0: break
            
        case 1:
            let flexIntroVC  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"FlexIntroduction") as! FlexIntroduction
            flexIntroVC.m_isEnrollmentConfirmed = m_isEnrollmentConfirmed
            flexIntroVC.m_windowPeriodEndDate = m_windowPeriodEndDate
            
            UserDefaults.standard.set(false, forKey: "isFlexFirstTime")
            navigationController?.pushViewController(flexIntroVC, animated: true)
            
        case 2: //Emp Info
            
            let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
            enrollmentVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            enrollmentVC.m_windowPeriodEndDate=m_windowPeriodEndDate
            enrollmentVC.progressBar.currentIndex = 0
            enrollmentVC.selectedIndexForView = 0
            
            navigationController?.pushViewController(enrollmentVC, animated: true)
            
            
        case 3: //Dependant Info
            let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
            enrollmentVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            enrollmentVC.m_windowPeriodEndDate=m_windowPeriodEndDate
            enrollmentVC.progressBar.currentIndex = 1
            enrollmentVC.selectedIndexForView = 1
            navigationController?.pushViewController(enrollmentVC, animated: true)
            
        case 4: //Top Up
            let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
            enrollmentVC.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            enrollmentVC.m_windowPeriodEndDate=m_windowPeriodEndDate
            enrollmentVC.progressBar.currentIndex = 2
            enrollmentVC.selectedIndexForView = 2
            navigationController?.pushViewController(enrollmentVC, animated: true)
            
        case 5: //ParentalPremiumVC
            let coreBenefitsVc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "ParentalPremiumVC") as! ParentalPremiumVC
            navigationController?.pushViewController(coreBenefitsVc, animated: true)
            
        case 6: //Core Benefits
            let coreBenefitsVc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "CoreBenefitsVC") as! CoreBenefitsVC
            navigationController?.pushViewController(coreBenefitsVc, animated: true)
            
        default:
            break
        }
        */
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Current XX centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
        
        if let number = centeredCollectionViewFlowLayout.currentCenteredPage {
            switch number {
            case 0:
                // self.lblHeading.text = ""
                break
            case 1:
                //self.lblHeading.text = "Enrollment Introduction"
                break
                
            case 2:
                //self.lblHeading.text = "Employee Information"
                break
                
            default:
                //  self.lblHeading.text = ""
                
                break
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("Current YY centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
        
        
    }
    
    
}


extension Array {
    mutating func remove(at indexes: [Int]) {
        
        if self.count > 0 {
            var lastIndex: Int? = nil
            for index in indexes.sorted(by: >) {
                guard lastIndex != index else {
                    continue
                }
                remove(at: index)
                lastIndex = index
            }
        }
    }
}


extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        // -value incereases then less swipe
       // let contentOffset = CGFloat(floor(self.bounds.size.width - 135))

        self.moveToFrame(contentOffset: contentOffset)
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
