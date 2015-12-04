//
//  CacheUtil.swift
//  CommonUtil
//
//  Created by lijunjie on 15/12/4.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation

public class  CacheUtil {
    
    var cache: NSCache = NSCache();
    
    public static func share() -> CacheUtil {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: CacheUtil? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CacheUtil()
        }
        return Static.instance!
    }
    
    public func shareCache() -> NSCache {
        return cache;
    }
    
    public func systemMemoryCacheSet(key: NSCoding, value: AnyObject) {
        self.shareCache().setObject(value, forKey: key);
    }
    
    public func systemMemoryCacheRemove(key: AnyObject) {
        self.shareCache().removeObjectForKey(key);
    }
    
    public func systemMemoryCacheGetValue(key:AnyObject) -> AnyObject? {
        return self.shareCache().objectForKey(key);
    }
    
    public func systemMemoryCacheEmptyValue(key:AnyObject) -> Bool {
        return (self.systemMemoryCacheGetValue(key) == nil);
    }
    
}
