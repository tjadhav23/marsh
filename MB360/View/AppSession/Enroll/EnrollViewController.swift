//
//  EnrollViewController.swift
//  MyBenefits
//
//  Created by Semantic on 07/05/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
extension UINavigationBar
{
    /// Applies a background gradient with the given colors
    func applyNavigationGradient( colors : [UIColor])
    {
        
        
        var frameAndStatusBar: CGRect = self.bounds
        frameAndStatusBar.size.height += 30 // add 20 to account for the status bar
        
        setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: colors), for: .default)
    }
    
    /// Creates a gradient image with the given settings
    static func gradient(size : CGSize, colors : [UIColor]) -> UIImage?
    {
        // Turn the colors into CGColors
        let cgcolors = colors.map { $0.cgColor }
        
        // Begin the graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        // If no context was retrieved, then it failed
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // From now on, the context gets ended if any return happens
        defer { UIGraphicsEndImageContext() }
        
        // Create the Coregraphics gradient
        var locations : [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}
class EnrollViewController: UIViewController
{
    @IBOutlet weak var enrollHeaderLbl: UILabel!
    @IBOutlet weak var enrollContentLbl: UILabel!
   

    var pageMenu : CAPSPageMenu?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        enrollHeaderLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.headerSize30))
        enrollHeaderLbl.textColor = FontsConstant.shared.app_FontPrimaryColor
        
        enrollContentLbl.font = UIFont(name: FontsConstant.shared.OpenSansMedium, size: CGFloat(FontsConstant.shared.h24))
        enrollContentLbl.textColor = UIColor(hexString: "#545454")//FontsConstant.shared.app_FontSecondryColor


        var controllerArray : [UIViewController] = []
        
        let controller1 : PersonalizeViewController = PersonalizeViewController(nibName: "PersonalizeViewController", bundle: nil)
        controller1.title = "favorites"
        controllerArray.append(controller1)
        
        let controller2 : ManageViewController = ManageViewController(nibName: "ManageViewController", bundle: nil)
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
            .menuMargin(20.0),
            .selectionIndicatorHeight(0.0),
            .bottomMenuHairlineColor(UIColor.orange),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .selectedMenuItemLabelColor(UIColor.white)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 60.0, width: self.view.frame.width, height: self.view.frame.height - 60.0), pageMenuOptions: parameters)
        
//        .addSubview(pageMenu!.view)
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.isNavigationBarHidden = false
//        navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: "4B66EA"),hexStringToUIColor(hex: "82A0F6")])
//        navigationController?.navigationBar.dropShadow()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextPageButtonClicked(_ sender: Any)
    {
        let personlizeVC : PersonalizeViewController = PersonalizeViewController()
        navigationController?.pushViewController(personlizeVC, animated: true)
    }
  

}
