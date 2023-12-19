//
//  EnrollmentIntroductionVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 24/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

protocol MoveToNextProtocol {
    func moveToInstruction()
}

class EnrollmentIntroductionVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSwipe: UIButton!
    @IBOutlet weak var imgBox: UIImageView!
    
    var moveToNextDelegate : MoveToNextProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
        if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
        {
            lblName.font =  Font(.installed(.MontserratRegular), size: .custom(18)).instance
            btnSwipe.titleLabel?.font = Font(.installed(.MontserratRegular), size: .custom(18.0)).instance

        }
        else {
            lblName.font =  Font(.installed(.MontserratRegular), size: .custom(20)).instance
            btnSwipe.titleLabel?.font = Font(.installed(.MontserratRegular), size: .custom(20.0)).instance

        }
        
        
         
        let array : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode: "GMC", relationName: "EMPLOYEE")
                        if(array.count>0)
                        {
                            let personInfo = array[0]
                            if let name = personInfo.personName
                            {
                               //let name1 = "Prathamesh Shenoy"
                                self.lblName.text = String(format:"Hi %@, ready to unbox your Benefits?",name)
                                
                               
                            }
                            
                        
                            
                        }
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
                   if(userArray.count>0)
                   {
                    var m_employeedict: EMPLOYEE_INFORMATION?
                        m_employeedict = userArray[0]
                       
                       var empSrNo = String()
                       
                    if let empsrno = m_employeedict?.empSrNo
                       {
                           empSrNo=String(empsrno)
                       }
                    
                    let urlLink = APIEngine.shared.allocateWalletAPI(empSrNo: empSrNo)
                    
                    allocateWallet(urlSec: urlLink)
                    EnrollmentServerRequestManager.serverInstance.getBGGHITopUpOptionsFromServer()
            }
        
        self.btnSwipe.makeCicularWithMasks()
        self.btnSwipe.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.btnSwipe.layer.borderWidth = 3.0

        animateView()
        
        
    }
    
    //
    private func animateView() {
    
    //IMG BOX
        let transitionNew = CGAffineTransform(translationX: 0, y: self.imgBox.frame.origin.y - 400 )
        self.imgBox.transform = transitionNew
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            let reset = CGAffineTransform(translationX: 0, y: 0)
            self.imgBox.transform = reset
        }, completion: {
            (value: Bool) in
        })
    
    //Label
    let transitionNew1 = CGAffineTransform(translationX:self.lblName.frame.origin.x - 500  , y: 0)
    self.lblName.transform = transitionNew1
    UIView.animate(withDuration: 0.6, delay: 0.2, options: [], animations: {
        let reset = CGAffineTransform(translationX: 0, y: 0)
        self.lblName.transform = reset
    }, completion: {
        (value: Bool) in
    })
        
    //Swipe Button
        let transitionNew2 = CGAffineTransform(translationX:self.btnSwipe.frame.origin.x + 500  , y: 0)
        self.btnSwipe.transform = transitionNew2
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [], animations: {
            let reset = CGAffineTransform(translationX: 0, y: 0)
            self.btnSwipe.transform = reset
        }, completion: {
            (value: Bool) in
        })


    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.view.myCustomAnimation()

    }

    @IBAction func swipeBtnAction(_ sender: UIButton) {
        if moveToNextDelegate != nil
        {
            self.moveToNextDelegate?.moveToInstruction()
        }
    }
    
}


extension EnrollmentIntroductionVC
{
    func allocateWallet(urlSec:String) {
        
        print("SECOND CHILD...")
        if(isConnectedToNetWithAlert())
        {
            
            let urlreq = NSURL(string : urlSec)
            
            //self.showPleaseWait(msg: "")
            print(urlSec)
            let dict = ["":""]
            
            EnrollmentServerRequestManager.serverInstance.postDataToServer(url: urlSec, dictionary: dict as NSDictionary, view: self) { (data, error) in
                
                if error != nil
                {
                    print("error ",error!)
                    self.displayActivityAlert(title: m_errorMsg)
                }
                else
                {
                     
                    do {
                        print("allocateWallet EnrollmentIntroductionVC")
                        print(data)
                        
                    
                        
                        if let jsonResult = data?.dictionary
                        {
                            print("Wallet Allocated...")
                            
                           
                        }//jsonResult
                    }//do
                        
                    catch let JSONError as NSError
                    {
                        print(JSONError)
                    }
                }//else
            }//server call
        }
       
        
    }
}


import UIKit
@IBDesignable
class LDGradientView: UIView {

    // the gradient start colour
    @IBInspectable var startColor: UIColor? {
        didSet {
            updateGradient()
        }
    }

    // the gradient end colour
    @IBInspectable var endColor: UIColor? {
        didSet {
            updateGradient()
        }
    }

    // the gradient angle, in degrees anticlockwise from 0 (east/right)
    @IBInspectable var angle: CGFloat = 270 {
        didSet {
            updateGradient()
        }
    }

    // the gradient layer
    private var gradient: CAGradientLayer?

    // initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        installGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        installGradient()
    }

    // Create a gradient and install it on the layer
    private func installGradient() {
        // if there's already a gradient installed on the layer, remove it
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = createGradient()
        self.layer.addSublayer(gradient)
        self.gradient = gradient
    }

    // Update an existing gradient
    private func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor ?? UIColor.clear
            let endColor = self.endColor ?? UIColor.clear
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            let (start, end) = gradientPointsForAngle(self.angle)
            gradient.startPoint = start
            gradient.endPoint = end
        }
    }

    // create gradient layer
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }

    // create vector pointing in direction of angle
    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        // get vector start and end points
        let end = pointForAngle(angle)
        //let start = pointForAngle(angle+180.0)
        let start = oppositePoint(end)
        // convert to gradient space
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }

    // get a point corresponding to the angle
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        // convert degrees to radians
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x,y) is in terms unit circle. Extrapolate to unit square to get full vector length
        if (fabs(x) > fabs(y)) {
            // extrapolate x to unit length
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            // extrapolate y to unit length
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }

    // transform point in unit space to gradient space
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        // input point is in signed unit space: (-1,-1) to (1,1)
        // convert to gradient space: (0,0) to (1,1), with flipped Y axis
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }

    // return the opposite point in the signed unit square
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }

    // ensure the gradient gets initialized when the view is created in IB
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        installGradient()
        updateGradient()
    }
}
