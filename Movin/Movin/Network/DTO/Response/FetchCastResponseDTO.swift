//
//  FetchCastResponseDTO.swift
//  Movin
//
//  Created by 조성민 on 2/1/25.
//

struct FetchCastResponseDTO: Decodable {
    let cast: [Cast]
}

struct Cast: Decodable {
    let name: String
    let profile_path: String?
    let character: String
}
