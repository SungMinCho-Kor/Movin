//
//  APIService.swift
//  Movin
//
//  Created by 조성민 on 1/27/25.
//

import Foundation
import Alamofire

final class APIService {
    static let shared = APIService()
    
    private init() { }
    
    func request<T: Router, U: Decodable>(
        api: T,
        completion: @escaping (Result<U, NetworkError>) -> Void
    ) {
        AF.request(api)
            .validate()
            .responseDecodable(of: U.self) { [weak self] response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    dump(error)
                    let customError = self?.handleWrongStatusCode(response.response?.statusCode) ?? .deinitialized
                    dump(customError.alert)
                    completion(.failure(customError))
                }
            }
    }
    
    private func handleWrongStatusCode(_ code: Int?) -> NetworkError {
        guard let code else {
            return .alamofireError
        }
        switch code {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 422:
            return .invalidParameters
        case 500...504:
            return .internalError
        case 429:
            return .rateLimit
        default:
            return .unknown
        }
    }
}
