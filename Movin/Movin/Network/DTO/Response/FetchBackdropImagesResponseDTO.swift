//
//  FetchBackdropImagesResponseDTO.swift
//  Movin
//
//  Created by 조성민 on 1/31/25.
//

struct FetchBackdropImagesResponseDTO: Decodable {
    let backdrops: [BackdropImageDTO]
}

struct BackdropImageDTO: Decodable {
    let file_path: String
}
