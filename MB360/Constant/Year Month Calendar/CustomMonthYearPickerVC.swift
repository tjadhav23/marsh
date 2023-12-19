//
//  CustomMonthYearPickerVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 16/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

struct CustomMonthYearModel {
    var year : Int?
    var monthArray = [0,0,0,0,0,0,0,0,0,0,0,0]
}

protocol MonthYearProtocol {
    func monthsSelected(monthString:String,monthCount:Int,monthModelArray:[CustomMonthYearModel],stringSelectionArray:[String],firstDayAllMonthString:String,lastDayAllMonthString:String)
}

class CustomMonthYearPickerVC: UIViewController {

    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var backRootView: UIView!
    
    @IBOutlet weak var lblError: UILabel!
    //Buttons
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let height = 183.0
    
    let monthArray = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    
    var calendarModelArray = [CustomMonthYearModel]()
    var isNew = false
    var finalString = ""
    
    var delegateObject : MonthYearProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        lblYear.text = String(Date().year)
        backRootView.layer.cornerRadius = 10.0
        self.lblError.isHidden = true

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 252/3, height: height/4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout

        btnDone.makeCicular()
        btnCancel.makeCicular()
        
        //btnDone.backgroundColor = Color.buttonBackgroundGreen.value
        //btnCancel.backgroundColor = Color.buttonBackgroundGreen.value
        
        btnDone.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        btnDone.setTitleColor(#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), for: .normal)
        btnDone.layer.borderWidth = 1.0

        btnCancel.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        btnCancel.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .normal)
        btnCancel.layer.borderWidth = 1.0

        if self.calendarModelArray.count == 0 {
            setModel()
        }
    }
    
    private func setModel() {
        var currentYear = Date().year
        var i = 0
        for i in 0..<10 {
            let monthArray = [0,0,0,0,0,0,0,0,0,0,0,0]
            let obj = CustomMonthYearModel.init(year: currentYear, monthArray: monthArray)
            self.calendarModelArray.append(obj)
            currentYear += 1
        }
    }
    
    
   
    //MARK:- Button Actions
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        self.finalString = ""
        
        var startMonthString = ""
        var endMonthString = ""
        
        var selectedMonthCount = 0
        
        //To display on previous screen
        var stringSelectionArray = [String]()
        if calendarModelArray.count > 0 {
        for obj in calendarModelArray {
            let monthArray = obj.monthArray
            let year = obj.year
            var no = 1 //for array index 0th to 11th

            for month in monthArray {
                if month == 1 {
                    selectedMonthCount += 1
                    let stringWithoutComma = "\(getMonth(index: no - 1))-\(year!.description)"
                    let string = "\(getMonth(index: no - 1))/\(year!.description),"
                    finalString.append(contentsOf: string)
                    stringSelectionArray.append(stringWithoutComma)
                    
                    //For Request API Parameter
                    //Create Start Date String
                    let startDateStr = String(format: "01-%@-%@", no.description,year!.description)
                    //convert into Date() Format
                    let dateStart = startDateStr.getDate()
                    
                    //Get End Date of month from Date()
                    let endDate = dateStart.endOfMonth()
                    
                    //Get start and end date with comma
                    let strStartDate = "\(dateStart.getSimpleDateGMTStrIndia()),"
                    let strEndDate = "\(endDate.getSimpleDateGMTStrIndia()),"
                    
                    //append start and end date string
                    startMonthString.append(strStartDate)
                    endMonthString.append(strEndDate)
                    
                }
                no += 1
            }
        }
        if finalString.count > 0 {
        finalString = String(finalString.dropLast())
            startMonthString = String(startMonthString.dropLast())
            endMonthString = String(endMonthString.dropLast())
            
            if delegateObject != nil {
                delegateObject?.monthsSelected(monthString: finalString,monthCount: selectedMonthCount, monthModelArray: calendarModelArray, stringSelectionArray: stringSelectionArray,firstDayAllMonthString:startMonthString ,lastDayAllMonthString:endMonthString)
                self.dismiss(animated: true, completion: nil)
            }

        }
        else {

            self.displayActivityAlert(title: "Please Select Month")
            //self.lblError.isHidden = false
        }
        }
        else
        {
            self.displayActivityAlert(title: "Please Select Month")

        }
        print("SelectedMonths..")
        print(finalString)
        
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        var selectedYear = Int(lblYear.text!) ?? Date().year
        
        selectedYear += 1
         let calenadrObj = calendarModelArray.filter({$0.year == selectedYear})
        if calenadrObj.count > 0 {
            self.lblYear.text = selectedYear.description
            self.collectionView.reloadData()
        }
        
    }
    
    @IBAction func btnPrevTapped(_ sender: UIButton) {
        var selectedYear = Int(lblYear.text!) ?? Date().year
        
        selectedYear -= 1
         let calenadrObj = calendarModelArray.filter({$0.year == selectedYear})
        if calenadrObj.count > 0 {
            self.lblYear.text = selectedYear.description
            self.collectionView.reloadData()
        }
    }
    
}

//MARK:- CollectionView Delegate & Datasource
extension CustomMonthYearPickerVC : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MonthSelection_HHC_Cell
        cell.lblMonth.text = getMonth(index: indexPath.row)
        
        let selectedYear = Int(lblYear.text!) ?? Date().year
         let calenadrObj = calendarModelArray.filter({$0.year == selectedYear})
        if calenadrObj.count > 0 {
            if calenadrObj[0].monthArray[indexPath.row] == 1 {
                //selected
                cell.backView.backgroundColor = Color.buttonBackgroundGreen.value
                cell.lblMonth.textColor = UIColor.white
                
            }
            else {
                //not selected
                cell.backView.backgroundColor = UIColor.white
                cell.lblMonth.textColor = UIColor.lightGray

            }
            
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let selectedYear = Int(lblYear.text!) ?? Date().year
        
        if Date().year == selectedYear {
            if Date().month1 > indexPath.row + 1 {
               return
            }
        }
        
        let calenadrObj = calendarModelArray.filter({$0.year == selectedYear})
        
        if calenadrObj.count > 0 {
            var modelMonthsArray = calenadrObj[0].monthArray
            
            if modelMonthsArray.count > indexPath.row {
                if modelMonthsArray[indexPath.row] == 1 {
                    modelMonthsArray[indexPath.row] = 0
                }
                else {
                    modelMonthsArray[indexPath.row] = 1
                }
            }
            
            
            if let row = calendarModelArray.firstIndex(where: {$0.year == selectedYear}) {
                calendarModelArray[row].monthArray = modelMonthsArray
            }
            
        }
        self.collectionView.reloadData()
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 252/3, height: height/4);
    }


    func getMonth(index:Int) -> String {
        return monthArray[index]
    }
    
}



extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}
