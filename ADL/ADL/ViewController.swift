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
    var locations:[CLLocation] = []
    
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
        /////////////////
        //audio  ////////
        ////////////////
        self.fileProcess.generateFileName(fileType:.audio)
        let fileName = self.fileProcess.getFileName(fileType:.audio)
        let setupRes = self.audioRecorder.setupRecorder(fileName: fileName,delegate: self)
        if setupRes == true {
            self.audioRecorder.startRecording()
        
        }

        // Motion DATA
        self.motionData.generateMotionData(interval: 0.5)
        
        // COMPASS DATA
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        //Battery Monitor
        let battery_status = getBattery()
        
        //screen orientation
        let screenOri = getScreenRotation()
        
        //Wifi AP
        //WiFiManagerRef manager = WiFiManagerClientCreate(kCFAllocatorDefault, 0)
        
        //wifi connected ID
        let ssid = getSSID()
        
        ////////////////////////
        //writing to csv file///
        ////////////////////////
        let delayTime = DispatchTime.now()+2
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.stopRecording()
            self.fileProcess.generateFileName(fileType: .csv)
            var csvContent:String = ""
            if let acc = self.motionData.getACCData() {
                let accData = acc.acceleration
                 csvContent = String(format: "%.2f", accData.x)+","+String(format: "%.2f", accData.y)+","+String(format: "%.2f", accData.z)+",,,,0.0,,"
            } else {
                csvContent = ",,,,,,0.0,"
            }
    //        print(csvContent)
            if self.locations.count == 0 {
                csvContent = csvContent+",,,"
            } else {
                let loc = self.locations[0]
                csvContent = csvContent+"\(loc.coordinate.latitude)"+","+"\(loc.coordinate.longitude)"+","+"\(loc.altitude)"+","
            }
    //        print(csvContent)
            csvContent = csvContent+",,,,,,0.0,0.0\n"
            //ggy
            csvContent = csvContent+"ggy,\n"
    //        print(csvContent)
            //ap
            if ssid == nil {
                csvContent = csvContent+"ap,,,,,\n"
            } else {
                let bssid = ssid!["BSSID"] as! String
                let ssid = ssid!["SSID"] as! String
                csvContent = csvContent+"ap,\(bssid),\(ssid),0,0.0.0.0,0.0\n"
            }
    //        print(csvContent)
            //mac addr(apple not allowed), use uuid instead
            let uuid = UIDevice.current.identifierForVendor
            let userName = self.fileProcess.getUserName()
            if uuid == nil {
                csvContent = csvContent+"mac,,\(userName),i,"
            } else {
                csvContent = csvContent+"mac,\(uuid!.uuidString),\(userName),i,\n"
            }
    //        print(csvContent)
            //battery
            csvContent = csvContent+"bat,\(battery_status.battery_state),,,,,,,2,\(battery_status.battery_level),0,\(screenOri)"
            print(csvContent)
            let csvFileName = self.fileProcess.getFileName(fileType: .csv)
            self.fileProcess.writeFile(content: csvContent, fileName: csvFileName, folder: "record")
            
            ///////////////////
            //motion.csv file//
            //////////////////
            var motionContent:String = ""
            self.fileProcess.generateFileName(fileType: .motion)
            motionContent = motionContent+"L,\n"
            motionContent = motionContent+"S,\n"
            motionContent = motionContent+"O,\n"
            motionContent = motionContent+"A,\n"
            motionContent = motionContent+"Y,\n"
            motionContent = motionContent+"G,\n"
            print(motionContent)
            let motionFileName = self.fileProcess.getFileName(fileType: .motion)
            self.fileProcess.writeFile(content: motionContent, fileName: motionFileName, folder: "record")
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
        self.locations = locations
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
            battery_state = "2"
        case UIDeviceBatteryState.full:
            battery_state = "5"
        case UIDeviceBatteryState.unplugged:
            battery_state = "3"
        default:
            battery_state = "0"
        }
        print ("the battery status:\(battery_state)")
        return (battery_level, battery_state)
    }
    
    //get Screen rotation
    func getScreenRotation() -> String {
        var res = ""
        switch UIDevice.current.orientation{
        case .landscapeLeft:
            res = "1"
        case .landscapeRight:
            res = "1"
        default:
            res = "2"
        }
        return res
    }
    
    //Current SSID
    func getSSID() -> [String:AnyObject]? {
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
        let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName as CFString)
        if unsafeInterfaceData == nil {
            return nil
        }
        print(unsafeInterfaceData)
        let interfaceData = unsafeInterfaceData as! Dictionary <String,AnyObject>
        print(interfaceData)
        return interfaceData
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

