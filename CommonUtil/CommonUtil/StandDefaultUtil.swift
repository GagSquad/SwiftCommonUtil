//
//  StandDefaultUtil.swift
//  CommonUtil
//
//  Created by lijunjie on 15/12/4.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation

public class StandDefaultUtil {
    
    private static let share = StandDefaultUtil();
    
    private init () {}
    
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

public let SharedStandDefaultUtil: StandDefaultUtil = StandDefaultUtil.share;
