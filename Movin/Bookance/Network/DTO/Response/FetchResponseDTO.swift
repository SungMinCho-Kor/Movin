//
//  FetchResponseDTO.swift
//  Movin
//
//  Created by 조성민 on 2/10/25.
//

struct FetchResponseDTO: Decodable {
    let totalResults: Int
    let startIndex: Int
    let itemsPerPage: Int
    let item: [BookDTO]
}
