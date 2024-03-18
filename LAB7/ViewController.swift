//
//  ViewController.swift
//  LAB7
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {

    
    @IBOutlet weak var currentSpeedLabel: UILabel!
    
    @IBOutlet weak var maximumSpeedLabel: UILabel!
    
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var maxAccLabel: UILabel!
    
    @IBOutlet weak var topView: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
   
    
    @IBOutlet weak var bottomView: UILabel!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Set up location manager
        super.viewDidAppear(animated)
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func startButton(_ sender: Any) {
        locationManager.startUpdatingLocation()
        bottomView.backgroundColor = .green
    }
 
    @IBAction func stopButton(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = false
        topView.backgroundColor = .none
        bottomView.backgroundColor = .gray
    }
    var maxspd = 0.0
    var spdArray: [Double] = []
    var avgSpeed = 0.0
    var totalDist  = 0.0
    var pTime: Date? = nil
    var lastLocation: CLLocation?
    var maxAcc = 0.0
    var prevSpd: Double?


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            // Current speed in km/h
            let crSpeed = location.speed * 3.6
            //Set current speed
            currentSpeedLabel.text = String(format: "%.2f",crSpeed) + " kh/h"
            
            // Top view will turn in red if speed increases more than 115 km/h
            if (crSpeed > 115) {
                topView.backgroundColor = .red
            } else {
                topView.backgroundColor = .none
            }
            
            spdArray.append(crSpeed)
                   
            maxspd = max(crSpeed,maxspd)
            //Max Speed
           maximumSpeedLabel.text = String(format: "%.2f",maxspd) + " kh/h"
            
            //Calculate the average speed
            let avgSpeed = spdArray.reduce(0, +)
            let averageSpeed = avgSpeed / Double(spdArray.count)
            averageSpeedLabel.text = String(format: "%.2f",averageSpeed) + " kh/h"
            
            // Update and display total distance
            let currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
            if let previousLocation = lastLocation {
                totalDist += previousLocation.distance(from: currentLocation)
                distanceLabel.text = String(format: "%.2f", totalDist/1000) + " km"
            }
                lastLocation = currentLocation
            // Calculate and display max acceleration
            if let previousSpeed = prevSpd {
                let timeDiff = Date().timeIntervalSince(pTime!)
                let acceleration = abs(crSpeed - previousSpeed) / timeDiff
                maxAccLabel.text = String(format: "%.2f", max(maxAcc, acceleration)) + " m/s^2"
               }
            prevSpd = location.speed
            pTime = Date()
        }
        
        
    }
    
}
