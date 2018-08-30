//
//  JKAppManager.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/8.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

class JKAppManager: NSObject {
    
    // 创建单例
    static let sharedInstance = JKAppManager()
    // 设置初始化方法为私有，防止报错
    private override init() {
        
    }
    
    // 选择根控制器
    func chooseRootVC(window: UIWindow) {
        window.rootViewController = JKTabBarController()
    }
    
    // APP初始化
    func initAppWithApplication(application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
    }
    
    // 跳转到主页
    func jumpToMainVC(window: UIWindow) {
        window.rootViewController = JKTabBarController()
    }
    
    // 跳转到登录
    func jumpToLoginVC(window: UIWindow) {
        window.rootViewController = JKLoginViewController()
    }
}
