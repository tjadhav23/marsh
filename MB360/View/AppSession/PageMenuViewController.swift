//
//  PageMenuViewController.swift
//  MyBenefits
//
//  Created by Semantic on 29/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class PageMenuViewController: UIViewController,CAPSPageMenuDelegate {

   
    @IBOutlet weak var m_getStartedButton: UIButton!
    @IBOutlet weak var m_stackView: UIStackView!
    @IBOutlet weak var m_page3Lbl: UILabel!
    @IBOutlet weak var m_page2Lbl: UILabel!
    @IBOutlet weak var m_page1Labl: UILabel!
    
    @IBOutlet weak var m_nextButton: UIButton!
    @IBOutlet weak var m_backButton: UIButton!
    var pageMenu : CAPSPageMenu?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden=true
        var controllerArray : [UIViewController] = []
        
        let controller1 : EnrollViewController = EnrollViewController(nibName: "EnrollViewController", bundle: nil)
        controller1.title = "favorites"
        controllerArray.append(controller1)
        
        let controller2 : PersonalizeViewController = PersonalizeViewController(nibName: "PersonalizeViewController", bundle: nil)
        controller2.title = "recents"
        controllerArray.append(controller2)
        let controller3 : ManageViewController = ManageViewController(nibName: "ManageViewController", bundle: nil)
        controller3.title = "contacts"
        controllerArray.append(controller3)
        
        //        for i in 0...10 {
        //            let controller3 : ManageViewController = ManageViewController(nibName: "ManageViewController", bundle: nil)
        //            controller3.title = "contr\(i)"
        //            //            controller3.view.backgroundColor = getRandomColor()
        //            controllerArray.append(controller3)
        //        }
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.4)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 35.0)!),
            .menuHeight(0),
            .menuMargin(0.0),
            .selectionIndicatorHeight(0.0),
            .bottomMenuHairlineColor(UIColor.white),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .selectedMenuItemLabelColor(UIColor.white)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 60.0, width: self.view.frame.width, height: m_mainView.frame.height - 60.0), pageMenuOptions: parameters)
        
        pageMenu?.delegate=self
        
                m_mainView.addSubview(pageMenu!.view)
        
    }

    @IBOutlet weak var m_mainView: UIView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func didMoveToPage(_ controller: UIViewController, index: Int)
    {
        if(index==1)
        {
            m_backButton.isHidden=false
            m_stackView.isHidden=false
            m_nextButton.isHidden=false
            m_getStartedButton.isHidden=true
            m_page1Labl.textColor=hexStringToUIColor(hex: "969696")
            m_page1Labl.backgroundColor=hexStringToUIColor(hex: "969696")
            m_page2Lbl.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            m_page2Lbl.textColor=hexStringToUIColor(hex: hightlightColor)
            
        }
    }
    func willMoveToPage(_ controller: UIViewController, index: Int)
    {
        m_nextButton.tag=index
        m_backButton.tag=index
        m_nextButton.dropShadow()
        if(index==0)
        {
            m_backButton.isHidden=true
            m_nextButton.isHidden=false
            m_stackView.isHidden=false
            m_getStartedButton.isHidden=true
            m_page1Labl.textColor=hexStringToUIColor(hex: hightlightColor)
            m_page1Labl.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            m_page2Lbl.backgroundColor=hexStringToUIColor(hex: "969696")
            m_page2Lbl.textColor=hexStringToUIColor(hex: "969696")
        }
        else if(index==1)
        {
            m_backButton.isHidden=false
            m_stackView.isHidden=false
            m_nextButton.isHidden=false
            m_getStartedButton.isHidden=true
            m_page1Labl.textColor=hexStringToUIColor(hex: "969696")
            m_page1Labl.backgroundColor=hexStringToUIColor(hex: "969696")
            m_page2Lbl.backgroundColor=hexStringToUIColor(hex: hightlightColor)
            m_page2Lbl.textColor=hexStringToUIColor(hex: hightlightColor)
            
        }
        else if(index==2)
        {
            m_backButton.isHidden=true
            m_nextButton.isHidden=true
            m_stackView.isHidden=true
            m_getStartedButton.isHidden=false
            
        }
        
    }
    @IBAction func nextButtonClicked(_ sender: UIButton)
    {
        switch sender.tag
        {
        case 0:
            pageMenu?.moveToPage(1)
            break
        case 1:
            pageMenu?.moveToPage(2)
            break
        default:
            break
        }
    }
    @IBAction func backButtonClicked(_ sender: UIButton)
    {
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
    @IBAction func getStartedButtonClicked(_ sender: Any)
    {
//        let loginVC : LoginViewController = LoginViewController()
//        navigationController?.pushViewController(loginVC, animated: true)
        let loginVc : LoginViewController_New = LoginViewController_New()
        navigationController?.pushViewController(loginVc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
