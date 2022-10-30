//
//  AuthParams.swift
//  ListTopReddits
//
//  Created by nicolas castello on 30/10/2022.
//

import Foundation

struct AuthParams: Codable {
    let user: String
    let redirectUri: String
    let responseType: String
    let state: String
    let duration: String
    let scope: String
}
