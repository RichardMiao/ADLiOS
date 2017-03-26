//
//  FileProcess.swift
//  ADL
//
//  Created by Richard on 2/25/17.
//  Copyright © 2017 RichardISU Computer Science smart house lab. All rights reserved.
//

import Foundation

enum FileType {
    case audio
    case csv
    case motion
    case other
}

class FileProcess {
    
    var fileNames:[FileType:String?] = [:]
    func createFile(fileName:String, folder:String) -> Void {
        print("file creating:");
        let fileDir = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folder)
        if !FileManager.default.fileExists(atPath: fileDir.path) {
            createFolder(folder: folder)
        }

        let path:String = fileDir.appendingPathComponent(fileName).path
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func createFolder(folder:String) -> Void {
        let filePath = try!  FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor:nil, create: false).appendingPathComponent(folder, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: filePath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func writeFile(content: String, fileName: String, folder:String) -> Void {
        let dir = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folder)
        let path:String = dir.appendingPathComponent(fileName).path
        if !FileManager.default.fileExists(atPath: path) {
            self.createFile(fileName: fileName, folder:folder)
        }
        print(path)
        
        if let fileHandle = FileHandle(forWritingAtPath: path) {
            fileHandle.seekToEndOfFile()
            let data = content.data(using: String.Encoding.utf8)
            fileHandle.write(data!)
            fileHandle.closeFile()
        }
    }
    
    func wirteFileWithCoverUp(content:String, fileName:String, folder:String) -> Void {
        let dir = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folder, isDirectory: true).appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: dir.path) {
            self.createFile(fileName: fileName, folder: folder)
        }
        
        do {
            try content.write(to: dir, atomically: false, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func generateFileName(fileType:FileType) -> Void {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = dateFormatter.string(from:date)
        let userName = getUserName()
        var res:String = ""
        if fileType == .audio {
            res = userName+"_"+dateString+".m4a"
        } else if fileType == .csv {
            res = userName+"_"+dateString+".csv"
        } else if fileType == .motion {
            res = userName+"_"+dateString+"_motion.csv"
        } else {
            res = userName+"_"+dateString
        }
        self.fileNames[fileType] = res
    }
    
    func getFileName(fileType:FileType) -> String {
        if let fileName = self.fileNames[fileType] {
            return fileName!
        } else {
            return ""
        }
    }
    
    
    
    func getUserName() -> String {
        if !self.checkLoginFile() {
            return ""
        }
        let fileContent = self.readFile(fileName: "user", folder: "login")
        if fileContent == nil {
            return ""
        }
        let userInfo = fileContent?.components(separatedBy: "\n")
        if userInfo == nil {
            return ""
        }
        return userInfo![0]
    }
    
    func getFileList(folder:String) -> Void {
        let fileDir = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folder, isDirectory: true)
        do {
            let directoryContents = try! FileManager.default.contentsOfDirectory(at: fileDir, includingPropertiesForKeys: nil, options: [])
            print (directoryContents)
        }
    }
    
    func deleteFromDirectory(folder:String) -> Void {
        
    }
    
    func checkLoginFile() -> Bool {
        let fileDir = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("login", isDirectory: true).appendingPathComponent("user", isDirectory: false)
        if !FileManager.default.fileExists(atPath: fileDir.path) {
            return false
        } else {
            return true
        }
    }
    
    func readFile(fileName:String, folder:String) -> String? {
        let fileDir = try! FileManager.default.url(for:.cachesDirectory, in:.userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folder, isDirectory:true).appendingPathComponent(fileName, isDirectory:false)
        var res:String? = nil
        if !FileManager.default.fileExists(atPath: fileDir.path) {
            return res
        } else {
            do {
                let str = try String(contentsOf: fileDir, encoding:String.Encoding.utf8).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                if str.isEmpty {
                    return res
                }
                res = str
            } catch let error as NSError {
                print(error)
            }
        }
        print("-------\n")
        print(res!)
        return res
    }
    
    func checkDir(folder:String) -> Bool {
        let dir = try! FileManager.default.url(for:.cachesDirectory, in:.userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folder, isDirectory:true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            return false
        } else {
            return true
        }
    }
    
}
