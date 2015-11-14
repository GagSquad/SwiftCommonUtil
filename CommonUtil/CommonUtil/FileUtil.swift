//
//  FileUtil.swift
//  CommonUtil
//
//  Created by lijunjie on 15/11/14.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation

public class FileUtil {
    public func deleteFile(filePath: String) -> Bool {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filePath);
            return true;
        } catch {
            return false;
        }
    }
    
    public func getObjcet(filePath: String) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(filePath);
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
    
    public func createDirectory(path: String) {
        if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: nil) {
            try! NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil);
        }
    }
    
    public func isExitFile(filePath: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(filePath, isDirectory: nil);
    }
    
    public func saveImage(path: NSString) {
        let lastDir = path.stringByDeletingLastPathComponent;
        if NSFileManager.defaultManager().fileExistsAtPath(lastDir, isDirectory: nil) {
            try! NSFileManager.defaultManager().createDirectoryAtPath(lastDir, withIntermediateDirectories: true, attributes: nil);
        }
    }
}

