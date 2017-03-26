//
//  AudioRecording.swift
//  ADL
//
//  Created by Richard on 3/17/17.
//  Copyright © 2017 RichardISU Computer Science smart house lab. All rights reserved.
//

import Foundation
import AVFoundation

class AudioRecording {
    var soundRecorder: AVAudioRecorder?
    var audioSession: AVAudioSession!
    var seconds:Double = 15
    let fileProcess = FileProcess()
    
    func setRecordTimeLength(seconds:Double) -> Bool {
        self.seconds = seconds
        return true
    }

    func getRecordTimeLength() -> Double {
        return self.seconds
    }
    
    func setupRecorder(fileName:String, delegate:AVAudioRecorderDelegate?) -> Bool {
        self.audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setActive(true)
            audioSession.requestRecordPermission({ (allowed) in
                if !allowed {
                    print("the permission is not allowed")
                }
            })
        } catch let error as NSError {
            print("error happened in session setting：\(error)")
            return false
        }
        
        var recorderSettings = [AVFormatIDKey: kAudioFormatAppleLossless,
                                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                                AVEncoderBitRateKey:320000,
                                AVNumberOfChannelsKey:2,
                                AVSampleRateKey: 441000.0] as [String : Any]
        let audioFilePath = self.getFileDir().appendingPathComponent(fileName)
        do {
            try soundRecorder = AVAudioRecorder(url: audioFilePath, settings: recorderSettings)
            soundRecorder?.delegate = delegate
            soundRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("error happened in audio recorder setting:\(error)")
            return false
        }
        return true
        
    }
    
    func getFileDir() -> URL {
        if self.fileProcess.checkDir(folder: "audio") == false {
            self.fileProcess.createFolder(folder: "audio")
        }
        
        let dir = try! FileManager.default.url(for:.cachesDirectory, in:.userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("audio", isDirectory:true)
        return dir
    }
    
//    func setDelegation(delegate:AVAudioRecorderDelegate?) -> Void {
//        if self.soundRecorder != nil {
//            self.soundRecorder?.delegate = delegate
//        }
//    }
    
    func startRecording() {
        self.soundRecorder?.record(forDuration: self.seconds)
    }
    
    func stopRecording() {
        self.soundRecorder?.stop()
    }
    
    
}
