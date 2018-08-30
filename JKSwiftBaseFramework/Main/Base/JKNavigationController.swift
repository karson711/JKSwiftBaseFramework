//
//  JKNavigationController.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/2.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

class JKNavigationController: UINavigationController,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
    var navLineView: UIView!
    lazy var blackList: NSMutableArray = {
        return NSMutableArray()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航栏背景色
        self.navigationBar.barTintColor = UIColor.white
        // 设置导航栏两侧文字颜色
//        self.navigationBar.tintColor = UIColor.black
        // 取消毛玻璃效果（设置为NO后会导致UISearchController点击后消失）
//        self.navigationBar.isTranslucent = false
        // 设置导航栏标题字体大小和颜色
//        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.backgroundColor: UIColor.black]
        
        
        let target = self.interactivePopGestureRecognizer?.delegate
        
        let handle: Selector = NSSelectorFromString("handleNavigationTransition:")
        
        let targetView: UIView = (self.interactivePopGestureRecognizer?.view)!
        
        let fullScreenGes: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: target, action: handle)
        fullScreenGes.delegate = self
        targetView.addGestureRecognizer(fullScreenGes)
        
        self.interactivePopGestureRecognizer?.isEnabled = false
        
        // 去掉navBar上的黑线
        self .removeBlackLine()
    }
    
    private func removeBlackLine() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
//        navLineView = getLineViewInNavigationBar(self.navLineView)
//        navLineView.isHidden = true
    }
    
    private func getLineViewInNavigationBar(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        
        for subView in view.subviews {
            let imageView: UIImageView? = getLineViewInNavigationBar(subView)
            if imageView != nil {
                return imageView
            }
        }
        
        return nil
    }
    
    @objc func leftBarButtonAction() {
        self.popViewController(animated: true)
    }
    
    
    // MARK: - UINavigationControllerDelegate
    
    /**
     *  重写这个方法目的：能够拦截所有push进来的控制器（当使用pushViewController的时候就会调用该方法）
     *
     *  @param viewController 即将push进来的控制器
     */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        if self.viewControllers.count > 0 {
            if #available(iOS 11, *) {
                let leftButton: UIButton = UIButton(type: UIButtonType.custom)
                leftButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
                leftButton.setImage(UIImage(named: "icon_back"), for: UIControlState.normal)
                leftButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                leftButton .addTarget(self, action: #selector(leftBarButtonAction), for: UIControlEvents.touchUpInside)
                leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
                leftButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 20)
                
                let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: leftButton)
                viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
            }
            else {
                let leftButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
                leftButton.setImage(UIImage(named: "icon_back"), for: UIControlState.normal)
                leftButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                leftButton .addTarget(self, action: #selector(leftBarButtonAction), for: UIControlEvents.touchUpInside)
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
            }
        }
    }
    
    
    // MARK: - UIGestureRecognizerDelegate
    
    //  防止导航控制器只有一个rootViewcontroller时触发手势
    private func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        // 根据具体控制器对象决定是否开启全屏右滑返回
        for viewController in self.blackList {
            if self.topViewController === viewController as! UIViewController {
                return false
            }
        }
        
        if self.value(forKey: "_isTransitioning") as! Bool {
            return false
        }
        
        // 解决右滑和UITableView左滑删除的冲突
        let translation: CGPoint = gestureRecognizer.translation(in: gestureRecognizer.view)
        if translation.x <= 0 {
            return false
        }
        
        return self.childViewControllers.count == 1 ? false: true
    }
    
    
    // MARK: - Public
    
    public func addFullScreenPopBlackListItem(_ viewController: UIViewController?) {
        if viewController != nil {
            self.blackList.add(viewController as Any)
        }
    }
    
    public func removeFromFullScreenPopBlackList(_ viewController: UIViewController?) {
        if viewController != nil {
            for vc in self.blackList {
                if vc as! UIViewController === viewController {
                    self.blackList.remove(vc)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
