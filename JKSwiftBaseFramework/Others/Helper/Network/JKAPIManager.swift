//
//  JKAPIManager.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/7/26.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import Foundation
import Moya

enum JKAPIManager {
    case login(account:String, password:String)      // 登录
    case logout                                      // 退出
}

extension JKAPIManager: TargetType {
    /// 请求根URL
    var baseURL: URL {
        return URL.init(string: uBaseURL)!
    }
    
    /// 请求URL路径
    var path: String {
        switch self {
        case .login(_, _):      // 带参数的请求
            return uUserLogin
        case .logout:    // 不带参数的请求
            return uUserLogout
        }
    }
    
    /// 请求方式
    var method: Moya.Method {
        switch self {
        case .login(_, _):
            return .post
        case .logout:
            return .get
        }
    }
    
    /// 任务
    var task: Task {
        var params: [String: Any] = [:]
        
        switch self {
        case let .login(account, password):
            params["phone"] = account
            params["password"] = password
            // 如果我们将一个参数设为 nil，那么相当于将其从参数列表中删除，发送请求时是不会传递这个参数的
            
        default:
            // 不需要传参数的接口走这里
            return .requestPlain
        }
        
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    /// 请求头信息
    var headers: [String: String]? {
        return nil
    }
    
    /// 单元测试模拟的数据，只会在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType {
        return .none
    }
}
