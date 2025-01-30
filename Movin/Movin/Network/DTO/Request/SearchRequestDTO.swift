//
//  SearchRequestDTO.swift
//  Movin
//
//  Created by 조성민 on 1/30/25.
//

struct SearchRequestDTO: Encodable {
    let query: String
    let include_adult: Bool = false
    let language: String = "ko-KR"
    let page: Int
}
