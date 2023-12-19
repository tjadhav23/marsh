//
//  EnrollmentInstructionsVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 24/02/20.
//  Copyright © 2020 Semantic. All rights reserved.
//
import UIKit


class EnrollmentInstructionsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var descriptionArray : [String] = []
    //= ["Verify the accuracy of your personal information - names, birth dates, and relations of your eligible dependants."]
    
    var myInstructionArray = [Instructions]()
    var lastContentOffset: CGFloat = 0 //ScrollViewDelegate
    var hideCollectionViewDelegate : HideCollectionViewProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Commented to fetch for array json
        getDataForInstructions()
        
        //fetchJsonDataFromInstructions()
        
        
        if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
        {
            self.tableView.isScrollEnabled = true
        }
        else {
            self.tableView.isScrollEnabled = true
        }
        
        //Add New Dependants Cell
        tableView.register(CellForInstructionHeaderCell.self, forCellReuseIdentifier: "CellForInstructionHeaderCell")
        tableView.register(UINib(nibName: "CellForInstructionHeaderCell", bundle: nil), forCellReuseIdentifier: "CellForInstructionHeaderCell")
        
        tableView.register(CellForInstructions.self, forCellReuseIdentifier: "CellForInstructions")
        tableView.register(UINib(nibName: "CellForInstructions", bundle: nil), forCellReuseIdentifier: "CellForInstructions")
        
        
        let startPoint = CGPoint(x:0.5, y:0.0)
        let endPoint = CGPoint(x:0.5, y:1.0)
        
        //self.view.setGradient(colorTop: EnrollmentColor.ghiTop.value, colorBottom: EnrollmentColor.ghiBottom.value, startPoint: startPoint, endPoint: endPoint, gradientLayer: gradientLayer)
        
        // setColorNew(view: self.view, colorTop: EnrollmentColor.empDetailsTop.value, colorBottom: EnrollmentColor.empDetailsBottom.value,gradientLayer:gradientLayer)
        
        
        
        self.view.setGradientBackground1(colorTop: EnrollmentColor.instructionTop.value, colorBottom: EnrollmentColor.instructionBottom.value, startPoint: startPoint, endPoint: endPoint, angle: 120)
        
        
        //   self.view.layer.contents = #imageLiteral(resourceName: "instructionsbgFinal").cgImage
        
        //displayOverlay()
        
        
    }
    
    private func displayOverlay() {
        let vc = UIStoryboard.init(name: "FlexiBen", bundle: nil).instantiateViewController(withIdentifier: "OverlayIntructionVC") as! OverlayIntructionVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    var isLoadedFlag = 0
    override func viewWillAppear(_ animated: Bool) {
        //getWindowPeriodDetails()
        tableView.reloadData()
        //        UIView.transition(with: tableView,
        //        duration: 0.35,
        //        options: .transitionCrossDissolve,
        //        animations: { self.tableView.reloadData() })
        //        self.view.myCustomAnimation()
        
        
        if isLoadedFlag == 0 {
            
            animateTable()
            isLoadedFlag = 1
        }
        
        
    }
    
    let gradientLayer = CAGradientLayer()
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = self.view.bounds
        CATransaction.commit()
    }
    
    
    
    
    
}


//MARK:- TableView Delegate & Datasource
extension EnrollmentInstructionsVC : UITableViewDelegate,UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        //return descriptionArray.count
        print("Count : 117",self.myInstructionArray.count)
        return self.myInstructionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForInstructionHeaderCell", for: indexPath) as! CellForInstructionHeaderCell
            cell.imgView.image = UIImage(named:"Asset 37")
            cell.lblDescription.text = ""
            cell.lblHeaderName.text = "Instructions"
            cell.btnTimer.alpha = 0
            cell.vewTimer.alpha = 0
            return cell
        }
        else { //Plans
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForInstructions", for: indexPath) as! CellForInstructions
            //cell.lblDescription.text = descriptionArray[indexPath.row]
            //cell.lblName.text = nameArray[indexPath.row]
            
            cell.lblDescription.text = self.myInstructionArray[indexPath.row].InstructionText
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140
        }
        
        //return 90
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        //let titleLabel = UILabel(frame: CGRect(x:10,y: 5 ,width:350,height:150))
        return vw
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 80
        }
        return 0
    }
    
    
    
    
}


extension EnrollmentInstructionsVC:UIScrollViewDelegate {
    // we set a variable to hold the contentOffSet before scroll view scrolls
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            if self.hideCollectionViewDelegate != nil {
                hideCollectionViewDelegate?.scrolled(index: 1)
            }
            
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            if self.hideCollectionViewDelegate != nil {
                hideCollectionViewDelegate?.show(index: 1)
            }
        } else {
            // didn't move
            if self.hideCollectionViewDelegate != nil {
                hideCollectionViewDelegate?.show(index: 1)
            }
            
        }
    }
    
    func animateTable() {
        
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            
            let cell: UITableViewCell = i as UITableViewCell
            if i.isKind(of: CellForInstructionHeaderCell.self) {
                cell.transform = CGAffineTransform(translationX: 0, y: -tableHeight)
            }
            else{
                cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            }
        }
        
        
        var index = 0
        
        for a in cells {
            
            if a.isKind(of: CellForInstructions.self) {
                let cell: CellForInstructions = a as! CellForInstructions
                
                UIView.animate(withDuration: 2, delay: 0.4 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    
                }, completion: nil)
                
                index += 1
            }
            
            else {
                //CellForParentalPremium
                let cell: CellForInstructionHeaderCell = a as! CellForInstructionHeaderCell
                
                UIView.animate(withDuration: 1.5, delay: 0.4 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    
                }, completion: nil)
                
                index += 1
                
            }
        }
    }
    
    func getDataForInstructions(){
        if(isConnectedToNetWithAlert()){
            
            let designation = "Android Engineer"
            
            let url = "http://localhost:3000/getInstructions"
            var urlRequest = URLRequest(url: URL(string: url)!)
            self.myInstructionArray.removeAll()
            let datatask = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
                (data, httpUrlResponse, error ) in
                guard let dataResponse = data,
                      error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
                do{
                    //here dataResponse received from a network request
                    let json = try JSONDecoder().decode(InstructionsNestedJSONModel.self, from: dataResponse)
                    let dataArray = json.instructions
                    
                    print("dataArray",dataArray)
                    
                    DispatchQueue.main.async {
                        for item in dataArray {
                            print("Designation: ",item.Designation.lowercased())
                            if item.Designation.lowercased() == designation.lowercased(){
                                self.myInstructionArray.append(item)
                            }
                            else{
                                
                            }
                        }
                        print("myCoveragesArray count: ",self.myInstructionArray.count)
                        self.tableView.reloadData()
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            })
            datatask.resume()
        }
    }
    
    func fetchJsonDataFromInstructions(){
        
        var designation = "IOS ENGINEER"
        var json: Any?
        
        if let path = Bundle.main.path(forResource: "EnrollmentInstructionJson", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let json = try JSONDecoder().decode(InstructionsNestedJSONModel.self, from: data)
                
                let dataArray = json.instructions
                for item in dataArray {
                    // DATA INSIDE Instructions ARRAY
                    
                    if(item.to_show_DESIGNATION.lowercased() == designation.lowercased()){
                        myInstructionArray.append(item)
                    }
                    
                }
                //print("Count for myCoveragesArray: ",myCoveragesArray.count)
            }catch{
                print("Error is: ",error)
            }
        }
        
    }
}
