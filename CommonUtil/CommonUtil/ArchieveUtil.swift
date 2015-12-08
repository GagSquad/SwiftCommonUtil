//
//  ArchieveUtil.swift
//  CommonUtil
//
//  Created by lijunjie on 15/12/4.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation

public class ArchieveUtil {
    
    private static let share = ArchieveUtil();
    
    private init () {}

    public func archieveObject(anObject: NSCoding, toPath: String) -> Bool {
        let archieveData = NSKeyedArchiver.archivedDataWithRootObject(anObject);
        return SharedFileUtil.writeFileData(archieveData, toPath: toPath);
    }
    
    public func unarchieveFromPath(filePath: String) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(filePath);
    }
}

public let SharedArchieveUtil: ArchieveUtil = ArchieveUtil.share;
