//
//  ViewController.swift
//  Project 22
//
//  Created by Andrew Emad on 26/07/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    var locationManager : CLLocationManager?
    @IBOutlet weak var distanceReading: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    //print("there's a beacon and we can detect a range between the beacon and our device")
                    startScanning()
                }
            }
        }
    }
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        locationManager?.startMonitoring(for: beaconRegion)
       // locationManager?.startRangingBeacons(in: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }
    func update(distance : CLProximity){
        UIView.animate(withDuration: 1){
            switch distance {
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "Right Here"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            let alert = UIAlertController(title: "Beacon Detected", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            update(distance: beacon.proximity)
        }else{
            update(distance: .unknown)
        }
    }
}

