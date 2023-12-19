//
//  IntroductionSecondScreenVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 03/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

protocol InstructionCompleteProtocol {
    func completedInstructionReading()
}


class IntroductionSecondScreenVC: UIViewController {
    
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var uiView1: UIView!
    @IBOutlet weak var uiView2: UIView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var btnNext: UIButton!
    
    
    var viewIndex = 0
    var m_isEnrollmentConfirmed = Bool()
    var m_windowPeriodEndDate = Date()
    
    
    var instructionReadingDelegate:InstructionCompleteProtocol? = nil
    var moveToNextDelegate:MoveCardToNextProtocol? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        
        //self.view.setBackgroundGradientColor(index: 0)

        
        navigationController?.isNavigationBarHidden=false
        self.navigationItem.title = "Enrollment"
        self.navigationItem.leftBarButtonItem=getBackButtonHideTabBar()
        
        
        btnNext.makeCicular()
        
        self.view.clipsToBounds = true
        self.backView.clipsToBounds = true
        
        uiView.clipsToBounds = true
        uiView1.clipsToBounds = true
        uiView2.clipsToBounds = true
        
        uiView.isHidden = false
        uiView1.isHidden = true
        uiView2.isHidden = true
        
        uiView.layer.cornerRadius = 12.0
        uiView1.layer.cornerRadius = 12.0
        uiView2.layer.cornerRadius = 12.0
        
        
        
        //self.shadowForCell(view: uiView)
        //self.shadowForCell(view: uiView1)
        //self.shadowForCell(view: uiView2)
        
        
        let temp = CGAffineTransform(translationX: 400, y: 0)
        uiView1.transform = temp
        uiView2.transform = temp
        
        self.pageControl.currentPage = self.viewIndex
        
        //shadowForCell(view: backView)
        self.backView.layer.cornerRadius = cornerRadiusForView//8.0
        btnNext.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.view.myCustomAnimation()
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        if viewIndex >= 2 {
//            let enrollmentVC: EnrollmentEmployeeViewController = EnrollmentEmployeeViewController()
//            enrollmentVC.m_isEnrollmentConfirmed = self.m_isEnrollmentConfirmed
//            enrollmentVC.m_windowPeriodEndDate = self.m_windowPeriodEndDate
//            enrollmentVC.progressBar.currentIndex = 0
//            enrollmentVC.selectedIndexForView = 0
            
            //self.navigationController?.pushViewController(enrollmentVC, animated: true)
            //animateView()
            
            if moveToNextDelegate != nil {
                       moveToNextDelegate?.moveToNextCard()
            }

        }
        else {
            animateView()
        }
    }
    
    
    func animateView() {
        // These values depends on the positioning of your element
        let left = CGAffineTransform(translationX: -300, y: 0)
        
        let temp = CGAffineTransform(translationX: 400, y: 0)
        
        //let right = CGAffineTransform(translationX: 300, y: 0)
        //let top = CGAffineTransform(translationX: 0, y: -300)
        let reset = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            // Add the transformation in this block
            // self.container is your view that you want to animate
            
            //Move card to left -300
            if self.viewIndex == 0 {
                self.uiView.transform = left
            }
            else if self.viewIndex == 1 {
                self.uiView1.transform = left
            }
            else {
                self.uiView2.transform = left
            }
            self.viewIndex += 1
            self.pageControl.currentPage = self.viewIndex
            
        }, completion: {
            (value: Bool) in
            
            if self.viewIndex == 1 { //Hide Card and animate next card
                print("If")
                self.uiView1.isHidden = false
                self.uiView.isHidden = true
                self.uiView2.isHidden = true
                
                UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: {
                    self.uiView1.transform = reset
                    self.uiView2.transform = temp
                })
                
                
            }
            else if self.viewIndex == 2
            {
                print("Else If")
                
                self.uiView2.isHidden = false
                self.uiView.isHidden = true
                self.uiView1.isHidden = true
                
                UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: {
                    self.uiView2.transform = reset
                    self.uiView1.transform = temp
                    self.uiView.transform = temp
                })
                
            }
            else {
                print("Else\(self.viewIndex)")
                
                //                self.uiView.isHidden = false
                //                self.uiView1.isHidden = true
                //                self.uiView2.isHidden = true
                //                self.viewIndex = 0
                
                //                UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: {
                //                    self.uiView.transform = reset
                //                    self.uiView2.transform = temp
                //                    self.uiView1.transform = temp
                //
                //                    self.pageControl.currentPage = self.viewIndex
                //
                //                    if self.instructionReadingDelegate != nil {
                //                        self.instructionReadingDelegate?.completedInstructionReading()
                //                    }
                //
                //
                //
                //
                //
                //
                //                })
                
            }
            
            
        })
        
    }
}



