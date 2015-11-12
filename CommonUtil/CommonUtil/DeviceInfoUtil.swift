//
//  DeviceInfoUtil.swift
//  SwiftTest
//
//  Created by lijunjie on 15/11/12.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation
import UIKit

public enum DeviceInfoError: ErrorType {
    case DeviceInfoKeychanError
}

public class DeviceInfoUtil {
    let kCUCFKeychainUDIDItemIdentifier = "UDID";
    
    let kCUCFKeychainUDIDAccount = "com.CUCFDeviceInfo";
    
    public let kCUDefaultKeyChainAccessGroup = "WEPZ293VNV.com.wanmei";
    
    public init () {
        
    }
    
    public func getUDIDWithKeyChainUDIDAccessGroup(accessGroup: String) -> String {
        if accessGroup.isEmpty {
            //            throw DeviceInfoError.DeviceInfoKeychanError;
        }
        
        let udidValue: NSData! = SharedKeychanUtil.getDataWithAccount(kCUCFKeychainUDIDAccount, service: kCUCFKeychainUDIDItemIdentifier, accessGroup: accessGroup);
        var uuid: String;
        if udidValue != nil {
            uuid = String(data: udidValue, encoding: NSUTF8StringEncoding)!;
        } else {
            uuid = (UIDevice.currentDevice().identifierForVendor?.UUIDString)!
            let keyChainItemValue =  uuid.dataUsingEncoding(NSUTF8StringEncoding) ;
            SharedKeychanUtil.saveData(keyChainItemValue!, account: kCUCFKeychainUDIDAccount, service: kCUCFKeychainUDIDItemIdentifier, accessGroup: accessGroup);
        }
        
        return uuid;
        
    }
    
}