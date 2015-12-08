//
//  ImageUtil.swift
//  CommonUtil
//
//  Created by lijunjie on 15/12/6.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import UIKit

public class ImageUtil {
    
    private static let share = ImageUtil()
    
    private init () {}
    
    public func imageForColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        CGContextFillRect(context, rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img
    }
}

public let SharedImageUtil: ImageUtil = ImageUtil.share
