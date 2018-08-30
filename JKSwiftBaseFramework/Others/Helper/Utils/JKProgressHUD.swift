//
//  JKProgressHUD.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/7/26.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

enum HUDType {
    case success
    case error
    case loading
    case info
    case progress
}

class JKProgressHUD: NSObject {
    
    class func initJKProgressHUD() {
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14.0))
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
    }
    
    class func showSuccess(_ status: String) {
        self.showJKProgressHUD(type: .success, status: status)
    }
    class func showError(_ status: String) {
        self.showJKProgressHUD(type: .error, status: status)
    }
    class func showLoading(_ status: String) {
        self.showJKProgressHUD(type: .loading, status: status)
    }
    class func showInfo(_ status: String) {
        self.showJKProgressHUD(type: .info, status: status)
    }
    class func showProgress(_ status: String, _ progress: CGFloat) {
        self.showJKProgressHUD(type: .success, status: status, progress: progress)
    }
    class func dismissHUD(_ delay: TimeInterval = 0) {
        SVProgressHUD.dismiss(withDelay: delay)
    }
}


extension JKProgressHUD {
    class func showJKProgressHUD(type: HUDType, status: String, progress: CGFloat = 0) {
        switch type {
        case .success:
            SVProgressHUD.showSuccess(withStatus: status)
        case .error:
            SVProgressHUD.showError(withStatus: status)
        case .loading:
            SVProgressHUD.show(withStatus: status)
        case .info:
            SVProgressHUD.showInfo(withStatus: status)
        case .progress:
            SVProgressHUD.showProgress(Float(progress), status: status)
        }
    }
}
