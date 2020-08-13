//
//  ViewController.swift
//  Memorias
//
//  Created by Guido Roberto Carballo Guerrero on 8/3/20.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tempFullAccuracy: UIButton!
    @IBOutlet weak var resetMapViewSpan: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    lazy var locationManager = CLLocationManager()
    
    var coordinateSpanFactor: Double!
    
    /*let authorizationStatus: CLAuthorizationStatus { get }
    let accuracyAuthorization: CLAccuracyAuthorization { get }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 200
        //locationManager.startUpdatingLocation()
        //locationManager.requestLocation()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        coordinatesLabel.layer.cornerRadius = 10
        tempFullAccuracy.layer.cornerRadius = 10
        resetMapViewSpan.layer.cornerRadius = 10
        currentLocationButton.layer.cornerRadius = 10
        
        coordinatesLabel.layer.masksToBounds = true
        
        coordinateSpanFactor = 0.5
        mapView.region.span = MKCoordinateSpan(latitudeDelta: coordinateSpanFactor, longitudeDelta: coordinateSpanFactor)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    func displayLocationInfo(placeMark:CLPlacemark){
        
        //self.locationManager.stopUpdatingLocation()
        
        print("We have a new location")
        print("City: \(placeMark.locality ?? "Couldn't find city")")
        print("Zip code: \(placeMark.postalCode ?? "Couldn't find the zip code")")
        print("State: \(placeMark.administrativeArea ?? "Couldn't find the state")")
        print("Country: \(placeMark.country ?? "Couldn't find the country")")
        
    }
    
    @IBAction func tempFullAccuracy(_ sender: UIButton) {
        
        locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "TempPermission")
        
    }
    @IBAction func resetMVSpan(_ sender: UIButton) {
        
        mapView.region.span = MKCoordinateSpan(latitudeDelta: coordinateSpanFactor, longitudeDelta: coordinateSpanFactor)
        
    }
    
    @IBAction func getCurrentLocation(_ sender: UIButton) {
        
        print("trying to get current location")
        
        locationManager.requestLocation()
        
        if let location = locationManager.location {
            
            print(location)
            
            let coorText = String(format: "   Lat: %.3f   \r\n   Long: %.3f   \r\n   Altitude: \(location.altitude)   ", location.coordinate.latitude, location.coordinate.longitude)
            coordinatesLabel.text = coorText
            
        } else {
            
            print("location couldn't be found")
            
        }
        
        
    }
    
}

extension ViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus()
        
        if status == .denied || status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        /*switch status {
            case .authorizedAlways:
                print("locationStatus: authorizedAlways")
                break
            case .authorizedWhenInUse:
                print("locationStatus: authorizedWhenInUse")
                break
            case .denied, .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                print("locationStatus: restricted")
                break
            default:
                break
        }
        
        let accuracyAuthorization = manager.accuracyAuthorization
        
        switch accuracyAuthorization {
            case .fullAccuracy:
                print("accuracyAuthorization: fullAccuracy")
                break
            case .reducedAccuracy:
                print("accuracyAuthorization: reducedAccuracy")
                manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "TempPermission")
                break
            default:
                break
        }*/
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let coorText = String(format: "   Lat: %.3f   \r\n   Long: %.3f   \r\n   Altitude: \(location.altitude)   ", location.coordinate.latitude, location.coordinate.longitude)
        coordinatesLabel.text = coorText
        
        let regionToZoom = MKCoordinateRegion(center: manager.location!.coordinate, span: self.mapView.region.span)
            
        mapView.setRegion(regionToZoom, animated: true)
        print("latitud: \(manager.location!.coordinate.latitude), longitud: \(manager.location!.coordinate.longitude)")
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            
            if (error != nil){
                print("Error 2: " + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0{
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(placeMark: pm)
            }else{
                print("Error with data")
            }
            
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
    
}
