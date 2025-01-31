//
//  UserDefaultsManager.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import Foundation

enum UserDefaultsKey: String {
    case isOnboardingDone
    case nickname
    case profileImageIndex
    case signUpDate
    case likeMovies
    case searchHistory
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    @UserDefault(
        key: UserDefaultsKey.isOnboardingDone.rawValue,
        defaultValue: false
    )
    var isOnboardingDone: Bool
    @UserDefault(
        key: UserDefaultsKey.nickname.rawValue,
        defaultValue: nil
    )
    var nickname: String?
    @UserDefault(
        key: UserDefaultsKey.profileImageIndex.rawValue,
        defaultValue: Int.random(in: 0...11)
    )
    var profileImageIndex: Int
    @UserDefault(
        key: UserDefaultsKey.signUpDate.rawValue,
        defaultValue: Date()
    )
    var signUpDate: Date
    @UserDefault(
        key: UserDefaultsKey.likeMovies.rawValue,
        defaultValue: []
    )
    var likeMovies: [Int]
    @UserDefault(
        key: UserDefaultsKey.searchHistory.rawValue,
        defaultValue: []
    )
    var searchHistory: [String]
    
    private init() { }
    
    func appendSearchHistory(keyword: String) {
        removeSearchHistory(keyword: keyword)
        searchHistory.insert(
            keyword,
            at: 0
        )
    }
    
    func removeSearchHistory(keyword: String) {
        if let firstIndex = searchHistory.firstIndex(of: keyword) {
            searchHistory.remove(at: firstIndex)
        }
    }
    
    func removeSearchHistory(index: Int) {
        searchHistory.remove(at: index)
    }
    
    func toggleLikeMovie(movieID: Int) {
        if likeMovies.contains(movieID) {
            likeMovies.removeAll { $0 == movieID }
        } else {
            likeMovies.append(movieID)
        }
    }
}
