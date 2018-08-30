//
//  JKBaseViewController.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/2.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

class JKBaseViewController: UIViewController {
    
    // 用户信息
    var userInfo: NSDictionary?
    // 字典信息
    var dictionaryInfo: NSDictionary?
    // 数组信息
    var arrayInfo: NSArray?
    // 字符串信息
    var stringInfo: NSString?
    // 整型信息
    var integerInfo: NSInteger?
    // 当前控制器名称
    var ctrlName: NSString?
    // 前一控制器名称
    var preCtrlName: NSString?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
    }
    
    public func getRandomNumber(_ from: UInt32, _ to: UInt32) -> UInt32 {
        return (from + (arc4random() % (to - from + 1)))
    }
    
    public func getRandomColor() -> UIColor {
        let r: UInt32 = arc4random_uniform(255)
        let g: UInt32 = arc4random_uniform(255)
        let b: UInt32 = arc4random_uniform(255)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
