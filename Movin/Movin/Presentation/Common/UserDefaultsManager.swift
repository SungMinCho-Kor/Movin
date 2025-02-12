//
//  UserDefaultsManager.swift
//  Movin
//
//  Created by 조성민 on 1/28/25.
//

import Foundation

final class UserDefaultsManager {
    private enum UserDefaultsKey: String, CaseIterable {
        case isOnboardingDone
        case nickname
        case profileImageIndex
        case profileImage
        case signUpDate
        case likeMovies
        case searchHistory
        case mbti
        case likeBooks
    }

    static let shared = UserDefaultsManager()
    
    @UserDefault(
        key: UserDefaultsKey.isOnboardingDone.rawValue,
        defaultValue: false
    )
    var isOnboardingDone: Bool
    @UserDefault(
        key: UserDefaultsKey.nickname.rawValue,
        defaultValue: ""
    )
    var nickname: String
    @UserDefault(
        key: UserDefaultsKey.profileImage.rawValue,
        defaultValue: nil
    )
    var profileImageIndex: Int?
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
    @UserDefault(
        key: UserDefaultsKey.mbti.rawValue,
        defaultValue: MBTI()
    )
    var mbti: MBTI
    @UserDefault(
        key: UserDefaultsKey.likeBooks.rawValue,
        defaultValue: []
    )
    var likeBooks: [Book]
    
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
    
    func toggleLikeBook(book: Book) {
        if let idx = likeBooks.firstIndex(where: { $0.isbn13 == book.isbn13 }) {
            likeBooks.remove(at: idx)
        } else {
            likeBooks.append(book)
        }
    }
    
    func resetUserData() {
        UserDefaultsKey.allCases.forEach { key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
}
