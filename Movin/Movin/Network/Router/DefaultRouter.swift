//
//  DefaultRouter.swift
//  Movin
//
//  Created by 조성민 on 1/27/25.
//

import Alamofire
import Foundation

enum DefaultRouter {
}

extension DefaultRouter: Router {
    var baseURL: String {
        return Environment.baseURL.value
    }
    
    var path: String {
        switch self {
        default: 
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var headers: [String : String] {
        switch self {
        default:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        default:
            return [:]
        }
    }
    
    var encoding: (any ParameterEncoding)? {
        switch self {
        default:
            return nil
        }
    }
    
}
