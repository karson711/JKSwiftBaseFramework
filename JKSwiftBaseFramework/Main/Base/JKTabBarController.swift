//
//  JKTabBarController.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/2.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit
import Foundation

class JKTabBarController: UITabBarController,JKTabBarViewDelegate {
    
    var isTabBarHide: Bool = false
    private var myTabBar: JKTabBar! {
        get {
            let myTab = JKTabBar(frame: self.tabBar.bounds)     // 注意frame与bounds的区别
            myTab.backgroundColor = UIColor.white
            myTab.tabBarView.delegate = self
            myTab.tabBarView.tabBarItems = self.tabBarCItems
            return myTab
        }
        set {
            
        }
    }
    private lazy var tabBarCItems: NSMutableArray = {
        return NSMutableArray()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置子控制器
        setUpAllChildViewController()
        // 自定义tabBar
        addCustTabBar()
    }
    
    // 修改tabbar高度
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = kTabBarHeight
        tabFrame.origin.y = self.view.frame.size.height - kTabBarHeight
        self.tabBar.frame = tabFrame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        removeTabBarButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        removeTabBarButton()
    }
    
    func removeTabBarButton() {
        // 隐藏系统的tabBar子视图（无需删除）
        for view in self.tabBar.subviews {
            if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                view.isHidden = true
            }
        }
    }
    
    func setUpAllChildViewController() {
        // 首页
        let home: JKHomeViewController = JKHomeViewController()
        setUpOneOfChildViewController(home, "icon_menu_home", "icon_menu_home_fill", "首页")
        // 生活
        let life: JKLifeViewController = JKLifeViewController()
        setUpOneOfChildViewController(life, "icon_menu_life", "icon_menu_life_fill", "生活")
        // 消息
        let msg: JKMessageViewController = JKMessageViewController()
        setUpOneOfChildViewController(msg, "icon_menu_circle", "icon_menu_circle_fill", "消息")
        // 我的
        let mine: JKMineViewController = JKMineViewController()
        setUpOneOfChildViewController(mine, "icon_menu_mine", "icon_menu_mine_fill", "我的")
    }
    
    func setUpOneOfChildViewController(_ vc: UIViewController, _ image: String, _ selectedImage: String, _ title: String) {
        // title属性会默认设置tabBarItem.title,如果设置了title，则tabBarItem.title会被覆盖
//        if vc.isKind(of: JKMineViewController.self) {
            vc.tabBarItem.title = title
//        }
//        else {
//            vc.title = title
//        }
        
        // 设置 tabbarItem 选中状态的图片(不被系统默认渲染,显示图像原始颜色)
        vc.tabBarItem.image = UIImage(named: image)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
//        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: UIControlState.normal)
//        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange], for: UIControlState.selected)
        
        // 保存tabBarItem模型到数组
        self.tabBarCItems.add(vc.tabBarItem)
        
        let nav: JKNavigationController = JKNavigationController(rootViewController: vc)
        self.addChildViewController(nav)
    }
    
    // 自定义tabBar
    func addCustTabBar() {
        // 去除tabBar上的黑线
        let originalTabBar = UITabBar.appearance()
        originalTabBar.shadowImage = UIImage()
        originalTabBar.backgroundImage = UIImage()
        
        // 添加自定义tabBar
        self.tabBar.addSubview(myTabBar)
        self.tabBar.isTranslucent = false
    }
    
    // 显示tabbar
    func showTabBar() {
        if isTabBarHide == true {
            var frame: CGRect = self.tabBar.frame
            frame.origin.y -= kTabBarHeight
            UIView.animate(withDuration: 0.5) {
                self.tabBar.frame = frame
            }
            
            isTabBarHide = false
        }
    }
    
    // 隐藏tabbar
    func hideTabBar() {
        if isTabBarHide == false {
            var frame  = self.tabBar.frame
            frame.origin.y += kTabBarHeight
            UIView.animate(withDuration: 0.5) {
                self.tabBar.frame = frame
            }
            
            isTabBarHide = true
        }
    }
    
    
    // MARK: - JKTabBarViewDelegate
    
    func tabBar(_ tabBar: JKTabBarView, didClickedButtonAtIndex index: NSInteger) {
        // 改变UITabBarController中当前显示的viewController
        if index < 2 {
            if self.selectedIndex == index {
                NotificationCenter.default.post(name: nRootVCRefresh, object: ["index": index])
            }
            self.selectedIndex = index
        }
        else if index == 2 {
            let pubVC: JKPublishViewController  = JKPublishViewController()
            let nav = JKNavigationController(rootViewController: pubVC)
            self.present(nav, animated: true, completion: nil)
        }
        else {
            if self.selectedIndex == index - 1 {
                NotificationCenter.default.post(name: nRootVCRefresh, object: ["index": index])
            }
            self.selectedIndex = index - 1
        }
    }

//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
