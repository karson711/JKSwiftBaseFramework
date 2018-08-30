//
//  JKHttpManager.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/9.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import Result
import SwiftyJSON
import ObjectMapper

/// Moya网络请求
public class JKHttpManager {
    /// 创建单例
    static let manager = JKHttpManager()
    private init() {}
    private let failInfo = "数据解析失败"
    
    /// 设置公共请求超时时间
    private func requestTimeoutClosure<T:TargetType>(target:T) -> MoyaProvider<T>.RequestClosure {
        let requestTimeoutClosure = { (endpoint:Endpoint, done: @escaping MoyaProvider<T>.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = 20 //设置请求超时时间
                done(.success(request))
            } catch {
                return
            }
        }
        return requestTimeoutClosure
    }
    
    /// 通过HTTPHeader设置公共请求参数
    private func endpointClosure<T:TargetType>(target:T) -> MoyaProvider<T>.EndpointClosure {
        let endpointClosure = { (target: JKAPIManager) -> Endpoint in
            let url: String = target.baseURL.absoluteString
            return Endpoint(url: url, sampleResponseClosure: { .networkResponse(200, target.sampleData) }, method: target.method, task: target.task, httpHeaderFields: target.headers).adding(newHTTPHeaderFields: ["x-platform" : "iOS"])
        }
        return endpointClosure as! (T) -> Endpoint
    }
    
    /// 请求JSON数据
    func requestJSONData<T:TargetType>(target:T, successClosure:@escaping (_ result:JSON) -> Void, failClosure: @escaping (_ errorMsg: String?) -> Void) {
        let requestProvider = MoyaProvider<T>(endpointClosure: endpointClosure(target: target), requestClosure: requestTimeoutClosure(target: target))
        let _ = requestProvider.request(target) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    // let statusCode = response.statusCode // 响应状态码：200, 401, 500...
                    // let data = response.data // 响应数据
                    let mapjson = try response.mapJSON()
                    let json = JSON(mapjson)
                    successClosure(json)
                } catch {
                    failClosure(self.failInfo)
                }
            case let .failure(error):
                switch error {
                case .imageMapping(let response):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print(response)
                case .jsonMapping(let response):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print(response)
                case .statusCode(let response):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print(response)
                case .stringMapping(let response):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print(response)
                case .underlying(let error, let response):
                    print(error)
                    print(response as Any)
                case .requestMapping:
                    print("错误原因：\(error.errorDescription ?? "")")
                case .objectMapping(let error, let response):
                    print(error)
                    print(response)
                case .encodableMapping(let response):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print(response)
                case .parameterEncoding(let response):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print(response)
                }
                failClosure(error.errorDescription)
            }
        }
    }
    
    /// 请求JSON数组对象数据
    func requestJSONArrayData<T:TargetType, M:Mappable>(target:T, model:M, successClosure:@escaping (_ result: [Mappable]?) -> Void, failClosure: @escaping (_ errorMsg: String?) -> Void) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        let _ = requestProvider.request(target) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    let json = try response.mapJSON()
                    let arr = Mapper<M>().mapArray(JSONObject:JSON(json).object)
                    successClosure(arr)
                } catch {
                    failClosure(self.failInfo)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
        }
    }
    
    /// 请求JSON对象数据
    func requestJSONObjectData<T:TargetType, M:Mappable>(target:T, model:M, successClosure:@escaping (_ result: Mappable?) -> Void, failClosure: @escaping (_ errorMsg: String?) -> Void) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        let _ = requestProvider.request(target) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    let json = try response.mapJSON()
                    let model = Mapper<M>().map(JSONObject:JSON(json).object)
                    successClosure(model)
                } catch {
                    failClosure(self.failInfo)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
        }
    }
    
    /// 请求String数据
    func requestStringData<T:TargetType>(target:T, successClosure:@escaping (_ result: String) -> Void, failClosure: @escaping (_ errorMsg: String?) -> Void) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        let _ = requestProvider.request(target) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    let str = try response.mapString()
                    successClosure(str)
                } catch {
                    failClosure(self.failInfo)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
            
        }
    }
    
    /// 下载文件 (Alamofire方式）
    func downloadFile(urlString:String!, saveName:String?, downloadProgress:@escaping Request.ProgressHandler, destinationURL: (_ destination: URL?) -> Void, completionHandler:@escaping (DownloadResponse<Data>) -> Void) {
        var destination: DownloadRequest.DownloadFileDestination
        
        let a = NSString(string:urlString)
        let s:CharacterSet = NSCharacterSet(charactersIn:"/") as CharacterSet
        let range = a.rangeOfCharacter(from: s, options: String.CompareOptions.backwards)
        let fileName = a.substring(with: NSMakeRange(range.location + 1, a.length - range.location - 1))
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let fileURL = documentsURL.appendingPathComponent(fileName)
//        if FileManager.default.fileExists(atPath: fileURL.absoluteString) {
//            print("yes")
//            destinationURL(fileURL)
//            return
//        }
        
        if saveName == nil {
//            destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            destination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(fileName)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
        }
        else {
            destination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(saveName!)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
        }
        
        Alamofire.download(urlString, to: destination)
            .downloadProgress { (progress) in
                downloadProgress(progress)
            }
            .responseData { (response) in
                completionHandler(response)
        }
    }
}
