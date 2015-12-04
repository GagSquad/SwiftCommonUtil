//
//  ArchieveUtil.swift
//  CommonUtil
//
//  Created by lijunjie on 15/12/4.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation

public class ArchieveUtil {
    class func share() -> ArchieveUtil {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ArchieveUtil? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ArchieveUtil()
        }
        return Static.instance!
    }

    public func archieveObject(anObject: NSCoding, toPath: String) -> Bool {
        let archieveData = NSKeyedArchiver.archivedDataWithRootObject(anObject);
        return FileUtil.share().writeFileData(archieveData, toPath: toPath);
    }
    
    public func unarchieveFromPath(filePath: String) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(filePath);
    }
}

public let SharedArchieveUtil: ArchieveUtil = ArchieveUtil.share();
