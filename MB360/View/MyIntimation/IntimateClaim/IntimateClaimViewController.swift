//
//  IntimateClaimViewController.swift
//  MyBenefits
//
//  Created by Semantic on 17/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit

class IntimateClaimViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate {
    @IBOutlet var m_dateView: UIView!
    @IBOutlet weak var m_topBarVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var m_tabbarView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var m_intimateNowButton: UIButton!
    
    @IBOutlet weak var m_IntimateNowTab: UIButton!
    @IBOutlet weak var m_datePickerSubview: UIView!
    
    @IBOutlet weak var m_datePicker: UIDatePicker!
    
    var xmlKey = String()
    var resultsDictArray: [[String: String]]?         // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
     var recordKey = String()
    var dictionaryKeys = ["PERSON_NAME", "PERSON_RELATION", "PERSON_SR_NO", "SORT_ORDER","CLM_INT_COUNT","CLM_INT_CLAIMANT","CLM_INT_COUNT_TEXT","INT_CLM_INTIMATION_DT","INT_CLM_HOSPITAL","INT_CLM_DOA_LIKELYDOA","INT_CLM_CLAIM_AMOUNT","INT_CLM_DIAGNOSIS_OR_AILMENT","IntimateError","INT_CLM_INTIMATION_NO"]
    var m_reuseIdentifier = "cell"
    var m_selectedDate = NSDate()
    var m_errorMessageArray = ["Select person", "Enter Diagnosis","Enter Amount","Enter DOA","Enter Name of Hospital","Enter Hospital Location"]
    
    @IBOutlet weak var m_tableView: UITableView!
    
    
    var m_membersArray = Array<String>()
    let dateDropDown=DropDown()
    var check = Int()
    var textFields: [UITextField]!
    
    var m_claimDetailsArray = ["","","","","",""]
    var m_titleArray = ["  Intimate For","  Diagnosis/Ailment","Estimated Reported Amount","DOA/Likely DOA","Hospital Name","Hospital Location"]
    
//    var m_enrollmentDetailsArray = Array<EnrollmentDetails>()
    var m_personDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden=true
        m_tableView.register(IntimateClaimTableViewCell.self, forCellReuseIdentifier: m_reuseIdentifier)
      
        m_tableView.register(UINib(nibName: "IntimateClaimTableViewCell", bundle: nil), forCellReuseIdentifier: m_reuseIdentifier)
        
        m_tableView.tableFooterView=UIView()
        m_tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
         self.navigationItem.title="Intimate Claim"
        
        navigationItem.leftBarButtonItem=getBackButton()
        if (Device.IS_IPHONE_X)
        {
//            m_topBarVerticalConstraint.constant=84
        }
        
        m_IntimateNowTab.layer.masksToBounds=true
        m_IntimateNowTab.layer.cornerRadius=m_IntimateNowTab.frame.size.height/2
        
        m_tabbarView.setBorderToView(color:hexStringToUIColor(hex: "E5E5E5"))
        m_intimateNowButton.dropShadow()
        m_intimateNowButton.layer.cornerRadius=25
        resetButton.dropShadow()
        resetButton.layer.cornerRadius=25
        
    }
    
    override func backButtonClicked()
    {
        self.tabBarController?.tabBar.isHidden=true
        _ = navigationController?.popViewController(animated: true)
    }
   
    @IBAction func resetButtonClicked(_ sender: Any)
    {
        m_claimDetailsArray = ["","","","","",""]
        m_tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool)
    {
       /*m_enrollmentDetailsArray = DatabaseManager.sharedInstance.retrieveEnrollmentDetails(productCode: "")
        var enrollmentDetailsDict : EnrollmentDetails?
        
        for enrollmentDetailsDict in m_enrollmentDetailsArray
        {
            m_membersArray.append(enrollmentDetailsDict.beneficiaryName!)
        }*/
        getPersonInfoForIntimation()
        
    }
    func getPersonInfoForIntimation()
    {
        if(isConnectedToNetWithAlert())
        {
            
            let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getPersonInfoForIntimation(employeesrno: UserDefaults.standard.value(forKey: "EmployeeSrNo") as! String))
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            request.url = urlreq as URL?// NSURL(string: urlreq)
            request.httpMethod = "GET"
            
            
            
            let task = URLSession.shared.dataTask(with: urlreq! as URL)
            { (data, response, error) in
                
                if data == nil
                {
                    
                    return
                }
                self.xmlKey = "IntimationPerson"
                let parser = XMLParser(data: data!)
                parser.delegate = self
                parser.parse()
                
                DispatchQueue.main.async
                    {
                        
                        for dict in self.resultsDictArray!
                        {
                            self.m_personDict  = dict as NSDictionary
                            self.m_membersArray.append(self.m_personDict.value(forKey: "PERSON_NAME") as! String)
                        }
                        
                }
                
                
                
            }
            task.resume()
        }
        
    }
    
    @IBAction func intimateClaimButtonClicked(_ sender: Any)
    {
        for textField in textFields
        {
            textField.resignFirstResponder()
//            textField.errorMessage=m_errorMessageArray[textField.tag]
//            textFieldDidEndEditing(textField)
            print("resign")
        }
        self.view.endEditing(true)
        
        
        let status =  CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: m_claimDetailsArray[2]))
        
        if(m_claimDetailsArray[0]=="")
        {
            
            displayActivityAlert(title: "Select person")
           let textfield = textFields[0].tag
            print(textfield)
        }
        else if(m_claimDetailsArray[1]=="")
        {
            displayActivityAlert(title: "Enter Diagnosis/Ailment")
            
        }
        else if(m_claimDetailsArray[1].contains("<") || m_claimDetailsArray[1].contains(">") || m_claimDetailsArray[1].contains("&") || m_claimDetailsArray[1].contains("=") || m_claimDetailsArray[1].contains("<") || m_claimDetailsArray[1].contains("JAVASCRIPT") || m_claimDetailsArray[1].contains("SCRIPT") || m_claimDetailsArray[1].contains("*") || m_claimDetailsArray[1].contains("{") || m_claimDetailsArray[1].contains("}") || m_claimDetailsArray[1].contains("-") || m_claimDetailsArray[1].contains("^") || m_claimDetailsArray[1].contains("`") || m_claimDetailsArray[1].contains("~") || m_claimDetailsArray[1].contains("$") || m_claimDetailsArray[1].contains("#") || m_claimDetailsArray[1].contains("WINDOW.") || m_claimDetailsArray[1].contains("DOCUMENT.") || m_claimDetailsArray[1].contains("VAL(") || m_claimDetailsArray[1].contains("LOG") || m_claimDetailsArray[1].contains("@")){
            displayActivityAlert(title: "Enter valid Diagnosis/Ailment")
        }
        else if(m_claimDetailsArray[2]=="")
        {
            displayActivityAlert(title: "Enter Amount")
        }
        else if(m_claimDetailsArray[2].contains("<") || m_claimDetailsArray[2].contains(">") || m_claimDetailsArray[2].contains("&") || m_claimDetailsArray[2].contains("=") || m_claimDetailsArray[2].contains("<") || m_claimDetailsArray[2].contains("JAVASCRIPT") || m_claimDetailsArray[2].contains("SCRIPT") || m_claimDetailsArray[2].contains("*") || m_claimDetailsArray[2].contains("{") || m_claimDetailsArray[2].contains("}") || m_claimDetailsArray[2].contains("-") || m_claimDetailsArray[2].contains("^") || m_claimDetailsArray[2].contains("`") || m_claimDetailsArray[2].contains("~") || m_claimDetailsArray[2].contains("$") || m_claimDetailsArray[2].contains("#") || m_claimDetailsArray[2].contains("WINDOW.") || m_claimDetailsArray[2].contains("DOCUMENT.") || m_claimDetailsArray[2].contains("VAL(") || m_claimDetailsArray[2].contains("LOG") || m_claimDetailsArray[2].contains("@")){
            displayActivityAlert(title: "Enter valid Amount")
        }
        else if(!status)
        {
            displayActivityAlert(title:"Enter valid amount")
        }
        else if(m_claimDetailsArray[3]=="")
        {
            displayActivityAlert(title: "Enter DOA")
        }
        else if(m_claimDetailsArray[3].contains("<") || m_claimDetailsArray[3].contains(">") || m_claimDetailsArray[3].contains("&") || m_claimDetailsArray[3].contains("=") || m_claimDetailsArray[3].contains("<") || m_claimDetailsArray[3].contains("JAVASCRIPT") || m_claimDetailsArray[3].contains("SCRIPT") || m_claimDetailsArray[3].contains("*") || m_claimDetailsArray[3].contains("{") || m_claimDetailsArray[3].contains("}") || m_claimDetailsArray[3].contains("-") || m_claimDetailsArray[3].contains("^") || m_claimDetailsArray[3].contains("`") || m_claimDetailsArray[3].contains("~") || m_claimDetailsArray[3].contains("$") || m_claimDetailsArray[3].contains("#") || m_claimDetailsArray[3].contains("WINDOW.") || m_claimDetailsArray[3].contains("DOCUMENT.") || m_claimDetailsArray[3].contains("VAL(") || m_claimDetailsArray[3].contains("LOG") || m_claimDetailsArray[3].contains("@")){
            displayActivityAlert(title: "Enter valid DOA")
        }
        else if(m_claimDetailsArray[4]=="")
        {
            displayActivityAlert(title: "Enter Hospital Name")
        }
        else if(m_claimDetailsArray[4].contains("<") || m_claimDetailsArray[4].contains(">") || m_claimDetailsArray[4].contains("&") || m_claimDetailsArray[4].contains("=") || m_claimDetailsArray[4].contains("<") || m_claimDetailsArray[4].contains("JAVASCRIPT") || m_claimDetailsArray[4].contains("SCRIPT") || m_claimDetailsArray[4].contains("*") || m_claimDetailsArray[4].contains("{") || m_claimDetailsArray[4].contains("}") || m_claimDetailsArray[4].contains("-") || m_claimDetailsArray[4].contains("^") || m_claimDetailsArray[4].contains("`") || m_claimDetailsArray[4].contains("~") || m_claimDetailsArray[4].contains("$") || m_claimDetailsArray[4].contains("#") || m_claimDetailsArray[4].contains("WINDOW.") || m_claimDetailsArray[4].contains("DOCUMENT.") || m_claimDetailsArray[4].contains("VAL(") || m_claimDetailsArray[4].contains("LOG") || m_claimDetailsArray[4].contains("@")){
            displayActivityAlert(title: "Enter valid Hospital Name")
        }
        else if(m_claimDetailsArray[5]=="")
        {
            displayActivityAlert(title: "Enter Hospital Location")
        }
        else if(m_claimDetailsArray[5].contains("<") || m_claimDetailsArray[5].contains(">") || m_claimDetailsArray[5].contains("&") || m_claimDetailsArray[5].contains("=") || m_claimDetailsArray[5].contains("<") || m_claimDetailsArray[5].contains("JAVASCRIPT") || m_claimDetailsArray[5].contains("SCRIPT") || m_claimDetailsArray[5].contains("*") || m_claimDetailsArray[5].contains("{") || m_claimDetailsArray[5].contains("}") || m_claimDetailsArray[5].contains("-") || m_claimDetailsArray[5].contains("^") || m_claimDetailsArray[5].contains("`") || m_claimDetailsArray[5].contains("~") || m_claimDetailsArray[5].contains("$") || m_claimDetailsArray[5].contains("#") || m_claimDetailsArray[5].contains("WINDOW.") || m_claimDetailsArray[5].contains("DOCUMENT.") || m_claimDetailsArray[5].contains("VAL(") || m_claimDetailsArray[5].contains("LOG") || m_claimDetailsArray[5].contains("@")){
            displayActivityAlert(title: "Enter valid Hospital Location")
        }
        else
        {
            if(isConnectedToNetWithAlert())
            {
                let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getIntimateNewClaimUrl(employeesrno: 1104356, personsrno: m_personDict.value(forKey: "") as! Int32, diagnosis: m_claimDetailsArray[1], claimamount: m_claimDetailsArray[2], likelydoa: m_claimDetailsArray[3], nameofhospital: m_claimDetailsArray[4], locationofhospital: m_claimDetailsArray[5]))
                
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?// NSURL(string: urlreq)
                request.httpMethod = "GET"
                
                
                
                let task = URLSession.shared.dataTask(with: (urlreq as URL?)!)
                { (data, response, error) in
                    
                    if data == nil
                    {
                        
                        return
                    }
                    self.xmlKey = "Intimate"
                    let parser = XMLParser(data: data!)
                    parser.delegate = self
                    parser.parse()
                    
                   for obj in self.resultsDictArray!
                   {
                    print(obj)
                    }
                    
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    
                }
                task.resume()
            }
        
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return m_titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell :IntimateClaimTableViewCell = tableView.dequeueReusableCell(withIdentifier: m_reuseIdentifier, for: indexPath) as! IntimateClaimTableViewCell
        
         cell.m_titleTextField.layer.masksToBounds=true
         cell.m_titleTextField.layer.borderColor=hexStringToUIColor(hex: "E5E5E5").cgColor
         cell.m_titleTextField.layer.borderWidth=1
         cell.m_titleTextField.layer.cornerRadius=cell.m_titleTextField.frame.size.height/2
       
        
        textFields=[cell.m_titleTextField]
        cell.m_titleTextField.tag = indexPath.row
        cell.m_selectButton.tag = indexPath.row
        
        setupField(textField: cell.m_titleTextField, with: m_titleArray[indexPath.row])
        
        switch indexPath.row
        {
            
        case 0:
            cell.m_titleTextField.isUserInteractionEnabled=true
            cell.m_selectButton.isHidden=false
            let image = #imageLiteral(resourceName: "arrow")
           
            cell.m_selectButton.addTarget(self, action: #selector(selectDropDown), for: .touchUpInside)
            
            
            
            let button = UIButton(type: .custom)
            button.setImage(image, for: .normal)
            
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
            button.contentMode=UIViewContentMode.scaleAspectFit
            button.frame = CGRect(x: CGFloat(-10), y: CGFloat(2), width: CGFloat(30), height: CGFloat(20))
          
            
//            button.addTarget(self, action: #selector(selectDropDown(sender:)), for: .touchUpInside)
            
            cell.m_titleTextField.rightView =  button
            cell.m_titleTextField.rightViewMode = .always
            
            
            break
        case 1:
            cell.m_titleTextField.isUserInteractionEnabled=true
            cell.m_selectButton.isHidden=true
            
        case 2:
             cell.m_titleTextField.isUserInteractionEnabled=true
          cell.m_titleTextField.keyboardType=UIKeyboardType.numbersAndPunctuation
            cell.m_selectButton.isHidden=true
             setLeftSideImageView(image: #imageLiteral(resourceName: "Rupee"), textField: cell.m_titleTextField)
             break
            break
        case 3:
            
            cell.m_titleTextField.isUserInteractionEnabled=true
            cell.m_selectButton.isHidden=false
            let image = #imageLiteral(resourceName: "Date")
            setLeftSideImageView(image: #imageLiteral(resourceName: "Date"), textField: cell.m_titleTextField)
            
            cell.m_selectButton.addTarget(self, action:#selector(selectDateButtonClicked(sender:)), for: .touchUpInside)
                        
            let button = UIButton(type: .custom)
//            button.setImage(image, for: .normal)
//            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            button.frame = CGRect(x: CGFloat(-5), y: CGFloat(2), width: CGFloat(35), height: CGFloat(35))
           
            
            cell.m_titleTextField.rightView =  button
            cell.m_titleTextField.rightViewMode = .always
            
            
            break
            
        case 4:
            cell.m_titleTextField.isUserInteractionEnabled=true
            cell.m_selectButton.isHidden=true
            setLeftSideImageView(image: #imageLiteral(resourceName: "HospitalName"), textField: cell.m_titleTextField)
            break
        case 5:
            cell.m_titleTextField.isUserInteractionEnabled=true
            cell.m_selectButton.isHidden=true
            setLeftSideImageView(image: #imageLiteral(resourceName: "placeholder"), textField: cell.m_titleTextField)
            break
            
       
        default:
            break
        }
        
        cell.m_titleTextField.text=m_claimDetailsArray[indexPath.row]
        
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        
        return cell
    }
    @objc func selectDateButtonClicked(sender:UIButton)
    {
        view.endEditing(true)
        _ = Bundle.main.loadNibNamed("ProfileDatePicker", owner: self, options: nil)?[0];
        m_dateView.frame=view.frame
        view.addSubview(m_dateView)
        addBordersToComponents()
        print("selectDateButtonClicked")
    }
    func addBordersToComponents()
    {
        m_datePickerSubview.layer.borderWidth = 1
        m_datePickerSubview.layer.borderColor = UIColor.darkGray.cgColor
        m_datePickerSubview.layer.cornerRadius = 5
        
       
        
    }
   
    @objc func selectDropDown(sender : UIButton)
    {
//        setupDropDown(sender,at: sender.tag)
        dateDropDown.show()
    }
    func validateTextFields(textField:UITextField)->Int
    {
        if(textField.tag==2)
        {
            let status =  CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: textField.text!))
            if(!status)
            {
//                textField.errorMessage =  "Enter valid amount"
                return 1
            }
        }
        let whitespaceSet = CharacterSet.whitespaces
        if((textField.text?.isEmpty)! || (textField.text?.trimmingCharacters(in: whitespaceSet).isEmpty)!)
        {
            textField.textColor=UIColor.red
                if (textField.tag == 0)
                {
                    textField.text = "Select person"
                    return 1
                }
                else if(textField.tag == 1)
                {
                    textField.text =  "Enter Diagnosis/Ailment"
                    return 1
                }
                else if(textField.tag == 2)
                {
                    textField.text =  "Enter Amount"
                    return 1
                }
                else if(textField.tag == 3)
                {
                    textField.text =  "Enter DOA"
                    return 1
                }
                else if(textField.tag == 4)
                {
                    textField.text =  "Enter Hospital Name"
                    return 1
                }
                else if(textField.tag == 5)
                {
                    textField.text =  "Enter Hospital Location"
                    return 1
                }
                
           
        }
        return 0
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    func setupDropDown(_ selectButon: UITextField, at index: Int)
    {
       
        dateDropDown.anchorView = selectButon
        dateDropDown.bottomOffset = CGPoint(x: 30, y: 10)
        dateDropDown.width = view.frame.size.width-80
        
        dateDropDown.dataSource =
            m_membersArray
        
        // Action triggered on selection
        dateDropDown.selectionAction =
            {
                [unowned self] (index, item) in
//                selectButon.setTitle(item, for: .normal)
                
                self.m_claimDetailsArray[0]=item
                
                self.m_tableView.reloadData()
        }
        
    }
    @IBAction func dateCancelButtonClicked(_ sender: Any)
    {
        m_dateView.removeFromSuperview()
    }
    
    @IBAction func DateDonebuttonClicked(_ sender: Any)
    {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        //        formatter.dateFormat = "yyyy-MM-dd"
        m_selectedDate = m_datePicker.date as NSDate
        let dateString = formatter.string(from: m_datePicker.date)
        print(dateString)
        
        m_claimDetailsArray[3] = dateString
        m_tableView.reloadData()
        m_dateView.removeFromSuperview()
        
    }
    
    func setupField(textField:UITextField,with placeholder:String)
    {
        
        textField.delegate = self
        textField.textAlignment = .left
       
        
        textField.placeholder = NSLocalizedString(
            placeholder,
            tableName: "SkyFloatingLabelTextField",
            comment: ""
        )
       
       
        
        
    }
    func applySkyscannerTheme(textField: UITextField) {
        
       /* textField.tintColor = overcastBlueColor
        
        textField.textColor = darkGreyColor
        textField.lineColor = lightGreyColor
        textField.lineView .isHidden = true
        textField.selectedTitleColor = overcastBlueColor
        textField.selectedLineColor = overcastBlueColor
        //        SanFranciscoText-Regular 19.0
        // Set custom fonts for the title, placeholder and textfield labels*/
//        textField.titleLabel.font = UIFont(name: "Poppins Regular", size: 18)
//        textField.placeholderFont = UIFont(name: "Poppins Light", size: 18)
        textField.font = UIFont(name: "Poppins Regular", size: 18)
    }
    
    
    func showingTitleInAnimationComplete(_ completed: Bool) {
        // If a field is not filled out, display the highlighted title for 0.3 seco
      /*  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.showingTitleInProgress = false
            if !self.isSubmitButtonPressed {
                self.hideTitleVisibleFromFields()
            }
        }*/
    }
    func hideTitleVisibleFromFields() {
        
        for textField in textFields {
//            textField.setTitleVisible(false, animated: true)
            textField.isHighlighted = false
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if(textField.tag==0)
        {
            setupDropDown(textField,at: textField.tag)
            dateDropDown.show()
            return false
        }
        else if(textField.tag==3)
        {
//            view.endEditing(true)
            _ = Bundle.main.loadNibNamed("ProfileDatePicker", owner: self, options: nil)?[0];
            m_dateView.frame=view.frame
            view.addSubview(m_dateView)
            addBordersToComponents()
            print("selectDateButtonClicked")
            return false
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField.tag == 0)
        {
            
            let newtf = textField
//            if( ((textField.text?.length)!-1)==0)
//            {
//                newtf.errorMessage = nil
//            }
            
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if(textField.tag==0)
        {
            
            
        }
        else
        {
           
            //        newtf.errorMessage = nil
            textField.textColor=UIColor.black
            textField.text=""
            
        }
        animateTextField(textField, with: true)
        
        
        //        changePlaceholderColor(textField: textField, color: .black)
    }
    func textFieldDidChange(_ textField: UITextField)
    {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        animateTextField(textField, with: false)
        let tag = textField.tag
        let text = textField.text
        m_claimDetailsArray[tag] = text!
        print(m_claimDetailsArray)
        
        let indexPath = IndexPath(row: tag, section: 0)
        let cell = m_tableView.cellForRow(at: indexPath) as! IntimateClaimTableViewCell!
        if(tag==0)
        {
            cell?.m_titleTextField.resignFirstResponder()
        }
        else if(tag==1)
        {
            
            cell?.m_titleTextField.resignFirstResponder()
        }
        else if(tag==2)
        {
            cell?.m_titleTextField.resignFirstResponder()
        }
        else if(tag==3)
        {
            cell?.m_titleTextField.resignFirstResponder()
        }
        
        check = validateTextFields(textField: textField )
        
    }
    
    func animateTextField(_ textField:UITextField, with up: Bool)
    {
        var movementDistance=0
        let movementDuration=0.3
        if(textField.tag==0)
        {
            movementDistance=0;
        }
        else if(textField.tag==1)
        {
            movementDistance=20;
        }
        else if(textField.tag==2)
        {
            movementDistance=60;
        }
        else if(textField.tag==3)
        {
            movementDistance=100;
        }
        else if(textField.tag==4)
        {
            movementDistance=100;
        }
        else
        {
            movementDistance=245;
        }
        
        
        let movement = (up ? -movementDistance : movementDistance);
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame=self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
        
    }
    func parserDidStartDocument(_ parser: XMLParser)
    {
        resultsDictArray = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        
        if elementName == xmlKey
        {
            currentDictionary = [String : String]()
        }
        else if dictionaryKeys.contains(elementName)
        {
            self.currentValue = String()
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        self.currentValue += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == xmlKey
        {
            resultsDictArray?.append(currentDictionary!)
            self.currentDictionary = [:]
            
        }
        else if dictionaryKeys.contains(elementName)
        {
            self.currentDictionary![elementName] = currentValue
            self.currentValue = ""
            
        }
        
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        
        
    }
    
    @IBAction func intimatedClaimSelected(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }

}
