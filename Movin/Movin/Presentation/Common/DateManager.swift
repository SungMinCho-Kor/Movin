//
//  DateManager.swift
//  Movin
//
//  Created by 조성민 on 1/30/25.
//

import Foundation

final class DateManager {
    static let shared = DateManager()
    private init() { }
    private let dateFormatter = DateFormatter()
    
    func profileDateFormat(date: Date) -> String {
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    func searchDateFormat(dateString: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            print(#function, "worng format")
            return ""
        }
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.string(from: date)
    }
}
