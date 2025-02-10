//
//  BookDTO.swift
//  Movin
//
//  Created by 조성민 on 2/11/25.
//

struct BookDTO: Decodable {
    let title: String
    let link: String //알라딘 구매 링크
    let author: String
    let pubDate: String // 출시일
    let description: String // 설명
    let isbn13: String
    let priceSales: Int // 할인가
    let priceStandard: Int // 정상가
    let cover: String // 이미지
    let categoryName: String // 카테고리
    let publisher: String // 출판사
}
