//
//  MapViewControllerNew.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 12/06/23.
//  Copyright © 2023 Semantic. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

class MapViewControllerNew: UIViewController {

    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var zoomInButton: UIButton!
    var zoomOutButton: UIButton!
    var directionButton: UIButton!
    var zoomCount: Int = 0
    var m_resultDict = NSDictionary()
    var detailView: UIView!

    var latitudeFinal = CLLocationDegrees(0.0)
    var longitudeFinal = CLLocationDegrees(0.0)
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
              self.showPleaseWait(msg: "")
      
        spinner.isHidden = false
        spinner.startAnimating()
        
        self.navigationItem.title = "link5Name".localized()
        navigationItem.leftBarButtonItem = getBackButton()
        
        self.tabBarController?.tabBar.isHidden = true
        menuButton.isHidden = true
        
        print("m_resultDict from NetworkHospital Page: ", m_resultDict)
        
        let lat2 = Double(self.m_resultDict.value(forKey: "LATITUDE") as! String) ?? 0.0
        let lon2 = Double(self.m_resultDict.value(forKey: "LONGITUDE") as! String) ?? 0.0
        
        print("Converted in Maps lat2 :",lat2," lon2:",lon2)
        
//        if lat2 == 0 || lat2 == 0.0 || lon2 == 0 || lon2 == 0.0 {
//            displayActivityAlert(title: "No latitude and longitude found.")
//            navigationController?.popViewController(animated: true)
//        }
        if lat2 == 0 || lat2 == 0.0 || lon2 == 0 || lon2 == 0.0 {
            if let hospitalNameData = m_resultDict["HOSP_NAME"] as? String,
               let hospitalAddress = m_resultDict["HOSP_ADDRESS"] as? String {
                let hospitalName = "\(hospitalNameData) " + "\(hospitalAddress)"
                
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = hospitalName
                
                let search = MKLocalSearch(request: searchRequest)
                print("search Request",searchRequest)
                search.start { [weak self] (response, error) in
                    if let error = error {
                        print("Error searching for location: \(error)")
                        self?.displayActivityAlert(title: "No latitude and longitude found!.")
                        self?.navigationController?.popViewController(animated: true)
                    } else if let mapItem = response?.mapItems.first {
                        print(" hospitalName Map: ",hospitalName)
                        print(" response Map: ",response)
                        let placemark = mapItem.placemark
                        
                        let latitude = placemark.coordinate.latitude
                        let longitude = placemark.coordinate.longitude
                        
                        print("Search by name ",hospitalName)
                        print("latitude: ",latitude," longitude:",longitude)
                        
                        self?.latitudeFinal = latitude
                        self?.longitudeFinal = longitude
                        self?.openMap()
                    }
                    
                }
                
            }

        }
        else{
            guard let latitudeString = m_resultDict["LATITUDE"] as? String,
                  let longitudeString = m_resultDict["LONGITUDE"] as? String,
                  let latitude = CLLocationDegrees(latitudeString),
                  let longitude = CLLocationDegrees(longitudeString) else {
                print("No coordinates found: ",m_resultDict)
                return
            }
            latitudeFinal = latitude
            longitudeFinal = longitude
            openMap()
        }
        
        
    }
    
    func openMap(){
//        print("Outsiide latitudeFinal: ",latitudeFinal," longitudeFinal:",longitudeFinal)
//        // Create the map view
//        mapView = MKMapView(frame: view.bounds)
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        mapView.delegate = self
//        view.addSubview(mapView)
//
//        // Add an initial annotation to the map
//        let initialCoordinate = CLLocationCoordinate2D(latitude: latitudeFinal, longitude: longitudeFinal)
//        let region = MKCoordinateRegionMakeWithDistance(initialCoordinate, 1000, 1000)
//        mapView.setRegion(region, animated: true)
//
//        // Add a placemark annotation to the map
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = initialCoordinate
//        annotation.title = m_resultDict["HOSP_NAME"] as? String
//        mapView.addAnnotation(annotation)
//
//        // Add zoom in button
//        zoomInButton = UIButton(type: .system)
//        zoomInButton.setTitle("Zoom In", for: .normal)
//       zoomInButton.addTarget(self, action: #selector(zoomInButtonTapped), for: .touchUpInside)
//        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(zoomInButton)
//        NSLayoutConstraint.activate([
//            zoomInButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            zoomInButton.widthAnchor.constraint(equalToConstant: 40), // Set the desired width
//            zoomInButton.heightAnchor.constraint(equalToConstant: 40) // Set the desired height
//
//        ])
//
//        // Add zoom out button
//        zoomOutButton = UIButton(type: .system)
//        zoomOutButton.setTitle("Zoom Out", for: .normal)
//        zoomOutButton.addTarget(self, action: #selector(zoomOutButtonTapped), for: .touchUpInside)
//        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(zoomOutButton)
//        NSLayoutConstraint.activate([
//            zoomOutButton.topAnchor.constraint(equalTo: zoomInButton.bottomAnchor, constant: 8),
//            zoomOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            zoomInButton.widthAnchor.constraint(equalToConstant: 40), // Set the desired width
//            zoomInButton.heightAnchor.constraint(equalToConstant: 40) // Set the desired height
//        ])
//
//        // Add direction button
//        directionButton = UIButton(type: .system)
//        directionButton.setTitle("Directions", for: .normal)
//        directionButton.addTarget(self, action: #selector(directionButtonTapped), for: .touchUpInside)
//        directionButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(directionButton)
//        NSLayoutConstraint.activate([
//            directionButton.topAnchor.constraint(equalTo: zoomOutButton.bottomAnchor, constant: 8),
//            directionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//        ])
//
//        // Request location permission
//        locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//        }
//
//        // Add an initial annotation to the map
//        let initialCoordinate1 = CLLocationCoordinate2D(latitude: latitudeFinal, longitude: longitudeFinal)
//        let region1 = MKCoordinateRegionMakeWithDistance(initialCoordinate1, 1000, 1000)
//        mapView.setRegion(region1, animated: true)
//
//        // Add a detail view for placemark details
//        detailView = UIView()
//        detailView.backgroundColor = UIColor.white
//        detailView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(detailView)
//        NSLayoutConstraint.activate([
//            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            detailView.heightAnchor.constraint(equalToConstant: 100)
//        ])
//
//
//        var hospitalName = m_resultDict["HOSP_NAME"] as! String
//        var hospitalAddress = m_resultDict["HOSP_ADDRESS"] as! String
//        var completeDetail = "\(hospitalName) "+"\(hospitalAddress)"
//
//        let addressLabel = UILabel()
//        addressLabel.text = completeDetail
//        addressLabel.numberOfLines = 0 // Allow multiple lines
//        addressLabel.lineBreakMode = .byWordWrapping
//        addressLabel.adjustsFontSizeToFitWidth = true
//        addressLabel.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h12))
//        addressLabel.minimumScaleFactor = 0.5 // Minimum font size (e.g., half of the original size)
//        addressLabel.translatesAutoresizingMaskIntoConstraints = false
//        detailView.addSubview(addressLabel)
//
//        NSLayoutConstraint.activate([
//            addressLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 16),
//            addressLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -16), // Set trailing constraint
//            addressLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 16), // Adjust top constraint if needed
//            addressLabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -16) // Adjust bottom constraint if needed
//        ])
//
//
//        //Made hidden from map
//        zoomInButton.isHidden = true
//        zoomOutButton.isHidden = true
//        directionButton.isHidden = true
//        spinner.stopAnimating()
//        spinner.isHidden = true
        
        // Create the map view
               mapView = MKMapView(frame: view.bounds)
               mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
               mapView.delegate = self
               view.addSubview(mapView)
               
               // Add an initial annotation to the map
               let initialCoordinate = CLLocationCoordinate2D(latitude: latitudeFinal, longitude: longitudeFinal)
               let region = MKCoordinateRegionMakeWithDistance(initialCoordinate, 1000, 1000)
               mapView.setRegion(region, animated: true)
               
               // Add a placemark annotation to the map
               let annotation = MKPointAnnotation()
               annotation.coordinate = initialCoordinate
               annotation.title = m_resultDict["HOSP_NAME"] as? String
               mapView.addAnnotation(annotation)
               
               // Add zoom in button
               zoomInButton = UIButton(type: .system)
               zoomInButton.setTitle("Zoom In", for: .normal)
              zoomInButton.addTarget(self, action: #selector(zoomInButtonTapped), for: .touchUpInside)
               zoomInButton.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(zoomInButton)
               NSLayoutConstraint.activate([
                   zoomInButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                   zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                   zoomInButton.widthAnchor.constraint(equalToConstant: 40), // Set the desired width
                   zoomInButton.heightAnchor.constraint(equalToConstant: 40) // Set the desired height
               ])
               
               // Add zoom out button
               zoomOutButton = UIButton(type: .system)
               zoomOutButton.setTitle("Zoom Out", for: .normal)
               zoomOutButton.addTarget(self, action: #selector(zoomOutButtonTapped), for: .touchUpInside)
               zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(zoomOutButton)
               NSLayoutConstraint.activate([
                   zoomOutButton.topAnchor.constraint(equalTo: zoomInButton.bottomAnchor, constant: 8),
                   zoomOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                   zoomInButton.widthAnchor.constraint(equalToConstant: 40), // Set the desired width
                   zoomInButton.heightAnchor.constraint(equalToConstant: 40) // Set the desired height
               ])
               
               // Add direction button
               directionButton = UIButton(type: .system)
               directionButton.setTitle("Directions", for: .normal)
               directionButton.addTarget(self, action: #selector(directionButtonTapped), for: .touchUpInside)
               directionButton.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(directionButton)
               NSLayoutConstraint.activate([
                   directionButton.topAnchor.constraint(equalTo: zoomOutButton.bottomAnchor, constant: 8),
                   directionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
               ])
               
               // Request location permission
               locationManager.requestWhenInUseAuthorization()
               
               if CLLocationManager.locationServicesEnabled() {
                   locationManager.delegate = self
                   locationManager.desiredAccuracy = kCLLocationAccuracyBest
                   locationManager.startUpdatingLocation()
               }
               
               // Add an initial annotation to the map
               let initialCoordinate1 = CLLocationCoordinate2D(latitude: latitudeFinal, longitude: longitudeFinal)
               let region1 = MKCoordinateRegionMakeWithDistance(initialCoordinate1, 1000, 1000)
               mapView.setRegion(region1, animated: true)
               
               // Add a detail view for placemark details
               detailView = UIView()
               detailView.backgroundColor = UIColor.white
               detailView.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(detailView)
               NSLayoutConstraint.activate([
                   detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                   detailView.heightAnchor.constraint(equalToConstant: 100)
               ])
               
               
               var hospitalName = m_resultDict["HOSP_NAME"] as! String
               var hospitalAddress = m_resultDict["HOSP_ADDRESS"] as! String
               var completeDetail = "\(hospitalName) "+"\(hospitalAddress)"
               
               let addressLabel = UILabel()
               addressLabel.text = completeDetail
               addressLabel.numberOfLines = 0 // Allow multiple lines
               addressLabel.lineBreakMode = .byWordWrapping
               addressLabel.adjustsFontSizeToFitWidth = true
               addressLabel.font = UIFont(name: FontsConstant.shared.OpenSansBold, size: CGFloat(FontsConstant.shared.h12))
               addressLabel.minimumScaleFactor = 0.5 // Minimum font size (e.g., half of the original size)
               addressLabel.translatesAutoresizingMaskIntoConstraints = false
               detailView.addSubview(addressLabel)
               
               NSLayoutConstraint.activate([
                   addressLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 16),
                   addressLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -16), // Set trailing constraint
                   addressLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 16), // Adjust top constraint if needed
                   addressLabel.bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: -16) // Adjust bottom constraint if needed
               ])
               
        //Made hidden from map
               zoomInButton.isHidden = true
               zoomOutButton.isHidden = true
               directionButton.isHidden = true
               self.hidePleaseWait()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden=false
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
        DispatchQueue.main.async()
        {
            menuButton.isHidden=true
            menuButton.accessibilityElementsHidden=true
        }
    }

    @objc func zoomInButtonTapped() {
        var region = mapView.region
        region.span.latitudeDelta /= 2
        region.span.longitudeDelta /= 2
        mapView.setRegion(region, animated: true)
        zoomCount += 1
        print("Zoom In Count: \(zoomCount)")
    }

    @objc func zoomOutButtonTapped() {
        var region = mapView.region
        region.span.latitudeDelta *= 2
        region.span.longitudeDelta *= 2
        
        // Check if the span values are within a valid range
        let maxSpanValue: CLLocationDegrees = 180
        if region.span.latitudeDelta <= maxSpanValue && region.span.longitudeDelta <= maxSpanValue {
            mapView.setRegion(region, animated: true)
            zoomCount -= 1
            if zoomCount < 0 {
                zoomCount = 0
            }
            print("Zoom Out Count: \(zoomCount)")
        } else {
            print("Invalid region span")
        }
    }


    @objc func directionButtonTapped() {
        let alertController = UIAlertController(title: "Directions", message: "Open directions in Maps?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openAction = UIAlertAction(title: "Open", style: .default) { _ in
            self.openDirectionsInMaps()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(openAction)
        present(alertController, animated: true, completion: nil)
    }

    func openDirectionsInMaps() {
        
        if let latitudeString = m_resultDict["LATITUDE"] as? String,
           let latitude = CLLocationDegrees(latitudeString),
           let longitudeString = m_resultDict["LONGITUDE"] as? String,
           let longitude = CLLocationDegrees(longitudeString) {
            print("openDirectionsInMaps : latitude",latitude," : longitude",longitude)
            var destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let placemark = MKPlacemark(coordinate: destinationCoordinate)
            let mapItem = MKMapItem(placemark: placemark)
            
            if let currentLocation = locationManager.location?.coordinate {
                let sourcePlacemark = MKPlacemark(coordinate: currentLocation)
                let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                
                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                MKMapItem.openMaps(with: [sourceMapItem, mapItem], launchOptions: options)
            } else {
                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: options)
            }
        }
    }
}

extension MapViewControllerNew: MKMapViewDelegate {
    // Customize the appearance of the annotation views, if needed
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "AnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            //for I from placemaker icon
            //let detailButton = UIButton(type: .detailDisclosure)
            //annotationView?.rightCalloutAccessoryView = detailButton
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    

}

extension MapViewControllerNew: CLLocationManagerDelegate {
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        
        var currentCoordinate = currentLocation.coordinate
        
        if let latitudeString = m_resultDict["LATITUDE"] as? String, let latitude = CLLocationDegrees(latitudeString) {
            currentCoordinate.latitude = latitude
        }
        
        if let longitudeString = m_resultDict["LONGITUDE"] as? String, let longitude = CLLocationDegrees(longitudeString) {
            currentCoordinate.longitude = longitude
        }

        print("Result Latitude: \(currentCoordinate.latitude)")
        print("Result Longitude: \(currentCoordinate.longitude)")

        // Update map view with current location
        let region = MKCoordinateRegionMakeWithDistance(currentCoordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)

        // Add an annotation for current location
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentCoordinate
        let hospitalName = m_resultDict["HOSP_NAME"] as? String
        annotation.title = hospitalName
        mapView.addAnnotation(annotation)

        // Stop updating location to conserve battery
        locationManager.stopUpdatingLocation()
    }
*/

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            if clError.code == .denied {
                // Handle case when the user denied location permissions
                print("Location manager error: User denied location permissions.")
            } else {
                // Handle other location errors
                print("Location manager error: \(clError.localizedDescription)")
            }
        } else {
            // Handle non-CLError errors
            print("Location manager error: \(error.localizedDescription)")
        }
    }

}

extension MapViewControllerNew {
    // UI changes
    
    @objc override func backButtonClicked() {
        self.tabBarController?.tabBar.isHidden = false
        menuButton.isHidden = false
        _ = navigationController?.popViewController(animated: true)
    }
}


