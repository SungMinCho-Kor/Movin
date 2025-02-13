//
//  FetchImagesResponseDTO.swift
//  Movin
//
//  Created by 조성민 on 1/31/25.
//

struct FetchImagesResponseDTO: Decodable {
    let backdrops: [MovieImage]
    let posters: [MovieImage]
}

struct MovieImage: Decodable {
    let file_path: String
}
