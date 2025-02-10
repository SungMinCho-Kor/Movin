//
//  FetchSearchRequestDTO.swift
//  Movin
//
//  Created by 조성민 on 2/10/25.
//

struct FetchSearchRequestDTO: Encodable {
    enum RequestSoryType: Encodable {
        case accuracy
        case publishTime
        case title
        case salesPoint
        case customerRating
        case myReviewCount
    }
    
    let ttbKey: String = Environment.token.value
    let query: String
    let queryType: String = "Keyword"
    let searchTarget: String = "Book"
    let start: Int
    let maxResults: Int
    let sort: RequestSoryType
    let cover: String = "Mini"
    let output: String = "JS"
    let version: String = "20131101"
    
    init(
        query: String,
        start: Int,
        maxResults: Int,
        sort: RequestSoryType
    ) {
        self.query = query
        self.start = start
        self.maxResults = maxResults
        self.sort = sort
    }
}
