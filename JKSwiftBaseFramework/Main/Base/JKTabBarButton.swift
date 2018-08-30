//
//  JKTabBarButton.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/2.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

class JKTabBarButton: UIButton {

    var badgeBtn: JKBadgeButton!
    var isShowTitle: Bool = false
    var item: UITabBarItem! {
        didSet {
            self.setImage(item.image, for: UIControlState.normal)
            self.setImage(item.selectedImage, for: UIControlState.selected)
            self.setTitle(item.title, for: UIControlState.normal)
            self.badgeBtn.badgeValue = item.badgeValue as NSString?
            
            // 利用KVO监听对象的属性值变化
            item.addObserver(self, forKeyPath: "badgeValue", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "selectedImage", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    override func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
        self.badgeBtn.badgeValue = item.badgeValue as NSString?
        self.setImage(item.image, for: UIControlState.normal)
        self.setImage(item.selectedImage, for: UIControlState.selected)
        self.setTitle(item.title, for: UIControlState.normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        badgeBtn = JKBadgeButton(type: UIButtonType.custom)
        self.addSubview(badgeBtn)
        
        self.setTitleColor(UIColor.colorWithHexString(colorString: cDarkGrayColor), for: UIControlState.normal)
        self.setTitleColor(UIColor.colorWithHexString(colorString: cCoffeeColor), for: UIControlState.selected)
        // 图片居中
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        // 文字居中
        self.titleLabel?.textAlignment = NSTextAlignment.center
        // 文字字体
        self.titleLabel?.font = UIFont.systemFont(ofSize: 11)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShowTitle {
            // imageView
            var objectX: CGFloat = 0.0
            var objectY: CGFloat = 5.0
            var objectW: CGFloat = self.bounds.size.width
            var objectH: CGFloat = self.bounds.size.height / 2.0 - 4.0
            self.imageView?.frame = CGRect(x: objectX, y: objectY, width: objectW, height: objectH)
            // title
            objectX = 0.0
            objectY = objectH + objectY
            objectW = self.bounds.size.width
            objectH = self.bounds.size.height - objectY
            self.titleLabel?.frame = CGRect(x: objectX, y: objectY, width: objectW, height: objectH)
        }
        else {
            // imageView
            let objectX: CGFloat = 0.0
            let objectY: CGFloat = 5.0
            let objectW: CGFloat = self.bounds.size.width
            let objectH: CGFloat = self.bounds.size.height - 10
            self.imageView?.frame = CGRect(x: objectX, y: objectY, width: objectW, height: objectH)
            // title
            self.titleLabel?.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        // badgeView
        let objectX: CGFloat = self.width - self.badgeBtn.width - 10.0
        let objectY: CGFloat = 0.0
        let objectW: CGFloat = 22.0
        self.badgeBtn.frame = CGRect(x: objectX, y: objectY, width: objectW, height: objectW)
    }
    
    // 取消高亮状态
    override var isHighlighted: Bool {
        set{
            
        }
        get {
            return false
        }
    }
    
    deinit {
        item.removeObserver(self, forKeyPath: "badgeValue")
        item.removeObserver(self, forKeyPath: "image")
        item.removeObserver(self, forKeyPath: "selectedImage")
        item.removeObserver(self, forKeyPath: "title")
    }
}
