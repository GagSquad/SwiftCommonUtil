//
//  StandDefaultUtil.swift
//  CommonUtil
//
//  Created by lijunjie on 15/12/4.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation

public class StandDefaultUtil {
    
    public static func share() -> StandDefaultUtil {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: StandDefaultUtil? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = StandDefaultUtil()
        }
        return Static.instance!
    }
    
    public func standDefault() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults();
    }
    
    public func userDefaultCache(value: NSCoding, key: AnyObject) {
        self.userDefaultCache(value, key: key);
    }
    
    public func userDefaultRemove(key: String) {
        self.standDefault().removeObjectForKey(key);
    }
    
    public func userDefaultGetValue(key: String) -> AnyObject! {
        return self.standDefault().objectForKey(key);
    }
    
    public func userDefaultEmptyValue(key: String) -> Bool {
        return self.userDefaultGetValue(key) == nil;
    }
    
}
