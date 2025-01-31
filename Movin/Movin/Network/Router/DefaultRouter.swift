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
    case fetchTodayMovie
    case fetchMovieImages(movieID: Int)
}

extension DefaultRouter: Router {
    var baseURL: String {
        return Environment.baseURL.value
    }
    
    var path: String {
        switch self {
        case .search:
            return "/3/search/movie"
        case .fetchTodayMovie:
            return "/3/trending/movie/day"
        case .fetchMovieImages(let movieID):
            return "/3/movie/\(movieID)/images"
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
        case .fetchTodayMovie:
            return [
                "language" : "ko-KR",
                "page": 1
            ]
        case .fetchMovieImages:
            return [:]
        }
    }
    
    var encoding: (any ParameterEncoding)? {
        switch self {
        case .search, .fetchTodayMovie:
            return URLEncoding.default
        case .fetchMovieImages:
            return nil
        }
    }
}
