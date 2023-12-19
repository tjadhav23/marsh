//
//  NetworkHospitalsViewController.swift
//  MyBenefits
//
//  Created by Semantic on 18/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import FirebaseCrashlytics
import TrustKit
import AesEverywhere

struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IS_IPHONE_XsMax     = IS_IPHONE && SCREEN_MAX_LENGTH > 812
    
}
extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count && self.characters.count == 10
            } else {
                return false
            }
        } catch
        {
            Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
            return false
        }
    }
}
struct State {
    let address: String
    let long: CLLocationDegrees
    let lat: CLLocationDegrees
}
class NetworkHospitalsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate,XMLParserDelegate,UITextFieldDelegate,UITextViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate {
    @IBOutlet weak var m_mapViewforNearbyLOcations: UIView!
    @IBOutlet weak var m_emptyStateImageView: UIImageView!
    
    @IBOutlet weak var m_noInternetView: UIView!
    @IBOutlet weak var m_tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var m_tableViewTopConsraint: NSLayoutConstraint!
    
    @IBOutlet weak var m_orLbl: UILabel!
    @IBOutlet weak var serachNearbyButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var TopHeaderBackgroundView: UIView!
    
    @IBOutlet weak var m_tableVIewConstraintWithSuperview: NSLayoutConstraint!
    @IBOutlet weak var m_searchTableBottomConstraintToNearbyButton: NSLayoutConstraint!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var topNoInternetVew: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var m_searchBar: UISearchBar!
    @IBOutlet weak var m_tableViewTopConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var m_nearbyHospitalsButton: UIButton!
    @IBOutlet weak var m_SMSAddressSubView: NetworkHospitalsTableViewCell!
    @IBOutlet weak var m_topBarVerticalSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet var m_SMSView: UIView!
    @IBOutlet weak var m_SMSAddressTextView: UITextView!
    
    @IBOutlet weak var m_searchTableview: UITableView!
    
    @IBOutlet weak var m_tableview: UITableView!
    
    @IBOutlet weak var noOFHospitalHeader: UILabel!
    @IBOutlet weak var m_noofHospitalsCountLbl: UILabel!
    
    @IBOutlet weak var m_primeryCountLbl: UILabel!
    @IBOutlet weak var primaryHeader: UILabel!
    
    @IBOutlet weak var secondaryHeader: UILabel!
    @IBOutlet weak var m_secondaryCountLbl: UILabel!
    
    @IBOutlet weak var tertiaryHeader: UILabel!
    @IBOutlet weak var m_tertiaryCountLbl: UILabel!
    
    @IBOutlet weak var m_emptyStateDetailsLbl: UILabel!
    @IBOutlet weak var m_emptyStateTitleLbl: UILabel!
    
    @IBOutlet weak var m_emptyStateTitleLbl_Height: NSLayoutConstraint!
    
    let reuseIdentifier = "cell"
    var m_productCode = String()
    var m_resultDict = NSDictionary()
    var xmlKey = String()
    let dictionaryKeys = ["HOSP_NAME", "HOSP_ADDRESS", "HOSP_PHONE_NO", "HOSP_LEVEL_OF_CARE","HospitalName","HospitalAddress","HospitalContactNo","HospitalLevelOfCare","TopupSumInsuredVal","V_COUNT","Latitude","Longitude"]
    var resultsDictArray = [[String: String]]()
    var allResultsDictArray = [[String: String]]()
    var resultsDictArrayNew = [[String: String]]()
    var m_nearbyHospitalsArrayNew = [[String: String]]()
    var distanceArray = [String]()
    var limit = 2
    var searchHospitalsDictArray = [[String: String]]()
    
    var primaryResultsDictArray = [[String: String]]()
    var secondaryResultsDictArray = [[String: String]]()
    var tertiaryResultsDictArray = [[String: String]]()
    var otherResultsDictArray = [[String: String]]()
    // the whole array of dictionaries
    var currentDictionary: [String: String]? // the current dictionary
    var currentValue = String()
    var m_employeedict : EMPLOYEE_INFORMATION?
    var isfromSearchString = Bool()
    let menuController = UIMenuController.shared
    var m_primaryArray = [NSDictionary]()
    var m_seconadryArray = [NSDictionary]()
    var m_tertiaryArray = [NSDictionary]()
    var m_otherArray = [NSDictionary]()
    
    var locationManager: CLLocationManager!
    var m_addressString = String()
    var apiFlag = false
    var m_subLocality = String()
    var m_nearbyHospitalsArray = [[String: String]]()
    var isSearchNearby = false
    
    //    var placePicker: GMSPlacePicker!
    var latitude: Double! = 0.0
    var longitude: Double! = 0.0
    var isFromSideBar = Bool()
    var isFirstTime = false
    var isNearBy = false
    var hospDetailsArray = Array<NetworkHospitalsDetails>()
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var selectedIndexPath = 0
    static var cnt = 0
    @IBOutlet weak var hospitalActivityIndicator: UIActivityIndicatorView!
    
    var primaryClicked = false
    var secondaryClicked = false
    var tertiaryClicked = false
    var otherClicked = false
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setFontUI()
//        spinner.color = UIColor.darkGray
//        spinner.hidesWhenStopped = true
//        m_tableview.tableFooterView = spinner
        
        userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
        userOegrpNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String ?? ""
        getEnrollStatus("GMC", 0, userOegrpNoGMC)
        print(m_windowPeriodStatus)
        
        m_tableview.register(NetworkHospitalsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        m_tableview.register(UINib (nibName: "NetworkHospitalsTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        m_searchTableview.register(SearchTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        m_searchTableview.register(UINib (nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        if CLLocationManager.locationServicesEnabled()
        {
           
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            //Default search to All
            m_addressString = "All"
            if(m_addressString=="")
            {
                //            showPleaseWait(msg: """
                //Please wait...
                //Fetching your current location
                //""")
            }
        }
        
        
        TopHeaderBackgroundView.isHidden=true
        m_nearbyHospitalsButton.isHidden=false
        m_tableview.isHidden=true
        m_searchBar.isHidden=true
        //btnClose.dropShadow()
        btnClose.layer.cornerRadius = cornerRadiusForView
        btnClose.layer.borderWidth = 1
        btnClose.layer.borderColor = UIColor.lightGray.cgColor
        btnClose.isHidden = true
        
        m_orLbl.isHidden=true
        m_searchBar.layer.borderWidth = 1
        m_searchBar.layer.borderColor = UIColor.lightGray.cgColor
        m_searchBar.backgroundImage=UIImage()
        m_searchBar.layer.masksToBounds=true
        m_searchBar.backgroundColor = UIColor.white
        
        //       m_searchBar.dropShadow()
        //m_searchBar.layer.cornerRadius=m_searchBar.frame.size.height/2
        m_searchBar.layer.cornerRadius=cornerRadiusForView//8
        if #available(iOS 13.0, *) {
            m_searchBar.searchTextField.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        m_tableview.contentInset = UIEdgeInsets.zero
        self.tabBarController?.tabBar.isHidden=false
        menuButton.isHidden=false
        self.m_tableview.estimatedRowHeight = 800.0;
        self.m_tableview.rowHeight = UITableViewAutomaticDimension;
        
        self.m_tableview.setNeedsLayout()
        self.m_tableview.layoutIfNeeded()
        
        self.m_searchTableview.tableFooterView=UIView()
        
        m_searchTableview.frame = CGRect(x: m_searchTableview.frame.origin.x, y: m_searchTableview.frame.origin.y, width: m_searchTableview.frame.size.width, height: m_searchTableview.contentSize.height)
        m_tableview.keyboardDismissMode = .interactive
        m_tableview.keyboardDismissMode = .onDrag
        shadowForCell(view: m_searchTableview)
        
        isSearchNearby=true
        print("VDL=",m_addressString)
        isFirstTime = true
      //  if apiFlag == true{
            //getPostHospitalDetails(searchString: m_addressString)
      
                print("globalHospitalList:::::",globalHospitalList)
                            if globalHospitalList.count > 0{
                                self.resultsDictArray = globalHospitalList
                                var index  = 0
                                while index < self.limit && index < self.resultsDictArray.count {
                                    //if index != cnt {
                                     self.resultsDictArrayNew.append(self.resultsDictArray[index])//append from main array
                                        index = index + 1
                                    //}
                                }
                
                                self.calculateDistance()
                                self.distancestring()
                
                
                                self.searchHospitalsDictArray = self.resultsDictArray
                                DispatchQueue.main.async
                                    {
                                        print(self.resultsDictArray)
                
                                        let sortDescriptor = NSSortDescriptor(key: "HospitalName", ascending: true)
                                        self.resultsDictArray = self.resultsDictArray.sorted {
                                            guard let s1 = $0["HOSP_NAME"], let s2 = $1["HOSP_NAME"] else {
                                                return false
                                            }
                
                                            if s1 == s2 {
                                                guard let g1 = $0["given"], let g2 = $1["given"] else {
                                                    return false
                                                }
                                                return g1 < g2
                                            }
                
                                            return s1 < s2
                                        }
                                        let count:Int = (self.resultsDictArray.count)
                                        if(count>0) {
                                            //self.TopHeaderBackgroundView.isHidden=false
                                            //self.m_nearbyHospitalsButton.isHidden=false
                                            self.serachNearbyButtonTopConstraint.constant=20
                                            self.m_tableview.isHidden=false
                                            //commented by Pranit
                                            //self.m_searchBar.isHidden=true
                
                                            //Added By Pranit
                                            if self.isSearchNearby {
                                                self.m_searchBar.isHidden=true
                                            }
                                            self.m_nearbyHospitalsButton.isHidden=true
                                            self.m_orLbl.isHidden=true
                                            self.m_tableViewTopConstraint.constant=25
                
                                            let countString : NSNumber =  self.resultsDictArray.count as! NSNumber
                                            self.m_noofHospitalsCountLbl.text=countString.stringValue
                                            self.getCount()
                                             self.m_tableview.reloadData()
                
                                        }
                                        else
                                        {
                                            self.m_noInternetView.isHidden=false
                                            self.m_emptyStateImageView.isHidden=false
                                            self.m_emptyStateTitleLbl.isHidden=false
                                            self.m_emptyStateDetailsLbl.isHidden=false
                                            self.topNoInternetVew.constant = 20
                                            if m_windowPeriodStatus{
                                                self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                                self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                            }else{
                                                self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                                self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                                self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                            }
                                            self.TopHeaderBackgroundView.isHidden=true
                                            self.m_nearbyHospitalsButton.isHidden=true
                                            //self.serachNearbyButtonTopConstraint.constant=50
                                            self.m_tableview.isHidden=true
                                            self.m_tableview.reloadData()
                                        }
                
                                        self.hidePleaseWait()
                
                                }
                                       DispatchQueue.main.async {
                                           self.hospitalActivityIndicator.stopAnimating()
                                           self.hospitalActivityIndicator.isHidden = true
                                       }
                
                
                            }else{
                                //getPostHospitalDetailsPortal(searchString: m_addressString)
                                getPostHospitalDetailsPortalJson(searchString: m_addressString)
                            }
               // apiFlag = false
            
        //}
        m_tableVIewConstraintWithSuperview.constant=0
        
    }
    
    func setFontUI(){
        if #available(iOS 13.0, *) {
            m_searchBar.searchTextField.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h14))
        } else {
            // Fallback on earlier versions
        }
        
        noOFHospitalHeader.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        noOFHospitalHeader.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_noofHospitalsCountLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        m_noofHospitalsCountLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        m_primeryCountLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        m_primeryCountLbl.textColor = FontsConstant.shared.app_FontSecondryColor
        
        primaryHeader.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        primaryHeader.textColor = FontsConstant.shared.app_FontSecondryColor
       
        secondaryHeader.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        secondaryHeader.textColor = FontsConstant.shared.app_FontSecondryColor
       
        tertiaryHeader.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h15))
        tertiaryHeader.textColor = FontsConstant.shared.app_FontSecondryColor
       
     
        m_emptyStateDetailsLbl.font = UIFont(name: FontsConstant.shared.OpenSansRegular, size: CGFloat(FontsConstant.shared.h12))
        m_emptyStateDetailsLbl.textColor = FontsConstant.shared.app_errorTitleColor
       
        m_emptyStateTitleLbl.font = UIFont(name: FontsConstant.shared.OpenSansSemiBold, size: CGFloat(FontsConstant.shared.h14))
        m_emptyStateTitleLbl.textColor = FontsConstant.shared.app_errorTitleColor
       
    }
    
    override func viewWillLayoutSubviews()
    {
        //        m_tableViewHeightConstraint.constant=m_tableview.contentSize.height
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
        
        isfromSearchString = true
        
        m_nearbyHospitalsButton.layer.masksToBounds=true
        m_nearbyHospitalsButton.layer.cornerRadius=20
        shadowForCell(view: TopHeaderBackgroundView)
        
        if(m_tableview.isHidden)
        {
            self.serachNearbyButtonTopConstraint.constant=30
            m_searchBar.isHidden=true
            btnClose.isHidden=true
            m_orLbl.isHidden=false
            m_tableViewTopConstraint.constant=65
        }
        else
        {
            self.serachNearbyButtonTopConstraint.constant=180
            m_searchBar.isHidden=true
            btnClose.isHidden=true
            m_orLbl.isHidden=true
            m_tableVIewConstraintWithSuperview.constant=0
        }
        
        //        getHospitalDetails(searchString: m_addressString)
        //        showLocationsOnMap()
        m_mapViewforNearbyLOcations.isHidden=true
        
        //hidePleaseWait()
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        if self.locationManager != nil {
        self.locationManager.stopUpdatingLocation()
        }
    }
    func showLocationsOnMap()
    {
        showPleaseWait(msg: "Please wait...")
        
        let lat = CLLocationDegrees()
        let lon = CLLocationDegrees()
        
        
        let geocoder = CLGeocoder()
        
        for dict in m_nearbyHospitalsArray
        {
            if let address = dict["HospitalAddress"]
            {
                geocoder.geocodeAddressString(address)
                {
                    
                    placemarks, error in
                    let placemark = placemarks?.first
                    
                    let lat = placemark?.location?.coordinate.latitude
                    let lon = placemark?.location?.coordinate.longitude
                    
                    let states = [
                        State(address: address, long:lon!, lat: lat!)]
                }
            }
        }
        
        if(lat != nil || lon != nil)
        {
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            m_mapViewforNearbyLOcations = mapView
            
            // Creates a marker in the center of the map.
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            marker.title = self.m_resultDict["HospitalName"] as? String
            // placemark?.subAdministrativeArea
            //                marker.snippet = address as? String
            marker.map = mapView
            
            /* let regionDistance : CLLocationDistance = 1000
             let cordinates = CLLocationCoordinate2DMake(lat!, lon!)
             let reginspan = MKCoordinateRegionMakeWithDistance(cordinates, regionDistance, regionDistance)
             let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: reginspan.center),
             MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: reginspan.span)]
             
             let placemarks = MKPlacemark(coordinate: cordinates, addressDictionary: nil)
             let mapItem = MKMapItem(placemark: placemarks )
             mapItem.name = address as? String
             mapItem.openInMaps(launchOptions: options)*/
            
            //                self.mapNotFoundImageView.isHidden=true
            
            
        }
        else
        {
            //                self.mapNotFoundImageView.isHidden=false
            
            //                        self.displayActivityAlert(title: "Address not found")
            
            
            
            //                    let camera = GMSCameraPosition.camera(withLatitude: 20.5937, longitude: 78.9629, zoom: 15.0)
            //                    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            //                    self.view = mapView
            //
            //                    // Creates a marker in the center of the map.
            //                    let marker = GMSMarker()
            //                    marker.position = CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)
            //                    marker.title = address as? String
            //                    marker.snippet = placemark?.subAdministrativeArea
            //                    marker.map = mapView
            //
            
            //            }
            //            self.hidePleaseWait()
        }
    }
    override func viewDidLayoutSubviews()
    {
        m_searchTableview.frame = CGRect(x: m_searchTableview.frame.origin.x, y: m_searchTableview.frame.origin.y, width: m_searchTableview.frame.size.width, height: m_searchTableview.contentSize.height)
        shadowForCell(view: m_searchTableview)
        m_searchTableview.reloadData()
    }
    override func rightButtonClicked()
    {
            m_noInternetView.isHidden=true
            m_searchBar.isHidden=false
            btnClose.isHidden = false
            m_searchBar.delegate = self
            m_searchBar.text=""
            m_searchBar.becomeFirstResponder()
            m_tableVIewConstraintWithSuperview.constant=80
            m_orLbl.isHidden=false
            
            if(resultsDictArray.count==0)
            {
                m_nearbyHospitalsButton.isHidden=false
                m_noInternetView.isHidden=false
            }
            else
            {
                m_nearbyHospitalsButton.isHidden=true
            }
        
    }
    func updateSearchResults(for searchController: UISearchController)
    {
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden=false
        
        
        setData()
        
    }
    func setData()
    {
        m_productCode = "GMC"
        self.navigationItem.title="link5Name".localized()
        
        var hospitalCount = UserDefaults.standard.value(forKey: "hospitalCountData") as? Int ?? 0
        print("hospitalCount from user default: ",hospitalCount," .")
        if hospitalCount == 0{
            navigationItem.rightBarButtonItem = nil
        }
        else{
            navigationItem.rightBarButtonItem=getRightButton()
        }
        
        navigationController?.isNavigationBarHidden=false
        navigationItem.leftBarButtonItem=getBackButton()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [hexStringToUIColor(hex: hightlightColor),hexStringToUIColor(hex: gradiantColor2)])
        navigationController?.navigationBar.dropShadow()
        
        m_tableview.separatorStyle=UITableViewCellSeparatorStyle.none
        
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        //        menuButton.backgroundColor = UIColor.white
        //        menuButton.setBackgroundImage(UIImage(named: ""), for: .normal)
        //        menuButton.setImage(UIImage(named:"Home"), for: .normal)
    }
    
    @objc private func homeButtonClicked(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        //        let dashboard :NewDashboardViewController = NewDashboardViewController()
        //        navigationController?.popToViewController(dashboard, animated: true)
        //        tabBarController!.selectedIndex = 2
    }
    @objc override func backButtonClicked()
    {
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    func setupTabbar()
    {
        let tabBarController = UITabBarController()
        
        let tabViewController1 = ContactDetailsViewController(
            nibName: "ContactDetailsViewController",
            bundle: nil)
        let tabViewController2 = NewDashboardViewController(
            nibName:"NewDashboardViewController",
            bundle: nil)
        let tabViewController3 = NewDashboardViewController(
            nibName: "NewDashboardViewController",
            bundle: nil)
        let tabViewController4 = UtilitiesViewController(
            nibName:"UtilitiesViewController",
            bundle: nil)
        let tabViewController5 = LeftSideViewController(
            nibName:"LeftSideViewController",
            bundle: nil)
        
        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
        
        
        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
        tabBarController.viewControllers = controllers as? [UIViewController]
        
        nav1.tabBarItem = UITabBarItem(
            title: "Contact",
            image: UIImage(named: "call-1"),
            tag: 1)
        nav2.tabBarItem = UITabBarItem(
            title: "E-card",
            image:UIImage(named: "ecard1") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Utilities",
            image:UIImage(named: "utilities") ,
            tag:2)
        
        nav5.tabBarItem = UITabBarItem(
            title: "More",
            image:UIImage(named: "profile") ,
            tag:2)
        
        let leftSideView = LeftSideViewController(
            nibName: "LeftSideViewController",
            bundle: nil)
        let leftSideMenuNav = UINavigationController(rootViewController: leftSideView)
        
        
        
        let dashboard :NewDashboardViewController = NewDashboardViewController()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        //        appdelegate.drawerContainer = MMDrawerController(center: tabBarController, leftDrawerViewController: leftSideMenuNav)
        
        
        
        tabBarController.selectedIndex=2
        
        
    }
    func getRightButton() -> UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(rightButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func primaryCountButtonClicked(sender:UIButton)
    {

        self.hospitalActivityIndicator.startAnimating()
        self.hospitalActivityIndicator.isHidden = false
        self.m_tableview.isScrollEnabled = false
        
        isNearBy = false
        primaryResultsDictArray.removeAll()
        
        resultsDictArray = searchHospitalsDictArray
        
        if primaryClicked{
            primaryResultsDictArray = resultsDictArray
            
            primaryClicked = false
            secondaryClicked = false
            tertiaryClicked = false
            otherClicked = false
            print("primaryResultsDictArray true if ",primaryResultsDictArray.count)
        }
        else{
            for dictionary in resultsDictArray
            {
                let dict : NSDictionary = dictionary as NSDictionary
                let level = dict.value(forKey: "HOSP_LEVEL_OF_CARE") as? String
                if(level=="Primary")
                {
                    primaryResultsDictArray.append(dict as! [String : String])
                }
            }
            
            primaryClicked = true
            secondaryClicked = false
            tertiaryClicked = false
            otherClicked = false
            print("primaryResultsDictArray false else ",primaryResultsDictArray.count)
        }
       
        resultsDictArray = primaryResultsDictArray
        print(primaryResultsDictArray)
        print("resultsDictArrayNew: ",resultsDictArrayNew)
        if resultsDictArray.isEmpty{
            self.m_noInternetView.isHidden=false
            self.m_emptyStateImageView.isHidden=false
            self.m_emptyStateTitleLbl.isHidden=false
            self.m_emptyStateDetailsLbl.isHidden=false
            self.topNoInternetVew.constant = 180
            //self.m_emptyStateTitleLbl_Height.constant = 0
            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
            //if total count is 0 and button click is zero then show During_PostEnrollment_Header_HospitalErrorMsg
            if self.searchHospitalsDictArray.count == 0 && self.resultsDictArrayNew.count == 0{
                self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
            }
            else{
                self.m_emptyStateTitleLbl.text = "Provider Network details are not available for this category."
            }
            
            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
            
            self.TopHeaderBackgroundView.isHidden=false
            self.m_nearbyHospitalsButton.isHidden=true
            self.m_tableview.isHidden=false
            
            spinner.stopAnimating()
            spinner.isHidden = true
            
        }else{
            self.m_noInternetView.isHidden=true
            self.m_emptyStateImageView.isHidden=true
            self.m_emptyStateTitleLbl.isHidden=true
            self.m_emptyStateDetailsLbl.isHidden=true
            self.m_tableview.isHidden=false
        }
       
        m_tableview.reloadData()
        m_searchTableview.reloadData()
       
        //spinner.stopAnimating()
        
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
        let cell1 = m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
        if primaryClicked{
            cell1.m_primaryCountButton.backgroundColor = FontsConstant.shared.HosptailBtnBG
        }
        else{
            cell1.m_primaryCountButton.backgroundColor = UIColor.white
        }
        cell1.m_secondaryCountButton.backgroundColor = UIColor.white
        cell1.m_tertiaryCountButton.backgroundColor = UIColor.white
        cell1.m_OtherCountButton.backgroundColor = UIColor.white
        
        self.hospitalActivityIndicator.stopAnimating()
        self.hospitalActivityIndicator.isHidden = true
        self.m_tableview.isScrollEnabled = true
    }
    @objc func secondaryCountButtonClicked(sender:UIButton)
    {
        self.hospitalActivityIndicator.startAnimating()
        self.hospitalActivityIndicator.isHidden = false
        self.m_tableview.isScrollEnabled = false
        
        isNearBy = false
        secondaryResultsDictArray.removeAll()
        print(resultsDictArray)
        resultsDictArray = searchHospitalsDictArray
       
        if secondaryClicked{
            secondaryResultsDictArray = resultsDictArray
            
            primaryClicked = false
            secondaryClicked = false
            tertiaryClicked = false
            otherClicked = false
            print("secondaryResultsDictArray true if ",secondaryResultsDictArray.count)
        }
        else{
            for dictionary in resultsDictArray
            {
                let dict : NSDictionary = dictionary as NSDictionary
                let level = dict.value(forKey: "HOSP_LEVEL_OF_CARE") as? String
                if(level=="Secondary")
                {
                    secondaryResultsDictArray.append(dict as! [String : String])
                }
            }
            
            primaryClicked = false
            secondaryClicked = true
            tertiaryClicked = false
            otherClicked = false
            print("secondaryResultsDictArray false else ",secondaryResultsDictArray.count)
        }
       
        
        resultsDictArray = secondaryResultsDictArray
        print(resultsDictArray)
        print("resultsDictArrayNew: ",resultsDictArrayNew)
        if resultsDictArray.isEmpty{
            self.topNoInternetVew.constant = 180
            self.m_noInternetView.isHidden=false
            self.m_emptyStateImageView.isHidden=false
            self.m_emptyStateTitleLbl.isHidden=false
            self.m_emptyStateDetailsLbl.isHidden=false
            //self.m_emptyStateTitleLbl_Height.constant = 0

            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
            //if total count is 0 and button click is zero then show During_PostEnrollment_Header_HospitalErrorMsg
            if self.searchHospitalsDictArray.count == 0 && self.resultsDictArrayNew.count == 0{
                self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
            }
            else{
                self.m_emptyStateTitleLbl.text = "Provider Network details are not available for this category."
            }
            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
            
            self.TopHeaderBackgroundView.isHidden=false
            self.m_nearbyHospitalsButton.isHidden=true
            self.m_tableview.isHidden=false
            
        }else{
            self.m_noInternetView.isHidden=true
            self.m_emptyStateImageView.isHidden=true
            self.m_emptyStateTitleLbl.isHidden=true
            self.m_emptyStateDetailsLbl.isHidden=true
            self.m_tableview.isHidden=false
        }
       
        m_tableview.reloadData()
        m_searchTableview.reloadData()
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
        let cell1 = m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
        cell1.m_primaryCountButton.backgroundColor = UIColor.white
        
        if secondaryClicked{
            cell1.m_secondaryCountButton.backgroundColor = FontsConstant.shared.HosptailBtnBG
        }
        else{
            cell1.m_secondaryCountButton.backgroundColor = UIColor.white
        }
        cell1.m_tertiaryCountButton.backgroundColor = UIColor.white
        cell1.m_OtherCountButton.backgroundColor = UIColor.white
        
        
        self.hospitalActivityIndicator.stopAnimating()
        self.hospitalActivityIndicator.isHidden = true
        self.m_tableview.isScrollEnabled = true
        
    }
    @objc func tertiaryCountButtonClicked(sender:UIButton)
    {
        self.hospitalActivityIndicator.startAnimating()
        self.hospitalActivityIndicator.isHidden = false
        self.m_tableview.isScrollEnabled = false
        
        let indexpath = IndexPath(row: sender.tag, section: 0)
        isNearBy = false
        
        let cell = m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
        
        tertiaryResultsDictArray.removeAll()
        m_tableview.reloadData()
        resultsDictArray = searchHospitalsDictArray
        
        if tertiaryClicked{
            tertiaryResultsDictArray = resultsDictArray
            
            primaryClicked = false
            secondaryClicked = false
            tertiaryClicked = false
            otherClicked = false
            print("tertiaryResultsDictArray true if ",tertiaryResultsDictArray.count)
        }
        else{
            for dictionary in resultsDictArray
            {
                let dict : NSDictionary = dictionary as NSDictionary
                let level = dict.value(forKey: "HOSP_LEVEL_OF_CARE") as? String
                if(level=="Tertiary")
                {
                    tertiaryResultsDictArray.append(dict as! [String : String])
                }
            }
            
            primaryClicked = false
            secondaryClicked = false
            tertiaryClicked = true
            otherClicked = false
            print("tertiaryResultsDictArray false else ",tertiaryResultsDictArray.count)
        }

        resultsDictArray = tertiaryResultsDictArray
        
        if resultsDictArray.isEmpty{
            self.topNoInternetVew.constant = 180
            self.m_noInternetView.isHidden=false
            self.m_emptyStateImageView.isHidden=false
            self.m_emptyStateTitleLbl.isHidden=false
            self.m_emptyStateDetailsLbl.isHidden=false
            
            //self.m_emptyStateTitleLbl_Height.constant = 0

            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
            //if total count is 0 and button click is zero then show During_PostEnrollment_Header_HospitalErrorMsg
            if self.searchHospitalsDictArray.count == 0 && self.resultsDictArrayNew.count == 0{
                self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
            }
            else{
                self.m_emptyStateTitleLbl.text = "Provider Network details are not available for this category."
            }
            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
            
            self.TopHeaderBackgroundView.isHidden=false
            self.m_nearbyHospitalsButton.isHidden=true
            self.m_tableview.isHidden=false
            
        }else{
            self.m_noInternetView.isHidden=true
            self.m_emptyStateImageView.isHidden=true
            self.m_emptyStateTitleLbl.isHidden=true
            self.m_emptyStateDetailsLbl.isHidden=true
            self.m_tableview.isHidden=false
        }
      
        m_tableview.reloadData()
        m_searchTableview.reloadData()
        let cell1 = m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
        cell1.m_primaryCountButton.backgroundColor = UIColor.white
        cell1.m_secondaryCountButton.backgroundColor = UIColor.white
        
        if tertiaryClicked{
            cell1.m_tertiaryCountButton.backgroundColor = FontsConstant.shared.HosptailBtnBG
        }
        else{
            cell1.m_tertiaryCountButton.backgroundColor = UIColor.white
        }
        
        cell1.m_OtherCountButton.backgroundColor = UIColor.white
        
        self.hospitalActivityIndicator.stopAnimating()
        self.hospitalActivityIndicator.isHidden = true
        self.m_tableview.isScrollEnabled = true
    }
  
    @objc func otherCountButtonClicked(sender:UIButton)
    {
        self.hospitalActivityIndicator.startAnimating()
        self.hospitalActivityIndicator.isHidden = false
        self.m_tableview.isScrollEnabled = false
        
        let indexpath = IndexPath(row: sender.tag, section: 0)
        isNearBy = false
        
        let cell = m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
       
        otherResultsDictArray.removeAll()
        
        m_tableview.reloadData()
        resultsDictArray = searchHospitalsDictArray
      
        if otherClicked{
            otherResultsDictArray = resultsDictArray
            otherClicked = false
            secondaryClicked = false
            primaryClicked = false
            tertiaryClicked = false
            print("otherResultsDictArray true if ",otherResultsDictArray.count)
        }
        else{
            for dictionary in resultsDictArray
            {
               
                let dict : NSDictionary = dictionary as NSDictionary
                
                let level = dict.value(forKey: "HOSP_LEVEL_OF_CARE") as? String
                if(level != "Primary" && level != "Secondary" && level != "Tertiary")
                {
                    otherResultsDictArray.append(dict as! [String : String])
                }
            }
            otherClicked = true
            tertiaryClicked = false
            secondaryClicked = false
            primaryClicked = false
            print("otherResultsDictArray false else ",otherResultsDictArray.count)
        }
        
        
        
        print("otherResultsDictArray",otherResultsDictArray)
   
        resultsDictArray = otherResultsDictArray
        
        if resultsDictArray.isEmpty{
            self.topNoInternetVew.constant = 180
            self.m_noInternetView.isHidden=false
            self.m_emptyStateImageView.isHidden=false
            self.m_emptyStateTitleLbl.isHidden=false
            self.m_emptyStateDetailsLbl.isHidden=false
            
            //self.m_emptyStateTitleLbl_Height.constant = 0

            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
            //if total count is 0 and button click is zero then show During_PostEnrollment_Header_HospitalErrorMsg
            if self.searchHospitalsDictArray.count == 0 && self.resultsDictArrayNew.count == 0{
                self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
            }
            else{
                self.m_emptyStateTitleLbl.text = "Provider Network details are not available for this category."
            }
            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
            
            self.TopHeaderBackgroundView.isHidden=false
            self.m_nearbyHospitalsButton.isHidden=true
            self.m_tableview.isHidden=false
            
        }else{
            self.m_noInternetView.isHidden=true
            self.m_emptyStateImageView.isHidden=true
            self.m_emptyStateTitleLbl.isHidden=true
            self.m_emptyStateDetailsLbl.isHidden=true
            self.m_tableview.isHidden=false
        }
        DispatchQueue.main.async {
            self.hospitalActivityIndicator.stopAnimating()
            self.hospitalActivityIndicator.isHidden = true
        }
        m_tableview.reloadData()
        m_searchTableview.reloadData()
        
        print("otherResultsDictArray: ",otherResultsDictArray)
        m_tableview.reloadData()
        let cell1 = m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
        cell1.m_primaryCountButton.backgroundColor = UIColor.white
        cell1.m_secondaryCountButton.backgroundColor = UIColor.white
        cell1.m_tertiaryCountButton.backgroundColor = UIColor.white
        
        if otherClicked{
            cell1.m_OtherCountButton.backgroundColor = FontsConstant.shared.HosptailBtnBG
        }
        else{
            cell1.m_OtherCountButton.backgroundColor = UIColor.white
        }
        
        self.hospitalActivityIndicator.stopAnimating()
        self.hospitalActivityIndicator.isHidden = true
        self.m_tableview.isScrollEnabled = true
    }
  
    
    
    //MARK:- Get Hospitals
    func getPostHospitalDetails(searchString:String)
    {
        if(isConnectedToNetWithAlert())
        {
            if(searchString != "")
            {
                self.hospitalActivityIndicator.startAnimating()
                self.hospitalActivityIndicator.isHidden = false
                let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
                m_employeedict=userArray[0]
                
                var oegrpbasinfsrno = String()
                var groupChildSrNo = String()
                
                if let empNo = m_employeedict?.oe_group_base_Info_Sr_No{
                    oegrpbasinfsrno = String(empNo)
                }
                if let groupChlNo = m_employeedict?.groupChildSrNo{
                    groupChildSrNo=String(groupChlNo)
                }
                
                           var string = ""
                           let allStr = "All"
                        if isFirstTime{
                             string = "<DataRequest><groupchildsrno>\(groupChildSrNo)</groupchildsrno><oegrpbasinfsrno>\(oegrpbasinfsrno)</oegrpbasinfsrno><hospitalsearchtext>\(allStr)</hospitalsearchtext></DataRequest>"
                            isFirstTime = false
                        }else{
                             string = "<DataRequest><groupchildsrno>\(groupChildSrNo)</groupchildsrno><oegrpbasinfsrno>\(oegrpbasinfsrno)</oegrpbasinfsrno><hospitalsearchtext>\(searchString)</hospitalsearchtext></DataRequest>"
                           //  string = "<DataRequest><groupchildsrno>\(groupChildSrNo)</groupchildsrno><oegrpbasinfsrno>\(oegrpbasinfsrno)</oegrpbasinfsrno><hospitalsearchtext>418016</hospitalsearchtext></DataRequest>"
                        }
                
                
                let uploadData = string.data(using: .utf8)
                
                let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getHospitalDetailsPostUrl() as String)
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?// NSURL(string: urlreq)
                request.httpMethod = "POST"
                request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
                
                request.httpBody=uploadData
                print("NW URL : \(urlreq) \n param : \(string)")
                let session = URLSession(configuration: .default)
                resultsDictArray.removeAll()
                resultsDictArrayNew.removeAll()
                self.m_nearbyHospitalsArray.removeAll()
                self.distanceArray.removeAll()
                
                let task = session.dataTask(with: request as URLRequest)
                { (data, response, error) -> Void in
                    if error != nil
                    {
                        print("error ",error!)
                        self.hidePleaseWait()
                        self.displayActivityAlert(title: m_errorMsg)

                        DispatchQueue.main.async {
                            self.hospitalActivityIndicator.stopAnimating()
                            self.hospitalActivityIndicator.isHidden = true
                        }
                    }
                    else
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            if httpResponse.statusCode == 200
                            {
                               
                                
                                self.xmlKey = "HospitalInformation"
                                let parser = XMLParser(data: data!)
                                parser.delegate = self as? XMLParserDelegate
                                parser.parse()
                                if(self.isSearchNearby)
                                {
                                    self.m_nearbyHospitalsArray=[]
                                    
                                    //Added by geeta
                                       if self.resultsDictArray.count > 0 {
                                           //var cnt = self.resultsDictArray.count
                                           
                                           var index  = 0
                                           while index < self.limit && index < self.resultsDictArray.count {
                                               //if index != cnt {
                                                self.resultsDictArrayNew.append(self.resultsDictArray[index])//append from main array
                                                   index = index + 1
                                               //}
                                           }
                                           
                                       }
                                    
                                    /* for dict in  self.resultsDictArray {
                                     let address = dict["HospitalAddress"]
                                     print(address!,self.m_subLocality)
                                     print("addressString\(self.m_addressString)")
                                     let subLocality = self.m_subLocality.uppercased()
                                     let addr = self.m_addressString.uppercased()
                                     if(address?.contains(addr))!{
                                        self.m_nearbyHospitalsArray.append(dict)
                                     }
                                     }*/
                                    self.calculateDistance()
                                    self.distancestring()
                                    
                                    
                                    print(self.m_nearbyHospitalsArray,self.m_nearbyHospitalsArray.count)
                                    
                                    //self.showLocationsOnMap()
//                                    if(!self.m_nearbyHospitalsArray.contains([:])) {
//                                        self.resultsDictArray=self.m_nearbyHospitalsArray
//                                    }
                                    
                                }
                                self.searchHospitalsDictArray = self.resultsDictArray
                                DispatchQueue.main.async
                                    {
                                        print(self.resultsDictArray)
                                        
                                        let sortDescriptor = NSSortDescriptor(key: "HospitalName", ascending: true)
                                        self.resultsDictArray = self.resultsDictArray.sorted {
                                            guard let s1 = $0["HospitalName"], let s2 = $1["HospitalName"] else {
                                                return false
                                            }
                                            
                                            if s1 == s2 {
                                                guard let g1 = $0["given"], let g2 = $1["given"] else {
                                                    return false
                                                }
                                                return g1 < g2
                                            }
                                            
                                            return s1 < s2
                                        }
                                        let count:Int = (self.resultsDictArray.count)
                                        if(count>0) {
                                            //self.TopHeaderBackgroundView.isHidden=false
                                            //self.m_nearbyHospitalsButton.isHidden=false
                                            self.serachNearbyButtonTopConstraint.constant=20
                                            self.m_tableview.isHidden=false
                                            //commented by Pranit
                                            //self.m_searchBar.isHidden=true
                                            
                                            //Added By Pranit
                                            if self.isSearchNearby {
                                                self.m_searchBar.isHidden=true
                                            }
                                            self.m_nearbyHospitalsButton.isHidden=true
                                            self.m_orLbl.isHidden=true
                                            self.m_tableViewTopConstraint.constant=25
                                            
                                            let countString : NSNumber =  self.resultsDictArray.count as! NSNumber
                                            self.m_noofHospitalsCountLbl.text=countString.stringValue
                                            self.getCount()
                                             self.m_tableview.reloadData()
                                            
                                        }
                                        else
                                        {
                                            self.m_noInternetView.isHidden=false
                                            self.m_emptyStateImageView.isHidden=false
                                            self.m_emptyStateTitleLbl.isHidden=false
                                            self.m_emptyStateDetailsLbl.isHidden=false
                                            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                            
                                            self.m_emptyStateTitleLbl_Height.constant = 0
                                            
                                            if m_windowPeriodStatus{
                                                self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                                self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                            }else{
                                                self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                                self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                                self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                            }
                                            
                                            self.TopHeaderBackgroundView.isHidden=true
                                            self.m_nearbyHospitalsButton.isHidden=true
                                            //self.serachNearbyButtonTopConstraint.constant=50
                                            self.m_tableview.isHidden=true
                                            self.m_tableview.reloadData()
                                        }
                                        
                                        self.hidePleaseWait()
                                        
                                }
                                       DispatchQueue.main.async {
                                           self.hospitalActivityIndicator.stopAnimating()
                                           self.hospitalActivityIndicator.isHidden = true
                                       }
                                                               
                            }
                            else
                            {
                                print("Can't cast response to NSHTTPURLResponse")
                                self.displayActivityAlert(title: m_errorMsg)
                                
                                DispatchQueue.main.async {
                                    self.hospitalActivityIndicator.stopAnimating()
                                    self.hospitalActivityIndicator.isHidden = true
                                    
                                    self.m_noInternetView.isHidden=false
                                    self.m_emptyStateImageView.isHidden=false
                                    self.m_emptyStateTitleLbl.isHidden=false
                                    self.m_emptyStateDetailsLbl.isHidden=false
                                    if m_windowPeriodStatus{
                                        self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                        self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                        self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                    }else{
                                        self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                        self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                        self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                    }
                                    self.m_emptyStateDetailsLbl.isHidden = true
                                    self.TopHeaderBackgroundView.isHidden=true
                                    self.m_nearbyHospitalsButton.isHidden=true
                                    self.m_tableview.isHidden=true
                                }
                                
                            }
                            
                        }
                    }
                    
                }
                task.resume()
            }
            else{
                displayActivityAlert(title: "Not getting your current location")
            }
            
        }
        else{
            displayActivityAlert(title: "No Internet Connection")
        }
    }
    
    
    func getPostHospitalDetailsPortalJson(searchString:String)
    {
        if(isConnectedToNetWithAlert())
        {
            print("searchString in request: ",searchString)
            if(searchString != "")
            {
                userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
                userOegrpNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String ?? ""
                
                print("getPostHospitalDetailsPortal Userdefaults userGroupChildNo: ",userGroupChildNo," userOegrpNo: ",userOegrpNo)
                
                self.hospitalActivityIndicator.startAnimating()
                self.hospitalActivityIndicator.isHidden = false
                self.m_tableview.isHidden=true
                
                if(!userGroupChildNo.isEmpty && !userOegrpNo.isEmpty)
                {
                    var oegrpbasinfsrno = String()
                    var groupChildSrNo = String()
                    
                    
                    if let oegrpGMC = userOegrpNo as? String{
                        oegrpbasinfsrno = String(oegrpGMC)
                        oegrpbasinfsrno = try! AES256.encrypt(input: oegrpbasinfsrno, passphrase: m_passphrase_Portal)
                    }
                    if let groupChlNo = userGroupChildNo as? String{
                        groupChildSrNo=String(groupChlNo)
                        groupChildSrNo = try! AES256.encrypt(input: groupChildSrNo, passphrase: m_passphrase_Portal)
                    }
                    
                    var str = ""
                    var allStr = ""
                    if isfromSearchString{
                        allStr = searchString
                        print("Search by \(allStr)")
                    }else{
                        allStr = "All"
                        print("Search by \(allStr)")
                    }
                https://uat-employee.benefitsyou.com/mb360apiv1/api/EnrollmentDetails/LoadProviders?groupchildsrno=1708&oegrpbasinfsrno=2449&hospitalsearchtext=ALL
                    if isFirstTime{
                        str = "LoadProviders?groupchildsrno=\(groupChildSrNo.URLEncoded)&oegrpbasinfsrno=\(oegrpbasinfsrno.URLEncoded)&hospitalsearchtext=\(allStr)"
                        //Test hard code data
                        //string = "<DataRequest><groupchildsrno>1224</groupchildsrno><oegrpbasinfsrno>1356</oegrpbasinfsrno><hospitalsearchtext>\(allStr)</hospitalsearchtext></DataRequest>"
                        
                        isFirstTime = false
                    }else{
                        str = "LoadProviders?groupchildsrno=\(groupChildSrNo.URLEncoded)&oegrpbasinfsrno=\(oegrpbasinfsrno.URLEncoded)&hospitalsearchtext=\(searchString)"
                        //Test hard code data
                        //string = "<DataRequest><groupchildsrno>1224</groupchildsrno><oegrpbasinfsrno>1356</oegrpbasinfsrno><hospitalsearchtext>\(allStr)</hospitalsearchtext></DataRequest>"
                    }
                    
                    
                    
                    
                    resultsDictArray.removeAll()
                    resultsDictArrayNew.removeAll()
                    self.m_nearbyHospitalsArray.removeAll()
                    self.distanceArray.removeAll()
                    
                    webServices().getRequestForJson(str, completion: { (data,error,resp) in
                        print("getPostHospitalDetailsPortalJson error: ",error)
                        if error != ""{
                            if error == "getRequestForJson error"{
                                DispatchQueue.main.async {
                                    self.hospitalActivityIndicator.stopAnimating()
                                    self.hospitalActivityIndicator.isHidden = true
                                    self.m_noInternetView.isHidden=false
                                    self.m_emptyStateImageView.isHidden=false
                                    self.m_emptyStateTitleLbl.isHidden=false
                                    self.m_emptyStateDetailsLbl.isHidden=false
                                   
                                    if m_windowPeriodStatus{
                                        self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                        self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                        self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                    }else{
                                        self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                        self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                        self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                    }
                                    
                                    self.TopHeaderBackgroundView.isHidden=false
                                    self.m_nearbyHospitalsButton.isHidden=true
                                    //self.serachNearbyButtonTopConstraint.constant=50
                                    let indexpath = IndexPath(row: 0, section: 0)
                                    let cell1 = self.m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
                                    cell1.m_primaryCountButton.backgroundColor = UIColor.white
                                    cell1.m_secondaryCountButton.backgroundColor = UIColor.white
                                    cell1.m_tertiaryCountButton.backgroundColor = UIColor.white
                                    cell1.m_OtherCountButton.backgroundColor = UIColor.white
                                    
                                     
                                    self.m_tableview.isHidden=true
                                    self.m_tableview.reloadData()
                                    
                                }
                            }else{
                                print("error ",error)
                                self.hidePleaseWait()
                                self.displayActivityAlert(title: m_errorMsg)
                                
                                DispatchQueue.main.async {
                                    self.hospitalActivityIndicator.stopAnimating()
                                    self.hospitalActivityIndicator.isHidden = true
                                }
                            }
                        }else{
                            if let httpResponse = resp as? HTTPURLResponse//response as? HTTPURLResponse
                            {
                                print("getPostHospitalDetailsPortal: ",httpResponse.statusCode)
                                if httpResponse.statusCode == 200
                                {
                                    do {
                                        
                                        
                                        let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                                        
                                        print("jsonResult",jsonResult)
                                        
                                        
                                        if let message = jsonResult["message"] as? [String: Any], let messageValue = message["Message"] as? String {
                                            print("Message: \(messageValue)")
                                            
                                            if messageValue.lowercased() == "details found"{
                                                var arrHospInfo = jsonResult["Hospital_Information"] as? [[String: String]]
                                                print("arrHospInfo: ",arrHospInfo)
                                                if arrHospInfo!.count == 0{
                                                    DispatchQueue.main.async {
                                                        self.m_noInternetView.isHidden=false
                                                        self.m_emptyStateImageView.isHidden=false
                                                        self.m_emptyStateTitleLbl.isHidden=false
                                                        self.m_emptyStateDetailsLbl.isHidden=false
                                                       
                                                        if m_windowPeriodStatus{
                                                            self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                                            self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                            self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                                        }else{
                                                            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                                            self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                                            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                                        }
                                                        
                                                        self.TopHeaderBackgroundView.isHidden=true
                                                        self.m_nearbyHospitalsButton.isHidden=true
                                                        //self.serachNearbyButtonTopConstraint.constant=50
                                                        self.m_tableview.isHidden=false
                                                        self.m_tableview.reloadData()
                                                        
                                                        self.hidePleaseWait()
                                                        
                                                        
                                                        self.hospitalActivityIndicator.stopAnimating()
                                                        self.hospitalActivityIndicator.isHidden = true
                                                    }
                                                    self.m_nearbyHospitalsButton.isHidden=true
                                                    self.m_orLbl.isHidden=true
                                                    //self.m_tableViewTopConstraint.constant=25
                                                    
                                                    let countString : NSNumber =  self.resultsDictArray.count as! NSNumber
                                                    self.m_noofHospitalsCountLbl.text=countString.stringValue
                                                    self.getCount()
                                                    self.m_tableview.reloadData()
                                                    self.m_noInternetView.isHidden=true
                                                    
                                                    self.m_emptyStateImageView.isHidden=true
                                                    self.m_emptyStateTitleLbl.isHidden=true
                                                    self.m_emptyStateDetailsLbl.isHidden=true
                                                    self.m_tableview.isHidden = false
                                                    
                                                    //                                            let indexpath = IndexPath(row: self.selectedIndexPath, section: 0)
                                                    //                                            let cell = self.m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
                                                    
                                                }else{
//                                                    DispatchQueue.main.async {
//                                                        self.m_tableview.isHidden=false
//                                                    }
                                                    if(self.isSearchNearby)
                                                    {
                                                        self.m_nearbyHospitalsArray=[]
                                                        //var arrHospInfo = jsonResult["Hospital_Information"] as? [[String: String]]
                                                        self.resultsDictArray = arrHospInfo!
                                                        if  self.m_addressString.uppercased() == "ALL"{
                                                            self.allResultsDictArray = arrHospInfo!
                                                            print("Saved All allResultsDictArray : ",self.allResultsDictArray.count)
                                                        }
                                                        else{
                                                            print("Already saved All allResultsDictArray :",self.allResultsDictArray.count)
                                                        }
                                                        //globalHospitalList = arrHospInfo!
                                                        print(self.resultsDictArray)
                                                        //Added by geeta
                                                        if self.resultsDictArray.count > 0 {
                                                            //var cnt = self.resultsDictArray.count
                                                            if NetworkHospitalsViewController.cnt == 0{
                                                                globalHospitalList = self.resultsDictArray
                                                                NetworkHospitalsViewController.cnt = 1
                                                            }
                                                            var index  = 0
                                                            while index < self.limit && index < self.resultsDictArray.count {
                                                                //if index != cnt {
                                                                self.resultsDictArrayNew.append(self.resultsDictArray[index])//append from main array
                                                                index = index + 1
                                                                //}
                                                            }
                                                            
                                                        }
                                                        
                                                        /* for dict in  self.resultsDictArray {
                                                         let address = dict["HospitalAddress"]
                                                         print(address!,self.m_subLocality)
                                                         print("addressString\(self.m_addressString)")
                                                         let subLocality = self.m_subLocality.uppercased()
                                                         let addr = self.m_addressString.uppercased()
                                                         if(address?.contains(addr))!{
                                                         self.m_nearbyHospitalsArray.append(dict)
                                                         }
                                                         }*/
                                                        self.calculateDistance()
                                                        self.distancestring()
                                                        
                                                        
                                                        print(self.m_nearbyHospitalsArray,self.m_nearbyHospitalsArray.count)
                                                        
                                                        //self.showLocationsOnMap()
                                                        //                                    if(!self.m_nearbyHospitalsArray.contains([:])) {
                                                        //                                        self.resultsDictArray=self.m_nearbyHospitalsArray
                                                        //                                    }
                                                        
                                                    }
                                                    self.searchHospitalsDictArray = self.resultsDictArray
                                                    DispatchQueue.main.async
                                                    {
                                                        print(self.resultsDictArray)
                                                        
                                                        let sortDescriptor = NSSortDescriptor(key: "HospitalName", ascending: true)
                                                        self.resultsDictArray = self.resultsDictArray.sorted {
                                                            guard let s1 = $0["HOSP_NAME"], let s2 = $1["HOSP_NAME"] else {
                                                                return false
                                                            }
                                                            
                                                            if s1 == s2 {
                                                                guard let g1 = $0["given"], let g2 = $1["given"] else {
                                                                    return false
                                                                }
                                                                return g1 < g2
                                                            }
                                                            
                                                            return s1 < s2
                                                        }
                                                        let count:Int = (self.resultsDictArray.count)
                                                        if(count>0) {
                                                            //self.TopHeaderBackgroundView.isHidden=false
                                                            //self.m_nearbyHospitalsButton.isHidden=false
                                                            self.serachNearbyButtonTopConstraint.constant=20
                                                            self.m_tableview.isHidden=false
                                                            //commented by Pranit
                                                            //self.m_searchBar.isHidden=true
                                                            
                                                            //Added By Pranit
//                                                            if self.isSearchNearby {
//                                                                self.m_searchBar.isHidden=true
//                                                            }
                                                            self.m_nearbyHospitalsButton.isHidden=true
                                                            self.m_orLbl.isHidden=true
                                                            self.m_tableViewTopConstraint.constant=25
                                                            let countString : NSNumber =  self.resultsDictArray.count as! NSNumber
                                                            self.m_noofHospitalsCountLbl.text=countString.stringValue
                                                            self.getCount()
                                                            self.m_tableview.reloadData()
                                                            self.m_noInternetView.isHidden=true
                                                            
                                                            self.m_emptyStateImageView.isHidden=true
                                                            self.m_emptyStateTitleLbl.isHidden=true
                                                            self.m_emptyStateDetailsLbl.isHidden=true
                                                            self.m_tableview.isHidden = false
                                                            //                                            let indexpath = IndexPath(row: self.selectedIndexPath, section: 0)
                                                            //                                            let cell = self.m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
                                                        }
                                                        else
                                                        {
                                                            //self.m_tableViewTopConstraint.constant=25
                                                            self.m_noInternetView.isHidden=false
                                                            self.m_emptyStateImageView.isHidden=false
                                                            self.m_emptyStateTitleLbl.isHidden=false
                                                            self.m_emptyStateDetailsLbl.isHidden=false
                                                            
                                                            if m_windowPeriodStatus{
                                                                self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                                                self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                                self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                                            }else{
                                                                self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                                                self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                                                self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                                            }
                                                            
                                                            self.TopHeaderBackgroundView.isHidden=true
                                                            self.m_nearbyHospitalsButton.isHidden=true
                                                            //self.serachNearbyButtonTopConstraint.constant=50
                                                            self.m_tableview.isHidden=false
                                                            self.m_tableview.reloadData()
                                                        }
                                                        self.hidePleaseWait()
                                                    }
                                                    DispatchQueue.main.async {
                                                        self.hospitalActivityIndicator.stopAnimating()
                                                        self.hospitalActivityIndicator.isHidden = true
                                                    }
                                                }
                                            }else{
                                                DispatchQueue.main.async {
                                                    self.m_noInternetView.isHidden=false
                                                    self.m_emptyStateImageView.isHidden=false
                                                    self.m_emptyStateTitleLbl.isHidden=false
                                                    self.m_emptyStateDetailsLbl.isHidden=false
                                                    self.topNoInternetVew.constant = 20
                                                    //self.m_tableViewTopConstraint.constant=25
                                                    
                                                    if m_windowPeriodStatus{
                                                        self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                                        self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                        self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                                    }else{
                                                        self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                                        self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                                        self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                                    }
                                                    
                                                    self.TopHeaderBackgroundView.isHidden=false
                                                    self.m_nearbyHospitalsButton.isHidden=true
                                                    //self.serachNearbyButtonTopConstraint.constant=50
                                                    self.m_tableview.isHidden=false
                                                    self.m_tableview.reloadData()
                                                    self.hidePleaseWait()
                                                    self.hospitalActivityIndicator.stopAnimating()
                                                    self.hospitalActivityIndicator.isHidden = true
                                                    
                                                   
                                                }
                                            }
                                        } else {
                                            print("Failed to extract the 'Message' value.")
                                        }
                                    }catch{
                                        print("getPostHospitalDetailsPortalJson Error ",error)
                                    }
                                    
                                }
                                else if httpResponse.statusCode == 404{
                                    
                                    print("Hospital httpResponse.statusCode 404 ",httpResponse.statusCode)
                                    //self.displayActivityAlert(title: "No hospital found in your network..")
                                    DispatchQueue.main.async {
                                        self.topNoInternetVew.constant = 20
                                        self.hospitalActivityIndicator.stopAnimating()
                                        self.hospitalActivityIndicator.isHidden = true
                                        self.m_noInternetView.isHidden=false
                                        self.m_emptyStateImageView.isHidden=false
                                        self.m_emptyStateTitleLbl.isHidden=false
                                        self.m_emptyStateDetailsLbl.isHidden=false
                                        
                                        if m_windowPeriodStatus{
                                            self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                            self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                            self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                        }else{
                                            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                            self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                        }
                                        
                                        self.TopHeaderBackgroundView.isHidden=true
                                        self.m_nearbyHospitalsButton.isHidden=true
                                        //self.serachNearbyButtonTopConstraint.constant=50
                                        self.m_tableview.isHidden=false
                                        self.m_tableview.reloadData()
                                    }
                                }
                                else
                                {
                                    print("Hospital httpResponse.statusCode ",httpResponse.statusCode)
                                    //self.displayActivityAlert(title: "No hospital found in your network")
                                    DispatchQueue.main.async {
                                        self.hospitalActivityIndicator.stopAnimating()
                                        self.hospitalActivityIndicator.isHidden = true
                                        self.m_noInternetView.isHidden=false
                                        self.m_emptyStateImageView.isHidden=false
                                        self.m_emptyStateTitleLbl.isHidden=false
                                        self.m_emptyStateDetailsLbl.isHidden=false
                                        self.topNoInternetVew.constant = 20
                                        if m_windowPeriodStatus{
                                            self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                            self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                            self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                        }else{
                                            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                            self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                        }
                                        self.TopHeaderBackgroundView.isHidden=true
                                        self.m_nearbyHospitalsButton.isHidden=true
                                        //self.serachNearbyButtonTopConstraint.constant=50
                                        self.m_tableview.isHidden=false
                                        self.m_tableview.reloadData()
                                    }
                                }
                            }
                        }
                    })
                }
                else{
                    print("Array data empty")
                    DispatchQueue.main.async {
                        self.hospitalActivityIndicator.stopAnimating()
                        self.hospitalActivityIndicator.isHidden = true
                        self.m_noInternetView.isHidden=false
                        self.m_emptyStateImageView.isHidden=false
                        self.m_emptyStateTitleLbl.isHidden=false
                        self.m_emptyStateDetailsLbl.isHidden=false
                        self.topNoInternetVew.constant = 20
                        if m_windowPeriodStatus{
                            self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                            self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                            self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                        }else{
                            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                            self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                        }
                        self.TopHeaderBackgroundView.isHidden=true
                        self.m_nearbyHospitalsButton.isHidden=true
                        //self.serachNearbyButtonTopConstraint.constant=50
                        self.m_tableview.isHidden=false
                        self.m_tableview.reloadData()
                    }
                }
            }
            else{
                //displayActivityAlert(title: "Not getting your current location")
                print("searchString is empty... ")
            }
            
        }
        else{
            //displayActivityAlert(title: "No Internet Connection")
            DispatchQueue.main.async {
                self.topNoInternetVew.constant = 0
                self.hospitalActivityIndicator.stopAnimating()
                self.hospitalActivityIndicator.isHidden = true
                self.m_noInternetView.isHidden=false
                self.m_emptyStateImageView.isHidden=false
                self.m_emptyStateTitleLbl.isHidden=false
                self.m_emptyStateDetailsLbl.isHidden=false
                self.m_emptyStateImageView.image=UIImage(named: "nointernet")
                self.m_emptyStateTitleLbl.text = error_NoInternet
                self.m_emptyStateDetailsLbl.text = ""
                self.TopHeaderBackgroundView.isHidden=true
                self.m_nearbyHospitalsButton.isHidden=true
                //self.serachNearbyButtonTopConstraint.constant=50
                self.m_tableview.isHidden=false
                self.m_tableview.reloadData()
            }
        }
    }
    
    
    func getPostHospitalDetailsPortal(searchString:String)
    {
        if(isConnectedToNetWithAlert())
        {
            print("searchString in request: ",searchString)
            if(searchString != "")
            {
                userGroupChildNo = UserDefaults.standard.value(forKey: "userGroupChildNoValue") as? String ?? ""
                userOegrpNo = UserDefaults.standard.value(forKey: "userOegrpNoValue") as? String ?? ""
              
                print("getPostHospitalDetailsPortal Userdefaults userGroupChildNo: ",userGroupChildNo," userOegrpNo: ",userOegrpNo)
                      
                self.hospitalActivityIndicator.startAnimating()
                self.hospitalActivityIndicator.isHidden = false
                
                
                if(!userGroupChildNo.isEmpty && !userOegrpNo.isEmpty)
                {
                    var oegrpbasinfsrno = String()
                    var groupChildSrNo = String()
                    
                    
                    if let oegrpGMC = userOegrpNo as? String{
                        oegrpbasinfsrno = String(oegrpGMC)
                    }
                    if let groupChlNo = userGroupChildNo as? String{
                        groupChildSrNo=String(groupChlNo)
                    }
                    
                    var string = ""
                    var allStr = ""
                    if isfromSearchString{
                        allStr = searchString
                        print("Search by \(allStr)")
                    }else{
                        allStr = "All"
                        print("Search by \(allStr)")
                    }
                    if isFirstTime{
                        string = "<DataRequest><groupchildsrno>\(groupChildSrNo)</groupchildsrno><oegrpbasinfsrno>\(oegrpbasinfsrno)</oegrpbasinfsrno><hospitalsearchtext>\(allStr)</hospitalsearchtext></DataRequest>"
                        //Test hard code data
                        //string = "<DataRequest><groupchildsrno>1224</groupchildsrno><oegrpbasinfsrno>1356</oegrpbasinfsrno><hospitalsearchtext>\(allStr)</hospitalsearchtext></DataRequest>"
                        
                        isFirstTime = false
                    }else{
                        string = "<DataRequest><groupchildsrno>\(groupChildSrNo)</groupchildsrno><oegrpbasinfsrno>\(oegrpbasinfsrno)</oegrpbasinfsrno><hospitalsearchtext>\(searchString)</hospitalsearchtext></DataRequest>"
                        //Test hard code data
                        //string = "<DataRequest><groupchildsrno>1224</groupchildsrno><oegrpbasinfsrno>1356</oegrpbasinfsrno><hospitalsearchtext>\(allStr)</hospitalsearchtext></DataRequest>"
                    }
                    
                    
                    let uploadData = string.data(using: .utf8)
                    
                    let urlreq = NSURL(string: WebServiceManager.getSharedInstance().getHospitalDetailsPostUrlPortal() as String)
                    
                    let request : NSMutableURLRequest = NSMutableURLRequest()
                    request.url = urlreq as URL?// NSURL(string: urlreq)
                    request.httpMethod = "POST"
                    request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
                    
                    request.httpBody=uploadData
                    print("NW URL Portal : \(urlreq) \n param : \(string)")
                    
                    resultsDictArray.removeAll()
                    resultsDictArrayNew.removeAll()
                    self.m_nearbyHospitalsArray.removeAll()
                    self.distanceArray.removeAll()
                    
                    //                //SSL Pinning
                    //                let sessionConfig = URLSessionConfiguration.default
                    //                sessionConfig.urlCache = nil // disable caching to ensure requests are always validated
                    //                sessionConfig.timeoutIntervalForRequest = sslTimeOut // set a timeout interval if desired
                    //                TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
                    //                let session = URLSession(
                    //                               configuration: sessionConfig,
                    //                               delegate: URLSessionPinningDelegate(),
                    //                               delegateQueue: nil)
                    
                    let session = URLSession(configuration: .default)
                    let task = session.dataTask(with: request as URLRequest)
                    { (data, response, error) -> Void in
                        //SSL Pinning
                        if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == -1200 {
                            // Handle SSL connection failure
                            print("SSL connection error: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                self.alertForLogout(titleMsg: error.localizedDescription)
                            }
                        }
                        else if error != nil
                        {
                            print("error ",error!)
                            self.hidePleaseWait()
                            self.displayActivityAlert(title: m_errorMsg)
                            
                            DispatchQueue.main.async {
                                self.hospitalActivityIndicator.stopAnimating()
                                self.hospitalActivityIndicator.isHidden = true
                            }
                        }
                        else
                        {
                            if let httpResponse = response as? HTTPURLResponse
                            {
                                print("getPostHospitalDetailsPortal: ",httpResponse.statusCode)
                                if httpResponse.statusCode == 200
                                {
                                    
                                    
                                    self.xmlKey = "HospitalInformation"
                                    let parser = XMLParser(data: data!)
                                    parser.delegate = self as? XMLParserDelegate
                                    parser.parse()
                                    
                                    if(self.isSearchNearby)
                                    {
                                        self.m_nearbyHospitalsArray=[]
                                        
                                        //Added by geeta
                                        if self.resultsDictArray.count > 0 {
                                            //var cnt = self.resultsDictArray.count
                                            if NetworkHospitalsViewController.cnt == 0{
                                                globalHospitalList = self.resultsDictArray
                                                NetworkHospitalsViewController.cnt = 1
                                            }
                                            var index  = 0
                                            while index < self.limit && index < self.resultsDictArray.count {
                                                //if index != cnt {
                                                self.resultsDictArrayNew.append(self.resultsDictArray[index])//append from main array
                                                index = index + 1
                                                //}
                                            }
                                            
                                        }
                                        
                                        /* for dict in  self.resultsDictArray {
                                         let address = dict["HospitalAddress"]
                                         print(address!,self.m_subLocality)
                                         print("addressString\(self.m_addressString)")
                                         let subLocality = self.m_subLocality.uppercased()
                                         let addr = self.m_addressString.uppercased()
                                         if(address?.contains(addr))!{
                                         self.m_nearbyHospitalsArray.append(dict)
                                         }
                                         }*/
                                        self.calculateDistance()
                                        self.distancestring()
                                        
                                        
                                        print(self.m_nearbyHospitalsArray,self.m_nearbyHospitalsArray.count)
                                        
                                        //self.showLocationsOnMap()
                                        //                                    if(!self.m_nearbyHospitalsArray.contains([:])) {
                                        //                                        self.resultsDictArray=self.m_nearbyHospitalsArray
                                        //                                    }
                                        
                                    }
                                    self.searchHospitalsDictArray = self.resultsDictArray
                                    DispatchQueue.main.async
                                    {
                                        print(self.resultsDictArray)
                                        
                                        let sortDescriptor = NSSortDescriptor(key: "HospitalName", ascending: true)
                                        self.resultsDictArray = self.resultsDictArray.sorted {
                                            guard let s1 = $0["HospitalName"], let s2 = $1["HospitalName"] else {
                                                return false
                                            }
                                            
                                            if s1 == s2 {
                                                guard let g1 = $0["given"], let g2 = $1["given"] else {
                                                    return false
                                                }
                                                return g1 < g2
                                            }
                                            
                                            return s1 < s2
                                        }
                                        let count:Int = (self.resultsDictArray.count)
                                        if(count>0) {
                                            //self.TopHeaderBackgroundView.isHidden=false
                                            //self.m_nearbyHospitalsButton.isHidden=false
                                            self.serachNearbyButtonTopConstraint.constant=20
                                            self.m_tableview.isHidden=false
                                            //commented by Pranit
                                            //self.m_searchBar.isHidden=true
                                            
                                            //Added By Pranit
                                            if self.isSearchNearby {
                                                self.m_searchBar.isHidden=true
                                            }
                                            self.m_nearbyHospitalsButton.isHidden=true
                                            self.m_orLbl.isHidden=true
                                            self.m_tableViewTopConstraint.constant=25
                                            
                                            let countString : NSNumber =  self.resultsDictArray.count as! NSNumber
                                            self.m_noofHospitalsCountLbl.text=countString.stringValue
                                            self.getCount()
                                            self.m_tableview.reloadData()
                                            self.m_noInternetView.isHidden=true
                                            self.m_emptyStateImageView.isHidden=true
                                            self.m_emptyStateTitleLbl.isHidden=true
                                            self.m_emptyStateDetailsLbl.isHidden=true
                                            self.m_tableview.isHidden = false
                                            
                                            //                                            let indexpath = IndexPath(row: self.selectedIndexPath, section: 0)
                                            //                                            let cell = self.m_tableview.cellForRow(at: indexpath) as! NetworkHospitalsTableViewCell
                                            
                                        }
                                        else
                                        {
                                            self.m_noInternetView.isHidden=false
                                            self.m_emptyStateImageView.isHidden=false
                                            self.m_emptyStateTitleLbl.isHidden=false
                                            self.m_emptyStateDetailsLbl.isHidden=false
                                            
                                            self.m_emptyStateTitleLbl_Height.constant = 0
                                            
                                            if m_windowPeriodStatus{
                                                self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                                self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                                self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                            }else{
                                                self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                                self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                                self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                            }
                                            self.TopHeaderBackgroundView.isHidden=true
                                            self.m_nearbyHospitalsButton.isHidden=true
                                            //self.serachNearbyButtonTopConstraint.constant=50
                                            self.m_tableview.isHidden=true
                                            self.m_tableview.reloadData()
                                        }
                                        
                                        self.hidePleaseWait()
                                        
                                    }
                                    DispatchQueue.main.async {
                                        self.hospitalActivityIndicator.stopAnimating()
                                        self.hospitalActivityIndicator.isHidden = true
                                    }
                                    
                                }
                                else if httpResponse.statusCode == 404{
                                    
                                    print("Hospital httpResponse.statusCode 404 ",httpResponse.statusCode)
                                    //self.displayActivityAlert(title: "No hospital found in your network..")
                                    DispatchQueue.main.async {
                                        self.hospitalActivityIndicator.stopAnimating()
                                        self.hospitalActivityIndicator.isHidden = true
                                        self.m_noInternetView.isHidden=false
                                        self.m_emptyStateImageView.isHidden=false
                                        self.m_emptyStateTitleLbl.isHidden=false
                                        self.m_emptyStateDetailsLbl.isHidden=false
                                        
                                        self.m_emptyStateTitleLbl_Height.constant = 0

                                        if m_windowPeriodStatus{
                                            self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                            self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                            self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                        }else{
                                            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                            self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                        }
                                        self.TopHeaderBackgroundView.isHidden=true
                                        self.m_nearbyHospitalsButton.isHidden=true
                                        //self.serachNearbyButtonTopConstraint.constant=50
                                        self.m_tableview.isHidden=true
                                        self.m_tableview.reloadData()
                                    }
                                }
                                else
                                {
                                    print("Hospital httpResponse.statusCode ",httpResponse.statusCode)
                                    //self.displayActivityAlert(title: "No hospital found in your network")
                                    DispatchQueue.main.async {
                                        self.hospitalActivityIndicator.stopAnimating()
                                        self.hospitalActivityIndicator.isHidden = true
                                        self.m_noInternetView.isHidden=false
                                        self.m_emptyStateImageView.isHidden=false
                                        self.m_emptyStateTitleLbl.isHidden=false
                                        self.m_emptyStateDetailsLbl.isHidden=false
                                        
                                        
                                        self.m_emptyStateTitleLbl_Height.constant = 0

                                        if m_windowPeriodStatus{
                                            self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                            self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                            self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                        }else{
                                            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                            self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                        }
                                        
                                        self.TopHeaderBackgroundView.isHidden=true
                                        self.m_nearbyHospitalsButton.isHidden=true
                                        //self.serachNearbyButtonTopConstraint.constant=50
                                        self.m_tableview.isHidden=true
                                        self.m_tableview.reloadData()
                                    }
                                    
                                }
                                
                            }
                        }
                        
                    }
                    task.resume()
                }
                else{
                    print("Array data empty")
                    DispatchQueue.main.async {
                        self.hospitalActivityIndicator.stopAnimating()
                        self.hospitalActivityIndicator.isHidden = true
                        self.m_noInternetView.isHidden=false
                        self.m_emptyStateImageView.isHidden=false
                        self.m_emptyStateTitleLbl.isHidden=false
                        self.m_emptyStateDetailsLbl.isHidden=false
                        
                        
                        self.m_emptyStateTitleLbl_Height.constant = 0

                        if m_windowPeriodStatus{
                            self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                            self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                            self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                        }else{
                            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                            self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                        }
                        
                        self.TopHeaderBackgroundView.isHidden=true
                        self.m_nearbyHospitalsButton.isHidden=true
                        //self.serachNearbyButtonTopConstraint.constant=50
                        self.m_tableview.isHidden=true
                        self.m_tableview.reloadData()
                    }
                    
                }
            }
            else{
                //displayActivityAlert(title: "Not getting your current location")
                print("searchString is empty... ")
            }
            
        }
        else{
            displayActivityAlert(title: "No Internet Connection")
        }
    }
    
    
    
    //Not used
    func getHospitalDetails(searchString:String)
    {
        if(isConnectedToNet())
        {
            
            
            
            showPleaseWait(msg: """
Please wait...
Fetching Hospitals
""")
            
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "")
            if (userArray.count>0)
            {
                
                m_employeedict=userArray[0]
                
                var groupchildsrno = String()
                var oegrpbasinfsrno = String()
                
                if let childNo = m_employeedict?.groupChildSrNo
                {
                    groupchildsrno = String(childNo)
                }
                if let oeinfNo = m_employeedict?.oe_group_base_Info_Sr_No
                {
                    oegrpbasinfsrno = String(oeinfNo)
                }
                
                let urlreq = NSURL(string : WebServiceManager.getSharedInstance().getNetworkHospitalUrl(groupchildsrno: groupchildsrno, oegrpbasinfsrno: oegrpbasinfsrno, searchString: searchString))
                
                let request : NSMutableURLRequest = NSMutableURLRequest()
                request.url = urlreq as URL?// NSURL(string: urlreq)
                request.httpMethod = "GET"
                
                
                
                let task = URLSession.shared.dataTask(with: urlreq! as URL)
                { (data, response, error) in
                    
                    if data == nil
                    {
                        
                        return
                    }
                    self.xmlKey = "Hospitals"
                    let parser = XMLParser(data: data!)
                    parser.delegate = self
                    parser.parse()
                    
                    
                    if(self.isSearchNearby)
                    {
                        self.m_nearbyHospitalsArray=[]
                        for dict in  self.resultsDictArray
                        {
                            let address = dict["HospitalAddress"]
                            print(address!,self.m_subLocality)
                            print("addressString\(self.m_addressString)")
                            let subLocality = self.m_subLocality.uppercased()
                            
                            let addr = self.m_addressString.uppercased()
                            if(address?.contains(addr))!
                            {
                                
                                self.m_nearbyHospitalsArray.append(dict)
                            }
                        }
                        print(self.m_nearbyHospitalsArray)
                        //                        self.showLocationsOnMap()
                        if self.m_nearbyHospitalsArray != nil
                        {
                            self.resultsDictArray=self.m_nearbyHospitalsArray
                        }
                    }
                    self.searchHospitalsDictArray = self.resultsDictArray
                    DispatchQueue.main.async
                        {
                            print(self.resultsDictArray)
                            
                            let sortDescriptor = NSSortDescriptor(key: "HospitalName", ascending: true)
                            self.resultsDictArray = self.resultsDictArray.sorted {
                                guard let s1 = $0["HospitalName"], let s2 = $1["HospitalName"] else {
                                    return false
                                }
                                
                                if s1 == s2 {
                                    guard let g1 = $0["given"], let g2 = $1["given"] else {
                                        return false
                                    }
                                    return g1 < g2
                                }
                                
                                return s1 < s2
                            }
                            
                            let count:Int = (self.resultsDictArray.count)
                            if(count>0)
                            {
                                
                                //                                self.TopHeaderBackgroundView.isHidden=false
                                //                                self.m_nearbyHospitalsButton.isHidden=false
                                self.serachNearbyButtonTopConstraint.constant=20
                                self.m_tableview.isHidden=false
                                self.m_searchBar.isHidden=true
                                self.m_nearbyHospitalsButton.isHidden=true
                                self.m_orLbl.isHidden=true
                                self.m_tableViewTopConstraint.constant=25
                                
                                //added by pranit
                                self.m_tableVIewConstraintWithSuperview.constant = 0
                                
                                self.m_tableview.reloadData()
                                let countString : NSNumber =  self.resultsDictArray.count as! NSNumber
                                self.m_noofHospitalsCountLbl.text=countString.stringValue
                                self.getCount()
                                
                                
                            }
                            else
                            {
                                self.m_noInternetView.isHidden=false
                                self.m_emptyStateImageView.isHidden=false
                                self.m_emptyStateTitleLbl.isHidden=false
                                self.m_emptyStateDetailsLbl.isHidden=false
                                
                                
                                self.m_emptyStateTitleLbl_Height.constant = 0

                                if m_windowPeriodStatus{
                                    self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                                    self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                                    self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                                }else{
                                    self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                                    self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                                    self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                                }
                                
                                self.TopHeaderBackgroundView.isHidden=true
                                self.m_nearbyHospitalsButton.isHidden=true
                                //                                self.serachNearbyButtonTopConstraint.constant=50
                                self.m_tableview.isHidden=true
                                self.m_tableview.reloadData()
                            }
                            
                            self.hidePleaseWait()
                    }
                    
                    
                }
                task.resume()
                
            }
        }
        else
        {
            m_noInternetView.isHidden=false
            m_tableview.reloadData()
        }
    }
    
    
    @IBAction func btnCloseAct(_ sender: Any) {
        m_searchBar.isHidden = true
        m_searchTableview.isHidden = true
        btnClose.isHidden = true
        m_searchBar.endEditing(true)
//        m_tableview.isHidden = false

        print("selectedIndexPath: ",selectedIndexPath)
        let indexpath = IndexPath(row: selectedIndexPath, section: 0)
        let cell1 = m_tableview.cellForRow(at: indexpath) as? NetworkHospitalsTableViewCell
        cell1?.m_primaryCountButton.backgroundColor = UIColor.white
        cell1?.m_secondaryCountButton.backgroundColor = UIColor.white
        cell1?.m_tertiaryCountButton.backgroundColor = UIColor.white
        cell1?.m_OtherCountButton.backgroundColor = UIColor.white
        
        
        
        m_tableVIewConstraintWithSuperview.constant=0
        print(globalHospitalList.count)
        if globalHospitalList.count > 0
        {
            self.hospitalActivityIndicator.startAnimating()
            self.hospitalActivityIndicator.isHidden = false
            self.m_tableview.isScrollEnabled = false
            self.m_tableview.isHidden = true
            self.resultsDictArray = globalHospitalList
            var index  = 0
            while index < self.limit && index < self.resultsDictArray.count {
                //if index != cnt {
                 self.resultsDictArrayNew.append(self.resultsDictArray[index])//append from main array
                    index = index + 1
                //}
            }

            self.calculateDistance()
            self.distancestring()


            self.searchHospitalsDictArray = self.resultsDictArray
            DispatchQueue.main.async
                {
                    print(self.resultsDictArray)

                    let sortDescriptor = NSSortDescriptor(key: "HospitalName", ascending: true)
                    self.resultsDictArray = self.resultsDictArray.sorted {
                        guard let s1 = $0["HOSP_NAME"], let s2 = $1["HOSP_NAME"] else {
                            return false
                        }

                        if s1 == s2 {
                            guard let g1 = $0["given"], let g2 = $1["given"] else {
                                return false
                            }
                            return g1 < g2
                        }

                        return s1 < s2
                    }
                    let count:Int = (self.resultsDictArray.count)
                    if(count>0) {
                        //self.TopHeaderBackgroundView.isHidden=false
                        //self.m_nearbyHospitalsButton.isHidden=false
                        self.serachNearbyButtonTopConstraint.constant=20
                        self.m_tableview.isHidden=false
                        self.m_noInternetView.isHidden = true
                        self.m_emptyStateImageView.isHidden=true
                        self.m_emptyStateTitleLbl.isHidden=true
                        self.m_emptyStateDetailsLbl.isHidden=true
                        //commented by Pranit
                        //self.m_searchBar.isHidden=true

                        //Added By Pranit
                        if self.isSearchNearby {
                            self.m_searchBar.isHidden=true
                        }
                        self.m_nearbyHospitalsButton.isHidden=true
                        self.m_orLbl.isHidden=true
                        self.m_tableViewTopConstraint.constant=25

                        let countString : NSNumber =  self.resultsDictArray.count as! NSNumber
                        self.m_noofHospitalsCountLbl.text=countString.stringValue
                        self.getCount()
                         self.m_tableview.reloadData()

                    }
                    else
                    {
                        self.m_noInternetView.isHidden=false
                        self.m_emptyStateImageView.isHidden=false
                        self.m_emptyStateTitleLbl.isHidden=false
                        self.m_emptyStateDetailsLbl.isHidden=false
                        self.topNoInternetVew.constant = 20
                        self.m_emptyStateTitleLbl_Height.constant = 0

                        if m_windowPeriodStatus{
                            self.m_emptyStateImageView.image=UIImage(named: "duringEnrollDataNotFound");
                            self.m_emptyStateTitleLbl.text = "During_Enrollment_Header_ErrorMsg".localized()
                            self.m_emptyStateDetailsLbl.text = "During_Enrollment_Detail_ErrorMsg".localized()
                        }else{
                            self.m_emptyStateImageView.image=UIImage(named: "Nohospital")
                            self.m_emptyStateTitleLbl.text = "During_PostEnrollment_Header_HospitalErrorMsg".localized()
                            self.m_emptyStateDetailsLbl.text = "DataNotFoundErrorMsg".localized()
                        }
                        
                        self.TopHeaderBackgroundView.isHidden=true
                        self.m_nearbyHospitalsButton.isHidden=true
                        //self.serachNearbyButtonTopConstraint.constant=50
                        self.m_tableview.isHidden=true
                        self.m_tableview.reloadData()
                    }

                    self.hidePleaseWait()

            }
                   DispatchQueue.main.async {
                       self.hospitalActivityIndicator.stopAnimating()
                       self.hospitalActivityIndicator.isHidden = true
                       self.m_tableview.isScrollEnabled = true
                       self.m_tableview.isHidden = false
                   }


        }else{
            //getPostHospitalDetailsPortal(searchString: m_addressString)
            getPostHospitalDetailsPortalJson(searchString: m_addressString)
        }
        
    }
    
    
    func calculateDistance()
        {
            print("main array count in calculateDistance: \(self.resultsDictArray.count)")
           // DatabaseManager.sharedInstance.deleteHospitalDetails(searchString: "")
            for dict in self.resultsDictArray
            {
                    
//                let DictVal : NSDictionary = dict as! NSDictionary
//                print(DictVal)
//                DatabaseManager.sharedInstance.saveNetworkHospitalsDetails(contactDict: DictVal)
                
                                                
                
               if let lati = dict["Latitude"]
               {
                let lat : NSString = lati as NSString
                let long : NSString = dict["Longitude"]! as NSString
                print("latitude : \(latitude) & longitude : \(longitude)")
                //print(latitude,longitude)
                if(latitude != nil && longitude != nil)
                {
                    let coordinate₀ = CLLocation(latitude: latitude, longitude: longitude)
                    let coordinate₁ = CLLocation(latitude: lat.doubleValue, longitude: long.doubleValue)
                    
                    let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                    print("In Meters = ",distanceInMeters)
                    
                    let distanceInKm = distanceInMeters/1000
                    print("In KiloMeters = ",distanceInKm)
                    let dist = String(distanceInKm).components(separatedBy: ".")
                    print(dist)
                    self.distanceArray.append(dist[0])
                    if distanceInMeters <= 5000
                    {
                        self.m_nearbyHospitalsArray.append(dict)
                    }
                }
                else{
                    
                }
                
            }
            else{
    //            calculateDistance()
            }
            }
            print("nearbr array count in calculateDistance: \(m_nearbyHospitalsArray.count)")
            
        }
    

        func distancestring() {
            
    //        if (d / 1000 > 1){
    //            print(round(d / 1000))
    //        }
    //        else if (d / 1000 <= 1){
    //            print(Double(round(d)/1000))
    //        }
            //self.m_nearbyHospitalsArrayNew.removeAll()
            print("latitude :\(latitude) longitude:\(longitude)")
            print("Current location : latitude :\(latitude!) longitude:\(longitude!)")
            var distArray = [String]()
             let lat1:Double = latitude
             let lon1:Double = longitude
            for dict in self.resultsDictArray
            {
                let lat2 = Double(dict["LATITUDE"]!) ?? 0.0
                let lon2 = Double(dict["LONGITUDE"]!) ?? 0.0
                
                 if lat2 == 0 || lat2 == 0.0 || lon2 == 0 || lon2 == 0.0 {
                    //cell.distanceLbl.text = "- km"
                 }else{
                     let R = 6378137.00
                    
                     let dLat = (lat2 - lat1) * .pi / 180
                     let dLon = (lon2 - lon1) * .pi / 180
                     let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180) * sin(dLon / 2) * sin(dLon / 2)
                     let c = 2 * atan2(sqrt(a), sqrt(1 - a))
                     let d = (R * c)
                     let c1 = Double(round(d)/1000)
                     //if d > 0 && Double(round(d)/1000) < 10{
                        if d > 0 && round(c1) < 10 {
                            
                            let c = Double(round(d)/1000)
                            let arr = String(round(c)).components(separatedBy: ".")
                            if arr.count > 0{
                                distArray.append(arr[0])
                            }
                        
                            self.m_nearbyHospitalsArrayNew.append(dict)
                      
                     }else{
                        //cell.distanceLbl.text = "- km"
                     }
                 }
            }
            

            print("distanceArray : \(distArray)")
                   
            for i in 0..<distArray.count {
                for j in (i + 1)..<distArray.count {
                       if distArray[i] > distArray[j] {
                           let a = distArray[i]
                           distArray[i] = distArray[j]
                           distArray[j] = a
                           
                           let b =  m_nearbyHospitalsArrayNew[i];
                           m_nearbyHospitalsArrayNew[i] = m_nearbyHospitalsArrayNew[j]
                           m_nearbyHospitalsArrayNew[j] = b
                        }
                       }
                   }
                   print("numberArray : \(distArray)")
                   print("m_nearbyArray : \(m_nearbyHospitalsArrayNew)")
            
            print("m_nearbyHospitalsArrayNew : \(m_nearbyHospitalsArrayNew.count)")
            //......
        }
    
    func getCount()
    {
        m_primaryArray.removeAll()
        m_seconadryArray.removeAll()
        m_tertiaryArray.removeAll()
        m_otherArray.removeAll()
        
        for dict in resultsDictArray
        {
            let hospitalDict : NSDictionary = dict as NSDictionary
            let level = hospitalDict.value(forKey: "HOSP_LEVEL_OF_CARE") as? String
            
            switch level
            {
            case "Primary"?:
                
                m_primaryArray.append(m_resultDict)
                break
            case "Secondary"?:
                
                m_seconadryArray.append(m_resultDict)
                break
            case "Tertiary"?:
                
                m_tertiaryArray.append(m_resultDict)
                break
                
            default:
                m_otherArray.append(m_resultDict)
                break
            }
        }
        
    }
    
    //MARK:- TableView delagtes
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView==m_tableview)
        {
            if (resultsDictArray.count) != nil
            {
                if isNearBy{
                    if m_nearbyHospitalsArrayNew.count>0{
                        return m_nearbyHospitalsArrayNew.count
                    }
                    return 0
                }else{
                    if(!isfromSearchString)//if nearby
                    {
                        if((resultsDictArray.count)>9)
                        {
                            return resultsDictArrayNew.count
                            //return 10
                        }
                        else
                        {
                            return (resultsDictArray.count + 1)
                        }
                    }
                    else
                    {
                        //print("FOR search Result",resultsDictArrayNew.count)
                        //return (resultsDictArrayNew.count)+1
                        print("FOR search Result",resultsDictArray.count)
                        return (resultsDictArray.count)+1
                    }
                }
            }
            else
            {
                return 0
            }
        }
        else
        {
            if(StatusHolder.getSharedInstance().m_searchArray.count>0 || StatusHolder.getSharedInstance().m_searchArray.count==0 || StatusHolder.getSharedInstance().m_searchArray.count<11)
            {
                return StatusHolder.getSharedInstance().m_searchArray.count
            }
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(tableView==m_tableview)
        {
            
            let cell:NetworkHospitalsTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NetworkHospitalsTableViewCell
            
            if(indexPath.row==0)
            {
               // self.hidePleaseWait()
                
                if(m_primaryArray.count==0 && m_seconadryArray.count==0 && m_tertiaryArray.count==0 && m_otherArray.count==0)
                {
                    cell.m_headerView.isHidden = false
                    cell.m_nonCareHospitalCountView.isHidden=false
                    if isNearBy {
                        let countString : NSNumber =  self.m_nearbyHospitalsArrayNew.count as NSNumber
                        cell.m_withoutCareHospitalCount.text=countString.stringValue.currencyInputFormatting()
                    } else {
                        let countString : NSNumber =  self.searchHospitalsDictArray.count as NSNumber
                        cell.m_withoutCareHospitalCount.text=countString.stringValue.currencyInputFormatting()
                    }
//                    let countString : NSNumber =  self.searchHospitalsDictArray.count as NSNumber
//                    cell.m_withoutCareHospitalCount.text=countString.stringValue
                    cell.m_nonCareHospitalCountView.layer.masksToBounds=true
                    cell.m_nonCareHospitalCountView.layer.cornerRadius=cornerRadiusForView//8
                    
                }
                else
                {
                    cell.m_headerView.isHidden=false
                    cell.m_nonCareHospitalCountView.isHidden=true
                    
                }
                cell.m_searchNearbyButtonTopConstraint.constant=20
                cell.m_searchNearbyButton.isHidden=false
                cell.m_backGroundView.isHidden=true
                cell.m_colorCodeLbl.isHidden=true
                
                shadowForCell(view: cell.m_headerView)
                //         cell.m_headerView.setBorderToView(color: UIColor.black)
                cell.m_searchNearbyButton.layer.masksToBounds = true
                cell.m_searchNearbyButton.layer.cornerRadius = cell.m_searchNearbyButton.frame.height/2
                
                cell.m_searchNearbyButton.addTarget(self, action: #selector(searchNearbyHospitalsButtonClicked), for: .touchUpInside)
                
                
                let primarycountString : NSNumber =  self.m_primaryArray.count as NSNumber
                let seconadrycountString : NSNumber =  self.m_seconadryArray.count as NSNumber
                let tertiarycountString : NSNumber =  self.m_tertiaryArray.count as NSNumber
                let othercountString : NSNumber =  self.m_otherArray.count as NSNumber
                print("othercountString: ",othercountString)
                
                if primarycountString.intValue == 0{
                    cell.m_primaryCountButton.setTitle(primarycountString.stringValue, for: .normal)
                }
                else{
                    cell.m_primaryCountButton.setTitle(primarycountString.stringValue.currencyInputFormatting(), for: .normal)
                }
                
                if seconadrycountString.intValue == 0{
                    cell.m_secondaryCountButton.setTitle(seconadrycountString.stringValue, for: .normal)
                }
                else{
                    cell.m_secondaryCountButton.setTitle(seconadrycountString.stringValue.currencyInputFormatting(), for: .normal)
                }
                
                if tertiarycountString.intValue == 0{
                    cell.m_tertiaryCountButton.setTitle(tertiarycountString.stringValue, for: .normal)
                }
                else{
                    cell.m_tertiaryCountButton.setTitle(tertiarycountString.stringValue.currencyInputFormatting(), for: .normal)
                }
                
                if othercountString.intValue == 0{
                    cell.m_OtherCountButton.setTitle(othercountString.stringValue, for: .normal)
                }
                else{
                    cell.m_OtherCountButton.setTitle(othercountString.stringValue.currencyInputFormatting(), for: .normal)
                }
                
                //Corner ladius
                cell.m_primaryCountButton.layer.cornerRadius = cornerRadiusForView
                cell.m_primaryCountButton.layer.maskedCorners = [.layerMinXMaxYCorner]
                cell.m_OtherCountButton.layer.cornerRadius = cornerRadiusForView
                cell.m_OtherCountButton.layer.maskedCorners = [.layerMaxXMaxYCorner]
                
                cell.m_primaryCountButton.addTarget(self, action: #selector(primaryCountButtonClicked), for: .touchUpInside)
                
                cell.m_secondaryCountButton.addTarget(self, action: #selector(secondaryCountButtonClicked), for: .touchUpInside)
                cell.m_tertiaryCountButton.addTarget(self, action: #selector(tertiaryCountButtonClicked), for: .touchUpInside)
                cell.m_OtherCountButton.addTarget(self, action: #selector(otherCountButtonClicked), for: .touchUpInside)
                    if isNearBy {
                       let countString : NSNumber =  self.m_nearbyHospitalsArrayNew.count as NSNumber
                        cell.m_totalCountLbl.text=countString.stringValue.currencyInputFormatting()
                   } else {
                       let countString : NSNumber =  self.searchHospitalsDictArray.count as NSNumber
                       cell.m_totalCountLbl.text=countString.stringValue.currencyInputFormatting()
                    }
//                let countString : NSNumber =  self.searchHospitalsDictArray.count as NSNumber
//                cell.m_totalCountLbl.text=countString.stringValue
                print("Inside cellForRowAt 0")
                
                
            }
            else
            {
                cell.m_headerView.isHidden=true
                cell.m_searchNearbyButton.isHidden=true
                cell.m_backGroundView.isHidden=false
                cell.m_nonCareHospitalCountView.isHidden=true
                
                selectedIndexPath = indexPath.row
                if isNearBy{
                    
                    if m_nearbyHospitalsArrayNew.count > indexPath.row - 1 {
                        m_resultDict = m_nearbyHospitalsArrayNew[indexPath.row-1] as NSDictionary
                        cell.m_nameLbl.text=m_resultDict.value(forKey: "HOSP_NAME") as? String
                        var address = m_resultDict.value(forKey: "HOSP_ADDRESS") as? String
                        address = address?.replacingOccurrences(of: "NOT AVALIABLE", with: "")
                        cell.m_locationLbl.text=address
                        
                        
                        //        cell.m_contactDetailsLbl.text=m_resultDict.value(forKey: "HOSP_PHONE_NO") as? String
                        
                        var contactNumber = m_resultDict.value(forKey: "HOSP_PHONE_NO") as? String
                        contactNumber = contactNumber?.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890").inverted)
                        if(contactNumber=="")
                        {
                            cell.m_contactNumberButton.setTitle("-", for: .normal)
                        }
                        else
                        {
                            cell.m_contactNumberButton.setTitle(contactNumber, for: .normal)
                        }
                        cell.m_contactNumberButton.addTarget(self, action: #selector(contactButtonTapped), for: .touchUpInside)
                        
                        //        cell.m_levelButton.layer.masksToBounds=true
                        //        cell.m_levelButton.layer.cornerRadius=12.6
                        //        cell.m_levelButton.isUserInteractionEnabled = true
                        //        cell.m_levelButton.becomeFirstResponder()
                        //        cell.m_levelButton.tag=indexPath.row
                        //        cell.m_levelButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
                        
                        let level = m_resultDict.value(forKey: "HOSP_LEVEL_OF_CARE") as? String
                        
                        switch level
                        {
                        case "Primary"?:
                            
                            cell.m_colorCodeLbl.isHidden=false
                            
                            cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblPrimary
                            cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblPrimary
                            cell.m_topConstraint.constant=45
                            cell.m_levelLbl.isHidden=false
                            cell.m_levelLbl.text=level!+" "+"careLbl".localized()
                            
                            //            primaryResultsDictArray?.append(m_resultDict as! [String : String])
                            cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_Blue")
                            
                            
                            break
                        case "Secondary"?:
                            
                            cell.m_colorCodeLbl.isHidden=false
                            cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblSecondary
                            cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblSecondary
                            cell.m_topConstraint.constant=45
                            cell.m_levelLbl.isHidden=false
                            cell.m_levelLbl.text=level!+" "+"careLbl".localized()
                            
                            //            secondaryResultsDictArray?.append(m_resultDict as! [String : String])
                           
                            cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_MGreen")
                            break
                        case "Tertiary"?:
                            
                            cell.m_colorCodeLbl.isHidden=false
                            cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblTertiary
                            cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblTertiary
                            cell.m_topConstraint.constant=45
                            cell.m_levelLbl.isHidden=false
                            cell.m_levelLbl.text=level!+" "+"careLbl".localized()
                            
                            //            tertiaryResultsDictArray?.append(m_resultDict as! [String : String])
                            
                            cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_Red")
                            
                            break
                            
                        case "NOT AVAILABLE"?:
                            
                            cell.m_colorCodeLbl.isHidden=false
                            cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblOther
                            cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblOther
                            cell.m_topConstraint.constant=45
                            cell.m_levelLbl.isHidden=false
                            cell.m_levelLbl.text="Other"
                            
                            //            tertiaryResultsDictArray?.append(m_resultDict as! [String : String])
                           
                            cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_Yellow")
                            
                            break
                            
                        case "Not Applicable"?:
                            
                            cell.m_colorCodeLbl.isHidden=false
                            cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblOther
                            cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblOther
                            cell.m_topConstraint.constant=45
                            cell.m_levelLbl.isHidden=false
                            cell.m_levelLbl.text="Other"
                            
                            //            tertiaryResultsDictArray?.append(m_resultDict as! [String : String])
                           
                            cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_Yellow")
                            
                            break
                        
                        case "Nursing"?:
                            
                            cell.m_colorCodeLbl.isHidden=false
                            cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblOther
                            cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblOther
                            cell.m_topConstraint.constant=45
                            cell.m_levelLbl.isHidden=false
                            cell.m_levelLbl.text="Other"
                            
                            //            tertiaryResultsDictArray?.append(m_resultDict as! [String : String])
                           
                            cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_Yellow")
                            
                            break
                            
                        case "-":
                            
                            cell.m_colorCodeLbl.isHidden=true
                            cell.m_levelLbl.isHidden=true
                            cell.m_topConstraint.constant=15
                            
                            cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_Yellow")
                            
                            break
                        case "":
                            cell.m_levelLbl.isHidden=true
                            cell.m_colorCodeLbl.isHidden=true
                            cell.m_topConstraint.constant=15
                            cell.badgeImageView.image  = #imageLiteral(resourceName: "Badge_Yellow")
                            
                            break
                            
                        default:
                            cell.m_colorCodeLbl.isHidden=false
                            cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblOther
                            cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblOther
                            cell.m_topConstraint.constant=45
                            cell.m_levelLbl.isHidden=false
                            cell.m_levelLbl.text="Other"
                            
                            //            tertiaryResultsDictArray?.append(m_resultDict as! [String : String])
                           
                            cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_Yellow")
                            break
                        }
                        
                        //Added by Geeta
                        cell.numberLbl.text = (indexPath.row).description
    //                    if indexPath.row < distanceArray.count {
    //                        cell.distanceLbl.text = "\(distanceArray[indexPath.row]) km"
    //                    }
                        

                        print("Current location : latitude :\(latitude!) longitude:\(longitude!)")
                         let lat1:Double = latitude
                         let lon1:Double = longitude

                         let lat2 = Double(m_resultDict.value(forKey: "LATITUDE") as! String) ?? 0.0
                         let lon2 = Double(m_resultDict.value(forKey: "LONGITUDE") as! String) ?? 0.0
                        
                        if lat2 == 0 || lat2 == 0.0 || lon2 == 0 || lon2 == 0.0 {
                            cell.distanceLbl.text = "- km"
                        }else{
                             let R = 6378137.00
                            
                             let dLat = (lat2 - lat1) * .pi / 180
                             let dLon = (lon2 - lon1) * .pi / 180
                             let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180) * sin(dLon / 2) * sin(dLon / 2)
                             let c = 2 * atan2(sqrt(a), sqrt(1 - a))
                             let d = (R * c)
                             if d > 0 {
                                let c = Double(round(d)/1000)
                                let arr = String(round(c)).components(separatedBy: ".")
                                if arr.count > 0{
                                    cell.distanceLbl.text = "\(arr[0]) km"
                                }else{
                                    cell.distanceLbl.text = "\(round(c)) km"
                                }
                             }else{
                                cell.distanceLbl.text = "- km"
                             }
                         }
                        //......
                        
                        cell.m_smsButton.layer.borderWidth = 0
                        cell.m_showMapButton.layer.borderWidth = 0
                        
                        cell.m_smsButton.tag=indexPath.row
                        cell.m_showMapButton.tag=indexPath.row
                        cell.m_smsButton.addTarget(self, action: #selector(smsButtonClicked(sender:)), for: .touchUpInside)
                        cell.m_showMapButton.addTarget(self, action: #selector(showMapButtonClicked(sender:)), for: .touchUpInside)
                    }
                    
                }else{
                                
                        if resultsDictArray.count > indexPath.row - 1 {
                            m_resultDict = resultsDictArray[indexPath.row-1] as NSDictionary
                            cell.m_nameLbl.text=m_resultDict.value(forKey: "HOSP_NAME") as? String
                            var address = m_resultDict.value(forKey: "HOSP_ADDRESS") as? String
                            address = address?.replacingOccurrences(of: "NOT AVALIABLE", with: "")
                            cell.m_locationLbl.text=address
                            
                            //        cell.m_contactDetailsLbl.text=m_resultDict.value(forKey: "HOSP_PHONE_NO") as? String
                            
                            
                            
                            var contactNumber = m_resultDict.value(forKey: "HOSP_PHONE_NO") as? String
                            contactNumber = contactNumber?.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890").inverted)
                            if(contactNumber=="")
                            {
                                cell.m_contactNumberButton.setTitle("-", for: .normal)
                            }
                            else
                            {
                                cell.m_contactNumberButton.setTitle(contactNumber, for: .normal)
                            }
                            cell.m_contactNumberButton.addTarget(self, action: #selector(contactButtonTapped), for: .touchUpInside)
                            
                            //        cell.m_levelButton.layer.masksToBounds=true
                            //        cell.m_levelButton.layer.cornerRadius=12.6
                            //        cell.m_levelButton.isUserInteractionEnabled = true
                            //        cell.m_levelButton.becomeFirstResponder()
                            //        cell.m_levelButton.tag=indexPath.row
                            //        cell.m_levelButton.addTarget(self, action: #selector(levelButtonTapped), for: .touchUpInside)
                            
                            let level = m_resultDict.value(forKey: "HOSP_LEVEL_OF_CARE") as? String
                            
                            switch level
                            {
                            case "Primary"?:
                                
                                cell.m_colorCodeLbl.isHidden=false
                                
                                cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblPrimary
                                cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblPrimary
                                cell.m_topConstraint.constant=45
                                cell.m_levelLbl.isHidden=false
                                cell.m_levelLbl.text=level!+" "+"careLbl".localized()
                                
                                //            primaryResultsDictArray?.append(m_resultDict as! [String : String])
                                
                                cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_Blue")
                                
                                break
                            case "Secondary"?:
                                
                                cell.m_colorCodeLbl.isHidden=false
                                cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblSecondary
                                cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblSecondary
                                cell.m_topConstraint.constant=45
                                cell.m_levelLbl.isHidden=false
                                cell.m_levelLbl.text=level!+" "+"careLbl".localized()
                                
                                //            secondaryResultsDictArray?.append(m_resultDict as! [String : String])
                                
                                cell.badgeImageView.image=#imageLiteral(resourceName: "Badge_MGreen")
                                
                                break
                            case "Tertiary"?:
                                
                                cell.m_colorCodeLbl.isHidden=false
                                cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblTertiary
                                cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblTertiary
                                cell.m_topConstraint.constant=45
                                cell.m_levelLbl.isHidden=false
                                cell.m_levelLbl.text=level!+" "+"careLbl".localized()
                                
                                //            tertiaryResultsDictArray?.append(m_resultDict as! [String : String])
                                
                                cell.badgeImageView.image=#imageLiteral(resourceName: "Badge_Red")
                                
                                
                                break
                                
                            case "NOT AVAILABLE"?:
                                
                                cell.m_colorCodeLbl.isHidden=false
                                cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblOther
                                cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblOther
                                cell.m_topConstraint.constant=45
                                cell.m_levelLbl.isHidden=false
                                cell.m_levelLbl.text="Other"
                                
                                //            tertiaryResultsDictArray?.append(m_resultDict as! [String : String])
                                
                                cell.badgeImageView.image=#imageLiteral(resourceName: "Badge_Yellow")
                                
                                break
                                
                            case "Not Applicable"?:
                                
                                cell.m_colorCodeLbl.isHidden=false
                                cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblOther
                                cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblOther
                                cell.m_topConstraint.constant=45
                                cell.m_levelLbl.isHidden=false
                                cell.m_levelLbl.text="Other"
                                
                                //            tertiaryResultsDictArray?.append(m_resultDict as! [String : String])
                               
                                cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_Yellow")
                                
                                break
                            
                            case "Nursing"?:
                                
                                cell.m_colorCodeLbl.isHidden=false
                                cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblOther
                                cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblOther
                                cell.m_topConstraint.constant=45
                                cell.m_levelLbl.isHidden=false
                                cell.m_levelLbl.text="Other"
                                
                                //            tertiaryResultsDictArray?.append(m_resultDict as! [String : String])
                               
                                cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_Yellow")
                                
                                break
                                
                                
                            case "-":
                                
                                cell.m_colorCodeLbl.isHidden=true
                                cell.m_levelLbl.isHidden=true
                                cell.m_topConstraint.constant=15
                                
                                cell.badgeImageView.image=#imageLiteral(resourceName: "Badge_Yellow")
                                
                                break
                            case "":
                                cell.m_levelLbl.isHidden=true
                                cell.m_colorCodeLbl.isHidden=true
                                cell.m_topConstraint.constant=15
                                cell.badgeImageView.image=#imageLiteral(resourceName: "Badge_Yellow")
                                
                                break
                                
                            default:
                                cell.m_colorCodeLbl.isHidden=false
                                cell.m_levelLbl.textColor = FontsConstant.shared.HosptailLblOther
                                cell.m_colorCodeLbl.backgroundColor = FontsConstant.shared.HosptailLblOther
                                cell.m_topConstraint.constant=45
                                cell.m_levelLbl.isHidden=false
                                cell.m_levelLbl.text="Other"
                                
                                //            tertiaryResultsDictArray?.append(m_resultDict as! [String : String])
                               
                                cell.badgeImageView.image = #imageLiteral(resourceName: "Badge_Yellow")
                                break
                            }
                            
                            //Added by Geeta
                            cell.numberLbl.text = (indexPath.row).description
        //                    if indexPath.row < distanceArray.count {
        //                        cell.distanceLbl.text = "\(distanceArray[indexPath.row]) km"
        //                    }
                            
                            print("Current location : latitude :\(latitude!) longitude:\(longitude!)")
                             let lat1:Double = latitude
                             let lon1:Double = longitude

                             let lat2 = Double(m_resultDict.value(forKey: "LATITUDE") as! String) ?? 0.0
                             let lon2 = Double(m_resultDict.value(forKey: "LONGITUDE") as! String) ?? 0.0
                            
                            if lat2 == 0 || lat2 == 0.0 || lon2 == 0 || lon2 == 0.0 {
                                cell.distanceLbl.text = "- km"
                            }else{
                                 let R = 6378137.00
                                
                                 let dLat = (lat2 - lat1) * .pi / 180
                                 let dLon = (lon2 - lon1) * .pi / 180
                                 let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180) * sin(dLon / 2) * sin(dLon / 2)
                                 let c = 2 * atan2(sqrt(a), sqrt(1 - a))
                                 let d = (R * c)
                                 if d > 0 {
                                    let c = Double(round(d)/1000)// need to round(c) also
                                    let arr = String(round(c)).components(separatedBy: ".")
                                    if arr.count > 0{
                                        cell.distanceLbl.text = "\(arr[0]) km"
                                    }else{
                                        cell.distanceLbl.text = "\(round(c)) km"
                                    }
                                    
                                 }else{
                                    cell.distanceLbl.text = "- km"
                                 }
                             }
                            //......
                            
                            cell.m_smsButton.layer.borderWidth = 0
                            cell.m_showMapButton.layer.borderWidth = 0
                            
                            cell.m_smsButton.tag=indexPath.row
                            cell.m_showMapButton.tag=indexPath.row
                            cell.m_smsButton.addTarget(self, action: #selector(smsButtonClicked(sender:)), for: .touchUpInside)
                            cell.m_showMapButton.addTarget(self, action: #selector(showMapButtonClicked(sender:)), for: .touchUpInside)
                        } //else
                    }
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            shadowForCell(view: cell.m_backGroundView)
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            return cell
        }
        else
        {
            let cell : SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchTableViewCell
            if(StatusHolder.getSharedInstance().m_searchArray.count>0)
            {
                cell.m_searchNameLbl.text = StatusHolder.getSharedInstance().m_searchArray[indexPath.row]
            }
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView==m_searchTableview)
        {
            m_searchBar.text=StatusHolder.getSharedInstance().m_searchArray[indexPath.row]
            m_searchBar.endEditing(true)
            
        }
    }
    
    
    //willDisplay by geeta
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           //spinner.startAnimating()
        if isNearBy {
                   if indexPath.row == resultsDictArrayNew.count-1 {
                      print(" we r at last cell load more content")
                    
                    if resultsDictArrayNew.count < m_nearbyHospitalsArrayNew.count{
                           print("we need to bring more record which r pending")
                           var index  = resultsDictArrayNew.count
                            limit = index + 2
                        
                         while index < limit && index < m_nearbyHospitalsArrayNew.count {
                            //if index != resultsDictArray.count {
                                resultsDictArrayNew.append(m_nearbyHospitalsArrayNew[index]) // append from main array
                                index = index + 1
                            //}
                           }
                           print("resultsDictArrayNew count : \(resultsDictArrayNew.count)")
                           self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
                       }
                   }
               }else{
                   if indexPath.row == resultsDictArrayNew.count-1 {
                      print(" we r at last cell load more content")
                    
                    if resultsDictArrayNew.count < resultsDictArray.count{
                           print("we need to bring more record which r pending")
                           var index  = resultsDictArrayNew.count
                            limit = index + 2
                        
                        while index < limit && index < resultsDictArray.count{
                            //if index != resultsDictArray.count {
                                resultsDictArrayNew.append(resultsDictArray[index]) // append from main array
                                index = index + 1
                            //}
                           }
                           print("resultsDictArrayNew count : \(resultsDictArrayNew.count)")
                          
                           self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
                           
                       }
                   
                   }
//                    if resultsDictArrayNew.count == resultsDictArray.count {
//                        spinner.stopAnimating()
//                    }
        }
}
    
    
    @objc func loadTable (){
        self.m_tableview.reloadData()
    }
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    //    {
    //
    //        if let postCell = cell as? NetworkHospitalsTableViewCell
    //        {
    //            self.tableView(tableView: m_tableview, willDisplayMyCell: postCell, forRowAtIndexPath: indexPath as NSIndexPath)
    //        }
    //
    //    }
    //    private func tableView(tableView: UITableView, willDisplayMyCell myCell: NetworkHospitalsTableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    //    {
    //        TipInCellAnimator.animate(cell: myCell)
    //    }
    
    @objc internal func levelButtonTapped(sender:UIButton)
    {
        
        sender.becomeFirstResponder()
        
        m_resultDict = resultsDictArray[sender.tag] as NSDictionary
        
        let level = m_resultDict.value(forKey: "HospitalLevelOfCare") as? String
        menuController.menuItems = [
            UIMenuItem(
                title: level!,
                action: #selector(handleCustomAction(_:))
            )
        ]
        
        menuController.setTargetRect(sender.frame, in: sender.superview!)
        menuController.setMenuVisible(true, animated: true)
    }
    @objc func contactButtonTapped(sender:UIButton)
    {
        var number = sender.titleLabel?.text?.replacingOccurrences(of:" ", with: "", options: NSString.CompareOptions.literal, range: nil)
        number = number?.replacingOccurrences(of:"+91", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        if let url = URL(string: "tel://"+number!), UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10, *)
            {
                UIApplication.shared.open(url)
            }
            else
            {
                UIApplication.shared.openURL(url)
            }
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    @objc internal func handleCustomAction(_ controller: UIMenuController)
    {
        print("Custom action!")
    }
    
    func sendAddress()
    {
        let alertController = UIAlertController(title: "smsAddr".localized(), message:"smsAddrMsg" .localized(), preferredStyle: UIAlertControllerStyle.alert)
        
        
        /*
         To get location and contact details of this hospital messaged to your phone, enter your mobile number below. You can add multiple mobile numbers separated by commas.*/
        
        
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
        }
        alertController.view.tintColor=hexStringToUIColor(hex: hightlightColor)
        alertController.view.layer.masksToBounds=true
        alertController.view.layer.cornerRadius=25
        let okAction = UIAlertAction(title: "submit".localized(), style: UIAlertActionStyle.default)
        { (result : UIAlertAction) -> Void in
            
            
            
            self.displayActivityAlert(title: "sentMsg".localized())
            //            self.ale
            /* if((number.count == 10)
             {
             
             
             let test = (MyConstant.appsendsms + (alertController.textFields?.first?.text)! + "&from=MYBFTS&text="  + (sender as! String) as? String)! + ". Regards, MyBenefits.&selfid=true&alert=1&dlrreq=true"
             
             let urlwithPercentEscapes = test.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
             
             let url2:URL=URL(string:urlwithPercentEscapes!)!
             
             //"http://www.mybenefits360.com/appservice/hospitalService.svc/getproviders/881/285/mumbai/10/20" )!
             
             
             Alamofire.request(url2).response
             { response in
             if(response.data != nil)
             {
             print("hello")
             self.view.makeToast("Hospital Address Send successfully ", duration: 4.0, position: .center)
             }
             else
             {
             print(response.error)
             self.view.makeToast("Fail to send Address ", duration: 4.0, position: .center)
             return
             }
             }
             return
             }
             else
             {
             self.view.makeToast("Mobile Number should be 10 digit ", duration: 4.0, position: .center)
             return
             }*/
            
            
            
            
            
        }
        
        
        
        
        alertController.addTextField
            {
                (textField : UITextField) -> Void in
                // textField.secureTextEntry = true
                //                textField.layer.masksToBounds=true
                //                textField.layer.cornerRadius=10
                //                textField.layer.borderColor=UIColor.lightGray.cgColor
                //                textField.layer.borderWidth=1
                textField.placeholder = "mobNoPlaceholder".localized()
                textField.keyboardType = UIKeyboardType.numbersAndPunctuation
                
                textField.delegate = self
                
                
                NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using:
                    {_ in
                        // Being in this block means that something fired the UITextFieldTextDidChange notification.
                        
                        // Access the textField object from alertController.addTextField(configurationHandler:) above and get the character count of its non whitespace characters
                        let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count ?? 0
                        let textIsNotEmpty = textCount == 10
                        print(textIsNotEmpty)
                        // If the text contains non whitespace characters, enable the OK Button
                        okAction.isEnabled = textIsNotEmpty
                        
                        
                        
                        /* if let number = alertController.textFields![0].text
                         {
                         
                         let mobileNumberArray = number.components(separatedBy:",")
                         for mobileNumberString in mobileNumberArray
                         {
                         if mobileNumberString.contains(" ")
                         {
                         self.displayActivityAlert(title: "Space not allowed")
                         }
                         else if(number.isPhoneNumber)
                         {
                         okAction.isEnabled =  true
                         self.displayActivityAlert(title: "Address sent successfully")
                         }
                         else
                         {
                         self.displayActivityAlert(title: "Enter valid mobile number")
                         }
                         }
                         }*/
                        
                        
                })
                
                
                
                
        }
        
        
        okAction.isEnabled =  false
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    @objc func smsButtonClicked(sender:UIButton)
    {
        Bundle.main.loadNibNamed("SMSAddressView", owner: self, options: nil)
        m_SMSView.frame.size.width=self.view.frame.size.width
        m_SMSView.frame.size.height=view.frame.size.height
        //        m_SMSView.backgroundColor = UIColor.black
        
        m_SMSAddressSubView.layer.masksToBounds = true
        m_SMSAddressSubView.layer.cornerRadius=14;
        
        m_SMSView.isUserInteractionEnabled = true
        let myColor : UIColor = UIColor.lightGray
        m_SMSAddressTextView.layer.borderColor = myColor.cgColor
        m_SMSAddressTextView.layer.borderWidth = 1.0
        m_SMSAddressTextView.layer.cornerRadius = 8
        m_SMSAddressTextView.keyboardType = .numbersAndPunctuation
        m_SMSAddressTextView.delegate=self
        
        self.view.addSubview(m_SMSView)
    }
    @IBAction func cancelAddressButtonClicked(_ sender: Any)
    {
        m_SMSView.removeFromSuperview()
    }
    @IBAction func submitAddressButtonClicked(_ sender: Any)
    {
        if let number = m_SMSAddressTextView.text
        {
            var valid = Bool()
            let mobileNumberArray = number.components(separatedBy:",")
            for mobileNumberString in mobileNumberArray
            {
                if mobileNumberString.contains(" ")
                {
                    valid = false
                    self.displayActivityAlert(title: "mobNoValidationMsg1".localized())
                    return
                }
                else if(mobileNumberString.isPhoneNumber)
                {
                    valid = true
                }
                else
                {
                    valid=false
                    self.displayActivityAlert(title: "mobNoValidationMsg2".localized())
                    return
                }
            }
            if(valid)
            {
                m_SMSView.removeFromSuperview()
                self.displayActivityAlert(title: "addrSentMsg".localized())
            }
        }
    }
    @objc func showMapButtonClicked(sender:UIButton)
    {
        //isNearBy = false
        
        /*showPleaseWait()
         m_resultDict=resultsDictArray![sender.tag] as NSDictionary
         let address = m_resultDict["HospitalAddress"]
         
         print(address,m_resultDict)
         let geocoder = CLGeocoder()
         geocoder.geocodeAddressString(address as! String)
         {
         placemarks, error in
         let placemark = placemarks?.first
         let lat = placemark?.location?.coordinate.latitude
         let lon = placemark?.location?.coordinate.longitude
         print("Lat: \(lat), Lon: \(lon)")
         
         if(lat != nil || lon != nil)
         {
         
         let regionDistance : CLLocationDistance = 1000
         let cordinates = CLLocationCoordinate2DMake(lat!, lon!)
         let reginspan = MKCoordinateRegionMakeWithDistance(cordinates, regionDistance, regionDistance)
         let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: reginspan.center),
         MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: reginspan.span)]
         
         let placemarks = MKPlacemark(coordinate: cordinates, addressDictionary: nil)
         let mapItem = MKMapItem(placemark: placemarks )
         mapItem.name = address as? String
         mapItem.openInMaps(launchOptions: options)
         
         
         
         }
         else
         {
         self.displayActivityAlert(title: "No maps found")
         
         
         }
         self.hidePleaseWait()
         }*/
        
        if isNearBy{
            if m_nearbyHospitalsArrayNew.count>0{
                self.m_resultDict = m_nearbyHospitalsArrayNew[sender.tag - 1] as! NSDictionary //return m_nearbyHospitalsArrayNew.count
            }
            //return 0
        }else{
            if(!isfromSearchString)//if nearby
            {
                if((resultsDictArray.count)>9)
                {
                    self.m_resultDict = resultsDictArrayNew[sender.tag - 1] as! NSDictionary//return resultsDictArrayNew.count
                    //return 10
                }
                else
                {
                    self.m_resultDict = resultsDictArray[sender.tag - 1] as! NSDictionary//return (resultsDictArray.count + 1)
                }
            }
            else
            {
                //print("FOR search Result",resultsDictArrayNew.count)
                //return (resultsDictArrayNew.count)+1
                //print("FOR search Result",resultsDictArray.count)
                self.m_resultDict = resultsDictArray[sender.tag - 1] as! NSDictionary//return (resultsDictArray.count)+1
            }
        }
        print("m_resultDict data: ",self.m_resultDict)
        let lat2 = Double(self.m_resultDict.value(forKey: "LATITUDE") as! String) ?? 0.0
        let lon2 = Double(self.m_resultDict.value(forKey: "LONGITUDE") as! String) ?? 0.0
        
        print("Converted lat2 :",lat2," lon2:",lon2)
        
        if lat2 == 0 || lat2 == 0.0 || lon2 == 0 || lon2 == 0.0 {
            //displayActivityAlert(title: "No latitude and longitude found.")
            let mapVC: MapViewControllerNew = MapViewControllerNew()
            if isNearBy{
                m_resultDict=m_nearbyHospitalsArrayNew[sender.tag-1] as NSDictionary
                mapVC.m_resultDict=m_resultDict
            }else{
                m_resultDict=resultsDictArray[sender.tag-1] as NSDictionary
                mapVC.m_resultDict=m_resultDict
            }
            
            navigationController?.pushViewController(mapVC, animated: true)
        }else{
            let mapVC: MapViewControllerNew = MapViewControllerNew()
            if isNearBy{
                m_resultDict=m_nearbyHospitalsArrayNew[sender.tag-1] as NSDictionary
                mapVC.m_resultDict=m_resultDict
            }else{
                m_resultDict=resultsDictArray[sender.tag-1] as NSDictionary
                mapVC.m_resultDict=m_resultDict
            }
            
            navigationController?.pushViewController(mapVC, animated: true)
        }
//        let lat2 = Double(mapVC.m_resultDict.value(forKey: "Latitude") as! String) ?? 0.0
//        let lon2 = Double(mapVC.m_resultDict.value(forKey: "Longitude") as! String) ?? 0.0
//
//        if lat2 == 0 || lat2 == 0.0 || lon2 == 0 || lon2 == 0.0 {
//           displayActivityAlert(title: "Location not found")
//        }else{
//           //navigationController?.pushViewController(mapVC, animated: true)
//
//
//
//            let address = m_resultDict["HospitalAddress"]
//
//            let lat = self.m_resultDict["Latitude"]
//            let lon = self.m_resultDict["Longitude"]
//            let lat1 :NSString = lat as! NSString
//            let lon1 :NSString = lon as! NSString
//
//            print("Lat: \(lat), Lon: \(lon)")
//
//
//            if(lat != nil && lon != nil)
//            {
//                //Apple Map Address -> Coordnate
//                var geocoder = CLGeocoder()
//                geocoder.geocodeAddressString(address as! String) {
//                    placemarks, error in
//                    let placemark = placemarks?.first
//                    let lat = placemark?.location?.coordinate.latitude
//                    let lon = placemark?.location?.coordinate.longitude
//                    print("Lat: \(lat), Lon: \(lon)")
//                }
//
//                //Apple Map Coordnate - > Address
//                let latitude:CLLocationDegrees =  lat1.doubleValue
//                let longitude:CLLocationDegrees =  lon1.doubleValue
//
//                let regionDistance:CLLocationDistance = 10000
//                let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
//                let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
//                let options = [
//                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
//                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
//                ]
//                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
//                let mapItem = MKMapItem(placemark: placemark)
//                mapItem.name = address as? String
//                mapItem.openInMaps(launchOptions: options)
//
//
//
//            }
//            else
//            {
//                //self.mapNotFoundImageView.isHidden=false
//            }
//            self.hidePleaseWait()
//        }
         
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
       
        m_searchTableview.isHidden=true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(tableView==m_tableview)
        {
            if(indexPath.row==0)
            {
                if(m_primaryArray.count==0 && m_seconadryArray.count==0 && m_tertiaryArray.count==0 && m_otherArray.count==0)
                {
                    return 130
                }
                else
                {
                    return 210
                }
            }
            
        }
        
        return UITableViewAutomaticDimension
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if(textField.tag==3)
        {
            textField.resignFirstResponder()
            return true
        }
        
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if(textView.text=="Enter Mobile Number")
        {
            m_SMSAddressTextView.text=""
        }
        //        m_SMSAddressTextView.text=""
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        m_SMSView.endEditing(true)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text=="\n")
        {
            view.endEditing(true)
        }
        
        let MAX_LENGTH_PHONENUMBER = 100
        let ACCEPTABLE_NUMBERS     = "0123456789,"
        let newLength: Int = textView.text!.characters.count + text.characters.count - range.length
        
        
        let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
        let strValid = text.rangeOfCharacter(from: numberOnly) == nil
        return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
    }
    
    
    //MARK:- Search Bar delegate
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
        if var searchString = searchBar.text
        {
            isfromSearchString = true
            
            print("selectedIndexPath: ",selectedIndexPath)
            let indexpath = IndexPath(row: selectedIndexPath, section: 0)
            let cell1 = m_tableview.cellForRow(at: indexpath) as? NetworkHospitalsTableViewCell
            cell1?.m_primaryCountButton.backgroundColor = UIColor.white
            cell1?.m_secondaryCountButton.backgroundColor = UIColor.white
            cell1?.m_tertiaryCountButton.backgroundColor = UIColor.white
            cell1?.m_OtherCountButton.backgroundColor = UIColor.white

            
            print("searchString : ",searchString)
            if searchString.contains(" "){
                searchString = searchString.replacingOccurrences(of: " ", with: "%20")
            }
            print("searchString without space: ",searchString)
            if searchString.count == 0 || searchString == " " || searchString == ""{
                searchString = "All"
            }
            if(searchString.count>0 && searchString != " " && searchString != "All")
            {
                isSearchNearby = true
                isNearBy = false
                
                //                getHospitalDetails(searchString: searchString)
                //getPostHospitalDetails(searchString: searchString)
                print("searchString: ",searchString)
                //getPostHospitalDetailsPortal(searchString: searchString)
                
                getPostHospitalDetailsPortalJson(searchString: searchString)
                if(StatusHolder.sharedInstance.m_searchArray.contains(searchString))
                {
                    
                }
                else
                {
                    if(StatusHolder.sharedInstance.m_searchArray.count==10)
                    {
                        StatusHolder.sharedInstance.m_searchArray.remove(at: 9)
                        StatusHolder.sharedInstance.m_searchArray.insert(searchString, at: 0)
                        
                    }
                    else
                    {
                        StatusHolder.sharedInstance.m_searchArray.insert(searchString, at: 0)
                        
                    }
                }
                
            }
            //m_searchTableview.isHidden=true
            //m_searchBar.isHidden=true
            m_nearbyHospitalsButton.isHidden=true
            m_orLbl.isHidden=true
            //m_tableVIewConstraintWithSuperview.constant=0
            
            
            //            m_nearbyHospitalsButton.isHidden=true
            //            serachNearbyButtonTopConstraint.constant=180
            //            m_tableViewTopConstraint.constant=15
            //            displayActivityAlert(title: "Data not found")
            
        }
        
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        
        
        self.navigationItem.title="Hospital Details"
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
        //        getHospitalDetails(searchString: searchBar.text!)
        print("selectedIndexPath: ",selectedIndexPath)
        let indexpath = IndexPath(row: selectedIndexPath, section: 0)
        let cell = m_tableview.cellForRow(at: indexpath) as? NetworkHospitalsTableViewCell
        cell?.m_primaryCountButton.backgroundColor = UIColor.white
        cell?.m_secondaryCountButton.backgroundColor = UIColor.white
        cell?.m_tertiaryCountButton.backgroundColor = UIColor.white
        cell?.m_OtherCountButton.backgroundColor = UIColor.white
        
//        if searchBar.text == "" {
//            print("Inside searchBar: ")
//            DispatchQueue.main.async {
//                self.hospitalActivityIndicator.stopAnimating()
//                self.hospitalActivityIndicator.isHidden = true
//                self.m_noInternetView.isHidden=false
//                self.topNoInternetVew.constant = 20
//                self.m_emptyStateImageView.image=UIImage(named: "Nohospital");         self.m_emptyStateTitleLbl.text = ""
//        m_emptyStateTitleLbl_Height.constant= 0

//                self.m_emptyStateDetailsLbl.text="DataNotFoundErrorMsg".localized()
//                self.TopHeaderBackgroundView.isHidden=true
//                self.m_nearbyHospitalsButton.isHidden=true
//                //self.serachNearbyButtonTopConstraint.constant=50
//                self.m_tableview.isHidden=false
//                self.m_tableview.reloadData()
        
//            }
//        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        
        if(StatusHolder.getSharedInstance().m_searchArray.count>0)
        {
            m_searchTableview.isHidden=false
            self.view.addSubview(m_searchTableview)
            m_searchTableview.reloadData()
            
        }
        let count = resultsDictArray.count
        
        m_nearbyHospitalsButton.isHidden=true
        if(count>0)
        {
            
            m_orLbl.isHidden=false
        }
        else
        {
            
            m_orLbl.isHidden=true
        }
        
        
        
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        m_nearbyHospitalsButton.isHidden=true
        m_orLbl.isHidden=true
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let MAX_LENGTH_PHONENUMBER = 10
        let ACCEPTABLE_NUMBERS     = "0123456789"
        let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
        
        let numberOnly = NSCharacterSet.init(charactersIn: ACCEPTABLE_NUMBERS).inverted
        let strValid = string.rangeOfCharacter(from: numberOnly) == nil
        return (strValid && (newLength <= MAX_LENGTH_PHONENUMBER))
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
            //resultsDictArray.append(currentDictionary!)
            self.currentDictionary = [:]
            
        }
        else if(elementName=="Hospitals")
        {
            resultsDictArray.append(currentDictionary!)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        
        //if(StatusHolder.getSharedInstance().m_searchArray.contains(searchText))
        //        {
        //            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: searchText)
        //            let range:NSRange = NSMakeRange(0, searchText.characters.count)
        //            let pattern = "(\(searchText))"
        //            let regex = try! NSRegularExpression( pattern: pattern, options: NSRegularExpression.Options())
        //            regex.enumerateMatches(
        //                in: searchText,
        //                options: NSRegularExpression.MatchingOptions(),
        //                range: range,
        //                using: {
        //                    (textCheckingResult, matchingFlags, stop) -> Void in
        //                    let subRange = textCheckingResult?.range
        //                    attributedString.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey, value: UIColor.red, range: subRange!)
        //
        //                    m_searchTableview.reloadData()
        //            }
        //            )
        //        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        
        
        DispatchQueue.global(qos: .background).async{
            
            if let location:CLLocation = locations.last
            {
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                
                
                var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
                let ceo: CLGeocoder = CLGeocoder()
                center.latitude = self.latitude
                center.longitude = self.longitude
                
                let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
                
                
                ceo.reverseGeocodeLocation(loc, completionHandler:
                    {(placemarks, error) in
                        if (error != nil)
                        {
                            print("reverse geocode fail: \(error!.localizedDescription)")
                            self.hidePleaseWait()
                        }
                        else
                        {
                            do
                            {
                                if let pm = placemarks
                                {
                                    if pm.count > 0
                                    {
                                        if let pm = placemarks?[0]
                                        {
                                            if let subLocality = pm.postalCode
                                            {
                                                self.m_subLocality=subLocality
                                                var addressString : String = ""
                                                if pm.locality != nil
                                                {
                                                    addressString = addressString + pm.locality!
                                                }
                                                print(addressString)
                                                self.m_addressString=addressString
                                                if self.m_addressString != nil || self.m_addressString != ""{
                                                     //self.getPostHospitalDetails(searchString: self.m_addressString)
                                                }
                                                //                                    self.hidePleaseWait()
                                            }
                                            else
                                            {
                                                self.hidePleaseWait()
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                }
                                
                            }
                            catch
                            {
                                Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                                //                            self.displayActivityAlert(title: m_errorMsg)
                            }
                            
                        }
                })
            }
            
        }
        
        
        
        
    }
    @objc func searchNearbyHospitalsButtonClicked(sender: UIButton)
    {
        if(self.latitude==nil)
        {
            
        }
        else
        {
            //isSearchNearby = true
           // self.getPostHospitalDetails(searchString: self.m_addressString)
            
            //added by geeta
            if isNearBy == true {
                isNearBy = false
            } else {
                isNearBy = true
            }
            
            m_tableview.reloadData()
            
            
            /*
             let center = CLLocationCoordinate2DMake(self.latitude, self.longitude)
             let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
             let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
             let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)*/
        }
        /* let config = GMSPlacePickerConfig(viewport: viewport)
         self.placePicker = GMSPlacePicker(config: config)
         
         // 2
         placePicker.pickPlaceWithCallback { (place: GMSPlace?, error: NSError?) -> Void in
         
         if let error = error {
         print("Error occurred: \(error.localizedDescription)")
         return
         }
         // 3
         if let place = place {
         let coordinates = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
         let marker = GMSMarker(position: coordinates)
         marker.title = place.name
         marker.map = self.googleMapView
         self.googleMapView.animateToLocation(coordinates)
         } else {
         print("No place was selected")
         }
         }*/
    }
    @IBAction func searchNearbyHospitalsButtonClicked(_ sender: Any)
    {
        if(self.latitude==nil)
        {
            
        }
        else if(self.m_addressString=="")
        {
            displayActivityAlert(title: "Not getting your current location. Please try again")
        }
        else
        {
            isSearchNearby = true
            m_tableVIewConstraintWithSuperview.constant=0
            
            //self.getPostHospitalDetails(searchString: self.m_addressString)
            //self.getPostHospitalDetailsPortal(searchString: self.m_addressString)
            self.getPostHospitalDetailsPortalJson(searchString: self.m_addressString)
        }
    }
    
}

