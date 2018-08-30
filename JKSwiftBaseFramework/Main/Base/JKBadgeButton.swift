//
//  JKBadgeButton.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/2.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

class JKBadgeButton: UIButton {

    var badgeValue: NSString? {
        didSet {
            if badgeValue != nil {
                if badgeValue?.length == 0 || (badgeValue?.isEqual(to: "0"))! {
                    self.isHidden = true
                }
                else {
                    self.isHidden = false
                }
                
                let size: CGSize = badgeValue!.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10)])
                if size.width > self.width-7 {      // 文字的尺寸大于控件的宽度
                    self.setImage(UIImage(named: "icon_new_dot"), for: UIControlState.normal)
                    self.setTitle(nil, for: UIControlState.normal)
                    self.setBackgroundImage(nil, for: UIControlState.normal)
                }
                else {
                    self.setImage(nil, for: UIControlState.normal)
                    self.setTitle(badgeValue as String?, for: UIControlState.normal)
                    self.setBackgroundImage(UIImage(named: "icon_main_badge"), for: UIControlState.normal)
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        
        // 设置字体大小
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.titleLabel?.textColor = UIColor.white
        
        self.sizeToFit()
    }
}
