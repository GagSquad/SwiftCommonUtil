//
//  KeychanUtil.swift
//  CommonUtil
//
//  Created by lijunjie on 15/11/12.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation

public enum CommonUtilError: ErrorType {
    case KeychanGetError
    case KeychanSaveError
    case KeychanDeleteError
    case KeychanUpdateError
}

public class KeychanUtil
{
    class var sharedInstance: KeychanUtil {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: KeychanUtil? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = KeychanUtil()
        }
        return Static.instance!
    }
    
    public func getBaseKeychainQueryWithAccount(account: String, service: String, accessGroup: String) -> [NSString : AnyObject] {
        var res = [NSString : AnyObject]();
        res[kSecClass] = kSecClassGenericPassword;
        res[kSecAttrAccount] = account;
        res[kSecAttrService] = service;
        
        if !accessGroup.isEmpty {
            #if TARGET_IPHONE_SIMULATOR
                // 如果在模拟器上运行，则忽略accessGroup
                //
                // 模拟器运行app没有签名, 所以这里没有accessGroup
                // 在模拟器上运行时，所有的应用程序可以看到所有钥匙串项目
                //
                // 如果SecItem包含accessGroup,当SecItemAdd and SecItemUpdate时，将返回-25243 (errSecNoAccessForItem)
            #else
                res[kSecAttrAccessGroup] = accessGroup;
            #endif
        }
        return res;
    }
    
    public func getDataWithAccount(account: String, service: String, accessGroup: String) -> NSData! {
        var res: [NSString : AnyObject] = self.getBaseKeychainQueryWithAccount(account, service: service, accessGroup: accessGroup);
        res[kSecMatchCaseInsensitive] = kCFBooleanTrue;
        res[kSecMatchLimit] = kSecMatchLimitOne;
        res[kSecReturnData] = kCFBooleanTrue;
        var queryErr: OSStatus = noErr;
        var udidValue: NSData?;
        var inTypeRef : AnyObject?
        
        queryErr = SecItemCopyMatching(res, &inTypeRef);
        udidValue = inTypeRef as? NSData;
        if (queryErr != errSecSuccess) {
            print("KeyChain Item query Error!!! Error code:%ld", queryErr);
//            throw CommonUtilError.KeychanGetError;
        }
        return udidValue;
    }
    
    public func saveData(data: NSData, account: String, service:String, accessGroup: String) {
        let query : [NSString : AnyObject] = [
            kSecAttrLabel:"",
            kSecValueData:data,
        ];
        var writeErr: OSStatus = noErr;
        writeErr = SecItemAdd(query, nil);
        if writeErr != errSecSuccess {
            print("Add KeyChain Item Error!!! Error Code:%ld", writeErr);
//            throw CommonUtilError.KeychanSaveError;
        }
    }
    
    public func deleteDataWithAccount(account: String, service: String, accessGroup: String) throws {
        let dictForDelete: [NSString : AnyObject] = self.getBaseKeychainQueryWithAccount(account, service: service, accessGroup: accessGroup);
        var deleteErr: OSStatus = noErr;
        
        deleteErr = SecItemDelete(dictForDelete);

        if(deleteErr != errSecSuccess){
            throw CommonUtilError.KeychanDeleteError;
        }
    }
    
    public func updateData(data: NSData, account:String, service:String, accessGroup:String) throws {
        var dictForQuery: [NSString : AnyObject] = self.getBaseKeychainQueryWithAccount(account, service: service, accessGroup: accessGroup);
        
        dictForQuery[kSecMatchCaseInsensitive] = kCFBooleanTrue;
        dictForQuery[kSecMatchLimit] = kSecMatchLimitOne;
        dictForQuery[kSecReturnData] = kCFBooleanTrue;
        dictForQuery[kSecReturnAttributes] = kCFBooleanTrue;
        
        var queryResultRef: AnyObject?;
        
        SecItemCopyMatching(dictForQuery, &queryResultRef);
        
        if queryResultRef != nil {
            
            var dictForUpdate: [NSString : AnyObject] = self.getBaseKeychainQueryWithAccount(account, service: service, accessGroup: accessGroup)
            dictForUpdate[kSecValueData] = data;
            var updateErr: OSStatus = noErr;
            
            // First we need the attributes from the Keychain.
            updateErr = SecItemUpdate(dictForQuery, dictForUpdate);
            if (updateErr != errSecSuccess) {
                print("Update KeyChain Item Error!!! Error Code:%ld", updateErr);
                throw CommonUtilError.KeychanUpdateError;
            }
        }
    }
}

public let SharedKeychanUtil: KeychanUtil = KeychanUtil.sharedInstance;