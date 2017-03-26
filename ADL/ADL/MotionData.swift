//
//  motionData.swift
//  ADL
//
//  Created by Richard on 10/25/16.
//  Copyright © 2016 RichardISU Computer Science smart house lab. All rights reserved.
//

import Foundation
import CoreMotion

class MotionData {
    let motionManager = CMMotionManager()
    let fileProcess = FileProcess()
    var accData:CMAccelerometerData? = nil
    var gyroData:CMGyroData? = nil
    var magData:CMMagnetometerData? = nil
    
    func generateAccData(interval:Double) -> Void {
        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(accelerometerData: CMAccelerometerData?, error: Error?) -> Void in
            self.accData = accelerometerData
            print("print the acc data")
            print(accelerometerData)
            if error != nil {
                print("\(error)")
            }
        })
    }
    
    func getACCData() -> CMAccelerometerData? {
        return self.accData
    }
    
    func stopAccData() -> Void{
        motionManager.stopAccelerometerUpdates()
    }
    
    func generateGyroData(interval:Double) -> Void {
        
        motionManager.gyroUpdateInterval = interval
        motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: {(gyroscopeData:CMGyroData?,error: Error?) -> Void in
            print("getting gyro data!")
            print(gyroscopeData)
            self.gyroData = gyroscopeData
            if error != nil {
                print("\(error)")
            }
        })
    }
    
    func getGyroData() -> CMGyroData?{
        return self.gyroData
    }
    
    func stopGyroData() -> Void {
        motionManager.stopGyroUpdates()
    }
    
    func generateMagData(interval:Double) -> Void{
        motionManager.magnetometerUpdateInterval = interval
        motionManager.startMagnetometerUpdates(to: OperationQueue.current!, withHandler: {(magnData:CMMagnetometerData?,error: Error?)->Void in
            print("get the mag data")
            print(magnData)
            self.magData = magnData
            
            if error != nil {
                print("\(error)")
            }
        })
    }
    
    func getMagData() -> CMMagnetometerData?{
        return self.magData
    }
    
    func stopMagData() -> Void {
        motionManager.stopMagnetometerUpdates()
    }
    
    func generateMotionData(interval:Double) -> Void {
        self.generateAccData(interval: interval)
        self.generateGyroData(interval: interval)
        self.generateMagData(interval: interval)
    }
    
    func stopMotionData() -> Void {
        self.stopAccData()
        self.stopMagData()
        self.stopGyroData()
    }
}
