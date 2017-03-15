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
    func getAccData(interval:Double) -> Void {
        print("this function start")
        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(accelerometerData: CMAccelerometerData?, error: Error?) -> Void in
            let str = self.outPutAccData(accData:accelerometerData!.acceleration)
            if error != nil {
                print("\(error)")
            }
            let file = self.fileProcess.getFileName()
            print(str)
            self.fileProcess.writeFile(content: str, fileName: file, folder:"record")
        })
    }
    
    func outPutAccData(accData:CMAcceleration) -> String {
        print("the accelerometer data")
        let res = "Accelerometer: x: \(accData.x), y: \(accData.y), z: \(accData.z)\n"
        return res
    }
    
    func stopAccData() -> Void{
        motionManager.stopAccelerometerUpdates()
    }
    
    func getGyroData(interval:Double) -> Void {
        print("getting gyro data!")
        motionManager.gyroUpdateInterval = interval
        motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: {(gyroscopeData:CMGyroData?,error: Error?) -> Void in
            let str = self.outPutGyroData(gyroData: gyroscopeData!.rotationRate)
            if error != nil {
                print("\(error)")
            }
            let file = self.fileProcess.getFileName()
            print(str)
            self.fileProcess.writeFile(content: str, fileName: file, folder: "record")
        })
    }
    
    func outPutGyroData(gyroData:CMRotationRate) -> String {
        print("the gyroscope data")
        let res = "Gyroscope: x: \(gyroData.x), y: \(gyroData.y), z: \(gyroData.z)\n"
        return res
    }
    
    func stopGyroData() -> Void {
        motionManager.stopGyroUpdates()
    }
    
    func getMagData(interval:Double) -> Void{
        print("get the mag data")
        motionManager.magnetometerUpdateInterval = interval
        motionManager.startMagnetometerUpdates(to: OperationQueue.current!, withHandler: {(magnData:CMMagnetometerData?,error: Error?)->Void in
            let str = self.outPutMagData(magData: magnData!.magneticField)
            if error != nil {
                print("\(error)")
            }
            let file = self.fileProcess.getFileName()
            print(str)
            self.fileProcess.writeFile(content: str, fileName: file, folder:"record")
        })
    }
    
    func outPutMagData(magData:CMMagneticField) -> String{
        print("the magnetometer data")
        let res = "Magnetometer: x: \(magData.x), y: \(magData.y), z: \(magData.z)\n"
        return res
    }
    
    func stopMagData() -> Void {
        motionManager.stopMagnetometerUpdates()
    }
    
    func stopMotionData() -> Void {
        self.stopAccData()
        self.stopMagData()
        self.stopGyroData()
    }
}
