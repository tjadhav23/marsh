//
//  MapViewController.swift
//  MyBenefits
//
//  Created by Semantic on 07/06/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit

class MapViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var mapNotFoundImageView: UIImageView!
    @IBOutlet weak var m_addressLbl: UILabel!
    var m_resultDict = NSDictionary()
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title="link5Name".localized()
        navigationItem.leftBarButtonItem = getBackButton()
       
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
    }
    func getLeftBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:UIImage(named: "menu"), style: .plain, target: self, action: #selector(leftButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func leftButtonClicked()
    {
       
        
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        tabBarController!.selectedIndex = 2
    }
    
    @objc override func backButtonClicked()
    {
        
        self.tabBarController?.tabBar.isHidden=false
        menuButton.isHidden=false
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        showPleaseWait(msg: "Please wait...")
       print(m_resultDict)
        let address = m_resultDict["HospitalAddress"]
        
        m_addressLbl.text=address as? String
        
//        print(address,m_resultDict)
       
        /*let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address as! String)
            {
                
            placemarks, error in
                
                
            let placemark = placemarks?.first
               
//            let lat = placemark?.location?.coordinate.latitude
//            let lon = placemark?.location?.coordinate.longitude
                
                let lat = self.m_resultDict["Latitude"]
                let lon = self.m_resultDict["Longitude"]
                let lat1 :NSString = lat as! NSString
                let lon1 :NSString = lon as! NSString
            print("Lat: \(lat), Lon: \(lon)")
          */
        
        //Map Lat log search on the bases of address
        
        let address1 = self.m_resultDict["HospitalAddress"] as? String ?? ""
  
        var hospitalName  = self.m_resultDict["HospitalName"] as? String ?? ""
        var lat = self.m_resultDict["Latitude"] as? String ?? "37.7749"
        var long = self.m_resultDict["Longitude"] as? String ?? "-122.4194"
            
        let hospitalNameAddress = hospitalName+","+address1
        var addressArray : [String] = address1.components(separatedBy: ",")
        let Address = addressArray.suffix(3)//"\(addressArray.last - 1),\(addressArray.last - 0),\(addressArray.last)"
        print(Address)
        let AddressJoined : String = Address.joined(separator: ",")
         
            print("Map hospitalName ",AddressJoined)
            //hospitalName = "4 Bradford St, Perth WA 6050"
        if lat.uppercased() == "NOT AVAILABLE" || long.uppercased() == "NOT AVAILABLE"{
            let geocoder = CLGeocoder()

            geocoder.geocodeAddressString(AddressJoined, completionHandler: {(placemarks, error) -> Void in
                print("Map placemarks ",placemarks)
           
               if((error) != nil){
                  print("Error", error)
                   self.displayActivityAlert(title: "Location not found")
                   self.navigationController?.popViewController(animated: true)
               }
               if let placemark = placemarks?.first {
                  let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                   print("Place: ",placemarks)
                   print("coor: 111 ",coordinates)
               
                   let lat = placemark.location?.coordinate.latitude
                   let lon = placemark.location?.coordinate.longitude
                   print("Lat: \(lat), Lon: \(lon)")
                 
        
        
        
        
            if(lat != nil && lon != nil)
            {
                let lat1 = lat
                let lon1 = lon
                print("Lat1: \(lat1), Lon1: \(lon1)")
              
                let camera = GMSCameraPosition.camera(withLatitude: lat1!, longitude: lon1!, zoom: 15.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            self.view = mapView
            
            // Creates a marker in the center of the map.
                
            let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat1!, longitude: lon1!)
            marker.title = self.m_resultDict["HospitalName"] as? String
                placemark.subAdministrativeArea
            marker.snippet = address as? String
            marker.map = mapView
          
                self.mapNotFoundImageView.isHidden=true
            
            }
            else
            {
                self.mapNotFoundImageView.isHidden=false
            }
               }
            })
            self.hidePleaseWait()
        }else{
            let latitude: CLLocationDegrees = Double(lat)!
                    let longitude: CLLocationDegrees = Double(long)!
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        
        // Creates a marker in the center of the map.
            
        let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = self.m_resultDict["HospitalName"] as? String
            //placemark.subAdministrativeArea
        marker.snippet = address as? String
        marker.map = mapView
                    
//                    let regionDistance:CLLocationDistance = 10000
//                    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
//                    let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
//                    let options = [
//                        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
//                        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
//                    ]
//                    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
//                    let mapItem = MKMapItem(placemark: placemark)
//                    mapItem.name = "Place Name"
//                    mapItem.openInMaps(launchOptions: options)
            self.hidePleaseWait()
        }
            
     }
    
    func viewWillAppear(animated: Bool)
    {
        mapView.addObserver(self, forKeyPath: "myLocation", options:NSKeyValueObservingOptions(rawValue: 0), context:nil)
        navigationItem.rightBarButtonItem=getRightBarButton()
    }
    
   

}
