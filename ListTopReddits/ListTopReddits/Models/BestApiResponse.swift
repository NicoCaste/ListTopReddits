//
//  BestApiResponse.swift
//  ListTopReddits
//
//  Created by nicolas castello on 30/10/2022.
//

import Foundation

struct BestApiResponse: Codable {
    var kind: String?
    var data: BestApiDataResponse?
}

struct BestApiDataResponse: Codable {
    var modash: String?
    var children: [Children]?
    var before: String?
    var after: String?
    var geoFilter: String?
    var dist: Int?
}

struct Children: Codable  {
    var kind: String?
    var data: ChildrenData?
}

struct ChildrenData: Codable {
    var id: String?
    var author: String?
    var title: String?
    var thumbnail: String?
    var authorFullname: String?
    var url: String?
    var createdUtc: Int?
}
