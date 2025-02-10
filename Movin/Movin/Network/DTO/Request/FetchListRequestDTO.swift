//
//  FetchListRequestDTO.swift
//  Movin
//
//  Created by 조성민 on 2/11/25.
//


struct FetchListRequestDTO: Encodable {
    enum QueryType: String {
        case itemNewAll 
        case itemNewSpecial
        case itemEditorChoice
        case bestseller
        case blogBest
    }
    
    let queryType: String
    let ttbKey: String = Environment.token.value
    let searchTarget: String = "Book"
    let start: Int
    let maxResults: Int
    let cover: String = "Mini"
    let output: String = "JS"
    let version: String = "20131101"
    
    init(
        queryType: QueryType,
        start: Int,
        maxResults: Int
    ) {
        self.queryType = queryType.rawValue
        self.start = start
        self.maxResults = maxResults
    }
}
