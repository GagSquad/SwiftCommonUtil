//
//  SystemUitil.swift
//  CommonUtil
//
//  Created by lijunjie on 15/11/8.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import ReachabilitySwift

public class SystemUtils {
    
    /**
     获取App的版本号 Float 行
     
     - returns: 返回Float型的   App版本号
     */
    public static func appFloatVersion() -> Float {
        let infoDict = NSBundle.mainBundle().infoDictionary
        return Float(infoDict!["CFBundleShortVersionString"] as! String)!
    }
    
    
    public static func appStringVersion() -> String {
        let infoDict = NSBundle.mainBundle().infoDictionary
        return  infoDict!["CFBundleShortVersionString"] as! String
    }
    
    public static func appBundleStringVersion() -> String {
        let infoDict = NSBundle.mainBundle().infoDictionary
        return infoDict!["CFBundleVersion"] as! String;
    }
    
    public static func appBundleIntVersion() -> Int {
        let infoDict = NSBundle.mainBundle().infoDictionary
        return Int(infoDict!["CFBundleVersion"] as! String)!
    }
    
    public static func appBundleIdentifier() -> String {
        return NSBundle.mainBundle().bundleIdentifier!
    }
    
    public static func isSystemVersionOver(versionValue:Float) -> Bool {
        return self.currentSystemFloatVersion() >= versionValue
    }
    
    public static func screenBounds() -> CGRect {
        return UIScreen.mainScreen().bounds
    }
    
    public static func currentSystemFloatVersion() -> Float {
        return Float(UIDevice.currentDevice().systemVersion)!
    }
    
    public static func currentSystemStringVersion() -> String {
        return UIDevice.currentDevice().systemVersion
    }
    
    public static func currentSystemName() -> String {
        return UIDevice.currentDevice().systemName
    }
    
    public static func currentScreenScale() -> CGFloat {
        return UIScreen.mainScreen().scale
    }
    
    public static func iPadDevice() -> Bool {
        return (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
    }
    
    public static func iPhone4Device() -> Bool {
        return CGSizeEqualToSize(CGSizeMake(320, 480), self.deviceScreenSize())
    }
    
    public static func iPhone5Device() -> Bool {
        return CGSizeEqualToSize(CGSizeMake(320, 568), self.deviceScreenSize())
    }
    
    public static func iPhone6Device() -> Bool {
        return CGSizeEqualToSize(CGSizeMake(375, 667), self.deviceScreenSize())
    }
    
    public static func iPhone6PlusDevice() -> Bool {
        return CGSizeEqualToSize(CGSizeMake(414, 736), self.deviceScreenSize())
    }
    
    public static func deviceScreenSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    public static func naivationBarHeight() -> CGFloat {
        return CGFloat(44.0)
    }
    
    public static func defaultCenter() -> NSNotificationCenter {
        return NSNotificationCenter.defaultCenter()
    }
    
    public static func postNoti(notiName: String) {
        self.postNoti(notiName, withObject: nil)
    }
    
    public static func postNoti(notiName: String, withObject: String?) {
        self.postNoti(notiName, withObject: withObject, infoDict: nil)
    }
    
    public static func postNoti(notiName: String, withObject: String?, infoDict: Dictionary<NSObject , AnyObject>?) {
        self.defaultCenter().postNotificationName(notiName, object: withObject, userInfo: infoDict)
    }
    
    public static func mainBundlePath(fileName: String) -> String? {
        let fileArray:Array = fileName.componentsSeparatedByString(".")
        if fileArray.count < 2 {
            return nil
        }
        return NSBundle.mainBundle().pathForResource(fileArray[0], ofType: fileArray[1])
    }
    
    public static func bundle(bundle: String, file: String) -> String? {
        let s:NSString = bundle
        return s.stringByAppendingPathComponent(file)
    }
    
    public static func showNetworkIndicatorActivity(state: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = state
    }
//    
//    + (void)originObject:(id)originObject associateObject:(id)anObject byKey:(NSString *const)associateKey
//    {
//    if (CUCFCheckObjectNull(originObject) || CUCFCheckObjectNull(anObject)) {
//    return;
//    }
//    
//    objc_setAssociatedObject(originObject, &associateKey, anObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    
//    + (id)associateObjectFromOrigin:(id)originObject byKey:(NSString *const)associateKey
//    {
//    if (CUCFCheckObjectNull(originObject) || CUCFStringIsNull(associateKey)) {
//    return nil;
//    }
//    id associateObj = objc_getAssociatedObject(originObject, &associateKey);
//    return associateObj;
//    }
//    
//    + (void)associateRemoveFromOrigin:(id)originObject
//    {
//    if (CUCFCheckObjectNull(originObject)) {
//    return;
//    }
//    objc_removeAssociatedObjects(originObject);
//    }
//   
    
    public static func cameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    public static func frontCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)
    }
    
    public static func cameraFlashAvailable() -> Bool {
        return UIImagePickerController.isFlashAvailableForCameraDevice(UIImagePickerControllerCameraDevice.Rear)
    }
    
    public static func canSendSMS() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(fileURLWithPath:"sms://"))
    }
    
    public static func canMakePhoneCall() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(fileURLWithPath:"tel://"))
    }
    
    public static func networkAvailable() -> Bool {
        let status:Reachability.NetworkStatus = try! Reachability.reachabilityForInternetConnection().currentReachabilityStatus
        if status == Reachability.NetworkStatus.NotReachable {
            return false
        } else {
            return true
        }
    }
    
    public static func isAppCameraAccessAuthorized() -> Bool {
        if !self.isSystemVersionOver(7.0) {
            return true
        }
        let mediaType: String = AVMediaTypeVideo;
        
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(mediaType)
        if authStatus !=  AVAuthorizationStatus.Authorized {
            return authStatus == AVAuthorizationStatus.NotDetermined;
        } else {
            return true;
        }
    }
    
    public static func isAppPhotoLibraryAccessAuthorized() -> Bool {
        let authStatus: ALAuthorizationStatus = ALAssetsLibrary.authorizationStatus()
        if authStatus != ALAuthorizationStatus.Authorized {
            return authStatus == ALAuthorizationStatus.NotDetermined;
        }else{
            return true;
        }
    }
    
    public static func getSelfViewFrameOrangeY() -> Double {
        var orangeY: Double = 0.0
        let version: Float = Float(UIDevice.currentDevice().systemVersion)!
        
        if version >= 7.0 && version < 7.1 {
            orangeY = 20 + 46
        }
        return orangeY
    }
    
    public static func isSystemVersionIs7() -> Bool {
        var result: Bool = false
        let version: Float = Float(UIDevice.currentDevice().systemVersion)!
        if version >= 7.0 && version < 7.1 {
            result = true
        }
        return result
    }
}