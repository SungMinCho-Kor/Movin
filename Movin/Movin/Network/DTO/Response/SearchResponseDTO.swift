//
//  SearchResponseDTO.swift
//  Movin
//
//  Created by 조성민 on 1/30/25.
//

struct SearchResponseDTO: Decodable {
    let page: Int
    let total_pages: Int
    let results: [SearchResult]
}

struct SearchResult: Decodable {
    let id: Int
    let release_date: String
    let poster_path: String?
    let title: String
    let genre_ids: [Int]
}
