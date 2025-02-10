//
//  Environment.swift
//  Movin
//
//  Created by 조성민 on 1/27/25.
//

import Foundation

enum Environment {
    case baseURL
    case imageBaseURL
    case accessToken
    case aladinBaseURL
    case token
    
    var value: String {
        switch self {
        case .baseURL:
            return Bundle.main.infoDictionary?["BASE_URL"] as! String
        case .imageBaseURL:
            return Bundle.main.infoDictionary?["IMAGE_BASE_URL"] as! String
        case .accessToken:
            return Bundle.main.infoDictionary?["ACCESS_TOKEN"] as! String
        case .aladinBaseURL:
            return Bundle.main.infoDictionary?["ALADIN_BASE_URL"] as! String
        case .token:
            return Bundle.main.infoDictionary?["TOKEN"] as! String
        }
    }
}
