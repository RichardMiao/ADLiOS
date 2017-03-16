//
//  FileProcess.swift
//  ADL
//
//  Created by Richard on 2/25/17.
//  Copyright © 2017 RichardISU Computer Science smart house lab. All rights reserved.
//

import Foundation

class FileProcess {
    
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
        //        do {
        //            print(content)
        //            try content.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        //        } catch let error as NSError {
        //            print(error.localizedDescription)
        //        }
        
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
    
    func getFileName() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from:date)
        return dateString
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
        let fileDir = try! FileManager.default.url(for:.cachesDirectory, in:.userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(folder, isDirectory:true).appendingPathComponent(fileName, isDirectory: false)
            
        if !FileManager.default.fileExists(atPath: fileDir.path) {
            return nil
        } else {
            do  {let text = try String(contentsOf: fileDir, encoding: .utf8)
            } catch let error as NSError {
                print(error)
            }
        }
        return text?
    }
    
}
