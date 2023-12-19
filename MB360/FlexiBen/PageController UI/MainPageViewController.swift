//
//  MainPageViewController.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 11/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit




class MainPageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIGestureRecognizerDelegate {
   
    var leads:[UIViewController] = []
    var isEdit:Bool = false
    var pageAnimation:Bool? = false
    var indexID:UIViewController?
    
    var pageChangedDelegate : PageChangedProtocol? = nil
    

    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()

    var selectedPage = 0
    
    var lastContentOffset: CGFloat = 0 //ScrollViewDelegate
    var hideCollectionViewDelegate : HideCollectionViewProtocol? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("#VDL-Main Page")
        self.view.backgroundColor = UIColor.white
        getControllers()
        self.isDoubleSided = false

        dataSource = self
        delegate = self
        
        self.delegate = self
        self.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToNextPage(notification:)), name: Notification.Name("nextPage"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToPreviousPage(notification:)), name: Notification.Name("previousPage"), object: nil)
        self.view.backgroundColor = UIColor.clear

       // self.view.layer.contents = #imageLiteral(resourceName: "gmctopupbg").cgImage

      //removeSwipeGesture()
      
    }
    func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    @objc func moveToNextPage(notification: Notification) {
        
        guard let index = notification.userInfo?["index"] as? Int else {
            return
        }
        
        selectedPage = index
        
     if selectedPage <=  leads.count  {
        //self.selectedPage += 1
       // getRandomColor()
     self.setViewControllers([leads[selectedPage]], direction: .forward, animated: true, completion: nil)
        
     }
    }
    
    
       func getRandomColor() {
        
        self.view.backgroundColor = UIColor.red
            let red   = CGFloat((arc4random() % 256)) / 255.0
            let green = CGFloat((arc4random() % 256)) / 255.0
            let blue  = CGFloat((arc4random() % 256)) / 255.0
            let alpha = CGFloat(1.0)

            UIView.animate(withDuration: 1.0, delay: 0.0, options:[.repeat, .autoreverse], animations: {
                self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            }, completion:nil)
        }
  
    @objc func moveToPreviousPage(notification: Notification) {
        guard let index = notification.userInfo?["index"] as? Int else {
            return
        }
        
        selectedPage = index
        
        if selectedPage >=  0  {
               //self.selectedPage -= 1
            self.setViewControllers([leads[selectedPage]], direction: .reverse, animated: true, completion: nil)
            }
    }



    //MARK:- Get Controllers...
    private func getControllers() {
        let vc1 = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier: "EnrollmentIntroductionVC") as! EnrollmentIntroductionVC
        //vc1.moveToNextDelegate = self
        
        let vc2 = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier: "EnrollmentInstructionsVC") as! EnrollmentInstructionsVC
        vc2.hideCollectionViewDelegate = self
        //vc2.moveToNextDelegate = self
        
        let vc9 = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier: "CoveragesInfoVC") as! CoveragesInfoVC
        vc9.hideCollectionViewDelegate = self

        //vc9.moveToNextDelegate = self
        let vc3 = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier: "EmployeeDetailsVC") as! EmployeeDetailsVC
       
       // let vc3: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
       // vc3.progressBar.currentIndex = 0
       // vc3.selectedIndexForView = 0

        //Dependants
        /*let vc4 = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "DependantsListVC") as! DependantsListVC
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
        //vc6.hideCollectionViewDelegate = self
        
        let vc7  = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier:"GPATopUpVC") as! GPATopUpVC
        vc7.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
        vc7.m_windowPeriodEndDate=m_windowPeriodEndDate
        //vc7.hideCollectionViewDelegate = self

        
        let vc8  = UIStoryboard.init(name: "Enrollment", bundle: nil).instantiateViewController(withIdentifier:"GTLTopUpVC") as! GTLTopUpVC
        vc8.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
        vc8.m_windowPeriodEndDate=m_windowPeriodEndDate
        //vc8.hideCollectionViewDelegate = self

        

        //Health & Dental
//        let vc9  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"HealthPackagesVC") as! HealthPackagesVC
//        vc9.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
//        vc9.m_windowPeriodEndDate=m_windowPeriodEndDate
//
//        let vc10  = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier:"DentalPackagesVC") as! DentalPackagesVC
//        vc10.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
//        vc10.m_windowPeriodEndDate=m_windowPeriodEndDate

//        let vc11 : EnrollmentSummaryViewController = EnrollmentSummaryViewController()
//        vc11.m_isEnrollmentConfirmed=m_isEnrollmentConfirmed
//        vc11.m_windowPeriodEndDate=m_windowPeriodEndDate

        
        self.leads.append(vc1)
        self.leads.append(vc2)
        self.leads.append(vc9)
        self.leads.append(vc3)
        self.leads.append(vc4)
        self.leads.append(vc5)
        self.leads.append(vc6)
        self.leads.append(vc7)
        self.leads.append(vc8)

        //self.leads.append(vc9)
        //self.leads.append(vc10)
        //self.leads.append(vc11)



        if selectedPage <  leads.count  {
        self.setViewControllers([leads[selectedPage]], direction: .forward, animated: false, completion: nil)
        }
    }
    


     func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            print("\(#function)#AdLead@@@@@@")

            //pageViewController.view.layoutIfNeeded()
            pageAnimation = true
        //pageViewController.view.alpha = 0
       // apply3DDepthTransform(view: pageViewController.view, ratio: 0.9)
            print("Animation True")
        
        
        }
    
    
    
    func apply3DDepthTransform(view: UIView, ratio: CGFloat) {
        view.layer.transform = CATransform3DMakeScale(ratio, ratio, ratio)
        view.alpha = 1 - ((1 - ratio)*10)
    }
    

        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            print("\(#function)")

            if completed || finished  {
               // pageViewController.view.alpha = 1
                //apply3DDepthTransform(view: pageViewController.view, ratio: 1.0)
                
                //pageViewController.view.frame.size.width += 30
                //pageViewController.view.frame.size.height += 30

                //pageViewController.view.isHidden = false
                //pageViewController.view.myCustomAnimation()

                indexID = pageViewController.viewControllers!.first! //Page Index
                print(indexID!)
                //pageViewController.view.layoutIfNeeded()
                pageAnimation = true
                
                guard let viewControllerIndex = leads.index(of: indexID!) else {
                    return
                }
                print("Animation False\(viewControllerIndex)")

                selectedPage = viewControllerIndex
                if pageChangedDelegate != nil {
                    self.pageChangedDelegate?.pageChanged(index: viewControllerIndex)
                }

            }
        }
    
   

    }

    extension MainPageViewController {
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

            print("new")
            guard let viewControllerIndex = leads.index(of: viewController) else {
                return nil
            }

            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = leads.count

            guard orderedViewControllersCount != nextIndex else {
                return nil
            }

            guard orderedViewControllersCount > nextIndex else {
                return nil
            }

            return leads[nextIndex]
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            print("Old")

            guard let viewControllerIndex = leads.index(of: viewController) else {
                return nil
            }

            let previousIndex = viewControllerIndex - 1

            guard previousIndex >= 0 else {
                return nil
            }

            guard (leads.count) > previousIndex else {
                return nil
            }
            
            return leads[previousIndex]
        }
        
        
    }


extension MainPageViewController : HideCollectionViewProtocol,MoveCardToNextProtocol{
    //DelegateProtocol Methods of TableView
    func scrolled(index: Int) { // hide
        if self.pageChangedDelegate != nil {
                   pageChangedDelegate?.animateCollectionView(index: selectedPage)
            }
    }
    
    
    func show(index: Int) {
           if self.pageChangedDelegate != nil {
                      pageChangedDelegate?.pageChanged(index: selectedPage)
               }
    }
    
    func moveToNextCard() {
        self.selectedPage += 1
        self.setViewControllers([leads[selectedPage]], direction: .forward, animated: false, completion: nil)
    
        if pageChangedDelegate != nil {
        self.pageChangedDelegate?.pageChanged(index: selectedPage)
        }
    }
}
