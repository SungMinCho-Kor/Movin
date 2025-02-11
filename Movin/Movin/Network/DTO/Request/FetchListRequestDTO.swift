//
//  FetchListRequestDTO.swift
//  Movin
//
//  Created by 조성민 on 2/11/25.
//

enum QueryType: Int, CaseIterable {
    case itemNewSpecial // 주목할 만한 신간
    case bestseller // 베스트셀러
    case blogBest // 블로그 베스트셀러
    case itemNewAll // 신간 전체
    
    var codingKey: String {
        switch self {
        case .itemNewSpecial:
            return "itemNewSpecial"
        case .bestseller:
            return "bestseller"
        case .blogBest:
            return "blogBest"
        case .itemNewAll:
            return "itemNewAll"
        }
    }
}

struct FetchListRequestDTO: Encodable {
    let queryType: String
    let ttbKey: String = Environment.token.value
    let searchTarget: String = "Book"
    let start: Int
    let maxResults: Int
    let cover: String = "MidBig"
    let output: String = "JS"
    let version: String = "20131101"
    
    init(
        queryType: QueryType,
        start: Int,
        maxResults: Int
    ) {
        self.queryType = queryType.codingKey
        self.start = start
        self.maxResults = maxResults
    }
}
