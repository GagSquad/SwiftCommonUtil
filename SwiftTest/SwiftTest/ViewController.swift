//
//  ViewController.swift
//  SwiftTest
//
//  Created by lijunjie on 15/11/5.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import UIKit
import CommonUtil

class ViewController: UIViewController {

    @IBAction func btnAction(sender: AnyObject) {
        
        self.view.backgroundColor = UIColor.redColor()
        
        let vc: OtherViewController = OtherViewController()
        self.view.addSubview(vc.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swd = SwiftDemo()
        swd.display()
        let a: String = "aa"
        a.a()
        //
        //var addTest;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

public extension String {
    public func a () {
        print("aaa2")
    }
}

