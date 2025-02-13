//
//  FetchTodayMovieResponseDTO.swift
//  Movin
//
//  Created by 조성민 on 1/31/25.
//

struct FetchTodayMovieResponseDTO: Decodable {
    let results: [TodayMovie]
}

struct TodayMovie: Decodable {
    let id: Int
    let release_date: String?
    let poster_path: String?
    let overview: String
    let title: String
    let genre_ids: [Int]?
    let vote_average: Double?
}
