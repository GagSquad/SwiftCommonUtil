//
//  SwiftDemo.swift
//  CommonUtil
//
//  Created by lijunjie on 15/11/5.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation
public class SwiftDemo {
    public init () {
        print("SwiftDemo Init !")
        let a: String = "aaa"
        a.a()
    }
    
    public func display () {
        print("display")
    }
    
}

public extension String {
    public func a () {
        print("aaa2")
    }
}