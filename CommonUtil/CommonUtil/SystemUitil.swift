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

public class SystemUtil {
    
    class func share() -> SystemUtil {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: SystemUtil? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SystemUtil()
        }
        return Static.instance!
    }
    
    /**
     获取App的版本号 Float 行
     
     - returns: 返回Float型的   App版本号
     */
    public func appFloatVersion() -> Float {
        let infoDict = NSBundle.mainBundle().infoDictionary
        return Float(infoDict!["CFBundleShortVersionString"] as! String)!
    }
    
    
    public func appStringVersion() -> String {
        let infoDict = NSBundle.mainBundle().infoDictionary
        return  infoDict!["CFBundleShortVersionString"] as! String
    }
    
    public func appBundleStringVersion() -> String {
        let infoDict = NSBundle.mainBundle().infoDictionary
        return infoDict!["CFBundleVersion"] as! String;
    }
    
    public func appBundleIntVersion() -> Int {
        let infoDict = NSBundle.mainBundle().infoDictionary
        return Int(infoDict!["CFBundleVersion"] as! String)!
    }
    
    public func appBundleIdentifier() -> String {
        return NSBundle.mainBundle().bundleIdentifier!
    }
    
    public func isSystemVersionOver(versionValue:Float) -> Bool {
        return self.currentSystemFloatVersion() >= versionValue
    }
    
    public func screenBounds() -> CGRect {
        return UIScreen.mainScreen().bounds
    }
    
    public func currentSystemFloatVersion() -> Float {
        return Float(UIDevice.currentDevice().systemVersion)!
    }
    
    public func currentSystemStringVersion() -> String {
        return UIDevice.currentDevice().systemVersion
    }
    
    public func currentSystemName() -> String {
        return UIDevice.currentDevice().systemName
    }
    
    public func currentScreenScale() -> CGFloat {
        return UIScreen.mainScreen().scale
    }
    
    public func iPadDevice() -> Bool {
        return (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
    }
    
    public func iPhone4Device() -> Bool {
        return CGSizeEqualToSize(CGSizeMake(320, 480), self.deviceScreenSize())
    }
    
    public func iPhone5Device() -> Bool {
        return CGSizeEqualToSize(CGSizeMake(320, 568), self.deviceScreenSize())
    }
    
    public func iPhone6Device() -> Bool {
        return CGSizeEqualToSize(CGSizeMake(375, 667), self.deviceScreenSize())
    }
    
    public func iPhone6PlusDevice() -> Bool {
        return CGSizeEqualToSize(CGSizeMake(414, 736), self.deviceScreenSize())
    }
    
    public func deviceScreenSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    public func deviceScreenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    public func deviceScreenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
    
    public func naivationBarHeight() -> CGFloat {
        return CGFloat(44.0)
    }
    
    public func defaultCenter() -> NSNotificationCenter {
        return NSNotificationCenter.defaultCenter()
    }
    
    public func postNoti(notiName: String) {
        self.postNoti(notiName, withObject: nil)
    }
    
    public func postNoti(notiName: String, withObject: String?) {
        self.postNoti(notiName, withObject: withObject, infoDict: nil)
    }
    
    public func postNoti(notiName: String, withObject: String?, infoDict: Dictionary<NSObject , AnyObject>?) {
        self.defaultCenter().postNotificationName(notiName, object: withObject, userInfo: infoDict)
    }
    
    public func mainBundlePath(fileName: String) -> String? {
        let fileArray:Array = fileName.componentsSeparatedByString(".")
        if fileArray.count < 2 {
            return nil
        }
        return NSBundle.mainBundle().pathForResource(fileArray[0], ofType: fileArray[1])
    }
    
    public func bundle(bundle: String, file: String) -> String? {
        let s:NSString = bundle
        return s.stringByAppendingPathComponent(file)
    }
    
    public func showNetworkIndicatorActivity(state: Bool) {
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
    
    public func cameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    public func frontCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)
    }
    
    public func cameraFlashAvailable() -> Bool {
        return UIImagePickerController.isFlashAvailableForCameraDevice(UIImagePickerControllerCameraDevice.Rear)
    }
    
    public func canSendSMS() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(fileURLWithPath:"sms://"))
    }
    
    public func canMakePhoneCall() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(fileURLWithPath:"tel://"))
    }
    
    public func networkAvailable() -> Bool {
        let status:Reachability.NetworkStatus = try! Reachability.reachabilityForInternetConnection().currentReachabilityStatus
        if status == Reachability.NetworkStatus.NotReachable {
            return false
        } else {
            return true
        }
    }
    
    public func isAppCameraAccessAuthorized() -> Bool {
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
    
    public func isAppPhotoLibraryAccessAuthorized() -> Bool {
        let authStatus: ALAuthorizationStatus = ALAssetsLibrary.authorizationStatus()
        if authStatus != ALAuthorizationStatus.Authorized {
            return authStatus == ALAuthorizationStatus.NotDetermined;
        }else{
            return true;
        }
    }
    
    public func getSelfViewFrameOrangeY() -> Double {
        var orangeY: Double = 0.0
        let version: Float = Float(UIDevice.currentDevice().systemVersion)!
        
        if version >= 7.0 && version < 7.1 {
            orangeY = 20 + 46
        }
        return orangeY
    }
    
    public func isSystemVersionIs7() -> Bool {
        var result: Bool = false
        let version: Float = Float(UIDevice.currentDevice().systemVersion)!
        if version >= 7.0 && version < 7.1 {
            result = true
        }
        return result
    }
}

public let SharedSystemUtil: SystemUtil = SystemUtil.share();

