//
//  ColorVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 17/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class ColorVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let color1 = ConstantContent.sharedInstance.hexStringToUIColor(hex: "3ed9b0")
        let color2 = ConstantContent.sharedInstance.hexStringToUIColor(hex: "40e0d0")

        let gradient = CAGradientLayer(start: .topLeft, end: .topRight, colors: [color1.cgColor, color2.cgColor])

        gradient.frame = view.bounds
       // view.layer.addSublayer(gradient)
        
        self.navigationController?.navigationBar.applyGradient()

        //imgView.loadGif(name: "loading")
        
        
        
        
    }
    

   

}







extension CAGradientLayer {
    
    enum Point {
        case topLeft
        case centerLeft
        case bottomLeft
        case topCenter
        case center
        case bottomCenter
        case topRight
        case centerRight
        case bottomRight
        
        var point: CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: 0, y: 0)
            case .centerLeft:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeft:
                return CGPoint(x: 0, y: 1.0)
            case .topCenter:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottomCenter:
                return CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                return CGPoint(x: 1.0, y: 0.0)
            case .centerRight:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomRight:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
    convenience init(start: Point, end: Point, colors: [CGColor]) {
        self.init()
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.locations = (0..<colors.count).map(NSNumber.init)
        //self.type = type as String
    }
}
