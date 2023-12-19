//
//  ConstantContent.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 30/05/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

/*
class ConstantContent: NSObject {

    static let sharedInstance = ConstantContent()
    
    var currency = "₹"
    var imageForPaymentGateway = "https://wellness.mybenefits360.com/mybenefits/assets/img/logo-master-small.png"
    
    //Green Background color
    //let buttonBackgroundColor = UIColor.init(hexFromString: "20DBC0")
    //let lblGreenColor = UIColor.init(hexFromString: "20DBC0")

    func hexStringToUIColor (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6)
        {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            
        )
    }
    
     func circularView(view:UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 20
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 2
        view.layer.cornerRadius = 10.0
    }
    
    

}

//Add space before text
extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

//MARK:- Navigation BAR Shadow
extension UIView {

    func navBarDropShadow11(scale: Bool = true)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        layer.shadowOpacity = 30
        layer.shadowOffset = CGSize(width: 0.0, height: 3)
        layer.shadowRadius = 3
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = frame.size.height/2
        
    }
    
    func makeTransparentBackground(){
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
//    func setBottomShadowButton() {
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
//        self.layer.shadowOpacity = 30
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 3)
//        self.layer.shadowRadius = 2
//        self.layer.cornerRadius = self.bounds.height / 2
//
//        self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
//        self.layer.borderWidth = 0.7
//    }
    
    func setGradientBackground1(colorTop: UIColor, colorBottom: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        // gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        //gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}

extension UIButton {
    func setBottomShadowButton() {
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
//        self.layer.shadowOpacity = 30
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 3)
//        self.layer.shadowRadius = 2
//        self.layer.cornerRadius = self.bounds.height / 2
//
//        self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
//        self.layer.borderWidth = 0.7
        
        layer.masksToBounds = false
        layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.shadowOpacity = 30
        layer.shadowOffset = CGSize(width: 0.0, height: 10)
        layer.shadowRadius = 10
        
        layer.cornerRadius = frame.size.height/2
        
    }
}

extension UILabel {
    
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            
            attributedString.addAttribute(NSAttributedStringKey.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
        }
        
        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedStringKey.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
}

//Capital First letter
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

//Remove white spaces between string.
extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}

//Replace last occurence of string in swift
extension String
{
    func replacingLastOccurrenceOfString(_ searchString: String,
                                         with replacementString: String,
                                         caseInsensitive: Bool = true) -> String
    {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }
        
        if let range = self.range(of: searchString,
                                  options: options,
                                  range: nil,
                                  locale: nil) {
            
            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
}

extension String {
    //MARK:- Convert Date
    func convertStringToDate() -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date1 = dateFormatter.date(from: self)
        {
            return date1
            //dateFormatter.dateFormat = "dd/MM/yyyy"
            // return  dateFormatter.string(from: date1)
        }
        else
        {
            return Date()
        }
    }
}

//Make Underline
extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

//Check Valid Contact
extension String {
    var isValidContact: Bool {
        let phoneNumberRegex = "^[1-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
}

//MARK:- Navigation Bar Font
extension UINavigationBar {
    func applyGradient() {
        self.applyNavigationGradient(colors: [Color.greenBottom.value, Color.greenTop.value])
    }
    
    func applyFitnessGradient() {
        self.applyNavigationGradient(colors: [Color.redBottom.value, Color.redTop.value])
    }
    
    func hideBackButton() {
        let backImage = UIImage(named: "back button")
          self.backIndicatorImage = UIImage(named: "back button")
         self.backIndicatorTransitionMaskImage = backImage
         self.backItem?.title = ""

    }
    
    //MARK:- Navigation bar font
    func changeFont(){
    
        self.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name:"Poppins-Medium", size: 17)!]

    }
    
    func navBarDropShadow(scale: Bool = true)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        layer.shadowOpacity = 30
        layer.shadowOffset = CGSize(width: 0.0, height: 3)
        layer.shadowRadius = 3
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = frame.size.height/2
        self.shadowImage = UIImage()
    }
}



extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}


//MARK:- Shimmer Effect
/*
extension UIView {
    func hideShimmer() {
        self.hideSkeleton()
        self.stopSkeletonAnimation()
    }
    
    func showShimmer() {
        self.showAnimatedSkeleton()
        self.startSkeletonAnimation()
    }
}
*/

extension UIView {
    func setGradientBackgroundNew(colorTop: UIColor, colorBottom: UIColor) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradientLayer.locations = [0, 1]
//        gradientLayer.frame = bounds
//        layer.insertSublayer(gradientLayer, at: 0)
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [1, 0]
        gradientLayer.frame = self.bounds
        
        layer.insertSublayer(gradientLayer, at: 0)

        
        


    }
    
    func buttonDropShadow(scale: Bool = true)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        layer.shadowOpacity = 30
        layer.shadowOffset = CGSize(width: 0.0, height: 3)
        layer.shadowRadius = 3
        layer.cornerRadius = frame.size.height/2
    }
    
    func whiteButtonDropShadow(scale: Bool = true)
    {
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
//        layer.shadowOpacity = 30
//        layer.shadowOffset = CGSize(width: 0.0, height: 3)
//        layer.shadowRadius = 3
//        layer.cornerRadius = frame.size.height/2
        
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
       // layer.shadowOpacity = 80
        //layer.shadowOffset = CGSize(width: 0.0, height: 3)
        //layer.shadowRadius = 3
        layer.cornerRadius = frame.size.height/2
        
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        
    }
}



extension UIButton {
    func makeCicular() {
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    func makeCicularWithMasks() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
    }
    
}


//Func Set Empty Message to tableview
extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "Poppins-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
    }
}


extension UIViewController {
    
     func getNewFormattedCurrency(amount:String) -> String {
          
          if amount == "" {
              return ""
          }
          else if amount.contains(",") {
              return amount
          }
          let myDouble = Double(amount)!
          let currencyFormatter = NumberFormatter()
          currencyFormatter.usesGroupingSeparator = true
          currencyFormatter.numberStyle = .currency
          currencyFormatter.currencySymbol = ""
          // localize to your grouping and decimal separator
          currencyFormatter.locale = Locale.current
          // We'll force unwrap with the !, if you've got defined data you may need more error checking
          var priceString = currencyFormatter.string(from: NSNumber(value: myDouble))!
          print(priceString)
          priceString = priceString.replacingOccurrences(of: ".00", with: "")
          priceString = priceString.replacingOccurrences(of: " ", with: "")
          
          let formatedString =  String(format: "%@",priceString)
          
          //  let str = "₹ 3700"
          
          return formatedString.removeWhitespace()
      }
}



extension String {
    func getDate() -> Date {
        if self != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-M-yyyy"
            //formatter.timeZone = TimeZone(abbreviation: "GMT")
            
            let olddate = formatter.date(from: self)
            return olddate ?? Date()
        }
        return Date()
    }
    
    func getDateYMD() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-dd"
        //formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        
        let olddate = formatter.date(from: self)
        return olddate ?? Date()
    }
    
    func getGMTDateFromSTR() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
        
        let olddate = dateFormatter.date(from: self)
        return olddate ?? Date()
        
    }
    
    func getSimpleDateGMT() -> Date {
        if self != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
            
            let olddate = dateFormatter.date(from: self)
            return olddate ?? Date()
        }
        else {
            return Date()
        }
        //        return dateFormatter.string(from: self)
    }
    
    
    func getSimpleDateUTC() -> Date {
        if self != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
            
            let olddate = dateFormatter.date(from: self)
            return olddate ?? Date()
        }
        else {
            return Date()
        }
        //        return dateFormatter.string(from: self)
        
   
        
    }
    
    func getSimpleDate() -> Date {
          if self != "" {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "dd-MM-yyyy"
              //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
              
              let olddate = dateFormatter.date(from: self)
              return olddate ?? Date()
          }
          else {
              return Date()
          }
          //        return dateFormatter.string(from: self)
      }
    
    
    func getStrDateEnrollment() -> String {
        if self != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
            
            if let olddate = dateFormatter.date(from: self) {
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd-MMM-yyyy"
            return dateFormatter1.string(from: olddate)
            }
            return ""
        }
        else {
            return ""
        }
        //        return dateFormatter.string(from: self)
    }
    
    

}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
*/

//extension NSDictionary {
//
//    var json: Data {
//        let invalidJson = "Not a valid JSON"
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
//            //return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
//            return jsonData
//
//        } catch {
//            print("Exp")
//
//        }
//        return Data()
//    }
//
//
//}


class ConstantContent: NSObject {

    static let sharedInstance = ConstantContent()
    
    var currency = "₹"
    var imageForPaymentGateway = "https://wellness.mybenefits360.com/mybenefits/assets/img/logo-master-small.png"
    
    //Green Background color
    //let buttonBackgroundColor = UIColor.init(hexFromString: "20DBC0")
    //let lblGreenColor = UIColor.init(hexFromString: "20DBC0")

    func hexStringToUIColor (hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6)
        {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            
        )
    }
    
     func circularView(view:UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 20
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 2
        view.layer.cornerRadius = 10.0
    }
    
    

}

//Add space before text
extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

//MARK:- Navigation BAR Shadow
extension UIView {

    func navBarDropShadow11(scale: Bool = true)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        layer.shadowOpacity = 30
        layer.shadowOffset = CGSize(width: 0.0, height: 3)
        layer.shadowRadius = 3
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = frame.size.height/2
        
    }
    
    func makeTransparentBackground(){
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
//    func setBottomShadowButton() {
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
//        self.layer.shadowOpacity = 30
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 3)
//        self.layer.shadowRadius = 2
//        self.layer.cornerRadius = self.bounds.height / 2
//
//        self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
//        self.layer.borderWidth = 0.7
//    }
    
    func setGradientBackground1(colorTop: UIColor, colorBottom: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        // gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        //gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}

extension UIButton {
    func setBottomShadowButton() {
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
//        self.layer.shadowOpacity = 30
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 3)
//        self.layer.shadowRadius = 2
//        self.layer.cornerRadius = self.bounds.height / 2
//
//        self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10).cgColor
//        self.layer.borderWidth = 0.7
        
        layer.masksToBounds = false
        layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.shadowOpacity = 30
        layer.shadowOffset = CGSize(width: 0.0, height: 10)
        layer.shadowRadius = 10
        
        layer.cornerRadius = frame.size.height/2
        
    }
}

extension UILabel {
    
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            
            attributedString.addAttribute(NSAttributedStringKey.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
        }
        
        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedStringKey.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
}

//Capital First letter
extension String {
    func capitalizingFirstLetter() -> String {
        if self == "" {
            return self
        }
        else
        { return prefix(1).uppercased() + self.lowercased().dropFirst()
        }
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

//Remove white spaces between string.
extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}

//Replace last occurence of string in swift
extension String
{
    func replacingLastOccurrenceOfString(_ searchString: String,
                                         with replacementString: String,
                                         caseInsensitive: Bool = true) -> String
    {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }
        
        if let range = self.range(of: searchString,
                                  options: options,
                                  range: nil,
                                  locale: nil) {
            
            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
}

extension String {
    //MARK:- Convert Date
    func convertStringToDate() -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date1 = dateFormatter.date(from: self)
        {
            return date1
            //dateFormatter.dateFormat = "dd/MM/yyyy"
            // return  dateFormatter.string(from: date1)
        }
        else
        {
            return Date()
        }
    }
}

//Make Underline
extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

//Check Valid Contact
extension String {
    var isValidContact: Bool {
        let phoneNumberRegex = "^[1-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
}

//MARK:- Navigation Bar Font
extension UINavigationBar {
    func applyGradient() {
        self.applyNavigationGradient(colors: [Color.greenTop.value, Color.greenBottom.value])
    }
    
    func applyFitnessGradient() {
        self.applyNavigationGradient(colors: [Color.redBottom.value, Color.redTop.value])
    }
    
    func hideBackButton() {
        let backImage = UIImage(named: "back button")
          self.backIndicatorImage = UIImage(named: "back button")
         self.backIndicatorTransitionMaskImage = backImage
         self.backItem?.title = ""

    }
    
    //MARK:- Navigation bar font
    func changeFont(){
    
        self.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name:"Poppins-Medium", size: 17)!]

    }
    
    func navBarDropShadow(scale: Bool = true)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        layer.shadowOpacity = 30
        layer.shadowOffset = CGSize(width: 0.0, height: 3)
        layer.shadowRadius = 3
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = frame.size.height/2
        self.shadowImage = UIImage()
    }
}



extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}


//MARK:- Shimmer Effect

extension UIView {
    func hideShimmer() {
//        self.hideSkeleton()
//        self.stopSkeletonAnimation()
    }
    
    func showShimmer() {
//        self.showAnimatedSkeleton()
//        self.startSkeletonAnimation()
    }
}


extension UIView {
    func setGradientBackgroundNew(colorTop: UIColor, colorBottom: UIColor) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradientLayer.locations = [0, 1]
//        gradientLayer.frame = bounds
//        layer.insertSublayer(gradientLayer, at: 0)
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [1, 0]
        gradientLayer.frame = self.bounds
        
        layer.insertSublayer(gradientLayer, at: 0)

        
        


    }
    
    func buttonDropShadow(scale: Bool = true)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        layer.shadowOpacity = 30
        layer.shadowOffset = CGSize(width: 0.0, height: 3)
        layer.shadowRadius = 3
        layer.cornerRadius = frame.size.height/2
    }
    
    func whiteButtonDropShadow(scale: Bool = true)
    {
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
//        layer.shadowOpacity = 30
//        layer.shadowOffset = CGSize(width: 0.0, height: 3)
//        layer.shadowRadius = 3
//        layer.cornerRadius = frame.size.height/2
        
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
       // layer.shadowOpacity = 80
        //layer.shadowOffset = CGSize(width: 0.0, height: 3)
        //layer.shadowRadius = 3
        layer.cornerRadius = frame.size.height/2
        
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        
    }
}





extension UIButton {
    func makeCicular() {
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    func makeCicularWithMasks() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
    }
    func makeRound() {
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
}


//Func Set Empty Message to tableview
extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.lightGray
        titleLabel.font = UIFont(name: "Poppins-Regular", size: 17)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "Poppins-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor,constant: -20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor,constant: 0).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = ""
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
    }
}


extension String {
   
    func getSimpleDate() -> Date {
          if self != "" {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "dd-MM-yyyy"
              //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
              
              let olddate = dateFormatter.date(from: self)
              return olddate ?? Date()
          }
          else {
              return Date()
          }
          //        return dateFormatter.string(from: self)
      }
    
    
    func getStrDateEnrollment() -> String {
        if self != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
            
            if let olddate = dateFormatter.date(from: self) {
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd-MMM-yyyy"
            return dateFormatter1.string(from: olddate)
            }
            return ""
        }
        else {
            return ""
        }
        //        return dateFormatter.string(from: self)
    }
    
    func getStrDateFormatyyyyMMdd() -> String {
        if self != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
            
            if let olddate = dateFormatter.date(from: self) {
            //"message" : "\"member.date_of_birth\" must be in YYYY-MM-DD format",

            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            return dateFormatter1.string(from: olddate)
            }
            return self
        }
        else {
            return ""
        }
    }
    
    //Used on Aktivo Calendar
    func getStrDateFitnessBadge() -> String {
        if self != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
            
            if let olddate = dateFormatter.date(from: self) {
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd MMM yyyy"
                return dateFormatter1.string(from: olddate)
            }
            return ""
        }
        else {
            return ""
        }
        //        return dateFormatter.string(from: self)
    }
    
    //Used on Aktivo Profile
    func getStrDateFitnessProfile() -> String {
        if self != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
            
            if let olddate = dateFormatter.date(from: self) {
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd-MMM-yyyy"
                return dateFormatter1.string(from: olddate)
            }
            return ""
        }
        else {
            return ""
        }
        //        return dateFormatter.string(from: self)
    }
    

}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}


extension Date {
    func getSimpleDateDD_MMM() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"

        return dateFormatter.string(from: self)
    }
    
    //Used In HHC Physiotherapy
    func getSimpleDateDD_MMM_yyyy() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"

        return dateFormatter.string(from: self)
    }
}


extension UIDevice {

    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
           return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
   }
}


//FOR FITNESS SECTION
extension UIViewController {
    func setFitnessBackground() {
        //tableView.backgroundView = UIImageView(image: UIImage(named: "aktivo_background"))
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"aktivo_background")!)

       // self.view = UIImageView(image: UIImage(named: "aktivo_background"))
        
        self.view.layer.contents = UIImage(named: "aktivo_background")!.cgImage

    }
}


extension UINavigationController {

  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
      popToViewController(vc, animated: animated)
    }
  }

  func popViewControllers(viewsToPop: Int, animated: Bool = true) {
    if viewControllers.count > viewsToPop {
      let vc = viewControllers[viewControllers.count - viewsToPop - 1]
      popToViewController(vc, animated: animated)
    }
  }

}


extension UIView {
    func setBlackBorderToView()
    {
        layer.masksToBounds=true
        layer.cornerRadius=frame.size.height/2
        layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        layer.borderWidth=1
    }
}

//Added After Oct 2020

extension String {
    func titleCase() -> String {
        return self
            .replacingOccurrences(of: "([A-Z])",
                                  with: " $1",
                                  options: .regularExpression,
                                  range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized // If input is in llamaCase
    }
}
