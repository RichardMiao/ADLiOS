//
//  ViewController.swift
//  ADL
//
//  Created by Richard on 10/10/16.
//  Copyright © 2016 RichardISU Computer Science smart house lab. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import Foundation
import SystemConfiguration.CaptiveNetwork
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate, SituationLabelDelagate, AVAudioRecorderDelegate {
    @IBOutlet weak var compassIcon: UIImageView!
    
    
    @IBOutlet weak var locationLabel: UIButton!
    
    let locationManager = CLLocationManager()
    let fileProcess = FileProcess()
    let motionData = MotionData()
    let audioRecorder = AudioRecording()
    var isLogin = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.compassIcon.image = UIImage(named:"compass.png")
//        self.fileProcess.getFileList(folder: "record")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.isLogin = self.checkLogin()
        if isLogin == false {
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
    }
    
    //main button
    @IBAction func mainButton(_ sender: UIButton) {
        let text = sender.currentTitle;
        if text == "ON" {
            print("the action is on")
            sender.backgroundColor = UIColor(colorLiteralRed: 27/255, green: 113/255, blue: 252/255, alpha: 1.0)
            sender.setTitle("OFF", for: UIControlState.normal)
            startRecording()
        } else if text == "OFF" {
            print("the action is off")
            sender.backgroundColor = UIColor(colorLiteralRed: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
            sender.setTitle("ON", for: UIControlState.normal)
            stopRecording()
        }
    }
    
    func startRecording() {
        
        //audio
        let fileName = self.fileProcess.getFileName()+"m4a"
        let setupRes = self.audioRecorder.setupRecorder(fileName: fileName,delegate: self)
        if setupRes == true {
            self.audioRecorder.startRecording()
        }
        
        // Motion DATA
        self.motionData.getAccData(interval: 0.5)
        self.motionData.getGyroData(interval: 0.5)
        self.motionData.getMagData(interval: 0.5)
        
        // COMPASS DATA
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        //Battery Monitor
        let battery_status = getBattery()
        let cur_time = getDateHour()
        let file = self.fileProcess.getFileName()
        let content:String = "battery level: \(battery_status.battery_level)%, battery state: \(battery_status.battery_state), time:\(cur_time)\n\n"
        self.fileProcess.writeFile(content: content, fileName: file, folder:"record")
        print (content)
        
        //Wifi AP
        //WiFiManagerRef manager = WiFiManagerClientCreate(kCFAllocatorDefault, 0)
        
        //wifi connected ID
        let ssid = getSSID()
        if ssid != nil {
            let file = self.fileProcess.getFileName()
            let cur_time = getDateHour()
            let content:String = "wifi ssid: \(ssid), time:\(cur_time)\n\n"
            self.fileProcess.writeFile(content: content, fileName: file, folder:"record")
            print(ssid!)
        }
    }
    
    func stopRecording() -> Void {
        self.motionData.stopMotionData()
        self.locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("get the location")
        let file = self.fileProcess.getFileName()
        for loc:CLLocation in locations {
//            print("the longitute: \(loc.coordinate.longitude)")
//            print("the latitude:\(loc.coordinate.latitude)")
//            print("the altitude:\(loc.altitude)")
            var record:String = "longitute: \(loc.coordinate.longitude)"
            record += ", latitude: \(loc.coordinate.latitude)"
            record += ", altitude: \(loc.altitude)"
            record += ", time: \(loc.timestamp)"
            record += "\n"
//            print(record)
            self.fileProcess.writeFile(content: record, fileName: file, folder:"record")
        }
//        print("location = \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get location fail")
        print(error)
    }
    
    //Battery Level
    func getBattery() -> (battery_level:Float,battery_state:String) {
        print ("get current battery level")
        UIDevice.current.isBatteryMonitoringEnabled = true
        let battery_level = UIDevice.current.batteryLevel*100
//        print (level)
        let status = UIDevice.current.batteryState
        var battery_state:String = "unknown"
        switch status {
        case UIDeviceBatteryState.charging:
            battery_state = "in charging"
        case UIDeviceBatteryState.full:
            battery_state = "full"
        case UIDeviceBatteryState.unplugged:
            battery_state = "unplugged"
        default:
            battery_state = "unknown"
        }
        print ("the battery status:\(battery_state)")
        return (battery_level, battery_state)
    }
    
    //Current SSID
    func getSSID() -> String? {
        print("get current wifi ssid")
        let interfaces = CNCopySupportedInterfaces()
        if interfaces == nil {
            return nil
        }
        
        let interfacesArray = interfaces as! [String]
        if interfacesArray.count <= 0 {
            return nil
        }
        
        let interfaceName = interfacesArray[0] as String
        let unsafeInterfaceData =     CNCopyCurrentNetworkInfo(interfaceName as CFString)
        if unsafeInterfaceData == nil {
            return nil
        }
        
        let interfaceData = unsafeInterfaceData as! Dictionary <String,AnyObject>
        
        return interfaceData["SSID"] as? String
    }
    
    func getDateHour()-> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func checkLogin() -> Bool {
        if self.fileProcess.checkLoginFile() == false {
            return false
        } else {
            let userStr = self.fileProcess.readFile(fileName: "user", folder: "login")
            if userStr == nil {
                return false
            } else {
                print("success")
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOption" {
            print("the delegate set")
            let optionViewController:SituationViewController = segue.destination as! SituationViewController
            optionViewController.delegate = self
        }
    }
    
    func situationLabel(label:String?) -> Void {
        if label != nil {
            print("set location label")
            print(label)
            self.locationLabel.setTitle(label, for: .normal)
        }
    }

}

