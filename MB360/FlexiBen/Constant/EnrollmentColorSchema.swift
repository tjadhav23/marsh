//
//  EnrollmentColorSchema.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 21/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import Foundation
import UIKit

enum EnrollmentColor {
    
    case buttonBackgroundGreen
    
    case custom(hexString: String, alpha: Double)
    
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
    
    //Greeen Gradient Color
    case introductionTop
    case introductionBottom
    
    
    case instructionTop
    case instructionBottom
    
    
    
    case coveragesTop
    case coveragesBottom
    
    case empDetailsTop
    case empDetailsBottom
    
    case dependantListTop
    case dependantListBottom
    
    case parentalListTop
    case parentalListBottom
    
    case ghiTop
    case ghiBottom
    
    case gpaTop
    case gpaBottom
    
    case gtlTop
    case gtlBottom
    
    case fontColor
    case textDarkGreen
    case bottomColor
    
    
    //Red Gradient Color
    
    case tabBarBottomColor
    
    
    case backgroundLightGrayShade
    
    func printMessage() {
        //print("Hello World....!!")
    }
}

/*
 extension EnrollmentColor {
 var value: UIColor {
 var instanceColor = UIColor.clear
 
 
 switch self {
 
 case .custom(let hexValue, let opacity):
 instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
 
 //Introduction - set through STORYBOARD
 case .introductionTop:
 instanceColor = UIColor(hexString: "#4887FF")
 printMessage()
 break
 
 case .introductionBottom:
 instanceColor = UIColor(hexString: "4887FF")
 printMessage()
 break
 
 //Instruction
 case .instructionTop:
 instanceColor = UIColor(hexString: "#4887FF")
 printMessage()
 case .instructionBottom:
 instanceColor = UIColor(hexString: "4887FF")
 printMessage()
 
 
 
 case .buttonBackgroundGreen:
 break
 
 
 case .coveragesTop:
 instanceColor = UIColor(hexString: "4887FF")
 break
 case .coveragesBottom:
 instanceColor = UIColor(hexString: "4887FF")
 break
 
 
 case .empDetailsTop:
 instanceColor = UIColor(hexString: "4887FF")
 break
 case .empDetailsBottom:
 instanceColor = UIColor(hexString: "4887FF")
 break
 
 case .dependantListTop:
 instanceColor = UIColor(hexString: "4887FF")
 break
 case .dependantListBottom:
 instanceColor = UIColor(hexString: "4887FF")
 break
 
 case .parentalListTop:
 instanceColor = UIColor(hexString: "4887FF")
 break
 case .parentalListBottom:
 instanceColor = UIColor(hexString: "4887FF")
 break
 
 case .ghiTop:
 instanceColor = UIColor(hexString: "4887FF")
 break
 case .ghiBottom:
 instanceColor = UIColor(hexString: "4887FF")
 break
 
 case .gpaTop:
 instanceColor = UIColor(hexString: "4887FF")
 break
 case .gpaBottom:
 instanceColor = UIColor(hexString: "4887FF")
 break
 
 case .gtlTop:
 instanceColor = UIColor(hexString: "4887FF")
 break
 case .gtlBottom:
 instanceColor = UIColor(hexString: "4887FF")
 break
 
 case .fontColor:
 break
 case .textDarkGreen:
 break
 case .bottomColor:
 break
 case .tabBarBottomColor:
 break
 case .backgroundLightGrayShade:
 break
 
 
 }//switch
 return instanceColor
 }
 }
 
 */
extension EnrollmentColor {
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        
        switch self {
            
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
            
        //Introduction - set through STORYBOARD
        case .introductionTop:
            instanceColor = UIColor(hexString: "4887FF")
            printMessage()
            break
            
        case .introductionBottom:
            instanceColor = UIColor(hexString: "4887FF")
            printMessage()
            break
            
        //Instruction
        case .instructionTop:
            instanceColor = UIColor(hexString: "#4887FF")
            printMessage()
        case .instructionBottom:
            instanceColor = UIColor(hexString: "0013C7")
            printMessage()
            
            
            
        case .buttonBackgroundGreen:
            break
            
            
        case .coveragesTop:
            instanceColor = UIColor(hexString: "A5D134")
            break
        case .coveragesBottom:
            instanceColor = UIColor(hexString: "86B8EB")
            break
            
            
        case .empDetailsTop:
            instanceColor = UIColor(hexString: "344DBC")
            break
        case .empDetailsBottom:
            instanceColor = UIColor(hexString: "86B8EB")
            break
            
        case .dependantListTop:
            instanceColor = UIColor(hexString: "0013C7")
            break
        case .dependantListBottom:
            instanceColor = UIColor(hexString: "86B8EB")
            break
            
        case .parentalListTop:
            instanceColor = UIColor(hexString: "0013C7")
            break
        case .parentalListBottom:
            instanceColor = UIColor(hexString: "86B8EB")
            break
            
        case .ghiTop:
            instanceColor = UIColor(hexString: "344DBC")
            break
        case .ghiBottom:
            instanceColor = UIColor(hexString: "86B8EB")
            break
            
        case .gpaTop:
            instanceColor = UIColor(hexString: "7C17FF")
            break
        case .gpaBottom:
            instanceColor = UIColor(hexString: "FFFFFF")
            break
            
        case .gtlTop:
            instanceColor = UIColor(hexString: "7C17FF")
            break
        case .gtlBottom:
            instanceColor = UIColor(hexString: "FFFFFF")
            break
            
        case .fontColor:
            break
        case .textDarkGreen:
            break
        case .bottomColor:
            break
        case .tabBarBottomColor:
            break
        case .backgroundLightGrayShade:
            break
            
            
        }//switch
        return instanceColor
    }
}




extension UIView {
    func setGradientBackgroundColor(colorTop: UIColor, colorBottom: UIColor,startPoint:CGPoint,endPoint:CGPoint) {
        
        let gradientLayer = CAGradientLayer()
        
        //gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.colors = [EnrollmentColor.ghiTop.value, EnrollmentColor.introductionTop.value]
        
        //        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        //      gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        //gradientLayer.startPoint = startPoint
        //gradientLayer.endPoint = endPoint
        
        let alpha: Float = 120 / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        
        print("Start",startPoint)
        print("End",endPoint)
        
        // gradientLayer.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        // gradientLayer.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.6, y: 1.0)
        
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        
        
        /*
         //        let gradient = CAGradientLayer()
         //
         //        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
         //        let alphaValue: CGFloat = 1.0
         //        gradient.colors = [colorTop.withAlphaComponent(CGFloat(alphaValue)).cgColor, colorBottom.withAlphaComponent(alphaValue).cgColor]
         //        let x: Double! = 120 / 360.0
         //        let a = pow(sinf(Float(2.0 * M_PI * ((x + 0.75) / 2.0))),2.0);
         //        let b = pow(sinf(Float(2*M_PI*((x+0.0)/2))),2);
         //        let c = pow(sinf(Float(2*M_PI*((x+0.25)/2))),2);
         //        let d = pow(sinf(Float(2*M_PI*((x+0.5)/2))),2);
         //
         //        gradient.endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
         //        gradient.startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
         //
         //        //self.roundCorners([.topLeft, .bottomLeft], radius: 18.0)
         //        self.layer.insertSublayer(gradient, at: 0)
         */
        
        // self.backgroundColor = UIColor(patternImage: UIImage(named: "gmctopupbg")!)
        //self.layer.contents = #imageLiteral(resourceName: "gmctopupbg").cgImage //Original
        // self.view.layer.contents = #imageLiteral(resourceName: "gmctopupbg").cgImage
        
        //self.layer.contents = #imageLiteral(resourceName: "instructionsbg").cgImage
        //self.backgroundColor = UIColor.clear
        
    }
    
    func setBackgroundGradientColor(index:Int) {
        let startPoint = CGPoint(x:0.0, y:1.0)
        let endPoint = CGPoint(x:1.0, y:0.0)
        
        self.setGradientBackgroundColor(colorTop: EnrollmentColor.introductionTop.value, colorBottom: EnrollmentColor.introductionBottom.value, startPoint: startPoint, endPoint: endPoint)
    }
}


extension UIView { //used on instruction screen
    func setGradientBackground1(colorTop: UIColor, colorBottom: UIColor,startPoint:CGPoint,endPoint:CGPoint,angle:Float) {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [EnrollmentColor.instructionTop.value.cgColor, EnrollmentColor.instructionBottom.value.cgColor]
        
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.4)
       // gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        let alpha: Float = angle / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )

       // gradientLayer.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
       // gradientLayer.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))

        
        
        gradientLayer.locations = [0.7, 1.0]
        
        
        
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientForEmpDetails(colorTop: UIColor, colorBottom: UIColor,startPoint:CGPoint,endPoint:CGPoint,angle:Float,gradientLayer:CAGradientLayer) {
        
        
        gradientLayer.colors = [EnrollmentColor.instructionTop.value.cgColor, EnrollmentColor.instructionBottom.value.cgColor]
        
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.4)
       // gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        let alpha: Float = angle / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )

       // gradientLayer.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
       // gradientLayer.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))

        
        
        gradientLayer.locations = [0.7, 1.0]
        
        
        
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }

}
