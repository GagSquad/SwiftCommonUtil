//
//  FileUtil.swift
//  CommonUtil
//
//  Created by lijunjie on 15/11/14.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation

public class FileUtil {
    
    static func share() -> FileUtil {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: FileUtil? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = FileUtil()
        }
        return Static.instance!
    }
    
    public func createDirectory(path: String) {
        if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: nil) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil);
            } catch {
                print("创建目录错误！");
            }
        }
    }
    
    public func fileExist(filePath: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(filePath, isDirectory: nil);
    }
    
    public func deleteFile(filePath: String) -> Bool {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filePath);
            return true;
        } catch {
            return false;
        }
    }
    
    public func directoryExist(directoryPath: String) -> Bool {
        var isDir:ObjCBool = true;
        return NSFileManager.defaultManager().fileExistsAtPath(directoryPath, isDirectory: &isDir);
    }
    
    public func writeFileData(data:NSData, toPath: String) -> Bool {
        return data.writeToFile(toPath, atomically: true);
    }
    
    public func readFromFile(path: String) -> NSData? {
        return NSData(contentsOfFile: path);
    }
    
    public func deleteFileAtPath(filePath: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filePath);
        } catch {
            print("删除目录里面的文件错误！");
        }
    }
    
    public func deleteDirectoryAtPath(dirPath: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(dirPath);
        } catch {
            print("删除目录里面的目录错误！");
        }
    }
    
    public func copyFileFromPath(fromPath: String, toPath: String, isRemoveOld: Bool) -> Bool {
        var res = false;
        if self.fileExist(fromPath) {
            do {
                try NSFileManager.defaultManager().copyItemAtPath(fromPath, toPath: toPath);
                res = true;
            } catch {
                print("复制文件错误！");
            }
        } else {
            print("源文件不存在！");
        }
        
        if res && isRemoveOld {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(fromPath);
            } catch {
                print("删除当前路径");
            }
        }
        return res;
    }
    
    public func documentDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!;
    }
    
    public func documentDirectoryPath(file: String) -> String {
        return (self.documentDirectory() as NSString).stringByAppendingPathComponent(file);
    }
    
    public func cacheDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!;
    }
    
    public func cacheDirectoryPath(file: String) -> String {
        return (self.cacheDirectory() as NSString).stringByAppendingPathComponent(file);
    }
    
    public func cacheDirectoryDelete(file: String) -> Bool {
         return self.deleteFile(self.cacheDirectoryPath(file));
    }
    
    public func documentDirectoryDelete(file: String) -> Bool {
        return self.deleteFile(self.documentDirectoryPath(file));
    }
    
    public func getDirFileNames(dirPath: String) -> [String] {
        var arrTemp = [NSURL]();
        do {
            arrTemp = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(NSURL.fileURLWithPath(dirPath), includingPropertiesForKeys: [NSURLNameKey], options: NSDirectoryEnumerationOptions.SkipsHiddenFiles);
        } catch {
            return Array();
        }
        if arrTemp.count == 0 {
            return Array();
        }
        var arr = [String]();
        for fileNameUrl in arrTemp {
            arr.append(fileNameUrl.relativePath!);
        }
        return arr;
    }
    
    public func saveImage(path: NSString) {
        let lastDir = path.stringByDeletingLastPathComponent;
        if NSFileManager.defaultManager().fileExistsAtPath(lastDir, isDirectory: nil) {
            try! NSFileManager.defaultManager().createDirectoryAtPath(lastDir, withIntermediateDirectories: true, attributes: nil);
        }
    }
}

public let SharedFileUtil: FileUtil = FileUtil.share();


