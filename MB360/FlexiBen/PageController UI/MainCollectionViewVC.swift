//
//  MainCollectionViewVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 11/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit




class MainCollectionViewVC: UIViewController,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnSummary: UIButton!

    
    
    var imgArray = ["intro icon","instructions icon","coverage icon","employee icon","dependants icon","Parents icon","GMC icon","GPA icon","GTL icon","HC icon_1","icon_1"]

    
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    
    var visibleIndex = 0
    
    var leads:[UIViewController] = []
    var isGestureEnabled = true
    var isFromLogin = true
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.layer.contents = #imageLiteral(resourceName: "gmctopupbg").cgImage

        //navigationController?.isNavigationBarHidden=false
        setupUI()
        let rootVC = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
        rootVC.pageChangedDelegate = self
        rootVC.selectedPage = 0
        
        getControllers()

        display(contentController: leads[0], on: self.innerView)
        
        self.selectedView.layer.cornerRadius = self.selectedView.bounds.height / 2
       // self.selectedView.backgroundColor = UIColor.lightGray
        
        //setRightButton()//commnetcd 29 march
        
        checkConditions()
        
        
        getFamilyDefination()
        
        

        
        //Add Swipe Gesture
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeMade(_:)))
           leftRecognizer.direction = .left
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeMade(_:)))
           rightRecognizer.direction = .right
        leftRecognizer.delegate = self as? UIGestureRecognizerDelegate
        rightRecognizer.delegate = self as? UIGestureRecognizerDelegate
        
           self.view.addGestureRecognizer(leftRecognizer)
           self.view.addGestureRecognizer(rightRecognizer)
        
        /*
        if(!m_windowPeriodStatus)
        {
            print("Window period ended on \(convertDatetoString(m_windowPeriodEndDate))")
        }
        else {
            print("Window period active till \(convertDatetoString(m_windowPeriodEndDate))")

        }
        */

    }
    
    func setupUI(){
        self.navigationItem.title = ""
        self.btnBack.isHidden = false
        
       
        
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        
        setColorNew(view: self.view, colorTop: EnrollmentColor.gtlTop.value, colorBottom: EnrollmentColor.gtlBottom.value,gradientLayer:gradientLayer)

        self.selectedImage.image = UIImage(named: imgArray[selectedIndex])

        
        self.collectionView.layer.cornerRadius = self.collectionView.bounds.height / 2
        self.collectionView.layer.masksToBounds = true
        
        self.selectedView.isHidden = false //changed
    }
    
    
   
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.checkConditions()
        btnPrev.isHidden = false
        btnNext.isHidden = false
    }
    
   
    
  
        
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isGestureEnabled {
            return true
        }
        return false
    }

    
    
    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
       if sender.direction == .left {
       if selectedIndex < self.leads.count - 1 {
        self.selectedIndex += 1
        moveToNext()
        checkConditions()
        }
        }
       if sender.direction == .right {
        if selectedIndex > 0 {
        self.selectedIndex -= 1
          moveToPrevious()
        }
       }
    }

    
    let gradientLayer = CAGradientLayer()
    override func viewDidLayoutSubviews() {
         CATransaction.begin()
         CATransaction.setDisableActions(true)
         gradientLayer.frame = self.view.bounds
         CATransaction.commit()
       }

    
   
    
    @objc func backButtonClicked1()
    {
        print ("backButtonClicked")
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
 
    //Add Container View OR Change Container on collectionView Cell Selection
    func display(contentController content: UIViewController, on view: UIView) {
        
        //Added below 3 lines
       
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()

        view.addSubview(content.view)

        self.addChildViewController(content)

        content.view.frame = view.bounds
        content.didMove(toParentViewController: self)
        
        
       
        
       
        checkConditions()
        
    }
    
    //MARK:- Family Definition
    func getFamilyDefination()
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
                
                if(dict.gender?.uppercased() == "MALE")
                {
                    m_spouse="WIFE"
                }
                else
                {
                    m_spouse="HUSBAND"
                }
                
                
                break
            case "WIFE":
                familyDefinationArray[1]="W"
                break
            case "SON":
                if(familyDefinationArray[2]=="Sn1")
                {
                    if(familyDefinationArray[3]=="Sn2")
                    {
                        familyDefinationArray[4]="Sn3"
                    }
                    else
                    {
                        familyDefinationArray[3]="Sn2"
                    }
                }
                else
                {
                    familyDefinationArray[2]="Sn1"
                }
                break
            case "DAUGHTER":
                if(familyDefinationArray[3]=="D1")
                {
                    
                    if(familyDefinationArray[4]=="D2")
                    {
                        familyDefinationArray[5]="D3"
                    }
                    else
                    {
                        familyDefinationArray[4]="D2"
                    }
                }
                else
                {
                    familyDefinationArray[3]="D1"
                }
                break
                
            case "FATHER":
                familyDefinationArray[6]="F"
                break
            case "MOTHER":
                familyDefinationArray[7]="M"
                break
            case "FATHERINLAW":
                familyDefinationArray[8]="FIL"
                break
            case "MOTHERINLAW":
                familyDefinationArray[9]="MIL"
                break
                
            default:
                break
            }
        }
        var newArray : Array<String> = []
        newArray = familyDefinationArray
        for i in 0..<familyDefinationArray.count
        {
            let itemToRemove = ""
            if let index = newArray.index(of: itemToRemove)
            {
                newArray.remove(at: index)
            }
        }
        familyDefinationArray=newArray
        if(familyDefinationArray.count==1)
        {
            familyDefinationArray[0]="Employee"
        }
        print(familyDefinationArray.joined(separator: "+"))
    }
    
    
    
    func hideView() {
       // print(collectionView.frame.origin.y,"\t",self.view.bounds.height)
        self.selectedView.isHidden = false
        
        if self.collectionView.frame.origin.y + 20 < self.view.bounds.height {
            let bottom = CGAffineTransform(translationX: 0, y: collectionView.frame.origin.y + 55)
            let btnBottom = CGAffineTransform(translationX: 0, y: btnNext.frame.origin.y + 150)
            
            UIView.animate(withDuration: 0.6, delay: 0.0, options: [], animations: {
                
                self.collectionView.transform = bottom
                self.btnNext.transform = btnBottom
                self.btnPrev.transform = btnBottom
                
            }, completion: {
                (value: Bool) in
                print("Hide Complete..>>>",self.collectionView.frame.origin.y)
                self.selectedView.isHidden = false
                
            })
        }
    }
    
    //animate collectionView from bottom to top
    func showView() {
       // self.collectionView.isHidden = false
        //updated by pranit - 4th march
        self.collectionView.isHidden = true
        self.btnPrev.isHidden = false
        self.btnNext.isHidden = false

        
       // print(collectionView.frame.origin.y,"\t",self.view.bounds.height)
        
        if collectionView.frame.origin.y > self.view.bounds.height {
            let top = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(withDuration: 0.6, delay: 0.0, options: [], animations: {
                
                self.collectionView.transform = top
                self.btnPrev.transform = top
                self.btnNext.transform = top
                
            }, completion: {
                (value: Bool) in
                print("Show Complete")
                self.selectedView.isHidden = false //changed
            })
            
        }
        else {
            print(collectionView.frame.origin.y)
        }
    }
    
  
    
    
    func checkConditions() {
        print("CheckConditions = \(selectedIndex)")
//        if selectedIndex == 0 {
//
//            self.btnBack.isHidden = false
//
//        }
//        else {
//            self.btnBack.isHidden = true
//
//        }
        
        if selectedIndex > 3 {
            //setRightButton()
            self.btnSummary.isHidden = false
            self.btnBack.isHidden = false

        }
        else {
            self.btnSummary.isHidden = true
            let top = CGAffineTransform(translationX: 0, y: 0)
            self.btnPrev.transform = top
            self.btnNext.transform = top
            self.btnNext.isHidden = false
            self.btnPrev.isHidden = false
                self.btnBack.isHidden = false

            navigationItem.rightBarButtonItem = nil
        }
        
        if selectedIndex == 0 { //first
            self.btnPrev.isHidden = false
            self.btnNext.isHidden = false
            self.btnPrev.isUserInteractionEnabled = false
            self.btnNext.isUserInteractionEnabled = true
            //self.navigationController?.navigationBar.isHidden = false
            self.btnBack.isHidden = false

        }
        else if selectedIndex == imgArray.count - 1 { //last
            
             //self.btnPrev.isUserInteractionEnabled = true
            // self.btnNext.isUserInteractionEnabled = false
             //self.navigationController?.navigationBar.isHidden = true
             self.btnNext.isHidden = true
             self.btnPrev.isHidden = true
             self.selectedView.isHidden = true
             self.btnSummary.isHidden = true
            self.btnBack.isHidden = true
            
        }
            //        else if selectedIndex == imgArray.count {
//            self.btnNext.isHidden = true
//            self.btnPrev.isHidden = false
//            self.selectedView.isHidden = true
//
//        }
        else { //mid
            self.btnPrev.isUserInteractionEnabled = true
            self.btnNext.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.isHidden = true
            
            self.btnNext.isHidden = false
            self.selectedView.isHidden = false
            self.btnBack.isHidden = false


        }
        //self.btnPrev.isHidden = false
        //self.btnNext.isHidden = false
        
        
        
         let obj = leads[selectedIndex]
        if obj.isKind(of: DependantsListVC.self) || obj.isKind(of: ParentalPremiumVC.self) || obj.isKind(of: GHITopUpVC.self) || obj.isKind(of: GPATopUpVC.self) || obj.isKind(of: GTLTopUpVC.self) {
            self.isGestureEnabled = false
            }
        else {
            self.isGestureEnabled = true
        }
        
        

    }
}

extension MainCollectionViewVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "CellForMainCollectionView"), for: indexPath) as! CellForMainCollectionView
        cell.lblName.text = String(indexPath.row + 1)
        
        cell.imgView.image = UIImage(named: imgArray[indexPath.row])
        
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = UIColor.lightGray
           // selectedImage.image = UIImage(named: imgArray[indexPath.row])
        }
        else {
            cell.backgroundColor = UIColor.clear
            
        }
        
        cell.layer.cornerRadius = cell.bounds.height/2
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row > selectedIndex { //forward
            selectedIndex = indexPath.row
           // NotificationCenter.default.post(name: Notification.Name("nextPage"), object: nil, userInfo:["isForward": "true", "index": selectedIndex])
            
            moveToNext()
        }
        else if indexPath.row < selectedIndex { //reverse
            selectedIndex = indexPath.row
           // NotificationCenter.default.post(name: Notification.Name("previousPage"), object: nil,userInfo:["isForward": "false", "index": selectedIndex])
            
            moveToPrevious()
        }
        else {
            //No Action
        }
        
        self.collectionView.reloadData()
        let indexPath1 = IndexPath(row: selectedIndex, section: 0)
        collectionView.scrollToItem(at: indexPath1, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        
        //        let rootVC = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
        //        rootVC.pageChangedDelegate = self
        //        rootVC.selectedPage = indexPath.row
        //display(contentController: rootVC, on: self.innerView)
        
        checkConditions()
        
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == selectedIndex {
            return CGSize(width: 65.0, height: 65.0)
        }
        else {
            return CGSize(width: 50.0, height: 50.0)
        }
    }
    
    
    
}



extension MainCollectionViewVC {
        //MARK:- Get Controllers...
        private func getControllers() {
            let vc1 = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier: "EnrollmentIntroductionVC") as! EnrollmentIntroductionVC
           // vc1.moveToNextDelegate = self
            vc1.moveToNextDelegate = self

            
            let vc2 = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier: "EnrollmentInstructionsVC") as! EnrollmentInstructionsVC
            vc2.hideCollectionViewDelegate = self
            //vc2.moveToNextDelegate = self
            
            let vc9 = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier: "CoveragesInfoVC") as! CoveragesInfoVC
            vc9.hideCollectionViewDelegate = self

            //vc9.moveToNextDelegate = self

            //let vc3: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
           // vc4.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            //vc4.m_windowPeriodEndDate=m_windowPeriodEndDate
            //vc3.progressBar.currentIndex = 0
            //vc3.selectedIndexForView = 0

            let vc3 = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier: "EmployeeDetailsVC") as! EmployeeDetailsVC
            
            
            //Dependants
           /* let vc4 = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "DependantsListVC") as! DependantsListVC
            vc4.m_isEnrollmentConfirmed = m_isEnrollmentConfirmed
            vc4.m_windowPeriodEndDate = m_windowPeriodEndDate
            vc4.hideCollectionViewDelegate = self
            */
            let vc4 = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier: "DependantsListVCNew") as! DependantsListVCNew
            vc4.m_isEnrollmentConfirmed = m_isEnrollmentConfirmed
            vc4.m_windowPeriodEndDate = m_windowPeriodEndDate
            vc4.hideCollectionViewDelegate = self
            
            let vc5 = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier: "ParentalPremiumVC") as! ParentalPremiumVC
            vc5.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            vc5.m_windowPeriodEndDate=m_windowPeriodEndDate
            vc5.hideCollectionViewDelegate = self

            //Topup
            let vc6  = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier:"GHITopUpVC") as! GHITopUpVC
            vc6.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            vc6.m_windowPeriodEndDate=m_windowPeriodEndDate
            vc6.hideCollectionViewDelegate = self
            
            let vc7  = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier:"GPATopUpVC") as! GPATopUpVC
            vc7.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            vc7.m_windowPeriodEndDate=m_windowPeriodEndDate
            vc7.hideCollectionViewDelegate = self

            
            let vc8  = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier:"GTLTopUpVC") as! GTLTopUpVC
            vc8.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            vc8.m_windowPeriodEndDate=m_windowPeriodEndDate
            vc8.hideCollectionViewDelegate = self

            

            //Health & Dental
//            let vc91  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"HealthPackagesVC") as! HealthPackagesVC
//            vc91.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
//            vc91.m_windowPeriodEndDate=m_windowPeriodEndDate
//            vc91.hideCollectionViewDelegate = self

            //let vc10  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"DentalPackagesVC") as! DentalPackagesVC
            //vc10.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            //vc10.m_windowPeriodEndDate=m_windowPeriodEndDate

            /*
            let vc11 : EnrollmentSummaryViewController = EnrollmentSummaryViewController()
            vc11.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
            vc11.m_windowPeriodEndDate=m_windowPeriodEndDate
*/
            let vcEnd  = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier:"SummaryRightVC") as! SummaryRightVC
            vcEnd.isSwipe = true
            vcEnd.moveToPrevious = self
            vcEnd.isFromPush = false
            
            self.leads.append(vc1)
            self.leads.append(vc2)
            self.leads.append(vc9)
            self.leads.append(vc3)
            self.leads.append(vc4)
            self.leads.append(vc5)
            self.leads.append(vc6)
            self.leads.append(vc7)
            self.leads.append(vc8)

            //Removal for Health screen
            //self.leads.append(vc91)
            self.leads.append(vcEnd)

            //self.leads.append(vc10)
            //self.leads.append(vc11)



        }
    
    func moveToNext() {
       // self.selectedIndex += 1
        let newVC = leads[selectedIndex]

        self.selectedImage.image = UIImage(named: imgArray[selectedIndex])
        
               
        //New
        let transitionNew = CGAffineTransform(translationX: innerView.frame.origin.x - 200, y: 0 )
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.innerView.transform = transitionNew
            self.innerView.alpha = 0

        }, completion: {
            (value: Bool) in
            print("Hide Complete..>>>",self.collectionView.frame.origin.y)
            
            self.display(contentController: newVC, on: self.innerView)
            let reset = CGAffineTransform(translationX: 0, y: 0)
            self.innerView.transform = reset
            
            UIView.animate(withDuration: 0.1, animations: {
                
                self.innerView.alpha = 1.0


            })
            
           

            
        })


    }
    
    func moveToPrevious() {
        
        self.btnPrev.isHidden = false
        self.btnNext.isHidden = false
        
        let newVC = leads[selectedIndex]
        self.selectedImage.image = UIImage(named: imgArray[selectedIndex])

        
        //New
        let transitionNew = CGAffineTransform(translationX: innerView.frame.origin.x + 200, y: 0 )
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.innerView.transform = transitionNew
            self.innerView.alpha = 0

        }, completion: {
            (value: Bool) in
            print("Hide Complete..>>>",self.collectionView.frame.origin.y)
            

            self.display(contentController: newVC, on: self.innerView)
            let reset = CGAffineTransform(translationX: 0, y: 0)
            self.innerView.transform = reset
            
            UIView.animate(withDuration: 0.1, animations: {
                
                self.innerView.alpha = 1.0


            })
            
        })

        

    }
    
    func setupTabbar()
    {

    print("Tab Bar Setup - TCL1")
        let tabBarController = UITabBarController()
        let tabViewController1 = ContactDetailsViewController(
            nibName: "ContactDetailsViewController",
            bundle: nil)
        let tabViewController2 = NewDashboardViewController(
            nibName:"NewDashboardViewController",
            bundle: nil)
        let tabViewController3 = NewDashboardViewController(
            nibName: "NewDashboardViewController",
            bundle: nil)
        let tabViewController4 = UtilitiesViewController(
            nibName:"UtilitiesViewController",
            bundle: nil)
        let tabViewController5 = LeftSideViewController(
            nibName:"LeftSideViewController",
            bundle: nil)
        
        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
        
        
        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
        tabBarController.viewControllers = controllers as? [UIViewController]
        
        nav1.tabBarItem = UITabBarItem(
            title: "Contact",
            image: UIImage(named: "call-1"),
            tag: 1)
        nav2.tabBarItem = UITabBarItem(
            title: "E-card",
            image:UIImage(named: "ecard1") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Utilities",
            image:UIImage(named: "utilities") ,
            tag:2)
        
        nav5.tabBarItem = UITabBarItem(
            title: "More",
            image:UIImage(named: "menu-1") ,
            tag:2)
        
        
       
        
               
       navigationController?.pushViewController(tabBarController, animated: true)
       tabBarController.selectedIndex=2
     
    
    }
}


extension MainCollectionViewVC : HideCollectionViewProtocol,MoveToNextProtocol,MoveToPreviousVCProtocol{
    func scrolled(index: Int) {
 //       hideView()
        animateCollectionView(index: index)
    }
    
    func show(index: Int) {
        showView()
    }
    
    func moveToInstruction() {
        self.selectedIndex += 1
        moveToNext()
        checkConditions()
        self.collectionView.reloadData()
       }
    
    func moveToPreviousVC() {
        if selectedIndex > 0 {
            self.selectedIndex -= 1
            self.checkConditions()
            self.moveToPrevious()
        }
        self.btnPrev.isHidden = false
        self.btnNext.isHidden = false
    }
    
}


extension MainCollectionViewVC {
    
    @IBAction func btnSummaryTapped(_ sender: Any) {
//        SlideMenuOptions.contentViewDrag = true
//        SlideMenuOptions.leftViewWidth = self.view.frame.size.width * 0.75
//
        let flexStoryboard = UIStoryboard.init(name: "Enrollment", bundle: nil)
//        let contentVC = flexStoryboard.instantiateViewController(withIdentifier: "MainCollectionViewVC") as! MainCollectionViewVC
        let leftVC = flexStoryboard.instantiateViewController(withIdentifier: "SummaryRightVC") as! SummaryRightVC
//        let slideVC = SlideMenuController(mainViewController: contentVC, leftMenuViewController: leftVC)
//        slideVC.view.clipsToBounds = true
//        self.navigationController?.pushViewController(slideVC, animated: true)
        
        //self.slideMenuController()?.openRight()
        leftVC.isSwipe = false
        leftVC.isFromPush = true

        self.navigationController?.pushViewController(leftVC, animated: true)


    }
    
    //MARK:- Next & Prev Buttons
    @IBAction func btnNextTapped(_ sender: Any) {
        /*
        //let rootVC = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
        //rootVC.pageChangedDelegate = self
        selectedIndex += 1
        //rootVC.selectedPage = selectedIndex
        //display(contentController: rootVC, on: self.innerView)
        
        NotificationCenter.default.post(name: Notification.Name("nextPage"), object: nil,userInfo:["isForward": "true", "index": selectedIndex])
        
        self.collectionView.reloadData()
        self.selectedView.isHidden = true
        self.collectionView.isHidden = false
        showView()
        let indexPath1 = IndexPath(row: selectedIndex, section: 0)
        collectionView.scrollToItem(at: indexPath1, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        checkConditions()
        */
        if selectedIndex < self.leads.count - 1 {

        self.selectedIndex += 1
        self.navigationController?.navigationBar.isHidden = true
        moveToNext()
        checkConditions()
        //self.collectionView.reloadData()

       // let indexPath1 = IndexPath(row: selectedIndex, section: 0)
       // collectionView.scrollToItem(at: indexPath1, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
        

    }
    
    //MARK:- Back Tapped
    @IBAction func backButtonTapped(_ sender: Any) {
        
        if let status = UserDefaults.standard.value(forKey: "isFromLogin") as? Bool {
            if status {
                setupTabbar()

            }
            else {
                self.dismiss(animated: true, completion: nil)

            }
        }
        
    }
    
    @IBAction func btnPrevTapped(_ sender: Any) {
     
        selectedIndex -= 1
       // NotificationCenter.default.post(name: Notification.Name("previousPage"), object: nil, userInfo:["isForward": "false", "index": selectedIndex])
        
        self.collectionView.reloadData()
        self.selectedView.isHidden = false //changed
        //commented on 4th march
        //self.collectionView.isHidden = false
        self.collectionView.isHidden = true

        
        showView() //animate collectionView from bottom to top
        let indexPath1 = IndexPath(row: selectedIndex, section: 0)
        collectionView.scrollToItem(at: indexPath1, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
       

        checkConditions()
        
        moveToPrevious()
    }
}


extension MainCollectionViewVC : PageChangedProtocol{
    
    //hide collectionview on scrolling
    func animateCollectionView(index:Int) {
       
        hideView()
        
    }
    
    
    
    //Swipe between pages
    func pageChanged(index: Int) {
        print("Page Changed.....\(index)")
        selectedIndex = index
        self.collectionView.reloadData()
        self.visibleIndex = index
        let indexPath1 = IndexPath(row: selectedIndex, section: 0)
        collectionView.scrollToItem(at: indexPath1, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        
        
        showView()
        checkConditions()
        
        
        
    }
}
