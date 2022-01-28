//
//  Network.swift
//  ChargingTest
//
//  Created by Rzk on 2022/1/21.
//

import UIKit
import Moya
import Alamofire


let domain = "charging-battery.app"
let baseUrl = "https://\(domain)"

private let serverTrustPolicies: [String: ServerTrustPolicy] = [
    domain: .disableEvaluation
]

let configuration: URLSessionConfiguration = {
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    config.timeoutIntervalForRequest = 60
    config.timeoutIntervalForResource = 60
    config.requestCachePolicy = .useProtocolCachePolicy
    return config
}()

private let manger = Manager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
let NetworkAPIRequest = MoyaProvider<RequestApi>(manager: manger)


enum RequestApi {
    case tags(String, String, Bool)
}

extension RequestApi: TargetType {
    
    var baseURL: URL {
        switch self {
        case .tags(_, _, _):
            return URL(string: baseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .tags(_, _, _):
            return "/api/battery/tags"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .tags(_, _, _):
            return .post
        }
    }
    
    var task: Task {
        var param:[String:Any] = [:]
        
        switch self {
        case .tags(let locale, let appVersion, let random):
            param["locale"] = locale
            param["appVersion"] = appVersion
            param["random"] = random
//            return .requestParameters(parameters: param, encoding: URLEncoding.httpBody)
            return .requestCompositeParameters(bodyParameters: ["" : ""], bodyEncoding: URLEncoding.httpBody, urlParameters: param)
        }
        
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    var headers: [String : String]? {
        switch self {
        case .tags(_, _, _):
            return ["Content-Type" : "application/json", "token":"bq6WyxEvh2jbnu57ncPrrDwfhCfBfIlV"]
        }
    }
}



//private let serverTrustPolicies: [String: ServerTrustPolicy] = [
//    "charging-battery.app": .disableEvaluation,
//]
//
//let configuration: URLSessionConfiguration = {
//    let config = URLSessionConfiguration.default
//    config.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//    config.timeoutIntervalForRequest = 60
//    config.timeoutIntervalForResource = 60
//    config.requestCachePolicy = .useProtocolCachePolicy
//    return config
//}()
//
//private let manger = Manager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
//let NetworkAPIRequest = MoyaProvider<API>(manager: manger)
//
//public enum API {
//    case tags(String, String, Bool)
//}
//
//extension API: TargetType {
//
//    public var baseURL: URL { return NSURL(string: "https://charging-battery.app")! as URL }
//
//    public var path: String {
//        switch self {
//        case .tags(_, _, _):
//            return "/api/battery/tags"
//        }
//    }
//
//    public var method: Moya.Method {
//        switch self {
//        case .tags(_, _, _):
//            return .post
//        }
//    }
//
//    public var task: Task {
//        switch self {
//        case .tags(let locale, let appVersion, let random):
//            return .requestParameters(parameters: ["locale": locale, "appVersion": appVersion, "random": random], encoding: URLEncoding.default)
//        }
//    }
//
//    public var headers: [String: String]? {
//        return ["token" : "bq6WyxEvh2jbnu57ncPrrDwfhCfBfIlV",
//                "Content-Type" : "application/json"]
//    }
//
//    public var sampleData: Data {
//        return "".data(using: String.Encoding.utf8)!
//    }
//}

