//
//  extensions.swift
//  MyBenefits360
//
//  Created by home on 08/12/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation
import MBProgressHUD


extension UIView {
    func myCustomAnimation() {
        print("CS Animation....")
//        self.alpha = 0
//        self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
//        UIView.animate(withDuration: 0.7) {
//            self.alpha = 1
//            self.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
//        }
        
       // self.layer.contents = #imageLiteral(resourceName: "").cgImage
       // self.backgroundColor = UIColor.clear
        
        //        UIView.transition(with: self,
        //                          duration: 0.5,
        //                          options: [.transitionFlipFromTop],
        //                          animations: {
        //
        //                            self.isHidden = true
        //        },
        //                          completion: {(void) in
        //                            self.isHidden = false
        //
        //                            })
        
    }
    
    func dropShadow(scale: Bool = true)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        layer.shadowOpacity = 30
        layer.shadowOffset = CGSize(width: 0.0, height: 3)
        layer.shadowRadius = 3
        
        layer.cornerRadius = frame.size.height/2
        
    }
    
    
    
    func setBorderToView(color : UIColor)
    {
        layer.masksToBounds=true
        layer.cornerRadius=frame.size.height/2
        layer.borderColor=color.cgColor
        layer.borderWidth=1
    }
    
    func setBorderToViewSelectPolicy(color : UIColor)
    {
        layer.masksToBounds=true
        layer.cornerRadius=cornerRadiusForView//8
        layer.borderColor=color.cgColor
        layer.borderWidth=1
    }
    
    func ShadowForView(scale: Bool = true)
    {
        
        
        let shadowSize : CGFloat = 3.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: frame.size.width + shadowSize,
                                                   height: frame.size.height + shadowSize))
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.cornerRadius=cornerRadiusForView//8
        
    }
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.65, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}


extension UITextField {

    @available(iOS 13.4, *)
    func addInputViewDatePicker(_ selectedDate : Date,_ maxDate : Date,target: Any, selector: Selector) {

   let screenWidth = UIScreen.main.bounds.width

   //Add DatePicker as inputView
   let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
   datePicker.datePickerMode = .date

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }else{
            datePicker.preferredDatePickerStyle = .automatic
        }
        
        datePicker.maximumDate = maxDate//Calendar.current.date(byAdding: .year, value: 1, to: Date())
        datePicker.minimumDate = selectedDate
        
   self.inputView = datePicker

   //Add Tool Bar as input AccessoryView
   let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
   let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
   let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
   let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
   toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

   self.inputAccessoryView = toolBar
}

  @objc func cancelPressed() {
    self.resignFirstResponder()
  }
}

extension Data
{
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding)
        {
            append(data)
        }
    }
}


extension UITabBar{
    func inActiveTintColor() {
        if let items = items{
            for item in items{
                item.image =  item.image?.withRenderingMode(.alwaysOriginal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.lightGray], for: .normal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : Color.redBottom.value], for: .selected)
            }
        }
    }
    
    func inActiveTintColorRed() {
        if let items = items{
            for item in items{
                item.image =  item.image?.withRenderingMode(.automatic)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.lightGray], for: .normal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : Color.redBottom.value], for: .selected)
            }
        }
    }
    
    func inActiveTintColorGreen() {
        if let items = items{
            for item in items{
                item.image =  item.image?.withRenderingMode(.automatic)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.lightGray], for: .normal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : Color.buttonBackgroundGreen.value], for: .selected)
            }
        }
    }
}

extension Date {
    
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
}
extension Date {
    
    func components(_ components: Set<Calendar.Component>) -> DateComponents {
        return Calendar.current.dateComponents(components, from: self)
    }
    
    func component(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    var era: Int { return component(.era) }
    var year: Int { return component(.year) }
    var monthC: Int { return component(.month) }
    var day: Int { return component(.day) }
    var hour: Int { return component(.hour) }
    var minute: Int { return component(.minute) }
    var second: Int { return component(.second) }
    var weekday: Int { return component(.weekday) }
    var weekdayOrdinal: Int { return component(.weekdayOrdinal) }
    var quarter: Int { return component(.quarter) }
    var weekOfMonth: Int { return component(.weekOfMonth) }
    var weekOfYear: Int { return component(.weekOfYear) }
    var yearForWeekOfYear: Int { return component(.yearForWeekOfYear) }
    var nanosecond: Int { return component(.nanosecond) }
    var calendar: Calendar? { return components([.calendar]).calendar }
    var timeZone: TimeZone? { return components([.timeZone]).timeZone }
    
}


extension Date {
    struct Formatter {
        static let utcFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            return dateFormatter
        }()
    }
    
    var dateToUTC: String {
        return Formatter.utcFormatter.string(from: self)
    }
}

extension String {
    struct Formatter {
        static let utcFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            //dateFormatter.timeZone = TimeZone(identifier: "UTC+05:30")
            dateFormatter.timeZone = TimeZone(identifier: "IST")
            
            return dateFormatter
        }()
    }
    
    var dateFromUTC: Date? {
        return Formatter.utcFormatter.date(from: self)
    }
}


extension UIViewController {
    
    func showFitnessLoader(msg:String, type:Int) {
        
        
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            //hud.label.text = msg
            
            switch type {
            case 1:
                hud.bezelView.color = UIColor.white
                hud.bezelView.backgroundColor = UIColor.white //small box white
                hud.backgroundColor = UIColor.white //complete page make white
                hud.bezelView.layer.cornerRadius = 0
                break
            case 2:
                hud.backgroundColor = UIColor.clear
                hud.bezelView.backgroundColor = UIColor.clear
                hud.bezelView.color = UIColor.clear
                hud.bezelView.style = .solidColor
                // hud.backgroundView.color = UIColor.clear
                break
            default:
                break
            }
            
            hud.show(animated: true)
        }
    }
}


extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    var monthStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
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
}


extension Date {
    func convertToLocalTime(fromTimeZone timeZoneAbbreviation: String) -> Date? {
        if let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
            let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
            let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))
            
            return self.addingTimeInterval(targetOffset - localOffeset)
        }
        
        return nil
    }
}


extension Date {
    
    func getDaysInMonthFC() -> Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    func addMonthFC(month: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: month, to: self)!
    }
    
    func addMonthFCM(month: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: -month, to: self)!
    }
    
    func startOfMonthFC() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonthFC() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonthFC())!
    }
    
    func getDayOfWeekFC() -> Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
    }
    
    func getHeaderTitleFC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, YYYY"
        return dateFormatter.string(from: self)
    }
    func getDay() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.string(from: self)
    }
    
    //USed in stats aktivo weekly graph
    func getDayUTC() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self.dayAfter)
    }
    
    func getDayFC(day: Int) -> Date {
        let day = Calendar.current.date(byAdding: .day, value: day, to: self)!
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: day)!
    }
    
    func getYearOnlyFC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self)
    }
    
    func getTitleDateFC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM dd"
        return dateFormatter.string(from: self)
    }
    
    func getSimpleDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    //AKTIVO
    func getMMMddYYYYDateFC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter.string(from: self)
    }
    
    func getSimpleDateUTC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!

        return dateFormatter.string(from: self)
    }
    func getSimpleDateGMTStr() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
        
        return dateFormatter.string(from: self)
    }
    
    //USED IN HHC
    func getSimpleDateGMTStrIndia() -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd/MM/yyyy"
          // dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 19800)
           return dateFormatter.string(from: self)
       }
    //Used on Aktivo Profile wakeup time and bed time
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
}

extension UIView {
    func callRecursively(level: Int = 0, _ body: (_ subview: UIView, _ level: Int) -> Void) {
        body(self, level)
        subviews.forEach { $0.callRecursively(level: level + 1, body) }
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
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    var weekAgoDate: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: noon)!
    }
    var monthAgoDate: Date {
        return Calendar.current.date(byAdding: .day, value: -30, to: noon)!
    }
    
}

private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}

extension NSDictionary {
    
    var json: Data {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            //return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
            return jsonData
            
        } catch {
            print("Exp")
            
        }
        return Data()
    }
    
    
}
