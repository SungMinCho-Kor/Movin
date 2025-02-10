//
//  AladinRouter.swift
//  Movin
//
//  Created by 조성민 on 2/10/25.
//

import Alamofire
import Foundation

enum AladinRouter {
    case fetchSearch(dto: FetchSearchRequestDTO)
    case fetchList(dto: FetchListRequestDTO)
}

extension AladinRouter: Router {
    var baseURL: String {
        return Environment.aladinBaseURL.value
    }
    
    var path: String {
        switch self {
        case .fetchSearch:
            return "/ItemSearch.aspx"
        case .fetchList:
            return "/ItemList.aspx"
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
        case .fetchSearch(let dto):
            return dto.asDictionary()
        case .fetchList(let dto):
            return dto.asDictionary()
        }
    }
    
    var encoding: (any ParameterEncoding)? {
        switch self {
        default:
            return URLEncoding.default
        }
    }
}
