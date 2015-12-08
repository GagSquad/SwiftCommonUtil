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
    case DeviceInfoKeychainError
}

public class DeviceInfoUtil {
    let kCUCFKeychainUDIDItemIdentifier = "UDID";
    let kCUCFKeychainUDIDAccount = "com.deviceInfo";
    public let kCUDefaultKeychainAccessGroup = "WEPZ293VNV.com.itlijunjie";
    
    private static let share = DeviceInfoUtil();
    
    private init () {}
    public func getUDIDWithKeyChainUDIDAccessGroup(accessGroup: String) throws -> String {
        if accessGroup.isEmpty {
            throw DeviceInfoError.DeviceInfoKeychainError;
        }
        let udidValue: NSData? = SharedKeychanUtil.getDataWithAccount(kCUCFKeychainUDIDAccount, service: kCUCFKeychainUDIDItemIdentifier, accessGroup: accessGroup);
        var uuid: String;
        if let udid = udidValue {
            uuid = String(data: udid, encoding: NSUTF8StringEncoding)!;
        } else {
            uuid = (UIDevice.currentDevice().identifierForVendor?.UUIDString)!
            let keyChainItemValue =  uuid.dataUsingEncoding(NSUTF8StringEncoding) ;
            try! SharedKeychanUtil.saveData(keyChainItemValue!, account: kCUCFKeychainUDIDAccount, service: kCUCFKeychainUDIDItemIdentifier, accessGroup: accessGroup);
        }        
        return uuid;
        
    }
}

public let SharedDeviceInfoUtil: DeviceInfoUtil = DeviceInfoUtil.share;
