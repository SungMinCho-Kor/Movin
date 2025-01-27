//
//  NetworkError.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

enum NetworkError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case invalidParameters
    case internalError
    case rateLimit
    case alamofireError
    case deinitialized
    case unknown
    
    var alert: String {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다. "
        case .unauthorized:
            return "인증에 실패했습니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다."
        case .invalidParameters:
            return "잘못된 파라미터입니다."
        case .internalError:
            return "서버 내부 오류가 발생했습니다."
        case .rateLimit:
            return "요청 횟수를 초과했습니다."
        case .alamofireError:
            return "네트워크 요청 중 오류가 발생했습니다."
        case .deinitialized:
            return "객체가 해제되었습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
