//
//  ExtensionConstants.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 26/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    func setCornerRadius() {
        self.layer.cornerRadius  = 12.0
    }
}
extension Date {
    
    func getDaysInMonthFC1() -> Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    func addMonthFC1(month: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: month, to: self)!
    }
    
    func addMonthFCM1(month: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: -month, to: self)!
    }
    
    func startOfMonthFC1() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonthFC1() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonthFC())!
    }
    
    func getDayOfWeekFC1() -> Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
    }
    
    func getHeaderTitleFC1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, YYYY"
        return dateFormatter.string(from: self)
    }
    func getDay1() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.string(from: self)
    }
    
    //USed in stats aktivo weekly graph
    func getDayUTC1() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self.dayAfter)
    }
    
    func getDayFC1(day: Int) -> Date {
        let day = Calendar.current.date(byAdding: .day, value: day, to: self)!
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: day)!
    }
    
    func getYearOnlyFC1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self)
    }
    
    func getTitleDateFC1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd"
        return dateFormatter.string(from: self)
    }
    
    func getSimpleDate1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    //AKTIVO
    func getMMMddYYYYDateFC1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter.string(from: self)
    }
    
    func getSimpleDateUTC1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!

        return dateFormatter.string(from: self)
    }
    func getSimpleDateGMTStr1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
        
        return dateFormatter.string(from: self)
    }
    
    //USED IN HHC
    func getSimpleDateGMTStrIndia1() -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd/MM/yyyy"
          // dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 19800)
           return dateFormatter.string(from: self)
       }
    //Used on Aktivo Profile wakeup time and bed time
    func getTime1() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
}

extension Date {
    
    func addWeek(noOfWeeks: Int) -> Date {
        //let numberOfDays = 7 * noOfWeeks
        return Calendar.current.date(byAdding: .weekOfYear, value: noOfWeeks, to: self)!
    }
    
    //First Used in HHC - Physiotherapy
    func addDays(noOfDays: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: noOfDays, to: self)!
    }

    //First Used in HHC - Custom Multiple days selection
    func addYears(noOfYears: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: noOfYears, to: self)!
    }

    //First Used in HHC - Custom Multiple days selection
    public var removeTimeStamp : Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
        }
        return date
    }
    

    
    /*
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -10, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var yesterdayDate: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month1: Int {
        return Calendar.current.component(.month,  from: self)
    }
   
    
    var weekAgoDate: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: noon)!
    }
    var monthAgoDate: Date {
        return Calendar.current.date(byAdding: .day, value: -30, to: noon)!
    }
    
    //USed in stats aktivo weekly graph
       func getDayUTC() -> String {
           
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEE"
           dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
           return dateFormatter.string(from: self.dayAfter)
       }
       
       
       
    */
       
      
}


extension UILabel {
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }

    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.textDropShadow()
        return label
    }
}


extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
            { _ in completion() }
    }
}


extension UIView {
    
    func setGradient(colorTop: UIColor, colorBottom: UIColor,startPoint:CGPoint,endPoint:CGPoint,gradientLayer:CAGradientLayer) {

    let alpha: Float = 13 / 360
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
        
         //gradientLayer.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
         //gradientLayer.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
         gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint

        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        self.backgroundColor = UIColor.red
//        self.layer.insertSublayer(gradientLayer, at: 0)
        
        //self.backgroundColor = UIColor.red
    }
}

extension UIViewController {
    //used on MainCollectionview screen
    func setColorNew(view:UIView,colorTop:UIColor,colorBottom:UIColor,gradientLayer:CAGradientLayer) {
        /*
               // gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.colors = [EnrollmentColor.instructionTop.value.cgColor, EnrollmentColor.instructionBottom.value.cgColor]

                //gradientLayer.startPoint = startPoint
                //gradientLayer.endPoint = endPoint
        
        let alpha: Float = 13 / 360
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
           
             // gradientLayer.endPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
            //gradientLayer.startPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
      // print("Start",gradientLayer.startPoint)
      // print("End",gradientLayer.endPoint)

        
        
        let startPoint = CGPoint(x:0.5, y:0.0)
        let endPoint = CGPoint(x:0.5, y:1.0)

        
        
        gradientLayer.startPoint = startPoint
       gradientLayer.endPoint = endPoint
        

        gradientLayer.locations = [0.7, 1.0]

       // gradientLayer.locations = [0.6]
        gradientLayer.frame = self.view.bounds
    
        view.layer.insertSublayer(gradientLayer, at: 0)
        //self.view.layer.contents = #imageLiteral(resourceName: "updatedbg").cgImage
        
        //self.view.backgroundColor = UIColor(pattern: UIPattern(UIImage(named: "updatedbg")!))
*/
        //Commented image
      // self.view.layer.contents = UIImage(named: "updatedbg")!.cgImage

        //let img = UIImage(named: "updatedbg")
        //self.view.backgroundColor = UIColor(patternImage: img!)

        let startPoint = CGPoint(x:0.5, y:0.0)
        let endPoint = CGPoint(x:0.5, y:1.0)

        self.view.setGradientBackground1(colorTop: EnrollmentColor.instructionTop.value, colorBottom: EnrollmentColor.instructionBottom.value, startPoint: startPoint, endPoint: endPoint, angle: 120)
    }
}


//MARK:- Draw Border Dashed
extension UIView {
    func drawDashedBorder() { //Half border
        let border = CAShapeLayer()
        border.strokeColor = UIColor.darkGray.cgColor
        border.fillColor = nil
        border.lineDashPattern = [2, 4]
        border.path = UIBezierPath(rect: self.bounds).cgPath
        border.frame = self.bounds
        self.layer.cornerRadius = cornerRadiusForView//8.0
        self.layer.addSublayer(border)
    }
}

extension UIView {
    private static let lineDashPattern: [NSNumber] = [2, 2]
    private static let lineDashWidth: CGFloat = 1.0
    
    func makeDashedBorderLine() {
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = UIView.lineDashWidth
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineDashPattern = UIView.lineDashPattern
        path.addLines(between: [CGPoint(x: bounds.minX, y: bounds.height/2),
                                CGPoint(x: bounds.maxX, y: bounds.height/2)])
        
        
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
extension UIView {

    func addDashedBorder(shapeLayer:CAShapeLayer) {
        //Create a CAShapeLayer
       // let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 1
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [4,3]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}

extension UIView { //retangular border
    func addDashBorder() {
        let color = UIColor.darkGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [2,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
        
        self.layer.masksToBounds = false
        
        self.layer.addSublayer(shapeLayer)
    }
}

/*
extension UIView {
    func setCornerRadius() {
        self.layer.cornerRadius  = 12.0
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -10, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var yesterdayDate: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month1: Int {
        return Calendar.current.component(.month,  from: self)
    }
   
    
    var weekAgoDate: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: noon)!
    }
    var monthAgoDate: Date {
        return Calendar.current.date(byAdding: .day, value: -30, to: noon)!
    }
    
}

extension UILabel {
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }

    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.textDropShadow()
        return label
    }
}


extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
            { _ in completion() }
    }
}


extension UIView {
    
    func setGradient(colorTop: UIColor, colorBottom: UIColor,startPoint:CGPoint,endPoint:CGPoint,gradientLayer:CAGradientLayer) {

    let alpha: Float = 13 / 360
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
        
         //gradientLayer.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
         //gradientLayer.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
         gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint

        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        self.backgroundColor = UIColor.red
//        self.layer.insertSublayer(gradientLayer, at: 0)
        
        //self.backgroundColor = UIColor.red
    }
}

extension UIViewController {
    //used on MainCollectionview screen
    func setColorNew(view:UIView,colorTop:UIColor,colorBottom:UIColor,gradientLayer:CAGradientLayer) {
        /*
               // gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.colors = [EnrollmentColor.instructionTop.value.cgColor, EnrollmentColor.instructionBottom.value.cgColor]

                //gradientLayer.startPoint = startPoint
                //gradientLayer.endPoint = endPoint
        
        let alpha: Float = 13 / 360
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
           
             // gradientLayer.endPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
            //gradientLayer.startPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
      // print("Start",gradientLayer.startPoint)
      // print("End",gradientLayer.endPoint)

        
        
        let startPoint = CGPoint(x:0.5, y:0.0)
        let endPoint = CGPoint(x:0.5, y:1.0)

        
        
        gradientLayer.startPoint = startPoint
       gradientLayer.endPoint = endPoint
        

        gradientLayer.locations = [0.7, 1.0]

       // gradientLayer.locations = [0.6]
        gradientLayer.frame = self.view.bounds
    
        view.layer.insertSublayer(gradientLayer, at: 0)
        //self.view.layer.contents = #imageLiteral(resourceName: "updatedbg").cgImage
        
        //self.view.backgroundColor = UIColor(pattern: UIPattern(UIImage(named: "updatedbg")!))
*/
        //Commented image
      // self.view.layer.contents = UIImage(named: "updatedbg")!.cgImage

        //let img = UIImage(named: "updatedbg")
        //self.view.backgroundColor = UIColor(patternImage: img!)

        let startPoint = CGPoint(x:0.5, y:0.0)
        let endPoint = CGPoint(x:0.5, y:1.0)

        self.view.setGradientBackground1(colorTop: EnrollmentColor.instructionTop.value, colorBottom: EnrollmentColor.instructionBottom.value, startPoint: startPoint, endPoint: endPoint, angle: 120)
    }
}


//MARK:- Draw Border Dashed
extension UIView {
    func drawDashedBorder() { //Half border
        let border = CAShapeLayer()
        border.strokeColor = UIColor.darkGray.cgColor
        border.fillColor = nil
        border.lineDashPattern = [2, 4]
        border.path = UIBezierPath(rect: self.bounds).cgPath
        border.frame = self.bounds
        self.layer.cornerRadius = 8.0
        self.layer.addSublayer(border)
    }
}

extension UIView {
    private static let lineDashPattern: [NSNumber] = [2, 2]
    private static let lineDashWidth: CGFloat = 1.0
    
    func makeDashedBorderLine() {
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = UIView.lineDashWidth
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineDashPattern = UIView.lineDashPattern
        path.addLines(between: [CGPoint(x: bounds.minX, y: bounds.height/2),
                                CGPoint(x: bounds.maxX, y: bounds.height/2)])
        
        
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
extension UIView {

    func addDashedBorder(shapeLayer:CAShapeLayer) {
        //Create a CAShapeLayer
       // let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 1
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [4,3]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}

extension UIView { //retangular border
    func addDashBorder() {
        let color = UIColor.darkGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [2,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
        
        self.layer.masksToBounds = false
        
        self.layer.addSublayer(shapeLayer)
    }
}
*/
