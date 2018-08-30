//
//  AppMacro.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/8.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: - 系统相关 =================================================

public let kAppBundleInfoVersion = Bundle.main.infoDictionary ?? Dictionary()
public let kAppBundleVersion = (kAppBundleInfoVersion["CFBundleShortVersionString" as String] as? String ) ?? ""
public let kAppBundleBuild = (kAppBundleInfoVersion["CFBundleVersion"] as? String ) ?? ""
public let kAppDisplayName = (kAppBundleInfoVersion["CFBundleDisplayName"] as? String ) ?? ""

public let kiOSBase = 8.0
public let kOSGreaterOrEqualToiOS8 = ( (Double(UIDevice.current.systemVersion) ?? kiOSBase) > 8.0 ) ? true : false;
public let kOSGreaterOrEqualToiOS9 = ((Double(UIDevice.current.systemVersion) ?? kiOSBase) >= 9.0 ) ? true : false;
public let kOSGreaterOrEqualToiOS10 = ((Double(UIDevice.current.systemVersion) ?? kiOSBase) >= 10.0 ) ? true : false;
public let kOSGreaterOrEqualToiOS11 = ((Double(UIDevice.current.systemVersion) ?? kiOSBase) >= 11.0 ) ? true : false;

// 设备宽高、机型
public let kScreenHeight    = UIScreen.main.bounds.size.height
public let kScreenWidth     = UIScreen.main.bounds.size.width
public let kStatusBarheight = UIApplication.shared.statusBarFrame.size.height
public let kNavBarHeight_StatusHeight: ((UIViewController)-> CGFloat) = {(vc : UIViewController ) -> CGFloat in
    weak var weakVC = vc;
    var navHeight = weakVC?.navigationController?.navigationBar.bounds.size.height ?? 0.0
    return (navHeight + kStatusBarheight)
}

public func isIphoneX() -> Bool {
    if UIScreen.main.bounds.height == 812 {
        return true
    }
    return false
}
public let kNavigationHeight: CGFloat = (isIphoneX() ? 88 : 64)
public let kTabBarHeight: CGFloat = (isIphoneX() ? 83 : 49)
public let kIPhoneXMargin: CGFloat = 34

// 判断iPhone4
public let kIPHONE4_DEV:Bool! = (UIScreen.main.bounds.size.height == 480) ? true : false
// 判断iPhone5/5c/5s
public let kIPHONE5_DEV:Bool! = (UIScreen.main.bounds.size.height == 568) ? true : false
// 判断iPhone6/6s
public let kIPHONE6s_DEV:Bool! = (UIScreen.main.bounds.size.height == 667) ? true : false
// 判断iPhone6p
public let kIPHONE6p_DEV:Bool! = (UIScreen.main.bounds.size.height > 667) ? true : false
// 判断iPad
public let kIPAD_DEV:Bool! = (UIDevice.current.userInterfaceIdiom == .pad) ? true : false

public var isDebug: Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
}

public var isSimulator: Bool {
    #if targetEnvironment(simulator)
    return true
    #else
    return false
    #endif
}


// MARK: - 图片、颜色 =================================================

// 根据imageName创建一个UIImage
public let imageNamed:((String) -> UIImage? ) = { (imageName : String) -> UIImage? in
    return UIImage.init(named: imageName)
}

// 通过 十六进制与alpha来设置颜色值（ 样式：0xff00ff ）
public let HexRGBAlpha:((Int,Float) -> UIColor) = { (rgbValue : Int, alpha : Float) -> UIColor in
    return UIColor(red: CGFloat(CGFloat((rgbValue & 0xFF0000) >> 16)/255), green: CGFloat(CGFloat((rgbValue & 0xFF00) >> 8)/255), blue: CGFloat(CGFloat(rgbValue & 0xFF)/255), alpha: CGFloat(alpha))
}

// 通过 red 、 green 、blue 颜色数值
public let RGB:((Float,Float,Float) -> UIColor) = { (r: Float, g: Float , b: Float) -> UIColor in
    return UIColor.init(red: CGFloat(CGFloat(r)/255.0), green: CGFloat(CGFloat(g)/255.0), blue: CGFloat(CGFloat(b)/255.0), alpha: 1.0)
}

// 通过 red 、 green 、blue 、alpha 颜色数值
public let RGBAlpa:((Float,Float,Float,Float) -> UIColor) = { (r: Float, g: Float , b: Float , a: Float ) -> UIColor in
    return UIColor.init(red: CGFloat(CGFloat(r)/255.0), green: CGFloat(CGFloat(g)/255.0), blue: CGFloat(CGFloat(b)/255.0), alpha: CGFloat(a))
}


// MARK: - 自定义颜色 ===================================================

// 颜色
public let cNavigationBarBgColor: NSString   = "#ffffff"
public let cStatusBarBgColor: NSString       = "#ffffff"
public let cTabBarBgColor: NSString          = "#494949"
public let cBackgroundColor: NSString        = "#F5F5F5"
public let cGapLineColor: NSString           = "#E1E3E6"
public let cDarkGrayColor: NSString          = "#989898"
public let cLightGrayColor: NSString         = "#d8d8d8"
public let cCoffeeColor: NSString            = "#895327"  // "#5F3916"  // "#59371C"   // "#8b572a"
public let cDarkCoffee: NSString             = "#5e3b1e"
public let cLightCoffee: NSString            = "#baa796"
public let cThemeYellow: NSString            = "#fdd649"
public let cLineColor: NSString              = "#eeeeee"
public let cTextColor: NSString              = "#333333"
public let cOrangeColor: NSString            = "#fb9648"
public let cLightPink: NSString              = "#fae4d7"


// MARK: - 自定义宏 ===================================================

public let kPageCount: NSInteger = 15


// MARK: - 自定义通知

public let nRootVCRefresh = NSNotification.Name(rawValue:"RootVCRefresh")


// MARK: - 过滤 null ===================================================
///过滤null对象
public let kFilterNullOfObj:((Any)->Any?) = {(obj: Any) -> Any? in
    if obj is NSNull {
        return nil
    }
    return obj
}

///过滤null的字符串，当nil时返回一个初始化的空字符串
public let kFilterNullOfString:((Any)->String) = {(obj: Any) -> String in
    if obj is String {
        return obj as! String
    }
    return ""
}

/// 过滤null的数组，当nil时返回一个初始化的空数组
public let kFilterNullOfArray:((Any)->Array<Any>) = {(obj: Any) -> Array<Any> in
    if obj is Array<Any> {
        return obj as! Array<Any>
    }
    return Array()
}

/// 过滤null的字典，当为nil时返回一个初始化的字典
public let kFilterNullOfDictionary:((Any) -> Dictionary<AnyHashable, Any>) = {( obj: Any) -> Dictionary<AnyHashable, Any> in
    if obj is Dictionary<AnyHashable, Any> {
        return obj as! Dictionary<AnyHashable, Any>
    }
    return Dictionary()
}

