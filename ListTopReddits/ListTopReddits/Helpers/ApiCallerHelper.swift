//
//  ApiCallerHelper.swift
//  ListTopReddits
//
//  Created by nicolas castello on 30/10/2022.
//

import Foundation

class ApiCallerHelper {
    static private let baseUrl = "https://www.reddit.com/"
    static private let oAuthUrl = "https://oauth.reddit.com/"
    
    static func makeURLFromBasicUrl(path: String) -> String {
        baseUrl + path
    }
    
    static func makeUrlFromOAuth(path: String) -> String {
        oAuthUrl + path
    }
    
    static func getWebViewAuthUrl(with params: AuthParams) -> String {
        let user = params.user
        let redirectUri = params.redirectUri
        let responseType = params.responseType
        let state = params.state
        let duration = params.duration
        let scope = params.scope
        
        let path = "api/v1/authorize.compact?client_id=\(user)&response_type=\(responseType)&state=\(state)&redirect_uri=\(redirectUri)&duration=\(duration)&scope=\(scope)"
        
        return makeURLFromBasicUrl(path: path)
    }
}
