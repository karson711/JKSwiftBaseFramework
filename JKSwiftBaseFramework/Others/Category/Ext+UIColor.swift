//
//  Ext+UIColor.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/9.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

public extension UIColor {
    
    func imageWithColor() -> UIImage {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func colorWithHexString(colorString str: NSString) -> UIColor {
        return colorWithHexString(colorString: str, 1.0)
    }
    
    class func colorWithHexString(colorString str: NSString, _ alpha: CGFloat) -> UIColor {
        // 删除字符串中的空格
        var cString: NSString = str.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if cString.length < 6 {
            return UIColor.clear
        }
        
        // 如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        if cString.hasPrefix("0x") || cString.hasPrefix("0X") {
            cString = cString.substring(from: 2) as NSString
        }
        // 如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        if cString.hasPrefix("#") {
            cString = cString .substring(from: 1) as NSString
        }
        if cString.length != 6 {
            return UIColor.clear
        }
        
        var range: NSRange = NSRange(location: 0, length: 2)
        // r
        let rString = cString.substring(with: range)
        // g
        range.location = 2
        let gString = cString.substring(with: range)
        // b
        range.location = 4
        let bString = cString.substring(with: range)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
    }
    
    public func random(randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        let alpha = randomAlpha ? CGFloat.random() : 1.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }
}
