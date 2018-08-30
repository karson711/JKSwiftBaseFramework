//
//  JKTabBarView.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/2.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

@objc protocol JKTabBarViewDelegate {
    @objc optional func tabBar(_ tabBar: JKTabBarView, didClickedButtonAtIndex index: NSInteger)
}

class JKTabBarView: UIView {

    var delegate: JKTabBarViewDelegate?
    private var buttons: NSMutableArray!
    private var selectedButton: UIButton?
    
    private lazy var centerButton: JKTabBarButton = {
       let btn = JKTabBarButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "icon_menu_add"), for: UIControlState.normal)
        btn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        return btn
    }()
    
    var tabBarItems: NSArray! {
        didSet {
            buttons = NSMutableArray.init()
            
            // 遍历模型数组，创建对应tabBarButton
            for i in 0..<tabBarItems.count {
                let btn: JKTabBarButton = JKTabBarButton(type: UIButtonType.custom)
                // 给按钮赋值模型，按钮的内容由模型对应决定
                btn.item = tabBarItems[i] as! UITabBarItem
                // 设置按钮标记
                if i > 1 {
                    btn.tag = i + 1
                }
                else {
                    btn.tag = i
                }
                // 为按钮添加事件
                btn.addTarget(self, action: #selector(btnClicked(_:)), for: UIControlEvents.touchUpInside)
                // 初始选中第0个tabBar
                if i == 0 {
                    btnClicked(btn)
                }
                self.addSubview(btn)
                // 把按钮添加到按钮数组
                self.buttons.add(btn)
                
                // 单独设置中间的按钮
                if i == 1 {
                    self.addSubview(centerButton)
                    self.centerButton.tag = i + 1
                    self.centerButton.addTarget(self, action: #selector(btnClicked(_:)), for: UIControlEvents.touchUpInside)
                    self.bringSubview(toFront: btn)
                    self.buttons .add(self.centerButton)
                }
            }
        }
    }
    
    @objc func btnClicked(_ button: JKTabBarButton) {
        if button.tag != 2 {
            selectedButton?.isSelected = false  // 前一个button
            button.isSelected = true
            selectedButton = button     // 使当前button变成前一个button
        }
        
        // 响应代理
        delegate?.tabBar!(self, didClickedButtonAtIndex: button.tag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w: CGFloat = self.bounds.size.width
        let h: CGFloat = kTabBarHeight
        
        var btnX: CGFloat = 0
        let btnY: CGFloat = 0
        let btnW = w / CGFloat(self.buttons.count)
        let btnH = isIphoneX() ? (h-kIPhoneXMargin) : h
        
        // 修改系统tabBar上面的按钮的位置
        for i in 0..<self.buttons.count {
            if i == 2 {
                let centerBtn: JKTabBarButton = self.buttons[i] as! JKTabBarButton
                btnX = CGFloat(i) * btnW
                centerBtn.isShowTitle = false
                centerBtn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            }
            else {
                let tabBarButton = self.buttons[i] as! JKTabBarButton
                btnX = CGFloat(i) * btnW
                tabBarButton.isShowTitle = true
                tabBarButton.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            }
        }
    }
}
