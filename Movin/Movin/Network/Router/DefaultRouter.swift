//
//  DefaultRouter.swift
//  Movin
//
//  Created by 조성민 on 1/27/25.
//

import Alamofire
import Foundation

enum DefaultRouter {
    case search(dto: SearchRequestDTO)
}

extension DefaultRouter: Router {
    var baseURL: String {
        return Environment.baseURL.value
    }
    
    var path: String {
        switch self {
        case .search:
            return "/3/search/movie"
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
                "Content-Type": "application/json",
                "Authorization": "Bearer \(Environment.accessToken.value)"
            ]
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .search(let dto):
            return dto.asDictionary()
        default:
            return [:]
        }
    }
    
    var encoding: (any ParameterEncoding)? {
        switch self {
        case .search:
            return URLEncoding.default
        default:
            return nil
        }
    }
    
}
