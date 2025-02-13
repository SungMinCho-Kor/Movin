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
    case fetchCast(movieID: Int)
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
        case .fetchCast(let movieID):
            return "/3/movie/\(movieID)/credits"
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
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NzYwMzY5ODg2MmJhMzcwNjg2MjE0NzYwOTRlMTk3MSIsIm5iZiI6MTczNzk3NTA0Mi40NjIwMDAxLCJzdWIiOiI2Nzk3NjUwMmM3YjAxYjcyYzcyNDA3NTkiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.Xw0D-sczzmZc7UQThzT6HFheDmRfS2VVo0qU0r-ezsc"
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
        case .fetchCast:
            return [
                "language" : "ko-KR"
            ]
        }
    }
    
    var encoding: (any ParameterEncoding)? {
        switch self {
        case .search, .fetchTodayMovie, .fetchCast:
            return URLEncoding.default
        case .fetchMovieImages:
            return nil
        }
    }
}
