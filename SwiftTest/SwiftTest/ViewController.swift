//
//  ViewController.swift
//  SwiftTest
//
//  Created by lijunjie on 15/11/12.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import UIKit
import CommonUtil

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(try! SharedDeviceInfoUtil.getUDIDWithKeyChainUDIDAccessGroup(SharedDeviceInfoUtil.kCUDefaultKeychainAccessGroup));
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

