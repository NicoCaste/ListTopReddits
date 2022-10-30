//
//  TokenResponse.swift
//  ListTopReddits
//
//  Created by nicolas castello on 30/10/2022.
//

import Foundation

struct TokenResponse: Codable {
    var accessToken: String?
    var tokenType: String?
    var exiperesIn: Int?
    var scope: String?
}
