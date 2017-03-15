//
//  LocationData.swift
//  ADL
//
//  Created by Richard on 10/25/16.
//  Copyright © 2016 RichardISU Computer Science smart house lab. All rights reserved.
//

import Foundation
import CoreLocation

class LocationData:NSObject,CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
//    var authStatus:CLAuthorizationStatus
    var locationData:[CLLocation]?
    
    override init() {
        super.init()
        self.locationData = nil
//        self.authStatus = CLLocationManager.authorizationStatus()
//        if authStatus == CLAuthorizationStatus.notDetermined {
//            locationManager.requestAlwaysAuthorization()
//        }
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        print("start location recording")
        self.locationManager.startUpdatingLocation()
    }
    
    func startRecordLocation() {
        print("start the location recording")
        locationManager.startUpdatingLocation()
    }
    
    func stopRecordLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("get the location")
        self.locationData = locations
        print("location = \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get location fail")
        print(error)
    }
    
    func getLocationData() -> [CLLocation]? {
        print("get the location data")
        return self.locationData
    }
}
